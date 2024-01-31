import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mimicon_hyperhire_test/constants.dart';
import 'package:flutter_mimicon_hyperhire_test/file_handler.dart';
import 'package:flutter_mimicon_hyperhire_test/permission_handler.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:image_picker/image_picker.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: kAppPrimaryColor),
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
  final WidgetsToImageController _imageController = WidgetsToImageController();
  final _faceDetector = FaceDetector(
      options: FaceDetectorOptions(
    enableClassification: true,
    enableContours: true,
    performanceMode: FaceDetectorMode.accurate,
    enableLandmarks: true,
  ));

  XFile? image;
  Offset? eyePosition;
  Offset? mouthPosition;
  double eyeGap = 30;
  bool eyePositionClicked = false,
      mouthPositionClicked = false,
      savingFile = false,
      multipleFaceDetected = false;
  double eyeCircleWidth = 30.0, eyeCircleHeight = 30.0;
  double mouthCircleWidth = 60.0, mouthCircleHeight = 30.0;
  final GlobalKey genKey = GlobalKey();

  _selectImageFromGallery() async {
    final tempImage = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = tempImage;
    });
    if (image?.path != null) {
      final faces = await _faceDetector
          .processImage(InputImage.fromFilePath(image!.path));
      log("Faces detected = ${faces.length}");
      if (faces.length > 1) {
        setState(() {
          multipleFaceDetected = true;
        });
      } else {
        setState(() {
          multipleFaceDetected = false;
        });
      }
    }
  }

  _captureImage() async {
    final tempImage = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      image = tempImage;
    });
    if (image?.path != null) {
      final faces = await _faceDetector
          .processImage(InputImage.fromFilePath(image!.path));
      log("Faces detected = ${faces.length}");
      if (faces.length > 1) {
        setState(() {
          multipleFaceDetected = true;
        });
      } else {
        setState(() {
          multipleFaceDetected = false;
        });
      }
    }
  }

  @override
  void initState() {
    eyePosition = const Offset(150, 150);

    mouthPosition = const Offset(170, 250);
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
                      padding: const EdgeInsets.only(top: 50, bottom: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (!multipleFaceDetected && image != null) {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("닫다?"),
                                      content: const Text("편집을 취소하시겠습니까?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: const Text("취소")),
                                        TextButton(
                                            onPressed: () {
                                              setState(() {
                                                image = null;
                                                eyePositionClicked = false;
                                                mouthPositionClicked = false;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: const Text("닫다"))
                                      ],
                                    );
                                  },
                                );
                              } else {
                                setState(() {
                                  image = null;
                                  eyePositionClicked = false;
                                  mouthPositionClicked = false;
                                });
                              }
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
                              } else if (item == "position") {
                                setState(() {
                                  eyePosition = const Offset(150, 150);
                                });
                              }
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<String>>[
                              const PopupMenuItem<String>(
                                value: "gallery",
                                child: Text('갤러리에서 다시 선택'),
                              ),
                              const PopupMenuItem<String>(
                                value: "camera",
                                child: Text('새로운 사진을 찍다'),
                              ),
                              if (!multipleFaceDetected)
                                const PopupMenuItem<String>(
                                  value: "position",
                                  child: Text('위치 재설정'),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    WidgetsToImage(
                      controller: _imageController,
                      key: genKey,
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 390,
                            child: Image.file(
                              File(image!.path),
                              fit: BoxFit.fill,
                            ),
                          ),
                          if (eyePositionClicked)
                            Positioned(
                              left: eyePosition?.dx ?? 0,
                              top:
                                  (eyePosition?.dy ?? 0) - eyeCircleHeight - 94,
                              child: Draggable(
                                feedback: Row(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        width: 45,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color:
                                              kGreenBackground.withOpacity(0.8),
                                        ),
                                        child: const Center(
                                          child: SizedBox(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: eyeGap,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 45,
                                        height: 26,
                                        decoration: BoxDecoration(
                                          color:
                                              kGreenBackground.withOpacity(0.8),
                                        ),
                                        child: const Center(
                                          child: SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onDraggableCanceled:
                                    (Velocity velocity, Offset offset) {
                                  if (!eyePositionClicked) {
                                    return;
                                  }
                                  setState(() => eyePosition = offset);
                                },
                                child: Row(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        width: 45,
                                        height: 26,
                                        decoration: const BoxDecoration(
                                          color: kGreenBackground,
                                        ),
                                        child: const Center(
                                          child: SizedBox(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: eyeGap,
                                    ),
                                    ClipOval(
                                      child: Container(
                                        width: 45,
                                        height: 26,
                                        decoration: const BoxDecoration(
                                          color: kGreenBackground,
                                        ),
                                        child: const Center(
                                          child: SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (mouthPositionClicked)
                            Positioned(
                              left: mouthPosition?.dx ?? 0,
                              top: (mouthPosition?.dy ?? 0) -
                                  mouthCircleHeight -
                                  94,
                              child: Draggable(
                                feedback: Row(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        width: 66,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color:
                                              kGreenBackground.withOpacity(0.8),
                                        ),
                                        child: const Center(
                                          child: SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                onDraggableCanceled:
                                    (Velocity velocity, Offset offset) {
                                  if (!mouthPositionClicked) {
                                    return;
                                  }
                                  setState(() => mouthPosition = offset);
                                },
                                child: Row(
                                  children: [
                                    ClipOval(
                                      child: Container(
                                        width: 66,
                                        height: 30,
                                        decoration: const BoxDecoration(
                                          color: kGreenBackground,
                                        ),
                                        child: const Center(
                                          child: SizedBox(),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          if (multipleFaceDetected)
                            Positioned(
                              left: 100,
                              top: 20,
                              child: Container(
                                alignment: Alignment.center,
                                width: 240,
                                height: 69,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.black.withOpacity(0.4),
                                ),
                                child: const Center(
                                    child: Text(
                                  multipleFaceDetectedString,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    if (eyePositionClicked && !multipleFaceDetected)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 20),
                            child: Text(
                              "눈 위치를 조정하다",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Slider(
                            activeColor: kAppPrimaryColor,
                            value: eyeGap,
                            max: MediaQuery.of(context).size.width - 300,
                            onChanged: (double value) {
                              setState(() {
                                eyeGap = value;
                              });
                            },
                          ),
                        ],
                      ),
                    if (!multipleFaceDetected) const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: InkWell(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                              "assets/images/back_icon.png",
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              "다시찍기",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        onTap: () {
                          if (!multipleFaceDetected && image != null) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text("닫다?"),
                                  content: const Text("편집을 취소하시겠습니까?"),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("취소")),
                                    TextButton(
                                        onPressed: () {
                                          setState(() {
                                            image = null;
                                            eyePositionClicked = false;
                                            mouthPositionClicked = false;
                                          });
                                          Navigator.pop(context);
                                        },
                                        child: const Text("닫다"))
                                  ],
                                );
                              },
                            );
                          } else {
                            setState(() {
                              image = null;
                              eyePositionClicked = false;
                              mouthPositionClicked = false;
                            });
                          }
                        },
                      ),
                    ),
                    if (!multipleFaceDetected)
                      const SizedBox(
                        height: 25,
                      ),
                    if (!multipleFaceDetected)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  eyePositionClicked = true;
                                });
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                    child: Text(
                                  "눈",
                                  style: TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  mouthPositionClicked = true;
                                });
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Center(
                                    child: Text(
                                  "입",
                                  style: TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                          ],
                        ),
                      ),
                    if (!multipleFaceDetected)
                      const SizedBox(
                        height: 58,
                      ),
                    if (savingFile)
                      const CircularProgressIndicator(
                        color: kAppPrimaryColor,
                      ),
                    if (!savingFile && !multipleFaceDetected)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll(
                                mouthPositionClicked && eyePositionClicked
                                    ? kAppPrimaryColor
                                    : Colors.grey),
                            foregroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                            minimumSize: const MaterialStatePropertyAll(
                              Size(double.infinity, 40),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              side: BorderSide.none,
                            )),
                          ),
                          onPressed: () async {
                            try {
                              if (mouthPositionClicked && eyePositionClicked) {
                                final granted = await PermissionHelper
                                    .requestStoragePermissions();
                                if (granted) {
                                  setState(() {
                                    savingFile = true;
                                  });
                                  try {
                                    await savePictureToFile(_imageController);
                                    setState(() {
                                      savingFile = false;
                                    });
                                  } catch (e) {
                                    log(e.toString());
                                    savingFile = false;
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                              content: Text(
                                                  permissionNotGrantedString)));
                                    }
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                permissionNotGrantedString)));
                                  }
                                }
                              }
                            } catch (e) {
                              log(e.toString());
                            }
                          },
                          child: const Text(
                            '저장하기',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    const Spacer(),
                    const SizedBox(
                      height: 20,
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
                              "이미지 선택",
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
                              "새 사진 캡처",
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
