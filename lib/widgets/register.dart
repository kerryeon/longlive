import 'package:flutter/material.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/models/user.dart';
import 'package:longlive/widgets/dialog/simple.dart';

/// ## 첫 사용자 화면
/// ### 생김새
/// - 이름 및 성별 선택
/// - 습관 선택
///
/// ### 기능
/// - 이름 및 성별 선택 후, 등록 가능
/// - 습관은 선택 안해도 되지만, 대신 실수 방지를 위해 경고창 날림
class RegisterWidget extends StatefulWidget {
  @override
  State createState() => _State();
}

class _State extends State {
  int userAge;
  Gender userGender;
  final List<Habit> habits = Habit.all();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 가운데 맞춤
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.only(
          top: 16,
        ),
        // 스크롤 가능함
        child: SingleChildScrollView(
          // 세로 정렬
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                '반갑습니다',
                style: Theme.of(context).textTheme.headline3,
              ),
              // 나이 선택
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('나이'),
                  Padding(padding: const EdgeInsets.only(right: 16)),
                  DropdownButton(
                    hint: Text('나이를 선택하세요'),
                    value: userAge,
                    items: List<int>.generate(15, (i) => i + 20)
                        .map((x) => DropdownMenuItem(
                              value: x,
                              child: Text(x.toString()),
                            ))
                        .toList(),
                    // 변수 값을 바꾸고, UI를 갱신합니다.
                    onChanged: (x) => setState(() => userAge = x),
                  ),
                ],
              ),
              // 성별 선택
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('성별'),
                  Padding(padding: const EdgeInsets.only(right: 16)),
                  DropdownButton(
                    hint: Text('성별을 선택하세요'),
                    value: userGender,
                    items: [Gender.Male, Gender.Female]
                        .map((x) => DropdownMenuItem(
                              value: x,
                              child: Text(x.description),
                            ))
                        .toList(),
                    onChanged: (x) => setState(() => userGender = x),
                  ),
                ],
              ),
              // 습관 선택
              Padding(padding: const EdgeInsets.only(bottom: 16)),
              Text(
                '아래에서 해당하는 습관/질병을 골라주세요',
                style: Theme.of(context).textTheme.subtitle1,
              ),
              GridView(
                shrinkWrap: true,
                primary: false,
                padding: const EdgeInsets.all(16),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  // 한 줄에 표시할 카드 갯수
                  crossAxisCount: 4,
                ),
                // 습관 목록
                children: habits
                    .map((x) => Padding(
                          padding: const EdgeInsets.all(4),
                          child: FlatButton(
                            color: x.enabled ? Colors.brown : x.ty.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                x.name,
                                style: Theme.of(context).textTheme.button.apply(
                                      color: x.enabled
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            onPressed: () =>
                                setState(() => x.enabled = !x.enabled),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
      // 하단 버튼
      floatingActionButton: Visibility(
        visible: _isSelectedAll,
        child: FloatingActionButton(
          child: Icon(Icons.navigate_next),
          onPressed: _moveToNextPage,
        ),
      ),
    );
  }

  /// 가입에 필요한 모든 정보들이 입력되었는가?
  bool get _isSelectedAll => userAge != null && userGender != null;

  /// 단 하나의 습관이라도 선택되었는가?
  bool get isAnyHabitEnabled => habits.any((x) => x.enabled);

  /// 다음 화면으로 이동합니다.
  /// 이때, 아무 습관이 선택되지 않았다면, 진정 아무것도 선택하지 않았는지 물어봅니다.
  void _moveToNextPage({final bool checkHabits = true}) {
    if (checkHabits && !isAnyHabitEnabled) {
      showYesNoDialog(
        context: context,
        content: '정말 아무 습관/질병에도 해당되지 않으십니까?',
        onAccept: () => _moveToNextPage(checkHabits: false),
      );
      return;
    }
    // Navigator.of(context).pushReplacement(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) => RegisterWidget(),
    //   ),
    // );
  }
}
