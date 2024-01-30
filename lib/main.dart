import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mimicon',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  Offset? position;
  double width = 30.0, height = 30.0;

  _selectImageFromGallery() async {
    final tempImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = tempImage;
    });
  }

  _captureImage() async {
    final tempImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      image = tempImage;
    });
  }

  @override
  void initState() {
    position = const Offset(100, 100);
    _picker.pickImage(source: ImageSource.camera).then((value) {
      setState(() {
        image = value;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: image == null ? Colors.white : Colors.black,
        alignment: Alignment.center,
        child: Center(
          child: image != null && image?.path != null
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 30, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                image = null;
                              });
                            },
                            icon: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                          PopupMenuButton<String>(
                            icon: const Icon(
                              Icons.more_vert,
                              color: Colors.white,
                              size: 30,
                            ),
                            initialValue: null,
                            // Callback that sets the selected popup menu item.
                            onSelected: (item) {
                              if (item == "camera") {
                                _captureImage();
                              } else if (item == "gallery") {
                                _selectImageFromGallery();
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: "gallery",
                                child: Text('Reselect from Gallery'),
                              ),
                              const PopupMenuItem<String>(
                                value: "camera",
                                child: Text('Take new Picture'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Stack(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          height: 420,
                          child: Image.file(
                            File(image!.path),
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          left: position?.dx ?? 0,
                          top: (position?.dy ?? 0) - height - 66,
                          child: Draggable(
                            feedback: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.elliptical(90, 55),
                                    ),
                                    color: Colors.green.withOpacity(0.5),
                                  ),
                                  child: const Center(
                                    child: SizedBox(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Container(
                                  width: 48,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.elliptical(90, 55),
                                    ),
                                    color: Colors.green.withOpacity(0.5),
                                  ),
                                  child: const Center(
                                    child: SizedBox(),
                                  ),
                                ),
                              ],
                            ),
                            onDraggableCanceled:
                                (Velocity velocity, Offset offset) {
                              setState(() => position = offset);
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.elliptical(90, 55),
                                    ),
                                    color: Colors.green.withOpacity(0.8),
                                  ),
                                  child: const Center(
                                    child: SizedBox(),
                                  ),
                                ),
                                const SizedBox(
                                  width: 30,
                                ),
                                Container(
                                  width: 48,
                                  height: 30,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                      Radius.elliptical(90, 55),
                                    ),
                                    color: Colors.green.withOpacity(0.8),
                                  ),
                                  child: const Center(
                                    child: SizedBox(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // TODO: change icon
                            Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            // TODO: change text to korean
                            Text(
                              "Go Back",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          // TODO: change text and color of container and size of container and text
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 60,
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                  child: Text(
                                "EYE",
                                style: TextStyle(fontSize: 22),
                              )),
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          // TODO: change text and color of container and size of container and text
                          InkWell(
                            onTap: () {},
                            child: Container(
                              width: 60,
                              height: 65,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Center(
                                  child: Text(
                                "MOU",
                                style: TextStyle(fontSize: 22),
                              )),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // TODO: change text and color of container and size of container and text
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              const MaterialStatePropertyAll(Colors.blueAccent),
                          foregroundColor:
                              const MaterialStatePropertyAll(Colors.white),
                          minimumSize: const MaterialStatePropertyAll(
                            Size(double.infinity, 45),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            side: BorderSide.none,
                          )),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Submit',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                )
              : Container(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () async {
                          _selectImageFromGallery();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Select Image",
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          _captureImage();
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.camera),
                            SizedBox(
                              width: 5,
                            ),
                            Text(
                              "Capture new Picture",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
