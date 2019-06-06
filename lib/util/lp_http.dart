import 'dart:io';
import 'package:dio/dio.dart';
import 'i18n.dart';
import 'util.dart';

class LpHttpError extends Error {
  final int code;
  final String message;

  LpHttpError(this.code, this.message);

  String toString() => '[$code] $message';
}

abstract class LpHttpCode {
  static const ACCOUNT_DENIED = 100102;
  static const USER_TOKEN_EXPIRED = 100104;
  static const GUEST_TOKEN_EXPIRED = 100105;
  static const NEED_LOGIN = 100200;
  static const DUPLICATE_SUBMIT = -2;
}

class LpHttp {
  static final _instance = LpHttp.fromOptions(
    BaseOptions(
      baseUrl: '',
      connectTimeout: 30000,
      receiveTimeout: 30000,
    ),
  );

  final Dio _dio;

  LpHttp.fromOptions(BaseOptions baseOptions) : _dio = Dio(baseOptions) {
    if (AppInfo.isDebug || AppInfo.appChannel == 'rc-integration') {
      (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (client) {
        client.badCertificateCallback = (cert, host, port) {
          return Platform.isAndroid;
        };
        client.findProxy = (uri) {
          if (AppInfo.httpProxy != null && AppInfo.httpProxy != '') {
            return 'PROXY ${AppInfo.httpProxy}';
          } else {
            return 'DIRECT';
          }
        };
      };
    }
  }

  factory LpHttp() => _instance;

  void configBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  Options _extendOptions(Options options) {
    Map<String, dynamic> headers = {};
    if (AppInfo.token != null) {
      String ts = DateTime.now().millisecondsSinceEpoch.toString();
      String token = AppInfo.token;
      headers['Authorization'] = token;
      headers['LPR-TIMESTAMP'] = ts;
      headers['LPR-SIGNATURE'] = md5str(md5str(token + ts) + token);
    }
    headers['LPR-BRAND'] = AppInfo.brandName;
    headers['Accept-Language'] = AppInfo.locale;
    headers['User-Agent'] = AppInfo.userAgent;
    if (options == null) {
      options = Options(headers: headers);
    } else {
      if (options.headers != null) {
        headers.addAll(options.headers);
      }
      options = options.merge(headers: headers);
    }
    return options;
  }

  void _dealCommonError(Response<Map<String, dynamic>> res) {
    int code = res.data['code'];
    if (code == null || code == 0) {
      return;
    }
    if ([
      LpHttpCode.ACCOUNT_DENIED,
      LpHttpCode.USER_TOKEN_EXPIRED,
      LpHttpCode.NEED_LOGIN
    ].contains(code)) {
      callNativeMethod('gotoLogin');
    }
    String message = res.data['msg'] ?? $i18n('common.msg.svrErr');
    throw LpHttpError(code, message);
  }

  Future<Response<Map<String, dynamic>>> get(
    String path, {
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onReceiveProgress,
  }) async {
    var res = await _dio.get<Map<String, dynamic>>(
      path,
      queryParameters: queryParameters,
      options: _extendOptions(options),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    _dealCommonError(res);
    return res;
  }

  Future<Response<Map<String, dynamic>>> post(
    String path, {
    data,
    Map<String, dynamic> queryParameters,
    Options options,
    CancelToken cancelToken,
    ProgressCallback onSendProgress,
    ProgressCallback onReceiveProgress,
  }) async {
    var res = await _dio.post<Map<String, dynamic>>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: _extendOptions(options),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    _dealCommonError(res);
    return res;
  }
}
