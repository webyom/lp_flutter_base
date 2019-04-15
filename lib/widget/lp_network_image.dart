import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'lp_loading.dart';

class LpNetworkImage extends StatelessWidget {
  final String url;

  LpNetworkImage(
    this.url, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => Center(
            child: Container(
              width: 40.0,
              height: 80.0,
              padding: EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
              child: LpLoadingIcon(
                brightness: Brightness.dark,
              ),
            ),
          ),
      errorWidget: (context, url, error) => Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
              child: Image.asset(
                'assets/images/network_image_break.png',
                width: 90.0,
              ),
            ),
          ),
    );
  }
}
