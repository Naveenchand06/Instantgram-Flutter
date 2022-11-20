import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/image_upload/notifiers/image_upload_notifier.dart';
import 'package:instantgram/state/image_upload/typedef/is_loading.dart';

final imageUploadProvider =
    StateNotifierProvider<ImageUploadNotifier, IsLoading>((ref) {
  return ImageUploadNotifier();
});
