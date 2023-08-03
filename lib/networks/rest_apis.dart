import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/auth/sign_in_screen.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/main.dart';
import 'package:provider/models/Package_response.dart';
import 'package:provider/models/base_response.dart';
import 'package:provider/models/booking_detail_response.dart';
import 'package:provider/models/booking_list_response.dart';
import 'package:provider/models/booking_status_response.dart';
import 'package:provider/models/caregory_response.dart';
import 'package:provider/models/city_list_response.dart';
import 'package:provider/models/country_list_response.dart';
import 'package:provider/models/dashboard_response.dart';
import 'package:provider/models/document_list_response.dart';
import 'package:provider/models/handyman_dashboard_response.dart';
import 'package:provider/models/login_response.dart';
import 'package:provider/models/notification_list_response.dart';
import 'package:provider/models/payment_list_reasponse.dart';
import 'package:provider/models/plan_list_response.dart';
import 'package:provider/models/plan_request_model.dart';
import 'package:provider/models/profile_update_response.dart';
import 'package:provider/models/provider_document_list_response.dart';
import 'package:provider/models/provider_info_model.dart';
import 'package:provider/models/provider_subscription_model.dart';
import 'package:provider/models/register_response.dart';
import 'package:provider/models/search_list_response.dart';
import 'package:provider/models/service_address_response.dart';
import 'package:provider/models/service_detail_response.dart';
import 'package:provider/models/service_model.dart';
import 'package:provider/models/service_response.dart';
import 'package:provider/models/service_review_response.dart';
import 'package:provider/models/state_list_response.dart';
import 'package:provider/models/subscription_history_model.dart';
import 'package:provider/models/tax_list_response.dart';
import 'package:provider/models/total_earning_response.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/models/user_info_response.dart';
import 'package:provider/models/user_list_response.dart';
import 'package:provider/models/user_type_response.dart';
import 'package:provider/models/verify_transaction_response.dart';
import 'package:provider/networks/network_utils.dart';
import 'package:provider/provider/jobRequest/models/post_job_detail_response.dart';
import 'package:provider/provider/jobRequest/models/post_job_response.dart';
import 'package:provider/provider/provider_dashboard_screen.dart';
import 'package:provider/provider/timeSlots/models/slot_data.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/images.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import '../models/configuration_response.dart';
import '../models/google_places_model.dart';
import '../models/my_bid_response.dart';
import '../models/wallet_history_list_response.dart';
import '../provider/jobRequest/models/bidder_data.dart';
import '../provider/jobRequest/models/post_job_data.dart';

//region Auth API
Future<void> logout(BuildContext context) async {
  showInDialog(
    context,
    contentPadding: EdgeInsets.zero,
    builder: (_) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(logout_logo, width: context.width(), fit: BoxFit.cover),
              32.height,
              Text(languages.lblDeleteTitle, style: boldTextStyle(size: 18)),
              16.height,
              Text(languages.lblDeleteSubTitle, style: secondaryTextStyle()),
              28.height,
              Row(
                children: [
                  AppButton(
                    child: Text(languages.lblNo, style: boldTextStyle()),
                    color: context.cardColor,
                    elevation: 0,
                    onTap: () {
                      finish(context);
                    },
                  ).expand(),
                  16.width,
                  AppButton(
                    child: Text(languages.lblYes, style: boldTextStyle(color: white)),
                    color: primaryColor,
                    elevation: 0,
                    onTap: () async {
                      if (await isNetworkAvailable()) {
                        appStore.setLoading(true);
                        await logoutApi().then((value) async {}).catchError((e) {
                          appStore.setLoading(false);
                          toast(e.toString());
                        });

                        await clearPreferences();

                        // TODO: Please do not remove this condition because this feature not supported on iOS.
                        if (isAndroid) await OneSignal.shared.clearOneSignalNotifications();
                        appStore.setLoading(false);

                        SignInScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                      } else {
                        toast(errorInternetNotAvailable);
                      }
                    },
                  ).expand(),
                ],
              ),
            ],
          ).paddingSymmetric(horizontal: 16, vertical: 24),
          Observer(builder: (_) => LoaderWidget().withSize(width: 60, height: 60).visible(appStore.isLoading)),
        ],
      );
    },
  );
}

