import 'package:core/common_folder/Fonctions/Fonctions.dart';
import 'package:core/common_folder/constantes/styles.dart';
import 'package:core/common_folder/widgets/MyButtonWidget.dart';
import 'package:core/common_folder/widgets/MyTextWidget.dart';
import 'package:core/objet/ProduitBank.dart';
import 'package:flash_note/RateProduitBankPage.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanProduitBankPage extends StatefulWidget {
  const ScanProduitBankPage({Key? key}) : super(key: key);

  @override
  State<ScanProduitBankPage> createState() => _ScanProduitPageState();
}

class _ScanProduitPageState extends State<ScanProduitBankPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? qrController;
  Barcode? result;
  bool isFlashOn = false;
  switchOffFlash() {
    qrController!.getFlashStatus().then((value) {
      setState(() {
        isFlashOn = value ?? false;
        if (isFlashOn) {
          qrController!.toggleFlash();
        }
      });
    });
  }

  void _onQRViewCreated(QRViewController controller) {
    this.qrController = controller;
    switchOffFlash();
    controller.scannedDataStream.listen((scanData) {
      controller.stopCamera();
      setState(() {
        if (result == null) {
          result = scanData;
          if (result!.code!.isNotEmpty) {
            switchOffFlash();
            Fonctions().openPageToGo(
                contextPage: context,
                pageToGo: RateProduitBankPage(produitBank: ProduitBank(code: "${result!.code}")),
                replacePage: true);
            result = null;
            //controller.resumeCamera();
          }
        }
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            Container(
              height: 200,
              width: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              clipBehavior: Clip.hardEdge,
              child: QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
            ),
            SizedBox(
              height: 24,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MyButtonWidget(
                  backColor: Colors.white,
                  iconData: isFlashOn ? Icons.lightbulb : Icons.lightbulb_outline,
                  padding: EdgeInsets.all(16),
                  action: () {
                    qrController!.toggleFlash();
                    setState(() {
                      isFlashOn = !isFlashOn;
                    });
                  },
                )
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      children: <Widget>[
                        MyTextWidget(
                          text: "Comment ça marche?",
                          theme: BASE_TEXT_THEME.DISPLAY,
                          textColor: Colors.black,
                        ),
                        MyTextWidget(
                          text:
                              "Identifie sur l'emballage de ton produit son Code QR ou Code barre. Pointe ta caméra dessus et laisse la magie s'opérer.",
                          textColor: Colors.black,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
