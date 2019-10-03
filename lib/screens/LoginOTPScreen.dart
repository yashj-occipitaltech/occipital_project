import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:occipital_tech/enums/view_state.dart';
import 'package:occipital_tech/models/user_check.dart';
import 'package:occipital_tech/scoped_models/user_model.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/locator.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginOTPScreen extends StatefulWidget {
  @override
  _LoginOTPScreenState createState() => _LoginOTPScreenState();
}

class _LoginOTPScreenState extends State<LoginOTPScreen> {
  String phoneNo;
  String smsOTP='';
  String verificationId;
  String errorMessage = '';
  bool hasError = false;
  FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKeyOTP = GlobalKey<FormState>();

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
            this.verificationId = verId;
          },
          codeSent: smsOTPSent,
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
        body: Form(
          key: _formKeyOTP,
          child: ListView(
            children: <Widget>[loginView()],
          ),
        ),
      ),
    );
  }

  Widget loginView() {
    return Column(
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
        submitButton(),
        SizedBox(
          height: 10.0,
        )
      ],
    );
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    final UserModel model = locator<UserModel>();
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter OTP'),
            content: Column(mainAxisSize: MainAxisSize.min, children: [
              otpField(),
              Visibility(
                child: Text(
                  "Wrong PIN!",
                  style: TextStyle(color: Colors.red),
                ),
                visible: hasError,
              ),
              
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0)),
                  padding: EdgeInsets.all(16.0),
                  child: model.state == ViewState.Busy
                      ? CircularProgressIndicator()
                      : Text(
                          'Ok',
                          style: TextStyle(fontSize: 16.0),
                        ),
                  onPressed: () async {
                    final user = await _auth.currentUser();
                     if(smsOTP.isEmpty || smsOTP.length<6){
                       Fluttertoast.showToast(msg: 'Please enter the OTP');
                       setState(() {
                         hasError = true;
                       });
                     } else{
                        _onButtonPressed(user);
                     }
                   
                  },
                ),
              ),
              SizedBox(
                height: 10.0,
              )
            ]),
            contentPadding: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0)),
          );
        });
  }

  Widget otpField() {
    return PinCodeTextField(
      autofocus: true,
      hasError: hasError,
      pinCodeTextFieldLayoutType: PinCodeTextFieldLayoutType.WRAP,
      wrapAlignment: WrapAlignment.start,
      pinBoxWidth: 25.0,
      pinBoxDecoration: ProvidedPinBoxDecoration.underlinedPinBoxDecoration,
      maxLength: 6,
      onTextChanged: (value) {
        this.smsOTP = value;
      },
    );
  }

  Widget submitButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: RawMaterialButton(
        onPressed: () {
          if (_formKeyOTP.currentState.validate()) {
            _formKeyOTP.currentState.save();
            verifyPhone();
          }
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
    );
  }

  Widget imageContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
          image: DecorationImage(image: ExactAssetImage('assets/login_screen.png'),fit: BoxFit.fitHeight),
          ),
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
      child: TextFormField(
        validator: (String val) {
          if (val.isEmpty) {
            return 'Please enter your number';
          }
          if (val.length < 10) {
            return 'Please enter a valid phone number';
          }
          return null;
        },
        onSaved: (value) {
          this.phoneNo = '+91$value';
        },
        autofocus: true,
        autocorrect: false,
        
        keyboardType: TextInputType.number,
        inputFormatters: <TextInputFormatter>[
          WhitelistingTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(10)
        ],
        maxLength: 10,
        decoration: InputDecoration(
            counterText: '',
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

  _onButtonPressed(FirebaseUser user) async {
    final UserModel model = locator<UserModel>();
    final user = await _auth.currentUser();
    if (user != null) {
      model.storePhoneNo(phoneNo.substring(3));
      final response = await model.checkUser(UserCheck(phoneNo.substring(3)));
      if (response['success'] == 'True') {
        Navigator.pushNamed(context, '/signup');
      } 
      else if(response['success']=='Error' || response['resultCode']==2 || response['resultCode']==20 ){
        Fluttertoast.showToast(msg: 'Some error occured.Please try again');
      }
      else  {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      signIn();
    }
  }
}