Future<void> clearPreferences() async {
  cachedProviderDashboardResponse = null;
  cachedHandymanDashboardResponse = null;
  cachedBookingList = null;
  cachedPaymentList = null;
  cachedNotifications = null;
  cachedBookingStatusDropdown = null;

  await appStore.setFirstName('');
  await appStore.setLastName('');
  if (!getBoolAsync(IS_REMEMBERED)) await appStore.setUserEmail('');
  await appStore.setUserName('');
  await appStore.setContactNumber('');
  await appStore.setCountryId(0);
  await appStore.setStateId(0);
  await appStore.setCityId(0);
  await appStore.setUId('');
  await appStore.setToken('');
  await appStore.setCurrencySymbol('');
  await appStore.setLoggedIn(false);
  await appStore.setPlanSubscribeStatus(false);
  await appStore.setPlanTitle('');
  await appStore.setIdentifier('');
  await appStore.setPlanEndDate('');
  await appStore.setTester(false);
  await appStore.setPrivacyPolicy('');
  await appStore.setTermConditions('');
  await appStore.setInquiryEmail('');
  await appStore.setHelplineNumber('');

  // TODO: Please do not remove this condition because this feature not supported on iOS.
  if (isAndroid) await OneSignal.shared.clearOneSignalNotifications();
}

//endregion

//region Configuration API
Future<ConfigurationResponse> configurationDashboard() async {
  ConfigurationResponse data = ConfigurationResponse.fromJson(await handleResponse(await buildHttpResponse('configurations', method: HttpMethodType.GET)));

  setCurrencies(value: data.configurations, paymentSetting: data.paymentSettings);

  data.configurations.validate().forEach((data) {
    if (data.value.validate().isNotEmpty && data.key == ONESIGNAL_APP_ID_PROVIDER) {
      compareValuesInSharedPreference(ONESIGNAL_APP_ID_PROVIDER, data.value);
    } else if (data.value.validate().isNotEmpty && data.key == ONESIGNAL_REST_API_KEY_PROVIDER) {
      compareValuesInSharedPreference(ONESIGNAL_REST_API_KEY_PROVIDER, data.value);
    } else if (data.value.validate().isNotEmpty && data.key == ONESIGNAL_CHANNEL_KEY_PROVIDER) {
      compareValuesInSharedPreference(ONESIGNAL_CHANNEL_KEY_PROVIDER, data.value);
    } else if (data.value.validate().isNotEmpty && data.key == ONESIGNAL_APP_ID_USER) {
      compareValuesInSharedPreference(ONESIGNAL_APP_ID_USER, data.value);
    } else if (data.value.validate().isNotEmpty && data.key == ONESIGNAL_REST_API_KEY_USER) {
      compareValuesInSharedPreference(ONESIGNAL_REST_API_KEY_USER, data.value);
    } else if (data.value.validate().isNotEmpty && data.key == ONESIGNAL_CHANNEL_KEY_USER) {
      compareValuesInSharedPreference(ONESIGNAL_CHANNEL_KEY_USER, data.value);
    }
  });

  1.seconds.delay.then((value) {
    setOneSignal();
  });

  return data;
}
//endregion

//region Provider API
Future<DashboardResponse> providerDashboard() async {
  final completer = Completer<DashboardResponse>();

  try {
    final response = await buildHttpResponse('provider-dashboard', method: HttpMethodType.GET);
    final data = DashboardResponse.fromJson(await handleResponse(response));

    completer.complete(data);
    // Perform additional code or post-processing
    _performAdditionalProcessingProvider(data);
  } catch (e) {
    completer.completeError(e);
  }

  return completer.future;
}

