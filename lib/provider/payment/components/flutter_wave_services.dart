import 'package:flutterwave_standard/flutterwave.dart';
import 'package:provider/main.dart';
import 'package:provider/models/provider_subscription_model.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:uuid/uuid.dart';

class FlutterWaveServices {
  final Customer customer = Customer(
    name: appStore.userName,
    phoneNumber: appStore.userContactNumber,
    email: appStore.userEmail,
  );

  void payWithFlutterWave({
    required ProviderSubscriptionModel selectedPricingPlan,
    required String flutterWavePublicKey,
    required String flutterWaveSecretKey,
    required bool isTestMode,
  }) async {
    String transactionId = Uuid().v1();

    Flutterwave flutterWave = Flutterwave(
      context: getContext,
      publicKey: flutterWavePublicKey,
      currency: appStore.currencyCode,
      redirectUrl: BASE_URL,
      txRef: transactionId,
      amount: selectedPricingPlan.amount.validate().validate().toStringAsFixed(0),
      customer: customer,
      paymentOptions: "card, payattitude, barter",
      customization: Customization(title: "Pay With Flutterwave", logo: appLogo),
      isTestMode: isTestMode,
    );

    await flutterWave.charge().then((value) {
      if (value.status == "successful") {
        appStore.setLoading(true);

        verifyPayment(transactionId: value.transactionId.validate(), flutterWaveSecretKey: flutterWaveSecretKey).then((v) {
          if (v.status == "success") {
            savePayment(data: selectedPricingPlan, paymentMethod: PAYMENT_METHOD_FLUTTER_WAVE, paymentStatus: BOOKING_STATUS_PAID, txtId: value.transactionId.validate()).catchError(onError);
          } else {
            appStore.setLoading(false);
            toast(languages.lblTransactionFailed);
          }
        }).catchError((e) {
          appStore.setLoading(false);

          toast(e.toString());
        });
      } else {
        toast(languages.lblTransactionCancelled);
        appStore.setLoading(false);
      }
    });
  }
}
