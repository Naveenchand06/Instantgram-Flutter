import 'package:flutter/material.dart';
import 'package:instantgram/state/posts/models/post.dart';
import 'package:instantgram/views/components/animations/small_error_animation_view.dart';

class PostImageView extends StatelessWidget {
  final Post post;
  const PostImageView({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: post.aspectRatio,
      child: Image.network(
        post.fileUrl,
        errorBuilder: (context, error, stackTrace) {
          return const SmallErrorAnimationView();
        },
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
