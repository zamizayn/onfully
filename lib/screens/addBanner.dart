import 'dart:io';

import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/viewModel/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddBanner extends StatefulWidget {
  const AddBanner({Key? key}) : super(key: key);

  @override
  _AddBannerState createState() => _AddBannerState();
}

class _AddBannerState extends State<AddBanner> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? images = [];
  void addImages() async {
    PermissionStatus storageAccess = await Permission.storage.status;
    if (storageAccess.isGranted) {
      List<XFile>? imgs = await _picker.pickMultiImage(imageQuality: 50);
      imgs!.forEach((element) {
        images!.add(element);
      });
      print("IMAGES" + images!.length.toString());
      setState(() {});
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();
    }
  }

  void addImageFromCamera() async {
    PermissionStatus cameraAccess = await Permission.camera.status;
    if (cameraAccess.isGranted) {
      PickedFile? img = await ImagePicker.platform
          .pickImage(source: ImageSource.camera, imageQuality: 50);

      XFile file = XFile(img!.path);
      images!.add(file);
      setState(() {});
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.camera,
      ].request();
    }
  }

  void chooseType(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            color: Colors.white,
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Pick Image by using two options"),
                  SizedBox(
                    height: 20,
                  ),
                  new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            // print("hgcghc");
                            addImageFromCamera();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera,
                                size: 50,
                              ),
                              Text("CAMERA")
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Text("OR")],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            addImages();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image,
                                size: 50,
                              ),
                              Text("GALLERY")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("ADD BANNERS"),
      body: Neumorphic(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      //  addImages();
                      chooseType(context);
                    },
                    child: Neumorphic(
                      child: Container(
                        width: MediaQuery.of(context).size.width / 2,
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_a_photo),
                            SizedBox(
                              height: 10,
                            ),
                            Text("Add Images")
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  images!.length > 0
                      ? Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              itemCount: images!.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                        clipBehavior:
                                            Clip.antiAliasWithSaveLayer,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Stack(
                                          children: [
                                            Image.file(
                                              File(images![index].path),
                                              height: 80,
                                              width: 100,
                                              fit: BoxFit.cover,
                                            ),
                                            Positioned(
                                              top: 10,
                                              right: 5,
                                              child: GestureDetector(
                                                onTap: () {
                                                  images!.removeAt(index);
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons
                                                      .remove_circle_outline_sharp,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                        )
                      : Container(),
                  images!.length > 0
                      ? SizedBox(
                          height: 15,
                        )
                      : Container(),
                  images!.length > 0
                      ? GestureDetector(
                          onTap: () {
                            uploadBanners();
                          },
                          child: CustomIcon(icon: Icon(Icons.chevron_right)))
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void uploadBanners() async {
    getLoading(context);
    ProductsVM productsVM = ProductsVM();
    productsVM.addBanners(context, images!);
  }
}
