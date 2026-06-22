import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ifdex/features/certificados/data/certificado_repository.dart';
import 'package:ifdex/features/certificados/presentation/certificados_view_model.dart';
import 'package:ifdex/features/certificados/models/certificado.dart';

class FakeCertificadoRepository implements CertificadoRepository {
  final List<Certificado> _items = [];

  @override
  Future<List<Certificado>> listarTodos() async => _items;

  @override
  Future<void> adicionar(Certificado certificado, {String? fileName}) async {
    final index = _items.indexWhere((c) => c.id == certificado.id);
    if (index >= 0) {
      _items[index] = certificado;
    } else {
      _items.add(certificado);
    }
  }

  @override
  Future<void> remover(String id) async {
    _items.removeWhere((c) => c.id == id);
  }

  @override
  Future<Uint8List?> carregarArquivo(String certificadoId) async => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late ProviderContainer container;
  late FakeCertificadoRepository fakeRepo;

  setUp(() {
    fakeRepo = FakeCertificadoRepository();

    // Add initial item for tests
    fakeRepo._items.add(
      Certificado.criar(
        id: 'mock-1',
        origem: Origem.manual,
        titulo: 'Certificado Mock 1',
        ano: 2024,
        instituicao: 'Mock',
        tipoDescricao: 'Curso',
        tags: [],
        notaRelevancia: 1,
      ),
    );

    container = ProviderContainer(
      overrides: [certificadoRepositoryProvider.overrideWithValue(fakeRepo)],
    );
  });

  tearDown(() {
    container.dispose();
  });

  test('Deve carregar a lista de certificados no estado inicial', () async {
    final subscription = container.listen(
      certificadosViewModelProvider,
      (_, _) {},
    );

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
      await container.read(certificadosViewModelProvider.future);

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

      final repoList = await fakeRepo.listarTodos();
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
