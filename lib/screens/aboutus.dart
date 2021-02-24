import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_player/screens/music_player.dart';
import 'package:music_player/screens/setting.dart';
import 'package:music_player/screens/tracks.dart';
import 'package:music_player/utils/coustom_colors.dart';

class AboutUs extends StatefulWidget {
  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  @override
  Widget build(BuildContext context) {
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
            ListTile(
              leading: Icon(
                Icons.music_note,
                color: CustomColors().customPink,
              ),
              title: Text("Now playing"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => MusicPlayer()));
              },
            ),
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
                Icons.settings,
                color: CustomColors().customPink,
              ),
              title: Text("Setting"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => Setting()));
              },
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: CustomColors().customPink,
              ),
              title: Text("About Us"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AboutUs()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
