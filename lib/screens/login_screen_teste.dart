import 'package:flutter/material.dart';

class LoginScreenTeste extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              Column(
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    color: Colors.red,
                    child: Icon(
                      Icons.house,
                      size: 150,
                    ),
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: "E-mail", icon: Icon(Icons.person)),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Divider(),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                        hintText: "E-mail", icon: Icon(Icons.person)),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  Divider(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16)
                    ),

                    child: Text('Entrar'),
                  ),
                ],
              )
            ],
          )),
    );
  }
}
