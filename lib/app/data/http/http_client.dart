import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Get dio instance
Dio getDio({CacheConfig? cache, bool debug = false}) {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: getHostname().toString(),
      contentType: ContentType.json.toString(),
      headers: <String, dynamic>{'X-Requested-With': 'XMLHttpRequest'},
    ),
  );
  if (debug) {
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
  }
  if (cache != null) {
    dio.interceptors.add(DioCacheManager(cache).interceptor);
  }
  return dio;
}

// Requests

/// Fetch get
Future<Response<Map<String, dynamic>>> fetchGet(
  String url, {
  Map<String, dynamic> parameters = const <String, dynamic>{},
  Options? options,
  CacheConfig? cache,
  bool debug = false,
}) async =>
    getDio(
      debug: debug,
      cache: cache,
    ).get<Map<String, dynamic>>(
      url,
      queryParameters: {
        ...parameters,
        'api_key': dotenv.get('API_KEY'),
        'language': 'en-US',
      },
      options: options,
    );

/// Fetch get
Future<Response<List<Map<String, dynamic>>>> fetchListGet(
  String url, {
  Map<String, dynamic> parameters = const <String, dynamic>{},
  Options? options,
  CacheConfig? cache,
  bool debug = false,
}) async =>
    getDio(
      debug: debug,
      cache: cache,
    ).get<List<Map<String, dynamic>>>(
      url,
      queryParameters: {
        ...parameters,
        'api_key': dotenv.get('API_KEY'),
        'language': 'en-US',
      },
      options: options,
    );

/// Fetch post
Future<Response<Map<String, dynamic>>> fetchPost(
  String url, {
  Map<String, dynamic> parameters = const <String, dynamic>{},
  Options? options,
  CacheConfig? cache,
  bool debug = false,
}) async =>
    getDio(
      debug: debug,
      cache: cache,
    ).post<Map<String, dynamic>>(
      url,
      data: {
        ...parameters,
        'api_key': dotenv.get('API_KEY'),
        'language': 'en-US',
      },
      options: options,
    );

/// Fetch put
Future<Response<Map<String, dynamic>>> fetchPut(
  String url, {
  Map<String, dynamic> parameters = const <String, dynamic>{},
  Options? options,
  CacheConfig? cache,
  bool debug = false,
}) async =>
    getDio(
      debug: debug,
      cache: cache,
    ).put<Map<String, dynamic>>(
      url,
      data: {
        ...parameters,
        'api_key': dotenv.get('API_KEY'),
        'language': 'en-US',
      },
      options: options,
    );

/// Fetch delete
Future<Response<Map<String, dynamic>>> fetchDelete(
  String url, {
  Map<String, dynamic> parameters = const <String, dynamic>{},
  Options? options,
  CacheConfig? cache,
  bool debug = false,
}) async =>
    getDio(
      debug: debug,
      cache: cache,
    ).delete<Map<String, dynamic>>(
      url,
      data: {
        ...parameters,
        'api_key': dotenv.get('API_KEY'),
        'language': 'en-US',
      },
      options: options,
    );

// Tools

/// Get hostname
Uri getHostname() => Uri.parse(dotenv.get('API_URL'));
