import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:instantgram/state/auth/providers/user_id_provider.dart';
import 'package:instantgram/state/comments/models/post_comment_request.dart';
import 'package:instantgram/state/comments/providers/post_comments_provider.dart';
import 'package:instantgram/state/comments/providers/send_comment_provider.dart';
import 'package:instantgram/state/posts/typedefs/post_id.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
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
          children: [],
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
