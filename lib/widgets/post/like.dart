import 'package:flutter/material.dart';
import 'package:longlive/models/post.dart';

class LikeButtonWidget extends StatelessWidget {
  final PostInfo _info;

  const LikeButtonWidget(this._info);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: Icon(Icons.favorite),
            color: _info.isLiked ? Colors.red : Colors.black,
            tooltip: '찜하기',
            onPressed: () {},
          ),
          Text(_info.numLikesFormat),
        ],
      ),
    );
  }
}
