import 'package:flutter/material.dart';
import 'package:longlive/models/base.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/widgets/board/menu.dart';

/// ## 목록 위젯
/// ### 생김새
/// - 상단
///   - (좌) 카테고리 선택 버튼
///   - 카테고리 이름
///   - (우) 검색 버튼
/// - 중앙
///   - 목록
///
/// ### 기능
/// - 탭을 눌러 컨텐츠 전환
abstract class BoardState<T extends BoardEntity, Q extends DBQuery>
    extends State {
  BoardState({this.url, this.query});

  String url;

  List<T> infos = [];

  // 쿼리
  Q query;

  // 쿼리 갱신중
  bool _isLoading = false;

  Future<void> reload({
    String title,
    Habit ty,
    List<String> tags,
  }) async {
    if (!mounted || _isLoading) return;
    _isLoading = true;

    // 쿼리 갱신
    if (title != null) {
      query.title = title;
    }
    if (ty != null) {
      if (ty.id == 0) ty = null;
      query.ty = ty;
    }
    if (tags != null) {
      query.tags = tags;
    }

    // 쿼리 요청
    final infos = await query.getList(context, url);

    // 화면 갱신
    if (!mounted) return;
    _isLoading = false;
    setState(() => this.infos = infos);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => reload());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // 카테고리
        title: Text(
          query.ty != null ? query.ty.name : '모두',
        ),
        // 검색 버튼
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            tooltip: '검색',
            onPressed: () {},
          ),
        ],
      ),
      // 카테고리 목록
      drawer: CategoryWidget(
        onTap: (ty) => reload(ty: ty),
      ),
      // 중앙에 배치
      body: buildBody(context),
    );
  }

  Widget buildBody(BuildContext context);
}
