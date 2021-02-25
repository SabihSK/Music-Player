import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';

import 'package:music_player/screens/music_player.dart';
import 'package:music_player/screens/setting.dart';
import 'package:music_player/screens/tracks.dart';
import 'package:music_player/utils/coustom_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';

import 'albums.dart';
import 'artists.dart';

class AlbumSongs extends StatefulWidget {
  final AlbumInfo albumInfo;

  const AlbumSongs({Key key, @required this.albumInfo}) : super(key: key);
  @override
  _AlbumSongsState createState() => _AlbumSongsState();
}

class _AlbumSongsState extends State<AlbumSongs> {
  List<SongInfo> songs;
  Future<void> _launched;
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  int currentIndex = 0;
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    getSongsOfAlbum();
    super.initState();
  }

  void getSongsOfAlbum() async {
    /// getting all songs available on device storage
    songs = await audioQuery.getSongsFromAlbum(albumId: widget.albumInfo.id);
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
          widget.albumInfo.title,
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
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => Artists(),
                    ),
                  );
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
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Albums(),
                  ),
                );
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 20, bottom: 10),
            child: Row(
              children: [
                Text(
                  'Songs',
                  style: TextStyle(
                      fontSize: 22,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                Container(
                  height: 30,
                  width: 50,
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    color: CustomColors().customPink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    songs.length.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              separatorBuilder: (context, index) => Divider(),
              itemCount: songs.length,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: widget.albumInfo.albumArt == null
                      ? AssetImage('assets/images/music_gradient.jpg')
                      : Image.file(File(widget.albumInfo.albumArt)),
                ),
                title: Text(songs[index].title),
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
          ),
        ],
      ),
    );
  }
}
