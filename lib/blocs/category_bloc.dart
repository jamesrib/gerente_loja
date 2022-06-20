import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class CategoryBloc extends BlocBase{

  final _titleController = BehaviorSubject<String>();
  final _imageController = BehaviorSubject();
  final _deleteCotroller = BehaviorSubject<bool>();

  Stream<String> get outTitle => _titleController.stream.transform(
      StreamTransformer<String,String>.fromHandlers(
        handleData: (title, sink){
          if(title.isEmpty)
            sink.addError("Insira um título");
          else
            sink.add(title);
        }
      )
  );
  Stream get outImage => _imageController.stream;
  Stream<bool> get outDelete => _deleteCotroller.stream;
  Stream<bool> get submitValid => Observable.combineLatest2(
    outTitle, outImage, (a, b) => true
  );

  DocumentSnapshot category;
  String title;
  File image;
  CategoryBloc(this.category){
    if(category != null){
      //title = category.data["title"];
      title = category.get("title");
      _titleController.add(category.get("title"));
      _imageController.add(category.get("icon"));
      _deleteCotroller.add(true);
    }
    else{
      _deleteCotroller.add(false);
    }

  }

  void setTitle(String title){
    this.title = title;
    _titleController.add(title);
  }

  void setImage(File file){
    image = file;
    _imageController.add(file);
  }

  void delete(){
    category.reference.delete();
  }

  Future saveData() async{
    if( image == null && category != null && title == category.get("title")) return;

    Map<String, dynamic> dataToUpdate = {};

    if(image != null){
      UploadTask task = FirebaseStorage.instance.ref().child("icons")
          .child(title).putFile(image);
//      TaskSnapshot snap = await task.onComplete;
      TaskSnapshot snap = await task.whenComplete(() => null);

      dataToUpdate["icon"] = await snap.ref.getDownloadURL();


      /* deprecated
      StorageUploadTask task = FirebaseStorage.instance.ref().child("icons")
          .child(title).putFile(image);
      StorageTaskSnapshot snap = await task.onComplete;
      dataToUpdate["icon"] = await snap.ref.getDownloadURL();

       */
    }

    if(category == null || title != category.get("title")){
      dataToUpdate["title"] = title;
    }

    if(category == null){
  //    await Firestore.instance.collection("products").document(title.toLowerCase())
      await FirebaseFirestore.instance.collection("products").doc(title.toLowerCase())
          .set(dataToUpdate);
// deprecated           .setData(dataToUpdate);
    } else{
      //deprecated await category.reference.updateData(dataToUpdate);
      await category.reference.update(dataToUpdate);
    }


  }

  @override
  void dispose() {
    _titleController.close();
    _imageController.close();
    _deleteCotroller.close();
  }
}
