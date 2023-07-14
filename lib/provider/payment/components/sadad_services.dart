import 'package:flutter/cupertino.dart';
import 'package:provider/main.dart';
import 'package:provider/models/provider_subscription_model.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/payment/components/payment_webview_screen.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/constant.dart';

class SadadServices {
  String sadadId;
  String sadadKey;
  String sadadDomain;
  num totalAmount;
  ProviderSubscriptionModel? planData;

  SadadServices({
    required this.sadadId,
    required this.sadadKey,
    required this.sadadDomain,
    required this.totalAmount,
    required this.planData,
  });

  Future<void> payWithSadad(BuildContext context) async {
    Map request = {
      "sadadId": sadadId,
      "secretKey": sadadKey,
      "domain": sadadDomain,
    };

    await sadadLogin(request).then((accessToken) async {
      await createInvoice(context, accessToken: accessToken).then((value) async {
        //
      }).catchError((e) {
        appStore.setLoading(false);
        toast(e.toString());
      });
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Future<void> createInvoice(BuildContext context, {required String accessToken}) async {
    Map<String, dynamic> req = {
      "countryCode": 974,
      "clientname": appStore.userName.validate(),
      "cellnumber": appStore.userContactNumber.validate().splitAfter('-'),
      "invoicedetails": [
        {
          "description": planData!.title.validate(),
          "quantity": 1,
          "amount": totalAmount,
        },
      ],
      "status": 2,
      "remarks": planData!.description.validate(),
      "amount": totalAmount,
    };
    sadadCreateInvoice(request: req, sadadToken: accessToken).then((value) async {
      appStore.setLoading(false);
      log('val:${value[0]['shareUrl']}');

      String? res = await PaymentWebViewScreen(
        url: value[0]['shareUrl'],
        accessToken: accessToken,
      ).launch(context);

      if (res.validate().isNotEmpty) {
        savePayment(data: planData, paymentMethod: PAYMENT_METHOD_SADAD_PAYMENT, paymentStatus: BOOKING_STATUS_PAID, txtId: res);
      } else {
        toast("Transaction Failed", print: true);
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast('Error: $e', print: true);
    });
  }
}
// Handle CinetPayment
