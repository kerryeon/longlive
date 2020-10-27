import 'package:flutter/material.dart';
import 'package:longlive/models/post.dart';

class LikeButtonWidget extends StatelessWidget {
  final PostInfo info;

  final VoidCallback onUpdate;

  const LikeButtonWidget(
    this.info,
    this.onUpdate,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.favorite),
            color: info.isLiked ? Colors.red : Colors.black,
            tooltip: '찜하기',
            onPressed: () => _toggleLike(context),
          ),
          Text(info.numLikesFormat),
        ],
      ),
    );
  }

  Future<void> _toggleLike(BuildContext context) async {
    await info.toggleLike(context);
    onUpdate();
  }
}
