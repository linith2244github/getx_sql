import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_sqflite/Controller/news_controller.dart';
import 'package:getx_sqflite/View/widgets/category_widget.dart';
import 'package:getx_sqflite/View/widgets/home_widget.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final controller = Get.put(NewsController());
  final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Get.dialog(
          AlertDialog(
            title: const Text('Closing The App'),
            content: const Text('Are you sure to close the app?'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Get.back(
                      result: true,
                    );
                  },
                  child: const Text('Close')),
              ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('Cancel')),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'News App',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {
                  controller.changeThemeMode();
                },
                icon: Icon(controller.iconTheme())),
          ],
        ),
        body: PageView(
          onPageChanged: (index){
            controller.changeNavBar(currentIndex: index);
            debugPrint(index.toString());
          },
          controller: pageController,
          children: const [
            HomeWidget(),
            CategoryWidget(),
          ],
        ),
        bottomNavigationBar: GetBuilder<NewsController>(builder: (controller){
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: controller.index,
            onTap: (index){
              controller.changeNavBar(currentIndex: index);
              pageController.jumpToPage(index);
              debugPrint(index.toString());
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_max_outlined),
                activeIcon: Icon(Icons.home),
                label: 'Home',
                tooltip: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                activeIcon: Icon(Icons.category),
                label: 'Category',
                tooltip: 'Category',
              ),
            ],
          );
        },)
      ),
    );
  }
}
