import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:projectx/constants/assets.dart';
import 'package:projectx/constants/colors.dart';
import 'package:projectx/constants/dimens.dart';
import 'package:projectx/models/local/contact_model.dart';
import 'package:projectx/ui/contact_add.dart';
import 'package:projectx/utils/database/db_utils.dart';
import 'package:projectx/utils/device/device_utils.dart';
import 'package:sweetalert/sweetalert.dart';

class ContactList extends StatefulWidget {
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  Future<List<Contact>> contactList;
  DBHelper dbHelper;
  bool _listupdate=true;

  _ContactListState();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    _listupdate=true;
    contactList = dbHelper.getContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF4F6F8),
      appBar: AppBar(),
      body: Container(
        margin: EdgeInsets.only(top: 16),
          height: DeviceUtils.getScaledHeight(context, 1),
          width: DeviceUtils.getScaledWidth(context, 1),
          child: FutureBuilder(
            future: _listupdate ?  dbHelper.getContacts() : dbHelper.getContacts(),
            builder: (context, snapshot) {
              return ListView.builder(
                itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                itemBuilder: (context, index) {
                  print(snapshot.data[index].name);
                  return _contactCard(snapshot, index);
                },
              );
            },
          )),
    );
  }

  _contactCard(snapshot, index) {
    return Container(
      height: 75,
      padding: EdgeInsets.symmetric(horizontal: Dimens.horizontal_padding),
      margin: EdgeInsets.only(bottom: 10,),
      child: PhysicalModel(color: Colors.white,
        elevation: 1,
        borderRadius:BorderRadius.circular(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsets.only(left: 8, right: 16), child: _profileImage(),),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(snapshot.data[index].name, style: TextStyle(color: Color(0xFF1C49B9), fontWeight: FontWeight.w600, fontSize: 16),textAlign: TextAlign.start,),
                  Text(snapshot.data[index].number, style: TextStyle(color: Color(0xFF2F2F2F), fontWeight: FontWeight.w600, fontSize: 16),textAlign: TextAlign.end,),
                ],
              ),
            ),
            Row(
              children: [
                IconButton(icon: Icon(Icons.edit,color: Color(0xFF47a6fd),), onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContactEditTextField(
                          id: snapshot.data[index].id,
                          name: snapshot.data[index].name,
                          number: snapshot.data[index].number,
                        )),
                  );
                }),
                IconButton(icon: Icon(Icons.delete, color: Color(0xFFff6e6c),), onPressed: (){
                  SweetAlert.show(context,
                      title: "Are you sure to delete",
                      subtitle: "delete contact",
                      style: SweetAlertStyle.confirm,
                      showCancelButton: true, onPress: (bool isConfirm) {
                        if (isConfirm) {
                          dbHelper.delete(snapshot.data[index].id);
                          setState(() {
                            _listupdate = true;
                          });
                          SweetAlert.show(context,style: SweetAlertStyle.success,title: "Success");
                          return false;
                        }
                        return true;
                      });
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

_profileImage() {
  return CircularProfileAvatar(
    '',
    child: SvgPicture.asset(
        randomChoice(assetsList),
    ),
    backgroundColor: randomChoice(colorList),
    elevation: 1,
    radius: 25,
  );
}