void _performAdditionalProcessingProvider(DashboardResponse data) async {
  cachedProviderDashboardResponse = data;

  data.configurations.validate().forEach((data) {
    if (data.key == CONFIGURATION_KEY_CURRENCY_COUNTRY_ID && data.country != null) {
      if (data.country!.currencyCode.validate() != appStore.currencyCode) appStore.setCurrencyCode(data.country!.currencyCode.validate());
      if (data.country!.id.validate().toString() != appStore.countryId.toString()) appStore.setCurrencyCountryId(data.country!.id.validate().toString());
      if (data.country!.symbol.validate() != appStore.currencySymbol) appStore.setCurrencySymbol(data.country!.symbol.validate());
    } else if (data.key == CONFIGURATION_TYPE_CURRENCY_POSITION && data.value.validate().isNotEmpty) {
      compareValuesInSharedPreference(CURRENCY_POSITION, data.value);
    }
  });

  if (data.commission != null) {
    compareValuesInSharedPreference(DASHBOARD_COMMISSION, jsonEncode(data.commission));
  }

  if (data.appDownload != null) {
    compareValuesInSharedPreference(PROVIDER_PLAY_STORE_URL, data.appDownload!.providerPlayStoreUrl.validate());
    compareValuesInSharedPreference(PROVIDER_APPSTORE_URL, data.appDownload!.providerAppstoreUrl.validate());
  }

  appStore.setNotificationCount(data.notificationUnreadCount.validate());
  appStore.setPrivacyPolicy(data.privacyPolicy?.value.validate() ?? PRIVACY_POLICY_URL);
  appStore.setTermConditions(data.termConditions?.value.validate() ?? TERMS_CONDITION_URL);
  appStore.setInquiryEmail(data.inquiryEmail.validate(value: INQUIRY_SUPPORT_EMAIL));
  appStore.setHelplineNumber(data.helplineNumber.validate());

  if (data.languageOption != null) {
    compareValuesInSharedPreference(SERVER_LANGUAGES, jsonEncode(data.languageOption!.toList()));
  }

  compareValuesInSharedPreference(IS_ADVANCE_PAYMENT_ALLOWED, data.isAdvancedPaymentAllowed == '1');
  appStore.setEarningType(data.earningType.validate());

  if (data.subscription != null) {
    await setSaveSubscription(
      isSubscribe: data.isSubscribed,
      title: data.subscription!.title.validate(),
      identifier: data.subscription!.identifier.validate(),
      endAt: data.subscription!.endAt.validate(),
    );
  }

  if (appStore.isLoggedIn) {
    configurationDashboard();
  }

  appStore.setLoading(false);
}

Future<ProviderDocumentListResponse> getProviderDoc() async {
  return ProviderDocumentListResponse.fromJson(await handleResponse(await buildHttpResponse('provider-document-list', method: HttpMethodType.GET)));
}

Future<CommonResponseModel> deleteProviderDoc(int? id) async {
  return CommonResponseModel.fromJson(await handleResponse(await buildHttpResponse('provider-document-delete/$id', method: HttpMethodType.POST)));
}
//endregion

//region Handyman API
Future<HandymanDashBoardResponse> handymanDashboard() async {
  final completer = Completer<HandymanDashBoardResponse>();

  try {
    final response = await buildHttpResponse('handyman-dashboard', method: HttpMethodType.GET);
    final data = HandymanDashBoardResponse.fromJson(await handleResponse(response));

    // Perform additional code or post-processing
    _performAdditionalProcessingHandyman(data);

    completer.complete(data);
  } catch (e) {
    completer.completeError(e);
  }

  return completer.future;
}

void _performAdditionalProcessingHandyman(HandymanDashBoardResponse data) {
  cachedHandymanDashboardResponse = data;

  appStore.setCompletedBooking(data.completedBooking.validate().toInt());
  appStore.setHandymanAvailability(data.isHandymanAvailable.validate());

  data.configurations.validate().forEach((data) {
    if (data.key == CONFIGURATION_KEY_CURRENCY_COUNTRY_ID && data.country != null) {
      if (data.country!.currencyCode.validate() != appStore.currencyCode) appStore.setCurrencyCode(data.country!.currencyCode.validate());
      if (data.country!.id.validate().toString() != appStore.countryId.toString()) appStore.setCurrencyCountryId(data.country!.id.validate().toString());
      if (data.country!.symbol.validate() != appStore.currencySymbol) appStore.setCurrencySymbol(data.country!.symbol.validate());
    } else if (data.key == CONFIGURATION_TYPE_CURRENCY_POSITION && data.value.validate().isNotEmpty) {
      compareValuesInSharedPreference(CURRENCY_POSITION, data.value);
    }
  });

  if (data.appDownload != null) {
    compareValuesInSharedPreference(PROVIDER_PLAY_STORE_URL, data.appDownload!.providerPlayStoreUrl.validate());
    compareValuesInSharedPreference(PROVIDER_APPSTORE_URL, data.appDownload!.providerAppstoreUrl.validate());
  }

  appStore.setNotificationCount(data.notificationUnreadCount.validate());
  appStore.setPrivacyPolicy(data.privacyPolicy?.value.validate() ?? PRIVACY_POLICY_URL);
  appStore.setTermConditions(data.termConditions?.value.validate() ?? TERMS_CONDITION_URL);

  if (data.commission != null) {
    compareValuesInSharedPreference(DASHBOARD_COMMISSION, jsonEncode(data.commission));
  }

  appStore.setInquiryEmail(data.inquiryEmail.validate(value: INQUIRY_SUPPORT_EMAIL));
  appStore.setHelplineNumber(data.helplineNumber.validate());

  if (data.languageOption != null) {
    compareValuesInSharedPreference(SERVER_LANGUAGES, jsonEncode(data.languageOption!.toList()));
  }

  if (appStore.isLoggedIn) {
    configurationDashboard();
  }

  appStore.setLoading(false);
}


