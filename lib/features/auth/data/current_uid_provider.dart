import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ifdex/features/auth/presentation/auth_view_model.dart';

part 'current_uid_provider.g.dart';

@riverpod
String? currentUid(CurrentUidRef ref) {
  final authState = ref.watch(authViewModelProvider);
  return authState.valueOrNull?.uid;
}
