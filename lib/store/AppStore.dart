import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/locale/applocalizations.dart';
import 'package:provider/locale/base_language.dart';
import 'package:provider/main.dart';
import 'package:provider/models/service_model.dart';
import 'package:provider/utils/colors.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';

part 'AppStore.g.dart';

class AppStore = _AppStore with _$AppStore;

abstract class _AppStore with Store {
  @observable
  bool isLoggedIn = false;

  @observable
  bool isDarkMode = false;

  @observable
  bool isLoading = false;

  @observable
  bool isRememberMe = false;

  @observable
  bool isTester = false;

  @observable
  bool isCategoryWisePackageService = false;

  @observable
  String selectedLanguageCode = DEFAULT_LANGUAGE;

  @observable
  String userProfileImage = '';

  @observable
  String currencySymbol = '';

  @observable
  String currencyCode = '';

  @observable
  String currencyCountryId = '';

  @observable
  String uid = '';

  @observable
  bool isPlanSubscribe = false;

  @observable
  String planTitle = '';

  @observable
  String identifier = '';

  @observable
  String planEndDate = '';

  @observable
  num notificationCount = -1;

  @observable
  String userFirstName = '';

  @observable
  String userLastName = '';

  @observable
  String userContactNumber = '';

  @observable
  String userEmail = '';

  @observable
  String userName = '';

  @observable
  String token = '';

  @observable
  int countryId = 0;

  @observable
  int stateId = 0;

  @observable
  int cityId = 0;

  @observable
  String address = '';

  @observable
  String playerId = '';

  @observable
  String designation = '';

  @computed
  String get userFullName => '$userFirstName $userLastName'.trim();

  @observable
  int? userId = -1;

  @observable
  int? providerId = -1;

  @observable
  int serviceAddressId = -1;

  @observable
  String userType = '';

  @observable
  String privacyPolicy = '';

  @observable
  String termConditions = '';

  @observable
  String inquiryEmail = '';

  @observable
  String helplineNumber = '';

  @observable
  int initialAdCount = 0;

  @observable
  int totalBooking = 0;

  @observable
  int completedBooking = 0;

  @observable
  String createdAt = '';

  @observable
  String earningType = '';

  @observable
  int handymanAvailability = 0;

  @observable
  List<ServiceData> selectedServiceList = ObservableList.of([]);

  @observable
  bool is24HourFormat = true;

  @computed
  bool get earningTypeCommission => earningType == EARNING_TYPE_COMMISSION;

  @computed
  bool get earningTypeSubscription => earningType == EARNING_TYPE_SUBSCRIPTION;

  @action
  Future<void> setEarningType(String val, {bool isInitializing = false}) async {
    earningType = val;
    if (!isInitializing) await compareValuesInSharedPreference(EARNING_TYPE, val);
  }

  @action
  Future<void> setTester(bool val, {bool isInitializing = false}) async {
    isTester = val;
    if (!isInitializing) await setValue(IS_TESTER, isTester);
  }

  @action
  Future<void> addSelectedPackageService(ServiceData val, {bool isInitializing = false}) async {
    selectedServiceList.add(val);
    log('Selected Service length: ${selectedServiceList.length}');
  }

  @action
  Future<void> addAllSelectedPackageService(List<ServiceData> val, {bool isInitializing = false}) async {
    selectedServiceList.addAll(val);
    log('Selected All Service length: ${selectedServiceList.length}');
  }

  @action
  Future<void> removeSelectedPackageService(ServiceData val, {bool isInitializing = false}) async {
    selectedServiceList.remove(selectedServiceList.firstWhere((element) => element.id == val.id));
    log('After remove Selected Service length: ${selectedServiceList.length}');
  }

  @action
  Future<void> setCategoryBasedPackageService(bool val, {bool isInitializing = false}) async {
    isCategoryWisePackageService = val;
    if (!isInitializing) await setValue(CATEGORY_BASED_SELECT_PACKAGE_SERVICE, isCategoryWisePackageService);
  }

  @action
  Future<void> setUserProfile(String val, {bool isInitializing = false}) async {
    userProfileImage = val;
    if (!isInitializing) await setValue(PROFILE_IMAGE, val);
  }

