import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_header.dart';

class OrderTile extends StatelessWidget {

  final DocumentSnapshot order;

  OrderTile(this.order);

  final states =[
    "", "Em preparação", "Em transporte", "Aguardando Entrega", "Entregue"
  ];


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 4),
      child: Card(
        child: ExpansionTile( //o numero da ordem sao os 7 ultimos digitos
          key: Key(order.id),
          initiallyExpanded: order.get("status") != 4,
          title: Text("#${order.id.substring(order.id.length - 7, order.id.length)} - "
              "${states[order.get("status")]}",
              style: TextStyle(color: order.get("status") != 4 ? Colors.grey[850] : Colors.green),
          ),
          children: [
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16,top: 0,bottom: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  OrderHeader(order),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: order.get("products").map<Widget>((p){
                      return ListTile(
                        title: Text(p["product"]["title"] + " " + p["size"]),

                        subtitle: Text(p["category"] + "/" + p["pid"]),
                        trailing: Text(
                          p["quantity"].toString(),
                          style: TextStyle(fontSize: 20),
                        ),
                        contentPadding: EdgeInsets.zero,
                      );

                    }).toList(),

                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color:Colors.red,)
                          ),
                          onPressed: (){
                            FirebaseFirestore.instance.collection("users").doc(order["clientId"])
                                .collection("orders").doc(order.id).delete();
                            order.reference.delete();
                          },

                          child:  Text("Excluir")
                      ),
                      ElevatedButton(
                          onPressed: order.get("status") > 1 ? (){
                            order.reference.update({"status" : order.get("status") - 1});
                          } :
                          null,
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.grey[850])
                          )
                          ,
                          child:  Text("Regredir")
                      ),
                      ElevatedButton(
                          onPressed: order.get("status") < 4 ? (){
                            order.reference.update({"status" : order.get("status") + 1});

                          }:
                          null,
                          style: ElevatedButton.styleFrom(
                            textStyle: TextStyle(color: Colors.grey[850])
                          ),
                          child:  Text("Avançar")
                      )
                    ],
                  )
                ],
              )
              ,
            )
          ],
        ),

      ),
    );
  }
}
