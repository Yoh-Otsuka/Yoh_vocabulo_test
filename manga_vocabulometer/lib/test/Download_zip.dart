

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:archive/archive.dart';

class Download_zip extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Download_zipState();
  }
}

class Download_zipState extends State<StatefulWidget>{

  bool _downloading, _fileExist;
  String _dir;
  List<String> _images, _tempImages;
  String _zipPath = "zipped_images/BARRAGE/ep2.zip";
  String _localZipFileName = "BARRAGE_ep2.zip";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _images = List();
    _tempImages = List();
    _downloading = false;
    _initDir();
  }

  _initDir() async {
    if(null == _dir){
      _dir = (await getApplicationDocumentsDirectory()).path;
    }
    var file = File('$_dir/$_localZipFileName');
    if(file.existsSync()){
      setState(() {
        _fileExist = true;
      });
      print('exist');
    } else {
      _fileExist = false;
      print('Not exist');
    }
  }

  Future<File> _downloadFile(String filePath, String fileName) async {
    //TODO ファイルが既に存在しているかの処理を入れる
    //storageからファイルのURLを取得
    final String url = await FirebaseStorage().ref().child(filePath).getDownloadURL();
    //final http.Response downloadData = await http.get(url);
    var req = await http.Client().get(Uri.parse(url));
    var file = File('$_dir/$fileName');
    return file.writeAsBytes(req.bodyBytes);
  }

  Future<void> _downloadZip() async {

    setState(() {
      _downloading = true;
    });

    if (!_fileExist) {

      _images.clear();
      _tempImages.clear();

      var zippedFile = await _downloadFile(_zipPath, _localZipFileName);
      await unarchiveAndSave(zippedFile);


    } else {
      print('Already downloaded');
      var zippedfile = File('$_dir/$_localZipFileName');
      var bytes = zippedfile.readAsBytesSync();
      var archive = ZipDecoder().decodeBytes(bytes);
      for (var file in archive) {
        var fileName = '$_dir/${file.name}';
        if(file.isFile) {
          var outFile = File(fileName);
          print('File:: ' + outFile.path);
          _images.add(outFile.path);
        }
      }
    }

    setState(() {
      _images.addAll(_tempImages);
      _downloading = false;
    });
  }

  unarchiveAndSave(var zippedFile) async {
    var bytes = zippedFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (var file in archive) {
      var fileName = '$_dir/${file.name}';
      if(file.isFile){
        var outFile = File(fileName);
        print('File:: ' + outFile.path);
        _tempImages.add(outFile.path);
        outFile = await outFile.create(recursive: true);
        await outFile.writeAsBytes(file.content);
      }
    }
  }

  buildList() {
    return Expanded(
      child: ListView.builder(
          itemCount: _images.length,
        itemBuilder: (BuildContext context, int index) {
            return Image.file(File(_images[index]),
            fit : BoxFit.fitWidth);
        },
      ),
    );
  }

  progress() {
    return Container(
      child: CircularProgressIndicator(strokeWidth: 3.0,),
    );
  }



  Widget _checkButton() {
    return RaisedButton(
      onPressed: () {

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("download zip file"),
        actions: <Widget>[
          _downloading ? progress(): Container(),
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: () {
              _downloadZip();
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[

            buildList(),
          ],
        ),
      ),
    );
  }
}