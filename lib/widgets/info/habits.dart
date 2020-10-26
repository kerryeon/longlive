import 'package:flutter/material.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/models/user.dart';
import 'package:longlive/widgets/info/base.dart';

/// ## 증상/습관 정보 변경 기능
class HabitsInfo implements UserInfo {
  String get label => '증상/습관 정보 변경';

  Future<void> onPressed(BuildContext context) async {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => _Widget(),
      ),
    );
  }
}

class HabitsContentWidget extends StatelessWidget {
  final List<HabitToggle> habits;

  final void Function(HabitToggle) onTap;

  const HabitsContentWidget({
    this.habits,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      primary: false,
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // 한 줄에 표시할 카드 갯수
        crossAxisCount: 4,
      ),
      // 습관 목록
      children: habits
          .map(
            (x) => Padding(
              padding: const EdgeInsets.all(4),
              child: FlatButton(
                color: x.enabled ? Colors.brown : x.habit.ty.color,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    x.habit.name,
                    style: Theme.of(context).textTheme.button.apply(
                          color: x.enabled ? Colors.white : Colors.black,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ),
                onPressed: () => onTap(x),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _Widget extends StatefulWidget {
  @override
  State createState() => _State();
}

class _State extends State {
  final List<HabitToggle> habits = User.getInstance().enabledHabits();

  bool isProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('증상/습관 정보 변경'),
      ),
      body: SingleChildScrollView(
        child: HabitsContentWidget(
          habits: habits,
          onTap: _changeHabit,
        ),
      ),
    );
  }

  /// 선택한 습관 정보를 갱신합니다.
  Future<void> _changeHabit(HabitToggle habit) async {
    // 이미 갱신중이면, 버튼 입력을 무시합니다.
    if (isProgress) return;
    isProgress = true;

    // 습관 정보를 도치합니다.
    habit.enabled = !habit.enabled;
    final habits =
        this.habits.where((e) => e.enabled).map((e) => e.habit).toList();

    // 유저 정보에 반영합니다.
    final user = User.getInstance();
    final habitsOld = user.habits;
    user.habits = habits;

    // 서버에 갱신을 요청합니다.
    final result = await user.updateHabits(context);

    if (result) {
      // 갱신에 성공한 경우, UI를 갱신합니다.
      if (mounted) setState(() {});
    } else {
      // 갱신에 실패한 경우, 결과를 이전으로 되돌립니다.
      habit.enabled = !habit.enabled;
      user.habits = habitsOld;
    }

    // 버튼 입력을 활성화합니다.
    isProgress = false;
  }
}
