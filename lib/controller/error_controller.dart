import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

void ConsoleLog(data) => log(data.toString());

class ApiProcessorController extends GetxController {
  static Future<dynamic> errorState(data,[bool? isUser]) async {
    try {
      if (data == null) {
        return;
      } else if (data.statusCode == 200) {
        return data.body;
      } else {
        if(isUser != true){
           errorSnack("Something went wrong");

        }
       
        return;
      }
    } on SocketException {
      errorSnack("Check your internet and try again");
      return;
    } catch (e) {
      errorSnack(e);
      return;
    }
  }

  static void errorSnack(msg) {
    Get.showSnackbar(GetSnackBar(
      title: "ERROR",
      message: "$msg",
      backgroundColor: Colors.red,
      duration: Duration(seconds: 5),
    ));
  }

    static void successSnack(msg) {
    Get.showSnackbar(GetSnackBar(
      title: "Successful",
      message: "$msg",
      backgroundColor: Colors.green,
      duration: Duration(seconds: 5),
    ));
  }
}
