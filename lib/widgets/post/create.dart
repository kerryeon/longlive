import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:longlive/widgets/board/form.dart';
import 'package:longlive/widgets/dialog/pop.dart';
import 'package:longlive/widgets/image/carousel.dart';
import 'package:longlive/widgets/post/board.dart';

/// ## 게시글 작성 위젯
/// ### 생김새
/// - 상단
///   - "카테고리" 컨텐츠 만들기
/// - 중앙
///   - 이미지 추가 (가로 스크롤)
///     - 전체 삭제 기능
///   - 제목 작성
///   - 글 작성
///   - HashTag 추가
/// - 하단
///   - 등록 버튼
class PostCreateWidget extends StatefulWidget {
  final PostBoardController _controller;

  const PostCreateWidget(this._controller);

  @override
  State createState() => _State(this._controller);
}

class _State extends State {
  final PostBoardController _controller;
  final CarouselToolController _imagesController = CarouselToolController(
    images: [],
    append: true,
  );

  _State(this._controller);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('\'${_controller.category}\' 컨텐츠 만들기'),
      ),
      body: WillPopScope(
        child: ListView(
          children: [
            // 이미지
            CarouselToolWidget(_imagesController),
            // 제목 및 내용
            FormTextWidget(
              keyboardType: TextInputType.text,
              labelText: '제목',
            ),
            FormTextWidget(
              keyboardType: TextInputType.multiline,
              labelText: '내용',
            ),
            // HashTag
            Container(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
              child: HashTagTextField(
                decoration: FormTextWidget.decoration('해시태그'),
                basicStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
                decoratedStyle: TextStyle(
                  fontSize: 16,
                  color: Colors.blue,
                ),
              ),
            ),
          ],
        ),
        onWillPop: () => onExitForm(context),
      ),
      // 등록 버튼
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        tooltip: '업로드',
        onPressed: () {},
      ),
    );
  }
}
