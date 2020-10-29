import 'dart:convert';

import 'package:flutter/foundation.dart';

class GitHubUser {
  GitHubUser(
      {@required this.login,
      @required this.reposUrl,
      @required this.avatarUrl,
      @required this.score,
      @required this.htmlUrl});

  final String login;
  final String avatarUrl;
  final String htmlUrl;
  final String reposUrl;
  final dynamic score;

  factory GitHubUser.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    final login = json['login'];
    if (login != null) {
      final avatarUrl = json['avatar_url'];
      final htmlUrl = json['html_url'];
      final reposUrl = json['repos_url'];
      final score = json['score'];
      return GitHubUser(
          login: login,
          avatarUrl: avatarUrl,
          htmlUrl: htmlUrl,
          score: score,
          reposUrl: reposUrl);
    }
    return null;
  }

  /* Sample response data for a given user
  {
      "login": "bizz84",
      "id": 153167,
      "node_id": "MDQ6VXNlcjE1MzE2Nw==",
      "avatar_url": "https://avatars0.githubusercontent.com/u/153167?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/bizz84",
      "html_url": "https://github.com/bizz84",
      "followers_url": "https://api.github.com/users/bizz84/followers",
      "following_url": "https://api.github.com/users/bizz84/following{/other_user}",
      "gists_url": "https://api.github.com/users/bizz84/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/bizz84/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/bizz84/subscriptions",
      "organizations_url": "https://api.github.com/users/bizz84/orgs",
      "repos_url": "https://api.github.com/users/bizz84/repos",
      "events_url": "https://api.github.com/users/bizz84/events{/privacy}",
      "received_events_url": "https://api.github.com/users/bizz84/received_events",
      "type": "User",
      "site_admin": false,
      "score": 1.0
    }
    */

  @override
  String toString() => 'username: $login';
}
// To parse this JSON data, do
//
//     final search = searchFromJson(jsonString);

Search searchFromJson(String str) => Search.fromJson(json.decode(str));

String searchToJson(Search data) => json.encode(data.toJson());

class Search {
  Search({
    this.totalCount,
    this.incompleteResults,
    this.items,
  });

  dynamic totalCount;
  bool incompleteResults;
  List<Item> items;

  factory Search.fromJson(Map<String, dynamic> json) => Search(
        totalCount: json["total_count"],
        incompleteResults: json["incomplete_results"],
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total_count": totalCount,
        "incomplete_results": incompleteResults,
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  Item({
    this.login,
    this.id,
    this.nodeId,
    this.avatarUrl,
    this.gravatarId,
    this.url,
    this.htmlUrl,
    this.followersUrl,
    this.followingUrl,
    this.gistsUrl,
    this.starredUrl,
    this.subscriptionsUrl,
    this.organizationsUrl,
    this.reposUrl,
    this.eventsUrl,
    this.receivedEventsUrl,
    this.type,
    this.siteAdmin,
    this.score,
  });

  String login;
  int id;
  String nodeId;
  String avatarUrl;
  String gravatarId;
  String url;
  String htmlUrl;
  String followersUrl;
  String followingUrl;
  String gistsUrl;
  String starredUrl;
  String subscriptionsUrl;
  String organizationsUrl;
  String reposUrl;
  String eventsUrl;
  String receivedEventsUrl;
  Type type;
  bool siteAdmin;
  int score;

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        login: json["login"],
        id: json["id"],
        nodeId: json["node_id"],
        avatarUrl: json["avatar_url"],
        gravatarId: json["gravatar_id"],
        url: json["url"],
        htmlUrl: json["html_url"],
        followersUrl: json["followers_url"],
        followingUrl: json["following_url"],
        gistsUrl: json["gists_url"],
        starredUrl: json["starred_url"],
        subscriptionsUrl: json["subscriptions_url"],
        organizationsUrl: json["organizations_url"],
        reposUrl: json["repos_url"],
        eventsUrl: json["events_url"],
        receivedEventsUrl: json["received_events_url"],
        type: typeValues.map[json["type"]],
        siteAdmin: json["site_admin"],
        score: json["score"],
      );

  Map<String, dynamic> toJson() => {
        "login": login,
        "id": id,
        "node_id": nodeId,
        "avatar_url": avatarUrl,
        "gravatar_id": gravatarId,
        "url": url,
        "html_url": htmlUrl,
        "followers_url": followersUrl,
        "following_url": followingUrl,
        "gists_url": gistsUrl,
        "starred_url": starredUrl,
        "subscriptions_url": subscriptionsUrl,
        "organizations_url": organizationsUrl,
        "repos_url": reposUrl,
        "events_url": eventsUrl,
        "received_events_url": receivedEventsUrl,
        "type": typeValues.reverse[type],
        "site_admin": siteAdmin,
        "score": score,
      };
}

enum Type { USER, ORGANIZATION }

final typeValues =
    EnumValues({"Organization": Type.ORGANIZATION, "User": Type.USER});

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
