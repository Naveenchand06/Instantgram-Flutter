import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/providers/auth_state_provider.dart';
import 'package:instantgram/state/posts/typedefs/user_id.dart';

final userIdProvider = Provider<UserId?>((ref) {
  return ref.watch(authStateProvider).userId;
});
