import 'package:flutter/material.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/models/user.dart';

typedef Future<void> OnTapHandler(Habit habit);

class CategoryWidget extends StatelessWidget {
  final OnTapHandler onTap;

  const CategoryWidget({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      semanticLabel: '카테고리',
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
              // 헤더
              DrawerHeader(
                child: null,
                decoration: BoxDecoration(
                  color: Colors.green,
                  image: DecorationImage(
                    image: AssetImage('assets/icons/logo.png'),
                    fit: BoxFit.cover,
                    alignment: FractionalOffset(0.5, 0.24),
                  ),
                ),
              ),
              // 모든 카테고리 버튼
              ListTile(
                leading: Icon(HabitType.allIcon),
                title: Text('모두'),
                onTap: () => _onTap(context, Habit(id: 0)),
              ),
            ] +
            // 각 카테고리 버튼
            User.getInstance()
                .habits
                .map(
                  (ty) => ListTile(
                    leading: Icon(ty.icon),
                    title: Text(ty.name),
                    onTap: () => _onTap(context, ty),
                  ),
                )
                .toList(),
      ),
    );
  }

  void _onTap(BuildContext context, Habit habit) {
    Navigator.pop(context);
    onTap(habit);
  }
}
