import 'dart:io';
import 'package:csv/csv.dart';
import 'package:excel_export_flutter_app/toast_message.dart';
import 'package:external_path/external_path.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart' as sysPath;

import 'alert_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Excel Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<List<dynamic>> employeeData;

  getCsv({required fileName}) async {
    if (await Permission.storage.request().isGranted) {
      debugPrint("is pressed!");
      //store file in documents folder
      //var fileBytes = excel.save();
      String dir = Platform.isAndroid
          ? "${await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS)}/$fileName.csv" //Android
          : "${(await sysPath.getApplicationDocumentsDirectory()).path}/$fileName.csv"; //Ios
      String file = dir;
      File f = File(file);
      debugPrint("android path => $dir");
      debugPrint(
          "${(await sysPath.getApplicationDocumentsDirectory()).path}/$fileName.csv");
      ShowToast.successToast("File saved in $dir");
      /*..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes ?? []);*/
      // convert rows to String and write as csv file
      String csv = const ListToCsvConverter().convert(employeeData);
      f.writeAsString(csv);
    } else {
      await [
        Permission.storage,
      ].request();
    }
  }

  @override
  void initState() {
    super.initState();
    //create an element rows of type list of list. All the above data set are stored in associate list
    //Let associate be a model class with attributes name,gender and age and associateList be a list of associate model class.
    employeeData = <List<dynamic>>[];
    for (int i = 0; i < 5; i++) {
      //row refer to each column of a row in csv file and rows refer to each row in a file
      List<dynamic> row = [];
      row.add("Employee Name $i");
      row.add((i % 2 == 0) ? "Male" : "Female");
      row.add(" Experience : ${i * 5}");
      employeeData.add(row);
    }
  }

  @override
  Widget build(BuildContext context) {

    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    final formKey = GlobalKey<FormState>();

    late TextEditingController nameController = TextEditingController();
    
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ListView.builder(
                shrinkWrap: true,
                itemCount: employeeData.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(employeeData[index][0]),
                          Text(employeeData[index][1]),
                          Text(employeeData[index][2]),
                        ],
                      ),
                    ),
                  );
                }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.green,
                height: 30,
                child: TextButton(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          contentPadding: EdgeInsets.zero,
                          content: SingleChildScrollView(
                            child: Form(
                              key: formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: width,
                                    height: height * 0.06,
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(left: width * 0.04),
                                    color: Colors.blue.shade200,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'File Name',
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                      top: height * 0.02,
                                      left: width * 0.04,
                                      bottom: height * 0.005,
                                    ),
                                    child: Text(
                                      'Give a File Name*',
                                      style: TextStyle(color: Colors.grey.shade800, fontSize: 16),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: width * 0.04),
                                    child: TextFormField(
                                      maxLines: 1,
                                      controller: nameController,
                                      onChanged: (value) {
                                        if (value.isNotEmpty) {
                                          formKey.currentState!.validate();
                                        }
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return '* Required';
                                        }
                                        return null;
                                      },
                                      decoration: const InputDecoration(
                                        hintText: ' Enter File Name',
                                      ),
                                    ),
                                  ),
                                  Container(
                                      height: height * 0.050,
                                      width: width,
                                      margin: EdgeInsets.only(
                                          top: height * 0.02, bottom: height * 0.02),
                                      padding: EdgeInsets.symmetric(horizontal: width * 0.02),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(5)),
                                            primary: Colors.white,
                                            backgroundColor: Colors.blue.shade700),
                                        onPressed: () {
                                          if (formKey.currentState!.validate()) {
                                            getCsv(fileName: nameController.text.trim()).whenComplete(() {
                                              Navigator.of(context).pop();
                                            });
                                          }
                                        },
                                        child: const Text(
                                          'SUBMIT',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  child: const Text(
                    "Export to CSV",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
