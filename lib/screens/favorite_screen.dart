import 'dart:io';

import 'package:flutter/material.dart';
import 'package:music_player/screens/music_player.dart';
import 'package:music_player/utils/coustom_colors.dart';
import 'package:music_player/utils/global_data.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  int currentIndex = 0;
  final GlobalKey<MusicPlayerState> key = GlobalKey<MusicPlayerState>();

  void changeTrack(bool isNext) {
    if (isNext) {
      print(isNext);
      if (currentIndex != favSongs.length - 1) {
        currentIndex++;

        print(currentIndex++);
      }
    } else {
      if (currentIndex != 0) {
        currentIndex--;
      }
    }
    key.currentState.setSong(favSongs[currentIndex]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //     icon: Icon(Icons.arrow_back_ios_sharp,
        //         color: CustomColors().customPink)),
        iconTheme: IconThemeData(color: CustomColors().customPink),
        title: Text(
          'My favorite',
          style: TextStyle(
            color: CustomColors().customPink,
          ),
        ),
      ),
      body: favSongs.isEmpty
          ? Center(
              child: Text(
                'No Favorites yet : (',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 20),
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
                          favSongs.length.toString(),
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
                SizedBox(
                  height: 20,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  separatorBuilder: (context, index) => Divider(),
                  itemCount: favSongs.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: CircleAvatar(
                      backgroundImage: favSongs[index].albumArtwork == null
                          ? AssetImage('assets/images/music_gradient.jpg')
                          : FileImage(File(favSongs[index].albumArtwork)),
                    ),
                    title: Text(
                      favSongs[index].title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      currentIndex = index;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => MusicPlayer(
                            changeTrack: changeTrack,
                            songInfo: favSongs[currentIndex],
                            key: key,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
