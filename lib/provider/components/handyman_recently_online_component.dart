import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:provider/main.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constant.dart';

class HandymanRecentlyOnlineComponent extends StatelessWidget {
  final List<String> images;

  const HandymanRecentlyOnlineComponent({Key? key, required this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (images.isEmpty) return SizedBox();

    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(languages.lblRecentlyOnlineHandyman, style: boldTextStyle(size: LABEL_TEXT_SIZE)),
          16.height,
          FlutterImageStack(
            imageList: images,
            totalCount: images.length,
            showTotalCount: false,
            itemRadius: 50,
            itemBorderWidth: 2,
            itemBorderColor: darkGreen,
          ),
        ],
      ),
    );
  }
}
