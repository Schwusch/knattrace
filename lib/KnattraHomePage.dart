import 'dart:async';

import 'package:flutter/material.dart';
import 'solutions.dart';
import 'Challenge.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';

class KnattraHomePage extends StatefulWidget {
  KnattraHomePage({Key key}) : super(key: key);

  // Your team name, change this to your own!
  final String TEAM_NAME = "knattra";
  final String PASSWORD = "password";

  @override
  _KnattraHomePageState createState() => new _KnattraHomePageState();
}

class _KnattraHomePageState extends State<KnattraHomePage> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Challenge currentChallenge;

  String id; // The initial id, change this if you want
  SearchBar searchBar;

  AppBar buildAppBar(BuildContext context) {
    return new AppBar(
        title: new Text('Knattra team "${widget.TEAM_NAME}"'),
        actions: [searchBar.getSearchAction(context)]);
  }

  _KnattraHomePageState() {
    searchBar = new SearchBar(
        hintText: "Challenge",
        inBar: false,
        setState: setState,
        onSubmitted: (String text) {
          setState(() {
            id = text.toLowerCase();
            _refreshIndicatorKey.currentState?.show();
          });
        },
        buildDefaultAppBar: buildAppBar);
  }

  showDescription(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Description"),
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  new Container(
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: new Text(currentChallenge?.description),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Future<Challenge> fetchStuff() {
    return Challenge
        .retrieve(id, widget.TEAM_NAME, widget.PASSWORD)
        .then((challenge) {
      setState(() {
        currentChallenge = challenge;
      });
    });
  }

  List<Widget> buildChallengeClues(List<Clue> clues) {
    return clues
        .map((clue) => new InkWell(
              onTap: () {
                showDialog<Null>(
                    context: context,
                    builder: (context) {
                      return new AlertDialog(
                        title: new Text("Clue Key"),
                        content: new Text(clue.key),
                      );
                    });
              },
              child: new Image.memory(
                clue.image,
                fit: BoxFit.fill,
              ),
            ))
        .toList();
  }

  FloatingActionButton buildFAB() {
    return currentChallenge == null
        ? null
        : new FloatingActionButton(
            onPressed: () {
              showDescription(context);
            },
            child: new Icon(Icons.info),
          );
  }

  @override
  Widget build(BuildContext context) {
    Challenge solvedChallenge = solveChallenge(currentChallenge, id);
    return new Scaffold(
      key: _scaffoldKey,
      appBar: searchBar.build(context),
      body: new RefreshIndicator(
          key: _refreshIndicatorKey,
          child: new Center(
              child: new ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              solvedChallenge == null
                  ? new Center(
                      child: new Image.asset("assets/jay.gif"),
                    )
                  : new Card(
                      elevation: 10.0,
                      child: new GridView.count(
                        padding: new EdgeInsets.all(5.0),
                        shrinkWrap: true,
                        crossAxisCount: solvedChallenge.gridColumns,
                        children: buildChallengeClues(solvedChallenge.clues),
                      ),
                    )
            ],
          )),
          onRefresh: () async {
            fetchStuff().catchError((e) {
              print("error ${e.message}");
              _scaffoldKey.currentState?.showSnackBar(new SnackBar(
                  duration: new Duration(seconds: 5),
                  content: new Text(e.message.toString())));
            });
          }),
      floatingActionButton: buildFAB(),
    );
  }
}
