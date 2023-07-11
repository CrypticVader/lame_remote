part of 'ssh_bloc.dart';

@immutable
abstract class SshEvent {}

class SshConnectEvent extends SshEvent {
  final String host;
  final int port;
  final String username;
  final String password;

  SshConnectEvent({
    required this.host,
    required this.port,
    required this.username,
    required this.password,
  });
}

class SshDisconnectEvent extends SshEvent {}

class SshKeyPressEvent extends SshEvent {
  final MovementEvent key;

  SshKeyPressEvent({required this.key});
}

class SshKeyReleaseEvent extends SshEvent {
  final MovementEvent key;

  SshKeyReleaseEvent({required this.key});
}

class SshRunCommandEvent extends SshEvent {
  final String command;

  SshRunCommandEvent({required this.command});
}

class SshKillProcessEvent extends SshEvent {}
