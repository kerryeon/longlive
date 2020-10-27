import 'package:flutter/material.dart';
import 'package:hashtagable/hashtagable.dart';
import 'package:longlive/models/base.dart';
import 'package:longlive/models/habit.dart';
import 'package:longlive/widgets/board/menu.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  BoardState({this.url, this.query});

  String url;

  List<T> infos = [];

  // 쿼리
  Q query;

  // 쿼리 갱신중
  bool _isLoading = false;

  Future<void> reload({
    bool nextPage = false,
    bool refreshPage = true,
    String title,
    Habit ty,
    List<String> tags,
  }) async {
    if (!mounted) return;
    if (_isLoading) {
      if (nextPage) {
        _refreshController.loadComplete();
      }
      if (refreshPage) {
        _refreshController.refreshCompleted();
      }
    }
    _isLoading = true;

    // 쿼리 갱신
    if (nextPage == true) {
      // 다음 페이지가 없으면, 불러오지 않습니다.
      if (!query.hasNextPage) {
        _refreshController.loadNoData();
        return;
      }
      query.page += 1;
    }
    if (refreshPage == true) {
      _refreshController.resetNoData();
      query.page = 1;
    }
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
    setState(() {
      if (nextPage) {
        // 다음 페이지의 내용은 이전 페이지들의 내용의 뒤에 붙입니다.
        this.infos += infos;
      } else {
        // 새로운 페이지의 내용은 이전 페이지들의 내용에 덮어씌웁니다.
        this.infos = infos;
      }
    });

    // 컨트롤러 갱신
    if (nextPage) {
      _refreshController.loadComplete();
    }
    if (refreshPage) {
      _refreshController.refreshCompleted();
    }
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
            onPressed: _search,
          ),
        ],
      ),
      // 카테고리 목록
      drawer: CategoryWidget(
        onTap: (ty) => reload(title: '', tags: [], ty: ty),
      ),
      // 중앙에 배치
      body: Center(
        child: SmartRefresher(
          controller: _refreshController,
          enablePullUp: true,
          enablePullDown: true,
          header: WaterDropHeader(),
          onRefresh: () async => reload(),
          onLoading: () async => reload(refreshPage: false, nextPage: true),
          child: buildBody(context),
        ),
      ),
    );
  }

  ScrollView buildBody(BuildContext context);

  /// 주제어 및 태그를 검색합니다.
  Future<void> _search() async {
    final query = await showSearch(context: context, delegate: _Search());
    if (query == null) {
      return reload(title: '', tags: []);
    }

    final tags = extractHashTags(query);
    if (tags.isNotEmpty) {
      final tagsNoSharp = tags.map((e) => e.substring(1)).toList();
      return reload(title: '', tags: tagsNoSharp);
    } else {
      return reload(title: query, tags: []);
    }
  }
}

/// 검색 기능 유틸리티
class _Search extends SearchDelegate<String> {
  static List<String> history = [];

  String result = '';

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = '';
        },
      ),
      IconButton(
        icon: Icon(Icons.search),
        onPressed: () => storeAndReturn(context, query),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return ListView(
      children: _Search.history.reversed
          .where((e) => e.contains(query))
          .map((e) => buildEntity(context, e))
          .toList(),
    );
  }

  Widget buildEntity(BuildContext context, String title) {
    return ListTile(
      leading: Icon(Icons.history),
      title: Text(title),
      onTap: () => storeAndReturn(context, title),
    );
  }

  void storeAndReturn(BuildContext context, String value) {
    history.remove(value);
    history.add(value);
    return close(context, value);
  }
}
