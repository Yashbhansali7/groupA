import 'package:flutter/material.dart';
import 'package:job_assessment/screens/welcome_screen.dart';

class CustomAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Container listContainer(String listText, double padd) {
      return Container(
          padding: EdgeInsets.all(padd),
          margin: EdgeInsets.only(left: 22),
          alignment: Alignment.centerLeft,
          child: Text(
            listText,
            style: TextStyle(
                color: Colors.cyan[800],
                fontSize: 18,
                //  fontWeight: FontWeight.w500,
                letterSpacing: .6),
            textAlign: TextAlign.start,
          ));
    }

    _showSheet() {
      showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.transparent,
        context: context,
        builder: (context) {
          return Wrap(children: [
            AnimatedContainer(
              duration: Duration(seconds: 0),
              height: 600,
              margin: EdgeInsets.only(right: 10, left: 10, top: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                // color: Colors.blue[100],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 8,
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.only(left: 20),
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        radius: 35,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Your Name'),
                          Text('Your Username'),
                          TextButton.icon(
                              onPressed: () {},
                              icon: Icon(Icons.star_border),
                              label: Text('11'))
                        ],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton.icon(
                          onPressed: () {},
                          label: Text('1900'),
                          icon: Icon(
                            Icons.wallet_giftcard,
                          ))
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.teal,
                  ),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      listContainer('Groupalike Premium', 5),
                      SizedBox(
                        width: 100,
                      ),
                      Icon(
                        Icons.shield,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.teal,
                  ),
                  Divider(
                    color: Colors.white,
                  ),
                  listContainer('Follow requests', 3),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  listContainer('Refer a Friend', 3),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  listContainer('My Data', 3),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  listContainer('Bookmark', 3),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  listContainer('Report a Bug', 3),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  listContainer('Give Feedback', 3),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  listContainer('Settings', 3),
                  Divider(
                    color: Colors.grey[300],
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(context)
                            .pushReplacementNamed(WelcomeScreen.routeName);
                      },
                      child: listContainer('Log Out', 3)),
                ],
              ),
            ),
          ]);
        },
      );
    }
    return Container(
      child: Row(
        children: [
          IconButton(
              onPressed: _showSheet,
              splashRadius: 20,
              icon: Icon(
                Icons.menu_outlined,
                size: 30,
                color: Colors.cyan[600],
              )),
          IconButton(
              onPressed: () {},
              splashRadius: 20,
              icon: Icon(
                Icons.notifications_none_outlined,
                size: 30,
                color: Colors.cyan[600],
              )),
          IconButton(
              onPressed: () {},
              splashRadius: 20,
              icon: Icon(
                Icons.search_outlined,
                size: 30,
                color: Colors.cyan[600],
              )),
          SizedBox(
            width: 40,
          ),
          TextButton.icon(
            style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.all(0))),
            onPressed: () {},
            icon: Icon(
              Icons.star_border_outlined,
              size: 30,
              color: Colors.cyan[600],
            ),
            label: Text('11',
                style: TextStyle(
                  color: Colors.cyan[600],
                )),
          ),
          TextButton.icon(
            style: ButtonStyle(padding: MaterialStateProperty.all(EdgeInsets.all(0))),
            onPressed: () {},
            icon: Icon(
              Icons.wallet_travel_outlined,
              size: 30,
              color: Colors.cyan[600],
            ),
            label: Text(
              '1900',
              style: TextStyle(
                color: Colors.cyan[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
