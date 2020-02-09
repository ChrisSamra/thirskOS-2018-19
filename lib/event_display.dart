import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
//import 'package:path_provider/path_provider.dart';
import 'package:date_format/date_format.dart';
import 'dart:async';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';
//import 'dart:io';
//import "html_parser.dart";

part 'event_display.g.dart';

@JsonSerializable()
class OnePostDate{
  String date;
  OnePostDate({this.date});
  factory OnePostDate.fromJson(Map<String, dynamic> json) => _$OnePostDateFromJson(json);
  factory OnePostDate.directFromJson(String jsonVal){
    Map tempMap = json.decode(jsonVal);
    return OnePostDate.fromJson(tempMap);
  }

  Map<String, dynamic> toJson() => _$OnePostDateToJson(this);
}

@JsonSerializable()
class OnePostData
{
  @JsonKey(name:"Post_id")
  String postId;
  String name;
  String uid;
  //@JsonKey(name:"Title")
  String title;
  //String email;
  @JsonKey(name:"content")
  String postContent;
  //@JsonKey(name:"date")
  String postDate;
  OnePostData({this.postId,this.name,this.uid,this.title,this.postContent,this.postDate});
  factory OnePostData.fromJson(Map<String, dynamic> json) => _$OnePostDataFromJson(json);
  factory OnePostData.directFromJson(String jsonVal){
    Map tempMap = json.decode(jsonVal);
    return OnePostData.fromJson(tempMap);
  }

