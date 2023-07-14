import 'dart:convert';
import 'dart:io';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:geocoding/geocoding.dart';
import 'package:provider/auth/auth_user_services.dart';
import 'package:provider/components/html_widget.dart';
import 'package:provider/components/new_update_dialog.dart';
import 'package:provider/main.dart';
import 'package:provider/models/LatLong.dart';
import 'package:provider/models/booking_detail_response.dart';
import 'package:provider/models/extra_charges_model.dart';
import 'package:provider/models/remote_config_data_model.dart';
import 'package:provider/models/service_model.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:html/parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/configuration_response.dart';
import '../models/tax_list_response.dart';

//region App Default Settings
void defaultSettings() {
  passwordLengthGlobal = 6;
  appButtonBackgroundColorGlobal = primaryColor;
  defaultRadius = 12;
  defaultAppButtonTextColorGlobal = Colors.white;
  defaultElevation = 0;
  defaultBlurRadius = 0;
  defaultSpreadRadius = 0;
  defaultAppButtonRadius = defaultRadius;
  defaultAppButtonElevation = 0;
  textBoldSizeGlobal = 14;
  textPrimarySizeGlobal = 14;
  textSecondarySizeGlobal = 12;
}
//endregion

//region Set User Values when user is logged In
Future<void> setLoginValues() async {
  if (appStore.isLoggedIn) {
    await appStore.setUserId(getIntAsync(USER_ID), isInitializing: true);
    await appStore.setFirstName(getStringAsync(FIRST_NAME), isInitializing: true);
    await appStore.setLastName(getStringAsync(LAST_NAME), isInitializing: true);
    await appStore.setUserEmail(getStringAsync(USER_EMAIL), isInitializing: true);
    await appStore.setUserName(getStringAsync(USERNAME), isInitializing: true);
    await appStore.setContactNumber(getStringAsync(CONTACT_NUMBER), isInitializing: true);
    await appStore.setUserProfile(getStringAsync(PROFILE_IMAGE), isInitializing: true);
    await appStore.setCountryId(getIntAsync(COUNTRY_ID), isInitializing: true);
    await appStore.setStateId(getIntAsync(STATE_ID), isInitializing: true);
    await appStore.set24HourFormat(getBoolAsync(HOUR_FORMAT_STATUS), isInitializing: true);
    await appStore.setUId(getStringAsync(UID), isInitializing: true);
    await appStore.setCityId(getIntAsync(CITY_ID), isInitializing: true);
    await appStore.setUserType(getStringAsync(USER_TYPE), isInitializing: true);
    await appStore.setServiceAddressId(getIntAsync(SERVICE_ADDRESS_ID), isInitializing: true);
    await appStore.setProviderId(getIntAsync(PROVIDER_ID), isInitializing: true);

    await appStore.setCurrencyCode(getStringAsync(CURRENCY_COUNTRY_CODE), isInitializing: true);
    await appStore.setCurrencyCountryId(getStringAsync(CURRENCY_COUNTRY_ID), isInitializing: true);
    await appStore.setCurrencySymbol(getStringAsync(CURRENCY_COUNTRY_SYMBOL), isInitializing: true);
    await appStore.setCreatedAt(getStringAsync(CREATED_AT), isInitializing: true);
    await appStore.setTotalBooking(getIntAsync(TOTAL_BOOKING), isInitializing: true);
    await appStore.setCompletedBooking(getIntAsync(COMPLETED_BOOKING), isInitializing: true);

    await appStore.setToken(getStringAsync(TOKEN), isInitializing: true);

    await appStore.setTester(getBoolAsync(IS_TESTER), isInitializing: true);
    await appStore.setPrivacyPolicy(getStringAsync(PRIVACY_POLICY), isInitializing: true);
    await appStore.setTermConditions(getStringAsync(TERM_CONDITIONS), isInitializing: true);
    await appStore.setInquiryEmail(getStringAsync(INQUIRY_EMAIL), isInitializing: true);
    await appStore.setHelplineNumber(getStringAsync(HELPLINE_NUMBER), isInitializing: true);
    await appStore.setCategoryBasedPackageService(getBoolAsync(CATEGORY_BASED_SELECT_PACKAGE_SERVICE), isInitializing: true);
    await appStore.setPlayerId(getStringAsync(PLAYERID), isInitializing: true);

    await setSaveSubscription();

    await appStore.setDesignation(getStringAsync(DESIGNATION), isInitializing: true);
  }
}

