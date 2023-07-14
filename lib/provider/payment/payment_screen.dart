import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/back_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/models/provider_subscription_model.dart';
import 'package:provider/provider/payment/components/cinet_pay_services.dart';
import 'package:provider/provider/payment/components/flutter_wave_services.dart';
import 'package:provider/provider/payment/components/razor_pay_services.dart';
import 'package:provider/provider/payment/components/sadad_services.dart';
import 'package:provider/provider/payment/components/stripe_services.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../components/empty_error_state_widget.dart';
import '../../models/configuration_response.dart';

class PaymentScreen extends StatefulWidget {
  final ProviderSubscriptionModel selectedPricingPlan;

  const PaymentScreen(this.selectedPricingPlan);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  RazorPayServices razorPayServices = RazorPayServices();

  List<PaymentSetting> paymentList = [];

  PaymentSetting? selectedPaymentSetting;

  bool isPaymentProcessing = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    paymentList = PaymentSetting.decode(getStringAsync(PAYMENT_LIST));
    paymentList.removeWhere((element) => element.type == PAYMENT_METHOD_COD);
    paymentList.removeWhere((element) => element.type == PAYMENT_METHOD_PAYPAL);

    if (paymentList.isNotEmpty) {
      selectedPaymentSetting = paymentList.first;
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  void _handleClick() async {
    if (isPaymentProcessing) return;
    isPaymentProcessing = false;

    if (selectedPaymentSetting!.type == PAYMENT_METHOD_STRIPE) {
      if (selectedPaymentSetting!.isTest == 1) {
        appStore.setLoading(true);

        await stripeServices.init(
          providerData: widget.selectedPricingPlan,
          stripePaymentPublishKey: selectedPaymentSetting!.testValue!.stripePublickey.validate(),
          totalAmount: widget.selectedPricingPlan.amount.validate(),
          stripeURL: selectedPaymentSetting!.testValue!.stripeUrl.validate(),
          stripePaymentKey: selectedPaymentSetting!.testValue!.stripeKey.validate(),
          isTest: true,
        );
        await 1.seconds.delay;
        stripeServices.stripePay(onPaymentComplete: () {
          isPaymentProcessing = false;
        });
      } else {
        appStore.setLoading(true);

        await stripeServices.init(
          providerData: widget.selectedPricingPlan,
          stripePaymentPublishKey: selectedPaymentSetting!.liveValue!.stripePublickey.validate(),
          totalAmount: widget.selectedPricingPlan.amount.validate(),
          stripeURL: selectedPaymentSetting!.liveValue!.stripeUrl.validate(),
          stripePaymentKey: selectedPaymentSetting!.liveValue!.stripeKey.validate(),
          isTest: false,
        );
        await 1.seconds.delay;
        stripeServices.stripePay(onPaymentComplete: () {
          isPaymentProcessing = false;
        });
      }
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_RAZOR) {
      if (selectedPaymentSetting!.isTest == 1) {
        appStore.setLoading(true);
        razorPayServices.init(razorKey: selectedPaymentSetting!.testValue!.razorKey!, data: widget.selectedPricingPlan);

        await 1.seconds.delay;
        appStore.setLoading(false);
        razorPayServices.razorPayCheckout(widget.selectedPricingPlan.amount.validate());
      } else {
        appStore.setLoading(true);
        razorPayServices.init(razorKey: selectedPaymentSetting!.liveValue!.razorKey!, data: widget.selectedPricingPlan);

        await 1.seconds.delay;
        appStore.setLoading(false);
        razorPayServices.razorPayCheckout(widget.selectedPricingPlan.amount.validate());
      }
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_FLUTTER_WAVE) {
      if (selectedPaymentSetting!.isTest == 1) {
        appStore.setLoading(true);

        FlutterWaveServices().payWithFlutterWave(
          selectedPricingPlan: widget.selectedPricingPlan,
          flutterWavePublicKey: selectedPaymentSetting!.testValue!.flutterwavePublic.validate(),
          flutterWaveSecretKey: selectedPaymentSetting!.testValue!.flutterwaveSecret.validate(),
          isTestMode: true,
        );
      } else {
        appStore.setLoading(true);

        FlutterWaveServices().payWithFlutterWave(
          selectedPricingPlan: widget.selectedPricingPlan,
          flutterWavePublicKey: selectedPaymentSetting!.liveValue!.flutterwavePublic.validate(),
          flutterWaveSecretKey: selectedPaymentSetting!.liveValue!.flutterwaveSecret.validate(),
          isTestMode: false,
        );
      }
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_CINETPAY) {
      List<String> supportedCurrencies = ["XOF", "XAF", "CDF", "GNF", "USD"];

      if (!supportedCurrencies.contains(appStore.currencyCode)) {
        toast(languages.lblYourCurrenciesNotSupport);
        return;
      }

      appStore.setLoading(true);

      if (selectedPaymentSetting!.isTest == 1) {
        CinetPayServices cinetPayServices = CinetPayServices(
          cinetPayApiKey: selectedPaymentSetting!.testValue!.cinetPublicKey.validate(),
          totalAmount: widget.selectedPricingPlan.amount.validate(),
          planData: widget.selectedPricingPlan,
          siteId: selectedPaymentSetting!.testValue!.cinetId.validate(),
          secretKey: selectedPaymentSetting!.testValue!.cinetKey.validate(),
        );
        await 1.seconds.delay;

        cinetPayServices.payWithCinetPay(context: context);
      } else {
        CinetPayServices cinetPayServices = CinetPayServices(
          cinetPayApiKey: selectedPaymentSetting!.liveValue!.cinetPublicKey.validate(),
          totalAmount: widget.selectedPricingPlan.amount.validate(),
          planData: widget.selectedPricingPlan,
          siteId: selectedPaymentSetting!.liveValue!.cinetId.validate(),
          secretKey: selectedPaymentSetting!.liveValue!.cinetKey.validate(),
        );
        await 1.seconds.delay;

        cinetPayServices.payWithCinetPay(context: context);
      }
    } else if (selectedPaymentSetting!.type == PAYMENT_METHOD_SADAD_PAYMENT) {
      if (selectedPaymentSetting!.isTest == 1) {
        appStore.setLoading(true);
        SadadServices sadadServices = SadadServices(
          sadadId: selectedPaymentSetting!.testValue!.sadadId.validate(),
          sadadKey: selectedPaymentSetting!.testValue!.sadadKey.validate(),
          sadadDomain: selectedPaymentSetting!.testValue!.sadadDomain.validate(),
          totalAmount: widget.selectedPricingPlan.amount.validate(),
          planData: widget.selectedPricingPlan,
        );

        await 1.seconds.delay;
        await sadadServices.payWithSadad(context);
        appStore.setLoading(false);
      } else {
        appStore.setLoading(true);
        SadadServices sadadServices = SadadServices(
          sadadId: selectedPaymentSetting!.liveValue!.sadadId.validate(),
          sadadKey: selectedPaymentSetting!.liveValue!.sadadKey.validate(),
          sadadDomain: selectedPaymentSetting!.liveValue!.sadadDomain.validate(),
          totalAmount: widget.selectedPricingPlan.amount.validate(),
          planData: widget.selectedPricingPlan,
        );

        await 1.seconds.delay;
        await sadadServices.payWithSadad(context);
        appStore.setLoading(false);
      }
    }
    /*else if (currentTimeValue!.type == PAYMENT_METHOD_PAYPAL) {
      if (currentTimeValue!.isTest == 1) {
        appStore.setLoading(true);

        PaypalPayment paypalPayment = PaypalPayment(
          totalAmount: widget.selectedPricingPlan.amount.validate(),
          planData: widget.selectedPricingPlan,
          payPalUrl: currentTimeValue!.testValue!.paypalUrl.validate(),
        );

        await 1.seconds.delay;
        paypalPayment.brainTreeDrop();
      } else {
        appStore.setLoading(true);

        PaypalPayment paypalPayment = PaypalPayment(
          totalAmount: widget.selectedPricingPlan.amount.validate(),
          planData: widget.selectedPricingPlan,
          payPalUrl: currentTimeValue!.liveValue!.paypalUrl.validate(),
        );

        await 1.seconds.delay;
        paypalPayment.brainTreeDrop();
      }
    }*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(languages.lblPayment, color: context.primaryColor, textColor: Colors.white, backWidget: BackWidget()),
      body: Stack(
        children: [
          if (paymentList.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                16.height,
                Text(languages.lblChoosePaymentMethod, style: boldTextStyle(size: 18)).paddingOnly(left: 16),
                16.height,
                AnimatedListView(
                  itemCount: paymentList.length,
                  shrinkWrap: true,
                  listAnimationType: ListAnimationType.FadeIn,
                  fadeInConfiguration: FadeInConfiguration(duration: 2.seconds),
                  itemBuilder: (context, index) {
                    PaymentSetting value = paymentList[index];
                    return RadioListTile<PaymentSetting>(
                      dense: true,
                      activeColor: primaryColor,
                      value: value,
                      controlAffinity: ListTileControlAffinity.trailing,
                      groupValue: selectedPaymentSetting,
                      onChanged: (PaymentSetting? ind) {
                        selectedPaymentSetting = ind;
                        setState(() {});
                      },
                      title: Text(value.title.validate(), style: primaryTextStyle()),
                    );
                  },
                ),
                Spacer(),
                AppButton(
                  onTap: () {
                    if (selectedPaymentSetting!.type == PAYMENT_METHOD_COD) {
                      showConfirmDialogCustom(
                        context,
                        dialogType: DialogType.CONFIRMATION,
                        title: "${languages.lblPayWith} ${selectedPaymentSetting!.title.validate()}",
                        primaryColor: primaryColor,
                        positiveText: languages.lblYes,
                        negativeText: languages.lblNo,
                        onAccept: (p0) {
                          _handleClick();
                        },
                      );
                    } else {
                      _handleClick();
                    }
                  },
                  text: languages.lblProceed,
                  color: context.primaryColor,
                  width: context.width(),
                ).paddingAll(16),
              ],
            ),
          if (paymentList.isEmpty)
            NoDataWidget(
              imageWidget: EmptyStateWidget(),
              title: languages.lblNoPayments,
              imageSize: Size(150, 150),
            ),
          Observer(builder: (context) => LoaderWidget().center().visible(appStore.isLoading))
        ],
      ),
    );
  }
}
