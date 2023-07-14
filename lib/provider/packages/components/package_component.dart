import 'package:flutter/material.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/components/price_widget.dart';
import 'package:provider/components/view_all_label_component.dart';
import 'package:provider/main.dart';
import 'package:provider/models/Package_response.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/images.dart';
import '../../services/components/package_info_bottom_sheet.dart';

class PackageComponent extends StatefulWidget {
  final List<PackageData> servicePackage;

  PackageComponent({required this.servicePackage});

  @override
  _PackageComponentState createState() => _PackageComponentState();
}

class _PackageComponentState extends State<PackageComponent> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.servicePackage.isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ViewAllLabel(
          label: languages.packageService,
          list: [],
          onTap: () {
            //
          },
        ).paddingSymmetric(horizontal: 16),
        ListView.builder(
          shrinkWrap: true,
          itemCount: widget.servicePackage.length,
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (_, i) {
            PackageData data = widget.servicePackage[i];

            return Container(
              width: context.width(),
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.all(8),
              decoration: boxDecorationWithRoundedCorners(
                borderRadius: radius(),
                backgroundColor: context.cardColor,
                border: appStore.isDarkMode ? Border.all(color: context.dividerColor) : null,
              ),
              child: Row(
                children: [
                  CachedImageWidget(
                    url: data.imageAttachments.validate().isNotEmpty ? data.imageAttachments!.first.validate() : "",
                    height: 60,
                    fit: BoxFit.cover,
                    radius: defaultRadius,
                  ),
                  16.width,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(data.name.validate(), style: boldTextStyle()),
                      8.height,
                      PriceWidget(
                        price: data.price.validate(),
                        hourlyTextColor: Colors.white,
                        size: 14,
                      ),
                    ],
                  ).expand(),
                  ic_info.iconImage(size: 25),
                ],
              ).onTap(() {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  isScrollControlled: true,
                  isDismissible: true,
                  shape: RoundedRectangleBorder(borderRadius: radiusOnly(topLeft: defaultRadius, topRight: defaultRadius)),
                  builder: (_) {
                    return DraggableScrollableSheet(
                      initialChildSize: 0.50,
                      minChildSize: 0.2,
                      maxChildSize: 1,
                      builder: (context, scrollController) => PackageInfoComponent(packageData: data, scrollController: scrollController, isFromServiceDetail: true),
                    );
                  },
                );
              }),
            );
          },
        )
      ],
    );
  }
}
