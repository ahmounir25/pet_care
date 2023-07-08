import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pet_care/shared/colors.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanning extends StatefulWidget {

  static const String routeName = 'scanning';

  @override
  State<QrScanning> createState() => _QrScanningState();
}

class _QrScanningState extends State<QrScanning> {

  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(flex: 4, child: _buildQrView(context)),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  if (result != null)
                    Center(
                        child: Text(
                      'Content :\n${result!.code}',
                      style: TextStyle(fontSize: 18, fontFamily: 'DMSans'),
                    ))
                  else
                    const Text(
                      'Scan The QR Code',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'DMSans'),
                    ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: MyColors.primaryColor),
                          onPressed: () async {
                            await controller?.resumeCamera();
                          },
                          child: const Text('Start',
                              style: TextStyle(
                                  fontSize: 10, fontFamily: 'DMSans')),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: MyColors.primaryColor,
                          ),
                          onPressed: () async {
                            await controller?.pauseCamera();
                          },
                          child: const Text('pause',
                              style: TextStyle(
                                  fontSize: 10, fontFamily: 'DMSans')),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 350 ||
            MediaQuery.of(context).size.height < 350)
        ? 150.0
        : 300.0;

    return QRView(
      key: qrKey,
      onQRViewCreated: getQR_info,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void getQR_info(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