Future<UserData> deleteHandyman(int id) async {
  return UserData.fromJson(await handleResponse(await buildHttpResponse('handyman-delete/$id', method: HttpMethodType.POST)));
}

Future<BaseResponseModel> restoreHandyman(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('handyman-action', request: request, method: HttpMethodType.POST)));
}

//endregion


Future<ServiceDetailResponse> getServiceDetail(Map request) async {
  return ServiceDetailResponse.fromJson(await handleResponse(await buildHttpResponse('service-detail', request: request, method: HttpMethodType.POST)));
}

Future<CommonResponseModel> deleteService(int id) async {
  return CommonResponseModel.fromJson(await handleResponse(await buildHttpResponse('service-delete/$id', method: HttpMethodType.POST)));
}

Future<BaseResponseModel> deleteImage(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('remove-file', request: request, method: HttpMethodType.POST)));
}

Future<void> addServiceMultiPart({required Map<String, dynamic> value, List<int>? serviceAddressList, List<File>? imageFile}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('service-save');

  multiPartRequest.fields.addAll(await getMultipartFields(val: value));

  if (serviceAddressList.validate().isNotEmpty) {
    for (int i = 0; i < serviceAddressList!.length; i++) {
      multiPartRequest.fields[AddServiceKey.providerAddressId + '[$i]'] = serviceAddressList[i].toString().validate();
    }
  }

  if (imageFile.validate().isNotEmpty) {
    multiPartRequest.files.addAll(await getMultipartImages(files: imageFile.validate(), name: AddServiceKey.serviceAttachment));
    multiPartRequest.fields[AddServiceKey.attachmentCount] = imageFile.validate().length.toString();
  }

  log("${multiPartRequest.fields}");

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log("Multi Part Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");

  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    log("Response: ${jsonDecode(temp)}");

    toast(jsonDecode(temp)['message'], print: true);
    finish(getContext, true);
  }, onError: (error) {
    toast(error.toString(), print: true);
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
    toast(e.toString());
  });
}
//endregion

//region Booking API
Future<List<BookingStatusResponse>> bookingStatus() async {
  Iterable res = await (handleResponse(await buildHttpResponse('booking-status', method: HttpMethodType.GET)));
  cachedBookingStatusDropdown = res.map((e) => BookingStatusResponse.fromJson(e)).toList();

  return cachedBookingStatusDropdown.validate();
}