Future<void> setSaveSubscription({int? isSubscribe, String? title, String? identifier, String? endAt}) async {
  await appStore.setPlanTitle(title ?? getStringAsync(PLAN_TITLE), isInitializing: title == null);
  await appStore.setIdentifier(identifier ?? getStringAsync(PLAN_IDENTIFIER), isInitializing: identifier == null);
  await appStore.setPlanEndDate(endAt ?? getStringAsync(PLAN_END_DATE), isInitializing: endAt == null);
  await appStore.setPlanSubscribeStatus(isSubscribe.validate() == 1, isInitializing: isSubscribe == null);
}

//endregion

//region OneSignal Setup
void setOneSignal() async {
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);

  await OneSignal.shared.setAppId(getStringAsync(ONESIGNAL_APP_ID_PROVIDER)).then((value) async {
    OneSignal.shared.setNotificationWillShowInForegroundHandler((OSNotificationReceivedEvent? event) {
      return event?.complete(event.notification);
    });

    OneSignal.shared.disablePush(false);
    OneSignal.shared.consentGranted(true);
    OSDeviceState? osDeviceState = await OneSignal.shared.getDeviceState();
    if (osDeviceState!.hasNotificationPermission) {
      if (appStore.playerId.validate().isEmpty) {
        if (osDeviceState.userId.validate() != appStore.playerId.validate()) {
          updatePlayerId(playerId: osDeviceState.userId.validate());
        }
      }
    } else {
      await OneSignal.shared.promptUserForPushNotificationPermission(fallbackToSettings: true).then((value) async {
        if (value) {
          if (appStore.playerId.validate().isEmpty) {
            if (osDeviceState.userId.validate() != appStore.playerId.validate()) {
              updatePlayerId(playerId: osDeviceState.userId.validate());
            }
          }
        }
      });
    }
    userService.updatePlayerIdInFirebase(email: appStore.userEmail.validate(), playerId: osDeviceState.userId.validate());
  });
}

//endregion

int getRemainingPlanDays() {
  if (appStore.planEndDate.isNotEmpty) {
    var now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    DateTime endAt = DateFormat(DATE_FORMAT_7).parse(appStore.planEndDate);

    return (date.difference(endAt).inDays).abs();
  } else {
    return 0;
  }
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'assets/flag/ic_us.png'),
    LanguageDataModel(id: 2, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'assets/flag/ic_india.png'),
    LanguageDataModel(id: 3, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'assets/flag/ic_ar.png'),
    LanguageDataModel(id: 4, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'assets/flag/ic_fr.png'),
    LanguageDataModel(id: 5, name: 'German', languageCode: 'de', fullLanguageCode: 'de-DE', flag: 'assets/flag/ic_de.png'),
  ];

  /*if (getStringAsync(SERVER_LANGUAGES).isNotEmpty) {
    Iterable it = jsonDecode(getStringAsync(SERVER_LANGUAGES));
    var res = it.map((e) => LanguageOption.fromJson(e)).toList();

    localeLanguageList.clear();

    res.forEach((element) {
      localeLanguageList.add(LanguageDataModel(languageCode: element.id.validate().toString(), flag: element.flagImage, name: element.title));
    });

    return localeLanguageList;
  } else {
    return [
      LanguageDataModel(id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'assets/flag/ic_us.png'),
      LanguageDataModel(id: 2, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'assets/flag/ic_india.png'),
      LanguageDataModel(id: 3, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'assets/flag/ic_ar.png'),
      LanguageDataModel(id: 4, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'assets/flag/ic_fr.png'),
      LanguageDataModel(id: 5, name: 'German', languageCode: 'de', fullLanguageCode: 'de-DE', flag: 'assets/flag/ic_de.png'),
    ];
  }*/
}

InputDecoration inputDecoration(BuildContext context, {Widget? prefixIcon, Widget? prefix, String? hint, Color? fillColor, String? counterText, double? borderRadius}) {
  return InputDecoration(
    contentPadding: EdgeInsets.only(left: 12, bottom: 10, top: 10, right: 10),
    labelText: hint,
    labelStyle: secondaryTextStyle(),
    alignLabelWithHint: true,
    counterText: counterText,
    prefixIcon: prefixIcon,
    prefix: prefix,
    enabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 0.0),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    errorMaxLines: 2,
    border: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    disabledBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: Colors.transparent, width: 0.0),
    ),
    errorStyle: primaryTextStyle(color: Colors.red, size: 12),
    focusedBorder: OutlineInputBorder(
      borderRadius: radius(borderRadius ?? defaultRadius),
      borderSide: BorderSide(color: primaryColor, width: 0.0),
    ),
    filled: true,
    fillColor: fillColor ?? context.cardColor,
  );
}

