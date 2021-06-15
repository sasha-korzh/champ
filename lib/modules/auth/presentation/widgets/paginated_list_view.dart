import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/no_glow_scroll_behavior.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PaginatedListView extends StatelessWidget {
  final refreshController;
  final Function onRefresh;
  final Function onLoadNewPage;
  final itemBuilder;
  final itemsCount;

  const PaginatedListView(
      {Key key,
      @required this.refreshController,
      @required this.onRefresh,
      @required this.onLoadNewPage,
      @required this.itemBuilder,
      @required this.itemsCount
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: ScrollConfiguration(
              behavior: NoGlowScrollBehavior(),
              child: SmartRefresher(
                controller: refreshController,
                onRefresh: onRefresh,
                onLoading: onLoadNewPage,
                enablePullDown: true,
                enablePullUp: true,
                footer: getCustomFooter(),
                header: getCustomHeader(),
                child: ListView.builder(
                  itemBuilder: itemBuilder,
                  itemCount: itemsCount,
                ),
              ),
            ),
      ),
    );
  }

  Widget getCustomHeader() {
    return CustomHeader(
      refreshStyle: RefreshStyle.Follow,
      builder: (BuildContext context, RefreshStatus status) {
        Widget text;
        switch (status) {
          case RefreshStatus.canRefresh:
          case RefreshStatus.idle:
            text = Text('Update', style: TextStyles.weight400px14());
            break;
          case RefreshStatus.refreshing:
            text = Text('Loading', style: TextStyles.weight400px14());
            break;
          case RefreshStatus.completed:
            text = Text('Completed', style: TextStyles.weight400px14());
            break;
          default:
            text = Text('Error', style: TextStyles.weight400px14());
        }

        return Container(
          height: 55.0,
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CupertinoActivityIndicator(), SizedBox(width: 10), text],
          )),
        );
      },
    );
  }

  Widget getCustomFooter() {
    return CustomFooter(
      loadStyle: LoadStyle.ShowWhenLoading,
      builder: (BuildContext context, LoadStatus status) {
        Widget text;
        switch (status) {
          case LoadStatus.canLoading:
          case LoadStatus.idle:
            text = Text('Loading', style: TextStyles.weight400px14());
            break;
          case LoadStatus.noMore:
            text = Text('End of Page.(', style: TextStyles.weight400px14());
            break;
          default:
            text = Text('Error', style: TextStyles.weight400px14());
        }

        return Container(
          height: 55.0,
          child: Center(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [CupertinoActivityIndicator(), SizedBox(width: 10), text],
          )),
        );
      },
    );
  }
}
