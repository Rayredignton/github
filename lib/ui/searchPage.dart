import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:githubApp/core/models/github_search_result.dart';
import 'package:githubApp/core/models/github_user.dart';
import 'package:githubApp/core/services/github_search_service.dart';
import 'package:url_launcher/url_launcher.dart';

class GitHubSearchDelegate extends SearchDelegate<GitHubUser> {
  GitHubSearchDelegate(this.searchService);
  final GitHubSearchService searchService;

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      tooltip: 'Back',
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    // search-as-you-type if enabled
    searchService.searchUser(query);
    return buildMatchingSuggestions(context);
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return Container();
    }
    // always search if submitted
    searchService.searchUser(query);
    return buildMatchingSuggestions(context);
  }

  Widget buildMatchingSuggestions(BuildContext context) {
    final Map<GitHubAPIError, String> errorMessages = {
      GitHubAPIError.parseError: 'Error reading data from the API',
      GitHubAPIError.rateLimitExceeded: 'Rate limit exceeded',
      GitHubAPIError.unknownError: 'Unknown error',
    };
    // then return results
    return StreamBuilder<GitHubSearchResult>(
      stream: searchService.results,
      builder: (context, AsyncSnapshot<GitHubSearchResult> snapshot) {
        if (snapshot.hasData) {
          final GitHubSearchResult result = snapshot.data;
          return result.when(
            (users) => PageView.builder(
              
              physics: BouncingScrollPhysics(),
              itemCount: users.length,
              scrollDirection: Axis.vertical,
              // gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              //   maxCrossAxisExtent: 200,
              //   crossAxisSpacing: 10,
              //   mainAxisSpacing: 10,
              //   childAspectRatio: 0.8,
              // ),
              itemBuilder: (context, index) {
                return GitHubUserSearchResultTile(
                  user: users[index],
                  onSelected: (value) => close(context, value),
                );
              },
            ),
            error: (error) => SearchPlaceholder(title: errorMessages[error]),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return query.isEmpty
        ? []
        : <Widget>[
            IconButton(
              tooltip: 'Clear',
              icon: const Icon(Icons.clear),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          ];
  }
}

class GitHubUserSearchResultTile extends StatelessWidget {
  GitHubUserSearchResultTile(
      {@required this.user, @required this.onSelected, this.search});

  final GitHubUser user;
  final Search search;
  final ValueChanged<GitHubUser> onSelected;
  List<GitHubSearchResult> results=[];
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
      onTap: () => _launchURL(user.htmlUrl),
      child: Column(
        children: [
            
          ClipPath(
            clipper: ShapeBorderClipper(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(90)),
              ),
            ),
            child: Container(
              child: Image.network(
                user.avatarUrl,
              ),
            ),
          ),
          SizedBox(height: 35.0),
          Text(
            user.login,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w700,
            )
          ),
          
          SizedBox(height: 28.0),
          Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
                  Icon(Icons.star),
              Text(
                "star ${user.score}",
                style: TextStyle(
                  fontSize:30 ,
                  fontWeight: FontWeight.w600,
                )
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SearchPlaceholder extends StatelessWidget {
  const SearchPlaceholder({@required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Text(
        title,
        style: theme.textTheme.headline5,
        textAlign: TextAlign.center,
      ),
    );
  }
}
