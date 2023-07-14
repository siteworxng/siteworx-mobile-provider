import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/back_widget.dart';
import 'package:provider/main.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:provider/utils/images.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordCont = TextEditingController();
  TextEditingController newPasswordCont = TextEditingController();
  TextEditingController reenterPasswordCont = TextEditingController();

  FocusNode oldPasswordFocus = FocusNode();
  FocusNode newPasswordFocus = FocusNode();
  FocusNode reenterPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  Future<void> changePassword() async {
    await setValue(USER_PASSWORD, newPasswordCont.text);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);
      appStore.setLoading(true);

      var request = {
        UserKeys.oldPassword: oldPasswordCont.text,
        UserKeys.newPassword: newPasswordCont.text,
      };

      await changeUserPassword(request).then(
        (res) async {
          appStore.setLoading(false);
          toast(res.message);
          finish(context);
        },
      ).catchError(
        (e) {
          toast(e.toString(), print: true);
          appStore.setLoading(false);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        languages.changePassword,
        backWidget: BackWidget(),
        showBack: true,
        textColor: white,
        color: context.primaryColor,
        elevation: 0.0,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Container(
              height: context.height(),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(languages.changePasswordTitle, style: secondaryTextStyle()),
                    24.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: oldPasswordCont,
                      focus: oldPasswordFocus,
                      suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                      suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                      validator: (s) {
                        if (s!.isEmpty)
                          return languages.hintRequired;
                        else
                          return null;
                      },
                      nextFocus: newPasswordFocus,
                      decoration: inputDecoration(context, hint: languages.hintOldPasswordTxt),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: newPasswordCont,
                      focus: newPasswordFocus,
                      suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                      suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                      validator: (s) {
                        if (s!.isEmpty)
                          return languages.hintRequired;
                        else
                          return null;
                      },
                      nextFocus: reenterPasswordFocus,
                      decoration: inputDecoration(context, hint: languages.hintNewPasswordTxt),
                    ),
                    16.height,
                    AppTextField(
                      textFieldType: TextFieldType.PASSWORD,
                      controller: reenterPasswordCont,
                      focus: reenterPasswordFocus,
                      suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
                      suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
                      validator: (v) {
                        if (newPasswordCont.text != v) {
                          return languages.passwordNotMatch;
                        } else if (reenterPasswordCont.text.isEmpty) {
                          return languages.hintRequired;
                        }
                        return null;
                      },
                      onFieldSubmitted: (s) {
                        ifNotTester(context, () {
                          changePassword();
                        });
                      },
                      decoration: inputDecoration(context, hint: languages.hintReenterPasswordTxt),
                    ),
                    24.height,
                    AppButton(
                      text: languages.confirm,
                      height: 40,
                      color: primaryColor,
                      textStyle: primaryTextStyle(color: white),
                      width: context.width() - context.navigationBarHeight,
                      onTap: () {
                        ifNotTester(context, () {
                          changePassword();
                        });
                      },
                    ),
                    24.height,
                  ],
                ),
              ),
            ),
          ),
          Observer(builder: (_) => LoaderWidget().center().visible(appStore.isLoading)),
        ],
      ),
    );
  }
}
