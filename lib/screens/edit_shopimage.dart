import 'dart:io';

import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/pojo/profilepojo.dart';
import 'package:ecom_app/viewModel/products.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class EditShopImage extends StatefulWidget {
  final ProfilePojo image;
  EditShopImage({required this.image});

  @override
  _EditShopImageState createState() => _EditShopImageState();
}

class _EditShopImageState extends State<EditShopImage> {
  final ImagePicker _picker = ImagePicker();
  XFile? file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("EDIT SHOP IMAGE"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // customHeader(context, "EDIT SHOP IMAGE"),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: file == null
                      ? Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: NetworkImage(IMAGEURL +
                                widget.image.imageDetails.last["shop_image"]),
                            fit: BoxFit.cover,
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.7),
                                BlendMode.dstATop),
                          )),
                          height: 30.h,
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            onTap: () {
                              chooseType(context);
                            },
                            child: Icon(
                              Icons.camera_enhance,
                              color: Colors.white,
                              size: 30,
                            ),
                          ))
                      : Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                            image: FileImage(File(file!.path)),
                            fit: BoxFit.cover,
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.7),
                                BlendMode.dstATop),
                          )),
                          height: 30.h,
                          width: MediaQuery.of(context).size.width,
                          child: GestureDetector(
                            onTap: () {
                              chooseType(context);
                            },
                            child: Icon(
                              Icons.camera_enhance,
                              color: Colors.white,
                              size: 30,
                            ),
                          )),
                ),
              ),
              TextButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(purple)),
                  onPressed: () async {
                    // print("GHGHGHG" + file!.name.toString());
                    if (file == null) {
                      showToast("No new file selected");
                    } else if (file != null) {
                      getLoading(context);
                      ProductsVM productsVM = ProductsVM();
                      String? message =
                          await productsVM.editShopImage(context, file);
                      showToast("Image added successfully");
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12.0, right: 12),
                    child: Text(
                      "Upload",
                      style: TextStyle(fontSize: 9.sp, color: Colors.white),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  void addImages() async {
    PermissionStatus storageAccess = await Permission.storage.status;
    if (storageAccess.isGranted) {
      file = await _picker.pickImage(
          source: ImageSource.gallery, imageQuality: 50);

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

      file = XFile(img!.path);

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
}
