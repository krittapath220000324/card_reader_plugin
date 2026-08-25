import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:card_reader_plugin/card_reader_plugin.dart';
import 'package:path_provider/path_provider.dart' as path;

void main() {
  runZonedGuarded( () {
    runApp(const MyApp());
  }, (Object error, StackTrace stack) {
    _buildLogsFile(error: error, stack: stack);
  });
}

Future<void> _buildLogsFile({
  required Object error,
  required StackTrace stack
}) async {
  final cacheApps = await path.getApplicationCacheDirectory();
  final String cachePath = cacheApps.path;
  if(kDebugMode) print("_buildLogsFile: cachePath: $cachePath");

  final String logsDirsPath = "$cachePath/logs_apps";
  final dirs = Directory(logsDirsPath);

  if(!await dirs.exists()) {
    await dirs.create();
  }

  final String logsPath = dirs.path;
  if(kDebugMode) print("_buildLogsFile: logsPath: $logsPath");

  final String timeStamp = DateTime
      .now()
      .toIso8601String();

  final String pathFile = "$logsPath/${timeStamp}_logs_file.txt";
  if(kDebugMode) print("_buildLogsFile: pathFile: $pathFile");

  final File file = File(pathFile);

  await file.writeAsString(
      "$stack",
      mode: .append
  );

  if(kDebugMode) print("_buildLogsFile: writeAsString: ${file.path}");

}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  @override
  StatefulElement createElement() => _MyAppElement(this);
}

class _MyAppElement extends StatefulElement {

  _MyAppElement(super.widget);

}

class _MyAppState extends State<MyApp> {

  static final bool _platformAndroid = Platform.isAndroid;
  static final bool _platformIOS = Platform.isIOS;

  String _platformVersion = 'Unknown';
  String _readerStatus = "";
  String _deviceName = "";

  void get _updateUI {
    if(mounted) setState(() {});
  }

  bool _waiting = false;

