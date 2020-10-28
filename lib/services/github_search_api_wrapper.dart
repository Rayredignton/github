import 'dart:convert';

import 'package:githubApp/models/github_search_result.dart';
import 'package:githubApp/models/github_user.dart';
import 'package:http/http.dart' as http;

class GitHubSearchAPIWrapper {
  Uri searchUsernameUri(String username) => Uri(
        scheme: 'https',
        host: 'api.github.com',
        path: 'search/users',
        queryParameters: {'q': username},
      );

  final url = 'https://api.github.com/search/users?q=example';

  Future<GitHubSearchResult> searchUser(String username) async {
    final uri = searchUsernameUri(username);
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['items'];
      if (items?.isNotEmpty ?? false) {
        final users = items.map((item) => GitHubUser.fromJson(item)).toList();
        return GitHubSearchResult(users);
      }
      return GitHubSearchResult.error(GitHubAPIError.parseError);
    }
    if (response.statusCode == 403) {
      return GitHubSearchResult.error(GitHubAPIError.rateLimitExceeded);
    }
    print(
        'Request $uri failed\nResponse: ${response.statusCode} ${response.reasonPhrase}');
    return GitHubSearchResult.error(GitHubAPIError.unknownError);
  }

  // Future<GitHubSearchResult> users(String username) async {
  // try {
  //     // final response = await azurehttp.get(Paths.getRecipients);
  //     final response = await url;
      
  //     if (response['data'] != null && response['data']['records'] != null) {
  //       var records = response['data']['records'];
  //       if (records.length > 0) {
  //         var recievers = <Search>[];
  //         records.map((country) {
  //           recievers.add(Search.fromJson(country));
  //         }).toList();
  //         print(recievers);
  //         return SuccessResponse(recievers);
  //       }

  //       return SuccessResponse(<Record>[]);
  //     }
  //   } 
  // }
}
