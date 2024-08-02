import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_sqflite/view/screens/edit_screen.dart';

import '../../controller/controller.dart';

class TodoItem extends StatelessWidget {
  const TodoItem({super.key, required this.controller, required this.index});
  final SQLController controller;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: SizedBox(
        height: 150.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                children: [
                  const Spacer(),
                  Expanded(child: Text(controller.list[index].title)),
                  Expanded(child: Text(controller.list[index].time)),
                ],
              ),
              const SizedBox(
                height: 20.0,
              ),
              Text(controller.list[index].description),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      controller.deleteData(id: controller.list[index].id);
                    },
                    icon: const Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.updateItemIntoFav(
                          taskId: controller.list[index].id,
                          favorite: controller.list[index].favorite);
                    },
                    icon: Icon(
                      Icons.favorite,
                      color: controller.list[index].favorite == 0 ? Colors.black : Colors.red,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      controller.updateTaskData = true;
                      Get.to(
                        () => EditScreen(
                          id: controller.list[index].id,
                          title: controller.list[index].title,
                          desc: controller.list[index].description,
                          time: controller.list[index].time,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
