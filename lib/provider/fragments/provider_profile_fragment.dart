import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:provider/auth/change_password_screen.dart';
import 'package:provider/auth/edit_profile_screen.dart';
import 'package:provider/auth/sign_in_screen.dart';
import 'package:provider/components/cached_image_widget.dart';
import 'package:provider/components/theme_selection_dailog.dart';
import 'package:provider/main.dart';
import 'package:provider/models/dashboard_response.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/blog/view/blog_list_screen.dart';
import 'package:provider/provider/components/commission_component.dart';
import 'package:provider/provider/handyman_list_screen.dart';
import 'package:provider/provider/jobRequest/bid_list_screen.dart';
import 'package:provider/provider/packages/package_list_screen.dart';
import 'package:provider/provider/service_address/service_addresses_screen.dart';
import 'package:provider/provider/services/service_list_screen.dart';
import 'package:provider/provider/subscription/subscription_history_screen.dart';
import 'package:provider/provider/taxes/taxes_screen.dart';
import 'package:provider/provider/timeSlots/my_time_slots_screen.dart';
import 'package:provider/provider/wallet/wallet_history_screen.dart';
import 'package:provider/screens/about_us_screen.dart';
import 'package:provider/screens/languages_screen.dart';
import 'package:provider/screens/verify_provider_screen.dart';
import 'package:provider/utils/colors.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:provider/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class ProviderProfileFragment extends StatefulWidget {
  final List<UserData>? list;

  ProviderProfileFragment({this.list});

  @override
  ProviderProfileFragmentState createState() => ProviderProfileFragmentState();
}

