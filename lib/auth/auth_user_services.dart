import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/main.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/networks/network_utils.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

Future<UserData> loginCurrentUsers(BuildContext context, {required Map<String, dynamic> req}) async {
  try {
    appStore.setLoading(true);

    final userValue = await loginUser(req);

    log("***************** Normal Login Succeeds*****************");

    try {
      final firebaseUid = await firebaseLogin(context, data: userValue.data!);

      userValue.data!.uid = firebaseUid;
    } on Exception catch (e) {
      return userValue.data!;
    }
    userValue.data!.password = req['password'];

    return userValue.data!;
  } catch (e) {
    log("<<<<<<$e>>>>>>");
    throw e.toString();
  }
}

Future<String> firebaseLogin(BuildContext context, {required UserData data}) async {
  try {
    final firebaseEmail = data.email.validate();
    final firebaseUid = await authService.signInWithEmailPassword(email: firebaseEmail);

    log("***************** User Already Registered in Firebase*****************");

    if (await userService.isUserExistWithUid(firebaseUid)) {
      return firebaseUid;
    } else {
      data.uid = firebaseUid;
      return await authService.setRegisterData(userData: data).catchError((ee) {
        throw "Cannot Register";
      });
    }
  } catch (e) {
    log("======= $e");
    if (e.toString() == USER_NOT_FOUND) {
      log("***************** ($e) User Not Found, Again registering the current user *****************");

      return await registerUserInFirebase(context, user: data);
    } else {
      throw e.toString();
    }
  }
}

Future<String> registerUserInFirebase(BuildContext context, {required UserData user}) async {
  try {
    log("*************************************************** Login user is registering again.  ***************************************************");
    return authService.signUpWithEmailPassword(context, userData: user);
  } catch (e) {
    throw e.toString();
  }
}

Future<void> updatePlayerId({required String playerId}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('update-profile');
  Map<String, dynamic> req = {
    UserKeys.id: appStore.userId,
    UserKeys.playerId: playerId,
  };

  multiPartRequest.fields.addAll(await getMultipartFields(val: req));

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log("MultiPart Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    if ((temp as String).isJson()) {
      appStore.setPlayerId(playerId);
    }
  }, onError: (error) {
    toast(error.toString(), print: true);
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
    toast(e.toString());
  });
}
