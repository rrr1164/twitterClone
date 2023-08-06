import 'package:flutter/material.dart';

class Utilities{
  static showErrorSnackBar(BuildContext context,String message ){
    SnackBar snackBar = SnackBar(
      backgroundColor: Colors.red,
      content: Text(
        message,
        style: const TextStyle(color: Colors.black, letterSpacing: 0.5),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

  }
  static showSnackBar(BuildContext context,String message ){
    SnackBar snackBar = SnackBar(
      content: Text(
        message,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
  static const baseApiUrl = "https://yousef-shora.in/twitter/";

}