import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:occipital_tech/enums/view_state.dart';
import 'package:occipital_tech/models/user_check.dart';
import 'package:occipital_tech/scoped_models/user_model.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/locator.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginOTPScreen extends StatefulWidget {
  @override
  _LoginOTPScreenState createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
  String phoneNo;
  String smsOTP;
  String verificationId;
  String errorMessage = '';
  FirebaseAuth _auth = FirebaseAuth.instance;

  void dispose() {
    super.dispose();
  }

  Future<void> verifyPhone() async {
    final PhoneCodeSent smsOTPSent = (String verId, [int forceCodeResend]) {
      this.verificationId = verId;
      smsOTPDialog(context).then((value) {
        print('sign in');
      });
    };
    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: this.phoneNo, // PHONE NUMBER TO SEND OTP
          codeAutoRetrievalTimeout: (String verId) {
            //Starts the phone number verification process for the given phone number.
            //Either sends an SMS with a 6 digit code to the phone number specified, or sign's the user in and [verificationCompleted] is called.
            this.verificationId = verId;
          },
          codeSent:
              smsOTPSent, // WHEN CODE SENT THEN WE OPEN DIALOG TO ENTER OTP.
          timeout: const Duration(seconds: 20),
          verificationCompleted: (AuthCredential phoneAuthCredential) {
            print(phoneAuthCredential);
          },
          verificationFailed: (AuthException exceptio) {
            print('${exceptio.message}');
          });
    } catch (e) {
      handleError(e);
    }
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    final UserModel model = locator<UserModel>();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter SMS Code'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  onChanged: (value) {
                    this.smsOTP = value;
                  },
                ),
                (errorMessage != ''
                    ? Text(
                        errorMessage,
                        style: TextStyle(color: Colors.red),
                      )
                    : Container())
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              FlatButton(
                child: model.state== ViewState.Busy ? CircularProgressIndicator(): Text('Done'),
                onPressed: () async {
                  final user = await _auth.currentUser();
                  _onButtonPressed(user);

                  // if (user != null) {
                  //   // Navigator.of(context).pop();
                  //   final response = await ApiClient.checkUser(
                  //       UserCheck(phoneNo.substring(3)));
                  //   //   _showDialog();
                  //   if (response.status == 'False') {
                  //     print('Verified user');
                  //     Navigator.of(context).pushReplacementNamed('/home');
                  //   } else {
                  //     print('Not verified');
                  //     // Navigator.of(context).pop();
                  //     Navigator.of(context).pushNamed('/signup');
                  //   }
                  // } else {
                  //   signIn();
                  // }
                },
              )
            ],
          );
        });
  }

  _onButtonPressed(FirebaseUser user) async {
    final UserModel model = locator<UserModel>();
    final user = await _auth.currentUser();
    if(user!=null){
      model.storePhoneNo(phoneNo.substring(3));
      final response = await model.checkUser(UserCheck(phoneNo.substring(3)));  
      if(response['success']=='True'){
        Navigator.pushNamed(context, '/signup');
      }else{
        Navigator.pushReplacementNamed(context, '/home');
      }
    }else{
      signIn();
    }
  }

  _showDialog() {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  width: 5.0,
                ),
                Text('Verfiying user...')
              ],
            ),
          );
        });
  }

  signIn() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId,
        smsCode: smsOTP,
      );
      final FirebaseUser user =
          (await _auth.signInWithCredential(credential)).user;
      final FirebaseUser currentUser = await _auth.currentUser();
      assert(user.uid == currentUser.uid);
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      handleError(e);
    }
  }

  handleError(PlatformException error) {
    print(error);
    switch (error.code) {
      case 'ERROR_INVALID_VERIFICATION_CODE':
        FocusScope.of(context).requestFocus(new FocusNode());
        setState(() {
          errorMessage = 'Invalid Code';
        });
        Navigator.of(context).pop();
        smsOTPDialog(context).then((value) {
          print('sign in');
        });
        break;
      default:
        setState(() {
          errorMessage = error.message;
        });

        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
      builder: (context, chuild, UserModel model) => Scaffold(
        body: ListView(
          //padding: EdgeInsets.all(16.0),
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                imageContainer(),
                SizedBox(
                  height: 15.0,
                ),
                labelText(),
                SizedBox(
                  height: 10.0,
                ),
                inputField(),
                SizedBox(
                  height: 10.0,
                ),
                Text('We will send you one time password'),
                Text('on your mobile number'),
                SizedBox(
                  height: 30.0,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: RawMaterialButton(
                    onPressed: () {
                      verifyPhone();
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 25.0,
                    ),
                    shape: CircleBorder(),
                    elevation: 2.0,
                    fillColor: Colors.green,
                    padding: EdgeInsets.all(15.0),
                  ),
                ),

                SizedBox(
                  height: 10.0,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget imageContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.55,
      decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100.0),
              bottomRight: Radius.circular(100.0))),
    );
  }

  Widget labelText() {
    return Text(
      'Enter your mobile number',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      textAlign: TextAlign.start,
    );
  }

  Widget inputField() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: TextField(
        decoration: InputDecoration(
           
            hintText: 'Your mobile number',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30.0)),
            contentPadding: EdgeInsets.all(15.0)),
        onChanged: (value) {
          this.phoneNo = '+91$value';
        },
      ),
    );
  }
}
