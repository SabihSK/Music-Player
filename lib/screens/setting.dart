import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/screens/albums.dart';
import 'package:music_player/screens/artists.dart';
import 'package:music_player/screens/tracks.dart';
import 'package:music_player/utils/coustom_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget {
  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Future<void> _launched;
  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    const String toLaunch = 'http://remerse.com/';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Setting',
          style: TextStyle(color: CustomColors().customPink),
        ),
        iconTheme: IconThemeData(color: CustomColors().customPink),
        // actions: [
        //   IconButton(
        //     icon: Icon(
        //       Icons.search,
        //       color: CustomColors().customPink,
        //     ),
        //     onPressed: () async {
        //       // await showSearch(
        //       //   context: context,
        //       //   delegate: SearchScreen(files: files),
        //       // );
        //     },
        //   ),
        // ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // ListTile(
            //   leading: Icon(
            //     Icons.music_note,
            //     color: CustomColors().customPink,
            //   ),
            //   title: Text("Now playing"),
            //   trailing: Icon(Icons.arrow_forward),
            //   onTap: () {
            //     Navigator.of(context).pop();
            //     Navigator.of(context).push(MaterialPageRoute(
            //         builder: (BuildContext context) => MusicPlayer()));
            //   },
            // ),
            ListTile(
              leading: Icon(
                Icons.art_track,
                color: CustomColors().customPink,
              ),
              title: Text("Music List"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Tracks()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: CustomColors().customPink,
              ),
              title: Text(
                "Artist",
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Artists()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.album,
                color: CustomColors().customPink,
              ),
              title: Text(
                "Albums",
                // style: TextStyle(color: Colors.white),
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Albums()));
              },
            ),
            Container(
              color: CustomColors().customPink,
              child: ListTile(
                leading: Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                title: Text("Setting"),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Setting()));
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: CustomColors().customPink,
              ),
              title: Text("About Us"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                _launched = _launchInBrowser(toLaunch);
                // Navigator.of(context).pop();
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (BuildContext context) => AboutUs()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
