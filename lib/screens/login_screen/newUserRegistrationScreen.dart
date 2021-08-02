import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:io';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:untitled1/commonWidgets/background.dart';
import 'package:untitled1/commonWidgets/input.dart';
import 'package:untitled1/model/userModel.dart';
import 'package:untitled1/screens/home_screen/DashBord.dart';
import 'package:untitled1/services/auth.dart';
import 'package:untitled1/services/database.dart';

class NewUserRegScreen extends StatefulWidget {
  final bool showPopUp;
  NewUserRegScreen({this.showPopUp});
  @override
  _NewUserRegScreenState createState() => _NewUserRegScreenState();
}

class _NewUserRegScreenState extends State<NewUserRegScreen> {
  Widget formSpace = SizedBox(height: 10);
  bool isLoading = false;
  var txtController = TextEditingController();
  UserModel user;

  final AuthProvider _authProvider = AuthProvider();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _email;

  String _status;


  Future<UserModel> createUser() async {
    String userID = await _authProvider.getCurrentUserID();
    user = UserModel(
     
      email: _email,
      status: _status,
     
      uid: userID,
    );
    return user;
  }

  void showSnackBar() {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 2),
        content: Text(
          'Continue where you left off',
        ),
      ),
    );
  }
  
  //for getting initial email value
  void getEmail() {
    checkEmail().then((value) => txtController.text = value);
  }

  Future<String> checkEmail() async {
    FirebaseUser user = await AuthProvider().getCurrentUser();
    return user.email;
  }


  Future<bool> _onBackPressed() async {
    return false;
    //returning false will prevent backpress operation
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getEmail();
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.showPopUp != null && widget.showPopUp) {
    //   showSnackBar();
    // }
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Ajinkya'),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: LoadingOverlay(
          isLoading: isLoading,
          child: Stack(
            children: [
              BackgroundContainer(),
              SingleChildScrollView(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(25),
                    child: Form(
                      key: _formKey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_forward_ios),
          onPressed: () async {
            if (!_formKey.currentState.validate()) {
              return;
            }
            _formKey.currentState.save();
            setState(() {
              isLoading = true;
            });
            user = await createUser(); //locally create user
            final DatabaseService _dbService = DatabaseService(uid: user.uid);

            await _dbService.updateUserDataInDatabase(user); //put user data
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Dash(),
              ),
            );
          },
        ),
      ),
    );
  }
}
