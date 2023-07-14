import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/models/base_response.dart';
import 'package:provider/models/user_bank_model.dart';
import 'package:provider/networks/network_utils.dart';
import 'package:provider/screens/cash_management/model/cash_detail_model.dart';
import 'package:provider/screens/cash_management/model/payment_history_model.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

Future<List<PaymentHistoryData>> getPaymentHistory({required String bookingId}) async {
  String bId = "booking_id=$bookingId";
  PaymentHistoryModel res = PaymentHistoryModel.fromJson(await handleResponse(await buildHttpResponse('payment-history?$bId', method: HttpMethodType.GET)));

  return res.data.validate();
}

Future<(num, num, List<PaymentHistoryData>)> getCashDetails({
  int? page,
  int? providerId,
  String? toDate,
  String? fromDate,
  String? statusType,
  required List<PaymentHistoryData> list,
  Function(bool)? lastPageCallback,
  bool disableLoader = false,
}) async {
  log("From Date $fromDate");
  log("To Date $fromDate");
  late CashHistoryModel res;
  try {
    String pPage = "&per_page=$PER_PAGE_ITEM";
    String pages = "page=$page";
    String tdate = fromDate != null ? "&to=$toDate" : '';
    String fdate = toDate != null ? "&from=$fromDate" : '';
    String sType = statusType != null ? "&status=$statusType" : '';
    appStore.setLoading(true);

    res = CashHistoryModel.fromJson(
      await handleResponse(await buildHttpResponse('cash-detail?$pages$pPage$tdate$fdate$sType', method: HttpMethodType.GET)),
    );

    if (page == 1) list.clear();

    list.addAll(res.data.validate());

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    if (!disableLoader) {
      appStore.setLoading(false);
    }
  } catch (e) {
    if (!disableLoader) {
      appStore.setLoading(false);
    }

    throw e;
  }
  return (res.totalCash.validate(), res.todayCash.validate(), list);
}

Future<UserBankDetails> getUserBankDetail({required int userId}) async {
  return UserBankDetails.fromJson(await handleResponse(await buildHttpResponse('user-bank-detail?user_id=$userId', method: HttpMethodType.GET)));
}

Future<BaseResponseModel> transferCashAPI({required Map<String, dynamic> req}) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('transfer-payment', method: HttpMethodType.POST, request: req)));
}

Future<void> transferAmountAPI(
  BuildContext context, {
  required PaymentHistoryData paymentData,
  required String status,
  required String action,
  bool isFinishRequired = true,
  Function()? onTap,
}) async {
  await showConfirmDialogCustom(
    context,
    title: languages.confirmationRequestTxt,
    positiveText: languages.lblYes,
    negativeText: languages.lblNo,
    primaryColor: context.primaryColor,
    onAccept: (p0) async {
      Map<String, dynamic> req = {
        "payment_id": paymentData.paymentId.validate(),
        "booking_id": paymentData.bookingId.validate(),
        "action": action,
        "type": paymentData.type,
        "sender_id": paymentData.senderId,
        "receiver_id": paymentData.receiverId,
        "txn_id": paymentData.txnId,
        "other_transaction_detail": "",
        "datetime": formatDate(DateTime.now().toString(), format: DATE_FORMAT_7),
        "total_amount": paymentData.totalAmount,
        "status": status,
        "p_id": paymentData.id,
        "parent_id": paymentData.parentId,
      };
      log(req);
      appStore.setLoading(true);

      await transferCashAPI(req: req).then((value) {
        onTap?.call();
        if (isFinishRequired) {
          finish(context);
        }
        toast(value.message.validate());

        // appStore.setLoading(false);
      }).catchError((e) {
        toast(e.toString());
        // appStore.setLoading(false);
      });
    },
  );
}
