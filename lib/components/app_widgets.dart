import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:provider/components/spin_kit_chasing_dots.dart';
import 'package:provider/main.dart';
import 'package:provider/models/booking_list_response.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/common.dart';

Widget placeHolderWidget({String? placeHolderImage, double? height, double? width, BoxFit? fit, AlignmentGeometry? alignment}) {
  return PlaceHolderWidget(
    height: height,
    width: width,
    alignment: alignment ?? Alignment.center,
  );
}

String commonPrice(num price) {
  var formatter = NumberFormat('#,##,000.00');
  return formatter.format(price);
}

class LoaderWidget extends StatelessWidget {
  final double? size;

  LoaderWidget({this.size});

  @override
  Widget build(BuildContext context) {
    return SpinKitChasingDots(color: primaryColor, size: size ?? 50);
  }
}

Widget aboutCustomerWidget({BuildContext? context, BookingData? bookingDetail}) {
  return Row(
    children: [
      Text(languages.lblAboutCustomer, style: boldTextStyle(size: LABEL_TEXT_SIZE)).expand(),
      if (bookingDetail!.canCustomerContact)
        Align(
          alignment: Alignment.topRight,
          child: AppButton(
            child: Text(languages.lblGetDirection, style: boldTextStyle(color: primaryColor, size: 12)),
            shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context!.dividerColor)),
            padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
            elevation: 0,
            enableScaleAnimation: false,
            onTap: () async {
              if (isAndroid) {
                final AndroidIntent intent = AndroidIntent(
                  action: 'action_view',
                  data: 'google.navigation:q=${bookingDetail.address.validate()}',
                  package: 'package:com.google.android.apps.maps',
                );
                await intent.launch();
              } else {
                commonLaunchUrl('$GOOGLE_MAP_PREFIX${Uri.encodeFull(bookingDetail.address.validate())}', launchMode: LaunchMode.externalApplication);
              }
            },
          ),
        ),
    ],
  );
}
