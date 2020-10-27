import 'package:flutter/material.dart';
import 'package:longlive/models/post.dart';
import 'package:longlive/widgets/board/form.dart';
import 'package:longlive/widgets/dialog/form.dart';
import 'package:longlive/widgets/dialog/pop.dart';
import 'package:longlive/widgets/dialog/simple.dart';

class ReportButtonWidget extends StatelessWidget {
  final PostInfo info;

  const ReportButtonWidget(this.info);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.report,
        color: Colors.red,
      ),
      tooltip: '신고하기',
      onPressed: () => onPressed(context),
    );
  }

  Future<void> onPressed(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => _FormWidget(info),
      ),
    );
  }
}

/// ## 신고 양식 위젯
/// ### 생김새
/// - 상단
///   - 신고할 게시글 제목
/// - 중앙
///   - 신고 사유 작성
/// - 하단
///   - 등록 버튼
class _FormWidget extends StatefulWidget {
  final PostInfo info;

  const _FormWidget(this.info);

  @override
  State createState() => _State(this.info);
}

class _State extends State {
  final TextEditingController _descController = TextEditingController();
  final FocusNode _descFocus = FocusNode();

  final PostInfo info;

  _State(this.info);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('신고하기: "${info.title}"'),
      ),
      body: WillPopScope(
        child: FormTextWidget(
          controller: _descController,
          focusNode: _descFocus,
          autofocus: true,
          keyboardType: TextInputType.multiline,
          labelText: '사유',
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

  /// 정말 신고할 것인지, 다시 한번 물어봅니다.
  void onPressed() {
    final desc = tryGetString(context, _descController, _descFocus, '신고 사유');
    if (desc == null) return;

    showYesNoDialog(
      context: context,
      content: '정말 신고하시겠습니까?',
      onAccept: () => submit(desc),
    );
  }

  /// 작성한 사유를 토대로 신고합니다.
  Future<void> submit(String desc) async {
    final result = await info.report(context, desc);
    if (result) Navigator.of(context).pop();
  }
}
