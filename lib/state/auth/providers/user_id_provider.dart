import 'package:instantgram/state/auth/providers/auth_state_provider.dart';
import 'package:instantgram/state/posts/typedefs/user_id.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'user_id_provider.g.dart';

@riverpod
UserId? userId(UserIdRef ref) {
  return ref.watch(authStateProvider).userId;
}
