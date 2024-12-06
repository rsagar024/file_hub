import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:vap_uploader/core/enums/remote_enum/request_method.dart';
import 'package:vap_uploader/core/remote/rest_client.dart';

abstract class RestService extends RestClient {
  static const int _maxRetryAttempts = 3;

  Future<T> executeRequestAsync<T>(RestRequest restRequest, T Function(Map<String, dynamic>) fromJson, {int retryCount = 0}) async {
    try {
      Response<dynamic> response = await _sendRequest(restRequest);
      _handleResponse(response);
      final jsonResponse = response.data;

      if (jsonResponse is T) {
        return jsonResponse;
      } else if (jsonResponse is Map<String, dynamic>) {
        return fromJson(jsonResponse);
      } else {
        throw Exception('Invalid response format for type $T');
      }
    } on DioException catch (error) {
      debugPrint(error.toString());
      final content = error.response?.data?.toString() ?? '';
      final actionCode = _getActionCode(content);
      _handleDioError(error);
      rethrow;
    } catch (error) {
      debugPrint(error.toString());
      rethrow;
    }
  }

  Future<Response<dynamic>> _sendRequest(RestRequest restRequest) async {
    return dio.request<dynamic>(
      restRequest.path,
      data: restRequest.body,
      options: Options(
        method: _mapRequestMethodToString(restRequest.requestMethod),
        headers: restRequest.headers,
      ),
    );
  }

  String _mapRequestMethodToString(RequestMethod? method) {
    switch (method) {
      case RequestMethod.get:
        return 'GET';
      case RequestMethod.post:
        return 'POST';
      case RequestMethod.put:
        return 'PUT';
      case RequestMethod.delete:
        return 'DELETE';
      default:
        throw Exception("Unknown Method");
    }
  }

  void _handleResponse(Response<dynamic> response) {
    final statusCode = response.statusCode;
    if (statusCode == null) {
      throw Exception("No status code found");
    }
    if (statusCode == 200) return;
    if (statusCode == 204) throw Exception("No content returned");
    if (statusCode == 401) throw Exception("No header found");
    if (statusCode == 403) throw Exception("User does not have permission");
    if (statusCode == 404) throw Exception("Resource not found");
    if (statusCode >= 500) throw Exception("Server Error");
  }

  int _getActionCode(String content) {
    try {
      final json = content.isNotEmpty ? content : '{}';
      final jsonObject = jsonDecode(json);
      return jsonObject['actionCode'] as int ?? 100;
    } catch (e) {
      debugPrint(e.toString());
      return 100;
    }
  }

  void _handleDioError(DioException error) {
    final statusCode = error.response?.statusCode;
    if (statusCode == null) {
      throw Exception('No status code found');
    }
    if (statusCode == 401) throw Exception(error.response!.toString());
    if (statusCode == 403) throw Exception("User does not have permission");
    if (statusCode == 404) throw Exception('Resource not found');
    if (statusCode == 204) throw Exception('No content returned');
    if (statusCode >= 500) {
      final errorMessage = error.response?.data['messages'][0] ?? error.message;
      throw errorMessage;
    }
    throw Exception(error.message);
  }

  RestRequest createGetRequest(String resource, {dynamic body}) => RestRequest(resource, body, method: RequestMethod.get);

  RestRequest createPostRequest(String resource, {dynamic body}) => RestRequest(resource, body, method: RequestMethod.post);

  RestRequest createPutRequest(String resource, {dynamic body}) => RestRequest(resource, body, method: RequestMethod.put);

  RestRequest createDeleteRequest(String resource, {dynamic body}) => RestRequest(resource, body, method: RequestMethod.delete);
}
