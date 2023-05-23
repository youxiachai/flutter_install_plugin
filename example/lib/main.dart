import 'dart:io';

import 'package:flutter/material.dart';
import 'package:install_plugin_v2/install_plugin_v2.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String _appUrl = '';
  String _apkFilePath = 'demo.apk';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            TextField(
              decoration: const InputDecoration(hintText: 'app data files apk file name to install. Like demo.apk'),
              onChanged: (path) {
                print('onChanged $path');
                _apkFilePath = path;
              },
            ),
            TextButton(
                onPressed: () {
                  onClickInstallApk();

                  //
                },
                child: const Text('install')),
            // TextField(
            //   decoration:
            //       InputDecoration(hintText: 'URL for app store to launch'),
            //   onChanged: (url) => _appUrl = url,
            // ),
            // TextButton(
            //     onPressed: () => onClickGotoAppStore(_appUrl),
            //     child: Text('gotoAppStore'))
          ],
        ),
      ),
    );
  }

  void onClickInstallApk() async {
    if (_apkFilePath.isEmpty) {
      print('make sure the apk file is set');
      return;
    }
    var permissions = await Permission.storage.status;
    if (permissions.isGranted) {
      var storageDir = await getExternalStorageDirectory();
      final dirPath = storageDir?.path ?? '/';

      final resultPath = dirPath + '/' + _apkFilePath;

      var file = File(resultPath);
      var isExists = await file.exists();
      print('onClickInstallApk _apkFilePath $resultPath exists $isExists');

      InstallPlugin.installApk(resultPath, 'com.youxiachai.installpluginexample').then((result) {
        print('install apk $result');
      }).catchError((error) {
        print('install apk error: $error');
      });
    } else {
      print('Permission request fail!');
    }
  }

  void onClickGotoAppStore(String url) {
    // url = url.isEmpty
    //     ? 'https://itunes.apple.com/cn/app/%E5%86%8D%E6%83%A0%E5%90%88%E4%BC%99%E4%BA%BA/id1375433239?l=zh&ls=1&mt=8'
    //     : url;
    // InstallPlugin.gotoAppStore(url);
  }
}
