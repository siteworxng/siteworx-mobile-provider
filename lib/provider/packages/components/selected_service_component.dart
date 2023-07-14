import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/service_model.dart';
import 'package:provider/utils/extensions/context_ext.dart';
import 'package:nb_utils/nb_utils.dart';

class SelectedServiceComponent extends StatefulWidget {
  final Function(ServiceData)? onItemRemove;

  SelectedServiceComponent({this.onItemRemove});

  @override
  _SelectedServiceComponentState createState() => _SelectedServiceComponentState();
}

class _SelectedServiceComponentState extends State<SelectedServiceComponent> {
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
    if (appStore.selectedServiceList.isEmpty) Offstage();

    return Observer(builder: (_) {
      return HorizontalList(
        crossAxisAlignment: WrapCrossAlignment.start,
        itemCount: appStore.selectedServiceList.length,
        runSpacing: 16,
        spacing: 16,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (_, i) {
          ServiceData data = appStore.selectedServiceList[i];

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: context.width() * 0.35,
                decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), backgroundColor: context.cardColor),
                child: Column(
                  children: [
                    CachedImageWidget(
                      url: data.imageAttachments!.isNotEmpty ? data.imageAttachments!.first.validate() : "",
                      height: 70,
                      width: context.width() * 0.35,
                      fit: BoxFit.cover,
                      radius: defaultRadius,
                    ),
                    16.height,
                    Marquee(child: Text(data.name.validate(), style: boldTextStyle(size: 14))).paddingSymmetric(horizontal: 8),
                    12.height,
                  ],
                ),
              ),
              Positioned(
                top: -22,
                right: -20,
                child: IconButton(
                  icon: Icon(Icons.dangerous_outlined, color: Colors.red),
                  onPressed: () {
                    showConfirmDialogCustom(
                      context,
                      dialogType: DialogType.CONFIRMATION,
                      title: languages.confirmationRemovePackage,
                      positiveText: context.translate.lblYes,
                      negativeText: context.translate.lblNo,
                      onAccept: (p0) {
                        appStore.removeSelectedPackageService(data);
                        // selectedServiceList.remove(selectedServiceList.firstWhere((element) => element.id == data.id));
                        widget.onItemRemove?.call(data);
                        setState(() {});
                      },
                    );
                  },
                ),
              )
            ],
          );
        },
      );
    });
  }
}
