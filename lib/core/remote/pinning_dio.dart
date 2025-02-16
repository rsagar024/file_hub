import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class PinningDio {
  static final Map<String, String> _pinnedCertificates = {
    'api.telegram.org': 'w4Rr8kuek8pkJ0wOxnwezF4CT/ys0tdAGTUOgf5UauQ=',
  };

  static Dio createDio() {
    final options = BaseOptions(
      baseUrl: 'https://api.telegram.org',
      // connectTimeout: const Duration(seconds: 3),
      // sendTimeout: const Duration(minutes: 5),
      // receiveTimeout: const Duration(minutes: 5),
    );

    final dio = Dio(options);

    dio.httpClientAdapter = IOHttpClientAdapter(
      createHttpClient: () {
        final context = SecurityContext(); // SecurityContext(withTrustedRoots: false)
        final client = HttpClient(context: context)
          ..badCertificateCallback = (X509Certificate cert, String host, int port) {
            final certHash = base64.encode(sha256.convert(cert.der).bytes);
            final pinnedHash = _pinnedCertificates[host];
            if (pinnedHash == null) {
              return true;
            }
            return certHash == pinnedHash;
          };
        return client;
      },
    );
    return dio;
  }
}
