import 'package:http/http.dart' as http;

Future<http.Response> httpGetRequest({required String url}) async {
  final http.Response response = await http.get(Uri.parse(url));
  return response;
}
