import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:dartssh2/dartssh2.dart';

class RoverSSHService {
  RoverSSHService.sharedInstance();

  static final _shared = RoverSSHService.sharedInstance();

  factory RoverSSHService() => _shared;

  SSHClient? _client;

  /// Sets up an SSH connection to the Rover's Raspberry Pi.
  ///
  /// Uses preconfigured credentials, which can be provided explicitly if required.
  Future<void> connect({
    String host = '192.168.8.69',
    int port = 22,
    String username = 'pi',
    String password = 'raspberry',
  }) async {
    try {
      final socket = await SSHSocket.connect(
        host,
        port,
        timeout: const Duration(seconds: 10),
      );
      final SSHClient client = SSHClient(
        socket,
        username: username,
        onPasswordRequest: () => password,
        onAuthenticated: () => log('SSH authenticated'),
      );
      _client = client;
      // } on SocketException {
      //   throw CouldNotConnectSshException();
    } catch (e) {
      rethrow;
    }
  }

  void closeConnection() {
    _client?.close;
    _client = null;
  }

  Future<void> goForward() async => await _client!.run('python car_forward.py');

  Future<void> goBackward() async =>
      await _client!.run('python car_backward.py');

  Future<void> goRight() async => await _client!.run('python car_stop.py');

  Future<void> goLeft() async => await _client!.run('python car_stop.py');

  Future<void> stopMoving() async => await _client!.run('python car_stop.py');

  Future<void> setupCamFeed() async {
    await _client!.run('pkill -f cam.py');
    await _client!.run('python cam.py');
  }

  Future<void> closeCamService() async {
    await _client!.run('pkill -f cam.py');
  }
}

enum MovementEvent {
  forward,
  backward,
  left,
  right,
}

extension Code on MovementEvent {
  String get script {
    switch (this) {
      case MovementEvent.forward:
        return 'python car_forward.py';
      case MovementEvent.backward:
        return 'python car_backward.py';
      case MovementEvent.right:
        return 'python car_stop.py';
      case MovementEvent.left:
        return 'python car_stop.py';
      default:
        return 'python car_stop.py';
    }
  }
}

class CouldNotConnectSshException implements Exception {}

class InvalidCredentialsSshException implements Exception {}
