
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:date_format/date_format.dart';
import 'dart:async';
import 'dart:io';
import 'event_display.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_linkify/flutter_linkify.dart';// for later use with video links
//imported packages etc.

part 'main.g.dart'; // link to generated dart code (ask Roger)

const ctsURL ="";//placeholder for button link for cts page

const foconURL = "https://drive.google.com/file/d/1I8bsvMj5nDtgVdgIeoIKi6iy3YJ2qmKa/view?usp=sharing";
//!REPLACE LINK ONCE PDF LINK OR WEB LINK TO CONNECT & FOCUS ROOMS FOR 2019/2020 IS OBTAINED^^^^

const esURL = 'http://school.cbe.ab.ca/School/Repository/SBAttachments/87b0d243-5782-4986-8dd3-0405f8f12963_ExamScheduleJune2019.pdf';
//!REPLACE LINK ONCE NEW EXAM SCHEDULE IS POSTED FOR JAN 2020, ALSO UNCOMMENT THE EXAM SCHEDULE BUTTON ON THE EXAM RESOURCES PAGE

const dockURL = "http://school.cbe.ab.ca/school/robertthirsk/culture-environment/school-spirit/merchandise/pages/default.aspx";
const clubURL = "http://school.cbe.ab.ca/school/robertthirsk/extracurricular/clubs/pages/default.aspx";
const staffURL = "http://school.cbe.ab.ca/school/robertthirsk/about-us/contact/staff/pages/default.aspx";
const scholarURL = "http://school.cbe.ab.ca/school/robertthirsk/teaching-learning/exams-graduation/scholarships/pages/default.aspx";
const connectURL = "https://drive.google.com/drive/folders/1kWBTP-O2TFhrcSCotdCC_zcxWSNNJ3IK?usp=sharing";
const edURL = "http://edventure.rths.ca/";
const faURL = "http://school.cbe.ab.ca/school/robertthirsk/teaching-learning/classes-departments/fine-arts/pages/default.aspx";
const gradURL = 'http://school.cbe.ab.ca/school/robertthirsk/teaching-learning/exams-graduation/graduation/pages/default.aspx';
const psURL = 'http://school.cbe.ab.ca/school/robertthirsk/about-us/news-centre/_layouts/ci/post.aspx?oaid=aa6fd0ba-b1b6-4896-9912-b49bb6f2cd57&oact=20001';
const chssURL = 'http://calgaryhighschoolsports.ca/divisions.php?lang=1';
const coURL = 'http://school.cbe.ab.ca/school/robertthirsk/about-us/news-centre/_layouts/ci/post.aspx?oaid=81469bbc-eec0-4fa8-8cf1-815ac261fbe7&oact=20001';
const adpURL = 'http://www.diplomaprep.com/';
const fgcURL = 'https://rogerhub.com/final-grade-calculator/';
const expcURL = 'https://www.alberta.ca/writing-diploma-exams.aspx?utm_source=redirector#toc-2';
const qappURL = 'https://questaplus.alberta.ca/PracticeMain.html#';

// constants that hold all the resource links within thirskOS primarily on the thrive page, this is modular in the sense that it's easy to swap out links
// and add new ones when needed with little programing knowledge



///Don't steal my api key
const String APP_API_KEY = "AIzaSyCE5gLyCtDW6dzAkPBowBdeXqAy5iw7ebY";


void main() => runApp(MyApp());

