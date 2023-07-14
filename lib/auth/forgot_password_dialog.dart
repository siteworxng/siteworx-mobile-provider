import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/main.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController emailCont = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future<void> forgotPwd() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (emailCont.text == DEFAULT_HANDYMAN_EMAIL || emailCont.text == DEFAULT_PROVIDER_EMAIL) {
        toast(languages.lblUnAuthorized);
      } else {
        Map req = {UserKeys.email: emailCont.text.validate()};
        appStore.setLoading(true);

        forgotPassword(req).then((value) {
          appStore.setLoading(false);
          toast(value.message.toString());

          pop();
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString(), print: true);
        });
      }
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width(),
      color: Colors.transparent,
      child: Container(
        decoration: boxDecorationDefault(
          color: context.scaffoldBackgroundColor,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: context.width(),
                decoration: boxDecorationWithRoundedCorners(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
                  backgroundColor: primaryColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(languages.forgotPassword, style: boldTextStyle(color: white)).paddingOnly(left: 16),
                    CloseButton(color: Colors.white),
                  ],
                ),
              ),
              16.height,
              Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                padding: EdgeInsets.all(8),
                alignment: Alignment.bottomCenter,
                decoration: boxDecorationRoundedWithShadow(defaultRadius.toInt(), blurRadius: 0, backgroundColor: context.scaffoldBackgroundColor),
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(languages.forgotPasswordTitleTxt, style: primaryTextStyle().copyWith(height: 1.5)),
                      6.height,
                      Text(languages.forgotPasswordSubtitle, style: secondaryTextStyle()),
                      24.height,
                      AppTextField(
                        textFieldType: TextFieldType.EMAIL_ENHANCED,
                        controller: emailCont,
                        autoFocus: true,
                        validator: (s) {
                          if (s!.isEmpty)
                            return languages.hintRequired;
                          else
                            return null;
                        },
                        errorThisFieldRequired: languages.hintRequired,
                        decoration: inputDecoration(context, hint: languages.hintEmailAddressTxt, fillColor: context.cardColor),
                        onFieldSubmitted: (s) {
                          forgotPwd();
                        },
                      ),
                      24.height,
                      Observer(
                        builder: (_) => appStore.isLoading
                            ? LoaderWidget().center()
                            : AppButton(
                                text: languages.resetPassword,
                                color: primaryColor,
                                textStyle: primaryTextStyle(color: white),
                                width: context.width() - context.navigationBarHeight,
                                onTap: () {
                                  forgotPwd();
                                },
                              ),
                      ),
                      8.height,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
