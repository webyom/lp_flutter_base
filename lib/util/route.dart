import 'package:flutter/material.dart';
import 'package:hybrid_stack_manager/hybrid_stack_manager_plugin.dart';

export 'package:hybrid_stack_manager/hybrid_stack_manager_plugin.dart' show HybridStackManagerPlugin, RouterOption, Router;

class AppRoute {
  static final GlobalKey globalKeyForRouter = GlobalKey(debugLabel: '[KWLM]');

  static void init(FlutterWidgetHandler routerWidgetHandler) {
    Router.sharedInstance().globalKeyForRouter = globalKeyForRouter;
    Router.sharedInstance().routerWidgetHandler = routerWidgetHandler;
  }

  static void popCurPage({
    bool animated = true,
  }) {
    HybridStackManagerPlugin.hybridStackManagerPlugin.popCurPage(
      animated: animated,
    );
  }

  static void openUrl({
    @required String url,
    Map query,
    Map params,
    bool animated,
  }) {
    String openUrl;
    final openQuery = query ?? {};
    if (url.startsWith('/')) {
      openUrl = 'hrd:/' + url;
    } else if (url.startsWith('http')) {
      openUrl = 'hrd://native/web_common';
      openQuery['url'] = url;
    } else {
      openUrl = url;
    }
    HybridStackManagerPlugin.hybridStackManagerPlugin.openUrlFromNative(
      url: openUrl,
      query: openQuery,
      params: params,
      animated: animated,
    );
  }
}