void setCurrencies({required List<Configurations>? value, List<PaymentSetting>? paymentSetting}) {
  if (value != null) {
    Configurations data = value.firstWhere((element) => element.type == "CURRENCY");

    if (data.country != null) {
      if (data.country!.currencyCode.validate() != appStore.currencyCode) appStore.setCurrencyCode(data.country!.currencyCode.validate());
      if (data.country!.id.toString().validate() != appStore.countryId.toString()) appStore.setCurrencyCountryId(data.country!.id.toString().validate());
      if (data.country!.symbol.validate() != appStore.currencySymbol) appStore.setCurrencySymbol(data.country!.symbol.validate());
    }
    if (paymentSetting != null) {
      setValue(PAYMENT_LIST, PaymentSetting.encode(paymentSetting.validate()));
    }
  }
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

String formatDate(String? dateTime, {String format = DATE_FORMAT_1, bool isFromMicrosecondsSinceEpoch = false, bool isLanguageNeeded = true}) {
  if (isFromMicrosecondsSinceEpoch) {
    return DateFormat(format, isLanguageNeeded ? appStore.selectedLanguageCode : null).format(DateTime.fromMicrosecondsSinceEpoch(dateTime.validate().toInt() * 1000));
  } else {
    return DateFormat(format, isLanguageNeeded ? appStore.selectedLanguageCode : null).format(DateTime.parse(dateTime.validate()));
  }
}

Future<LatLng> getLatLongFromAddress({required String address}) async {
  List<Location> locations = await locationFromAddress(address).catchError((e) {
    throw e.toString();
  });
  return LatLng(latitude: locations.first.latitude.validate(), longitude: locations.first.longitude.validate());
}

Future<void> commonLaunchUrl(String url, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(url), mode: launchMode).catchError((e) {
    toast('Invalid URL: $url');
    throw e;
  });
}

void launchCall(String? url) {
  if (url.validate().isNotEmpty) {
    if (isIOS)
      commonLaunchUrl('tel://' + url!, launchMode: LaunchMode.externalApplication);
    else
      commonLaunchUrl('tel:' + url!, launchMode: LaunchMode.externalApplication);
  }
}

void launchMail(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl('mailto:' + url!, launchMode: LaunchMode.externalApplication);
  }
}

void launchMap(String? url) {
  if (url.validate().isNotEmpty) {
    commonLaunchUrl(GOOGLE_MAP_PREFIX + url!, launchMode: LaunchMode.externalApplication);
  }
}

calculateLatLong(String address) async {
  try {
    List<Location> destinationPlaceMark = await locationFromAddress(address);
    double? destinationLatitude = destinationPlaceMark[0].latitude;
    double? destinationLongitude = destinationPlaceMark[0].longitude;
    List<double?> destinationCoordinatesString = [destinationLatitude, destinationLongitude];
    return destinationCoordinatesString;
  } catch (e) {
    throw errorSomethingWentWrong;
  }
}

bool get isRTL => RTL_LANGUAGES.contains(appStore.selectedLanguageCode);

bool get isCurrencyPositionLeft => getStringAsync(CURRENCY_POSITION, defaultValue: CURRENCY_POSITION_LEFT) == CURRENCY_POSITION_LEFT;

bool get isCurrencyPositionRight => getStringAsync(CURRENCY_POSITION, defaultValue: CURRENCY_POSITION_LEFT) == CURRENCY_POSITION_RIGHT;

bool isTodayAfterDate(DateTime val) => val.isAfter(todayDate);

num hourlyCalculationNew({required int secTime, required num price}) {
  /// Calculating time on based of seconds.
  String time = newCalculateTimer(secTime);

  /// Splitting the time to get the Hour,Minute,Seconds.
  List<String> data = time.split(":");
  String hour = data.first, minute = data[1];
  //String hour = data.first, minute = data[1], seconds = data.last;

  /// Calculating per minute charge for the price [Price is Dynamic].
  String perMinuteCharge = (price / 60).toStringAsFixed(2);

  /// If time is less than a hour then it will calculate the Base Price default.
  if (hour == "00") {
    return (price * 1).toStringAsFixed(2).toDouble();
  }

  ///If the time has passed the hour mark, the minute charge will be calculated.
  else if (hour != "00") {
    String value = (price * hour.toInt()).toStringAsFixed(2);

    ///If the minute after one hour is greater than 00 (i.e. 01:02:00), the 02 minute charge will be calculated and added to the base price.
    if (minute != "00") {
      /// Calculating Minute Charge for the service,
      num minuteCharge = perMinuteCharge.toDouble() * minute.toDouble();

      return value.toDouble() + minuteCharge;
    }

    return value.toDouble();
  }

  return 0.0;
}

