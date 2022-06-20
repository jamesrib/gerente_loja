import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/screens/product_screen.dart';
import 'package:gerente_loja/widgets/edit_category_dialog.dart';

class CategoryTile extends StatelessWidget {

  final DocumentSnapshot category;

  CategoryTile(this.category);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          leading: GestureDetector(
            onTap: (){
              showDialog(context: context, builder: (context) => EditCategoryDialog(
                category: category,
              ),);
            },
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              backgroundImage: NetworkImage(category.get("icon"),),
            ),
          ),
          title: Text(
            category.get("title"),
            style: TextStyle(color: Colors.grey[850], fontWeight: FontWeight.w500),
          ),
          children: <Widget>[
            //FutureBuilder<QuerySnapshot>(
            StreamBuilder<QuerySnapshot>(
              stream: category.reference.collection("items").snapshots(),
              builder: (context,snapshot){
                if(!snapshot.hasData) return Container();
                return Column(
                  children: snapshot.data.docs.map((doc){
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          backgroundImage: NetworkImage(doc.get("images")[0]),
                        ),
                        title: Text(doc.get("title")),
                        trailing: Text(
                          "R\$${doc.get("price").toStringAsFixed(2)}"
                        ),
                        onTap: (){
                          Navigator.of(context).push(
                            /*modificar produto*/
                            MaterialPageRoute(builder: (context) => ProductScreen(
                              categoryId: category.id,
                              product: doc,
                            ))
                          );
                        },
                      );
                    }).toList()..add( /*notacao de cascata, para adicionar mais um widget*/
                      ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: Icon(Icons.add, color: Colors.pinkAccent,),

                        ),
                        title: Text("Adicionar"),
                        onTap:() {
                          //novo produto
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => ProductScreen(
                                categoryId: category.id,

                              ))
                          );
                        },
                      )
                  )
                );
              }
            )
          ],
        ),
      ),
    );
  }
}