  @action
  Future<void> set24HourFormat(bool val, {bool isInitializing = false}) async {
    is24HourFormat = val;
    if (!isInitializing) await setValue(HOUR_FORMAT_STATUS, val);
  }

  @action
  Future<void> setNotificationCount(num val) async {
    notificationCount = val;
  }

  @action
  Future<void> setPlayerId(String val, {bool isInitializing = false}) async {
    playerId = val;
    if (!isInitializing) await setValue(PLAYERID, val);
  }

  @action
  Future<void> setToken(String val, {bool isInitializing = false}) async {
    token = val;
    if (!isInitializing) await setValue(TOKEN, val);
  }

  @action
  Future<void> setCountryId(int val, {bool isInitializing = false}) async {
    countryId = val;
    if (!isInitializing) await setValue(COUNTRY_ID, val);
  }

  @action
  Future<void> setStateId(int val, {bool isInitializing = false}) async {
    stateId = val;
    if (!isInitializing) await setValue(STATE_ID, val);
  }

  @action
  Future<void> setCurrencySymbol(String val, {bool isInitializing = false}) async {
    currencySymbol = val;
    if (!isInitializing) await compareValuesInSharedPreference(CURRENCY_COUNTRY_SYMBOL, val);
  }

  @action
  Future<void> setCurrencyCode(String val, {bool isInitializing = false}) async {
    currencyCode = val;
    if (!isInitializing) await compareValuesInSharedPreference(CURRENCY_COUNTRY_CODE, val);
  }

  @action
  Future<void> setCurrencyCountryId(String val, {bool isInitializing = false}) async {
    currencyCountryId = val;
    if (!isInitializing) await compareValuesInSharedPreference(CURRENCY_COUNTRY_ID, val);
  }

  @action
  Future<void> setCityId(int val, {bool isInitializing = false}) async {
    cityId = val;
    if (!isInitializing) await setValue(CITY_ID, val);
  }

  @action
  Future<void> setUId(String val, {bool isInitializing = false}) async {
    uid = val;
    if (!isInitializing) await setValue(UID, val);
  }

  @action
  Future<void> setPlanSubscribeStatus(bool val, {bool isInitializing = false}) async {
    isPlanSubscribe = val && planTitle.isNotEmpty;
    if (!isInitializing) await setValue(IS_PLAN_SUBSCRIBE, val);
  }

  @action
  Future<void> setPlanTitle(String val, {bool isInitializing = false}) async {
    planTitle = val;
    if (!isInitializing) await setValue(PLAN_TITLE, val);
  }

  @action
  Future<void> setIdentifier(String val, {bool isInitializing = false}) async {
    identifier = val;
    if (!isInitializing) await setValue(PLAN_IDENTIFIER, val);
  }

  @action
  Future<void> setPlanEndDate(String val, {bool isInitializing = false}) async {
    planEndDate = val;
    if (!isInitializing) await setValue(PLAN_END_DATE, val);
  }

  @action
  Future<void> setUserId(int val, {bool isInitializing = false}) async {
    userId = val;
    if (!isInitializing) await setValue(USER_ID, val);
  }

  @action
  Future<void> setDesignation(String val, {bool isInitializing = false}) async {
    designation = val;
    if (!isInitializing) await setValue(DESIGNATION, val);
  }

  @action
  Future<void> setUserType(String val, {bool isInitializing = false}) async {
    userType = val;
    if (!isInitializing) await setValue(USER_TYPE, val);
  }

  @action
  Future<void> setPrivacyPolicy(String val, {bool isInitializing = false}) async {
    privacyPolicy = val;
    if (!isInitializing) await compareValuesInSharedPreference(PRIVACY_POLICY, val);
  }

  @action
  Future<void> setTermConditions(String val, {bool isInitializing = false}) async {
    termConditions = val;
    if (!isInitializing) await compareValuesInSharedPreference(TERM_CONDITIONS, val);
  }

  @action
  Future<void> setInquiryEmail(String val, {bool isInitializing = false}) async {
    inquiryEmail = val;
    if (!isInitializing) await compareValuesInSharedPreference(INQUIRY_EMAIL, val);
  }

  @action
  Future<void> setHelplineNumber(String val, {bool isInitializing = false}) async {
    helplineNumber = val;
    if (!isInitializing) await compareValuesInSharedPreference(HELPLINE_NUMBER, val);
  }