String newCalculateTimer(int secTime) {
  int hour = 0, minute = 0, seconds = 0;

  hour = secTime ~/ 3600;

  minute = ((secTime - hour * 3600)) ~/ 60;

  seconds = secTime - (hour * 3600) - (minute * 60);

  String hourLeft = hour.toString().length < 2 ? "0" + hour.toString() : hour.toString();

  String minuteLeft = minute.toString().length < 2 ? "0" + minute.toString() : minute.toString();

  String secondsLeft = seconds.toString().length < 2 ? "0" + seconds.toString() : seconds.toString();

  String result = "$hourLeft:$minuteLeft:$secondsLeft";

  return result;
}

num getHourlyPrice({required int secTime, required num price, required String date}) {
  if (isTodayAfterDate(DateTime.parse(date))) {
    return hourlyCalculationNew(price: price, secTime: secTime);
  } else {
    return hourlyCalculation(price: price, secTime: secTime);
  }
}

num calculateTotalAmount({
  required num servicePrice,
  required int qty,
  required num? serviceDiscountPercent,
  CouponData? couponData,
  ServiceData? detail,
  required List<TaxData>? taxes,
  List<ExtraChargesModel>? extraCharges,
}) {
  if (qty == 0) qty = 1;
  double totalAmount = 0.0;
  double discountPrice = 0.0;
  double taxAmount = 0.0;
  double couponDiscountAmount = 0.0;

  if (couponData != null) {
    if (detail != null) {
      detail.couponId = couponData.id.toString();
      detail.appliedCouponData = couponData;
    }
    if (couponData.discountType == DISCOUNT_TYPE_FIXED) {
      totalAmount = totalAmount - couponData.discount.validate();
      couponDiscountAmount = couponData.discount.validate().toDouble();
    } else {
      totalAmount = totalAmount - ((totalAmount * couponData.discount.validate()) / 100);
      couponDiscountAmount = (couponDiscountAmount);
    }
  }

  taxes.validate().forEach((element) {
    if (isCommissionTypePercent(element.type)) {
      element.totalCalculatedValue = ((servicePrice * qty) * element.value.validate()) / 100;
    } else {
      element.totalCalculatedValue = element.value.validate();
    }
    taxAmount += element.totalCalculatedValue.validate().toDouble();
  });

  if (serviceDiscountPercent.validate() != 0) {
    totalAmount = (servicePrice * qty) - (((servicePrice * qty) * (serviceDiscountPercent!)) / 100);
    discountPrice = servicePrice * qty - totalAmount;
    totalAmount = (servicePrice * qty) - discountPrice - couponDiscountAmount + taxAmount;
  } else {
    totalAmount = (servicePrice * qty) - couponDiscountAmount + taxAmount;
  }

  if (extraCharges.validate().isNotEmpty) {
    totalAmount += extraCharges.sumByDouble((e) => e.total.validate());
  }

  if (detail != null) {
    detail.totalAmount = totalAmount.validate();
    detail.qty = qty.validate();
    detail.discountPrice = discountPrice.validate();
    detail.taxAmount = taxAmount.validate();
    detail.couponDiscountAmount = couponDiscountAmount.validate();
  }

  return totalAmount;
}

String calculateExperience() {
  int exp = 0;

  return exp.toString();
}

bool isCommissionTypePercent(String? type) => type.validate() == COMMISSION_TYPE_PERCENT;

bool get isUserTypeHandyman => appStore.userType == USER_TYPE_HANDYMAN;

bool get isUserTypeProvider => appStore.userType == USER_TYPE_PROVIDER;

void launchUrlCustomTab(String? url) {
  if (url.validate().isNotEmpty) {
    custom_tabs.launch(
      url!,
      customTabsOption: custom_tabs.CustomTabsOption(
        enableDefaultShare: true,
        enableInstantApps: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        toolbarColor: primaryColor,
      ),
    );
  }
}

