import 'package:flutter/material.dart';
import 'package:instantgram/state/comments/models/comments.dart';
import 'package:instantgram/views/components/comments/compact_coomment_tile.dart';

class CompactCommentColumn extends StatelessWidget {
  final Iterable<Comment> comments;

  const CompactCommentColumn({
    super.key,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments
            .map(
              (comment) => CompactCommentTile(comment: comment),
            )
            .toList(),
      ),
    );
  }
}
