import 'dart:io';
import 'dart:async';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart';
import 'package:image_crop/image_crop.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:vegitabledelivery/shared/constants.dart';
import 'package:uuid/uuid.dart';

class ImageCropper extends StatefulWidget {
  @override
  _ImageCropperState createState() => new _ImageCropperState();
}

class _ImageCropperState extends State<ImageCropper> {
  final cropKey = GlobalKey<CropState>();
  File _file;
  File _sample;
  File _lastCropped1;
  File _lastCropped2;

  String fileType = '';
  String fileName = '';
  bool buttonClicked = false;
  Map<String, dynamic> prevData = {};

  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped1?.delete();
    _lastCropped2?.delete();
  }

  @override
  Widget build(BuildContext context) {
    prevData = (ModalRoute.of(context).settings.arguments as Map);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 2.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.green[900]),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            'SELECT IMAGE OF ITEM',
            style: TextStyle(color: Colors.green[900], fontSize: 16.0),
          ),
        ),
        body: Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: _sample == null ? _buildOpeningImage() : _buildCroppingImage(),
        ),
      ),
    );
  }

  Widget _buildOpeningImage() {
    return Center(child: _buildOpenImage());
  }

  Widget _buildCroppingImage() {
    return Column(
      children: <Widget>[
        Expanded(
          child: Crop.file(
            _sample,
            key: cropKey,
            aspectRatio: 5.0 / 3.0,
          ),
        ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              OutlineButton(
                borderSide: BorderSide(color: Colors.green[500]),
                child: Text(
                  'CROP IMAGE',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.green[900]),
                ),
                onPressed: () => _cropImage(),
              ),
              _buildOpenImage(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOpenImage() {
    return prevData['action'] == 'EDIT'
        ? Column(
            children: <Widget>[
              OutlineButton(
                borderSide: BorderSide(color: Colors.green[500]),
                child: Text(
                  'EDIT IMAGE',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.green[900]),
                ),
                onPressed: () => _openImage(),
              ),
              OutlineButton(
                borderSide: BorderSide(color: Colors.green[500]),
                child: Text(
                  'SKIP',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.green[900]),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/add-new-items', arguments: {
                    'action': 'IMAGE_NOT_UPDATED',
                    'eachItem': this.prevData['eachItem']
                  });
                },
              ),
            ],
          )
        : Column(
            children: <Widget>[
              OutlineButton(
                borderSide: BorderSide(color: Colors.green[500]),
                child: Text(
                  'ADD IMAGE',
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Colors.green[900]),
                ),
                onPressed: () => _openImage(),
              ),
            ],
          );
  }

  Future<void> _openImage() async {
    final file = await ImagePicker.pickImage(source: ImageSource.gallery);
    final sample = await ImageCrop.sampleImage(
      file: file,
      preferredSize: context.size.longestSide.ceil(),
    );

    _sample?.delete();
    _file?.delete();

    setState(() {
      _sample = sample;
      _file = file;
    });
  }

  Future<void> _cropImage() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, dialogueState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)), //this right here
              child: Container(
                height: 300.0,
                width: 300.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                        color: Colors.green[900],
                        onPressed: this.buttonClicked
                            ? null
                            : () async {
                                dialogueState(() {
                                  this.buttonClicked = true;
                                });
                                var uuid = Uuid();
                                this.fileName = uuid.v1();
                                if (this.fileName.length < 2) {
                                  return;
                                }
                                final area = cropKey.currentState.area;
                                if (area == null) {
                                  // cannot crop, widget is not setup
                                  return;
                                }

                                // scale up to use maximum possible number of pixels
                                // this will sample image in higher resolution to make cropped image larger
                                final sample = await ImageCrop.sampleImage(
                                  file: _file,
                                  preferredWidth: 500,
                                  preferredHeight: 300,
                                );

                                final File file = await ImageCrop.cropImage(
                                  file: sample,
                                  area: area,
                                );

                                sample.delete();

                                // Read a jpeg image from file.
                                final image =
                                    decodeImage(file.readAsBytesSync());

                                // Resize the image to a 120x? thumbnail (maintaining the aspect ratio).
                                final thumbnail =
                                    copyResize(image, width: 500, height: 300);

                                // Save the thumbnail as a PNG.
                                var rng = new Random();

                                final file2 = new File(
                                    '${p.dirname(file.path)}/${rng.nextInt(10000000).toString()}.png')
                                  ..writeAsBytesSync(encodePng(thumbnail));

                                await _uploadFile(file2);
                                _lastCropped1?.delete();
                                _lastCropped1 = file;
                                _lastCropped2?.delete();
                                _lastCropped2 = file2;
                                this.buttonClicked = false;
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/add-new-items',
                                    arguments: {
                                      'action': 'IMAGE_ADDED',
                                      'imageName': '${this.fileName}.png',
                                      'eachItem': this.prevData['eachItem']
                                    });
                              },
                        child: Text(
                          'Upload Image',
                          style: TextStyle(color: Colors.white, fontSize: 18.0),
                        )),
                    buttonClicked
                        ? Theme(
                            child: CircularProgressIndicator(
                                backgroundColor: Colors.green[900]),
                            data: Theme.of(context)
                                .copyWith(accentColor: Colors.white),
                          )
                        : Container(
                            height: 0,
                          )
                  ],
                ),
              ),
            );
          });
        });
  }

  Future<void> _uploadFile(File file) async {
    StorageReference storageReference;
    storageReference = FirebaseStorage.instance
        .ref()
        .child("fresh_green/${this.fileName}.png");
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
  }
}
