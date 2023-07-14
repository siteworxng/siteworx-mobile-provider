import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/main.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class AuthService {
  //region Email

  Future<String> signUpWithEmailPassword(BuildContext context, {required UserData userData}) async {
    return await _auth.createUserWithEmailAndPassword(email: userData.email.validate(), password: DEFAULT_PASSWORD_FOR_FIREBASE).then((userCredential) async {
      User currentUser = userCredential.user!;

      userData.uid = currentUser.uid.validate();
      userData.createdAt = Timestamp.now().toDate().toString();
      userData.updatedAt = Timestamp.now().toDate().toString();
      userData.playerId = getStringAsync(PLAYERID);

      log("Step 1 ${userData.toFirebaseJson()}");

      return await setRegisterData(userData: userData);
    }).catchError((e) {
      throw "User is Not Registered in Firebase";
    });
  }

  Future<String> setRegisterData({required UserData userData}) async {
    return await userService.addDocumentWithCustomId(userData.uid.validate(), userData.toFirebaseJson()).then((value) async {
      return value.id.validate();
    }).catchError((e) {
      throw false;
    });
  }

  Future<String> signInWithEmailPassword({required String email}) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: DEFAULT_PASSWORD_FOR_FIREBASE).then((value) async {
      return value.user!.uid.validate();
    }).catchError((e) async {
      appStore.setLoading(false);
      log(e.toString());
      FirebaseAuth.instance.currentUser?.delete();
      throw "User Not Found";
    });
  }
//endregion
}
