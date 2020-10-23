import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:longlive/models/base.dart';
import 'package:longlive/res/net.dart';
import 'package:longlive/widgets/dialog/simple.dart';

typedef T GeneratorFunction<T>(Map<String, dynamic> json);
typedef Future<void> FallbackFunction();

class Net {
  static final String host = '203.255.3.210:40989';
  static final String apiUrl = '/api/v1';

  static dynamic _get({
    BuildContext context,
    String url,
    Map<String, String> queries,
    FallbackFunction onConnectionFailure,
    FallbackFunction onInternalFailure,
  }) async {
    final uri = Uri.http(host, '$apiUrl/$url', queries);

    try {
      final response = await http.get(
        uri,
        headers: {
          "Accept": "application/json",
          "Accept-Charset": "utf-8",
        },
      );

      // 내부 오류
      if (response.statusCode != 200) {
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

      return jsonDecode(utf8.decode(response.bodyBytes));
    } catch (_) {
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

  static Future<Map<int, T>> getList<T extends DBTable>({
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

  static dynamic _post({
    BuildContext context,
    String url,
    Map<String, dynamic> queries,
    FallbackFunction onConnectionFailure,
    FallbackFunction onInternalFailure,
  }) async {
    final uri = Uri.http(host, '$apiUrl/$url');

    try {
      final response = await http.post(
        uri,
        headers: {
          "content-type": "application/json",
          "Accept": "application/json",
          "Accept-Charset": "utf-8",
        },
        body: json.encode(queries),
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

      return jsonDecode(utf8.decode(response.bodyBytes));
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

  static Future<T> postOne<T extends DBTable>({
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

  static Future<bool> createOne<T extends DBTable>({
    BuildContext context,
    String url,
    T object,
  }) async {
    final Map<String, dynamic> data = await _post(
      context: context,
      url: url,
      queries: object.toJson(),
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

  static Future<bool> createOneWithQuery({
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
}
