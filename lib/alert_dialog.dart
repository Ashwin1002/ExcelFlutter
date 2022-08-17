import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SubmitDialog extends StatefulWidget {
  const SubmitDialog({Key? key, required this.function}) : super(key: key);

  final Function function;



  @override
  State<SubmitDialog> createState() => _SubmitAlertDialogState();
}

class _SubmitAlertDialogState extends State<SubmitDialog> {

  final formKey = GlobalKey<FormState>();

  late TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      //Provider.of<PropertyState>(context, listen: false).getRatingDataFromAPI(pid: int.parse(propId));
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
                  children: [
                    Text(
                      'File Name',
                      style: Theme.of(context).textTheme.headline1,
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
                            widget.function().whenComplete(() {
                          Navigator.of(context).pop();
                        });
                      }
                    },
                    child: Text(
                      'SUBMIT',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
