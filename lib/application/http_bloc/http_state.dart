part of 'http_bloc.dart';

@immutable
abstract class HttpState {}

class HttpUninitializedState extends HttpState {}

class HttpInitializedState extends HttpState {
  final Stream<Uint8List> Function() videoStream;

  HttpInitializedState({required this.videoStream});
}