  Map<String, dynamic> toJson() => _$OnePostDataToJson(this);


}
class OneEventPost extends StatelessWidget{
  OneEventPost({Key key,@required this.postJson}) : super(key:key);
  final String postJson;
  @override
  Widget build(BuildContext context) {

    OnePostData postData;
    final String defaultJson = '{"Post_id":"18","title":"asdasdasd","content":"asdasdasdasdasdasdasdvsdgsdfgg","postDate":"11-05-2019 (02:17:31)","name":"stamnostomp","uid":"1"}';
    try {
      if (postJson == '') {
        postData = OnePostData.directFromJson(defaultJson);
      } else {
        postData = OnePostData.directFromJson(postJson);
      }
    } catch (e) {
      print("this is an error. that's sad");
      return Container(
        child: Column(
          children: <Widget>[
            Text("Error", style: TextStyle(fontSize: 18.0, fontFamily: 'ROCK', color: Colors.white),),
            Text("Unacceptable json format. Press 'F' to pay respect.", style: TextStyle(fontSize: 12, fontFamily: 'ROCK', color: Colors.white),),
            Text(""),
            Row(
              children: <Widget>[
                Text("RIP this post"),
                Text("2019~2019")
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        color: Color(0xff5762db),
        margin: new EdgeInsets.all(10.0),
        padding: new EdgeInsets.all(10.0),

      );
    }
    try {
      return Container(


        child: Column(
          children: <Widget>[
            Text(postData.title, style: TextStyle(fontSize: 18.0, fontFamily: 'ROCK', color: Colors.white),),

            Linkify(
              //takes post content searches for links and makes them clickable
              onOpen: (link) async {
                if (await canLaunch(link.url)) {
                  await launch(link.url);
                } else {
                  throw 'Could not launch $link';
                }
              },

              text: postData.postContent.replaceAll('#039;', '\''), //replaces html code for ' with ' character
              style: TextStyle(fontSize: 12, fontFamily: 'ROCK', color: Colors.white),
              linkStyle: TextStyle(color: Colors.black),
            ),

            Text(""),
            Row(
              children: <Widget>[
                Text(""),
                //Text(postData.name, style: TextStyle(fontSize: 12, color: Colors.white),), not working properly (spits out "Array") (probably a backend issue
                Text(postData.postDate, style: TextStyle(fontSize: 12, color: Colors.white),),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        color: Color(0xff5762db),
        margin: new EdgeInsets.all(10.0),
        padding: new EdgeInsets.all(10.0),


      );

    } catch (e) {
      return Container(/*
        child: Column(
          children: <Widget>[
            Text("Error", style: TextStyle(fontSize: 18.0),),
            Text("Unacceptable json format. Press 'F' to pay respect."),
            Row(
              children: <Widget>[
                Text("RIP this post"),
                Text("2019~2019")
              ],
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        color: Colors.deepPurple.shade500,
        margin: new EdgeInsets.all(10.0),
        padding: new EdgeInsets.all(10.0),*/
      );
    }
  }
/*
  @override
  _OneEventPostState createState() {

    print(postJson);
    return _OneEventPostState();
  }*/
}
/*
class _OneEventPostState extends State<OneEventPost>{
  OnePostData postData;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(postData.title,style: TextStyle(fontSize: 18.0),),
          Text(postData.postContent),
          Row(
            children: <Widget>[
              Text(postData.name),
              Text(postData.postDate)
            ],
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.start,
      ),
      color: Colors.deepPurple.shade500,
      margin: new EdgeInsets.all(10.0),
      padding: new EdgeInsets.all(10.0),
    );
  }
  @override
  void initState() {

    super.initState();

    setState(() {
      print(widget.postJson);
      if(widget.postJson != '') {
        postData = OnePostData.directFromJson(widget.postJson);
      } else {
        postData = OnePostData.directFromJson(defaultJson);
      }
    });

  }
}
*/
class AllEventPosts extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {

    return _AllEventPostsState();
  }
}
class _AllEventPostsState extends State<AllEventPosts>{
  List<String> listOfPosts = [
    '{"name": "John S","email": "john@smith.net","Title": "Clickbait","post": "Literal shitpost that does nothing.","date": "19-04-19 10:10:46pm"}',
    '{"name": "Jane S","email": "jane@smith.net","Title": "Clickbait: Second Coming\\nYeye","post": "Another shitpost that does nothing.","date": "19-04-19 10:10:47pm"}',

  ];
  @override
  Widget build(BuildContext context) {

    List<Widget> convertedData = [];
    /*for(int i = 0; i < listOfPosts.length; i++){
      convertedData.add(OneEventPost(postJson: listOfPosts[i]));

    }*/
    debugPrint(convertedData.length.toString());
    //return OneEventPost(postJson: '{"name": "John S","email": "john@smith.net","Title": "Clickbait Title","post": "Literal shitpost that does nothing.","date": "19-04-19 10:10:46pm"}');

    return Container(
        child: FutureBuilder<List<String>>(
          future: fetchEventPosts("http://rths.ca/thirskOS/Posts.php"),
          builder: (context,snapshot){
            if(snapshot.hasData) {
              //print(snapshot.data);
              //print(LinkParser.getListOfLinks(snapshot.data));
              for(int i = 0; i < snapshot.data.length; i++){
                convertedData.add(OneEventPost(postJson: snapshot.data[i]));
              }
              return Column(
                children: convertedData,

                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              );
            }
            return Column(
              children: <Widget>[
                CircularProgressIndicator(),
                Text('New Posts Coming Soon...', style: TextStyle(color: Colors.white),),
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            );
          },
        )

    );
  }
}
Future<List<String>> fetchEventPosts(String url) async{
  final response = await http.get(url);

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON7

    //var listOfLinks = LinkParser.getListOfLinks(response.body);
    var listOfPosts = json.decode(response.body);
    List<String> listOfReturnData = [];
    for(int i = 0; i < listOfPosts.length; i++){
      listOfReturnData.add(json.encode(listOfPosts[i]));
      print(listOfReturnData[i]);
    }
    return listOfReturnData;
    //return '[{"menuID":"262","soup":"Cream of Broccoli","soupCost":"2.00","entree":"Steamed Hams\' Sandwich","entreeCost":"5.00","starch1":"","starch1Cost":"0.00","starch2":"","starch2Cost":"0.00","dessert":"Creme Brulee Cake","dessertCost":"2.00","menuDate":"2018-03-12"},{"menuID":"263","soup":"Vegetable Soup","soupCost":"2.00","entree":"Stuffed Peppers (Meat or Quinoa Stuffing) with Garden Salad","entreeCost":"5.00","starch1":"","starch1Cost":"0.00","starch2":"","starch2Cost":"0.00","dessert":"Squares","dessertCost":"0.00","menuDate":"2018-03-13"},{"menuID":"264","soup":"yes :)","soupCost":"2.00","entree":"Beef Burger and\/or Quinoa Burger with Baked Fries or Salad","entreeCost":"5.00","starch1":"","starch1Cost":"0.00","starch2":"","starch2Cost":"0.00","dessert":"Pie Daaayyyyyy!","dessertCost":"2.50","menuDate":"2018-03-14"},{"menuID":"265","soup":"For Sure...","soupCost":"2.00","entree":"Butter Chicken ","entreeCost":"2.00","starch1":"Basmati Rice","starch1Cost":"1.00","starch2":"fresh steamed vegetables","starch2Cost":"1.00","dessert":"Black Forest Cake","dessertCost":"2.50","menuDate":"2018-03-15"}]';
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}