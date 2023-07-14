import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/auth/auth_user_services.dart';
import 'package:provider/auth/component/user_demo_mode_screen.dart';
import 'package:provider/auth/forgot_password_dialog.dart';
import 'package:provider/auth/sign_up_screen.dart';
import 'package:provider/components/app_widgets.dart';
import 'package:provider/components/selected_item_widget.dart';
import 'package:provider/handyman/handyman_dashboard_screen.dart';
import 'package:provider/main.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/provider_dashboard_screen.dart';
import 'package:provider/utils/common.dart';
import 'package:provider/utils/configs.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/extensions/string_extension.dart';
import 'package:provider/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class SignInScreen extends StatefulWidget {
  final bool isRegeneratingToken;

  SignInScreen({this.isRegeneratingToken = false});

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Text Field Controller
  TextEditingController emailCont = TextEditingController();
  TextEditingController passwordCont = TextEditingController();

  /// FocusNodes
  FocusNode emailFocus = FocusNode();
  FocusNode passwordFocus = FocusNode();

  bool isRemember = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    isRemember = getBoolAsync(IS_REMEMBERED, defaultValue: true);
    if (isRemember) {
      emailCont.text = getStringAsync(USER_EMAIL);
      passwordCont.text = getStringAsync(USER_PASSWORD);
    }
    if (widget.isRegeneratingToken) {
      emailCont.text = appStore.userEmail;
      passwordCont.text = getStringAsync(USER_PASSWORD);

      _handleLogin(isDirectLogin: true);
    }
  }

  //region Widgets
  Widget _buildTopWidget() {
    return Column(
      children: [
        32.height,
        Text(languages.lblLoginTitle, style: boldTextStyle(size: 18)).center(),
        16.height,
        Text(
          languages.lblLoginSubtitle,
          style: secondaryTextStyle(size: 14),
          textAlign: TextAlign.center,
        ).paddingSymmetric(horizontal: 32).center(),
        64.height,
      ],
    );
  }

  Widget _buildFormWidget() {
    return AutofillGroup(
      onDisposeAction: AutofillContextAction.commit,
      child: Column(
        children: [
          AppTextField(
            textFieldType: TextFieldType.EMAIL_ENHANCED,
            controller: emailCont,
            focus: emailFocus,
            nextFocus: passwordFocus,
            errorThisFieldRequired: languages.hintRequired,
            decoration: inputDecoration(context, hint: languages.hintEmailAddressTxt),
            suffix: ic_message.iconImage(size: 10).paddingAll(14),
            autoFillHints: [AutofillHints.email],
          ),
          16.height,
          AppTextField(
            textFieldType: TextFieldType.PASSWORD,
            controller: passwordCont,
            focus: passwordFocus,
            errorThisFieldRequired: languages.hintRequired,
            suffixPasswordVisibleWidget: ic_show.iconImage(size: 10).paddingAll(14),
            suffixPasswordInvisibleWidget: ic_hide.iconImage(size: 10).paddingAll(14),
            errorMinimumPasswordLength: "${languages.errorPasswordLength} $passwordLengthGlobal",
            decoration: inputDecoration(context, hint: languages.hintPassword),
            autoFillHints: [AutofillHints.password],
            onFieldSubmitted: (s) {
              _handleLogin();
            },
          ),
          8.height,
        ],
      ),
    );
  }

  Widget _buildForgotRememberWidget() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                2.width,
                SelectedItemWidget(isSelected: isRemember).onTap(() async {
                  await setValue(IS_REMEMBERED, isRemember);
                  isRemember = !isRemember;
                  setState(() {});
                }),
                TextButton(
                  onPressed: () async {
                    await setValue(IS_REMEMBERED, isRemember);
                    isRemember = !isRemember;
                    setState(() {});
                  },
                  child: Text(languages.rememberMe, style: secondaryTextStyle()),
                ),
              ],
            ),
            TextButton(
              child: Text(
                languages.forgotPassword,
                style: boldTextStyle(color: primaryColor, fontStyle: FontStyle.italic),
                textAlign: TextAlign.right,
              ),
              onPressed: () {
                showInDialog(
                  context,
                  contentPadding: EdgeInsets.zero,
                  dialogAnimation: DialogAnimation.SLIDE_TOP_BOTTOM,
                  builder: (_) => ForgotPasswordScreen(),
                );
              },
            ).flexible()
          ],
        ),
        32.height,
      ],
    );
  }

  Widget _buildButtonWidget() {
    return Column(
      children: [
        AppButton(
          text: languages.signIn,
          height: 40,
          color: primaryColor,
          textStyle: primaryTextStyle(color: white),
          width: context.width() - context.navigationBarHeight,
          onTap: () {
            _handleLogin();
          },
        ),
        16.height,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(languages.doNotHaveAccount, style: secondaryTextStyle()),
            TextButton(
              onPressed: () {
                SignUpScreen().launch(context);
              },
              child: Text(
                languages.signUp,
                style: boldTextStyle(
                  color: primaryColor,
                  decoration: TextDecoration.underline,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }

  //endregion

  //region Methods
  void _handleLogin({bool isDirectLogin = false}) {
    if (isDirectLogin) {
      _handleLoginUsers();
    } else {
      hideKeyboard(context);
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        _handleLoginUsers();
      }
    }
  }

  void _handleLoginUsers() async {
    hideKeyboard(context);
    Map<String, dynamic> request = {
      'email': emailCont.text.trim(),
      'password': passwordCont.text.trim(),
      'player_id': getStringAsync(PLAYERID),
    };

    log(request);

    await loginCurrentUsers(context, req: request).then((value) async {
      if (isRemember) {
        setValue(USER_EMAIL, emailCont.text);
        setValue(USER_PASSWORD, passwordCont.text);
        await setValue(IS_REMEMBERED, isRemember);
      }

      redirectWidget(res: value);
      toast("Login Successfully");
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  void redirectWidget({required UserData res}) async {
    TextInput.finishAutofillContext();

    if (res.status.validate() == 1) {
      appStore.setTester(res.email == DEFAULT_PROVIDER_EMAIL || res.email == DEFAULT_HANDYMAN_EMAIL);

      /// Redirect on the base of User Role.
      if (res.userType.validate().trim() == USER_TYPE_PROVIDER) {
        /// if User type id Provider
        await saveUserData(res);
        ProviderDashboardScreen(index: 0).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      } else if (res.userType.validate().trim() == USER_TYPE_HANDYMAN) {
        /// if User type id Handyman
        await saveUserData(res);
        HandymanDashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      } else {
        toast(languages.cantLogin, print: true);
      }
    } else {
      appStore.setLoading(false);
      toast(languages.lblWaitForAcceptReq);
    }
  }

  //endregion

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(
        "",
        elevation: 0,
        showBack: false,
        color: context.scaffoldBackgroundColor,
        systemUiOverlayStyle: SystemUiOverlayStyle(statusBarIconBrightness: getStatusBrightness(val: appStore.isDarkMode), statusBarColor: context.scaffoldBackgroundColor),
      ),
      body: SizedBox(
        width: context.width(),
        child: Stack(
          children: [
            Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTopWidget(),
                    _buildFormWidget(),
                    _buildForgotRememberWidget(),
                    _buildButtonWidget(),
                    16.height,
                    SnapHelperWidget<bool>(
                        future: isIqonicProduct,
                        onSuccess: (data) {
                          if (data) {
                            return UserDemoModeScreen(
                              onChanged: (email, password) {
                                if (email.isNotEmpty && password.isNotEmpty) {
                                  emailCont.text = email;
                                  passwordCont.text = password;
                                } else {
                                  emailCont.clear();
                                  passwordCont.clear();
                                }
                              },
                            );
                          }
                          return Offstage();
                        }),
                  ],
                ),
              ),
            ),
            Observer(
              builder: (_) => LoaderWidget().center().visible(appStore.isLoading),
            ),
          ],
        ),
      ),
    );
  }
}
