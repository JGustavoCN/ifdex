import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:ifdex/features/auth/data/auth_repository.dart';

part 'auth_view_model.g.dart';

@riverpod
class AuthViewModel extends _$AuthViewModel {
  @override
  Stream<User?> build() {
    final repo = ref.watch(authRepositoryProvider);
    return repo.authStateChanges;
  }

  Future<void> signInAnonymously() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signInAnonymously();
  }

  Future<void> signInWithGoogle() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signInWithGoogle();
  }

  Future<void> linkWithGoogle() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.linkWithGoogle();
  }

  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    await repo.signOut();
  }
}
