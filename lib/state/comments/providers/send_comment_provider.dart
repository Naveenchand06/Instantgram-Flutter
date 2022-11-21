import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/comments/notifiers/send_comments_notifier.dart';
import 'package:instantgram/state/image_upload/typedef/is_loading.dart';

final sendCommentProvider =
    StateNotifierProvider<SendCommentNotifier, IsLoading>((ref) {
  return SendCommentNotifier();
});
