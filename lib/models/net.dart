import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/material.dart';
import 'package:longlive/models/base.dart';
import 'package:longlive/res/net.dart';
import 'package:longlive/widgets/dialog/simple.dart';
import 'package:path_provider/path_provider.dart';

typedef List<dynamic> PreprocessFunction(dynamic data);
typedef T GeneratorFunction<T>(Map<String, dynamic> json);
typedef Future<Response> RequestFunction(Dio dio, String url, {String data});
typedef Future<void> FallbackFunction();

class Net {
  static final String host = '203.255.3.210:40989';
  static final String apiUrl = '/api/v1';

  static final Net _instance = Net._internal();
  factory Net() => _instance;
  Net._internal();

  Future<Dio> dio() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;

    final cookieJar = PersistCookieJar(dir: appDocPath + '/.cookies/');
    final cookieManager = CookieManager(cookieJar);

    final dio = Dio();
    dio.interceptors.add(cookieManager);

    dio.options.contentType = 'application/json';
    dio.options.headers[HttpHeaders.acceptHeader] = 'application/json';
    dio.options.headers[HttpHeaders.acceptCharsetHeader] = 'utf-8';
    dio.options.responseType = ResponseType.bytes;
    return dio;
  }

  dynamic _request({
    BuildContext context,
    String url,
    Map<String, dynamic> queries,
    RequestFunction f,
    FallbackFunction onConnectionFailure,
    FallbackFunction onInternalFailure,
  }) async {
    final uri = Uri.http(host, '$apiUrl/$url/');

    try {
      final response = await f(
        await this.dio(),
        uri.toString(),
        data: json.encode(queries),
      );

      // 내부 오류
      if (![200, 201].contains(response.statusCode)) {
        if (onInternalFailure != null)
          await onInternalFailure();
        else
          await showMessageDialog(
            context: context,
            content: NetMessage.internalFailure,
            onConfirm: exitApp,
          );
        return null;
      }

      return jsonDecode(utf8.decode(response.data));
    } catch (e) {
      // 인터넷 연결 실패
      if (onConnectionFailure != null)
        await onConnectionFailure();
      else
        await showMessageDialog(
          context: context,
          content: NetMessage.connectionFailure,
          onConfirm: exitApp,
        );
    }
    return null;
  }

  dynamic _get({
    BuildContext context,
    String url,
    Map<String, String> queries,
    FallbackFunction onConnectionFailure,
    FallbackFunction onInternalFailure,
  }) async {
    final uri = Uri.http(host, '$apiUrl/$url/', queries).toString();
    return _request(
      f: (dio, _, {data}) => dio.get(uri),
      context: context,
      url: url,
      queries: queries,
      onConnectionFailure: onConnectionFailure,
      onInternalFailure: onInternalFailure,
    );
  }

  Future<List<T>> getList<T extends DBTable>({
    BuildContext context,
    String url,
    Map<String, String> queries,
    PreprocessFunction preprocess,
    GeneratorFunction<T> generator,
    FallbackFunction onConnectionFailure,
    FallbackFunction onInternalFailure,
  }) async {
    var data = await _get(
      context: context,
      url: url,
      queries: queries,
      onConnectionFailure: onConnectionFailure,
      onInternalFailure: onInternalFailure,
    );

    if (data != null) {
      final List<dynamic> dataPreprocessed =
          preprocess != null ? preprocess(data) : List<dynamic>.from(data);
      return dataPreprocessed.map((e) => generator(e)).toList();
    } else {
      return null;
    }
  }

  Future<Map<int, T>> getDict<T extends DBTable>({
    BuildContext context,
    String url,
    Map<String, String> queries,
    GeneratorFunction<T> generator,
    FallbackFunction onConnectionFailure,
    FallbackFunction onInternalFailure,
  }) async {
    final List<dynamic> data = await _get(
      context: context,
      url: url,
      queries: queries,
      onConnectionFailure: onConnectionFailure,
      onInternalFailure: onInternalFailure,
    );

    if (data != null) {
      final List<T> contents = data.map((e) => generator(e)).toList();
      return Map.fromIterable(contents, key: (e) => e.id, value: (e) => e);
    } else {
      return null;
    }
  }

  dynamic _post({
    BuildContext context,
    String url,
    Map<String, dynamic> queries,
    FallbackFunction onConnectionFailure,
    FallbackFunction onInternalFailure,
  }) async {
    return _request(
      f: (dio, url, {data}) => dio.post(url, data: data),
      context: context,
      url: url,
      queries: queries,
      onConnectionFailure: onConnectionFailure,
      onInternalFailure: onInternalFailure,
    );
  }

  Future<T> postOne<T extends DBTable>({
    BuildContext context,
    String url,
    Map<String, dynamic> queries,
    GeneratorFunction<T> generator,
    FallbackFunction onConnectionFailure,
    FallbackFunction onInternalFailure,
  }) async {
    final Map<String, dynamic> data = await _post(
      context: context,
      url: url,
      queries: queries,
      onConnectionFailure: onConnectionFailure,
      onInternalFailure: onInternalFailure,
    );

    if (data != null) {
      return generator(data);
    } else {
      return null;
    }
  }

  Future<bool> createOne<T extends DBTable>({
    BuildContext context,
    String url,
    T object,
  }) async {
    return createOneWithQuery(
      context: context,
      url: url,
      queries: object.toJson(),
    );
  }

  Future<bool> createOneWithQuery({
    BuildContext context,
    String url,
    Map<String, dynamic> queries,
  }) async {
    final Map<String, dynamic> data = await _post(
      context: context,
      url: url,
      queries: queries,
      onConnectionFailure: () async => showMessageDialog(
        context: context,
        content: NetMessage.connectionFailure,
      ),
      onInternalFailure: () async => {},
    );

    if (data != null) {
      return true;
    } else {
      return false;
    }
  }

  dynamic _update({
    BuildContext context,
    String url,
    Map<String, dynamic> queries,
    FallbackFunction onConnectionFailure,
    FallbackFunction onInternalFailure,
  }) async {
    return _request(
      f: (dio, url, {data}) => dio.patch(url, data: data),
      context: context,
      url: url,
      queries: queries,
      onConnectionFailure: onConnectionFailure,
      onInternalFailure: onInternalFailure,
    );
  }

  Future<bool> update({
    BuildContext context,
    String url,
    Map<String, dynamic> queries,
  }) async {
    final Map<String, dynamic> data = await _update(
      context: context,
      url: url,
      queries: queries,
      onConnectionFailure: () async => showMessageDialog(
        context: context,
        content: NetMessage.connectionFailure,
      ),
      onInternalFailure: () async => {},
    );

    if (data != null) {
      return true;
    } else {
      return false;
    }
  }
}
