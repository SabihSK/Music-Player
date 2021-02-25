import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:music_player/screens/albums.dart';
import 'package:music_player/screens/artist_songs.dart';

import 'package:music_player/screens/music_player.dart';
import 'package:music_player/screens/setting.dart';
import 'package:music_player/screens/tracks.dart';
import 'package:music_player/utils/coustom_colors.dart';
import 'package:url_launcher/url_launcher.dart';

import 'dart:io';

class Artists extends StatefulWidget {
  @override
  _ArtistsState createState() => _ArtistsState();
}

class _ArtistsState extends State<Artists> {
  List<ArtistInfo> artists;
  Future<void> _launched;
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();

  @override
  void initState() {
    getArtists();
    super.initState();
  }

  void getArtists() async {
    artists = await audioQuery.getArtists(); // returns all artists available
    setState(() {
      artists = artists;
    });
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
          'Artists',
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
                      builder: (BuildContext context) => Artists()));
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
                    builder: (BuildContext context) => Albums()));
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
                  'Artists',
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
                    artists.length.toString(),
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
              itemCount: artists.length,
              itemBuilder: (context, index) => ListTile(
                leading: CircleAvatar(
                  backgroundImage: artists[index].artistArtPath == null
                      ? AssetImage('assets/images/music_gradient.jpg')
                      : Image.file(File(artists[index].artistArtPath)),
                ),
                title: Text(artists[index].name),
                // title),
                subtitle: Text(artists[index].numberOfTracks),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ArtistSongs(
                        artistInfo: artists[index],
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
