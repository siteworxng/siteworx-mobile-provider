import 'package:flutter/material.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/components/handyman_add_update_screen.dart';
import 'package:provider/components/handyman_name_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/screens/chat/user_chat_screen.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:provider/utils/images.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class HandymanWidget extends StatefulWidget {
  final double width;
  final UserData? data;
  final Function? onUpdate;

  HandymanWidget({required this.width, this.data, this.onUpdate});

  @override
  State<HandymanWidget> createState() => _HandymanWidgetState();
}

class _HandymanWidgetState extends State<HandymanWidget> {
  Future<void> changeStatus(int? id, int status) async {
    appStore.setLoading(true);

    Map request = {CommonKeys.id: id, UserKeys.status: status};

    await updateHandymanStatus(request).then((value) {
      appStore.setLoading(false);

      toast(value.message.toString(), print: true);

      setState(() {});
    }).catchError((e) {
      appStore.setLoading(false);

      toast(e.toString(), print: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: widget.width,
          decoration: boxDecorationWithRoundedCorners(borderRadius: radius(), backgroundColor: appStore.isDarkMode ? context.scaffoldBackgroundColor : white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: radius(),
                  backgroundColor: primaryColor.withOpacity(0.2),
                ),
                child: CachedImageWidget(
                  url: widget.data!.profileImage!.isNotEmpty ? widget.data!.profileImage.validate() : '',
                  width: context.width(),
                  height: 110,
                  fit: BoxFit.cover,
                ).cornerRadiusWithClipRRectOnly(topRight: defaultRadius.toInt(), topLeft: defaultRadius.toInt()),
              ),
              Column(
                children: [
                  HandymanNameWidget(
                    name: widget.data!.displayName.validate(),
                    isHandymanAvailable: widget.data!.isHandymanAvailable,
                    size: 14,
                  ).center(),
                  16.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.data!.contactNumber.validate().isNotEmpty)
                        TextIcon(
                          onTap: () {
                            launchCall(widget.data!.contactNumber.validate());
                          },
                          prefix: Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: primaryColor.withOpacity(0.1),
                            ),
                            child: Image.asset(calling, color: primaryColor, height: 14, width: 14),
                          ),
                        ),
                      if (widget.data!.email.validate().isNotEmpty)
                        TextIcon(
                          onTap: () {
                            launchMail(widget.data!.email.validate());
                          },
                          prefix: Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: primaryColor.withOpacity(0.1),
                            ),
                            child: ic_message.iconImage(size: 14, color: primaryColor),
                          ),
                        ),
                      if (widget.data!.contactNumber.validate().isNotEmpty)
                        TextIcon(
                          onTap: () async {
                            toast(languages.pleaseWaitWhileWeLoadChatDetails);
                            UserData? user = await userService.getUserNull(email: widget.data!.email.validate());
                            if (user != null) {
                              Fluttertoast.cancel();
                              UserChatScreen(receiverUser: user).launch(context);
                            } else {
                              Fluttertoast.cancel();
                              toast("${widget.data!.firstName.validate()} ${languages.isNotAvailableForChat}");
                            }
                          },
                          prefix: Container(
                            padding: EdgeInsets.all(8),
                            decoration: boxDecorationWithRoundedCorners(
                              boxShape: BoxShape.circle,
                              backgroundColor: primaryColor.withOpacity(0.1),
                            ),
                            child: Image.asset(textMsg, color: primaryColor, height: 14, width: 14),
                          ),
                        ),
                    ],
                  ),
                ],
              ).paddingSymmetric(vertical: 16),
            ],
          ),
        ).onTap(() {
          HandymanAddUpdateScreen(
            userType: USER_TYPE_HANDYMAN,
            data: widget.data,
            onUpdate: () {
              widget.onUpdate?.call();
            },
          ).launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
        }, borderRadius: radius()),
        Positioned(
          right: 8,
          top: 8,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: boxDecorationWithRoundedCorners(
              boxShape: BoxShape.circle,
              backgroundColor: context.cardColor,
            ),
            alignment: Alignment.center,
            child: !widget.data!.isActive ? Image.asset(block, width: 18, height: 18) : Image.asset(unBlock, width: 18, height: 18),
          ).onTap(() {
            ifNotTester(context, () {
              if (!widget.data!.isActive) {
                changeStatus(widget.data!.id, 1);
              } else {
                changeStatus(widget.data!.id, 0);
              }
              widget.data!.isActive = !widget.data!.isActive;
            });
            setState(() {});
          }),
        )
      ],
    );
  }
}
