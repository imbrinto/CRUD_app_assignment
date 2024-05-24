import 'dart:convert';

import 'package:crud_app_assignment/add_product_list.dart';
import 'package:crud_app_assignment/edit_product_list.dart';
import 'package:crud_app_assignment/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isGetProductInProgress = true;
  List<dynamic> productList = [];

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crud App',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: RefreshIndicator(
          onRefresh: _getProductList,
          child: Visibility(
            visible: isGetProductInProgress == false,
            replacement: const Center(child: CircularProgressIndicator()),
            child: ListView.separated(
              itemCount: productList.length,
              itemBuilder: (context, index) {
                return _buildProductList(productList[index]);
              },
              separatorBuilder: (_, __) => const Divider(),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductList(),
            ),
          );
          if(result){
            return _getProductList();
          }
        },
      ),
    );
  }

  Widget _buildProductList(ProductModel productModel) {
    return ListTile(
      leading: Image(
        image: NetworkImage(productModel.img!),
        height: 45,
        width: 45,
        // displayed a loader until fetching the image from the api.
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return const CircularProgressIndicator();
        },
        // handled error if there is any invalid argument in productModel.img
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.error);
        },
      ),
      title: Text(
        productModel.productName ?? 'Unknown',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Wrap(
        children: [
          Text(
            'Product Code: ${productModel.productCode}',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          Text(
            'Unit Price: ${productModel.unitPrice} ',
            style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          Text(
            'Quantity: ${productModel.qty}',
            style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          Text(
            'Total Price: ${productModel.totalPrice}',
            style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProductList(productModel : productModel,),
                  ),
                );
                if(result){
                  return _getProductList();
                }
              },
              icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: () {
              _showDeleteConfirmationDialog(productModel.id!);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmationDialog(String productId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete"),
        content: const Text('Are you  sure you want to delete this product?'),
        actions: [
          TextButton(
              onPressed: () {
                _deleteProduct(productId);
                Navigator.pop(context);
              },
              child: const Text('Yes, delete')),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('No')),
        ],
      ),
    );
  }

  Future<void> _getProductList() async {
    isGetProductInProgress = true;
    setState(() {});
    const String getProductUrl =
        'https://crud.teamrabbil.com/api/v1/ReadProduct';
    productList.clear();
    Uri uri = Uri.parse(getProductUrl);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      final decodeData = jsonDecode(response.body);
      List<dynamic> jsonProductList = decodeData['data'];
      for (Map<String, dynamic> json in jsonProductList) {
        ProductModel productModel = ProductModel.fromJson(json);
        productList.add(productModel);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't get products list. Please try again"),
        ),
      );
    }
    isGetProductInProgress = false;
    setState(() {});
  }

  Future<void> _deleteProduct(String productId) async {
    isGetProductInProgress = true;
    setState(() {});
    String deleteProductUrl =
        'https://crud.teamrabbil.com/api/v1/DeleteProduct/$productId';
    productList.clear();
    Uri uri = Uri.parse(deleteProductUrl);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      _getProductList();
    } else {
      isGetProductInProgress = false;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Couldn't Delete product. Please try again"),
        ),
      );
    }

  }
}
