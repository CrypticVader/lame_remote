part of 'http_bloc.dart';

@immutable
abstract class HttpEvent {}

class HttpConnectEvent extends HttpEvent {}

class HttpDisconnectEvent extends HttpEvent {}

class HttpRetryEvent extends HttpEvent {}
