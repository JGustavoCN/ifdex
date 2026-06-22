import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:ifdex/features/certificados/models/certificado.dart';

void main() {
  // ── Helpers ─────────────────────────────────────────────
  /// Retorna parâmetros-base válidos para origem manual.
  Map<String, dynamic> baseManual() => {
    'id': 'abc-123',
    'origem': Origem.manual,
    'titulo': 'Curso de Flutter',
    'ano': 2024,
    'instituicao': 'Udemy',
    'tipoDescricao': 'Curso',
    'tags': <String>['Flutter', 'Dart'],
    'notaRelevancia': 3,
  };

  /// Retorna parâmetros-base válidos para origem Sispubli.
  Map<String, dynamic> baseSispubli() => {
    'id': 'sha256-abc',
    'origem': Origem.sispubli,
    'titulo': 'Semana de Tecnologia',
    'ano': 2024,
    'instituicao': 'IFS',
    'tipoDescricao': 'Participação',
    'tags': <String>['Tech'],
    'notaRelevancia': 4,
  };

  /// Cria um [Certificado] a partir de um mapa de parâmetros.
  Certificado criar(Map<String, dynamic> p) => Certificado.criar(
    id: p['id'] as String,
    origem: p['origem'] as Origem,
    titulo: p['titulo'] as String,
    ano: p['ano'] as int,
    instituicao: p['instituicao'] as String,
    tipoDescricao: p['tipoDescricao'] as String,
    cargaHoraria: p['cargaHoraria'] as int?,
    urlDocumento: p['urlDocumento'] as String?,
    uploadDocumento: p['uploadDocumento'] as Uint8List?,
    tags: p['tags'] as List<String>,
    notaRelevancia: p['notaRelevancia'] as int,
  );

  // ═══════════════════════════════════════════════════════
  // A. Caminhos Felizes (Casos de Sucesso)
  // ═══════════════════════════════════════════════════════
  group('A. Caminhos Felizes', () {
    test('#1 Deve criar um certificado manual válido com URL', () {
      final p = baseManual()..['urlDocumento'] = 'https://udemy.com/cert/123';

      final cert = criar(p);

      expect(cert.id, 'abc-123');
      expect(cert.origem, Origem.manual);
      expect(cert.urlDocumento, 'https://udemy.com/cert/123');
      expect(cert.uploadDocumento, isNull);
    });

    test('#2 Deve criar um certificado manual válido com '
        'Upload (bytes)', () {
      final bytes = Uint8List.fromList([0, 1, 2]);
      final p = baseManual()..['uploadDocumento'] = bytes;

      final cert = criar(p);

      expect(cert.uploadDocumento, bytes);
      expect(cert.urlDocumento, isNull);
    });

    test('#3 Deve criar um certificado manual válido sem '
        'anexos', () {
      final cert = criar(baseManual());

      expect(cert.urlDocumento, isNull);
      expect(cert.uploadDocumento, isNull);
    });

    test('#4 Deve criar um certificado Sispubli válido', () {
      final p = baseSispubli()
        ..['urlDocumento'] = 'https://sispubli.ifs.edu.br/doc/1';

      final cert = criar(p);

      expect(cert.origem, Origem.sispubli);
      expect(cert.instituicao, 'IFS');
      expect(cert.cargaHoraria, isNull);
      expect(cert.uploadDocumento, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════
  // B. Exclusão Mútua (Anexos)
  // ═══════════════════════════════════════════════════════
  group('B. Exclusão Mútua', () {
    test('#5 Deve lançar erro ao fornecer URL e Upload '
        'simultaneamente', () {
      final p = baseManual()
        ..['urlDocumento'] = 'https://example.com/doc'
        ..['uploadDocumento'] = Uint8List.fromList([1, 2]);

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Forneça uma URL ou um Arquivo, '
                'não ambos.',
          ),
        ),
      );
    });
  });

  // ═══════════════════════════════════════════════════════
  // C. Restrição de Domínio (Limites Numéricos)
  // ═══════════════════════════════════════════════════════
  group('C. Restrição de Domínio', () {
    test('#6 Deve lançar erro se o ano for menor que 1900', () {
      final p = baseManual()..['ano'] = 1899;

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'O ano deve estar entre 1900 e 2026.',
          ),
        ),
      );
    });

    test('#7 Deve lançar erro se o ano for maior que 2026', () {
      final p = baseManual()..['ano'] = 2027;

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'O ano deve estar entre 1900 e 2026.',
          ),
        ),
      );
    });

    test('#8 Deve lançar erro se a carga horária for '
        'menor que 1', () {
      final p = baseManual()..['cargaHoraria'] = 0;

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'A carga horária deve estar entre '
                '1 e 5000.',
          ),
        ),
      );
    });

    test('#9 Deve lançar erro se a carga horária for '
        'maior que 5000', () {
      final p = baseManual()..['cargaHoraria'] = 5001;

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'A carga horária deve estar entre '
                '1 e 5000.',
          ),
        ),
      );
    });

    test('#10 Deve lançar erro se a nota de relevância '
        'for menor que 1', () {
      final p = baseManual()..['notaRelevancia'] = 0;

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'A nota de relevância deve ser '
                'entre 1 e 5.',
          ),
        ),
      );
    });

    test('#11 Deve lançar erro se a nota de relevância '
        'for maior que 5', () {
      final p = baseManual()..['notaRelevancia'] = 6;

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'A nota de relevância deve ser '
                'entre 1 e 5.',
          ),
        ),
      );
    });
  });

  // ═══════════════════════════════════════════════════════
  // D. Regras de Strings e Regras de Negócio
  // ═══════════════════════════════════════════════════════
  group('D. Regras de Strings e Negócio', () {
    test('#12 Deve lançar erro se o título for vazio '
        '(string vazia)', () {
      final p = baseManual()..['titulo'] = '';

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'O título é obrigatório e deve ter '
                'no máximo 100 caracteres.',
          ),
        ),
      );
    });

    test('#12b Deve lançar erro se o título for vazio '
        '(apenas espaços)', () {
      final p = baseManual()..['titulo'] = '   ';

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'O título é obrigatório e deve ter '
                'no máximo 100 caracteres.',
          ),
        ),
      );
    });

    test('#13 Deve lançar erro se o título ultrapassar '
        '100 caracteres', () {
      final p = baseManual()..['titulo'] = 'A' * 101;

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'O título é obrigatório e deve ter '
                'no máximo 100 caracteres.',
          ),
        ),
      );
    });

    test('#14 Deve lançar erro se a URL não for um '
        'formato válido', () {
      final p = baseManual()..['urlDocumento'] = 'wwwgooglecom';

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'A URL fornecida é inválida.',
          ),
        ),
      );
    });

    test('#14b Deve lançar erro para URL textual inválida', () {
      final p = baseManual()..['urlDocumento'] = 'link falso';

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'A URL fornecida é inválida.',
          ),
        ),
      );
    });

    test('#15 Deve lançar erro se ID, Instituição ou '
        'Tipo forem vazios', () {
      // ID vazio
      expect(
        () => criar(baseManual()..['id'] = ''),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'ID, Instituição e Tipo de Descrição '
                'não podem ser vazios.',
          ),
        ),
      );

      // Instituição vazia
      expect(
        () => criar(baseManual()..['instituicao'] = ''),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'ID, Instituição e Tipo de Descrição '
                'não podem ser vazios.',
          ),
        ),
      );

      // Tipo vazio
      expect(
        () => criar(baseManual()..['tipoDescricao'] = ''),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'ID, Instituição e Tipo de Descrição '
                'não podem ser vazios.',
          ),
        ),
      );
    });

    test('#16 Deve lançar erro se a Origem for Sispubli '
        'e a Instituição não for IFS', () {
      final p = baseSispubli()..['instituicao'] = 'Udemy';

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Certificados do Sispubli devem ter '
                'a instituição "IFS".',
          ),
        ),
      );
    });
  });

  // ═══════════════════════════════════════════════════════
  // E. Limites Exatos (Boundary Values)
  // ═══════════════════════════════════════════════════════
  group('E. Limites Exatos (Boundary Values)', () {
    test('#17 Deve aceitar o ano exato do limite inferior '
        'e superior', () {
      final certInf = criar(baseManual()..['ano'] = 1900);
      expect(certInf.ano, 1900);

      final certSup = criar(baseManual()..['ano'] = 2026);
      expect(certSup.ano, 2026);
    });

    test('#18 Deve aceitar a carga horária exata dos '
        'limites', () {
      final certMin = criar(baseManual()..['cargaHoraria'] = 1);
      expect(certMin.cargaHoraria, 1);

      final certMax = criar(baseManual()..['cargaHoraria'] = 5000);
      expect(certMax.cargaHoraria, 5000);
    });

    test('#19 Deve aceitar as notas de relevância exatas', () {
      final certMin = criar(baseManual()..['notaRelevancia'] = 1);
      expect(certMin.notaRelevancia, 1);

      final certMax = criar(baseManual()..['notaRelevancia'] = 5);
      expect(certMax.notaRelevancia, 5);
    });

    test('#20 Deve aceitar um título com exatamente '
        '100 caracteres', () {
      final titulo100 = 'A' * 100;
      final cert = criar(baseManual()..['titulo'] = titulo100);
      expect(cert.titulo.length, 100);
    });
  });

  // ═══════════════════════════════════════════════════════
  // F. Casos de Borda (Arrays e Nulls)
  // ═══════════════════════════════════════════════════════
  group('F. Casos de Borda (Arrays e Nulls)', () {
    test('#21 Deve criar um certificado com lista de '
        'tags vazia', () {
      final cert = criar(baseManual()..['tags'] = <String>[]);
      expect(cert.tags, isEmpty);
    });

    test('#22 Deve aceitar carga horária nula para '
        'origem manual', () {
      final p = baseManual()..['cargaHoraria'] = null;

      final cert = criar(p);
      expect(cert.cargaHoraria, isNull);
    });
  });

  // ═══════════════════════════════════════════════════════
  // G. Regras do Sispubli (Exceções)
  // ═══════════════════════════════════════════════════════
  group('G. Regras do Sispubli (Exceções)', () {
    test('#23 Deve aceitar Sispubli com carga horária '
        '(enriquecimento do usuário)', () {
      final p = baseSispubli()..['cargaHoraria'] = 40;

      final cert = criar(p);
      expect(cert.cargaHoraria, 40);
    });

    test('#24 Deve aceitar uploadDocumento para a Origem Sispubli '
        '(proxy download)', () {
      final bytes = Uint8List.fromList([1, 2, 3]);
      final p = baseSispubli()..['uploadDocumento'] = bytes;

      final cert = criar(p);
      expect(cert.uploadDocumento, bytes);
      expect(cert.origem, Origem.sispubli);
    });
  });

  // ═══════════════════════════════════════════════════════
  // H. Validação de Tags
  // ═══════════════════════════════════════════════════════
  group('H. Validação de Tags', () {
    test('#25 Deve lançar erro se houver mais de '
        '5 tags', () {
      final p = baseManual()..['tags'] = <String>['A', 'B', 'C', 'D', 'E', 'F'];

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'O máximo permitido é 5 tags.',
          ),
        ),
      );
    });

    test('#26 Deve aceitar exatamente 5 tags', () {
      final p = baseManual()..['tags'] = <String>['A', 'B', 'C', 'D', 'E'];

      final cert = criar(p);
      expect(cert.tags.length, 5);
    });

    test('#27 Deve lançar erro se uma tag exceder '
        '20 caracteres', () {
      final tagLonga = 'A' * 21;
      final p = baseManual()..['tags'] = <String>[tagLonga];

      expect(
        () => criar(p),
        throwsA(
          isA<ArgumentError>().having(
            (e) => e.message,
            'message',
            'Cada tag deve ter no máximo '
                '20 caracteres.',
          ),
        ),
      );
    });

    test('#28 Deve aceitar tag com exatamente '
        '20 caracteres', () {
      final tag20 = 'A' * 20;
      final p = baseManual()..['tags'] = <String>[tag20];

      final cert = criar(p);
      expect(cert.tags.first.length, 20);
    });
  });

  // ═══════════════════════════════════════════════════════
  // I. Serialização (Firestore)
  // ═══════════════════════════════════════════════════════
  group('I. Serialização (Firestore)', () {
    test(
      '#29 Deve serializar e desserializar corretamente (roundtrip) - Manual',
      () {
        final certOriginal = Certificado.criar(
          id: '123',
          origem: Origem.manual,
          titulo: 'Flutter Avançado',
          ano: 2023,
          instituicao: 'Udemy',
          tipoDescricao: 'Curso',
          cargaHoraria: 40,
          urlDocumento: 'https://udemy.com/cert/123',
          temArquivo: false,
          tags: ['Flutter', 'Dart'],
          notaRelevancia: 5,
        );

        final map = certOriginal.toMap();
        final certRecuperado = Certificado.fromMap(map, '123');

        expect(certRecuperado.id, certOriginal.id);
        expect(certRecuperado.origem, certOriginal.origem);
        expect(certRecuperado.titulo, certOriginal.titulo);
        expect(certRecuperado.ano, certOriginal.ano);
        expect(certRecuperado.instituicao, certOriginal.instituicao);
        expect(certRecuperado.tipoDescricao, certOriginal.tipoDescricao);
        expect(certRecuperado.cargaHoraria, certOriginal.cargaHoraria);
        expect(certRecuperado.urlDocumento, certOriginal.urlDocumento);
        expect(certRecuperado.temArquivo, certOriginal.temArquivo);
        expect(certRecuperado.tags, certOriginal.tags);
        expect(certRecuperado.notaRelevancia, certOriginal.notaRelevancia);
      },
    );

    test(
      '#30 Deve serializar e desserializar corretamente (roundtrip) - Sispubli',
      () {
        final certOriginal = Certificado.criar(
          id: 'sha256-abc',
          origem: Origem.sispubli,
          titulo: 'Semana de Tecnologia',
          ano: 2024,
          instituicao: 'IFS',
          tipoDescricao: 'Participação',
          temArquivo: true,
          tags: ['Tech'],
          notaRelevancia: 4,
        );

        final map = certOriginal.toMap();
        final certRecuperado = Certificado.fromMap(map, 'sha256-abc');

        expect(certRecuperado.id, certOriginal.id);
        expect(certRecuperado.origem, certOriginal.origem);
        expect(certRecuperado.titulo, certOriginal.titulo);
        expect(certRecuperado.ano, certOriginal.ano);
        expect(certRecuperado.instituicao, certOriginal.instituicao);
        expect(certRecuperado.tipoDescricao, certOriginal.tipoDescricao);
        expect(certRecuperado.cargaHoraria, isNull);
        expect(certRecuperado.urlDocumento, isNull);
        expect(certRecuperado.temArquivo, certOriginal.temArquivo);
        expect(certRecuperado.tags, certOriginal.tags);
        expect(certRecuperado.notaRelevancia, certOriginal.notaRelevancia);
      },
    );
  });
}
