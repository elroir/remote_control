import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:remote_app/helpers/client_handler.dart';
import 'package:remote_app/helpers/generic_alert.dart';
import 'package:remote_app/services/mqtt_client.dart';
import 'package:remote_app/services/open_hab.dart';
import 'package:provider/provider.dart';
import 'package:remote_app/widgets/dual_button.dart';
import 'package:swipedetector/swipedetector.dart';

class ControlAppleView extends StatelessWidget {

  final openHab = new OpenHabService();

  @override
  Widget build(BuildContext context) {
    final MqttClientService mqtt = Provider.of<MqttClientService>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: size.width*0.8,
            margin: EdgeInsets.only(top: 20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10.0),
                    child: _buildPad(context,mqtt),
                  ),
                  _buildButtons(context, mqtt)

                ],
              ),
            )
        ),
      ),
      floatingActionButton:(ClientHandler.instance.currentClient==0) ? FloatingActionButton(
          child: (mqtt.serverStatus == ServerStatus.Offline) ? Icon(Icons.offline_bolt) : Icon(Icons.check_circle),
          backgroundColor: (mqtt.serverStatus == ServerStatus.Offline) ? Colors.red : Colors.blue,
          onPressed: () {}
      ) : null,

    );
  }

  Widget _buildButtons(BuildContext context, MqttClientService mqtt){

    final size = MediaQuery.of(context).size;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          height: size.height * 0.28,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              RawMaterialButton(
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () => genericAlert(context,'Boton de adorno', 'Este boton, lo llevan tanto la app como el control real, pero aqui se utilizo para rellenar el control'),
                elevation: 1.0,
                fillColor: Theme.of(context).primaryColor,
                child: Icon( CupertinoIcons.mic_solid,size: size.width*0.08, color: Colors.white70, ),
                padding: EdgeInsets.all(20.0),
                shape: CircleBorder(),
              ),
              RawMaterialButton(
                onPressed: () async {
                  if (ClientHandler.instance.currentClient==0){
                    mqtt.publish('control/apple_tv', '77E1FA80');
                  }else{
                    await openHab.publish('Control_Play', 'OFF');
                  }
                },
                elevation: 1.0,
                fillColor: Theme.of(context).primaryColor,
                child: Icon( MaterialCommunityIcons.play_pause,size: size.width*0.08, color: Colors.white70, ),
                padding: EdgeInsets.all(20.0),
                shape: CircleBorder(),
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: OutlinedButton(
            onPressed: () async {
              if (ClientHandler.instance.currentClient == 0){
                if(mqtt.serverStatus == ServerStatus.Online){
                  mqtt.publish('control/apple_tv','77E1C080');
                }else{
                  await mqtt.connect();
                  mqtt.publish('control/apple_tv','77E1C080');
                }
              }else
                openHab.publish('Control_power', 'OFF');
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all(CircleBorder()),
              padding: MaterialStateProperty.all(EdgeInsets.all(size.height*0.052)),
              side: MaterialStateProperty.all(BorderSide(width: 2.0,color: Colors.white)),
            ),
            child: Text('MENU',style: TextStyle(color: Colors.white,fontSize: 20.0),),
          ),
        ),
        DualButton(
          iconTop: Icon(Icons.add,size: size.width*0.08,),
          iconBottom: Icon(Icons.remove,size: size.width*0.08),
          topOnPressed: (){
            if (ClientHandler.instance.currentClient == 0)
              mqtt.publish('control/apple_tv','20DF40BF');
            else
              openHab.publish('Control_Volume_Up', 'OFF');
          },
          bottomOnPressed: (){
            if (ClientHandler.instance.currentClient == 0)
              mqtt.publish('control/apple_tv','20DFC03F');
            else
              openHab.publish('Control_Volume_Down', 'OFF');
          },
        ),
      ],
    );
  }

  Widget _buildPad(BuildContext context,MqttClientService mqtt){
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        if (ClientHandler.instance.currentClient == 0)
          mqtt.publish('control/apple_tv','77E13A80');
        else
          openHab.publish('Control_Ok', 'OFF');
      },
      child: SwipeDetector(
        onSwipeUp: () {
          if (ClientHandler.instance.currentClient == 0)
            mqtt.publish('control/apple_tv','77E15080');
          else
            openHab.publish('Control_apple_tv', 'OFF');
        } ,
        onSwipeDown: () {
          if (ClientHandler.instance.currentClient == 0)
            mqtt.publish('control/apple_tv','77E13080');
          else
            openHab.publish('arrow_down_Arrow_Down', 'OFF');
        } ,
        onSwipeLeft: () {
          if (ClientHandler.instance.currentClient == 0)
            mqtt.publish('control/apple_tv','77E19080');
          else
            openHab.publish('Control_Arrow_Left', 'OFF');
        } ,
        onSwipeRight: () {
          if (ClientHandler.instance.currentClient == 0)
            mqtt.publish('control/apple_tv','77E16080');
          else
            openHab.publish('Control_Arrow_Right', 'OFF');
        } ,
        child: Container(
          height: size.height*0.3,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(20.0),
          ),

        ),
      ),
    );
  }

}

