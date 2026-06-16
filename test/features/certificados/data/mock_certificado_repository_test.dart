import 'package:flutter_test/flutter_test.dart';
import 'package:ifdex/features/certificados/data/mock_certificado_repository.dart';
import 'package:ifdex/features/certificados/models/certificado.dart';

void main() {
  late MockCertificadoRepository repository;

  setUp(() {
    repository = MockCertificadoRepository(delay: Duration.zero);
  });

  test('Deve listar os certificados mocks iniciais', () async {
    final certificados = await repository.listar();
    expect(certificados, isNotEmpty);
    expect(certificados.length, greaterThan(0));
  });

  test('Deve adicionar um novo certificado', () async {
    final initialList = await repository.listar();
    final initialCount = initialList.length;

    final novoCertificado = Certificado.criar(
      id: 'mock_test_123',
      origem: Origem.manual,
      titulo: 'Certificado Teste',
      ano: 2024,
      instituicao: 'IFS',
      tipoDescricao: 'Participação',
      tags: <String>['Teste'],
      notaRelevancia: 5,
    );

    await repository.adicionar(novoCertificado);

    final updatedList = await repository.listar();
    expect(updatedList.length, equals(initialCount + 1));
    expect(updatedList.any((c) => c.id == 'mock_test_123'), isTrue);
  });

  test('Deve atualizar um certificado existente', () async {
    final certificados = await repository.listar();
    final alvo = certificados.first;

    final certificadoModificado = Certificado.criar(
      id: alvo.id,
      origem: alvo.origem,
      titulo: 'Título Atualizado Repository',
      ano: alvo.ano,
      instituicao: alvo.instituicao,
      tipoDescricao: alvo.tipoDescricao,
      tags: <String>[...alvo.tags],
      notaRelevancia: alvo.notaRelevancia,
      cargaHoraria: alvo.cargaHoraria,
      urlDocumento: alvo.urlDocumento,
      uploadDocumento: alvo.uploadDocumento,
    );

    await repository.atualizar(certificadoModificado);

    final updatedList = await repository.listar();
    final verificado = updatedList.firstWhere((c) => c.id == alvo.id);

    expect(verificado.titulo, equals('Título Atualizado Repository'));
  });

  test('Deve remover um certificado', () async {
    final initialList = await repository.listar();
    final initialCount = initialList.length;
    final alvo = initialList.first;

    await repository.remover(alvo.id);

    final updatedList = await repository.listar();
    expect(updatedList.length, equals(initialCount - 1));
    expect(updatedList.any((c) => c.id == alvo.id), isFalse);
  });
}
