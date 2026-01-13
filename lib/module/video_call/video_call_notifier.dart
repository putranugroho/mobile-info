import 'dart:convert';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class VideoCallNotifier extends ChangeNotifier {
  final BuildContext context;
  final String channelName;
  VideoCallNotifier(this.context, this.channelName) {
    getToken();
  }

  String appId = "";
  String? channel = "";
  int uid = 0;
  late RtcEngine _engine;
  int? remoteUuid;
  bool localUserJoined = false;

  var isLoading = false;

  var token = '';

  getToken() async {
    try {
      final response = await http.get(Uri.parse('https://tesseract.metimes.id/agora/agora_token.php?channel=cs_ai'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        appId = data['app_id'];
        channel = data['channel'];
        uid = data['uid'];
        token = data['token'];
        notifyListeners();
        initAgora();
      }
    } catch (e) {
      print("Token error: $e");
    }
  }

  bool _joined = false;
  int? _remoteUid;
  bool _localUserJoined = false;
  Future<void> initAgora() async {
    // retrieve permissions
    await [Permission.microphone, Permission.camera].request();

    //create the engine
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: appId, channelProfile: ChannelProfileType.channelProfileCommunication));

    await _engine.enableVideo();
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (con, elapsed) async {
          await _engine.setupLocalVideo(VideoCanvas(uid: con.localUid));
          _localUserJoined = true;
          notifyListeners();
        },
        onUserJoined: (con, remoteUid, elapsed) {
          _remoteUid = remoteUid;
          notifyListeners();
        },
        onUserOffline: (con, remoteUid, reason) {
          _remoteUid = null;
          notifyListeners();
        },
      ),
    );

    await _engine.joinChannel(token: token, channelId: channel!, uid: uid, options: ChannelMediaOptions());
    ;
  }
}
