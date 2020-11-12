import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutterjackpot/models/winner_score_model.dart';
import 'package:flutterjackpot/repository/signUpWithSocialMedia.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/common_toast.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/view/bottom_widget/winner_score_controller.dart';
import 'package:flutterjackpot/view/home/home_screen.dart';
import 'package:flutterjackpot/view/login_signUp/login_screen.dart';
import 'package:flutterjackpot/view/login_signUp/signup_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class LoginWithFBAndGoogleScreen extends StatefulWidget {
  @override
  _LoginWithFBAndGoogleScreenState createState() =>
      _LoginWithFBAndGoogleScreenState();
}

class _LoginWithFBAndGoogleScreenState
    extends State<LoginWithFBAndGoogleScreen> {
  static final platform = const MethodChannel("com.equitysoft.flutterjackpot");

  WinnerScoreController winnerScoreController = new WinnerScoreController();

  WinnerScore winnerScore = new WinnerScore();

  bool _isLoading = true;

  bool isLoggedIn = false;

  String _contactText;
  GoogleSignInAccount _currentUser;
  GoogleSignIn _googleSignIn = new GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  @override
  void initState() {
    super.initState();
    _getWinnerScore();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? Center(
              child: CupertinoActivityIndicator(
                radius: 15.0,
              ),
            )
          : _loginBodyWidget(winnerScore),
    );
  }

  Widget _loginBodyWidget(WinnerScore winnerScore) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              sizedBoxAddMob(60.0),
              SizedBox(
                height: 30.0,
              ),
              Text(
                "Trivia \$tax",
                style: TextStyle(
                    color: blackColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 30.0,
                    fontStyle: FontStyle.italic),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 30.0),
                child: layoutBuilderDot(blackColor),
              ),
              Text(
                "Five  Diamonds Media Group",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: blackColor,
                ),
              ),
              SizedBox(
                height: 25.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 10.0,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                decoration: BoxDecoration(
                  color: greenColor,
                  border: Border.all(
                    color: blackColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Trivia",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " Jackpots ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25.0,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " Prizes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0,
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              Container(
                width: MediaQuery.of(context).size.width - 10.0,
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
                decoration: BoxDecoration(
                  color: blackColor,
                  border: Border.all(
                    color: blackColor,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Current Member Jackpot",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.0,
                        color: greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Container(
//                width: MediaQuery.of(context).size.width - 80.0,
                      padding: EdgeInsets.symmetric(
                          vertical: 20.0, horizontal: 60.0),
                      decoration: BoxDecoration(
                        color: whiteColor,
                        border: Border.all(
                          color: blackColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      child: Text(
                        winnerScore.winnerScore != null
                            ? "\$ ${winnerScore.winnerScore}"
                            : "\$ 0",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0,
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                child: Container(
//                width: MediaQuery.of(context).size.width - 80.0,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: blackColor,
                    border: Border.all(
                      color: whiteColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "assets/facebook.png",
                        height: 45.0,
                        width: 45.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: AutoSizeText(
                          "Sign up with Facebook",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  initiateFacebookLogin();
//              getHaseKey();
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                child: Container(
//                width: MediaQuery.of(context).size.width - 80.0,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: blackColor,
                    border: Border.all(
                      color: whiteColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image.asset(
                        "assets/google.png",
                        height: 45.0,
                        width: 45.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 30.0),
                        child: AutoSizeText(
                          "Sign up with Google",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.0,
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  _handleSignIn();
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              InkWell(
                child: Container(
                  width: MediaQuery.of(context).size.width - 0.0,
                  padding:
                      EdgeInsets.symmetric(vertical: 21.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: blackColor,
                    border: Border.all(
                      color: whiteColor,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: AutoSizeText(
                    "Sign up",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22.0,
                      color: whiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SignUpScreen(),
                    ),
                  );
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                child: Text(
                  "Already have an account? Sign In",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: blackColor,
                    fontSize: 18.0,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LoginScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void initiateFacebookLogin() async {
    var facebookLogin = FacebookLogin();
    var facebookLoginResult = await facebookLogin.logIn(['email']);
    switch (facebookLoginResult.status) {
      case FacebookLoginStatus.error:
        print("Error");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("CancelledByUser");
        onLoginStatusChanged(false);
        break;
      case FacebookLoginStatus.loggedIn:
        print("LoggedIn");
        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${facebookLoginResult.accessToken.token}');

        var profile = json.decode(graphResponse.body);

        setState(() {
          _isLoading = true;
        });

        bool response = await LoginWithSocialRepository.loginWithSocial(
            token: facebookLoginResult.accessToken.token,
            isFbSignUp: true,
            name: profile['name'],
            emailId: profile['email']);

        if (response) {
          Common.showErrorToastMsg("Sign Up Success");
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(),
              ),
              (route) => false);
        } else {
          setState(() {
            Common.showErrorToastMsg("Something Wrong Please Try Again");
            _isLoading = false;
          });
        }
        onLoginStatusChanged(true);
        break;
    }
  }

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn().then((value) {
        if (value.displayName != null) {
          value.authentication.then((googleKey) async {
            print(googleKey.accessToken);
            print(googleKey.idToken);
            print(_googleSignIn.currentUser.displayName);
            setState(() {
              _isLoading = true;
            });

            bool response = await LoginWithSocialRepository.loginWithSocial(
                token: googleKey.accessToken,
                isFbSignUp: false,
                name: value.displayName,
                emailId: value.email);

            if (response) {
              Common.showErrorToastMsg("Sign Up Success");
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(),
                  ),
                  (route) => false);
            } else {
              setState(() {
                Common.showErrorToastMsg("Something Wrong Please Try Again");
                _isLoading = false;
              });
            }
          }).catchError((err) {
            print("***************************");
            print(err);
            print('inner error');
          });
        }
      });
    } catch (err) {
      print("***************************");
      print(err);
    }
  }

  Future<void> _handleSignOut() async {
    _googleSignIn.disconnect();
  }

  void googleSignInHandle() {
    _googleSignIn.onCurrentUserChanged.listen(
      (GoogleSignInAccount account) {
        setState(
          () {
            _currentUser = account;
          },
        );

        /*  if (_currentUser != null) {
        logInWithSocialMedia(_currentUser.displayName, _currentUser.email,
            _currentUser.id, _currentUser.photoUrl, false);
      }*/
      },
    );
    _googleSignIn.signInSilently();
  }

  Future<void> _getWinnerScore() async {
    winnerScore = await winnerScoreController.getWinnerScoreAPI();
    setState(() {
      _isLoading = false;
    });
  }
}
