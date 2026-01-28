import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:agora_rtc_engine/agora_rtc_engine.dart';

import 'package:flutter/material.dart';
import 'package:mobile_info/models/index.dart';
import 'package:mobile_info/pref/pref.dart';
import 'package:mobile_info/utils/images_path.dart';

import 'package:permission_handler/permission_handler.dart';

class VideoPage extends StatefulWidget {
  final String channelName;
  final String invoice;
  const VideoPage({Key? key, required this.channelName, required this.invoice})
    : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;

  String appId = "";
  String? channel = "";
  int uid = 0;
  UsersModel? users;
  int? remoteUuid;
  bool localUserJoined = false;

  var isLoading = false;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  var token = '';

  getToken() async {
    setState(() {
      isLoading = true;
    });

    try {
      users = await Pref().getUsers();
      final response = await http.get(
        Uri.parse(
          'https://ibprservices.medtrans.id/agora/agora_token.php?channel=mobile_info_${users!.nomorPonsel}&phone=${users!.nomorPonsel}&bpr_id=${users!.bprId}',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          appId = data['app_id'];
          channel = data['channel'];
          uid = data['uid'];
          token = data['token'];
        });

        initAgora();
      }
    } catch (e) {
      print("Token error: $e");
    }
  }

  bool _joined = false;

  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    await _engine.enableVideo();
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (con, elapsed) async {
          await _engine.setupLocalVideo(VideoCanvas(uid: con.localUid));
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (con, remoteUid, elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (con, remoteUid, reason) {
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );

    await _engine.joinChannel(
      token: token,
      channelId: channel!,
      uid: uid,
      options: ChannelMediaOptions(),
    );
    ;
  }

  bool muted = false;
  GlobalKey<NavigatorState> _yourKey = GlobalKey<NavigatorState>();

  back() async {
    setState(() {
      _engine.leaveChannel();
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => back(),
      child: Scaffold(
        key: _yourKey,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: Platform.isIOS ? 32 : 30,
              color: Colors.transparent,
            ),
            Container(
              height: 50,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => back(),
                    icon: Icon(Icons.arrow_back),
                  ),
                  Text("CS Online"),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.black),
                child: Stack(
                  children: [
                    Center(child: _remoteVideo()),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        width: 100,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: _localUserJoined
                              ? _localPreview()
                              : CircularProgressIndicator(),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                back();
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red[900],
                                ),
                                child: Icon(
                                  Icons.call_end,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  muted = !muted;
                                });
                                _engine.muteLocalAudioStream(muted);
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.grey,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  muted ? Icons.mic_off : Icons.mic,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _engine.switchCamera();
                                });
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                padding: EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      blurRadius: 10,
                                      color: Colors.grey,
                                      offset: Offset(2, 2),
                                    ),
                                  ],
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: Icon(
                                  Icons.cameraswitch,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _localPreview() {
    if (!_localUserJoined) {
      return const CircularProgressIndicator();
    }
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine,
        canvas: VideoCanvas(uid: uid),
      ),
    );
  }

  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          connection: RtcConnection(channelId: channel!),
          canvas: VideoCanvas(uid: _remoteUid),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(ImageAssets.logo, height: 100),
        const SizedBox(height: 12),
        const Text(
          'Please wait...',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ],
    );
  }
}
