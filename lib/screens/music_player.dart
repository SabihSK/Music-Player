import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_player/screens/aboutus.dart';
import 'package:music_player/screens/favorite_screen.dart';
import 'package:music_player/screens/setting.dart';
import 'package:music_player/screens/tracks.dart';
import 'package:music_player/utils/coustom_colors.dart';
import 'package:music_player/utils/global_data.dart';
import 'package:music_player/widgets/custom_slider.dart';
import 'package:music_player/widgets/custom_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class MusicPlayer extends StatefulWidget {
  SongInfo songInfo;
  Function changeTrack;
  final GlobalKey<MusicPlayerState> key;
  MusicPlayer({this.songInfo, this.changeTrack, this.key}) : super(key: key);
  MusicPlayerState createState() => MusicPlayerState();
}

class MusicPlayerState extends State<MusicPlayer> {
  Future<void> _launched;
  double minimumValue = 0.0, maximumValue, currentValue = 0.0;
  String currentTime = '', endTime = '';
  bool isPlaying = false;
  bool showSlider = false;
  final AudioPlayer player = AudioPlayer();

  void initState() {
    super.initState();
    setSong(widget.songInfo);
  }

  void dispose() {
    super.dispose();
    player?.dispose();
  }

  void setSong(SongInfo songInfo) async {
    widget.songInfo = songInfo;
    await player.setUrl(widget.songInfo.uri);
    currentValue = minimumValue;
    maximumValue = player.duration.inMilliseconds.toDouble();
    setState(() {
      currentTime = getDuration(currentValue);
      endTime = getDuration(maximumValue);
    });
    isPlaying = false;
    changeStatus();
    player.positionStream.listen((duration) {
      currentValue = duration.inMilliseconds.toDouble();
      setState(() {
        currentTime = getDuration(currentValue);
      });
    });
  }

