import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';

part 'http_event.dart';
part 'http_state.dart';

class HTTPBloc extends Bloc<HttpEvent, HttpState> {
  HTTPBloc() : super(HttpUninitializedState()) {
    on<HttpEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
