import 'package:benji_aggregator/src/common_widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import '../../controller/vendor_controller.dart';
import '../../model/vendor_list_model.dart';
import '../../model/vendor_rating_model.dart';
import '../../src/common_widgets/customer_review_card.dart';
import '../../src/common_widgets/star_row.dart';
import '../../src/providers/constants.dart';
import '../../theme/colors.dart';

class AboutVendor extends StatefulWidget {
  final String vendorName;
  final String vendorHeadLine;
  final String monToFriOpeningHours;
  final String monToFriClosingHours;
  final String satOpeningHours;
  final String satClosingHours;
  final String sunOpeningHours;
  final String sunClosingHours;
  final VendorListModel vendor;
  const AboutVendor({
    super.key,
    required this.vendorName,
    required this.vendorHeadLine,
    required this.monToFriOpeningHours,
    required this.monToFriClosingHours,
    required this.satOpeningHours,
    required this.satClosingHours,
    required this.sunOpeningHours,
    required this.sunClosingHours,
    required this.vendor,
  });

  @override
  State<AboutVendor> createState() => _AboutVendorState();
}

class _AboutVendorState extends State<AboutVendor> {
//============================================= INITIAL STATE AND DISPOSE  ===================================================\\
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      VendorController.instance.vendorRatingList(widget.vendor.id!);
    });

    _loadingScreen = true;
    Future.delayed(
      const Duration(milliseconds: 500),
      () => setState(
        () => _loadingScreen = false,
      ),
    );
  }

  //=================================== CONTROLLERS ====================================\\
  final ScrollController _scrollController = ScrollController();

//============================================= ALL VARIABLES  ===================================================\\
  late bool _loadingScreen;

//============================================= FUNCTIONS  ===================================================\\

//===================== Handle refresh ==========================\\

  Future<void> _handleRefresh() async {
    setState(() {
      _loadingScreen = true;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      _loadingScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double mediaWidth = MediaQuery.of(context).size.width;

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
          title: widget.vendor.shopName ?? "",
          elevation: 0,
          actions: [],
          backgroundColor: kPrimaryColor,
          toolbarHeight: kToolbarHeight,
        ),
        body: SafeArea(
          maintainBottomViewPadding: true,
          child: ObxValue((loadRatings) {
            return loadRatings.value
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: SpinKitDoubleBounce(color: kAccentColor),
                      ),
                    ],
                  )
                : Visibility(
                    visible:
                        loadRatings.value == false ? true : loadRatings.value,
                    child: ObxValue(
                        (rating) => Scrollbar(
                              controller: _scrollController,
                              radius: const Radius.circular(10),
                              scrollbarOrientation: ScrollbarOrientation.right,
                              child: ListView(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(kDefaultPadding),
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "About This Business",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      kSizedBox,
                                      Container(
                                        width: mediaWidth,
                                        padding: const EdgeInsets.all(
                                            kDefaultPadding),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFFEF8F8),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0.50,
                                              color: Color(0xFFFDEDED),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25),
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
                                        child: Text(
                                          widget.vendor.shopType!.description ?? "",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                      kSizedBox,
                                      const Text(
                                        "Opening Hours",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      kSizedBox,
                                      Container(
                                        width: mediaWidth,
                                        padding: const EdgeInsets.all(
                                            kDefaultPadding),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFFEF8F8),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0.50,
                                              color: Color(0xFFFDEDED),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Mon. - Fri.",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                kSizedBox,
                                                Text(
                                                  "Sat.",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                                kSizedBox,
                                                Text(
                                                  "Sun.",
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                                width: kDefaultPadding * 2),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: widget
                                                            .monToFriOpeningHours
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: " - ",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: widget
                                                            .monToFriClosingHours
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                kSizedBox,
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: widget
                                                            .satOpeningHours
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: " - ",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: widget
                                                            .satClosingHours
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                kSizedBox,
                                                Text.rich(
                                                  TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: widget
                                                            .sunOpeningHours
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: " - ",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: widget
                                                            .sunClosingHours
                                                            .toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                kSizedBox,
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      kSizedBox,
                                      Container(
                                        width: mediaWidth,
                                        padding: const EdgeInsets.all(
                                            kDefaultPadding),
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFFEF8F8),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                              width: 0.50,
                                              color: Color(0xFFFDEDED),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(25),
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
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Reviews View & Ratings",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: kDefaultPadding,
                                                horizontal:
                                                    kDefaultPadding * 0.5,
                                              ),
                                              child: StarRow(),
                                            ),
                                          ],
                                        ),
                                      ),
                                      kSizedBox,
                                      ListView.separated(
                                        physics: BouncingScrollPhysics(),
                                        separatorBuilder: (context, index) =>
                                            kSizedBox,
                                        shrinkWrap: true,
                                        itemCount: rating.value.items == null
                                            ? 0
                                            : rating.value.items!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          RatingItem data =
                                              rating.value.items![index];
                                          return CostumerReviewCard(
                                            mediaWidth: mediaWidth,
                                            rateData: data,
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                        VendorController.instance.vendorRating),
                  );
          }, VendorController.instance.isLoadRating),
        ),
      ),
    );
  }
}
