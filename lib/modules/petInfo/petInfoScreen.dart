import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:pet_care/shared/colors.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import '../../dataBase/dataBaseUtilities.dart';
import '../../models/Pet.dart';
import '../../models/myUser.dart';
import '../../providers/userProvider.dart';

class petInfoScreen extends StatefulWidget {
  static const String routeName = 'PetInfo';

  @override
  State<petInfoScreen> createState() => _petInfoScreenState();
}

class _petInfoScreenState extends State<petInfoScreen> {
  @override
  Widget build(BuildContext context) {
    var pet = ModalRoute.of(context)!.settings.arguments as Pet;
    var provider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: const BackButton(
          color: MyColors.primaryColor,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            pet.Image != null
                ? Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: CircleAvatar(
                        radius: 100,
                        backgroundImage: NetworkImage(pet.Image ?? "")),
                  )
                : Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: const CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage(
                        "assets/images/appLogo.jpg",
                        // fit: BoxFit.cover,
                      ),
                    ),
                  ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    pet.Name.length < 8
                        ? "${pet.Name}"
                        : "${pet.Name.substring(0, 8)}...",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 20, fontFamily: 'DMSans'),
                    textAlign: TextAlign.center),
                IconButton(
                    color: Colors.red,
                    onPressed: () {
                      showAlert(
                          context,
                          'Are you sure that you want to Delete this Pet ?',
                          1,
                          pet);
                    },
                    icon: const Icon(
                      Icons.delete,
                      size: 30,
                    )),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Text("Type : ${pet.type } ",
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, fontFamily: 'DMSans'),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 10,
            ),
            Text("Gender : ${pet.gender }",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, fontFamily: 'DMSans'),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 10,
            ),
            Text("Birth Day : ${pet.age ?? "Unknowm"}",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, fontFamily: 'DMSans'),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<DocumentSnapshot<myUser>>(
                stream:
                    DataBaseUtils.readUserInfoFromFirestore(provider.user!.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.primaryColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Some Thing went Wrong ...');
                  }
                  var user = snapshot.data;
                  return Text("Owner : ${user!.data()!.Name!} ",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(fontSize: 15, fontFamily: 'DMSans'),
                      textAlign: TextAlign.center);
                }),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<DocumentSnapshot<myUser>>(
                stream:
                    DataBaseUtils.readUserInfoFromFirestore(provider.user!.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.primaryColor,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Text('Some Thing went Wrong ...');
                  }
                  var user = snapshot.data;
                  return QrImage(
                    data:
                        'Name : ${pet.Name}\nOwner : ${pet.ownerName}\nOwner Phone : ${user!.data()!.phone}',
                    size: 120,
                  );
                }),
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: MyColors.primaryColor),
              onPressed: () async {
                String path = await createQrPicture(
                    'Name : ${pet.Name}\nOwner : ${pet.ownerName}\nOwner Phone : ${pet.ownerPhone}');
                final success = await GallerySaver.saveImage(path);
                success!
                    ? showAlert(
                        context, 'The QR has been saved successfully ', 0, pet)
                    : showAlert(context, 'fail to Save', 0, pet);
              },
              child: const Icon(
                Icons.download,
                size: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> writeToFile(ByteData data, String path) async {
    final buffer = data.buffer;
    await File(path).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
  }

  Future<String> createQrPicture(String qr) async {
    late String path;
    final qrValidationResult = QrValidator.validate(
      data: qr,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );
    final qrCode = qrValidationResult.qrCode;

    final painter = QrPainter.withQr(
      qr: qrCode!,
      color: const Color(0xFF000000),
      gapless: false,
    );

    await getTemporaryDirectory().then((value) async {
      String tempPath = value.path;
      final ts = DateTime.now().millisecondsSinceEpoch.toString();
      path = '$tempPath/$ts.png';

      await painter
          .toImageData(2048, format: ui.ImageByteFormat.png)
          .then((value) async {
        await writeToFile(value!, path);
      });
    });
    return path;
  }

  void showAlert(BuildContext context, String txt, int x, Pet pet) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                txt,
                style: const TextStyle(fontSize: 15, fontFamily: 'DMSans'),
              ),
              const SizedBox(
                height: 5,
              ),
              x == 0
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: MyColors.primaryColor),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Ok',
                        style: TextStyle(fontFamily: 'DMSans'),
                      ))
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: MyColors.primaryColor),
                            onPressed: () {
                              DataBaseUtils.DeletePet(pet);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Yes',
                              style: TextStyle(fontFamily: 'DMSans'),
                            )),
                        const SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: MyColors.primaryColor),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'No',
                              style: TextStyle(fontFamily: 'DMSans'),
                            ))
                      ],
                    )
            ]),
          ),
        );
      },
    );
  }
}
