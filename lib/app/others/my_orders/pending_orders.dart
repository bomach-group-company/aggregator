// ignore_for_file: unused_local_variable

import 'package:benji_aggregator/controller/operation.dart';
import 'package:benji_aggregator/src/providers/constants.dart';
import 'package:benji_aggregator/src/skeletons/dashboard_orders_list_skeleton.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../../model/order_list_model.dart';
import '../../../src/common_widgets/my_appbar.dart';
import '../../../theme/colors.dart';
import 'pending_order_details.dart';

class PendingOrders extends StatefulWidget {
  final List<OrderItem> orderList;
  const PendingOrders({super.key, required this.orderList});

  @override
  State<PendingOrders> createState() => _PendingOrdersState();
}

class _PendingOrdersState extends State<PendingOrders> {
  //===================== Initial State ==========================\\
  @override
  void initState() {
    super.initState();

    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  //=================================== CONTROLLERS ====================================\\
  final ScrollController _scrollController = ScrollController();

//========================================================= ALL VARIABLES =======================================================\\
  late bool _loadingScreen;
  int _incrementOrderID = 2 + 2;
  late int _orderID;
  String _orderItem = "Jollof Rice and Chicken";
  int _itemQuantity = 2;
  double price = 2500;
  double _itemPrice = 2500;
  String _orderImage = "chizzy's-food";

  String _customerImage = "customer/mercy_luke.png";
  String _customerName = "Mercy Luke";
  String _customerPhoneNumber = "09037453342";
  String _customerAddress = "21 Odogwu Street, New Haven";

//========================================================= FUNCTIONS =======================================================\\

  double calculateSubtotal() {
    return _itemPrice * _itemQuantity;
  }

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(milliseconds: 1000));
    setState(() {
      _loadingScreen = false;
    });
  }
//========================================================================================\\

  void _seeMorePendingOrders() {}

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String formattedDateAndTime = formatDateAndTime(now);
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    double subtotalPrice = calculateSubtotal();

    //===================== Navigate to Order Details Page ================================\\

//====================================================================================\\

    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      borderWidth: 5.0,
      backgroundColor: kPrimaryColor,
      height: 150,
      animSpeedFactor: 2,
      showChildOpacityTransition: false,
      child: Scaffold(
        appBar: MyAppBar(
          title: "Pending Orders",
          elevation: 10.0,
          actions: const [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: FutureBuilder(
            future: null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                const OrdersListSkeleton();
              }
              if (snapshot.connectionState == ConnectionState.none) {
                const Center(
                  child: Text("Please connect to the internet"),
                );
              }
              // if (snapshot.connectionState == snapshot.requireData) {
              //   SpinKitDoubleBounce(color: kAccentColor);
              // }
              if (snapshot.connectionState == snapshot.error) {
                const Center(
                  child: Text("Error, Please try again later"),
                );
              }
              return _loadingScreen
                  ? const Padding(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: OrdersListSkeleton(),
                    )
                  : Scrollbar(
                      controller: _scrollController,
                      radius: const Radius.circular(10),
                      scrollbarOrientation: ScrollbarOrientation.right,
                      child: ListView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.all(kDefaultPadding),
                        children: [
                          Column(
                            children:
                                List.generate(widget.orderList.length, (index) {
                              OrderItem order = widget.orderList[index];
                              return PendingOrderView(
                                order: order,
                              );
                            }),
                          ),
                          kSizedBox,
                          TextButton(
                            onPressed: _seeMorePendingOrders,
                            child: Text(
                              "See more",
                              style: TextStyle(color: kAccentColor),
                            ),
                          ),
                        ],
                      ),
                    );
            },
          ),
        ),
      ),
    );
  }
}

class PendingOrderView extends StatelessWidget {
  OrderItem order;
  PendingOrderView({super.key, required this.order});

  void toOrderDetailsPage() => Get.to(
        () => PendingOrderDetails(
          formatted12HrTime: "",
          orderID: 0,
          orderImage: "_orderImage",
          orderItem: "_orderItem",
          itemQuantity: 8,
          subtotalPrice: 0.0,
          customerImage: "_customerImage",
          customerPhoneNumber: "_customerPhoneNumber",
          customerName: "_customerName",
          customerAddress: "_customerAddress",
          order: order,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Pending order details",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.rightToLeft,
      );

  @override
  Widget build(BuildContext context) {
    int qty = 0;
    if (order.orderitems != null) {
      if (order.orderitems!.isNotEmpty)
        order.orderitems!.forEach((element) {
          qty += int.tryParse(element.quantity!.toString())!;
        });
    }
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;
    return InkWell(
      onTap: toOrderDetailsPage,
      borderRadius: BorderRadius.circular(kDefaultPadding),
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: kDefaultPadding / 2,
        ),
        padding: const EdgeInsets.only(
          top: kDefaultPadding / 2,
          left: kDefaultPadding / 2,
          right: kDefaultPadding / 2,
        ),
        width: mediaWidth / 1.1,
        height: 150,
        decoration: ShapeDecoration(
          color: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(kDefaultPadding),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 24,
              offset: Offset(0, 4),
              spreadRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: kPageSkeletonColor,
                    borderRadius: BorderRadius.circular(16),
                    // image: DecorationImage(
                    //   image: AssetImage(
                    //     "assets/images/products/$_orderImage.png",
                    //   ),
                    // ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                        order.client == null ? "" : order.client!.image ?? "",
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CupertinoActivityIndicator(
                      color: kRedColor,
                    )),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: kRedColor,
                    ),
                  ),
                ),
                kHalfSizedBox,
                Container(
                  width: 60,
                  child: Text(
                    order.id == null ? "#" : "#${order.code.toString()}",
                    style: TextStyle(
                      color: kTextGreyColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
            kWidthSizedBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: mediaWidth / 1.55,
                  // color: kAccentColor,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        child: Text(
                          "Vendor",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              order.created == null
                                  ? ""
                                  : Operation.convertDate(order.created!),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                kHalfSizedBox,
                Container(
                  color: kTransparentColor,
                  width: 250,
                  child: Text(
                    "order",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                kHalfSizedBox,
                Container(
                  width: 200,
                  color: kTransparentColor,
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "x $qty",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        const TextSpan(text: "  "),
                        TextSpan(
                          text: order.totalPrice == null
                              ? ""
                              : "₦ ${convertToCurrency(order.totalPrice.toString())}",
                          style: const TextStyle(
                            fontSize: 15,
                            fontFamily: 'sen',
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                kHalfSizedBox,
                Container(
                  color: kLightGreyColor,
                  height: 1,
                  width: mediaWidth / 1.8,
                ),
                kHalfSizedBox,
                SizedBox(
                  width: mediaWidth / 1.8,
                  child: Text(
                    order.client == null
                        ? ""
                        : "${order.client!.lastName ?? ""} ${order.client!.firstName ?? ""}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(
                  width: mediaWidth / 1.8,
                  child: Text(
                    order.deliveryAddress == null
                        ? ""
                        : order.deliveryAddress!.streetAddress ?? "",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
