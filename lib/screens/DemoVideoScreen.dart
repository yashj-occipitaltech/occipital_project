import 'package:flutter/material.dart';
import 'package:occipital_tech/util/ApiClient.dart';
import 'package:occipital_tech/util/AppDrawer.dart';
import 'package:rxdart/rxdart.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class DemoVideoScreen extends StatefulWidget {
  @override
  _DemoVideoScreenState createState() => _DemoVideoScreenState();
}

class _DemoVideoScreenState extends State<DemoVideoScreen> {
  YoutubePlayerController _controller;
  BehaviorSubject<String> linkUrl = BehaviorSubject();
  VoidCallback listener;

  @override
  void initState() {
    super.initState();
    getVideoLink();
  }


  getVideoLink() async {
    final response = await ApiClient.getVideoLink();
    linkUrl.add(response.toString());
  }

  @override
  void dispose() {
    super.dispose();
    linkUrl.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
            
        iconTheme:  IconThemeData(color: Colors.black),
      elevation: 0.0,
      title: Text('Demo Video',style: TextStyle(color: Colors.black),),
      centerTitle: true,
      backgroundColor: Colors.white,
      ),
      body: StreamBuilder<Object>(
          stream: linkUrl,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return YoutubePlayer(

                context: context,
                videoId: YoutubePlayer.convertUrlToId(linkUrl.value),
                flags: YoutubePlayerFlags(
                  autoPlay: true,
                  showVideoProgressIndicator: true,
                  loop: true
                ),
                

                onPlayerInitialized: (controller) {
                  _controller = controller;
                  _controller.addListener(listener);
                },
              );
            }

            return Center(
              child: CircularProgressIndicator(),
            );
          }),
     
    );
  }
}
