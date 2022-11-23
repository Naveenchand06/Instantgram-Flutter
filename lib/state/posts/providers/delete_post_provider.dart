import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/image_upload/typedef/is_loading.dart';
import 'package:instantgram/state/posts/notifier/delete_post_state_notifier.dart';

final deletePostProvider =
    StateNotifierProvider<DeletePostsStateNotifier, IsLoading>((ref) {
  return DeletePostsStateNotifier();
});
