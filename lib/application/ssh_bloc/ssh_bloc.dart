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

          // If connected, emit connected state
          emit(const SshConnectedState());

          await Future.delayed(const Duration(seconds: 3));
          unawaited(RoverSSHService().startMovementListener());
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
      (event, emit) {
        RoverSSHService().closeConnection();
        emit(const SshUninitializedState());
      },
    );

    // When any movement button is pressed
    on<SshKeyPressEvent>(
      (event, emit) {
        log('Key press: ${event.key.toString()}');
        RoverSSHService().startMovement(event.key);
      },
    );

    // When any movement button is released
    on<SshKeyReleaseEvent>(
      (event, emit) {
        log('Key release: ${event.key.toString()}');
        RoverSSHService().stopMovement(event.key);
      },
    );
  }
}
