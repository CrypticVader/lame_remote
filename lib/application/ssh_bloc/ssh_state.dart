part of 'ssh_bloc.dart';

@immutable
abstract class SshState {
  final String? exception;
  final bool isLoading;

  const SshState(
    this.exception,
    this.isLoading,
  );
}

class SshConnectedState extends SshState {
  const SshConnectedState() : super(null, false);
}

class SshUninitializedState extends SshState {
  const SshUninitializedState({
    String? exception,
    bool isLoading = false,
  }) : super(exception, isLoading);
}