  void changeStatus() {
    setState(() {
      isPlaying = !isPlaying;
    });
    if (isPlaying) {
      player.play();
    } else {
      player.pause();
    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());

    return [duration.inMinutes, duration.inSeconds]
        .map((element) => element.remainder(60).toString().padLeft(2, '0'))
        .join(':');
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
  Widget build(context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    const String toLaunch = 'http://remerse.com/';
    maximumValue = double.parse(widget.songInfo.duration);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.of(context).pop();
        //     },
        //     icon: Icon(Icons.arrow_back_ios_sharp,
        //         color: CustomColors().customPink)),
        iconTheme: IconThemeData(color: CustomColors().customPink),
        title: Text('Now Playing',
            style: TextStyle(color: CustomColors().customPink)),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            // Container(
            //   color: CustomColors().customPink,
            //   child: ListTile(
            //     leading: Icon(
            //       Icons.music_note,
            //       color: CustomColors().customPink,
            //     ),
            //     title: Text("Now playing"),
            //     trailing: Icon(Icons.arrow_forward),
            //     onTap: () {
            //       Navigator.of(context).pop();
            //       Navigator.of(context).push(MaterialPageRoute(
            //           builder: (BuildContext context) => MusicPlayer()));
            //     },
            //   ),
            // ),
            ListTile(
              leading: Icon(
                Icons.art_track,
                color: CustomColors().customPink,
              ),
              title: Text("Music List"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                dispose();
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => Tracks(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                Icons.list,
                color: CustomColors().customPink,
              ),
              title: Text("My favorite"),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => FavoriteScreen(),
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
                dispose();
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
                dispose();
                _launched = _launchInBrowser(toLaunch);
                // Navigator.of(context).pop();
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (BuildContext context) => AboutUs()));
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(5, 57, 5, 0),
            child: Column(children: <Widget>[
              CircleAvatar(
                backgroundImage: widget.songInfo.albumArtwork == null
                    ? AssetImage('assets/images/music_gradient.jpg')
                    : FileImage(File(widget.songInfo.albumArtwork)),
                radius: 75,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: Text(
                  widget.songInfo.title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 0, 0, 33),
                child: Text(
                  widget.songInfo.artist,
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Slider(
                inactiveColor: Colors.black12,
                activeColor: CustomColors().customPink,
                min: minimumValue,
                max: maximumValue,
                value: currentValue,
                onChanged: (value) {
                  currentValue = value;
                  player.seek(Duration(milliseconds: currentValue.round()));
                },
              ),
              Container(
                transform: Matrix4.translationValues(0, -15, 0),
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(currentTime,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500)),
                    Text(endTime,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500))
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                height: 60,
                width: screenWidth * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      icon: Icon(
                        favSongs.contains(widget.songInfo)
                            ? Icons.favorite_rounded
                            : Icons.favorite_outline_rounded,
                        color: favSongs.contains(widget.songInfo)
                            ? CustomColors().customPink
                            : Colors.grey,
                      ),
                      onPressed: () {
                        if (favSongs.contains(widget.songInfo)) {
                          showToast(text: 'Removed from favorites');
                          favSongs.remove(widget.songInfo);
                        } else {
                          showToast(text: 'Added to favorites');
                          favSongs.insert(0, widget.songInfo);
                        }
                        setState(() {});
                      },
                    ),
                    StreamBuilder<LoopMode>(
                      stream: player.loopModeStream,
                      builder: (context, snapshot) {
                        final loopMode = snapshot.data ?? LoopMode.off;
                        final icons = [
                          Icon(Icons.repeat, color: Colors.grey),
                          Icon(Icons.repeat, color: CustomColors().customPink),
                          Icon(Icons.repeat_one,
                              color: CustomColors().customPink),
                        ];
                        const cycleModes = [
                          LoopMode.off,
                          LoopMode.all,
                          LoopMode.one,
                        ];
                        final index = cycleModes.indexOf(loopMode);
                        return IconButton(
                          icon: icons[index],
                          onPressed: () {
                            if (index == 0) {
                              showToast(text: 'Loop all');
                            } else if (index == 1) {
                              showToast(text: 'Loop one');
                            } else {
                              showToast(text: 'Loop disabled');
                            }
                            player.setLoopMode(
                              cycleModes[(cycleModes.indexOf(loopMode) + 1) %
                                  cycleModes.length],
                            );
                          },
                        );
                      },
                    ),
                    StreamBuilder<bool>(
                      stream: player.shuffleModeEnabledStream,
                      builder: (context, snapshot) {
                        final shuffleModeEnabled = snapshot.data ?? false;
                        return IconButton(
                          icon: shuffleModeEnabled
                              ? Icon(Icons.shuffle,
                                  color: CustomColors().customPink)
                              : Icon(Icons.shuffle, color: Colors.grey),
                          onPressed: () async {
                            final enable = !shuffleModeEnabled;
                            if (enable) {
                              showToast(text: 'Loop enabled');
                              player.shuffleModeEnabledStream;
                            } else {
                              showToast(text: 'Loop disabled');
                            }

                            await player.setShuffleModeEnabled(enable);
                          },
                        );
                      },
                    ),
                    StreamBuilder<double>(
                      stream: player.speedStream,
                      builder: (context, snapshot) => IconButton(
                        icon: Text(
                          "${snapshot.data?.toStringAsFixed(1)}x",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        onPressed: () {
                          setState(() {
                            showSlider = true;
                          });
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.more_horiz,
                        color: Colors.grey,
                      ),
                      onPressed: () => buildBottomSheet(
                          context: context,
                          height: screenHeight,
                          songInfo: widget.songInfo),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: Icon(Icons.skip_previous,
                          color: CustomColors().customPink, size: 55),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.changeTrack(false);
                      },
                    ),
                    GestureDetector(
                      child: Icon(
                          isPlaying
                              ? Icons.pause_circle_filled_rounded
                              : Icons.play_circle_fill_rounded,
                          color: CustomColors().customPink,
                          size: 85),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        changeStatus();
                      },
                    ),
                    GestureDetector(
                      child: Icon(Icons.skip_next,
                          color: CustomColors().customPink, size: 55),
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        widget.changeTrack(true);
                      },
                    ),
                  ],
                ),
              ),
            ]),
          ),
          Positioned(
            top: screenHeight * 0.8,
            right: 0,
            left: 0,
            child: Visibility(
              visible: showSlider,
              child: StreamBuilder<double>(
                  stream: player.speedStream,
                  builder: (context, snapshot) {
                    return Slider(
                      activeColor: CustomColors().customPink,
                      divisions: 10,
                      min: 0.0,
                      max: 1.5,
                      value: snapshot.data == null ? 0.0 : snapshot.data,
                      onChanged: (val) {
                        player.setSpeed(val);
                        Timer(Duration(seconds: 2), () {
                          setState(() {
                            showSlider = false;
                          });
                        });
                      },
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

void buildBottomSheet(
    {BuildContext context, double height, SongInfo songInfo}) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: height * 0.2,
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            children: <Widget>[
              InkWell(
                onTap: () => buildDetailSheet(
                    context: context, height: height, songInfo: songInfo),
                child: Text(
                  'View Details',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  // try {
                  //   var file = File(songInfo.filePath);
                  //   if (await file.exists()) {
                  //     await file.delete();
                  //     showToast(text: 'Song deleted');
                  //   }
                  // } catch (e) {
                  //   throw Exception(e);
                  // }
                },
                child: Text(
                  'Delete Song',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 4,
                indent: 30,
                endIndent: 30,
                color: Colors.grey.withOpacity(0.2),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () => Navigator.pop(context),
                child: Text(
                  'Cancel',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      });
}

void buildDetailSheet(
    {BuildContext context, double height, SongInfo songInfo}) {
  showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: height,
          margin: const EdgeInsets.only(top: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Text(
                'Details',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: [
                    Text(
                      'Name:',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Text(
                        songInfo.title,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      'Artist:',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      songInfo.artist,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      'Album:',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      songInfo.album,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      'Size:',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      songInfo.fileSize,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                      'Duration:',
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      songInfo.duration,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      });
}
