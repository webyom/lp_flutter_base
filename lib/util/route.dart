import 'package:flutter/material.dart';
import 'package:hybrid_stack_manager/hybrid_stack_manager_plugin.dart';

export 'package:hybrid_stack_manager/hybrid_stack_manager_plugin.dart' show HybridStackManagerPlugin, RouterOption;

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
    String url,
    Map query,
    Map params,
    bool animated,
  }) {
    HybridStackManagerPlugin.hybridStackManagerPlugin.openUrlFromNative(
      url: url,
      query: query,
      params: params,
      animated: animated,
    );
  }
}
