import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


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
                    child: Text('Done'),    
                    onPressed: () {    
                        _auth.currentUser().then((user) {    
                        if (user != null) {    
                            Navigator.of(context).pop();    
                            Navigator.of(context).pushReplacementNamed('/home');    
                        } else {    
                            signIn();    
                        }    
                        });    
                    },    
                    )    
                ],    
                );    
        });    
    }    
    
    signIn() async {    
        try {    
            final AuthCredential credential = PhoneAuthProvider.getCredential(    
            verificationId: verificationId,    
            smsCode: smsOTP,    
            );    
            final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;    
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
    
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //         body: SingleChildScrollView(
  //       child: Column(
  //         mainAxisAlignment: MainAxisAlignment.start,
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           imageContainer(),
  //           SizedBox(height: 15.0,),
  //           labelText()
  //         ],
  //       ),
  //     ),
  //   );
  // }

  @override    
    Widget build(BuildContext context) {    
        return Scaffold(    
            appBar: AppBar(    
            //title: Text(widget.title),    
            ),    
            body: Center(    
            child: Column(    
                mainAxisAlignment: MainAxisAlignment.center,    
                children: <Widget>[    
                Padding(    
                    padding: EdgeInsets.all(10),    
                    child: TextField(    
                    decoration: InputDecoration(    
                        hintText: 'Enter Phone Number Eg. +910000000000'),    
                    onChanged: (value) {    
                        this.phoneNo = value;    
                    },    
                    ),    
                ),    
                (errorMessage != ''    
                    ? Text(    
                        errorMessage,    
                        style: TextStyle(color: Colors.red),    
                        )    
                    : Container()),    
                SizedBox(    
                    height: 10,    
                ),    
                RaisedButton(    
                    onPressed: () {    
                    verifyPhone();    
                    },    
                    child: Text('Verify'),    
                    textColor: Colors.white,    
                    elevation: 7,    
                    color: Colors.blue,    
                )    
                ],    
            ),    
            ),    
        );    
    }   



  Widget imageContainer(){
    return Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.6,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(100.0),bottomRight: Radius.circular(100.0))
            ),
            );
  }


  Widget labelText(){
    return Padding(
      padding: const EdgeInsets.only(left: 20.0,top: 8.0),
      child: Text('Enter your mobile number',style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20.0)),
    );
  }


  // Widget inputField(){
  //   return TextInput()
  // }
}