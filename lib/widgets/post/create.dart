import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:longlive/widgets/dialog/simple.dart';
import 'package:longlive/widgets/image/carousel.dart';
import 'package:longlive/widgets/post/board.dart';
import 'package:unicorndial/unicorndial.dart';

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
            _TextFieldWidget(
              keyboardType: TextInputType.text,
              labelText: '제목',
            ),
            _TextFieldWidget(
              keyboardType: TextInputType.multiline,
              labelText: '내용',
            ),
            // HashTag
            Container(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
              child: HashTagTextField(
                decoration: _decoration('해시태그'),
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
        onWillPop: _onWillPop,
      ),
      // 등록 버튼
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.send),
        tooltip: '업로드',
        onPressed: () {},
      ),
    );
  }

  /// 작성 중 뒤로 가려고 하는 경우, 정말로 뒤로 갈 것인지 물어봅니다.
  Future<bool> _onWillPop() async {
    var result = false;
    await showYesNoDialog(
      context: context,
      content: '작성 중 취소시 저장이 되지 않습니다.\n정말 취소하시겠습니까?',
      onAccept: () => result = true,
    );
    return result;
  }
}

class _TextFieldWidget extends StatelessWidget {
  final TextEditingController controller;

  final TextInputType keyboardType;

  final String labelText;

  const _TextFieldWidget({
    this.controller,
    this.keyboardType,
    this.labelText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: keyboardType == TextInputType.multiline ? null : 1,
        decoration: _decoration(labelText),
        style: TextStyle(fontSize: 16),
      ),
    );
  }
}

InputDecoration _decoration(String labelText) {
  return InputDecoration(
    labelText: labelText,
    labelStyle: TextStyle(fontSize: 16),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.blue),
    ),
    border: UnderlineInputBorder(),
  );
}
