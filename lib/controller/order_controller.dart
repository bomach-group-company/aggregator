import 'dart:convert';

import 'package:benji_aggregator/controller/error_controller.dart';
import 'package:benji_aggregator/controller/user_controller.dart';
import 'package:benji_aggregator/model/vendor_list_model.dart';
import 'package:benji_aggregator/services/api_url.dart';
import 'package:benji_aggregator/services/pref.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:http/http.dart' as http;
import 'dart:developer';
import '../model/order_list_model.dart';

class OrderController extends GetxController {
  static OrderController get instance {
    return Get.find<OrderController>();
  }

  bool? isFirst;
  OrderController({this.isFirst});
  var isLoad = false.obs;
  var orderList = <OrderItem>[].obs;

  @override
  void onInit() {
    runTask();
    // TODO: implement onInit
    super.onInit();
  }

  Future runTask([String? end]) async {
    isLoad.value = true;
    late String token;
    String id = UserController.instance.user.value.id.toString();
    update();
    var url = Api.baseUrl + Api.orderList + "$id/?start=1&end=${end ?? 100}";
    await KeyStore.getToken().then((element) {
      token = element!;
    });
    consoleLog(token);
    try {
      http.Response? response = await RequestData.getApi(url, token);
      var responseData =
          await ApiProcessorController.errorState(response, isFirst ?? true);
      if (responseData == null) {
        return;
      }

      try {
        var save = OrderListModel.fromJson(jsonDecode(responseData));
        orderList.value = save.items!;
        log(responseData);
      } catch (e) {
        consoleLog(e.toString());
      }

      update();
    } catch (e) {}
    isLoad.value = false;
    update();
  }
}
