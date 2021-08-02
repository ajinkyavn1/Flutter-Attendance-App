
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:untitled1/constants/constants.dart';
import 'package:untitled1/services/auth.dart';

class LoginScreen extends StatefulWidget {
  static final id = 'loginScreen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  AuthProvider _auth;
  void _toggleLoading() {
    setState(() {
      _isLoading = !_isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: LoadingOverlay(
        progressIndicator: SpinKitDualRing(
          color: Colors.white,
        ),
        isLoading: _isLoading,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: screenHeight(context: context, divideBy: 1.5),
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context: context, divideBy: 10)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipOval(
                    child: Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    'DYP Alerts',
                    style: TextStyle(
                      fontSize: screenHeight(context: context, divideBy: 20),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.orange[400],
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(
                      screenHeight(context: context, divideBy: 2.5)),
                ),
              ),
            ),
            SizedBox(
              height: screenHeight(context: context, divideBy: 16),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: screenWidth(context: context, divideBy: 10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    child: RaisedButton(
                      color: Colors.white,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image(
                            image: AssetImage(
                              'assets/images/google_logo1.png',
                            ),
                            height: 40,
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            'Sign in with Google',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      onPressed: () async {
                        _toggleLoading();
                        String uid = await _auth.signinWithGoogle();
                        print("Google User Logged in: $uid");
                        // _toggleLoading();
                      },
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
