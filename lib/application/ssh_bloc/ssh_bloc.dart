import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
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

          // Delay to wait for authentication
          await Future.delayed(const Duration(seconds: 3));
          await RoverSSHService().setupCamFeed();
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
        await RoverSSHService().closeCamService();
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
            await RoverSSHService().goForward();
          case MovementEvent.backward:
            await RoverSSHService().goBackward();
          case MovementEvent.left:
            await RoverSSHService().goLeft();
          case MovementEvent.right:
            await RoverSSHService().goRight();
        }
      },
    );

    // When any movement button is released
    on<SshKeyReleaseEvent>(
      (event, emit) async {
        log('Key release: ${event.key.toString()}');
        await RoverSSHService().stopMoving();
      },
    );
  }
}
