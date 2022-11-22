import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/providers/user_id_provider.dart';
import 'package:instantgram/state/comments/models/post_comment_request.dart';
import 'package:instantgram/state/comments/providers/post_comments_provider.dart';
import 'package:instantgram/state/comments/providers/send_comment_provider.dart';
import 'package:instantgram/state/posts/typedefs/post_id.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:instantgram/views/components/animations/empty_contents_animation_view.dart';
import 'package:instantgram/views/components/animations/error_animation_view.dart';
import 'package:instantgram/views/components/animations/loading_animation_view.dart';
import 'package:instantgram/views/components/commnets/comment_tile.dart';
import 'package:instantgram/views/components/constants/strings.dart';
import 'package:instantgram/views/extensions/dismiss_keyboard.dart';

class PostCommentsView extends HookConsumerWidget {
  const PostCommentsView({
    super.key,
    required this.postId,
  });

  final PostId postId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final commentController = useTextEditingController();

    final hasText = useState(false);

    final request = useState(
      RequestForPostAndComments(postId: postId),
    );

    final comments = ref.watch(
      postCommentsProvider(request.value),
    );

    useEffect(() {
      commentController.addListener(() {
        hasText.value = commentController.text.isNotEmpty;
      });
      return () {};
    }, [commentController]);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(Strings.comments),
        actions: [
          IconButton(
            onPressed: hasText.value
                ? () {
                    _submitCommentWithController(commentController, ref);
                  }
                : null,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
      body: SafeArea(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Expanded(
                flex: 4,
                child: comments.when(
                  data: (comments) {
                    if (comments.isEmpty) {
                      return const SingleChildScrollView(
                        child: EmptyContentsAnimationView(),
                      );
                    }
                    return RefreshIndicator(
                      onRefresh: () {
                        ref.refresh(postCommentsProvider(request.value));
                        return Future.delayed(const Duration(seconds: 1));
                      },
                      child: ListView.builder(
                        padding: const EdgeInsets.all(8.0),
                        itemCount: comments.length,
                        itemBuilder: (context, index) {
                          final comment = comments.elementAt(index);
                          return CommentTile(comment: comment);
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) {
                    return const ErrorAnimationView();
                  },
                  loading: () => const LoadingAnimationView(),
                )),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: TextField(
                    textInputAction: TextInputAction.send,
                    controller: commentController,
                    onSubmitted: (comment) {
                      if (comment.isNotEmpty) {
                        _submitCommentWithController(commentController, ref);
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: Strings.writeYourCommentHere,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _submitCommentWithController(
    TextEditingController controller,
    WidgetRef ref,
  ) async {
    final userId = ref.read(userIdProvider);
    if (userId == null) {
      return;
    }
    final isSent = await ref.read(sendCommentProvider.notifier).sendComment(
          fromUserId: userId,
          onPostId: postId,
          comment: controller.text,
        );

    if (isSent) {
      controller.clear();
      dismissKeyboard();
    }
  }
}
