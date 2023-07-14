import 'package:provider/models/provider_subscription_model.dart';

class PaypalPayment {
  num totalAmount;
  String payPalUrl;
  ProviderSubscriptionModel? planData;

  PaypalPayment({required this.payPalUrl, required this.totalAmount, required this.planData});

/*void brainTreeDrop() async {
    var request = BraintreeDropInRequest(
      tokenizationKey: payPalUrl,
      collectDeviceData: true,
      googlePaymentRequest: BraintreeGooglePaymentRequest(
        totalPrice: totalAmount.toString(),
        currencyCode: appStore.currencyCode,
        billingAddressRequired: false,
      ),
      paypalRequest: BraintreePayPalRequest(amount: totalAmount.toString(), currencyCode: "USD"),
      cardEnabled: true,
    );
    final result = await BraintreeDropIn.start(request);
    if (result != null) {
      log("TXNID?" + result.paymentMethodNonce.nonce);
      log("TXNTYPE_LABEL?" + result.paymentMethodNonce.typeLabel);
      log("desc" + result.paymentMethodNonce.description);
      log("Default" + result.paymentMethodNonce.isDefault.toString());
      await savePayment(
        data: planData,
        paymentMethod: PAYMENT_METHOD_PAYPAL,
        paymentStatus: SERVICE_PAYMENT_STATUS_PAID,
        txtId: result.paymentMethodNonce.nonce.validate(),
      );

      appStore.setLoading(false);
    }

    log("result call1");
  }*/
}