////////////////////////////////////////////////////////////////////////////
//This annotation is important for the code generation to generate code for the class
@JsonSerializable()
///A class that stores a day's menu
class OneDayMenu {
  String menuID;
  String soup;
  String soupCost;
  String entree;
  String entreeCost;
  //This annotation can be used if the json key is different from the variable name
  @JsonKey(name:'starch1')
  String starch;
  @JsonKey(name:'starch1Cost')
  String starchCost;
  @JsonKey(name:'starch2')
  String veggie;
  @JsonKey(name:'starch2Cost')
  String veggieCost;
  String dessert;
  String dessertCost;
  String menuDate;
  OneDayMenu({this.menuID,this.soup,this.soupCost,this.entree,this.entreeCost,this.starch,this.starchCost,this.veggie,this.veggieCost,this.dessert,this.dessertCost,this.menuDate});


  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson` constructor.
  /// The constructor is named after the source class, in this case User.
  factory OneDayMenu.fromJson(Map<String, dynamic> json) => _$OneDayMenuFromJson(json);
  ///Construct a OneDayMenu object directly from json string
  factory OneDayMenu.directFromJson(String jsonVal){
    Map tempMap = json.decode(jsonVal);
    return OneDayMenu.fromJson(tempMap);
  }

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$OneDayMenuToJson(this);
}
///A class that stores a list of menus, usually a week
class WeekMenu{
  List<OneDayMenu> thisWeeksMenu;
  WeekMenu({this.thisWeeksMenu});
  //Since the json string is a list, we have to build a new constructor
  factory WeekMenu.fromJson(List<dynamic> json){
    List<OneDayMenu> newList = new List<OneDayMenu>();
    newList = json.map((i)=>OneDayMenu.fromJson(i)).toList();
    return WeekMenu(thisWeeksMenu: newList);
  }
  factory WeekMenu.directFromJson(String jsonVal){
    List<dynamic> tempMap = json.decode(jsonVal);
    //print(tempMap);
    return WeekMenu.fromJson(tempMap);
  }

}
///Returns the json string from the site if retrieved successfully.
///
Future<String> fetchMenu() async {
  final response = await http.get('http://rths.ca/rthsJSONmenu.php');

  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON
    return response.body;
    //return '[{"menuID":"262","soup":"Cream of Broccoli","soupCost":"2.00","entree":"Steamed Hams\' Sandwich","entreeCost":"5.00","starch1":"","starch1Cost":"0.00","starch2":"","starch2Cost":"0.00","dessert":"Creme Brulee Cake","dessertCost":"2.00","menuDate":"2018-03-12"},{"menuID":"263","soup":"Vegetable Soup","soupCost":"2.00","entree":"Stuffed Peppers (Meat or Quinoa Stuffing) with Garden Salad","entreeCost":"5.00","starch1":"","starch1Cost":"0.00","starch2":"","starch2Cost":"0.00","dessert":"Squares","dessertCost":"0.00","menuDate":"2018-03-13"},{"menuID":"264","soup":"yes :)","soupCost":"2.00","entree":"Beef Burger and\/or Quinoa Burger with Baked Fries or Salad","entreeCost":"5.00","starch1":"","starch1Cost":"0.00","starch2":"","starch2Cost":"0.00","dessert":"Pie Daaayyyyyy!","dessertCost":"2.50","menuDate":"2018-03-14"},{"menuID":"265","soup":"For Sure...","soupCost":"2.00","entree":"Butter Chicken ","entreeCost":"2.00","starch1":"Basmati Rice","starch1Cost":"1.00","starch2":"fresh steamed vegetables","starch2Cost":"1.00","dessert":"Black Forest Cake","dessertCost":"2.50","menuDate":"2018-03-15"}]';
  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

///Builds the layout for the input [displayMenu]
///
List<Widget> displayData(WeekMenu displayMenu){
  List<Widget> entryList = new List<Widget>();
  //displayMenu = WeekMenu.directFromJson(jsonRetrieved);
  for(OneDayMenu dayEntry in displayMenu.thisWeeksMenu){
    entryList.add(Container(
      child: Column(
        children: <Widget>[

          //if text format needs to be modified in the lunch menu for any reason, here's the place to do it
          Text(""),
          Text(
            '${dayEntry.menuDate}',
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18, color: Color(0xFFFFFFFF), letterSpacing: 4, fontFamily: 'LEMONMILKLIGHT' ),
            textAlign: TextAlign.center,
          ),
          Text(
            // i used replace all to replace the html code for an apostrophe with one so it doesn't look weird
            'Entree: ${dayEntry.entree.replaceAll('#039;', '\'')}(CAD\$${dayEntry.entreeCost})', style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Text(
            dayEntry.starch == '' ? 'No veggie for thee <3' : 'Starch: ${dayEntry.starch.replaceAll('#039;', '\'')}(CAD\$${dayEntry.starchCost})',
            style: TextStyle(fontSize: 14,fontStyle: FontStyle.italic, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Text(
            dayEntry.veggie == '' ? 'No starch for thee <3' : 'Veggie: ${dayEntry.veggie.replaceAll('#039;', '\'')}(CAD\$${dayEntry.veggieCost})',
            style: TextStyle(fontSize: 14,fontStyle: FontStyle.italic, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Text(
            dayEntry.soup == '' ? 'No soup for thee <3' :'Soup: ${dayEntry.soup.replaceAll('#039;', '\'')}(CAD\$${dayEntry.soupCost})',
            style: TextStyle(fontSize: 14,fontStyle: FontStyle.italic, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Text(
            dayEntry.dessert == '' ? 'No dessert for thee <3' :'Dessert: ${dayEntry.dessert.replaceAll('#039;', '\'')}(CAD\$${dayEntry.dessertCost})',
            style: TextStyle(fontSize: 14,fontStyle: FontStyle.italic, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          Text(""),
          Text(""),
        ],
        //crossAxisAlignment: CrossAxisAlignment.start,
      ),
    ));
  }
  return entryList;
}

///Used to cache data from the site
class MenuCache {
  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/menujson.txt');
  }

  Future<String> readJson() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();

      return contents;
    } catch (e) {
      // If we encounter an error, return 0
      return '';
    }
  }
  Future<File> writeJson(String strToWrite) async {
    final file = await _localFile;

    // Write the file
    return file.writeAsString(strToWrite);
  }
}

class MenuDisplay extends StatefulWidget {
  MenuDisplay({Key key, @required this.menuCache}) : super(key: key);
  //final String title;
  final MenuCache menuCache;

  @override
  _MenuDisplayState createState() => _MenuDisplayState();
}

class _MenuDisplayState extends State<MenuDisplay> {
  //int _counter = 0;
  String jsonRetrieved = '[{"menuID":"262","soup":"Cream of Broccoli","soupCost":"2.00","entree":"Ravioli with 4 Cheese Sauce","entreeCost":"5.00","starch1":"","starch1Cost":"0.00","starch2":"","starch2Cost":"0.00","dessert":"Creme Brulee Cake","dessertCost":"2.00","menuDate":"2018-03-12"},{"menuID":"263","soup":"Vegetable Soup","soupCost":"2.00","entree":"Stuffed Peppers (Meat or Quinoa Stuffing) with Garden Salad","entreeCost":"5.00","starch1":"","starch1Cost":"0.00","starch2":"","starch2Cost":"0.00","dessert":"Squares","dessertCost":"0.00","menuDate":"2018-03-13"},{"menuID":"264","soup":"yes :)","soupCost":"2.00","entree":"Beef Burger and\/or Quinoa Burger with Baked Fries or Salad","entreeCost":"5.00","starch1":"","starch1Cost":"0.00","starch2":"","starch2Cost":"0.00","dessert":"Pie Daaayyyyyy!","dessertCost":"2.50","menuDate":"2018-03-14"},{"menuID":"265","soup":"For Sure...","soupCost":"2.00","entree":"Butter Chicken ","entreeCost":"2.00","starch1":"Basmati Rice","starch1Cost":"1.00","starch2":"fresh steamed vegetables","starch2Cost":"1.00","dessert":"Black Forest Cake","dessertCost":"2.50","menuDate":"2018-03-15"}]';
  String jsonCached = '';
  WeekMenu displayMenu;
  void _retrieveData() {
    setState(() {
      //It just reloads the data by calling setState
    });
  }
  @override
  ///Stores the cached json into a variable on when initialized
  void initState() {
    super.initState();
    widget.menuCache.readJson().then((String value) {
      setState(() {
        jsonCached = value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Container(
      child: FutureBuilder<String>(
        future: fetchMenu(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            jsonRetrieved = snapshot.data;
            jsonCached = snapshot.data;
            widget.menuCache.writeJson(snapshot.data);
            displayMenu = WeekMenu.directFromJson(snapshot.data);
            return Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: displayData(displayMenu),
            );
          } else if(snapshot.hasError){
            if(jsonCached == '') {
              return Text('Looks like you has an error:\n${snapshot
                  .error}\nYou should probably send help.',style: TextStyle(color: Colors.red),);
            } else {
              displayMenu = WeekMenu.directFromJson(jsonCached);
              return ListView(
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Looks like you has an error:\n${snapshot
                      .error}\nWe found your latest cache.',style: TextStyle(color: Colors.red),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: displayData(displayMenu),
                  ),
                ],
              );
            }
          }
          return Column(
            children: <Widget>[
              CircularProgressIndicator(),
              Text('Loading...', style: TextStyle(color: Colors.white)),
            ],
            crossAxisAlignment: CrossAxisAlignment.center,
          );
        },
        /*Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: entryList,
      ),*/
      )
    );
  }
}




//Mew Mhw and Mtw are buttons for the bottom navigation bar
class Mew extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/event.png');
    var image = new Image(image: assetsImage, height: 34, width: 34,);
    var bText = new Text("E V E N T S", style: new TextStyle( fontSize: 10, fontFamily: 'LEMONMILKLIGHT', fontStyle: FontStyle.italic),);

    return new Container( child: Column(
      children: <Widget>[

        image,
        bText,

      ],
    ));

  }
}

class Mhw extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/home.png');
    var image = new Image(image: assetsImage, height: 34, width: 34,);
    var bText = new Text("H O M E", style: new TextStyle( fontSize: 10, fontFamily: 'LEMONMILKLIGHT', fontStyle: FontStyle.italic),);

    return new Container( child: Column(
      children: <Widget>[
        image,
        bText,

      ],
    ));


  }
}

class Mtw extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/thrive.png');
    var image = new Image(image: assetsImage, height: 34, width: 34,);
    var bText = new Text("T H R I V E", style: new TextStyle( fontSize: 10, fontFamily: 'LEMONMILKLIGHT', fontStyle: FontStyle.italic),);

    return new Container( child: Column(
      children: <Widget>[
        image,
        bText,

      ],
    ));


  }
}
//Mew Mhw and Mtw are buttons for the bottom navigation bar


//page displayed on startup
class homeP extends StatelessWidget{

  Future launchfoconURL(String foconURL) async {
    if (await canLaunch(foconURL)){
      await launch(foconURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }
  //if/else statement which essentially says when the focus/connect rooms link is to be opened, how will it be opened on both IOS and ANDROID
  //else just gives a print statement


  @override
  Widget build(BuildContext context) { //builds the page

    var assetsImage = new AssetImage('assets/title.png');
    var image = new Image(image: assetsImage, alignment: new Alignment(-0.87,-0.87),);
    var nwtext = new Text("Check back soon for next week's lunch menu!", style: new TextStyle( fontSize: 14, color: Colors.white, ), textAlign: TextAlign.center,);
    var foc = new Text("Focus Rooms:", style: new TextStyle( fontSize: 22, color: Colors.white, fontFamily: 'LEMONMILKLIGHT', letterSpacing: 4 ), textAlign: TextAlign.center,);
    var lm = new Text("Lunch Menu:", style: new TextStyle( fontSize: 22, color: Colors.white, fontFamily: 'LEMONMILKLIGHT', letterSpacing: 4 ), textAlign: TextAlign.center, );
    var timeText = new Text( new DateFormat("| EEEE | MMM d | yyyy |").format(new DateTime.now(),), style: new TextStyle( fontSize: 16, color: Colors.white, letterSpacing: 4, fontFamily: 'LEMONMILKLIGHT'),  textAlign: TextAlign.center,);
    //variables of images and text to be on the page

    return new Container( child: ListView ( //dictates page format
      children: <Widget>[

        new RawMaterialButton(
        child: Image.asset('assets/title.png', ),
        onPressed: () {
        Navigator.push(context,
        MaterialPageRoute(builder: (context) => devP()),
        );
        },
        ),
        // thirskOS logo at top of home page
        // the image also serves as a secret button, once tapped it takes the user to the development credits page

        new Container(
          height: 5.0,
        ), //these containers act as spacers between pieces of content on the page

        timeText,


        //when video announcments are created at thirsk, instead of using a video player there should be a list of links inside a scrollable text box that expands
        //that list will update with every new link
        //this way it links to youtube or the web so we dont have to worry about or manage the video playback


        new Container(
          height: 10.0,
        ),

        new RawMaterialButton( //creates button
          child: const Text('FOCUS/CONNECT ROOMS ', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, letterSpacing: 4, fontFamily: 'LEMONMILKLIGHT', fontSize: 14,),),
          shape: StadiumBorder(), //style of button
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(10), //space between button edge and text
          fillColor: Color(0xff5d9dfa), //button colour
          splashColor: Color(0xFFFFFFFF), //colour once tapped

          onPressed: () {
            launchfoconURL(foconURL);
          },
        ),
        //goes to URL once tapped


        new Container(
          height: 10.0,
        ),

        lm,

        MenuDisplay(menuCache: MenuCache()), //grabs cached lunch menu (ask Roger)

        new Container(
          height: 5.0,
        ),

        nwtext,


      ],
    ));
  }
} //Home Page

class devP extends StatelessWidget{  //Development credits page


  @override
  Widget build(BuildContext context) {
    var image = new AssetImage('assets/icf.png');
    var bobimage = new Image(image: image, height: 160,);
    var sText = new Text("THIRSK OUTER SPACE", style: new TextStyle( fontFamily: 'ROCK', letterSpacing: 4, fontSize: 22, color: Color(0xFF5d9dfa),),);
    var vn = new Text("Release Version: 1.2.0", style: new TextStyle( fontFamily: 'ROCK', fontSize: 12, color: Color(0xFF5d9dfa), letterSpacing: 2),);
    var ct = new Text("Credits(2018~2019):", style: new TextStyle( fontFamily: 'ROCK', fontSize: 22, color: Colors.white, letterSpacing: 2),);
    var dev1 = new Text("Creator/Lead App Developer: Christopher Samra", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14),);
    var dev2 = new Text("Prototype App Co-Developer: Hasin Zaman", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14),);
    var dev3 = new Text("App Co-Developer: Roger Cao", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14),);
    var dev4 = new Text("Backend Developer: Dunedin Molnar", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14),);
    var dev5 = new Text("Backend Developer: Hasin Zaman", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 14),);
    return new Material( color: Color(0xff424242), child: Column(
      children: <Widget>[


        new Container(
          height: 30.0,

        ),

        new RawMaterialButton(
          child: const Text('Back', style: TextStyle(color: Colors.white, fontSize: 18,),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(5),
          fillColor: Colors.black12,
          splashColor: Color(0xFFFFFFFF),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        //back button to return to previous page

        new Container(
          height: 20.0,

        ),

        bobimage,

        new Container(
          height: 10.0,

        ),

        sText,

        vn,

        new Container(
          height: 20.0,

        ),

        ct,

        new Container(
          height: 3.0,

        ),

        dev1,
        dev2,
        dev3,
        dev4,
        dev5,



      ],
    ),);
  }
} //Dev Credits Page

class thriveP extends StatelessWidget{  //Thirve Page



  Future launchDockURL(String dockURL) async {
    if (await canLaunch(dockURL)){
      await launch(dockURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch dock webpage");
    }

  }

  Future launchClubURL(String clubURL) async {
    if (await canLaunch(clubURL)){
      await launch(clubURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  Future launchStaffURL(String staffURL) async {
    if (await canLaunch(staffURL)){
      await launch(staffURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  Future launchMakerURL(String makerURL) async {
    if (await canLaunch(makerURL)){
      await launch(makerURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  Future launchScholarURL(String scholarURL) async {
    if (await canLaunch(scholarURL)){
      await launch(scholarURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }


  Future launchConnectURL(String connectURL) async {
    if (await canLaunch(connectURL)){
      await launch(connectURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  Future launchEdURL(String edURL) async {
    if (await canLaunch(edURL)){
      await launch(edURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  Future launchfaURL(String faURL) async {
    if (await canLaunch(faURL)){
      await launch(faURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  Future launchcoURL(String coURL) async {
    if (await canLaunch(coURL)){
      await launch(coURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  Future launchpsURL(String connectURL) async {
    if (await canLaunch(psURL)){
      await launch(psURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  Future launchgradURL(String connectURL) async {
    if (await canLaunch(gradURL)){
      await launch(gradURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  //if statements which essentially say when the links are to be opened, how they are going to be opened on both IOS and ANDROID
  //else just gives a print statement


  @override
  Widget build(BuildContext context) {

    var assetsImage = new AssetImage('assets/title.png');
    var image = new Image(image: assetsImage, alignment: new Alignment(-0.87, -0.87),);
    var titleText = new Text("START THRIVING @ Thirsk!", style: new TextStyle( fontSize: 16, color: Colors.white, fontFamily: 'LEMONMILKLIGHT', letterSpacing: 4, ), textAlign: TextAlign.center,);
    //variables for images/text

    return new Container( child: ListView(
      children: <Widget>[

        image,

        new Container(
          height: 5.0,
        ),

        titleText,

        new Container(
          height: 10.0,
        ),

        new RawMaterialButton(  //creates button
          child: const Text('CLUBS', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(), //style & shape of button
          highlightColor: Color(0x0083ff), //dw about this
          padding: EdgeInsets.all(10), //space between edge of button and text
          fillColor: Color(0xff4bc5f2), //button colour
          splashColor: Color(0xFFFFFFFF), //colour of button when tapped

          onPressed: () {
            launchClubURL(clubURL);
          },
        ),
        //goes to url when pressed

        new Container(
          height: 5.0,
        ),

        new RawMaterialButton(
          child: const Text('FINE ARTS', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(),
          highlightColor: Color(0x4DB4ED),
          padding: EdgeInsets.all(10),
          fillColor: Color(0xff4DB4ED),
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => fineArtsP()),
            ); if fine arts is switched to a built in page instead of a weblink use this code*/
            launchfaURL(faURL);
          },
        ),

        new Container(
          height: 5.0,
        ),

        new RawMaterialButton(
          child: const Text('CTS', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(),
          highlightColor: Color(0x50A3E8),
          padding: EdgeInsets.all(10),
          fillColor: Color(0xff50A3E8),
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ctsP()), //goes to built in page when button pressed
            );
          },
        ),

        new Container(
          height: 5.0,
        ),

        new RawMaterialButton(
          child: const Text('SPORTS', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(),
          highlightColor: Color(0x5294E4),
          padding: EdgeInsets.all(10),
          fillColor: Color(0xff5294E4), //44a5ff  4f95f7
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => sportsP()),
            );
          },

        ),
        new Container(
          height: 5.0,
        ),

        new RawMaterialButton(
          child: const Text('THE DOCK', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(10),
          fillColor: Color(0xff548CE2),
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            launchDockURL(dockURL);
          },
        ),
        new Container(
          height: 5.0,
        ),

        new RawMaterialButton(
          child: const Text('EDVENTURE', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(10),
          fillColor: Color(0xff5583DF),
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            launchEdURL(edURL);
          },
        ),
        new Container(
          height: 5.0,
        ),

        new RawMaterialButton(
          child: const Text('CONNECT NEWSLETTER', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(),
          highlightColor: Color(0x6a7ffc),
          padding: EdgeInsets.all(10),
          fillColor: Color(0xff567BDD),
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            launchConnectURL(connectURL);
          },
        ),
        new Container(
          height: 5.0,
        ),

        new RawMaterialButton(
          child: const Text('TEACHER CONTACT LIST', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(),
          highlightColor: Color(0x5b69ff),
          padding: EdgeInsets.all(10),
          fillColor: Color(0xff586ED9),
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            launchStaffURL(staffURL);
          },
        ),
        new Container(
          height: 5.0,
        ),

        new RawMaterialButton(
          child: const Text('CAREER OPPOURTUNITIES', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(10),
          fillColor: Color(0xff5A63D6),
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => gradBeyondP()),
            );*/
            launchcoURL(coURL);
          },
        ),
        new Container(
          height: 5.0,
        ),


        new RawMaterialButton(
          child: const Text('SCHOLARSHIPS', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(10),
          fillColor: Color(0xff5D52D1),
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            launchScholarURL(scholarURL);
          },
        ),
        new Container(
          height: 5.0,
        ),

        new RawMaterialButton(
          child: const Text('EXAMS', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(10),
          fillColor: Color(0xff5F42CD),
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => diplomaP()),
            );
          },
        ),
        new Container(
          height: 5.0,
        ),


        new RawMaterialButton(
          child: const Text('GRADUATION', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(10),
          fillColor: Color(0xff6230C8),
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => gradBeyondP()),
            );*/
            launchgradURL(gradURL);
          },
        ),
        new Container(
          height: 5.0,
        ),


        new RawMaterialButton(
          child: const Text('POST SECONDARY', style: TextStyle(color: Colors.white, fontFamily: 'LEMONMILKLIGHT', fontSize: 18, letterSpacing: 4),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(10),
          fillColor: Color(0xff6521c4),
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => gradBeyondP()),
            );*/
            launchpsURL(psURL);
          },
        ),

        //Buttons that lead to certain pages or URLS, Each is coloured a certain way to create a gradient from blue to purple
        //if additional buttons need to be added there are extra colour codes that further complete the gradient
        //full gradient :
        //4bc5f2
        //4DB4ED
        //50A3E8
        //5294E4
        //548CE2
        //5583DF
        //567BDD
        //586ED9
        //596BD8
        //5A63D6
        //5B5AD4
        //5D52D1
        //5E4ACF
        //5F42CD
        //613ACB
        //6230C8
        //6329C6
        //6521c4

      ],
    ));

  }
}  //Thrive Page

class diplomaP extends StatelessWidget{   //Built in page for Exam Resources

  Future launchesURL(String esURL) async {
    if (await canLaunch(esURL)){
      await launch(esURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  Future launchadpURL(String adpURL) async {
    if (await canLaunch(adpURL)){
      await launch(adpURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  Future launchfgcURL(String fgcURL) async {
    if (await canLaunch(fgcURL)){
      await launch(fgcURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  Future launchexpcURL(String expcURL) async {
    if (await canLaunch(expcURL)){
      await launch(expcURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  Future launchqappURL(String qappURL) async {
    if (await canLaunch(qappURL)){
      await launch(qappURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }

  @override
  Widget build(BuildContext context) {
    var dpText = new Text("Exams", style: new TextStyle( fontFamily: 'ROCK', fontSize: 36, color: Colors.white, letterSpacing: 2),);
    var rt = new Text("Resources:", style: new TextStyle( fontFamily: 'ROCK', fontSize: 24, color: Colors.white, letterSpacing: 2),);
    var wm = new Text("This page is not final and will be updated next year!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 10),);
    return new Material( color: Color(0xff424242), child: Column(
      children: <Widget>[

        new Container(
          height: 30.0,

        ),

        new RawMaterialButton(
          child: const Text('Back', style: TextStyle(color: Colors.white, fontSize: 18,),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(5),
          fillColor: Colors.black12,
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            Navigator.pop(context);
          },
        ),

        new Container(
          height: 20.0,

        ),

        dpText,

        new Container(
          height: 15.0,

        ),

        rt,

        new Container(
        height: 10.0,

        ),


        /*new RawMaterialButton(
          child: const Text('RTHS EXAM SCHEDULE JAN 2020', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, letterSpacing: 4, fontFamily: 'LEMONMILKLIGHT', fontSize: 14,),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(10),
          fillColor: Colors.indigo,
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            launchesURL(esURL);
          },
        ),
        new Container(
          height: 2.0,

        ),       UNCOMMENT BUTTON AND UPDATE WITH JAN 2020 EXAM SCHEDULE PDF URL *update esURL in the const section at the top* AS SOON AS IT'S AVAILABLE                              */

        new RawMaterialButton(
          child: const Text('FINAL GRADE CALCULATOR',textAlign: TextAlign.center, style: TextStyle(color: Colors.white,letterSpacing: 4, fontFamily: 'LEMONMILKLIGHT', fontSize: 14,),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(10),
          fillColor: Colors.indigo,
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            launchfgcURL(fgcURL);
          },
        ),
        new Container(
          height: 2.0,

        ),

        new RawMaterialButton(
          child: const Text('ALBERTA DIPLOMA PREP COURSES',textAlign: TextAlign.center, style: TextStyle(color: Colors.white,letterSpacing: 4, fontFamily: 'LEMONMILKLIGHT', fontSize: 14,),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(10),
          fillColor: Colors.indigo,
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            launchadpURL(adpURL);
          },
        ),
        new Container(
          height: 5.0,

        ),

        new RawMaterialButton(
          child: const Text('EXAMPLARS AND PRACTICE FROM PREVIOUS DIPLOMAS',textAlign: TextAlign.center, style: TextStyle(color: Colors.white,letterSpacing: 4, fontFamily: 'LEMONMILKLIGHT', fontSize: 14,),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(10),
          fillColor: Colors.indigo,
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            launchexpcURL(expcURL);
          },
        ),



        wm,




      ],
    ),);
  }
} //Exam Resources Page

class ctsP extends StatelessWidget{   //CTS page


  Future launchchssURL(String ctsURL) async {
    if (await canLaunch(ctsURL)){
      await launch(ctsURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }


  @override
  Widget build(BuildContext context) {

    var assetsImageS = new AssetImage('assets/cometslogo.png');
    var imageS = new Image(image: assetsImageS, alignment: new Alignment(-0.87, -0.87), width: 270,);
    var assetsImage = new AssetImage('assets/m1.png');
    var image = new Image(image: assetsImage, alignment: new Alignment(-0.87, -0.87), width: 350,);
    var sText = new Text("CAREER TECHNOLOGY STUDIES",textAlign: TextAlign.center, style: new TextStyle( fontFamily: 'ROCK', letterSpacing: 6, fontSize: 20, color: Colors.white,),);
    var rt = new Text("What can you make?",textAlign: TextAlign.center, style: new TextStyle( fontFamily: 'LEMONMILKLIGHT', fontSize: 25, color: Colors.white, letterSpacing: 2),);
    var rt2 = new Text("What can become of your projects?",textAlign: TextAlign.center, style: new TextStyle( fontFamily: 'LEMONMILKLIGHT', fontSize: 25, color: Colors.white, letterSpacing: 2),);
    var assetsImage2 = new AssetImage('assets/m2.png');
    var image2 = new Image(image: assetsImage2, alignment: new Alignment(-0.87, -0.87), width: 350,);
    var assetsImage3 = new AssetImage('assets/m3.png');
    var image3 = new Image(image: assetsImage3, alignment: new Alignment(-0.87, -0.87), width: 350,);
    var wm = new Text("This page is not final and will be updated next year!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 10),);



    return new Material( color: Color(0xff424242), child: Column(
      children: <Widget>[


        new Container(
          height: 30.0,

        ),

        new RawMaterialButton(
          child: const Text('Back', style: TextStyle(color: Colors.white, fontSize: 18,),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(5),
          fillColor: Colors.black12,
          splashColor: Color(0xFFFFFFFF),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

        imageS,

        sText,

        new Container(
          height: 10.0,

        ),

        image,

        image2,

        image3,
        //placeholder images promoting CTS, they can be removed and replaced with more detailed/accurate info next year

        /*new Container(
          height: 10.0,

        ),

        new RawMaterialButton(
          child: const Text('cts web link',textAlign: TextAlign.center, style: TextStyle(color: Colors.white,letterSpacing: 4, fontFamily: 'LEMONMILKLIGHT', fontSize: 14,),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(5),
          fillColor: Colors.blueAccent,
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            launchchssURL(ctsURL);
          },
        ),    button for a cts web link in the event there is one */

        new Container(
          height: 20.0,

        ),

        wm,



      ],
    ),);
  }
}  //CTS Page

class sportsP extends StatelessWidget{


  Future launchchssURL(String chssURL) async {
    if (await canLaunch(chssURL)){
      await launch(chssURL, forceSafariVC: true, forceWebView: false);
    } else {
      print("cant launch webpage");
    }

  }


  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/cometslogo.png');
    var image = new Image(image: assetsImage, alignment: new Alignment(-0.87, -0.87), width: 325,);
    var sText = new Text("ATHLETICS", style: new TextStyle( fontFamily: 'ROCK', letterSpacing: 6, fontSize: 30, color: Colors.white,),);
    var rt = new Text("Team Games Schedule:", style: new TextStyle( fontFamily: 'ROCK', fontSize: 20, color: Colors.white, letterSpacing: 2),);
    var wm = new Text("This page is not final and will be updated next year!", textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 10),);
    return new Material( color: Color(0xff424242), child: Column(
      children: <Widget>[


        new Container(
          height: 30.0,

        ),

        new RawMaterialButton(
          child: const Text('Back', style: TextStyle(color: Colors.white, fontSize: 18,),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(5),
          fillColor: Colors.black12,
          splashColor: Color(0xFFFFFFFF),
          onPressed: () {
            Navigator.pop(context);
          },
        ),


        image,

        new Container(
          height: 10.0,

        ),


        sText,

        new Container(
          height: 20.0,

        ),

        rt,

        new Container(
          height: 10.0,

        ),

        new RawMaterialButton(
          child: const Text('CALGARY SENIOR HIGH SCHOOL ATHLETIC ASSOCIATION',textAlign: TextAlign.center, style: TextStyle(color: Colors.white,letterSpacing: 4, fontFamily: 'LEMONMILKLIGHT', fontSize: 14,),),
          shape: StadiumBorder(),
          highlightColor: Color(0x0083ff),
          padding: EdgeInsets.all(5),
          fillColor: Colors.red.shade900,
          splashColor: Color(0xFFFFFFFF),

          onPressed: () {
            launchchssURL(chssURL);
          },
        ),

        new Container(
          height: 20.0,

        ),

        wm,



      ],
    ),);
  }
} //Athletics Page

class eventP extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    var assetsImage = new AssetImage('assets/title.png');
    var image = new Image(image: assetsImage, alignment: new Alignment(-0.87, -0.87),);
    var titleText = new Text("| Arts | Athletics | CTS | Wellness | ", style: new TextStyle( fontSize: 11, color: Colors.white, fontFamily: 'LEMONMILKLIGHT',letterSpacing: 4, ), textAlign: TextAlign.center,);

    return new Container( child: ListView(
      children: <Widget>[


        image,

        new Container(
          height: 5.0,
        ),

        titleText,

        new Container(
          height: 10.0,
        ),

        //OneEventPost(postJson: '',),
        AllEventPosts() //grabs post information (ask Roger)

      ],
    ));
  }
}  //Events Page

class MyApp extends StatelessWidget {
  // This widget is the root of the application, the skeleton if you will.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]); //maintains vertical orientation
    return new MaterialApp(
      title: "thirskOS",
      color: Colors.grey,

      home: DefaultTabController(
        initialIndex: 1,
        length: 3,

        child: new Scaffold(
          body: TabBarView(
            children: [
              new Container(
                child: new thriveP(),
                padding: EdgeInsets.all(10),
                color: Color(0xFF424242),
              ),

              new Container(
                child: new homeP(),
                padding: EdgeInsets.all(10),
                color: Color(0xFF424242),
              ),

              new Container(
                child: new eventP(),
                padding: EdgeInsets.all(10),
                color: Color(0xFF424242),

              ),

              //containers of the three pages

            ],
          ),
          bottomNavigationBar: new TabBar( //creates bottom navigation bar
            tabs: [
              Tab(
                child: new Mtw(),
              ),

              Tab(
                child: new Mhw(),
              ),

              Tab(
                child: new Mew(),

              ),


            ],
            //labelColor: Colors.blue,
            //unselectedLabelColor: Colors.white,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.all(20),
            indicatorPadding: EdgeInsets.all(6.0),
            indicatorColor: Colors.white,
          ),
          backgroundColor: Color(0xFF2D2D2D), //app background colour
        ),
      ),
    );
  }
} //Skeleton of the UI


//fonts, image assets, and dependencies are listed in the pubspec.yaml file