import 'package:dio/dio.dart';
import 'package:file_hub/core/enums/remote_enum/request_method.dart';

class RestClient {
  Dio dio = Dio();

  RestClient() {
    if (dio.options.baseUrl.isEmpty) {
      dio.options.baseUrl = 'https://api.telegram.org/bot';
    }
  }
}

class RestRequest extends Options {
  final String path;
  final dynamic body;
  RequestMethod? requestMethod = RequestMethod.get;

  RestRequest(this.path, this.body, {RequestMethod? method, dynamic}) {
    requestMethod = method;
  }

  setRequestHeaders(Map<String, dynamic>? headers) {
    super.headers = headers;
  }
}
