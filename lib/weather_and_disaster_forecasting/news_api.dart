import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsApiService {
  // Your NewsAPI.org key
  static const String apiKey = 'a781e5e96f84488ba2acb75cc8f73472'; // Replace with your actual API key
  
  // Base URL for NewsAPI.org
  static const String topHeadlinesUrl = 'https://newsapi.org/v2/top-headlines';
  
  // Function to fetch top headlines for the Philippines
  Future<List<dynamic>> fetchTopHeadlines(us) async {
    final url = Uri.parse('$topHeadlinesUrl?country=US&apiKey=$apiKey');

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        Map<String, dynamic> json = jsonDecode(response.body);
        List<dynamic> articles = json['articles'];
        return articles; // Return the list of articles
      } else {
        throw Exception('Failed to load news');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}
