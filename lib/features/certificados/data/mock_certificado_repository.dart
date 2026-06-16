import 'package:ifdex/features/certificados/models/certificado.dart';
import 'package:ifdex/features/certificados/data/certificado_repository.dart';
import 'package:ifdex/features/certificados/data/mock_certificados.dart';

class MockCertificadoRepository implements CertificadoRepository {
  final Duration delay;

  MockCertificadoRepository({this.delay = const Duration(milliseconds: 300)});

  // Inicializamos a lista localmente com os mocks existentes
  final List<Certificado> _certificados = List.from(certificadosMock);

  @override
  Future<List<Certificado>> listar() async {
    // Simulando delay de rede
    await Future<void>.delayed(delay);
    return List.unmodifiable(_certificados);
  }

  @override
  Future<void> adicionar(Certificado certificado) async {
    await Future<void>.delayed(delay);
    _certificados.add(certificado);
  }

  @override
  Future<void> atualizar(Certificado certificado) async {
    await Future<void>.delayed(delay);
    final index = _certificados.indexWhere((c) => c.id == certificado.id);
    if (index != -1) {
      _certificados[index] = certificado;
    }
  }

  @override
  Future<void> remover(String id) async {
    await Future<void>.delayed(delay);
    _certificados.removeWhere((c) => c.id == id);
  }
}
