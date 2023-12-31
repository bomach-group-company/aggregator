// ignorFontWeight_for_file: unused_local_variable,

// ignore_for_file: unused_local_variable

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

import '../../controller/rider_controller.dart';
import '../../model/rider_list_model.dart';
import '../../src/providers/constants.dart';
import '../../src/providers/custom_show_search.dart';
import '../../src/skeletons/all_riders_page_skeleton.dart';
import '../../src/skeletons/riders_list_skeleton.dart';
import '../../theme/colors.dart';
import 'riders_detail.dart';

class Riders extends StatefulWidget {
  final VoidCallback showNavigation;
  final VoidCallback hideNavigation;

  final Color appBarBackgroundColor;
  final Color appTitleColor;
  final Color appBarSearchIconColor;
  const Riders({
    super.key,
    required this.appBarBackgroundColor,
    required this.appTitleColor,
    required this.appBarSearchIconColor,
    required this.showNavigation,
    required this.hideNavigation,
  });

  @override
  State<Riders> createState() => _RidersState();
}

class _RidersState extends State<Riders> with SingleTickerProviderStateMixin {
  //===================== Initial State ==========================\\

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (RiderController.instance.riderList.isEmpty) {
        RiderController.instance.runTask();
      }
    });

    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _scrollController.addListener(_scrollListener);
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        widget.showNavigation();
      } else {
        widget.hideNavigation();
      }
    });
    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 1000),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  //================================= ALL VARIABLES ==========================================\\
  late bool _loadingScreen;
  bool _riderStatus = true;
  bool _loadingRiderStatus = false;
  bool _isScrollToTopBtnVisible = false;

//Online Riders
  final String _onlineRidersImage = "rider/jerry_emmanuel.png";
  final String _onlineRidersName = "Jerry Emmanuel";
  final String _onlineRidersLocation = "Achara Layout";
  final int _onlineRidersNoOfTrips = 238;
  final String _onlineRidersPhoneNumber = "08032300044";
  final int _numberOfOnlineRiders = 10;

//Offline Riders
  final String _offlineRidersName = "Martins Okafor";
  final String _offlineRidersImage = "rider/martins_okafor.png";
  final String _offlineRidersPhoneNumber = "08032300253";
  final int _lastSeenCount = 20;
  final String _lastSeenMessage = "minutes ago";
  final int _offlineRiderNoOfTrips = 221;
  final int _numberOfOfflineRiders = 10;

  //============================================== CONTROLLERS =================================================\\
  final ScrollController _scrollController = ScrollController();
  late AnimationController _animationController;

  //================================= FUNCTIONS ==========================================\\

  //===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    RiderController.instance.addPage(5);
    //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
    RiderController.instance.runTask();
    // });

    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _loadingScreen = false;
    });
  }

  //================= Paginate ================ //
  Future paginateFeed(BuildContext context) async {
    print("Pageinating");
    RiderListModel provide = RiderController.instance.allRider.value;

    ///  provide.indexChange(index);

    // int checkNum = provide.feedPosts.length - 3; // lenght of posts
    int pageNum =
        RiderController.instance.pageVal.value; // api current  page num
    int maxPages = provide.total!; // api last page num
    //  emitter("there");
    //  emitter(maxPages.toString());
    // emitter(pageNum.toString());

    if (RiderController.instance.riderList.length -
            RiderController.instance.pageVal.value <
        5) {
      RiderController.instance.addPage(pageNum + 5);
    } else {}

    //  if (pageNum >= maxPages) {
    //  print("cannot paginate");
    // return;
    // } else {
    //  emitter("PAGINTATING");
    if (RiderController.instance.isPaging.value) {
      return;
    }
    await RiderController.instance
        .runTask(true, 0, RiderController.instance.pageVal.value)
        .whenComplete(() => print("paginated"));
    // }
  }

