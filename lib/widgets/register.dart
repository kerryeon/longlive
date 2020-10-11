import 'package:flutter/material.dart';
import 'package:longlive/models/user.dart';

class RegisterWidget extends StatefulWidget {
  @override
  State createState() => _State();
}

class _State extends State {
  int userAge;
  Gender userGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 가운데 맞춤
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
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
                  Padding(padding: EdgeInsets.only(right: 16)),
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
                  Padding(padding: EdgeInsets.only(right: 16)),
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
              Padding(padding: EdgeInsets.only(bottom: 16)),
              Text(
                '아래에서 해당하는 습관/질병을 골라주세요',
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
