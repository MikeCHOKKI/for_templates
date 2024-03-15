import 'package:flutter/material.dart';

class ScanBulletinPage extends StatefulWidget {
  const ScanBulletinPage({Key? key}) : super(key: key);

  @override
  State<ScanBulletinPage> createState() => _ScanBulletinPageState();
}

class _ScanBulletinPageState extends State<ScanBulletinPage> with WidgetsBindingObserver {
  /* bool _isCameraPermissionGranted = false;
  late final Future<void> future;
  CameraController? _cameraController;
  late CameraDescription camera;
  final textRecognizer = TextRecognizer();*/

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /* WidgetsBinding.instance.addObserver(this);
    future = requestCameraPermission();*/
  }
/*
  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    stopCamera();
    textRecognizer.close();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      stopCamera();
    } else if (state == AppLifecycleState.resumed &&
        _cameraController != null &&
        _cameraController!.value.isInitialized) {
      startCamera();
    }

    super.didChangeAppLifecycleState(state);
  }*/

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:
            Container()); /*FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          return Stack(
            children: [
              if (!_isCameraPermissionGranted)
                Scaffold(
                  body: Column(
                    children: [
                      Expanded(child: Center(child: MyTextWidget(text: "Autorisez l'accès à la caméra"))),
                      MyButtonWidget(
                        text: "Demander l'autorisation",
                        action: () {
                          Permission.camera.request();
                        },
                      )
                    ],
                  ),
                ),
              if (_isCameraPermissionGranted)
                FutureBuilder<List<CameraDescription>>(
                    future: availableCameras(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        initCamera(snapshot.data!);
                        print("Cam data ${snapshot.data!}");
                        return Scaffold(
                          body: Column(
                            children: [
                              Expanded(
                                child: CameraPreview(_cameraController!),
                              ),
                              MyButtonWidget(
                                text: "Scanner",
                                action: () {
                                  scanImage();
                                },
                              )
                            ],
                          ),
                        );
                      } else {
                        return MyLoadingWidget();
                      }
                    }),
            ],
          );
        });*/
  }

  /*void startCamera() {
    if (_cameraController != null) {
      print("SetSelectedCamera started");
      setSelectedCamera(_cameraController!.description);
    }
  }

  void stopCamera() {
    if (_cameraController != null) {
      _cameraController?.dispose();
    }
  }

  Future<void> requestCameraPermission() async {
    final status = await Permission.camera.request();
    _isCameraPermissionGranted = status == PermissionStatus.granted;
  }

  void initCamera(List<CameraDescription> cameras) {
    if (_cameraController != null) {
      return;
    }
    for (var i = 0; i < cameras.length; i++) {
      final CameraDescription currentCamera = cameras[i];
      if (currentCamera.lensDirection == CameraLensDirection.back) {
        camera = currentCamera;

        print("Camera list lenght ${cameras.length}");
      }
    }
    if (camera != null) {
      setSelectedCamera(camera);
    }
  }

  void setSelectedCamera(CameraDescription camera) async {
    _cameraController = CameraController(camera, ResolutionPreset.max, enableAudio: false);

    await _cameraController?.initialize();
    if (!mounted) {
      return;
    }

    setState(() {});
  }

  Future<void> scanImage() async {
    if (_cameraController == null) return;
    try {
      final image = await _cameraController!.takePicture();
      final file = File(image.path);

      final inputImage = InputImage.fromFile(file);
      final recognizedText = await textRecognizer.processImage(inputImage);
      Fonctions()
          .showWidgetAsDialog(context: context, widget: MyTextWidget(text: recognizedText.text), title: "Text Reconnu");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: MyTextWidget(text: "Une erreur s'est produite")));
    }
  }*/
}
