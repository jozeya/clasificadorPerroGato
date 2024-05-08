import 'package:cat_dog/controller/scan_controller2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TopImageViewer extends GetView<ScanController2> {
  const TopImageViewer({super.key});

  @override
  Widget build(BuildContext context) {
    return GetX<ScanController2>(builder: (controller) =>
        Positioned(
          top: 50,
          child: Container(
            width: Get.width,
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.imageList.length,
              itemBuilder: (_, index){
                return SizedBox(
                  height: 100,
                  width: 75,
                  child: Container(
                    margin: EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black54,
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(
                            3,3
                          )
                        )
                      ]
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: RepaintBoundary(
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: MemoryImage(
                                controller.imageList[index]
                              )
                            )
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            ),
          )
        )
    );
  }
}