class ProviderProfileFragmentState extends State<ProviderProfileFragment> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Observer(
        builder: (_) {
          return AnimatedScrollView(
            listAnimationType: ListAnimationType.FadeIn,
            fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  24.height,
                  if (appStore.userProfileImage.isNotEmpty)
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Container(
                          decoration: boxDecorationDefault(
                            border: Border.all(color: primaryColor, width: 3),
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            decoration: boxDecorationDefault(
                              border: Border.all(color: context.scaffoldBackgroundColor, width: 4),
                              shape: BoxShape.circle,
                            ),
                            child: CachedImageWidget(
                              url: appStore.userProfileImage.validate(),
                              height: 90,
                              fit: BoxFit.cover,
                              circle: true,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 8,
                          child: Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.all(6),
                            decoration: boxDecorationDefault(
                              shape: BoxShape.circle,
                              color: primaryColor,
                              border: Border.all(color: context.cardColor, width: 2),
                            ),
                            child: Icon(AntDesign.edit, color: white, size: 18),
                          ).onTap(() {
                            EditProfileScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade);
                          }),
                        ),
                      ],
                    ),
                  16.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        appStore.userFullName,
                        style: boldTextStyle(color: primaryColor, size: 16),
                      ),
                      4.height,
                      Text(appStore.userEmail, style: secondaryTextStyle()),
                    ],
                  ),
                ],
              ).center().visible(appStore.isLoggedIn),
              if (appStore.earningTypeSubscription && appStore.isPlanSubscribe)
                Column(
                  children: [
                    32.height,
                    Container(
                      decoration: boxDecorationWithRoundedCorners(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        backgroundColor: appStore.isDarkMode ? cardDarkColor : primaryColor.withOpacity(0.1),
                      ),
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(languages.lblCurrentPlan, style: secondaryTextStyle(color: appStore.isDarkMode ? white : appTextSecondaryColor)),
                              Text(languages.lblValidTill, style: secondaryTextStyle(color: appStore.isDarkMode ? white : appTextSecondaryColor)),
                            ],
                          ),
                          16.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(appStore.planTitle.validate().capitalizeFirstLetter(), style: boldTextStyle()),
                              Text(
                                formatDate(appStore.planEndDate.validate(), format: DATE_FORMAT_2),
                                style: boldTextStyle(color: primaryColor),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              16.height,
              if (getStringAsync(DASHBOARD_COMMISSION).validate().isNotEmpty) ...[
                CommissionComponent(
                  commission: Commission.fromJson(jsonDecode(getStringAsync(DASHBOARD_COMMISSION))),
                ),
                16.height,
              ],
              Container(
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(32), topLeft: Radius.circular(32)),
                  backgroundColor: appStore.isDarkMode ? cardDarkColor : cardColor,
                ),
                child: Column(
                  children: [
                    16.height,
                    if (appStore.earningTypeSubscription)
                      SettingItemWidget(
                        leading: Image.asset(services, height: 16, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                        title: languages.lblSubscriptionHistory,
                        trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                        onTap: () async {
                          SubscriptionHistoryScreen().launch(context).then((value) {
                            setState(() {});
                          });
                        },
                      ),
                    if (appStore.earningTypeSubscription) Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    SettingItemWidget(
                      leading: Image.asset(services, height: 16, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                      title: languages.lblServices,
                      trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                      onTap: () {
                        ServiceListScreen().launch(context);
                      },
                    ),
                    Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    if (appStore.userType != USER_TYPE_HANDYMAN)
                      SettingItemWidget(
                        leading: Image.asset(ic_document, height: 16, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                        title: languages.btnVerifyId,
                        trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                        onTap: () {
                          VerifyProviderScreen().launch(context);
                        },
                      ),
                    if (appStore.userType != USER_TYPE_HANDYMAN) Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    if (appStore.userType != USER_TYPE_HANDYMAN)
                      SettingItemWidget(
                        leading: Image.asset(ic_blog, height: 16, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                        title: languages.blogs,
                        trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                        onTap: () {
                          BlogListScreen().launch(context);
                        },
                      ),
                    Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    SettingItemWidget(
                      leading: Image.asset(handyman, height: 16, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                      title: languages.lblAllHandyman,
                      trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                      onTap: () {
                        HandymanListScreen().launch(context);
                      },
                    ),
                    Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    SettingItemWidget(
                      leading: Image.asset(ic_packages, height: 16, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                      title: languages.packages,
                      trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                      onTap: () {
                        PackageListScreen().launch(context);
                      },
                    ),
                    Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    SettingItemWidget(
                      leading: Image.asset(ic_time_slots, height: 14, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                      title: languages.timeSlots,
                      trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                      onTap: () {
                        MyTimeSlotsScreen().launch(context);
                      },
                    ),
                    Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    SettingItemWidget(
                      leading: Image.asset(servicesAddress, height: 16, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                      title: languages.lblServiceAddress,
                      trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                      onTap: () {
                        ServiceAddressesScreen().launch(context);
                      },
                    ),
                    Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    SettingItemWidget(
                      leading: Image.asset(list, height: 16, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                      title: languages.bidList,
                      trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                      onTap: () {
                        BidListScreen().launch(context);
                      },
                    ),
                    Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    SettingItemWidget(
                      leading: Image.asset(ic_tax, height: 18, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                      title: languages.lblTaxes,
                      trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                      onTap: () {
                        TaxesScreen().launch(context);
                      },
                    ),
                    if (appStore.earningTypeCommission)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                          SettingItemWidget(
                            leading: Image.asset(ic_un_fill_wallet, height: 16, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                            title: languages.lblWalletHistory,
                            trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                            onTap: () {
                              WalletHistoryScreen().launch(context);
                            },
                          ),
                        ],
                      ),
                    Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    SettingItemWidget(
                      leading: Image.asset(ic_theme, height: 18, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                      title: languages.appTheme,
                      trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                      onTap: () async {
                        await showInDialog(
                          context,
                          builder: (context) => ThemeSelectionDaiLog(context),
                          contentPadding: EdgeInsets.zero,
                        );
                      },
                    ),
                    Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    SettingItemWidget(
                      leading: Image.asset(language, height: 14, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                      title: languages.language,
                      trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                      onTap: () {
                        LanguagesScreen().launch(context);
                      },
                    ),
                    Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    SettingItemWidget(
                      leading: Image.asset(changePassword, height: 18, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                      title: languages.changePassword,
                      trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                      onTap: () {
                        ChangePasswordScreen().launch(context);
                      },
                    ),
                    Divider(height: 0, indent: 16, endIndent: 16, color: context.dividerColor).visible(appStore.isLoggedIn),
                    SettingItemWidget(
                      leading: Image.asset(about, height: 14, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                      title: languages.lblAbout,
                      trailing: Icon(Icons.chevron_right, color: appStore.isDarkMode ? white : gray.withOpacity(0.8), size: 24),
                      onTap: () {
                        AboutUsScreen().launch(context);
                      },
                    ),
                    Divider(height: 0, thickness: 1, indent: 15.0, endIndent: 15.0, color: context.dividerColor),
                    SettingItemWidget(
                      leading: Image.asset(ic_check_update, height: 16, width: 16, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                      title: languages.lblOptionalUpdateNotify,
                      trailing: Transform.scale(
                        scale: 0.7,
                        child: Switch.adaptive(
                          value: getBoolAsync(UPDATE_NOTIFY, defaultValue: true),
                          onChanged: (v) {
                            setValue(UPDATE_NOTIFY, v);
                            setState(() {});
                          },
                        ).withHeight(24),
                      ),
                    ),
                    8.height,
                  ],
                ),
              ),
              SettingSection(
                title: Text(languages.lblDangerZone.toUpperCase(), style: boldTextStyle(color: redColor)),
                headingDecoration: BoxDecoration(color: redColor.withOpacity(0.08)),
                divider: Offstage(),
                items: [
                  8.height,
                  SettingItemWidget(
                    leading: ic_delete_account.iconImage(size: 20, color: appStore.isDarkMode ? white : gray.withOpacity(0.8)),
                    paddingBeforeTrailing: 4,
                    title: languages.lblDeleteAccount,
                    onTap: () {
                      showConfirmDialogCustom(
                        context,
                        negativeText: languages.lblCancel,
                        positiveText: languages.lblDelete,
                        onAccept: (_) {
                          ifNotTester(context, () {
                            appStore.setLoading(true);

                            deleteAccountCompletely().then((value) async {
                              appStore.setLoading(true);

                              await userService.removeDocument(appStore.uid);
                              await userService.deleteUser();
                              await clearPreferences();

                              toast(value.message);

                              appStore.setLoading(false);

                              push(SignInScreen(), isNewTask: true);
                            }).catchError((e) {
                              appStore.setLoading(false);
                              toast(e.toString());
                            });
                          });
                        },
                        dialogType: DialogType.DELETE,
                        title: languages.lblDeleteAccountConformation,
                      );
                    },
                  ).paddingOnly(left: 4),
                ],
              ),
              16.height,
              TextButton(
                child: Text(languages.logout, style: boldTextStyle(color: primaryColor, size: 16)),
                onPressed: () {
                  appStore.setLoading(false);
                  logout(context);
                },
              ).center().visible(appStore.isLoggedIn),
              VersionInfoWidget(prefixText: 'v', textStyle: secondaryTextStyle()).center(),
              16.height,
            ],
          );
        },
      ),
    );
  }
}
