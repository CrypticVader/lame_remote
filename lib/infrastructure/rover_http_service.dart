import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:lame_remote/infrastructure/rover_ssh_service.dart';
import 'package:rxdart/rxdart.dart';

class RoverHTTPService {
  factory RoverHTTPService() => _shared;

  RoverHTTPService._sharedInstance();

  static final _shared = RoverHTTPService._sharedInstance();

  final Dio _dio = Dio();

  /// Makes an [HTTP] get request to the host device, & attempts to return a
  /// stream of the response body.
  Future<Stream<Uint8List>> _getResponseStream() async {
    final hostAddress = RoverSSHService().hostAddress;
    final Response<ResponseBody> response;
    if (hostAddress == null) {
      throw CouldNotFindHostAddressHttpException();
    } else {
      try {
        response = await _dio.get(
          'http://$hostAddress:8000/stream.mjpg',
          options: Options(responseType: ResponseType.stream),
        );
      } on DioException {
        throw CouldNotConnectHttpException();
      } catch (e) {
        rethrow;
      }
      if (response.statusCode == null || response.statusCode != 200) {
        throw CouldNotConnectHttpException();
      } else {
        return response.data!.stream;
      }
    }
  }

  Stream<Uint8List> getVideoStream() async* {
    final responseStream = await _getResponseStream();

    var startIndex = -1;
    var endIndex = -1;
    List<int> buf = [];

    await for (List<int> data in responseStream) {
      for (var i = 0; i < data.length - 1; i++) {
        if (data[i] == 0xff && data[i + 1] == 0xd8) {
          startIndex = buf.length + i;
        }

        if (data[i] == 0xff && data[i + 1] == 0xd9) {
          endIndex = buf.length + i;
        }
      }

      buf.addAll(data);

      if (startIndex != -1 && endIndex != -1) {
        final imgBuf = List<int>.from(buf.getRange(startIndex, endIndex + 2));
        yield Uint8List.fromList(imgBuf);
      }

      startIndex = endIndex = -1;
      buf = [];
    }
  }
}

class CouldNotConnectHttpException implements Exception {}

class CouldNotFindHostAddressHttpException implements Exception {}
