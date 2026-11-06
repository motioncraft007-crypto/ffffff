import 'package:flutter/material.dart';
import 'package:login_page/screens/register_screen.dart';

class LoginScreen extends StatelessWidget{
  const LoginScreen({super.key});
  
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



                Text(
                  'MiniNotes',
                  style: TextStyle(
                    fontSize: 33,
                  ),
                ),




                Text('Qaydlaringiz har doim siz bilan'),
                SizedBox(height: 32,),


                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(left:Radius.circular(15),right: Radius.circular(15)),
                    )
                  ),
                ),



                SizedBox(height: 12,),



                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Parol',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.horizontal(left:Radius.circular(15),right: Radius.circular(15)),
                    )
                  ),
                ),

                 SizedBox(height: 12,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  
                  Expanded(child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  onPressed: () {
                    Navigator.push(context,
                    MaterialPageRoute(builder: (BuildContext context) => const RegisterScreen())

                    );
                   }, 
                child:Text('Ro‘yxatdan o‘tish!',
                ),
                ), ),
                 

                Expanded(child: TextButton(
                  onPressed: () { }, 
                child:Text('Parolni unitdingizmi?',
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

