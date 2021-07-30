import 'package:flutter/material.dart';

class Errorwidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error,color: Colors.red,),
            SizedBox(height: 15,),
            Text("Something Went Wrong",style: TextStyle(
              color: Colors.red,
              fontSize: 18
            ),)
          ],
        ),
      ),
    );
  }
}
