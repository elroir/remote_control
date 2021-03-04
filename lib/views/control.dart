import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:remote_app/helpers/client_handler.dart';
import 'package:remote_app/services/mqtt_client.dart';
import 'package:remote_app/services/open_hab.dart';
import 'package:provider/provider.dart';
import 'package:remote_app/widgets/dual_button.dart';

class ControlView extends StatefulWidget {

  @override
  _ControlViewState createState() => _ControlViewState();
}

class _ControlViewState extends State<ControlView> with WidgetsBindingObserver {
  final openHab = new OpenHabService();
  MqttClientService mqtt;

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
      if (mqtt.serverStatus == ServerStatus.Offline){
        mqtt.connect();
      }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {

    mqtt = Provider.of<MqttClientService>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorDark,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: double.infinity,height: 20.0,),
            RawMaterialButton(
              onPressed: () => _submit('20DF10EF', 'Control_LG'),
              elevation: 2.0,
              fillColor: Theme.of(context).primaryColor,
              child: Icon( FontAwesome.power_off,size: 60.0, color: Colors.red, ),
              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _optionButton('Input', '20DFD02F', 'Control_Input'),
                _optionButton('Menu', '20DFC23D', 'Control_Settings')
              ],
            ),
            Container(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _arrowButton(Icon(Icons.arrow_drop_up,size: 32.0,), '20DF02FD', 'Control_Up'),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _arrowButton(Icon(Icons.arrow_left,size: 32.0,), '20DFE01F', 'Control_Left'),
                        RawMaterialButton(
                          onPressed:() => _submit('20DF22DD', 'Control_Ok_Lg'),
                          elevation: 2.0,
                          fillColor: Theme.of(context).primaryColor,
                          child: Text('OK',style: TextStyle(color: Colors.white,fontSize: 20.0),),
                          padding: EdgeInsets.all(20.0),
                          shape: CircleBorder(),
                        ),
                        _arrowButton(Icon(Icons.arrow_right,size: 32.0,), '20DF609F', 'Control_Right'),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _arrowButton(Icon(Icons.arrow_drop_down,size: 32.0,), '20DF827D', 'Control_Down'),
                    ),
                  ],
                )
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DualButton(
                  iconTop: Icon(Icons.add,size: 28.0,),
                  iconBottom: Icon(Icons.remove,size: 28.0),
                  text: 'Vol',
                  topOnPressed: () => _submit('20DF40BF', 'Control_Volume_Up'),
                  bottomOnPressed: () => _submit('20DFC03F', 'Control_Volume_Down'),
                ),
                DualButton(
                  iconTop: Icon(Icons.arrow_drop_up,size: 28.0,),
                  iconBottom: Icon(Icons.arrow_drop_down,size: 28.0),
                  text: 'CH',
                  topOnPressed: () => _submit('20DF00FF', 'Control_Channel_Up'),
                  bottomOnPressed: () => _submit('20DF807F', 'Control_Channel_Down'),
                ),
              ],
            )
          ],
        ),
      ),
      floatingActionButton:(ClientHandler.instance.currentClient==0) ? FloatingActionButton(
          child: (mqtt.serverStatus == ServerStatus.Offline) ? Icon(Icons.offline_bolt) : Icon(Icons.check_circle),
          backgroundColor: (mqtt.serverStatus == ServerStatus.Offline) ? Colors.red : Colors.blue,
          onPressed: () {}
      ) : null,
    );
  }

  Widget _arrowButton(Icon icon,String message,String thing){
    return FlatButton(
      onPressed:() => _submit(message, thing),
      child: icon,
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(vertical: 3.0),
      minWidth: 40.0,
    );
  }

  Widget _optionButton(String content,String message,String thing){
    return FlatButton(
      onPressed:() => _submit(message, thing),
      child: Text(content,style: TextStyle(color: Colors.white),),
      color: Theme.of(context).primaryColor,
      padding: EdgeInsets.symmetric(vertical: 3.0),
      shape: StadiumBorder(),

    );
  }

  Future<void> _submit(String message,String thing) async {
    {
      if (ClientHandler.instance.currentClient==0){
        if(mqtt.serverStatus == ServerStatus.Online){
          mqtt.publish('control/lg', message);
        }else{
          await mqtt.connect();
          mqtt.publish('control/lg', message);
        }
      }else{
        await openHab.publish(thing, 'OFF');
      }
    }
  }

}