Future<List<BookingData>> getBookingList(int page, {var perPage = PER_PAGE_ITEM, String status = '', required List<BookingData> bookings, Function(bool)? lastPageCallback}) async {
  try {
    BookingListResponse res;

    if (status == BOOKING_PAYMENT_STATUS_ALL) {
      res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?per_page=$perPage&page=$page', method: HttpMethodType.GET)));
    } else {
      res = BookingListResponse.fromJson(await handleResponse(await buildHttpResponse('booking-list?status=$status&per_page=$perPage&page=$page', method: HttpMethodType.GET)));
    }

    if (page == 1) bookings.clear();
    bookings.addAll(res.data.validate());
    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    cachedBookingList = bookings;

    appStore.setLoading(false);

    return bookings;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<List<ServiceData>> getSearchList(
  int page, {
  var perPage = PER_PAGE_ITEM,
  int? categoryId = -1,
  int? subCategoryId = -1,
  int? providerId,
  String? search,
  String? type,
  required List<ServiceData> services,
  Function(bool)? lastPageCallback,
}) async {
  try {
    SearchListResponse res;

    String? req;
    String categoryIds = categoryId != -1 ? 'category_id=$categoryId&' : '';
    String searchPara = search.validate().isNotEmpty ? 'search=$search&' : '';
    String subCategorys = subCategoryId != -1 ? 'subcategory_id=$subCategoryId&' : '';
    String pages = 'page=$page&';
    String perPages = 'per_page=$perPage';
    String providerIds = appStore.isLoggedIn ? 'provider_id=${appStore.userId}&' : '';
    String serviceType = type.validate().isNotEmpty ? 'type=$type&' : "";

    req = '?$categoryIds$providerIds$subCategorys$serviceType$searchPara$pages$perPages';
    res = SearchListResponse.fromJson(await handleResponse(await buildHttpResponse('search-list$req', method: HttpMethodType.GET)));

    if (page == 1) services.clear();
    services.addAll(res.data.validate());
    lastPageCallback?.call(res.data.validate().length != perPage);

    appStore.setLoading(false);

    return services;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<BookingDetailResponse> bookingDetail(Map request) async {
  BookingDetailResponse bookingDetailResponse = BookingDetailResponse.fromJson(
    await handleResponse(await buildHttpResponse('booking-detail', request: request, method: HttpMethodType.POST)),
  );

  bookingDetailResponse.finalTotalAmount = calculateTotalAmount(
    serviceDiscountPercent: bookingDetailResponse.service!.discount.validate(),
    qty: bookingDetailResponse.bookingDetail!.quantity.validate().toInt(),
    detail: bookingDetailResponse.service,
    servicePrice: bookingDetailResponse.service!.price.validate(),
    taxes: bookingDetailResponse.bookingDetail!.taxes.validate(),
    couponData: bookingDetailResponse.couponData,
    extraCharges: bookingDetailResponse.bookingDetail!.extraCharges,
  );

  appStore.setLoading(false);

  return bookingDetailResponse;
}

Future<BaseResponseModel> bookingUpdate(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('booking-update', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> assignBooking(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('booking-assigned', request: request, method: HttpMethodType.POST)));
}
//endregion

//region Address API
Future<ServiceAddressesResponse> getAddresses({int? providerId}) async {
  return ServiceAddressesResponse.fromJson(await handleResponse(await buildHttpResponse('provideraddress-list?provider_id=$providerId', method: HttpMethodType.GET)));
}

Future<List<AddressResponse>> getAddressesWithPagination({
  int? page,
  int? perPage = PER_PAGE_ITEM,
  required List<AddressResponse> addressList,
  required int providerId,
  Function(bool)? lastPageCallback,
}) async {
  try {
    ServiceAddressesResponse res = ServiceAddressesResponse.fromJson(await handleResponse(await buildHttpResponse('provideraddress-list?provider_id=$providerId&per_page=$perPage&page=$page', method: HttpMethodType.GET)));

    if (page == 1) addressList.clear();

    addressList.addAll(res.addressResponse.validate());

    lastPageCallback?.call(res.addressResponse.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
  return addressList;
}


//endregion

//region Reviews API
Future<List<RatingData>> serviceReviews(Map request) async {
  ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('service-reviews?per_page=all', request: request, method: HttpMethodType.POST)));

  return res.data.validate();
}

Future<List<RatingData>> handymanReviews(Map request) async {
  ServiceReviewResponse res = ServiceReviewResponse.fromJson(await handleResponse(await buildHttpResponse('handyman-reviews?per_page=all', request: request, method: HttpMethodType.POST)));
  return res.data.validate();
}
//endregion

//region Subscription API
Future<List<ProviderSubscriptionModel>> getPricingPlanList() async {
  try {
    PlanListResponse res = PlanListResponse.fromJson(await handleResponse(await buildHttpResponse('plan-list', method: HttpMethodType.GET)));

    appStore.setLoading(false);

    return res.data.validate();
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<ProviderSubscriptionModel> saveSubscription(Map request) async {
  return ProviderSubscriptionModel.fromJson(await handleResponse(await buildHttpResponse('save-subscription', request: request, method: HttpMethodType.POST)));
}

Future<List<ProviderSubscriptionModel>> getSubscriptionHistory({
  int? page,
  int? perPage = PER_PAGE_ITEM,
  required List<ProviderSubscriptionModel> providerSubscriptionList,
  Function(bool)? lastPageCallback,
}) async {
  try {
    SubscriptionHistoryResponse res = SubscriptionHistoryResponse.fromJson(await handleResponse(await buildHttpResponse(
      'subscription-history?per_page=$perPage&page=$page&orderby=desc',
      method: HttpMethodType.GET,
    )));

    if (page == 1) providerSubscriptionList.clear();

    providerSubscriptionList.addAll(res.data.validate());

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);

    return providerSubscriptionList;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<void> cancelSubscription(Map request) async {
  return await handleResponse(await buildHttpResponse('cancel-subscription', request: request, method: HttpMethodType.POST));
}

Future<void> savePayment({
  ProviderSubscriptionModel? data,
  String? paymentStatus = BOOKING_PAYMENT_STATUS_ALL,
  String? paymentMethod,
  String? txtId,
}) async {
  if (data != null) {
    PlanRequestModel planRequestModel = PlanRequestModel()
      ..amount = data.amount
      ..description = data.description
      ..duration = data.duration
      ..identifier = data.identifier
      ..otherTransactionDetail = ''
      ..paymentStatus = paymentStatus.validate()
      ..paymentType = paymentMethod.validate()
      ..planId = data.id
      ..planLimitation = data.planLimitation
      ..planType = data.planType
      ..title = data.title
      ..txnId = txtId
      ..type = data.type
      ..userId = appStore.userId;

    appStore.setLoading(true);
    log('Request : $planRequestModel');

    await saveSubscription(planRequestModel.toJson()).then((value) {
      toast("${data.title.validate()}  ${languages.successfullyActivated}");
      // toast("${data.title.validate()} ${languages.lblIsSuccessFullyActivated}");
      push(ProviderDashboardScreen(index: 0), isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }).catchError((e) {
      log(e.toString());
    }).whenComplete(() => appStore.setLoading(false));
  }
}

Future<List<WalletHistory>> getWalletHistory({
  int? page,
  var perPage = PER_PAGE_ITEM,
  required List<WalletHistory> list,
  Function(bool)? lastPageCallback,
}) async {
  try {
    WalletHistoryListResponse res = WalletHistoryListResponse.fromJson(
      await handleResponse(await buildHttpResponse('wallet-history?per_page=$perPage&page=$page&orderby=desc', method: HttpMethodType.GET)),
    );

    if (page == 1) list.clear();
    list.addAll(res.data.validate());

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
  return list;
}

Future<BaseResponseModel> updateHandymanAvailabilityApi({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('handyman-update-available-status', request: request, method: HttpMethodType.POST)));
}

//endregion

//region Payment API
Future<PaymentListResponse> getPaymentList(int page, {var perPage = PER_PAGE_ITEM}) async {
  return PaymentListResponse.fromJson(await handleResponse(await buildHttpResponse('payment-list?per_page=$perPage&page=$page', method: HttpMethodType.GET)));
}

Future<List<PaymentData>> getPaymentAPI(int page, List<PaymentData> list, Function(bool)? lastPageCallback, {var perPage = PER_PAGE_ITEM}) async {
  try {
    var res = PaymentListResponse.fromJson(await handleResponse(await buildHttpResponse('payment-list?per_page=$perPage&page=$page', method: HttpMethodType.GET)));

    if (page == 1) list.clear();
    list.addAll(res.data.validate());

    cachedPaymentList = list;

    appStore.setLoading(false);

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    return list;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<List<PaymentData>> getUserPaymentList(int page, int id, List<PaymentData> list, Function(bool)? lastPageCallback) async {
  appStore.setLoading(true);
  var res = PaymentListResponse.fromJson(await handleResponse(await buildHttpResponse('payment-list?booking_id=$id&page=$page', method: HttpMethodType.GET)));

  if (page == 1) list.clear();
  list.addAll(res.data.validate());

  appStore.setLoading(false);

  lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

  return list;
}

//endregion

//region Common API
Future<List<TaxData>> getTaxList({
  int? page,
  required List<TaxData> list,
  Function(bool)? lastPageCallback,
}) async {
  try {
    TaxListResponse res = TaxListResponse.fromJson(
      await (handleResponse(await buildHttpResponse('tax-list', method: HttpMethodType.GET))),
    );

    if (page == 1) list.clear();
    list.addAll(res.taxData.validate());

    lastPageCallback?.call(res.taxData.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
  return list;
}

Future<List<NotificationData>> getNotification(Map request, {int? page = 1, required List<NotificationData> notificationList, var perPage = PER_PAGE_ITEM, Function(bool)? lastPageCallback}) async {
  try {
    var res = NotificationListResponse.fromJson(await handleResponse(await buildHttpResponse('notification-list?per_page=$perPage&page=$page', request: request, method: HttpMethodType.POST)));

    if (page == 1) {
      notificationList.clear();
    }

    lastPageCallback?.call(res.notificationData.validate().length != PER_PAGE_ITEM);

    notificationList.addAll(res.notificationData.validate());
    cachedNotifications = notificationList;

    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }

  return notificationList;
}

Future<DocumentListResponse> getDocList() async {
  return DocumentListResponse.fromJson(await handleResponse(await buildHttpResponse('document-list', method: HttpMethodType.GET)));
}

Future<List<TotalData>> getTotalEarningList(int page, List<TotalData> list, Function(bool)? lastPageCallback, {var perPage = PER_PAGE_ITEM}) async {
  try {
    var res = TotalEarningResponse.fromJson(
      await handleResponse(await buildHttpResponse('${isUserTypeProvider ? 'provider-payout-list' : 'handyman-payout-list'}?per_page="$perPage"&page=$page', method: HttpMethodType.GET)),
    );

    if (page == 1) list.clear();
    list.addAll(res.data.validate());

    appStore.setLoading(false);

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    return list;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<UserTypeResponse> getUserType({String type = USER_TYPE_PROVIDER}) async {
  return UserTypeResponse.fromJson(await handleResponse(await buildHttpResponse('type-list?type=$type')));
}

Future<BaseResponseModel> deleteAccountCompletely() async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('delete-account', request: {}, method: HttpMethodType.POST)));
}
//endregion

//region Post Job Request
Future<List<PostJobData>> getPostJobList(int page, {var perPage = PER_PAGE_ITEM, required List<PostJobData> postJobList, Function(bool)? lastPageCallback}) async {
  try {
    var res = PostJobResponse.fromJson(await handleResponse(await buildHttpResponse('get-post-job?per_page=$perPage&page=$page', method: HttpMethodType.GET)));

    if (page == 1) {
      postJobList.clear();
    }

    lastPageCallback?.call(res.postJobData.validate().length != PER_PAGE_ITEM);

    postJobList.addAll(res.postJobData.validate());
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }

  return postJobList;
}

Future<PostJobDetailResponse> getPostJobDetail(Map request) async {
  try {
    var res = PostJobDetailResponse.fromJson(await handleResponse(await buildHttpResponse('get-post-job-detail', request: request, method: HttpMethodType.POST)));
    appStore.setLoading(false);
    return res;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}

Future<BaseResponseModel> saveBid(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-bid', request: request, method: HttpMethodType.POST)));
}

Future<List<BidderData>> getBidList({int page = 1, var perPage = PER_PAGE_ITEM, required List<BidderData> bidList, Function(bool)? lastPageCallback}) async {
  try {
    var res = MyBidResponse.fromJson(await handleResponse(await buildHttpResponse('get-bid-list?orderby=desc&per_page=$perPage&page=$page', method: HttpMethodType.GET)));

    if (page == 1) {
      bidList.clear();
    }

    lastPageCallback?.call(res.bidData.validate().length != PER_PAGE_ITEM);

    bidList.addAll(res.bidData.validate());
    appStore.setLoading(false);
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
  return bidList;
}
//endregion

// region Package service API
Future<List<PackageData>> getAllPackageList({int? page, required List<PackageData> packageData, Function(bool)? lastPageCallback}) async {
  try {
    PackageResponse res = PackageResponse.fromJson(
      await handleResponse(await buildHttpResponse('package-list?per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethodType.GET)),
    );

    if (page == 1) packageData.clear();

    packageData.addAll(res.packageList.validate());

    lastPageCallback?.call(res.packageList.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);

    return packageData;
  } catch (e) {
    appStore.setLoading(false);

    throw e;
  }
}

Future<void> addPackageMultiPart({required Map<String, dynamic> value, List<File>? imageFile}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('package-save');

  multiPartRequest.fields.addAll(await getMultipartFields(val: value));

  if (imageFile.validate().isNotEmpty) {
    multiPartRequest.files.addAll(await getMultipartImages(files: imageFile.validate(), name: PackageKey.packageAttachment));
    multiPartRequest.fields[AddServiceKey.attachmentCount] = imageFile.validate().length.toString();
  }

  log("${multiPartRequest.fields}");

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log("MultiPart Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");

  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    appStore.selectedServiceList.clear();
    log("Response: ${jsonDecode(temp)}");

    toast(jsonDecode(temp)['message'], print: true);
    finish(getContext, true);
  }, onError: (error) {
    toast(error.toString(), print: true);
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
    toast(e.toString());
  });
}

Future<CommonResponseModel> deletePackage(int id) async {
  return CommonResponseModel.fromJson(await handleResponse(await buildHttpResponse('package-delete/$id', method: HttpMethodType.POST)));
}
//endregion

//region FlutterWave Verify Transaction API
Future<VerifyTransactionResponse> verifyPayment({required String transactionId, required String flutterWaveSecretKey}) async {
  return VerifyTransactionResponse.fromJson(
    await handleResponse(await buildHttpResponse("https://api.flutterwave.com/v3/transactions/$transactionId/verify", extraKeys: {
      'isFlutterWave': true,
      'flutterWaveSecretKey': flutterWaveSecretKey,
    })),
  );
}
//endregion

//region TimeSlots
Future<BaseResponseModel> updateAllServicesApi({required Map request}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('provider-all-services-timeslots', request: request, method: HttpMethodType.POST)));
}

Future<List<SlotData>> getProviderSlot({int? val}) async {
  String providerId = val != null ? "?provider_id=$val" : '';
  Iterable res = await handleResponse(await buildHttpResponse('get-provider-slot$providerId', method: HttpMethodType.GET));
  return res.map((e) => SlotData.fromJson(e)).toList();
}

Future<List<SlotData>> getProviderServiceSlot({int? providerId, int? serviceId}) async {
  String pId = providerId != null ? "?provider_id=$providerId" : '';
  String sId = serviceId != null ? "&service_id=$serviceId" : '';
  Iterable res = await handleResponse(await buildHttpResponse('get-service-slot$pId$sId', method: HttpMethodType.GET));
  return res.map((e) => SlotData.fromJson(e)).toList();
}

Future<BaseResponseModel> saveProviderSlot(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-provider-slot', request: request, method: HttpMethodType.POST)));
}

Future<BaseResponseModel> saveServiceSlot(Map request) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('save-service-slot', request: request, method: HttpMethodType.POST)));
}

//endregion

//region CommonFunctions
Future<Map<String, String>> getMultipartFields({required Map<String, dynamic> val}) async {
  Map<String, String> data = {};

  val.forEach((key, value) {
    data[key] = '$value';
  });

  return data;
}

Future<List<MultipartFile>> getMultipartImages({required List<File> files, required String name}) async {
  List<MultipartFile> multiPartRequest = [];

  await Future.forEach<File>(files, (element) async {
    int i = files.indexOf(element);

    multiPartRequest.add(await MultipartFile.fromPath('${'$name' + i.toString()}', element.path));
  });

  return multiPartRequest;
}
//endregion

//region Sadad Payment Api
Future<String> sadadLogin(Map request) async {
  var res = await handleResponse(
    await buildHttpResponse('$SADAD_API_URL/api/userbusinesses/login', method: HttpMethodType.POST, request: request, extraKeys: {
      'isSadadPayment': true,
    }),
    avoidTokenError: false,
    isSadadPayment: true,
  );
  return res['accessToken'];
}

Future sadadCreateInvoice({required Map<String, dynamic> request, required String sadadToken}) async {
  return handleResponse(
    await buildHttpResponse('$SADAD_API_URL/api/invoices/createInvoice', method: HttpMethodType.POST, request: request, extraKeys: {
      'sadadToken': true,
      'isSadadPayment': true,
    }),
    avoidTokenError: false,
    isSadadPayment: true,
  );
}
//endregion

//region Google Maps
Future<List<GooglePlacesModel>> getSuggestion(String input) async {
  String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
  String request = '$baseURL?input=$input&key=$GOOGLE_MAPS_API_KEY&sessiontoken=${appStore.token}';

  var response = await buildHttpResponse(request);

  if (response.statusCode == 200) {
    Iterable it = jsonDecode(response.body)['predictions'];
    return it.map((e) => GooglePlacesModel.fromJson(e)).toList().validate();
  } else {
    throw Exception('${languages.lblFailedToLoadPredictions}');
  }
}
//endregion
