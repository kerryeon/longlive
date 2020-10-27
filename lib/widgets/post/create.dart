import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:longlive/models/post.dart';
import 'package:longlive/widgets/board/form.dart';
import 'package:longlive/widgets/dialog/form.dart';
import 'package:longlive/widgets/dialog/pop.dart';
import 'package:longlive/widgets/dialog/simple.dart';
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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _tagsController = TextEditingController();
  final FocusNode _titleFocus = FocusNode();
  final FocusNode _descFocus = FocusNode();
  final FocusNode _tagsFocus = FocusNode();

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
        title: Text('\'${_controller.category.name}\' 컨텐츠 만들기'),
      ),
      body: WillPopScope(
        child: ListView(
          children: [
            // 이미지
            CarouselToolWidget(_imagesController),
            // 제목 및 내용
            FormTextWidget(
              controller: _titleController,
              focusNode: _titleFocus,
              keyboardType: TextInputType.text,
              labelText: '제목',
            ),
            FormTextWidget(
              controller: _descController,
              focusNode: _descFocus,
              keyboardType: TextInputType.multiline,
              labelText: '내용',
            ),
            // HashTag
            Container(
              padding: const EdgeInsets.fromLTRB(14, 6, 14, 6),
              child: HashTagTextField(
                controller: _tagsController,
                focusNode: _tagsFocus,
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
        onPressed: onPressed,
      ),
    );
  }

  /// 정말 등록할 것인지, 다시 한번 물어봅니다.
  void onPressed() {
    final title = tryGetString(context, _titleController, _titleFocus, '제목');
    if (title == null) return;

    final desc = tryGetString(context, _descController, _descFocus, '내용');
    if (desc == null) return;

    final tags = extractHashTags(_tagsController.text)
        .map((e) => e.substring(1))
        // 중복 제거
        .toSet();

    final images = _imagesController.images
        .map((e) => e as FileImage)
        .map((e) => e.file)
        .toList();

    showYesNoDialog(
      context: context,
      content: '정말 등록하시겠습니까?',
      onAccept: () => submit(title, desc, tags, images),
    );
  }

  /// 게시글을 등록합니다.
  Future<void> submit(
    String title,
    String desc,
    Set<String> tags,
    List<File> images,
  ) async {
    final info = PostInfo(
      title: title,
      desc: desc,
      ty: _controller.category,
      tags: tags,
    );

    final result = await info.create(context, images);
    if (result) Navigator.of(context).pop(true);
  }
}
