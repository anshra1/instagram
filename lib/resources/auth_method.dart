import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/resources/storage_method.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser(
      {required String email,
      required String password,
      required String userName,
      required String bio,
      required Uint8List file}) async {
    String res = 'Some error occur';

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          userName.isNotEmpty ||
          bio.isNotEmpty) {
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password) ;
        print(cred.user!.uid);


        String photoUrl = await StorageMethod()
            .uploadImageToStorage('profilePics', file, false);

        await _firestore.collection('users').doc(cred.user!.uid).set({
          'username': userName,
          'uid': cred.user!.uid,
          'email': email,
          'bio': bio,
          'followers': [],
          'following': [],
          'photoUrl': photoUrl,
        });
        res = 'success';

        //   await _firestore.collection('users').add({
        //       'username':userName,
        //       'uid':cred.user!.uid,
        //       'email':email,
        //       'bio':bio,
        //       'followers':[],
        //       'following':[]
        //   });

      }
    } on FirebaseAuthException catch (err) {
      if (err.code == 'invalid-email') {
        res = 'The email is badly formatted';
      }
    } catch (err) {
      res == err.toString();
    }
    return res;
  }


  Future<String> loginUser ({required String email, required String password})async{
    String res = 'some error occured';

    try{
      if(email.isNotEmpty || password.isNotEmpty){
        await _auth.signInWithEmailAndPassword(email: email, password: password);
        res = 'success';
      }else{
        res = 'Please Enter All The Fileds';
      }
    }catch(err){
      res = err.toString();
    }
    return res;
  }



}
