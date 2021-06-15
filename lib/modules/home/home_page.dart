
import 'package:champ/core/util/appColors.dart';
import 'package:champ/core/util/pages/app_pages.dart';
import 'package:champ/core/util/textStyles.dart';
import 'package:champ/modules/auth/presentation/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'home_controller.dart';
import 'widgets/main_app_bar.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  HomeController homeController = Get.find();
  AuthController authController = Get.find();
  ScreenUtil su = ScreenUtil();

  final Duration duration = const Duration(milliseconds: 300);
  Animation<Offset> _slideMenuAnimation;
  Animation<Offset> _slidePageAnimation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: duration);
    final curvedAnimation = CurvedAnimation(
      curve: Curves.ease,
      parent: _controller,
    );
    _slideMenuAnimation = Tween<Offset>(begin: Offset(-1, 0), end: Offset(0, 0)).animate(curvedAnimation);
    _slidePageAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0.6, 0)).animate(curvedAnimation);
    homeController.isCollapsed.listen((isCollapsed) {
      if (isCollapsed) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var title, rightButton;

      if (homeController.menuSelectedItem.value == MenuItem.feed) {
        title = 'Моя стрічка';
        rightButton = IconButton(
            icon: Icon(Icons.add, color: AppColors.black),
            onPressed: () {
              if (authController.currentUser.value != null) {
                Get.toNamed(Routes.postEditor);
              } else {
                authController.showSignInSnackBar();
              }
            },
          );
      } else if (homeController.menuSelectedItem.value == MenuItem.training) {
        title = 'Тренування';
        rightButton = IconButton(
            icon: Icon(Icons.add, color: AppColors.black),
            onPressed: () {
              if (authController.currentUser.value != null) {
                Get.toNamed(Routes.createTraining);
              } else {
                authController.showSignInSnackBar();
              }
            },
          );
      } else if (homeController.menuSelectedItem.value == MenuItem.topics) {
        title = 'Топіки';
        rightButton = Container(width: su.setWidth(20),);
      } else  {
        title = '';
        rightButton = Container(width: su.setWidth(20),);
      }
      
      return  SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.white,
        extendBodyBehindAppBar: true,
        appBar: SlidableAppBar(
          title: title,
          position: _slidePageAnimation,
          leftButton: Obx(() => IconButton(
            icon: homeController.isCollapsed.value ? 
                Icon(Icons.close, color: AppColors.black)
              :
                Icon(Icons.menu, color: AppColors.black),
            onPressed: () {
              homeController.isCollapsed.value = !homeController.isCollapsed.value;
            },
          )),
          rightButton: rightButton,
        ),
        body: Stack(
          children: <Widget>[
            menu(context),
            Padding(
              padding: EdgeInsets.only(top: su.setHeight(110)),
              child: slideAnimatedPage(context),
            ),
          ],
        ),
      ),
    );
    });
  }

  Widget menu(BuildContext context) {
    return SlideTransition(
      position: _slideMenuAnimation,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Obx(() {
              if (authController.currentUser.value != null) {
                return getUserAvatarAndName();
              } else {
                return getSignInButton();
              }
            }),
            MenuButton(
              MenuItem.create,
              bottomMargin: su.setHeight(40)
            ),
            MenuButton(
              MenuItem.bookmarks,
              bottomMargin: su.setHeight(7)
            ),
            MenuButton(
              MenuItem.topics,
              bottomMargin: su.setHeight(7)
            ),
            MenuButton(
              MenuItem.feed,
              bottomMargin: su.setHeight(7)
            ),
            MenuButton(
              MenuItem.training,
              bottomMargin: su.setHeight(350)
            ),
            MenuButton(
              MenuItem.settings,
              bottomMargin: su.setHeight(20)
            ),
          ],
        ),
      ),
    );
  }  

  Widget slideAnimatedPage(BuildContext context) {
    return Obx(
      () => SlideTransition(
        position: _slidePageAnimation,
        child: homeController.currentPage.value,
      )
    );
  }

  Widget getUserAvatarAndName() {
    final url = authController.currentUser.value.avatarImageUrl;
    var name;
    if (authController.currentUser.value.fullname.length < 16) {
      name = authController.currentUser.value.fullname;
    } else {
      name = authController.currentUser.value.fullname.substring(0, 16)  + '...';
    }
    return GestureDetector(
      onTap: () {
        homeController.goTo(MenuItem.userProfile);
      },
      child: Container(
        margin: EdgeInsets.only(
          top: su.setHeight(46),
          bottom: su.setHeight(43),
          left: su.setWidth(33)
        ),
        child: Row(
          children: [
            ClipOval(
              child: Container(
                height: su.setHeight(24),
                width: su.setHeight(24),
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      alignment: FractionalOffset.center,
                      image: NetworkImage(url)
                  ),
                ),
              )
            ),
            SizedBox(width: su.setWidth(7)),
            Text(
              name,
              style: TextStyles.weight500px14(),
            )
          ],
        ),
      ),
    );
  }

  Widget getSignInButton() {
    return GestureDetector(
      onTap: () {
        homeController.isCollapsed.value = false;
        authController.showSignInSnackBar();
      },
      child: Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(
            left: su.setWidth(18),
            bottom: su.setHeight(43),
            top: su.setHeight(40)
          ),
          padding: EdgeInsets.only(
            top: su.setHeight(7),
            bottom: su.setHeight(7),
            left: su.setWidth(15),
          ),
          width: su.setWidth(121),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.all(Radius.circular(8))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(Icons.access_alarms_sharp, color: AppColors.white),
              SizedBox(width: su.setWidth(7)),
              Text(
                'Войти',
                style: TextStyles.weight500px14(color: AppColors.white),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  final MenuItem menuItem;
  final HomeController homeController = Get.find();
  final double bottomMargin;
  final ScreenUtil su = ScreenUtil();

  MenuButton(this.menuItem, {this.bottomMargin: 0});

  @override
  Widget build(BuildContext context) {
    return Obx(() => GestureDetector(
      onTap: () {
        homeController.goTo(menuItem);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.only(
          left: su.setWidth(18),
          bottom: bottomMargin
        ),
        padding: EdgeInsets.only(
          top: su.setHeight(7),
          bottom: su.setHeight(7),
          left: su.setWidth(15),
        ),
        width: su.setWidth(145),
        decoration: BoxDecoration(
          color: homeController.menuSelectedItem.value == menuItem 
            ? AppColors.grey 
            : AppColors.white,
          borderRadius: BorderRadius.all(Radius.circular(8))
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: su.setWidth(18),
              height: su.setWidth(18),
              child: Image.asset(menuItem.icon),
            ),
            SizedBox(width: su.setWidth(7)),
            Text(
              menuItem.name,
              style: TextStyles.weight500px14(),
            )
          ],
        ),
      ),
    ));
  }
}