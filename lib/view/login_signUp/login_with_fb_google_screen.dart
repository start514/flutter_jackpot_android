import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutterjackpot/utils/common/layout_dot_builder.dart';
import 'package:flutterjackpot/models/winner_score_model.dart';
import 'package:flutterjackpot/repository/signUpWithSocialMedia.dart';
import 'package:flutterjackpot/utils/colors_utils.dart';
import 'package:flutterjackpot/utils/common/common_sizebox_addmob.dart';
import 'package:flutterjackpot/utils/common/common_toast.dart';
import 'package:flutterjackpot/view/bottom_widget/winner_score_controller.dart';
import 'package:flutterjackpot/view/home/home_screen.dart';
import 'package:flutterjackpot/view/login_signUp/login_screen.dart';
import 'package:flutterjackpot/view/login_signUp/signup_screen.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:flutterjackpot/utils/image_utils.dart';

class LoginWithFBAndGoogleScreen extends StatefulWidget {
  @override
  _LoginWithFBAndGoogleScreenState createState() =>
      _LoginWithFBAndGoogleScreenState();
}

class _LoginWithFBAndGoogleScreenState
    extends State<LoginWithFBAndGoogleScreen> {
  static final platform = const MethodChannel("com.equitysoft.flutterjackpot");

  WinnerScoreController winnerScoreController = new WinnerScoreController();

  WinnerScore? winnerScore = new WinnerScore();

  bool _isLoading = true;

  bool isLoggedIn = false;
  double unitHeightValue = 1;
  double unitWidthValue = 1;

  String? _contactText;
  // GoogleSignInAccount? _currentUser;
  // GoogleSignIn _googleSignIn = new GoogleSignIn(
  //   scopes: [
  //     'email',
  //   ],
  // );

  @override
  void initState() {
    super.initState();
    _getWinnerScore();
  }

  @override
  Widget build(BuildContext context) {
    unitHeightValue = MediaQuery.of(context).size.height * 0.001;
    unitWidthValue = MediaQuery.of(context).size.width * 0.0021;
    print("\nThis is unitHeightValue: $unitHeightValue\n");
    print("\nThis is unitWidthValue: $unitWidthValue\n");
    return Stack(
      children: [
        bgImage(context),
        Scaffold(
          backgroundColor: transparentColor,
          body: _isLoading
              ? Center(
                  child: CupertinoActivityIndicator(
                    radius: 15.0,
                  ),
                )
              : _loginBodyWidget(winnerScore!),
        )
      ]
    );
  }

  Widget _loginBodyWidget(WinnerScore winnerScore) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
                    vertical: unitHeightValue * 10.0, horizontal: unitWidthValue * 10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              sizedBoxAddMob(unitHeightValue * 42.0),
              SizedBox(
                height: unitHeightValue * 10.0,
              ),
              Text(
                "Trivia \$tax",
                style: TextStyle(
                    color: whiteColor,
                    fontWeight: FontWeight.bold,
                    fontSize: unitHeightValue * 60.0,
                    fontFamily: "Arial",
                    fontStyle: FontStyle.italic),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: unitHeightValue * 20.0, horizontal: unitWidthValue * 30.0),
                child: layoutBuilderDot(greenColor, size: unitHeightValue * 6),
              ),
              Row(
              	mainAxisAlignment: MainAxisAlignment.center,
              	children: [
      					Text(
		              "Trivia for ",
		              style: TextStyle(
		                color: whiteColor,
		                fontSize: unitHeightValue * 24
		              ),
		            ),
		            Text(
		              "Cash",
		              style: TextStyle(
		                color: greenColor,
		                fontSize: unitHeightValue * 24
		              ),
		            ),
		            Text(
		              ", Not fake coins...",
		              style: TextStyle(
		                color: whiteColor,
		                fontSize: unitHeightValue * 24
		              ),
		            ),
              	]
              ),
              SizedBox(
                height: unitHeightValue * 25.0,
              ),
              Text(
	              "~100% Free to play~",
	              style: TextStyle(
	              	fontWeight: FontWeight.bold,
	                color: whiteColor,
	                fontSize: unitHeightValue * 24
	              ),
	            ),
              SizedBox(
                height: unitHeightValue * 10.0,
              ),
              Text(
	              "~NO CC needed~",
	              style: TextStyle(
	              	fontWeight: FontWeight.bold,
	                color: whiteColor,
	                fontSize: unitHeightValue * 24
	              ),
	            ),
              SizedBox(
                height: unitHeightValue * 10.0,
              ),
              Text(
	              "~Winners paid via PayPal~",
	              style: TextStyle(
	              	fontWeight: FontWeight.bold,
	                color: whiteColor,
	                fontSize: unitHeightValue * 24
	              ),
	            ),
              SizedBox(
                height: unitHeightValue * 20.0,
              ),
              SignUpScreen(),  
              SizedBox(
                height: unitHeightValue * 10.0,
              ),
              FlatButton(
              	child: Row(
              		mainAxisAlignment: MainAxisAlignment.center,
              		children: [
              			Text(
		                  "Already have an account? ",
		                  style: TextStyle(
		                    fontWeight: FontWeight.bold,
		                    color: whiteColor,
		                    fontSize: unitHeightValue * 18.0,
		                  ),
		                ),
		                Text(
		                  "Sign In",
		                  style: TextStyle(
		                    fontWeight: FontWeight.bold,
		                    color: whiteColor,
		                    fontSize: unitHeightValue * 18.0,
		                    decoration: TextDecoration.underline,
		                  ),
		                ),
              		]
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

  // void initiateFacebookLogin() async {
  //   var facebookLogin = FacebookLogin();
  //   var facebookLoginResult = await facebookLogin.logIn(['email']);
  //   switch (facebookLoginResult.status) {
  //     case FacebookLoginStatus.error:
  //       print("Error");
  //       onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //       print("CancelledByUser");
  //       onLoginStatusChanged(false);
  //       break;
  //     case FacebookLoginStatus.loggedIn:
  //       print("LoggedIn");
  //       var graphResponse = await http.get(Uri.https(
  //           'https://graph.facebook.com',
  //           'v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${facebookLoginResult.accessToken.token}'));

  //       var profile = json.decode(graphResponse.body);

  //       setState(() {
  //         _isLoading = true;
  //       });

  //       bool response = await LoginWithSocialRepository.loginWithSocial(
  //           token: facebookLoginResult.accessToken.token,
  //           isFbSignUp: true,
  //           name: profile['name'],
  //           emailId: profile['email']);

  //       if (response) {
  //         Common.showErrorToastMsg("Sign Up Success");
  //         Navigator.pushAndRemoveUntil(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => HomeScreen(),
  //             ),
  //             (route) => false);
  //       } else {
  //         setState(() {
  //           Common.showErrorToastMsg("Something Wrong Please Try Again");
  //           _isLoading = false;
  //         });
  //       }
  //       onLoginStatusChanged(true);
  //       break;
  //   }
  // }

  void onLoginStatusChanged(bool isLoggedIn) {
    setState(() {
      this.isLoggedIn = isLoggedIn;
    });
  }

  // Future<void> _handleSignIn() async {
  //   try {
  //     await _googleSignIn.signIn().then((value) {
  //       if (value!.displayName != null) {
  //         value.authentication.then((googleKey) async {
  //           print(googleKey.accessToken);
  //           print(googleKey.idToken);
  //           print(_googleSignIn.currentUser!.displayName);
  //           setState(() {
  //             _isLoading = true;
  //           });

  //           bool response = await LoginWithSocialRepository.loginWithSocial(
  //               token: googleKey.accessToken,
  //               isFbSignUp: false,
  //               name: value.displayName,
  //               emailId: value.email);

  //           if (response) {
  //             Common.showErrorToastMsg("Sign Up Success");
  //             Navigator.pushAndRemoveUntil(
  //                 context,
  //                 MaterialPageRoute(
  //                   builder: (context) => HomeScreen(),
  //                 ),
  //                 (route) => false);
  //           } else {
  //             setState(() {
  //               Common.showErrorToastMsg("Something Wrong Please Try Again");
  //               _isLoading = false;
  //             });
  //           }
  //         }).catchError((err) {
  //           print("***************************");
  //           print(err);
  //           print('inner error');
  //         });
  //       }
  //     });
  //   } catch (err) {
  //     print("***************************");
  //     print(err);
  //   }
  // }

  // Future<void> _handleSignOut() async {
  //   _googleSignIn.disconnect();
  // }

  // void googleSignInHandle() {
  //   _googleSignIn.onCurrentUserChanged.listen(
  //     (GoogleSignInAccount? account) {
  //       setState(
  //         () {
  //           _currentUser = account;
  //         },
  //       );

  //         if (_currentUser != null) {
  //       logInWithSocialMedia(_currentUser.displayName, _currentUser.email,
  //           _currentUser.id, _currentUser.photoUrl, false);
  //     }
  //     },
  //   );
  //   _googleSignIn.signInSilently();
  // }

  Future<void> _getWinnerScore() async {
    winnerScore = await winnerScoreController.getWinnerScoreAPI();
    setState(() {
      _isLoading = false;
    });
  }
}
