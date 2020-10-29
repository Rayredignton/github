import 'package:flutter/material.dart';
import 'package:githubApp/ui/searchPage.dart';
import 'package:githubApp/core/models/github_user.dart';
import 'package:githubApp/core/services/github_search_api_wrapper.dart';
import 'package:githubApp/core/services/github_search_service.dart';



class Home extends StatefulWidget {
  @override
  _StateHome createState() => _StateHome();
}

class _StateHome extends State<Home> {
void _showSearch(BuildContext context) async {
    final searchService =
        GitHubSearchService(apiWrapper: GitHubSearchAPIWrapper());
    final user = await showSearch<GitHubUser>(
      context: context,
      delegate: GitHubSearchDelegate(searchService),
    );
    searchService.dispose();
    print(user);
  }


 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.black,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
               SizedBox(height: MediaQuery.of(context).size.height * 0.38,),
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage('https://icon-library.net/images/github-icon-png/github-icon-png-29.jpg'),

                    ),

                  ),
                ),
              
                SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                MaterialButton(
                  padding: EdgeInsets.all(20),
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Align(
                    child: 
                      Text('Search Github Users', style: TextStyle(color: Colors.white,fontSize: 18),),
                  ), 
                   onPressed: () => _showSearch(context),
                  
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}