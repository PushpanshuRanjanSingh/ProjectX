import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:projectx/constants/dimens.dart';
import 'package:projectx/models/local/contact_model.dart';
import 'package:projectx/ui/contact_list_show.dart';
import 'package:projectx/utils/database/db_utils.dart';
import 'package:projectx/utils/device/device_utils.dart';

class ContactEditTextField extends StatefulWidget {
  final String name;
  final String number;
  final int id;

  const ContactEditTextField({Key key, this.name, this.number, this.id})
      : super(key: key);
  @override
  _ContactEditTextFieldState createState() => _ContactEditTextFieldState();
}

class _ContactEditTextFieldState extends State<ContactEditTextField> {
  DBHelper dbHelper;
  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  FocusNode nameNode = FocusNode();
  FocusNode numberNode = FocusNode();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _havetoUpdate = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    numberController = TextEditingController();
    _havetoUpdate = widget.name == null ? false : true;
    nameController.text = _havetoUpdate ? widget.name : nameController.text;
    numberController.text =
        _havetoUpdate ? widget.number : numberController.text;
    debugPrint("${nameController.text}     ${numberController.text}");
    nameNode = FocusNode();
    numberNode = FocusNode();
    dbHelper = DBHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            height: DeviceUtils.getScaledHeight(context, 1),
            width: DeviceUtils.getScaledWidth(context, 1),
            child: ListView(
              children: [
                Container(
                  height: DeviceUtils.getScaledHeight(context, 0.4),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(
                              DeviceUtils.getScaledHeight(context, 0.30))),
                      color: Color(0xFFF3F4F9)),
                  child: Center(
                    child: _profileImage(),
                  ),
                ),
                SizedBox(height: DeviceUtils.getScaledHeight(context, 0.1)),
                PhysicalModel(
                  color: Colors.white,
                  elevation: 4,
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(
                          DeviceUtils.getScaledHeight(context, 0.1))),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: Dimens.horizontal_padding,
                        vertical: Dimens.vertical_padding),
                    height: DeviceUtils.getScaledHeight(context, 0.4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Add/Modify",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color(0xFF364CB0)),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color(0xFFF3F4F9)),
                          child: TextFormField(
                            controller: nameController,
                            focusNode: nameNode,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.name,
                            onFieldSubmitted: (val) {
                              FocusScope.of(context).requestFocus(numberNode);
                            },
                            maxLength: 12,
                            decoration: InputDecoration(
                                hintText: _havetoUpdate ? widget.name : "name",
                                counterText: '',
                                icon: Icon(Icons.person_rounded),
                                border: InputBorder.none),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Color(0xFFF3F4F9)),
                          child: TextFormField(
                            controller: numberController,
                            focusNode: numberNode,
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            maxLength: 10,
                            decoration: InputDecoration(
                                counterText: '',
                                hintText:
                                    _havetoUpdate ? widget.number : "number",
                                icon: Icon(Icons.phone_android_rounded),
                                border: InputBorder.none),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _button(
                                Color(0xFFCE2E53),
                                _havetoUpdate ? "Update" : "Add",
                                _havetoUpdate
                                    ? () {
                                        final contact = Contact.withId(
                                            id: widget.id,
                                            name: nameController.text,
                                            number: numberController.text);
                                        dbHelper.update(contact);
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text("Updated"),
                                          duration: Duration(milliseconds: 80),
                                        ));
                                      }
                                    : () {
                                        final contact = Contact(
                                            name: nameController.text,
                                            number: numberController.text);
                                        dbHelper.add(contact);
                                        _scaffoldKey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text("Added"),
                                          duration: Duration(milliseconds: 80),
                                        ));
                                      }),
                            _button(Color(0xFF6A66F8), "Show", () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactList()),
                              );
                            }),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    numberController.dispose();
    nameNode.dispose();
    numberNode.dispose();
    dbHelper.close();
  }
}

_profileImage() {
  return CircularProfileAvatar(
    '',
    child: Image.network(
      "https://image.freepik.com/free-vector/cute-boy-standing-position-showing-thumb_96037-450.jpg",
      fit: BoxFit.cover,
    ),
    elevation: 2,
    radius: 50,
  );
}

_button(Color color, String label, Function onPressed) {
  return Container(
      decoration:
          BoxDecoration(borderRadius: BorderRadius.circular(30), color: color),
      child: FlatButton(onPressed: onPressed, child: Text(label)));
}
