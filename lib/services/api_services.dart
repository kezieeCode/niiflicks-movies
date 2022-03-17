import 'package:http/http.dart' as http;

class FetchSearch {
  String fetchurl = '';
  getMovies() async {
    var url = Uri.parse(fetchurl);
    var response = await http.get(url);
    if (response.statusCode == 200) {}
  }
}
