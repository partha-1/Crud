
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main (){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Crud project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      home: const ProductListScreen(),
    );
  }
}


class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {

  ProductListPojo? productListPojo;

  @override
  void initState() {
    super.initState();
    getProductListFromapi();
  }

  void getProductListFromapi () async {
    String url = 'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri uri = Uri.parse(url);
    http.Response response = await http.get(uri);
    if (response.statusCode == 200){
      productListPojo = ProductListPojo.fromJson(jsonDecode(response.body) );
      print(productListPojo?.listOfProducts?.length  ?? 0);

      setState(() {

      });

    }

    print(response.statusCode);
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AddNewProduct()));
        },
        child: const Icon(Icons.add),

      ),
      appBar: AppBar(
        title: const Text('Product List'),

      ),

      body: ListView.builder(
          itemCount: productListPojo?.listOfProducts?.length ?? 0,
          itemBuilder: (context,index){
            return ListTile(
              title: Text(productListPojo?.listOfProducts? [index].productName?? ""),
              subtitle: Text(productListPojo?.listOfProducts? [index].productCode?? ""),
              trailing: Text(productListPojo?.listOfProducts? [index].unitPrice?? ''),
            );
          }),
    );
  }
}

class ProductListPojo {
  String? status;
  List<Product>? listOfProducts;

  ProductListPojo({this.status, this.listOfProducts});

  ProductListPojo.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      listOfProducts = <Product>[];
      json['data'].forEach((v) {
        listOfProducts!.add(new Product.fromJson(v));
      });
    }
  }

}

class Product {
  String? sId;
  String? productName;
  String? productCode;
  String? img;
  String? unitPrice;
  String? qty;
  String? totalPrice;
  String? createdDate;

  Product(
      {this.sId,
        this.productName,
        this.productCode,
        this.img,
        this.unitPrice,
        this.qty,
        this.totalPrice,
        this.createdDate});

  Product.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productName = json['ProductName'];
    productCode = json['ProductCode'];
    img = json['Img'];
    unitPrice = json['UnitPrice'];
    qty = json['Qty'];
    totalPrice = json['TotalPrice'];
    createdDate = json['CreatedDate'];
  }


}



class AddNewProduct extends StatefulWidget {
  const AddNewProduct({super.key});

  @override
  State<AddNewProduct> createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  TextEditingController _productNameETController = TextEditingController();
  TextEditingController _productCodeETController = TextEditingController();
  TextEditingController _productUnitPriceETController = TextEditingController();
  TextEditingController _productImageETController = TextEditingController();
  TextEditingController _productQuantityETController = TextEditingController();
  TextEditingController _productTotalPriceETController = TextEditingController();

  GlobalKey<FormState> _form = GlobalKey(); // set unicidentifire for from

  Future<void> addANewProduct(String name, String productCode, String quantity,
      String image, String unitPrice, String totalPrice) async {

    //URL
    String url ='https://crud.teamrabbil.com/api/v1/CreateProduct';
    Uri uri = Uri.parse(url);
    http.Response response = await http.post(uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept' : 'application/json'
        },

        body: jsonEncode({
        "Img":image,
        "ProductCode": productCode,
        "ProductName": name,
        "Qty":quantity,
        "TotalPrice":totalPrice,
        "UnitPrice": unitPrice
      })
    );
    if (response.statusCode == 200){
      print(response.body);
      print('Product added successfully');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('product added successful')));

      _productImageETController.text = '';
      _productTotalPriceETController.text = '';
      _productUnitPriceETController.text = '';
      _productNameETController.text = '';
      _productCodeETController.text = '';
      _productQuantityETController.text = '';
    }else {
      print('failed');
    }

    
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADD new product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  Form(
          key: _form,
          child: Column(
            children: [
              TextFormField(
                validator: (String? value){
                  if (value?.isEmpty ?? true){
                    return 'Please enter your product name';
                  }
                  return null;
                },
                controller: _productNameETController,
                decoration: InputDecoration(
                  hintText: 'Product Name'
                ),
              ),TextField(
                controller: _productCodeETController,
                decoration: InputDecoration(
                  hintText: 'Product Code'
                ),
              ),TextField(
                keyboardType: TextInputType.number,
                controller: _productUnitPriceETController,
                decoration: InputDecoration(
                  hintText: 'Unit Price'
                ),
              ),TextField(
                controller: _productImageETController,
                decoration: InputDecoration(
                  hintText: ' Image'
                ),
              ),TextField(
                keyboardType: TextInputType.number,
                controller: _productQuantityETController,
                decoration: InputDecoration(
                  hintText: 'Quantity'
                ),
              ),TextField(
                keyboardType: TextInputType.number,
                controller: _productTotalPriceETController,
                decoration: InputDecoration(
                  hintText: 'Total Price'
                ),
              ),
              ElevatedButton(onPressed: (){
                if (_form.currentState!.validate()) {
                addANewProduct(
                  _productNameETController.text,
                  _productCodeETController.text,
                  _productQuantityETController.text,
                  _productImageETController.text,
                  _productUnitPriceETController.text,
                  _productTotalPriceETController.text,

                );}
              }, child: Text('add product'))
            ],
          ),
        ),
      ),
    );
  }
}

