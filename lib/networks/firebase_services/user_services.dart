import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:provider/main.dart';
import 'package:provider/models/user_data.dart';
import 'package:provider/utils/constant.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';

import 'base_services.dart';

class UserService extends BaseService {
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;

  UserService() {
    ref = fireStore.collection(USER_COLLECTION);
  }

  Future<void> updateUserInfo(Map data, String id, {File? profileImage}) async {
    if (profileImage != null) {
      String fileName = basename(profileImage.path);
      Reference storageRef = _storage.ref().child("$PROFILE_IMAGE/$fileName");
      UploadTask uploadTask = storageRef.putFile(profileImage);
      await uploadTask.then((e) async {
        await e.ref.getDownloadURL().then((value) {
          appStore.setUserProfile(value);
          data.putIfAbsent("photoUrl", () => value);
        });
      });
    }

    return ref!.doc(id).update(data as Map<String, Object?>);
  }

  Future<void> updateUserStatus(Map data, String id) async {
    return ref!.doc(id).update(data as Map<String, Object?>);
  }

  Future<UserData> getUser({String? email}) {
    return ref!.where("email", isEqualTo: email).limit(1).get().then((value) {
      if (value.docs.length == 1) {
        return UserData.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw '${languages.lblNoUserFound}';
      }
    });
  }

  Future<UserData?> getUserNull({String? email}) {
    return ref!.where("email", isEqualTo: email).limit(1).get().then((value) {
      if (value.docs.length == 1) {
        return UserData.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        return null;
      }
    });
  }

  Stream<List<UserData>> users({String? searchText}) {
    return ref!.where('caseSearch', arrayContains: searchText.validate().isEmpty ? null : searchText!.toLowerCase()).snapshots().map((x) {
      return x.docs.map((y) {
        return UserData.fromJson(y.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<UserData> userByEmail(String? email) async {
    return await ref!.where('email', isEqualTo: email).limit(1).get().then((value) {
      if (value.docs.isNotEmpty) {
        return UserData.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw '${languages.lblNoUserFound}';
      }
    });
  }

  Stream<UserData> singleUser(String? id, {String? searchText}) {
    return ref!.where('uid', isEqualTo: id).limit(1).snapshots().map((event) {
      return UserData.fromJson(event.docs.first.data() as Map<String, dynamic>);
    });
  }

  Future<UserData> userByMobileNumber(String? phone) async {
    return await ref!.where('phoneNumber', isEqualTo: phone).limit(1).get().then((value) {
      if (value.docs.isNotEmpty) {
        return UserData.fromJson(value.docs.first.data() as Map<String, dynamic>);
      } else {
        throw "${languages.lblNoUserFound}";
      }
    });
  }

  Future<void> saveToContacts({required String senderId, required String receiverId}) async {
    return ref!.doc(senderId).collection(CONTACT_COLLECTION).doc(receiverId).update({'lastMessageTime': DateTime.now().millisecondsSinceEpoch}).catchError((e) {
      throw USER_NOT_CREATED;
    });
  }

  Future<void> updatePlayerIdInFirebase({required String email, required String playerId}) async {
    await userByEmail(email).then((value) {
      ref!.doc(value.uid.validate()).update({
        'player_id': playerId,
        'updated_at': Timestamp.now().toDate().toString(),
      });
    }).catchError((e) {
      toast(e.toString());
    });
  }

  Future<void> deleteUser() async {
    await FirebaseAuth.instance.currentUser!.delete();
    await FirebaseAuth.instance.signOut();
  }

  Future<bool> isUserExistWithUid(String? uid) async {
    Query query = ref!.limit(1).where('uid', isEqualTo: uid);
    var res = await query.get();

    return res.docs.isNotEmpty;
  }

  Future<bool> isReceiverInContacts({required String senderUserId, required String receiverUserId}) async {
    final contactRef = ref!.doc(senderUserId).collection(CONTACT_COLLECTION).doc(receiverUserId);

    final contactSnapshot = await contactRef.get();
    return contactSnapshot.exists;
  }
}
