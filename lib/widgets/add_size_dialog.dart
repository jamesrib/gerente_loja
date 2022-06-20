import 'package:flutter/material.dart';

class AddSizeDialog extends StatelessWidget {

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.only(left: 8,right: 8,top: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            TextField(
              controller: _controller,
            ),
            Container(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: TextStyle(color: Colors.pinkAccent,)
                ),
                child: Text("Add"),

                onPressed: (){
                  Navigator.of(context).pop(_controller.text);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
