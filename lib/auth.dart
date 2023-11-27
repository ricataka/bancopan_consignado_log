import 'package:firebase_auth/firebase_auth.dart';
import 'modelo_participantes.dart';

// FirebaseUser loggedUser;
User? loggedUser = FirebaseAuth.instance.currentUser;

class AuthService {
  // HttpsCallable createUserCallable = FirebaseFunctions.instance.httpsCallable(
  //     'createUser',
  //     options: HttpsCallableOptions(timeout: Duration(seconds: 5)));

  String errorMessage = '';
  getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedUser = user;
        // print(loggedUser?.uid);
      }
    } catch (e) {
      // print(e.toString());
    }
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<String> createUser(String email, String senha) async {
  //   //create the data map to be send
  //   Map<String, dynamic> data = {
  //
  //   "email": email,
  //   "password": senha,
  //
  //   //Other custom attributes
  //
  //   };
  //   String uid = "0";
  //   await createUserCallable(data)
  //       .then((response) => {
  //   //save the id to return it
  //   if (response.data['status'] == 'success')
  //   {
  //   print("uid : " + response.data['uid']),
  //   uid = response.data['uid']
  //   }
  //   else
  //   //return a uid 0 on error
  //       {print(response.data['message']), uid = '0'}
  //   })
  //       .catchError((err) => {print('Error! : ' + err.toString())});
  //   return uid;
  // }

  User2? _userFromFirebase(User? user) {
    return User2(
      nome: user?.displayName ?? '', urlFoto: user?.photoURL ?? '',
      uid: user?.uid ?? '',
      email: user?.email ?? '',

      // nome: user.displayName,
      // urlFoto: user.photoURL ,
      // telefone: user.phoneNumber
    );
  }

  // void updateUserTelephone( String numerotelefone ) {
  //   var user = FirebaseAuth.instance.currentUser;
  //
  //   user.updatePhoneNumber(phoneCredential: numerotelefone).then((value){
  //     print("Profile has been changed successfully");
  //     //DO Other compilation here if you want to like setting the state of the app
  //   }).catchError((e){
  //     print("There was an error updating profile");
  //   });
  //
  // }
  criarUsuarioEmailSenha(String email, String password) async {
    try {} on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        // print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        // print('The account already exists for that email.');
      }
    } catch (e) {
      // print(e);
    }
  }

  void updateUserInfo(String nome, String photoURL) {
    var user = FirebaseAuth.instance.currentUser;

    user?.updateDisplayName(nome).then((value) {
      // print("Profile has been changed successfully");

      //DO Other compilation here if you want to like setting the state of the app
    }).catchError((e) {
      // print("There was an error updating profile");
    });
    user?.updatePhotoURL(photoURL).then((value) {
      // print("Profile has been changed successfully");

      //DO Other compilation here if you want to like setting the state of the app
    }).catchError((e) {
      // print("There was an error updating profile");
    });
  }

  // Stream<User2> get user {
  //   return _auth.idTokenChanges().map(_userFromFirebase);
  // }

  Stream<User2?> get user {
    return _auth.authStateChanges().map(_userFromFirebase);
  }

  Future signIn(String email, String password) async {
    try {
      // FirebaseMessaging _messaging;
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      User? user = userCredential.user;

      // _messaging = FirebaseMessaging.instance;
      // _messaging.getToken().then((deviceToken) {
        // print("device Token"+ deviceToken);
      //   DatabaseServiceDeviceToken().setDeviceToken(deviceToken);
      // });

      return user;
    } catch (e) {
      switch (e) {
        case "ERROR_INVALID_EMAIL":
          errorMessage = "Your email address appears to be malformed.";
          break;
        case "ERROR_WRONG_PASSWORD":
          errorMessage = "Your password is wrong.";
          break;
        case "ERROR_USER_NOT_FOUND":
          errorMessage = "User with this email doesn't exist.";
          break;
        case "ERROR_USER_DISABLED":
          errorMessage = "User with this email has been disabled.";
          break;
        case "ERROR_TOO_MANY_REQUESTS":
          errorMessage = "Too many requests. Try again later.";
          break;
        case "ERROR_OPERATION_NOT_ALLOWED":
          errorMessage = "Signing in with Email and Password is not enabled.";
          break;
        default:
          errorMessage = "An undefined Error happened.";
      }
      // print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await FirebaseAuth.instance.signOut();
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }
}
