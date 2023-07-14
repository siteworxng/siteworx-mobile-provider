import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

@Deprecated('Please use NoDataWidget instead of BackgroundComponent')
class BackgroundComponent extends StatelessWidget {
  final String? image;
  final String? text;
  final String? subTitle;
  final double? size;

  BackgroundComponent({this.image, this.text, this.subTitle, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.height(),
      width: context.width(),
      child: NoDataWidget(
        image: image,
        title: text,
        imageSize: Size(150, 150),
        subTitle: subTitle,
      ),
    );
  }
}
