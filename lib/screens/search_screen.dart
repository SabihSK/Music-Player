import 'dart:io';
import 'package:flutter/services.dart';

import 'package:flutter/material.dart';

class SearchScreen extends SearchDelegate<String> {
  final List<File> files;

  SearchScreen({@required this.files});

  final suggestions = [
    'abc',
    'def',
    'ghi',
  ];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  List<File> searchedList = new List<File>();

  @override
  Widget buildSuggestions(BuildContext context) {
    searchedList =
        files.where((p) => p.path.split('/').last.startsWith(query)).toList();
    return ListView.builder(
        itemCount: searchedList.length,
        itemBuilder: (context, index) {
          return query.isEmpty
              ? Text('')
              : ListTile(
                  onTap: () async {
                    // showResults(context);
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                    await Future.delayed(Duration(milliseconds: 500));

                    try {
                      // Navigator.of(context).push(
                      //   MaterialPageRoute(
                      //       builder: (context) => ViewerScreen(
                      //             state: true,
                      //             pathPDF: file.path,
                      //           )
                      //           ),
                      // );
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  leading: Image.asset(
                    'assets/icon.png',
                    height: 30,
                  ),
                  title: Align(
                    alignment: Alignment(-1.3, 0),
                    child: RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: searchedList[index]
                                .path
                                .split('/')
                                .last
                                .substring(0, query.length),
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 18),
                          ),
                          TextSpan(
                            text: searchedList[index]
                                .path
                                .split('/')
                                .last
                                .substring(query.length),
                            style: TextStyle(color: Colors.grey, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return Container();
//    throw UnimplementedError();
  }
}
