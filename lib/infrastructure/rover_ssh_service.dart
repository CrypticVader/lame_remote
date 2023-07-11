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
  SSHSession? _shell;
  String? _hostAddress;

  /// Returns the IP Address of the host device.
  String? get hostAddress => _hostAddress;

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
      _shell = await _client!.shell();
      _hostAddress = host;
      // } on SocketException {
      //   throw CouldNotConnectSshException();
    } catch (e) {
      rethrow;
    }
  }

  void runCommandOnHost({required String command}) =>
      _shell!.write(Uint8List.fromList(utf8.encode('$command\n')));

  void killCurrentProcess() => _shell?.kill(SSHSignal.KILL);

  void closeConnection() {
    _shell?.kill(SSHSignal.KILL);
    _client?.close;
    _client = null;
    _shell = null;
    _hostAddress = null;
  }

  /// Command the rover to move in forward direction.
  void goForward() {
    _shell?.kill(SSHSignal.KILL);
    _shell!.write(Uint8List.fromList(utf8.encode('python car_forward.py\n')));
  }

  /// Command the rover to move in backward direction.
  void goBackward() {
    _shell?.kill(SSHSignal.KILL);
    _shell!.write(Uint8List.fromList(utf8.encode('python car_back.py\n')));
  }

  /// Command the rover to move in right direction.
  void goRight() {
    _shell?.kill(SSHSignal.KILL);
    _shell!.write(Uint8List.fromList(utf8.encode('python car_right.py\n')));
  }

  /// Command the rover to move in left direction.
  void goLeft() {
    _shell?.kill(SSHSignal.KILL);
    _shell!.write(Uint8List.fromList(utf8.encode('python car_left.py\n')));
  }

  /// Command the rover to stop moving.
  void stopMoving() {
    _shell?.kill(SSHSignal.KILL);

    _shell!.write(Uint8List.fromList(utf8.encode('pkill -f car_forward.py')));
    _shell!.write(Uint8List.fromList(utf8.encode('pkill -f car_back.py\n')));
    _shell!.write(Uint8List.fromList(utf8.encode('pkill -f car_left.py\n')));
    _shell!.write(Uint8List.fromList(utf8.encode('pkill -f car_right.py\n')));
  }

  /// Initialize the script for turning on the camera module & setting up the
  /// camera feed from the host.
  Future<void> runCamScript() async {
    await _client!.run('pkill -f cam.py');
    unawaited(_client!.run('python cam.py'));
  }

  /// Kill the camera script & shut down the camera module completely.
  Future<void> killCamScript() async {
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
