import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/screens/album.dart';

import 'package:music_player/screens/music_player.dart';
import 'package:music_player/screens/setting.dart';
import 'package:music_player/screens/tracks.dart';
import 'package:music_player/utils/coustom_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';

class Singres extends StatefulWidget {
  @override
  _SingresState createState() => _SingresState();
}

class _SingresState extends State<Singres> {
  Future<void> _launched;
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  int currentIndex = 0;
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();
  TextEditingController editingController = TextEditingController();
  // List<File> files;

  void initState() {
    super.initState();
    getTracks();
    // getFiles();
  }

  // Future<void> getFiles() async {
  //   // Either the permission was already granted before or the user just granted it.
  //   if (await Permission.storage.request().isGranted) {
  //     //asyn function to get list of files
  //     List<StorageInfo> storageInfo = await PathProviderEx.getStorageInfo();
  //     var root = storageInfo[0]
  //         .rootDir; //storageInfo[1] for SD card, geting the root directory
  //     var fm = FileManager(root: Directory(root)); //
  //     files = await fm.filesTree(
  //         excludedPaths: ["/storage/emulated/0/Android"],
  //         extensions: ["mp3"] //optional, to filter files, list only pdf files
  //         );
  //     setState(() {}); //update the UI
  //   }
  // }

  void printdata() {
    print("data");
    print(changeTrack);
    print(songs[currentIndex]);
    print(key);
  }

  void getTracks() async {
    songs = await audioQuery.getSongs();
    setState(() {
      songs = songs;
    });
  }

  void changeTrack(bool isNext) {
    if (isNext) {
      print(isNext);
      if (currentIndex != songs.length - 1) {
        currentIndex++;

        print(currentIndex++);
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState.setSong(songs[currentIndex]);
  }

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
          'Artist',
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
        //       await showSearch(
        //         context: context,
        //         delegate: SearchScreen(files: files),
        //       );
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
            Container(
              color: CustomColors().customPink,
              child: ListTile(
                leading: Icon(
                  Icons.art_track,
                  color: Colors.white,
                ),
                title: Text(
                  "Artist",
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Icon(Icons.arrow_forward),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (BuildContext context) => Singres()));
                },
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.art_track,
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
                    builder: (BuildContext context) => Album()));
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
                _launched = _launchInBrowser(toLaunch);
                // Navigator.of(context).pop();
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (BuildContext context) => AboutUs()));
              },
            ),
          ],
        ),
      ),
      body: ListView.separated(
        shrinkWrap: true,
        separatorBuilder: (context, index) => Divider(),
        itemCount: songs.length,
        itemBuilder: (context, index) => ListTile(
          leading: CircleAvatar(
            backgroundImage: songs[index].albumArtwork == null
                ? AssetImage('assets/images/music_gradient.jpg')
                : FileImage(File(songs[index].albumArtwork)),
          ),
          title: Text(songs[index].artist),
          // title),
          subtitle: Text(songs[index].artistId),
          onTap: () {
            currentIndex = index;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => MusicPlayer(
                  changeTrack: changeTrack,
                  songInfo: songs[currentIndex],
                  key: key,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
