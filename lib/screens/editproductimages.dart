import 'dart:io';
import 'package:cool_alert/cool_alert.dart';
import 'package:ecom_app/helper/colors.dart';
import 'package:ecom_app/helper/constants.dart';
import 'package:ecom_app/helper/customwidgets.dart';
import 'package:ecom_app/pojo/productdetail.dart';
import 'package:ecom_app/viewModel/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class EditProductImages extends StatefulWidget {
  List<ImageDetail> images = [];
  final String id;

  EditProductImages({required this.images, required this.id});

  @override
  _EditProductImagesState createState() => _EditProductImagesState();
}

class _EditProductImagesState extends State<EditProductImages> {
  final ImagePicker _picker = ImagePicker();
  List<XFile>? images = [];

  void addImages() async {
    PermissionStatus storageAccess = await Permission.storage.status;
    if (storageAccess.isGranted) {
      List<XFile>? imgs = await _picker.pickMultiImage();
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
      PickedFile? img =
          await ImagePicker.platform.pickImage(source: ImageSource.camera);

      XFile file = XFile(img!.path);
      images!.add(file);
      setState(() {});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarContent("EDIT PRODUCT IMAGES"),
      body: SafeArea(
        child: Neumorphic(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  //    customHeader(context, "EDIT PRODUCT IMAGES"),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "Already Added Images",
                    style: TextStyle(fontSize: 15),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    height: 250,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: widget.images.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Image.network(
                                  IMAGEURL + widget.images[index].productImage,
                                  width: 200,
                                  height: 180,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    CoolAlert.show(
                                      context: context,
                                      confirmBtnColor: purple,
                                      backgroundColor: Colors.red,
                                      showCancelBtn: true,
                                      cancelBtnText: "NO",
                                      confirmBtnText: "YES",
                                      onCancelBtnTap: () {
                                        Navigator.pop(context);
                                      },
                                      widget: WillPopScope(
                                        child: Container(),
                                        onWillPop: () async => true,
                                      ),
                                      onConfirmBtnTap: () async {
                                        Navigator.pop(context);
                                        getLoading(context);
                                        ProductsVM vm = ProductsVM();
                                        vm.removeImage(context,
                                            widget.images[index].id.toString());
                                        // Navigator.pushAndRemoveUntil(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (BuildContext context) =>
                                        //         Dashboard(),
                                        //   ),
                                        //   (route) => false,
                                        // );
                                      },
                                      barrierDismissible: true,
                                      type: CoolAlertType.warning,
                                      text:
                                          "Do you want to delete this image ?",
                                    );
                                  },
                                  child: Neumorphic(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            color: Colors.red,
                                          ),
                                          Text("REMOVE"),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        }),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    onTap: () {
                      chooseType(context);
                    },
                    child: Neumorphic(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text("ADD MORE IMAGES"),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  images!.length > 0
                      ? Container(
                          height: 250,
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
                                        child: Stack(
                                          children: [
                                            Image.file(
                                              File(images![index].path),
                                              width: 200,
                                              height: 200,
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
                  SizedBox(
                    height: 20,
                  ),
                  images != null && images!.length > 0
                      ? GestureDetector(
                          onTap: () async {
                            getLoading(context);
                            ProductsVM productsVM = ProductsVM();
                            String? msg = await productsVM.editImages(
                                context, images!, widget.id);
                          },
                          child: CustomIcon(
                              icon: Icon(
                            Icons.check,
                            color: Colors.black,
                          )),
                        )
                      : Container()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
