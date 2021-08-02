import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

import 'package:untitled1/model/userModel.dart';
import 'package:untitled1/services/auth.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  final CollectionReference userCollection =
      Firestore.instance.collection('users');
  final CollectionReference noticeCollection =
      Firestore.instance.collection('notices');
  final CollectionReference syllabusCollection =
      Firestore.instance.collection('syllabus');



// create user in database
  Future updateUserDataInDatabase(UserModel user) async {
    if (uid == null || uid.isEmpty) return false;
    await userCollection.document(uid).setData({
      'status': user.status,
      'email': user.email,
      'uid': user.uid,
    }).whenComplete(() {
      return true;
    });
  }

  Future<UserModel> getUserDataFromDatabase() async {
    String uid = await AuthProvider().getCurrentUserID();
    var docs = await userCollection.document(uid).get();
    print('Name: ${docs.data['name']}');
    var usr = docs.data;
    UserModel currentUser = UserModel(
      status: usr['status'],
      email: usr['email'],
      uid: usr['uid'],
    );
    return currentUser;
  }

  Future<bool> checkUserInDatabase() async {
    bool isAvailable;
    await userCollection
        .where('uid', isEqualTo: uid)
        .getDocuments()
        .then((value) => {
              if (value.documents == null || value.documents.isEmpty)
                {isAvailable = false}
              else
                {isAvailable = true}
            });
    return isAvailable;
  }

  Future<bool> updateProfileUrl({String url}) async {
    await userCollection
        .document(uid)
        .updateData({'profileUrl': url}).then((value) {
      return true;
    });
    return false;
  }

  Future<String> getSyllabusUrl({String dept, String year}) async {
    var snap = await syllabusCollection.document(dept).get();
    return snap.data[year];
  }

  Future<String> uploadImage({File file}) async {
    String imageUrl;
    final StorageReference _storageReference = FirebaseStorage()
        .ref()
        .child('userData')
        .child('profilePics')
        .child(uid); //the name of file;
    print('uploading....');
    StorageTaskSnapshot snapshot =
        await _storageReference.putFile(file).onComplete;
    if (snapshot.error == null) {
      imageUrl = await snapshot.ref.getDownloadURL();
    } else {
      print('error in uploading image ${snapshot.error.toString()}');
    }
    print('Upload Successful:  $imageUrl');
    return imageUrl;
  }
}
