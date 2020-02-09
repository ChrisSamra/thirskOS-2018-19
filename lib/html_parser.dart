import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class LinkParser{
  static List<String> getListOfLinks(String htmlToParse){
    List<String> returnVal = [];
    var document = parse(htmlToParse);
    var links = document.getElementsByTagName("a");
    for(int i = 0; i < links.length; i++){
      if(links[i].attributes["href"].endsWith(".json")){
        //if(/*links[i].attributes["href"]!="./_post_on_19-04-21%2003:23:27am.json" && */links[i].attributes["href"]!="./stamno_post_on_19-04-21%2003:20:44am.json")
        returnVal.add(links[i].attributes["href"]);
      }
    }
    //print(document.outerHtml);
    return returnVal;
  }
}