//============================= Scroll to Top ======================================//
  void _scrollToTop() {
    _animationController.reverse();
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollListener() {
    //========= Show action button ========//
    if (_scrollController.position.pixels >= 200) {
      _animationController.forward();
      setState(() => _isScrollToTopBtnVisible = true);
    }
    //========= Hide action button ========//
    else if (_scrollController.position.pixels < 200) {
      _animationController.reverse();
      setState(() => _isScrollToTopBtnVisible = true);
    }
  }

  //===================== Handle riderStatus ==========================\\
  void clickOnlineRiders() async {
    setState(() {
      _loadingRiderStatus = true;
      _riderStatus = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _loadingRiderStatus = false;
    });
  }

  void clickOfflineRiders() async {
    setState(() {
      _loadingRiderStatus = true;
      _riderStatus = false;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    setState(() {
      _loadingRiderStatus = false;
    });
  }

//=============================== See more ========================================\\
  void _seeMoreOnlineRiders() {
    paginateFeed(context);
  }

  void _seeMoreOfflineRiders() {}

  //===================== Navigation ==========================\\

  void toRidersDetailPage(RiderItem rider) => Get.to(
        () => RidersDetail(
          ridersImage: _riderStatus ? _onlineRidersImage : _offlineRidersImage,
          ridersName: _riderStatus ? _onlineRidersName : _offlineRidersName,
          ridersPhoneNumber: _riderStatus
              ? _onlineRidersPhoneNumber
              : _offlineRidersPhoneNumber,
          noOfTrips:
              _riderStatus ? _onlineRidersNoOfTrips : _offlineRiderNoOfTrips,
          onlineIndicator: _riderStatus
              ? Container(
                  height: 20,
                  width: 20,
                  decoration: const ShapeDecoration(
                    color: kSuccessColor,
                    shape: OvalBorder(),
                  ),
                )
              : Container(),
          rider: rider,
        ),
        duration: const Duration(milliseconds: 300),
        fullscreenDialog: true,
        curve: Curves.easeIn,
        routeName: "Rider Details",
        preventDuplicates: true,
        popGesture: true,
        transition: Transition.downToUp,
      );

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;
    double mediaHeight = MediaQuery.of(context).size.height;

    void showSearchField() => showSearch(
        context: context,
        delegate: CustomSearchDelegate(
            searchTerms: RiderController.instance.riderList,
            pageName: "rider"));

    return LiquidPullToRefresh(
      onRefresh: _handleRefresh,
      color: kAccentColor,
      borderWidth: 5.0,
      backgroundColor: kPrimaryColor,
      height: 150,
      animSpeedFactor: 2,
      showChildOpacityTransition: false,
      child: Scaffold(
        appBar: AppBar(
          leadingWidth: 40,
          backgroundColor: widget.appBarBackgroundColor,
          title: Padding(
            padding: const EdgeInsets.only(left: kDefaultPadding),
            child: Text(
              "All Riders",
              style: TextStyle(
                fontSize: 20,
                color: widget.appTitleColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          actions: [
            IconButton(
              onPressed: showSearchField,
              tooltip: "Search",
              icon: Icon(
                Icons.search_rounded,
                color: widget.appBarSearchIconColor,
                size: 24,
              ),
            ),
          ],
          elevation: 0.0,
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            if (_isScrollToTopBtnVisible) ...[
              ScaleTransition(
                scale: CurvedAnimation(
                  parent: _animationController,
                  curve: Curves.easeInOut,
                ),
                child: FloatingActionButton(
                  onPressed: _scrollToTop,
                  mini: true,
                  backgroundColor: kAccentColor,
                  enableFeedback: true,
                  mouseCursor: SystemMouseCursors.click,
                  tooltip: "Scroll to top",
                  hoverColor: kAccentColor,
                  hoverElevation: 50.0,
                  child: const Icon(Icons.keyboard_arrow_up),
                ),
              ),
            ]
          ],
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: GetBuilder<RiderController>(
              init: RiderController(),
              builder: (controller) {
                return controller.isLoad.value
                    ? const AllRidersPageSkeleton()
                    : Scrollbar(
                        controller: _scrollController,
                        radius: const Radius.circular(10),
                        scrollbarOrientation: ScrollbarOrientation.right,
                        child: ListView(
                          controller: _scrollController,
                          scrollDirection: Axis.vertical,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(
                            bottom: kDefaultPadding,
                            right: kDefaultPadding,
                            left: kDefaultPadding,
                          ),
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            SizedBox(
                              width: mediaWidth,
                              child: Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: clickOnlineRiders,
                                    onLongPress: null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _riderStatus
                                          ? kAccentColor
                                          : kDefaultCategoryBackgroundColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      "Online Riders",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        color: _riderStatus
                                            ? kTextWhiteColor
                                            : kTextGreyColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  kWidthSizedBox,
                                  ElevatedButton(
                                    onPressed: clickOfflineRiders,
                                    onLongPress: null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _riderStatus
                                          ? kDefaultCategoryBackgroundColor
                                          : kAccentColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                    child: Text(
                                      "Offline Riders",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                        color: _riderStatus
                                            ? kTextGreyColor
                                            : kTextWhiteColor,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            kSizedBox,
                            controller.isLoad.value
                                ? const RidersListSkeleton()
                                : StreamBuilder(
                                    stream: null,
                                    builder: (context, snapshot) {
                                      List<RiderItem> ride = controller
                                          .riderList
                                          .where((p0) => p0.username == null
                                              ? p0.firstName!.isNotEmpty
                                              : p0.username!.isNotEmpty)
                                          .toList();
                                      return ListView.builder(
                                        itemCount: ride.length,
                                        addAutomaticKeepAlives: true,
                                        physics: const BouncingScrollPhysics(),
                                        shrinkWrap: true,
                                        itemBuilder: (context, index) =>
                                            InkWell(
                                          onTap: () => toRidersDetailPage(
                                              controller.riderList[index]),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          child: Container(
                                            width: max(mediaWidth, 374),
                                            margin: const EdgeInsets.only(
                                                bottom: kDefaultPadding / 2),
                                            padding: const EdgeInsets.all(
                                                kDefaultPadding / 2),
                                            decoration: ShapeDecoration(
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              shadows: const [
                                                BoxShadow(
                                                  color: Color(0x0F000000),
                                                  blurRadius: 24,
                                                  offset: Offset(0, 4),
                                                  spreadRadius: 0,
                                                ),
                                              ],
                                            ),
                                            child: Row(
                                              children: [
                                                Stack(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 30,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      //   backgroundImage:
                                                      //     AssetImage(
                                                      //   "assets/images/$_onlineRidersImage",
                                                      // ),
                                                      child: ClipOval(
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: ride[index]
                                                                  .image ??
                                                              "",
                                                          fit: BoxFit.cover,
                                                          progressIndicatorBuilder:
                                                              (context, url,
                                                                      downloadProgress) =>
                                                                  Center(
                                                                      child:
                                                                          CupertinoActivityIndicator(
                                                            color: kRedColor,
                                                          )),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              const Icon(
                                                            Icons.error,
                                                            color: kRedColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      right: 10,
                                                      bottom: 0,
                                                      child: Container(
                                                        height: 10,
                                                        width: 10,
                                                        decoration:
                                                            const ShapeDecoration(
                                                          color: kSuccessColor,
                                                          shape: OvalBorder(),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal:
                                                          kDefaultPadding),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      SizedBox(
                                                        width: mediaWidth - 200,
                                                        child: Text(
                                                          ride[index]
                                                                  .username ??
                                                              "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 1,
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                          ),
                                                        ),
                                                      ),
                                                      kHalfSizedBox,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.location_on,
                                                            color: kAccentColor,
                                                            size: 18,
                                                          ),
                                                          kHalfWidthSizedBox,
                                                          SizedBox(
                                                            width: mediaWidth -
                                                                200,
                                                            child: Text(
                                                              controller
                                                                      .riderList[
                                                                          index]
                                                                      .address ??
                                                                  "",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              maxLines: 1,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    kTextGreyColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      kHalfSizedBox,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.route,
                                                            color: kAccentColor,
                                                            size: 18,
                                                          ),
                                                          kHalfWidthSizedBox,
                                                          SizedBox(
                                                            width: mediaWidth -
                                                                200,
                                                            child: Text(
                                                              "0 Trips Completed",
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                color:
                                                                    kTextGreyColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                            kSizedBox,
                            _riderStatus
                                ? controller.isPaging.value
                                    ? SizedBox(
                                        height: 30,
                                        width: 40,
                                        child: SpinKitFadingFour(
                                            color: kAccentColor),
                                      )
                                    : TextButton(
                                        onPressed: _seeMoreOnlineRiders,
                                        child: Text(
                                          "See more",
                                          style: TextStyle(color: kAccentColor),
                                        ),
                                      )
                                : controller.isPaging.value
                                    ? SizedBox(
                                        height: 30,
                                        width: 40,
                                        child: SpinKitFadingFour(
                                            color: kAccentColor),
                                      )
                                    : TextButton(
                                        onPressed: _seeMoreOfflineRiders,
                                        child: Text(
                                          "See more",
                                          style: TextStyle(color: kAccentColor),
                                        ),
                                      ),
                          ],
                        ),
                      );
              }),
        ),
      ),
    );
  }
}
