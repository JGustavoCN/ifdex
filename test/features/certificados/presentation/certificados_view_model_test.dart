import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ifdex/features/certificados/data/certificado_repository.dart';
import 'package:ifdex/features/certificados/data/mock_certificado_repository.dart';
import 'package:ifdex/features/certificados/presentation/certificados_view_model.dart';
import 'package:ifdex/features/certificados/models/certificado.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        // Sobrescrevemos o repository se quiséssemos um mock puro com Mockito,
        // mas usar o MockCertificadoRepository já funciona para os testes em memória.
        certificadoRepositoryProvider.overrideWithValue(
          MockCertificadoRepository(delay: Duration.zero),
        ),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('Deve carregar a lista de certificados no estado inicial', () async {
    // Escuta para forçar o provider a construir
    final subscription = container.listen(
      certificadosViewModelProvider,
      (_, _) {},
    );

    // Aguarda o build concluir
    final state = await container.read(certificadosViewModelProvider.future);

    expect(state, isNotEmpty);
    subscription.close();
  });

  test(
    'Deve adicionar certificado atualizando o repository e o estado local mutável',
    () async {
      final subscription = container.listen(
        certificadosViewModelProvider,
        (_, _) {},
      );
      await container.read(
        certificadosViewModelProvider.future,
      ); // aguarda load inicial

      final notifier = container.read(certificadosViewModelProvider.notifier);
      final countBefore = container
          .read(certificadosViewModelProvider)
          .requireValue
          .length;

      final novo = Certificado.criar(
        id: 'view_model_test_id',
        origem: Origem.manual,
        titulo: 'Certificado Teste ViewModel',
        ano: 2025,
        instituicao: 'IFS',
        tipoDescricao: 'Curso',
        tags: <String>[],
        notaRelevancia: 3,
      );

      await notifier.adicionar(novo);

      final countAfter = container
          .read(certificadosViewModelProvider)
          .requireValue
          .length;
      expect(countAfter, equals(countBefore + 1));

      // Verifica se realmente foi pro repository
      final repoList = await container
          .read(certificadoRepositoryProvider)
          .listar();
      expect(repoList.any((c) => c.id == 'view_model_test_id'), isTrue);

      subscription.close();
    },
  );

  test(
    'Deve remover certificado atualizando o repository e o estado',
    () async {
      final subscription = container.listen(
        certificadosViewModelProvider,
        (_, _) {},
      );
      final stateList = await container.read(
        certificadosViewModelProvider.future,
      );

      final alvo = stateList.first;
      final countBefore = stateList.length;

      final notifier = container.read(certificadosViewModelProvider.notifier);
      await notifier.remover(alvo.id);

      final countAfter = container
          .read(certificadosViewModelProvider)
          .requireValue
          .length;
      expect(countAfter, equals(countBefore - 1));

      subscription.close();
    },
  );
}