  @action
  Future<void> setTotalBooking(int val, {bool isInitializing = false}) async {
    totalBooking = val;
    if (!isInitializing) await setValue(TOTAL_BOOKING, val);
  }

  @action
  Future<void> setCompletedBooking(int val, {bool isInitializing = false}) async {
    completedBooking = val;
    if (!isInitializing) await setValue(COMPLETED_BOOKING, val);
  }

  @action
  Future<void> setCreatedAt(String val, {bool isInitializing = false}) async {
    createdAt = val;
    if (!isInitializing) await setValue(CREATED_AT, val);
  }

  @action
  Future<void> setProviderId(int val, {bool isInitializing = false}) async {
    providerId = val;
    if (!isInitializing) await setValue(PROVIDER_ID, val);
  }

  @action
  Future<void> setServiceAddressId(int val, {bool isInitializing = false}) async {
    serviceAddressId = val;
    if (!isInitializing) await setValue(SERVICE_ADDRESS_ID, val);
  }

  @action
  Future<void> setUserEmail(String val, {bool isInitializing = false}) async {
    userEmail = val;
    if (!isInitializing) await setValue(USER_EMAIL, val);
  }

  @action
  Future<void> setAddress(String val, {bool isInitializing = false}) async {
    address = val;
    if (!isInitializing) await setValue(ADDRESS, val);
  }

  @action
  Future<void> setFirstName(String val, {bool isInitializing = false}) async {
    userFirstName = val;
    if (!isInitializing) await setValue(FIRST_NAME, val);
  }

  @action
  Future<void> setLastName(String val, {bool isInitializing = false}) async {
    userLastName = val;
    if (!isInitializing) await setValue(LAST_NAME, val);
  }

  @action
  Future<void> setContactNumber(String val, {bool isInitializing = false}) async {
    userContactNumber = val;
    if (!isInitializing) await setValue(CONTACT_NUMBER, val);
  }

  @action
  Future<void> setUserName(String val, {bool isInitializing = false}) async {
    userName = val;
    if (!isInitializing) await setValue(USERNAME, val);
  }

  @action
  Future<void> setLoggedIn(bool val, {bool isInitializing = false}) async {
    isLoggedIn = val;
    if (!isInitializing) await setValue(IS_LOGGED_IN, val);
  }

  @action
  void setLoading(bool val) {
    isLoading = val;
  }

  @action
  void setRemember(bool val) {
    isRememberMe = val;
  }

  @action
  Future<void> setInitialAdCount(int val) async {
    countryId = val;
    // await setValue(INITIAL_AD_COUNT, val);
  }

  @action
  Future<void> setDarkMode(bool val) async {
    isDarkMode = val;
    if (isDarkMode) {
      textPrimaryColorGlobal = Colors.white;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = scaffoldSecondaryDark;
      appButtonBackgroundColorGlobal = appButtonColorDark;
      shadowColorGlobal = Colors.white12;
      setStatusBarColor(appButtonColorDark);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: scaffoldColorDark,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ));
    } else {
      textPrimaryColorGlobal = textPrimaryColor;
      textSecondaryColorGlobal = textSecondaryColor;

      defaultLoaderBgColorGlobal = Colors.white;
      appButtonBackgroundColorGlobal = Colors.white;
      shadowColorGlobal = Colors.black12;
      setStatusBarColor(primaryColor);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.white,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ));
    }
  }

  @action
  Future<void> setLanguage(String val, {BuildContext? context}) async {
    selectedLanguageCode = val;
    selectedLanguageDataModel = getSelectedLanguageModel();

    await setValue(SELECTED_LANGUAGE_CODE, selectedLanguageCode);
    languages = await AppLocalizations().load(Locale(selectedLanguageCode));

    if (context != null) languages = Languages.of(context);

    errorMessage = languages.pleaseTryAgain;
    errorSomethingWentWrong = languages.somethingWentWrong;
    errorThisFieldRequired = languages.hintRequired;
    errorInternetNotAvailable = languages.internetNotAvailable;
  }

  @action
  Future<void> setHandymanAvailability(int val, {bool isInitializing = false}) async {
    handymanAvailability = val;
    if (isInitializing) await setValue(HANDYMAN_AVAILABLE_STATUS, val);
  }
}
