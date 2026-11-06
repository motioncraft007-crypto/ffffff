import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget{
  const RegisterScreen({super.key});
  
@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(243, 205, 247, 1),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.all(24),
            child: Column(
              children: [
                const Icon(
                  Icons.access_alarm_outlined,
                  size: 32,
                  color: Colors.lightBlue,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  
                  Expanded(child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  onPressed: () { }, 
                child:Text('Ro‘yxatdan o‘tish!',
                ),
                ), ),
                 

                Expanded(child: TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                   }, 
                child:Text('Kırısh',
                ),
                ),     ),
                           
                ],
                )
             ],
            ),
          
          ),
        )
      )
    );
    }

}

