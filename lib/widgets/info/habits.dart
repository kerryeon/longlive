import 'package:flutter/material.dart';
import 'package:longlive/models/habit.dart';
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
  final List<HabitToggle> habits = HabitToggle.all();

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
    habit.enabled = !habit.enabled;
    setState(() {});
  }
}
