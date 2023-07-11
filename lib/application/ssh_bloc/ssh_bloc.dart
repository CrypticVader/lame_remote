import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:lame_remote/infrastructure/rover_http_service.dart';
import 'package:lame_remote/infrastructure/rover_ssh_service.dart';

part 'ssh_event.dart';

part 'ssh_state.dart';

class SshBloc extends Bloc<SshEvent, SshState> {
  SshBloc() : super(const SshUninitializedState()) {
    // attempt to connect to host
    on<SshConnectEvent>(
      (event, emit) async {
        try {
          // Set UI to loading
          emit(const SshUninitializedState(isLoading: true));

          // Attempt to connect
          await RoverSSHService().connect(
            host: event.host,
            port: event.port,
            username: event.username,
            password: event.password,
          );

          await RoverSSHService().runCamScript();
          // Delay to wait for script to start
          await Future.delayed(const Duration(seconds: 3));
          // If connected, emit connected state
          emit(const SshConnectedState());
        } on CouldNotConnectSshException {
          emit(const SshUninitializedState(
            exception:
                'Could not connect to the host. Please check the credentials, & ensure the remote & host are on the same subnet.',
          ));
          rethrow;
        } catch (e) {
          emit(SshUninitializedState(exception: e.toString()));
          rethrow;
        }
      },
    );

    // disconnect from host
    on<SshDisconnectEvent>(
      (event, emit) async {
        await RoverSSHService().killCamScript();
        RoverSSHService().closeConnection();
        emit(const SshUninitializedState());
      },
    );

    // When any movement button is pressed
    on<SshKeyPressEvent>(
      (event, emit) async {
        log('Key press: ${event.key.toString()}');
        switch (event.key) {
          case MovementEvent.forward:
            RoverSSHService().goForward();
          case MovementEvent.backward:
            RoverSSHService().goBackward();
          case MovementEvent.left:
            RoverSSHService().goLeft();
          case MovementEvent.right:
            RoverSSHService().goRight();
        }
      },
    );

    // When any movement button is released
    on<SshKeyReleaseEvent>(
      (event, emit) async {
        log('Key release: ${event.key.toString()}');
        RoverSSHService().stopMoving();
      },
    );

    // Used to run an arbitrary command on the host
    on<SshRunCommandEvent>(
      (event, emit) =>
          RoverSSHService().runCommandOnHost(command: event.command),
    );

    on<SshKillProcessEvent>(
      (event, emit) => RoverSSHService().killCurrentProcess(),
    );
  }

  @override
  void onTransition(Transition<SshEvent, SshState> transition) {
    log(transition.toString());
    super.onTransition(transition);
  }
}
