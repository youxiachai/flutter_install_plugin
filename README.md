# install_plugin_v2

[![license](https://img.shields.io/github/license/mashape/apistatus.svg)](https://github.com/youxiachai/flutter_install_plugin/blob/master/LICENSE)

A flutter plugin for install apk for android, use flutter embedding v2

Thanks [https://github.com/hui-z/flutter_install_plugin](https://github.com/hui-z/flutter_install_plugin)

## Usage

To use this plugin, add `install_plugin_v2` as a dependency in your pubspec.yaml file. 

```dart
  /// for Android : install apk by its file absolute path;
  /// if the target platform is higher than android 24:
  /// a [appId] is required
  /// (the caller's applicationId which is defined in build.gradle)
  static Future<String> installApk(String filePath, String appId) async {
    Map<String, String> params = {'filePath': filePath, 'appId': appId};
    return await _channel.invokeMethod('installApk', params);
  }

```

### Example

For Android, you may need to request permission for READ_EXTERNAL_STORAGE to read the apk file. In the example, I used the `permission_handler` [plugin](https://pub.dartlang.org/packages/permission_handler).

please push you demo apk in `/storage/emulated/0/Android/data/com.youxiachai.installpluginexample/files/`

```dart
void main() => runApp(new MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _appUrl = '';
  String _apkFilePath = 'demo.apk';

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Plugin example app'),
        ),
        body: new Column(
          children: <Widget>[
            TextField(
              decoration: InputDecoration(
                  hintText:
                      'appdata files apk file name to install. Like demo.apk'),
              onChanged: (path) {
                _apkFilePath = path;
              },
            ),
            TextButton(
                onPressed: () {
                  onClickInstallApk();
                },
                child: Text('install')),
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

      final resultPath = '$dirPath' + '/' + '$_apkFilePath';
   
      var file = File(resultPath);
      var isExists = await file.exists();
      print('onClickInstallApk _apkFilePath $resultPath exists $isExists');     

      InstallPlugin.installApk(
              resultPath, 'com.youxiachai.installpluginexample')
          .then((result) {
        print('install apk $result');
        

      }).catchError((error) {
        print('install apk error: $error');
      });
    } else {
      print('Permission request fail!');
    }
  }
}

```

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).

For help on editing plugin code, view the [documentation](https://flutter.io/developing-packages/#edit-plugin-package).
