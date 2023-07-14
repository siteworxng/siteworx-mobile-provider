import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/components/handyman_name_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/base_scaffold_widget.dart';
import '../../components/empty_error_state_widget.dart';

class AssignHandymanScreen extends StatefulWidget {
  final int? bookingId;
  final Function? onUpdate;
  final int? serviceAddressId;

  const AssignHandymanScreen({Key? key, this.onUpdate, required this.bookingId, required this.serviceAddressId}) : super(key: key);

  @override
  _AssignHandymanScreenState createState() => _AssignHandymanScreenState();
}

class _AssignHandymanScreenState extends State<AssignHandymanScreen> {
  ScrollController scrollController = ScrollController();

  Future<List<UserData>>? future;
  List<UserData> handymanList = [];

  int page = 1;
  bool isLastPage = false;

  UserData? userListData;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    future = getAllHandyman(
      page: page,
      serviceAddressId: widget.serviceAddressId,
      userData: handymanList,
      lastPageCallback: (b) {
        isLastPage = b;
      },
    );
  }

  Future<void> _handleAssignHandyman() async {
    if (appStore.isLoading) return;

    showConfirmDialogCustom(
      context,
      title: '${languages.lblAreYouSureYouWantToAssignThisServiceTo} ${userListData!.firstName.validate()}',
      positiveText: languages.lblYes,
      negativeText: languages.lblNo,
      primaryColor: context.primaryColor,
      onAccept: (c) async {
        var request = {
          CommonKeys.id: widget.bookingId,
          CommonKeys.handymanId: [userListData!.id.validate()],
        };

        appStore.setLoading(true);

        await assignBooking(request).then((res) async {
          appStore.setLoading(false);

          widget.onUpdate?.call();

          finish(context);

          toast(res.message);
        }).catchError((e) {
          appStore.setLoading(false);

          toast(e.toString());
        });
      },
    );
  }

  Future<void> _handleAssignToMyself() async {
    if (appStore.isLoading) return;

    showConfirmDialogCustom(
      context,
      title: languages.lblAreYouSureYouWantToAssignToYourself,
      primaryColor: context.primaryColor,
      positiveText: languages.lblYes,
      negativeText: languages.lblCancel,
      onAccept: (c) async {
        var request = {
          CommonKeys.id: widget.bookingId,
          CommonKeys.handymanId: [appStore.userId.validate()],
        };

        appStore.setLoading(true);

        await assignBooking(request).then((res) async {
          appStore.setLoading(false);

          widget.onUpdate!.call();

          finish(context);

          toast(res.message);
        }).catchError((e) {
          appStore.setLoading(false);

          toast(e.toString());
        });
      },
    );
  }

  Widget buildRadioListTile({required UserData userData}) {
    return RadioListTile<UserData>(
      value: userData,
      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      controlAffinity: ListTileControlAffinity.trailing,
      groupValue: userListData,
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CachedImageWidget(
            url: userData.profileImage!.isNotEmpty ? userData.profileImage.validate() : "",
            height: 60,
            fit: BoxFit.cover,
            circle: true,
          ),
          16.width,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Marquee(
                child: HandymanNameWidget(
                  size: 14,
                  name: userData.displayName.validate(),
                  isHandymanAvailable: userData.isHandymanAvailable,
                ),
              ),
              if (userData.handymanType.validate().isNotEmpty) 4.height,
              if (userData.handymanType.validate().isNotEmpty)
                Text(
                  "${userData.handymanType.validate()}",
                  style: secondaryTextStyle(),
                ),
              4.height,
              if (userData.designation.validate().isNotEmpty)
                Text(
                  "${userData.designation.validate()}",
                  style: secondaryTextStyle(),
                )
              else
                Text(
                  "${languages.lblMemberSince} ${DateTime.parse(userData.createdAt.validate()).year}",
                  style: secondaryTextStyle(),
                ),
            ],
          ).flexible(),
        ],
      ),
      toggleable: false,
      onChanged: (value) {
        if (userData.isHandymanAvailable.validate()) {
          if (userListData == value) {
            userListData = null;
            setState(() {});
          } else {
            userListData = value;
            setState(() {});
          }
        } else {
          Fluttertoast.cancel();
          toast(languages.lblHandymanIsOffline);
        }
      },
      activeColor: primaryColor,
      selected: true,
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: languages.lblAssignHandyman,
      body: Stack(
        children: [
          SnapHelperWidget<List<UserData>>(
            future: future,
            loadingWidget: LoaderWidget(),
            onSuccess: (snap) {
              return AnimatedListView(
                controller: scrollController,
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                listAnimationType: ListAnimationType.FadeIn,
                fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                slideConfiguration: SlideConfiguration(verticalOffset: 400),
                padding: EdgeInsets.only(top: 8, bottom: 90),
                itemCount: snap.length,
                emptyWidget: NoDataWidget(
                  title: languages.noHandymanAvailable,
                  imageWidget: EmptyStateWidget(),
                ),
                onNextPage: () {
                  if (!isLastPage) {
                    page++;
                    appStore.setLoading(true);

                    init();
                    setState(() {});
                  }
                },
                itemBuilder: (BuildContext context, index) {
                  return Column(
                    children: [
                      buildRadioListTile(userData: snap[index]).paddingOnly(bottom: 2, top: 2),
                      Divider(endIndent: 16.0, indent: 16.0, height: 0, color: context.dividerColor),
                    ],
                  );
                },
                onSwipeRefresh: () async {
                  page = 1;

                  init();
                  setState(() {});

                  return await 2.seconds.delay;
                },
                disposeScrollController: false,
              );
            },
            errorBuilder: (error) {
              return NoDataWidget(
                title: error,
                imageWidget: ErrorStateWidget(),
                retryText: languages.reload,
                onRetry: () {
                  page = 1;
                  appStore.setLoading(true);

                  init();
                  setState(() {});
                },
              );
            },
          ),
          Positioned(
            bottom: 16,
            right: 16,
            left: 16,
            child: Row(
              children: [
                AppButton(
                  onTap: () {
                    _handleAssignToMyself();
                  },
                  width: context.width(),
                  shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
                  color: context.scaffoldBackgroundColor,
                  elevation: 0,
                  textColor: context.primaryColor,
                  text: languages.lblAssignToMyself,
                ).expand(),
                if (userListData != null) 16.width,
                if (userListData != null)
                  AppButton(
                    onTap: () {
                      if (userListData != null) {
                        _handleAssignHandyman();
                      } else {
                        toast(languages.lblSelectHandyman);
                      }
                    },
                    color: primaryColor,
                    width: context.width(),
                    text: languages.lblAssign,
                  ).expand(),
              ],
            ),
          ),
          Observer(
            builder: (context) => LoaderWidget().visible(appStore.isLoading),
          )
        ],
      ),
    );
  }
}
