import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_helper/controllers/history_controller.dart';
import 'package:whatsapp_helper/controllers/settings_controller.dart';
import 'package:whatsapp_helper/controllers/theme_controller.dart';
import 'package:whatsapp_helper/enums/theme.dart';
import 'package:whatsapp_helper/views/countries.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool downloading = false;
  String progress = '0';
  bool isDownloaded = false;
  String downloadUrl;
  String downloadFileName;
  String downloadedPath;
  var permission = Permission.storage;

  Future<void> downloadFile(downloadUrl, downloadFileName) async {
    setState(() {
      downloading = true;
    });
    String savePath = await getFilePath(downloadFileName);

    Dio dio = Dio();

    if (await permission.isUndetermined) {
      await Permission.storage.request();
    }
    if (await permission.isDenied) {
      await Permission.storage.request();
      downloadFile(downloadUrl, downloadFileName);
    }
    if (await permission.isGranted) {
      dio.download(
        downloadUrl,
        savePath,
        onReceiveProgress: (count, total) {
          setState(() {
            progress = ((count / total) * 100).toStringAsFixed(0);
            // print(progress);
          });
          if (progress == '100') {
            setState(() {
              isDownloaded = true;
            });
          } else if (double.parse(progress) < 100) {}
        },
        deleteOnError: true,
        cancelToken: CancelToken(),
      ).then((_) {
        setState(() {
          if (progress == '100') {
            isDownloaded = true;
          }
          downloading = false;
        });
      });
    } else if (await permission.isPermanentlyDenied) {
      progress = 'Permission Denied';
    }
  }

  Future<String> getFilePath(fileName) async {
    String path = '';
    // Directory dir = await getApplicationDocumentsDirectory();
    Directory dir = await getExternalStorageDirectory();
    // print(dir2.path);
    path = '${dir.path}/$fileName';
    // String path2 = '/sdcard/download/$fileName';
    downloadedPath = path;
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(
              Icons.palette,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Theme'),
            subtitle: Text(Provider.of<ThemeController>(context).isDark
                ? 'Dark'
                : 'Light'),
            trailing: Switch(
              value: Provider.of<ThemeController>(context).isDark,
              onChanged: (value) {
                if (value) {
                  Provider.of<ThemeController>(context, listen: false)
                      .setTheme(AppTheme.Dark);
                } else {
                  Provider.of<ThemeController>(context, listen: false)
                      .setTheme(AppTheme.Light);
                }
              },
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/flags/${Provider.of<SettingsController>(context).country.alpha2Code.toLowerCase()}.png',
              width: 24,
            ),
            title: Text('Default Country'),
            trailing: Text('+ ' +
                Provider.of<SettingsController>(context)
                    .country
                    .callingCodes
                    .first),
            onTap: () => showDialog(
              context: context,
              builder: (context) => Dialog(child: CountriesScreen()),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.history,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Clear History'),
            onTap: () async {
              bool clearStatus = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Are you sure?'),
                  content:
                      Text('This will clear all the entries in History Tab.'),
                  actions: [
                    FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Provider.of<HistoryController>(context, listen: false)
                              .clearHistory();
                          Navigator.of(context).pop(true);
                        }),
                    FlatButton(
                      child: Text('No'),
                      onPressed: () => Navigator.of(context).pop(false),
                    ),
                  ],
                ),
              );
              if (clearStatus) {
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('History Cleared'),
                ));
              }
            },
          ),
          ListTile(
            isThreeLine: true,
            leading: Icon(
              Icons.update,
              color: Theme.of(context).accentColor,
            ),
            title: Text('Check for updates'),
            subtitle: progress == 'Permission Denied'
                ? Text('Permission Denied')
                : progress == '0'
                    ? Text(
                        Provider.of<SettingsController>(context).updateAvailable
                            ? 'Update Available - ' +
                                Provider.of<SettingsController>(context)
                                    .latestVersion
                            : 'No Updates Available',
                      )
                    : progress != '100'
                        ? Text('Downloading - ' + progress + ' %')
                        : Text(
                            'Downloaded - ' +
                                Provider.of<SettingsController>(context)
                                    .latestVersion +
                                '\nClick to Install',
                          ),
            trailing:
                Provider.of<SettingsController>(context).projectVersion != null
                    ? Text('v' +
                        Provider.of<SettingsController>(context).projectVersion)
                    : Text(''),
            onTap: () {
              Provider.of<SettingsController>(context, listen: false)
                  .parseUpdate();
              showDialog(
                  context: context,
                  builder: (context) {
                    return Dialog(
                      child: Provider.of<SettingsController>(context).checking
                          ? Container(
                              height: 200,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text('Checking for updates'),
                                  ],
                                ),
                              ),
                            )
                          : Provider.of<SettingsController>(context)
                                  .updateAvailable
                              ? Container(
                                  height: 400,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    // crossAxisAlignment:
                                    //     CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Update Available',
                                        style: TextStyle(fontSize: 25),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      progress == 'Permission Denied'
                                          ? RaisedButton(
                                              color:
                                                  Theme.of(context).accentColor,
                                              onPressed: () async {
                                                if (await permission
                                                    .isPermanentlyDenied)
                                                  openAppSettings();
                                                else if (await permission
                                                    .isGranted) {
                                                  progress = '0';
                                                  downloadFile(downloadUrl,
                                                      downloadFileName);
                                                }
                                              },
                                              child: Text(progress ==
                                                      'Permission Denied'
                                                  ? 'Open App Settings'
                                                  : 'Download'),
                                            )
                                          : progress != '100'
                                              ? RaisedButton(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  onPressed: () {
                                                    downloadUrl = Provider.of<
                                                                    SettingsController>(
                                                                context,
                                                                listen: false)
                                                            .releaseMap['assets']
                                                            .first[
                                                        'browser_download_url'];
                                                    downloadFileName = Provider
                                                            .of<SettingsController>(
                                                                context,
                                                                listen: false)
                                                        .releaseMap['assets']
                                                        .first['name'];
                                                    Navigator.pop(context);
                                                    downloadFile(downloadUrl,
                                                        downloadFileName);
                                                  },
                                                  child: Text('Download'),
                                                )
                                              : RaisedButton(
                                                  color: Theme.of(context)
                                                      .accentColor,
                                                  onPressed: () {
                                                    OpenFile.open(
                                                        downloadedPath);
                                                  },
                                                  child: Text(
                                                    'Install',
                                                  ),
                                                ),
                                      SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                'Whats New:',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .headline5,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Markdown(
                                                  data: Provider.of<
                                                              SettingsController>(
                                                          context)
                                                      .releaseMap['body']),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 200,
                                  child: Center(
                                    child: Text(
                                      'No Updates Available',
                                      style: TextStyle(fontSize: 25),
                                    ),
                                  ),
                                ),
                    );
                  });
            },
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              downloading
                  ? 'Don\'t go to another tab while downloading update or it will start again'
                  : '',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
