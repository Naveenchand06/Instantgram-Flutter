import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/enums/date_sorting.dart';
import 'package:instantgram/state/comments/models/post_comment_request.dart';
import 'package:instantgram/state/posts/models/post.dart';
import 'package:instantgram/state/posts/post_date_view.dart';
import 'package:instantgram/state/posts/providers/can_current_user_delete_post_provider.dart';
import 'package:instantgram/state/posts/providers/delete_post_provider.dart';
import 'package:instantgram/state/posts/providers/specific_post_with_comments_provider.dart';
import 'package:instantgram/views/components/animations/error_animation_view.dart';
import 'package:instantgram/views/components/animations/loading_animation_view.dart';
import 'package:instantgram/views/components/animations/small_error_animation_view.dart';
import 'package:instantgram/views/components/comments/compact_comment_column.dart';
import 'package:instantgram/views/components/constants/strings.dart';
import 'package:instantgram/views/components/dialogs/alert_dialog_model.dart';
import 'package:instantgram/views/components/dialogs/delete_dialog.dart';
import 'package:instantgram/views/components/like_button.dart';
import 'package:instantgram/views/components/likes_count_view.dart';
import 'package:instantgram/views/components/post/post_display_name_and_message_view.dart';
import 'package:instantgram/views/components/post/post_image_or_video_view.dart';
import 'package:instantgram/views/post_comments/post_comments_view.dart';
import 'package:share_plus/share_plus.dart';

class PostDetailsView extends ConsumerStatefulWidget {
  final Post post;
  const PostDetailsView({
    super.key,
    required this.post,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PostDetailsViewState();
}

class _PostDetailsViewState extends ConsumerState<PostDetailsView> {
  @override
  Widget build(BuildContext context) {
    final request = RequestForPostAndComments(
      postId: widget.post.postId,
      limit: 3,
      sortByCreatedAt: true,
      dateSorting: DateSorting.oldestOnTop,
    );

    // Get the post with comments
    final postWithComments =
        ref.watch(specificPostWithCommnetsProvider(request));

    // Can we dleete post
    final canDeletePost = ref.watch(
      cancurrentUserDeletePostProvider(
        widget.post,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.postDetails),
        actions: [
          // Share button
          postWithComments.when(
            data: (postWithComments) {
              return IconButton(
                onPressed: () {
                  final url = postWithComments.post.fileUrl;
                  Share.share(url, subject: Strings.checkOutThisPost);
                },
                icon: const Icon(Icons.share),
              );
            },
            error: (error, stackTrace) {
              return const SmallErrorAnimationView();
            },
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          ),

          // Delete button
          if (canDeletePost.value ?? false)
            IconButton(
              onPressed: () async {
                final shouldDeletePost = await const DeleteDialog(
                        titleOfObjectToDelete: Strings.post)
                    .present(context)
                    .then(
                      (value) => value ?? false,
                    );
                if (shouldDeletePost) {
                  await ref
                      .read(deletePostProvider.notifier)
                      .deletePost(post: widget.post);
                  if (mounted) {
                    Navigator.of(context).pop();
                  }
                }
              },
              icon: const Icon(Icons.delete),
            )
        ],
      ),
      body: postWithComments.when(
        data: (postWithComments) {
          final postId = postWithComments.post.postId;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                PostImageOrVideoView(post: postWithComments.post),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (postWithComments.post.allowsLikes)
                      LikeButton(postId: postId),
                    if (postWithComments.post.allowsComments)
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return PostCommentsView(postId: postId);
                              },
                            ),
                          );
                        },
                        icon: const Icon(Icons.mode_comment_outlined),
                      ),
                  ],
                ),
                // Post Detail and divider
                PostDisplayNameAndMessageView(post: postWithComments.post),
                PostDateView(dateTime: postWithComments.post.createdAt),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(color: Colors.white70),
                ),
                CompactCommentColumn(comments: postWithComments.comments),
                // display like count
                if (postWithComments.post.allowsLikes)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        LikesCountView(postId: postId),
                      ],
                    ),
                  ),
                // add spacing
                const SizedBox(
                  height: 100,
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => const ErrorAnimationView(),
        loading: () => const LoadingAnimationView(),
      ),
    );
  }
}
