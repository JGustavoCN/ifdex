import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ifdex/shared/constants/app_constants.dart';

import 'sispubli_exceptions.dart';

part 'sispubli_datasource.g.dart';

@riverpod
SispubliDatasource sispubliDatasource(SispubliDatasourceRef ref) {
  return SispubliDatasource(AppConstants.sispubliBaseUrl);
}

/// DTO que espelha exatamente o JSON retornado pela API.
///
/// Isola o datasource do modelo de domínio — se a API
/// mudar o formato, só o DTO e o parse mudam.
class SispubliCertificadoDto {
  final String idUnico;
  final String titulo;
  final String? urlDownload;
  final int ano;
  final int tipoCodigo;
  final String tipoDescricao;

  const SispubliCertificadoDto({
    required this.idUnico,
    required this.titulo,
    this.urlDownload,
    required this.ano,
    required this.tipoCodigo,
    required this.tipoDescricao,
  });

  factory SispubliCertificadoDto.fromJson(Map<String, dynamic> json) {
    return SispubliCertificadoDto(
      idUnico: json['id_unico'] as String,
      titulo: json['titulo'] as String,
      urlDownload: json['url_download'] as String?,
      ano: json['ano'] as int,
      tipoCodigo: json['tipo_codigo'] as int,
      tipoDescricao: json['tipo_descricao'] as String,
    );
  }
}

/// DataSource HTTP responsável pela comunicação com a
/// API do Sispubli utilizando o [Dio].
///
/// Possui 3 operações:
/// 1. [autenticar] — gera token Fernet (TTL 15min)
/// 2. [listarCertificados] — extrai metadados
/// 3. [baixarPdf] — streaming do binário via túnel
class SispubliDatasource {
  final String baseUrl;
  final Dio _dio;

  SispubliDatasource(this.baseUrl) : _dio = Dio();

  /// POST /api/auth/token
  ///
  /// Recebe um CPF (11 dígitos) e retorna o
  /// `access_token` Fernet.
  Future<String> autenticar(String cpf) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$baseUrl/api/auth/token',
        data: {'cpf': cpf},
      );
      final data = response.data!;
      return data['access_token'] as String;
    } on DioException catch (e) {
      _tratarErroGeral(e);
      _tratarErroAuth(e.response!);
      rethrow;
    }
  }

  /// GET /api/certificados [Bearer token]
  ///
  /// Retorna a lista de DTOs intermediários extraídos
  /// do sistema upstream.
  Future<List<SispubliCertificadoDto>> listarCertificados(String token) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '$baseUrl/api/certificados',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      final dataBody = response.data!;
      final dataObj = dataBody['data'] as Map<String, dynamic>;
      final lista = dataObj['certificados'] as List<dynamic>?;

      if (lista == null) return [];

      return lista
          .cast<Map<String, dynamic>>()
          .map(SispubliCertificadoDto.fromJson)
          .toList();
    } on DioException catch (e) {
      _tratarErroGeral(e);
      _tratarErroCertificados(e.response!);
      rethrow;
    }
  }

  /// GET /api/pdf/{ticket}
  ///
  /// Baixa os bytes crus do PDF via túnel seguro.
  /// O [urlDownload] já contém a URL completa.
  Future<Uint8List> baixarPdf(String urlDownload) async {
    try {
      final response = await _dio.get<List<int>>(
        urlDownload,
        options: Options(responseType: ResponseType.bytes),
      );

      return Uint8List.fromList(response.data!);
    } on DioException catch (e) {
      _tratarErroGeral(e);
      _tratarErroPdf(e.response!);
      rethrow;
    }
  }

  // ── Tratamento de erros por endpoint ─────────────

  /// Trata falhas onde o [Response] é nulo (ex: falhas de CORS, DNS,
  /// timeout de conexão local). Dispara um [SispubliIndisponivelException]
  /// para o ViewModel poder mostrar amigavelmente pro usuário.
  void _tratarErroGeral(DioException e) {
    if (e.response == null || e.type == DioExceptionType.connectionError) {
      throw const SispubliIndisponivelException();
    }
  }

  void _tratarErroAuth(Response<dynamic> response) {
    switch (response.statusCode) {
      case 200:
        return;
      case 400:
      case 422:
        throw const SispubliCpfInvalidoException();
      case 429:
        throw const SispubliRateLimitException();
      default:
        throw SispubliDesconhecidaException(
          'Erro ${response.statusCode}: ${response.data}',
        );
    }
  }

  void _tratarErroCertificados(Response<dynamic> response) {
    switch (response.statusCode) {
      case 200:
        return;
      case 400:
        throw const SispubliCpfInvalidoException();
      case 401:
        throw const SispubliNaoAutorizadoException();
      case 429:
        throw const SispubliRateLimitException();
      case 502:
        throw const SispubliIndisponivelException();
      default:
        throw SispubliDesconhecidaException(
          'Erro ${response.statusCode}: ${response.data}',
        );
    }
  }

  void _tratarErroPdf(Response<dynamic> response) {
    switch (response.statusCode) {
      case 200:
        return;
      case 400:
        throw const SispubliCpfInvalidoException();
      case 403:
        throw const SispubliNaoAutorizadoException();
      case 429:
        throw const SispubliRateLimitException();
      case 502:
        throw const SispubliIndisponivelException();
      case 504:
        throw const SispubliTimeoutException();
      default:
        throw SispubliDesconhecidaException(
          'Erro ${response.statusCode}: ${response.data}',
        );
    }
  }
}
