import 'package:http_interceptor/http_interceptor.dart';

class LoggingInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    print('Request: { Url: ${data.baseUrl}, Headers: ${data.headers} }');
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    print('Response: { StatusCode: ${data.statusCode}, Body: ${data.body} }');
    return data;
  }
}
