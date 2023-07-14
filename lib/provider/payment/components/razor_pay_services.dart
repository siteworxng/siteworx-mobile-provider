import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/models/provider_subscription_model.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class RazorPayServices {
  static late Razorpay razorPay;
  static late String razorKeys;
  static ProviderSubscriptionModel? planData;

  init({required String razorKey, ProviderSubscriptionModel? data}) {
    razorPay = Razorpay();
    razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
    razorKeys = razorKey;
    planData = data;
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) async {
    log("PaymentId: ${response.paymentId}");

    savePayment(data: planData, paymentMethod: PAYMENT_METHOD_RAZOR, paymentStatus: BOOKING_STATUS_PAID, txtId: response.paymentId);
  }

  void handlePaymentError(PaymentFailureResponse response) {
    toast("Error: " + response.code.toString() + " - " + response.message!, print: true);
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    toast("external_wallet: " + response.walletName!);
  }

  void razorPayCheckout(num mAmount) async {
    var options = {
      'key': razorKeys,
      'amount': (mAmount * 100),
      'name': planData!.title.validate(),
      'theme.color': '#5f60b9',
      'image': 'https://razorpay.com/assets/razorpay-glyph.svg',
      'prefill': {'contact': appStore.userContactNumber, 'email': appStore.userEmail},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      razorPay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
