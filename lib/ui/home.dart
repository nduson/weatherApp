import 'dart:async';
import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import '../util/utils.dart' as util;

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  String _cityEntered;

  Future _goToNextScreen(BuildContext context) async{

    Map results = await Navigator.of(context).push(
      MaterialPageRoute<Map>(builder: (BuildContext context){
        return ChangeCityScreen();
      })

    );

    if (results != null && results.containsKey('city')){
      _cityEntered = results['city'];

    }else{
      print('Invalid City..');

    }

  }

void getdata() async{
  Map data = await getWeather(util.appId, util.defaultCity);
  print(data.toString());
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Weather App"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.menu), onPressed: (){_goToNextScreen(context);},)

        ],
      ),

      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset("images/umbrella.png",fit: BoxFit.fill,width: 500.0,height: 1200.00,),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0.0, 10.0, 20.0, 0.0),
           // child: Text("Abakalik", style: TextStyle(color: Colors.white,fontSize: 25.00, fontWeight: FontWeight.w500),),
          // child: myText(),
          child: Text("${_cityEntered == null ? util.defaultCity.toUpperCase() : _cityEntered.toUpperCase()}", style: mystyle(size: 22.9))
          ),

          Container(
            alignment: Alignment.center,
            child: Image.asset("images/light_rain.png"),
          ),

          Container(
            margin: EdgeInsets.fromLTRB(25.0, 350.0, 0.0, 0.0),
            child: updateTempWidget(_cityEntered),
            //child: Text("71.8f", style: mystyle(size: 22.9)),
          )
        ],
      ),
      
    );
  }

 Future<Map> getWeather(String appId, String city) async{
   String apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=metric";

   http.Response response = await http.get(apiUrl);

   return json.decode(response.body);

   
 }

 Widget updateTempWidget(String city){
   return FutureBuilder(
     future: getWeather(util.appId, city == null?util.defaultCity:city),
     builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
       if (snapshot.hasData && snapshot.data.containsKey('main')){
         Map content = snapshot.data;
         //print("Reach Here...");
         //print(snapshot.data.toString());
         return Container(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
                ListTile(
                 title: Text(content['main']['temp'].toString() + " C",style: mystyle(size: 40.9),),
                 subtitle: ListTile(
                   title: Text("Humidity: ${content['main']['humidity'].toString()} C\n"
                               "Temp_min: ${content['main']['temp_min'].toString()} C\n" 
                               "Temp_max: ${content['main']['temp_max'].toString()} C", style: mystyle(size: 16.0), ),
                 ),
               ),
             ],
           ),

         );
       }else{
        // print("Got to else Here...");
         return Container(child: Text("No Data Yet!", style: mystyle(size: 22.9)),);
       }

   },

   );
 }


  
}


class ChangeCityScreen extends StatelessWidget {
  var _cityFieldController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Change City"),
        backgroundColor: Colors.redAccent,
        centerTitle: true,
      ),

      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset("images/white_snow.png", width:500.0, height: 1200.0, fit:BoxFit.fill),
          ),
          ListView(
            children: <Widget>[
              ListTile(
                title: TextField(
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: "City",
                    labelText: "Enter City"
                  ),
                )
              ),
              ListTile(
                title: FlatButton(
                  child: Text('Get Weather...'),
                  color: Colors.redAccent,
                  textColor: Colors.white,
                  onPressed: ()=>{
                    Navigator.pop(context,{
                      'city': _cityFieldController.text
                    })
                  },
                ),
              )
            ],
          )
        ],
      ),
      
    );
  }
}

 TextStyle mystyle({double size}){

    return TextStyle(color: Colors.white,fontSize: size, fontWeight: FontWeight.w500,fontStyle: FontStyle.italic);
    
  }

Text myText(){
    return Text("Abakalik", style: TextStyle(color: Colors.white,fontSize: 22.9, fontWeight: FontWeight.w500),);
  }