// Logic For Calculate Time
String calculateTimer(int secTime) {
  //int hour = 0, minute = 0, seconds = 0;
  int hour = 0, minute = 0;

  hour = secTime ~/ 3600;

  minute = ((secTime - hour * 3600)) ~/ 60;

  //seconds = secTime - (hour * 3600) - (minute * 60);

  String hourLeft = hour.toString().length < 2 ? "0" + hour.toString() : hour.toString();

  String minuteLeft = minute.toString().length < 2 ? "0" + minute.toString() : minute.toString();

  String minutes = minuteLeft == '00' ? '01' : minuteLeft;

  String result = "$hourLeft:$minutes";

  return result;
}

num hourlyCalculation({required int secTime, required num price}) {
  num result = 0;

  String time = calculateTimer(secTime);
  String perMinuteCharge = (price / 60).toStringAsFixed(2);

  if (time == "01:00") {
    String value = (price * 1).toStringAsFixed(2);
    result = value.toDouble();
  } else {
    List<String> data = time.split(":");
    if (data.first == "00") {
      String value;
      if (secTime < 60) {
        value = (perMinuteCharge.toDouble() * 1).toStringAsFixed(2);
      } else {
        value = (perMinuteCharge.toDouble() * data.last.toDouble()).toStringAsFixed(2);
      }
      result = value.toDouble();
    } else {
      if (data.first.toInt() > 01 && data.last.toInt() == 00) {
        String value = (price * data.first.toInt()).toStringAsFixed(2);
        result = value.toDouble();
      } else {
        String value = (price * data.first.toInt()).toStringAsFixed(2);
        String extraMinuteCharge = (data.last.toDouble() * perMinuteCharge.toDouble()).toStringAsFixed(2);
        String finalPrice = (value.toDouble() + extraMinuteCharge.toDouble()).toStringAsFixed(2);
        result = finalPrice.toDouble();
      }
    }
  }

  return result.toDouble();
}

Widget subSubscriptionPlanWidget({Color? planBgColor, String? planTitle, String? planSubtitle, String? planButtonTxt, Function? onTap, Color? btnColor}) {
  return Container(
    color: planBgColor,
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(planTitle.validate(), style: boldTextStyle()),
            8.height,
            Text(planSubtitle.validate(), style: secondaryTextStyle()),
          ],
        ).flexible(),
        8.width,
        AppButton(
          child: Text(planButtonTxt.validate(), style: boldTextStyle(color: white)),
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          color: btnColor,
          elevation: 0,
          onTap: () {
            onTap?.call();
          },
        ),
      ],
    ),
  );
}

Brightness getStatusBrightness({required bool val}) {
  return val ? Brightness.light : Brightness.dark;
}

String getPaymentStatusText(String? status, String? method) {
  if (status!.isEmpty) {
    return languages.pending;
  } else if (status == PAID || status == PENDING_BY_ADMINs) {
    return languages.paid;
  } else if (status == PAYMENT_STATUS_ADVANCE) {
    return languages.advancePaid;
  } else if (status == PENDING && method == PAYMENT_METHOD_COD) {
    return languages.pendingApproval;
  } else if (status == PENDING) {
    return languages.pending;
  } else {
    return "";
  }
}

String getReasonText(BuildContext context, String val) {
  if (val == BookingStatusKeys.cancelled) {
    return languages.lblReasonCancelling;
  } else if (val == BookingStatusKeys.rejected) {
    return languages.lblReasonRejecting;
  } else if (val == BookingStatusKeys.failed) {
    return languages.lblFailed;
  }
  return '';
}

Future<bool> get isIqonicProduct async => await getPackageName() == APP_PACKAGE_NAME;

void checkIfLink(BuildContext context, String value, {String? title}) {
  String temp = parseHtmlString(value.validate());
  if (value.validate().isEmpty) return;

  if (temp.startsWith("https") || temp.startsWith("http")) {
    launchUrlCustomTab(temp.validate());
  } else if (temp.validateEmail()) {
    launchMail(temp);
  } else if (temp.validatePhone() || temp.startsWith('+')) {
    launchCall(temp);
  } else {
    HtmlWidget(postContent: value, title: title).launch(context);
  }
}

String buildPaymentStatusWithMethod(String status, String method) {
  return '${getPaymentStatusText(status, method)}${(status == BOOKING_STATUS_PAID || status == PENDING_BY_ADMINs) ? ' by $method' : ''}';
}