  static CardReaderPlugin Function() get _cardReaderPlugin =>
          () => CardReaderPlugin();
  
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }
  
  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await _cardReaderPlugin
          .call()
          .getPlatformVersion() ?? "";
      
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    if (!mounted) return;
    _platformVersion = platformVersion;
    _updateUI;
  }
  
  late Size _size;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _size = MediaQuery.of(context).size;

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp
    ]);

    if(_size.width > 600) {
      _size = MediaQuery.of(context).copyWith(
          size: Size.fromWidth(450)
      ).size;
    }

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(
          useMaterial3: true
      ),
      home: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.deepPurple,
            title: Text(
              "R&D Card Reader Plugin",
              maxLines: 1,
              overflow: TextOverflow.fade,
              style: TextStyle(
                  fontFamily: "Tahoma",
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                  fontSize: 20.0
              ),
            ),
            centerTitle: true,
          ),
          body: Stack(
            children: [

              _buildMain(
                height: _size.height,
                width: _size.width
              ),

              if(_waiting) Container(
                  height: _size.height,
                  width: _size.width,
                  color: Colors.black12,
                  alignment: Alignment.center,
                  child: SizedBox(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
              ),

            ],
          )
      ),
    );
  }

  Widget _buildMain({
    required double height,
    required double width,
  }) => Container(
    height: _size.height,
    width: _size.width,
    padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        SizedBox(
          height: height * 0.018,
        ),


        Text(
          "Platform Version: $_platformVersion"
        ),
        SizedBox(
          height: height * 0.008,
        ),
        Text(
          "Card Reader Status: $_readerStatus",
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(
          height: height * 0.018,
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .openLibrary()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text("openLibrary")
              ),
            ),

            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .closedLibrary()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text("closedLibrary")
              ),
            ),
          ],
        ),

        SizedBox(
          height: height * 0.008,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _waiting = true;
                    _updateUI;
                    _cardReaderPlugin
                        .call()
                        .updateLicenseFile()
                        .then((result) {
                      _readerStatus = "$result";
                      _waiting = false;
                      _updateUI;
                    });
                  },
                  child: Text("updateLicenseFile")
              ),
            ),

            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {

                    if(_platformIOS) {
                      _waiting = true;
                      _updateUI;
                    }

                    _cardReaderPlugin
                        .call()
                        .findReader()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;

                      final Map<String,dynamic> hashmap = result is Map
                          ? Map<String,dynamic>.from(result)
                          : <String,dynamic>{};
                      _readerStatus = "hashmap: $hashmap";
                      _updateUI;
                      
                      final resultList = hashmap["result"] is List<dynamic> 
                          ? hashmap["result"] as List<dynamic> 
                          : [];
                      _readerStatus = "resultList: $resultList";
                      _updateUI;
                      
                      final deviceName = resultList
                          .map((element) => element.toString())
                          .toList();

                      _readerStatus = "deviceName: $deviceName";
                      _deviceName = deviceName.isNotEmpty
                          ? deviceName.first
                          : "empty device name !!";

                      if(_platformIOS) _waiting = false;

                      _updateUI;
                    });

                  },
                  child: Text("findReader")
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.008,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _waiting = true;
                    _updateUI;
                    _cardReaderPlugin
                        .call()
                        .getReaderInfo()
                        .then((result) {
                      _readerStatus = "$result";
                      _waiting = false;
                      _updateUI;
                    });
                  },
                  child: Text("getReaderInfo")
              ),
            ),

            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .requestPermission()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text(
                    "requestPermission",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  )
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.008,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if(_platformAndroid) SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .setPermissionsAndroid(
                        permissionCode: 1
                    ).then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text("setPermissions")
              ),
            ),

            if(_platformAndroid) SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .closedEventsListenerAndroid()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text(
                    "closedEventsListener",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  )
              ),
            ),

            if(_platformIOS) SizedBox(
              width: width * 0.4,
            ),

            if(_platformIOS) SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .getReaderListIos()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text(
                    "getReaderListIos",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  )
              ),
            ),

          ],
        ),
        SizedBox(
          height: height * 0.008,
        ),


        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .selectReader(
                        deviceName: _deviceName
                    ).then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });

                    // try {
                    //
                    // } on PlatformException catch (error,stack){
                    //   _buildLogsFile(error: error, stack: stack);
                    // }

                  },
                  child: Text("selectReader")
              ),
            ),

            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .deselectReader()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text("deselectReader")
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.008,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .connectCard()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text("connectCard")
              ),
            ),

            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .disconnectCard()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text("disconnectCard")
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.008,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .getSoftwareInfo()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text("getSoftwareInfo")
              ),
            ),

            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .getLicenseInfo()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text("getLicenseInfo")
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.008,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .getIDCardNumber()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text("getIDCardNumber")
              ),
            ),

            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .getIDCardText()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text("getIDCardText")
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.008,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .getPhotoByteImage()
                        .then(_getPhotoImage);
                  },
                  child: Text(
                    "getPhotoByteImage",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  )
              ),
            ),

            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .getIDCardTextWithArgument(
                        optionNumber: 1
                    ).then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text(
                    "getIDCardTextWithArgument",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  )
              ),
            ),
          ],
        ),
        SizedBox(
          height: height * 0.008,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .getCardStatus()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text(
                      "getCardStatus"
                  )
              ),
            ),

            if(_platformAndroid) SizedBox(
              width: width * 0.4,
            ),

            if(_platformIOS) SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .setReaderTypeIos()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text(
                    "setReaderTypeIos",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  )
              ),
            )

          ],
        ),

        SizedBox(
          height: height * 0.008,
        ),


        if(_platformIOS) Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            SizedBox(
              width: width * 0.4,
              child: OutlinedButton(
                  onPressed: () {
                    _cardReaderPlugin
                        .call()
                        .stopFindReaderIos()
                        .then((result) {
                      _readerStatus = "$result";
                      _updateUI;
                    });
                  },
                  child: Text(
                    "stopFindReaderIos",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  )
              ),
            ),

            SizedBox(
              width: width * 0.4,
            ),

          ],
        )


      ],
    ),
  );

  void _getPhotoImage(dynamic result) {
    if(kDebugMode) print("_getPhotoImage: result: $result");

    final Map<String,dynamic> hashmap = result is Map
        ? Map<String,dynamic>.from(result)
        : <String,dynamic>{};
    if(kDebugMode) print("_getPhotoImage: hashmap: $hashmap");

    if(hashmap.isEmpty) return;

    final Uint8List byteImage = hashmap["result"] is Uint8List
        ? hashmap["result"] as Uint8List
        : Uint8List.fromList(List.empty());

    if(kDebugMode) print("_getPhotoImage: byteImage: $byteImage");

    final int code = hashmap["code"] is int
        ? hashmap["code"] as int
        : -1;

    final Uint8List? image = byteImage.isEmpty
        ? null
        : byteImage;


    if(kDebugMode) print("_getPhotoImage: image: $image");
    if(kDebugMode) print("_getPhotoImage: code: $code");

    _readerStatus = "code: $code || image: $image";
    _updateUI;
  }

}
