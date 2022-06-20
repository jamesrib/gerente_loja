import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gerente_loja/widgets/category_tile.dart';

class ProductsTab extends StatefulWidget {
  @override
  _ProductsTabState createState() => _ProductsTabState();
}

class _ProductsTabState extends State<ProductsTab>
  with AutomaticKeepAliveClientMixin // /* stfull - mantem o que foi carregado  sem necessidade de recerregar a cada troca de aba*/
  {
  @override
  Widget build(BuildContext context) {
    super.build(context); //necessario para AutomaticKeepAliveClientMixin
    /*futurebuilder para pegar lista apenas uma vez, sem necessidade de ser atualizado em tempo real*/
    //return FutureBuilder<QuerySnapshot>(
    //   future: Firestore.instance.collection("products").getDocuments(),
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection("products").snapshots(),
        builder: (context,snapshot){
          if(!snapshot.hasData) return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.white),
            ),
          );
          return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context,index){
                return CategoryTile(snapshot.data.docs[index]);
              },
          );
        }
    );
  }

  @override

  bool get wantKeepAlive => true; /*mantem o que foi carregado  sem necessidade de recerregar a cada troca de aba*/
}
