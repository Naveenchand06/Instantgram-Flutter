import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/providers/user_id_provider.dart';
import 'package:instantgram/state/likes/models/like_dislike_request.dart';
import 'package:instantgram/state/likes/providers/has_liked_post_provider.dart';
import 'package:instantgram/state/likes/providers/like_dislike_post_provider.dart';
import 'package:instantgram/state/posts/typedefs/post_id.dart';
import 'package:instantgram/views/components/animations/small_error_animation_view.dart';

class LikeButton extends ConsumerWidget {
  final PostId postId;
  const LikeButton({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasLiked = ref.watch(hasLikedPostProvider(postId));
    return hasLiked.when(
      data: (hasLiked) {
        return IconButton(
            onPressed: () {
              final userId = ref.read(userIdProvider);
              if (userId == null) {
                return;
              }
              final likeRequest =
                  LikeDislikeRequest(postId: postId, likedBy: userId);
              ref.read(likeDislikePostProvider(request: likeRequest));
            },
            icon: FaIcon(hasLiked
                ? FontAwesomeIcons.solidHeart
                : FontAwesomeIcons.heart));
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
