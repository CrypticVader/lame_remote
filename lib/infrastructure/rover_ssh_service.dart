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

  final StreamController<MovementEvent> _movementStartEvent =
      StreamController<MovementEvent>();
  final StreamController<MovementEvent> _movementStopEvent =
      StreamController<MovementEvent>();

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
        printTrace: (p0) {
          log(p0 ?? '', name: 'SSH Host');
        },
        printDebug: (p0) {
          log(p0 ?? '', name: 'SSH Host');
        },
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

  void startMovement(MovementEvent direction) {
    _movementStartEvent.sink.add(direction);
  }

  void stopMovement(MovementEvent direction) {
    _movementStopEvent.sink.add(direction);
  }

  Future<void> startMovementListener() async {
    final shell = await _client!.execute('python car.py');
    log('Script run');
    await for (MovementEvent direction
        in _movementStartEvent.stream.asBroadcastStream()) {
      log('START MOVEMENT');
      shell.write(Uint8List.fromList(utf8.encode(direction.code)));
    }
  }
}

enum MovementEvent {
  forward,
  backward,
  left,
  right,
}

extension Code on MovementEvent {
  String get code {
    switch (this) {
      case MovementEvent.forward:
        return '\u001b[A';
      case MovementEvent.backward:
        return '\u001b[B\n';
      case MovementEvent.right:
        return '\u001b[C';
      case MovementEvent.left:
        return '\u001b[D';
      default:
        return '';
    }
  }
}

class CouldNotConnectSshException implements Exception {}

class InvalidCredentialsSshException implements Exception {}
