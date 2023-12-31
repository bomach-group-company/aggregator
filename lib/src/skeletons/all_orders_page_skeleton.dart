import 'package:benji_aggregator/src/skeletons/dashboard_orders_list_skeleton.dart';
import 'package:flutter/material.dart';

import '../providers/constants.dart';

class AllOrdersPageskeleton extends StatelessWidget {
  const AllOrdersPageskeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) => OrdersListSkeleton(),
          separatorBuilder: (context, index) =>
              SizedBox(height: kDefaultPadding / 2),
          itemCount: 10,
        )
      ],
    );
  }
}