Color getRatingBarColor(int rating) {
  if (rating == 1 || rating == 2) {
    return Color(0xFFE80000);
  } else if (rating == 3) {
    return Color(0xFFff6200);
  } else if (rating == 4 || rating == 5) {
    return Color(0xFF73CB92);
  } else {
    return Color(0xFFE80000);
  }
}

Future<FirebaseRemoteConfig> setupFirebaseRemoteConfig() async {
  final FirebaseRemoteConfig remoteConfig = FirebaseRemoteConfig.instance;

  remoteConfig.setConfigSettings(RemoteConfigSettings(fetchTimeout: Duration.zero, minimumFetchInterval: Duration.zero));
  await remoteConfig.fetch();
  await remoteConfig.fetchAndActivate();

  if (remoteConfig.getString(PROVIDER_CHANGE_LOG).validate().isNotEmpty) {
    remoteConfigDataModel = RemoteConfigDataModel.fromJson(jsonDecode(remoteConfig.getString(PROVIDER_CHANGE_LOG)));

    setValue(PROVIDER_CHANGE_LOG, remoteConfig.getString(PROVIDER_CHANGE_LOG));

    if (isIOS) {
      await setValue(HAS_IN_REVIEW, remoteConfig.getBool(HAS_IN_APP_STORE_REVIEW));
    } else if (isAndroid) {
      await setValue(HAS_IN_REVIEW, remoteConfig.getBool(HAS_IN_PLAY_STORE_REVIEW));
    }
  }

  return remoteConfig;
}

void ifNotTester(BuildContext context, VoidCallback callback) {
  if (!appStore.isTester) {
    callback.call();
  } else {
    toast(languages.lblUnAuthorized);
  }
}

void forceUpdate(BuildContext context) async {
  showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    barrierDismissible: !remoteConfigDataModel.isForceUpdate.validate(),
    builder: (_) {
      return NewUpdateDialog();
    },
  );
}

Future<void> showForceUpdateDialog(BuildContext context) async {
  if (getBoolAsync(UPDATE_NOTIFY, defaultValue: true)) {
    getPackageInfo().then((value) {
      if (isAndroid && remoteConfigDataModel.android != null && remoteConfigDataModel.android!.versionCode.validate().toInt() > value.versionCode.validate().toInt()) {
        forceUpdate(context);
      } else if (isIOS && remoteConfigDataModel.iOS != null && remoteConfigDataModel.iOS!.versionCode.validate() != value.versionCode.validate()) {
        forceUpdate(context);
      }
    });
  }
}

Widget mobileNumberInfoWidget(BuildContext context) {
  return RichTextWidget(
    list: [
      TextSpan(text: '${languages.lblAddYourCountryCode}', style: secondaryTextStyle()),
      TextSpan(text: ' "91-", "236-" ', style: boldTextStyle(size: 12)),
      TextSpan(
        text: ' (${languages.lblHelp})',
        style: boldTextStyle(size: 12, color: primaryColor),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            launchUrlCustomTab("https://countrycode.org/");
          },
      ),
    ],
  );
}

Future<List<File>> getMultipleImageSource({bool isCamera = true}) async {
  final pickedImage = await ImagePicker().pickMultiImage();
  return pickedImage.map((e) => File(e.path)).toList();
}

Future<File> getCameraImage({bool isCamera = true}) async {
  final pickedImage = await ImagePicker().pickImage(source: isCamera ? ImageSource.camera : ImageSource.gallery);
  return File(pickedImage!.path);
}

String getDateInString({required DateTimeRange dateTime, String? format}) {
  if (dateTime.end.isToday)
    return languages.today;
  else if (dateTime.start.isTomorrow)
    return languages.tomorrow;
  else if (dateTime.start.isYesterday)
    return languages.yesterday;
  else {
    return "${formatDate(dateTime.start.toString(), format: format.validate())} - ${formatDate(dateTime.end.toString(), format: format.validate())}'s";
  }
}

Future<bool> compareValuesInSharedPreference(String key, dynamic value) async {
  bool status = false;
  if (value is String) {
    status = getStringAsync(key) == value;
  } else if (value is bool) {
    status = getBoolAsync(key) == value;
  } else if (value is int) {
    status = getIntAsync(key) == value;
  } else if (value is double) {
    status = getDoubleAsync(key) == value;
  }

  if (!status) {
    await setValue(key, value);
  }
  return status;
}
