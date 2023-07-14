import 'dart:math';

import 'package:cinetpay/cinetpay.dart';
import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/models/provider_subscription_model.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

class CinetPayServices {
  String cinetPayApiKey;
  String siteId;
  String secretKey;
  num totalAmount;
  ProviderSubscriptionModel? planData;

  // Local Variable
  Map<String, dynamic>? response;

  CinetPayServices({required this.cinetPayApiKey, required this.totalAmount, required this.planData, required this.siteId, required this.secretKey});

  final String transactionId = Random().nextInt(100000000).toString();

  Future<void> payWithCinetPay({required BuildContext context}) async {
    await Navigator.push(getContext, MaterialPageRoute(builder: (_) => cinetPay()));
    appStore.setLoading(false);
  }

  Widget cinetPay() {
    return CinetPayCheckout(
      title: languages.lblCheckOutWithCinetPay,
      configData: <String, dynamic>{
        'apikey': cinetPayApiKey,
        'site_id': siteId,
        'notify_url': 'http://mondomaine.com/notify/',
        'mode': 'PRODUCTION',
      },
      paymentData: <String, dynamic>{
        'transaction_id': transactionId,
        'amount': totalAmount,
        'currency': appStore.currencyCode,
        'channels': 'ALL',
        'description': '',
      },
      waitResponse: (data) {
        response = data;
        log(response);

        if (data['status'] == REFUSED) {
          toast(languages.yourPaymentFailedPleaseTryAgain);
        } else if (data['status'] == ACCEPTED) {
          toast(languages.yourPaymentHasBeenMadeSuccessfully);
          appStore.setLoading(false);
          savePayment(data: planData, paymentMethod: PAYMENT_METHOD_CINETPAY, paymentStatus: BOOKING_STATUS_PAID);
        }
      },
      onError: (data) {
        response = data;
        log(response);
        appStore.setLoading(false);
      },
    );
  }
}
