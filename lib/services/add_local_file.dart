import 'dart:io';
import 'package:docs/pages/person.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:docs/services/database.dart';

class AddImage extends StatelessWidget {

  final PersonDetails person;
  AddImage({ this.person });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // theme: ThemeData(brightness: Brightness.dark),
      body: ImageCapture(person: person,),
    );
  }
}

/// Widget to capture and crop the image
class ImageCapture extends StatefulWidget {
  final PersonDetails person;
  ImageCapture({this.person});
  createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  /// Active image file
  File _imageFile;

  /// Cropper plugin
  Future<void> _cropImage() async {
    File cropped = await ImageCropper.cropImage(
        sourcePath: _imageFile.path,
        );

    setState(() {
      _imageFile = cropped ?? _imageFile;
    });
  }

  /// Select an image via gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    // ignore: deprecated_member_use
    File selected = await ImagePicker.pickImage(source: source);

    setState(() {
      _imageFile = selected;
    });
  }

  /// Remove image
  void _clear() {
    setState(() => _imageFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.purple[200],),
        title: Text('Add a file', style: TextStyle(color: Colors.purple[200]),),
        backgroundColor: Colors.grey[800],
        automaticallyImplyLeading: true,
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.grey[800],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(
                Icons.photo_camera,
                color: Colors.purple[200],
                size: 30,
              ),
              onPressed: () {
                _pickImage(ImageSource.camera);
                },
              color: Colors.grey[800],
              label: Text('Take photo', style: TextStyle(color: Colors.purple[200]),),
            ),
            FlatButton.icon(
              icon: Icon(
                Icons.photo_library,
                color: Colors.purple[200],
                size: 30,
              ),
              onPressed: () => _pickImage(ImageSource.gallery),
              color: Colors.grey[800],
              label: Text('Pick from Gallery', style: TextStyle(color: Colors.purple[200]),),
            ),
          ],
        ),
      ),
      body: Container(
        color: Colors.grey[900],
        child: ListView(
          children: <Widget>[
            if (_imageFile != null) ...[
              Container(
                  padding: EdgeInsets.all(32), child: Image.file(_imageFile)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  RaisedButton.icon(
                    color: Colors.grey[800],
                    icon: Icon(Icons.crop, color: Colors.purple[200]),
                    onPressed: _cropImage,
                    label: Text('Crop Image', style: TextStyle(color: Colors.purple[200]),),
                  ),
                  RaisedButton.icon(
                    color: Colors.grey[800],
                    icon: Icon(Icons.cancel, color: Colors.purple[200]),
                    onPressed: _clear,
                    label: Text('Discard Image', style: TextStyle(color: Colors.purple[200]),),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(32),
                child: Uploader(
                  file: _imageFile,
                  person: widget.person,
                ),
              )
            ]
          ],
        ),
      ),
    );
  }
}

/// Widget used to handle the management of
class Uploader extends StatefulWidget {
  final File file;
  final PersonDetails person;

  Uploader({Key key, this.file, this.person}) : super(key: key);

  createState() => _UploaderState();
}

class _UploaderState extends State<Uploader> {
    
  StorageUploadTask _uploadTask;
  DateTime time;
  StorageReference _storage;
  String filePath;
  String completeText;
  String detect = '';

  Future<void> detectLabels() async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(widget.file);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();

    final VisionText visionText = await textRecognizer.processImage(visionImage);

    String wholeText = visionText.text;
    textRecognizer.close();
    setState(() {
      completeText = wholeText;
    });
  }

  Future<void> textdetect() async {
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(widget.file);
    final TextRecognizer textRecognizer = FirebaseVision.instance.textRecognizer();

    final VisionText visionText = await textRecognizer.processImage(visionImage);

    String wholeText = visionText.text;
    textRecognizer.close();
    setState(() {
      detect = wholeText;
    });
  }

  _startUpload() async {
    setState(() {
      time = DateTime.now();
      // print('in add local');
      // print(time.toString().substring(0,19));
      String tempTime = time.toString().substring(0,19);
      filePath = '${widget.person.uid}/$tempTime.png';
      _storage = FirebaseStorage(storageBucket: 'ADD FIREBASE STORAGE BUCKET LINK').ref().child(filePath);
      _uploadTask = _storage.putFile(widget.file);
    });
    // print('in add local file 1');
    // print(time);
  }

  @override
  Widget build(BuildContext context) {
    if (_uploadTask != null) {
      // print('in add_local_file');
      // print(widget.person.uid);
      return StreamBuilder<StorageTaskEvent>(
          stream: _uploadTask.events,
          builder: (context, snapshot) {
            var event = snapshot?.data?.snapshot;

            double progressPercent = event != null
                ? event.bytesTransferred / event.totalByteCount
                : 0;

            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(value: progressPercent, backgroundColor: Colors.grey[800], valueColor: AlwaysStoppedAnimation<Color>(Colors.purple[200])),
                  SizedBox(height: 20,),
                  Text(
                    '${(progressPercent * 100).toStringAsFixed(2)} % ',
                    style: TextStyle(fontSize: 18, color: Colors.green[300]),
                  ),
                  SizedBox(height: 20,),
                  if(_uploadTask.isComplete)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ButtonTheme(
                        minWidth: 120,
                        child: RaisedButton.icon(onPressed: ()async{
                          try {
                            await detectLabels();
                            DatabaseService(uid: widget.person.uid).addDownloadUrl(time, _storage, completeText);
                          } catch (e) {
                            print('ERROR OCCURRED WHILE ADDING TO DATABSE ${e.toString()}' );
                          }
                          Navigator.pop(context);
                        }, 
                        icon: Icon(Icons.check, color: Colors.purple[200]), 
                        label: Text(
                          'Done', 
                          style: TextStyle(
                            color: Colors.purple[200]
                          ), 
                        ), 
                        color: Colors.grey[800],
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 140,
                      child: RaisedButton.icon(
                        onPressed: ()async{
                          try {
                            await detectLabels();
                            DatabaseService(uid: widget.person.uid).addDownloadUrl(time, _storage, completeText);
                          } catch (e) {
                            print('ERROR OCCURRED WHILE ADDING TO DATABSE ${e.toString()}' );
                          }
                          // Navigator.pop(context);
                          Navigator.pushReplacement(context,  MaterialPageRoute(builder: (context) => AddImage(person: widget.person,)));
                        }, 
                        icon: Icon(Icons.play_arrow, color: Colors.purple[200]), 
                        label: Text(
                        'Continue', 
                          style: TextStyle(
                            color: Colors.purple[200]
                          ), 
                        ), 
                        color: Colors.grey[800],
                      ),
                    ),
                    ],
                  )

                // if(_uploadTask.isComplete)
                ]);
          });
    } else {
      textdetect();
      return Column(
        children: [
          if(detect!="")
            Text('Detected Text', style: TextStyle(fontSize: 18, color: Colors.white)),
          if(detect!="")
            SizedBox(height: 20,),
          if(detect!="")
            Text(detect, style: TextStyle(fontSize: 18, color: Colors.white)),
          if(detect!="")
            SizedBox(height: 20,),
          FlatButton.icon(
              color: Colors.grey[800],
              label: Text('Save image', style: TextStyle(color: Colors.purple[200]),),
              icon: Icon(Icons.cloud_upload, color: Colors.purple[200]),
              onPressed: _startUpload),
        ],
      );
    }
  }
}