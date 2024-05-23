import 'dart:convert';
import 'package:crud_app_assignment/product_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class EditProductList extends StatefulWidget {
  final ProductModel productModel;

  const EditProductList({
    super.key,
    required this.productModel,
  });

  @override
  State<EditProductList> createState() => _EditProductListState();
}

class _EditProductListState extends State<EditProductList> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _productCodeTEController =
      TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _quantityTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _updateProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.productModel.productName ?? '';
    _productCodeTEController.text = widget.productModel.productCode ?? '';
    _unitPriceTEController.text = widget.productModel.unitPrice ?? '';
    _quantityTEController.text = widget.productModel.qty ?? '';
    _totalPriceTEController.text = widget.productModel.totalPrice ?? '';
    _imageTEController.text = widget.productModel.img ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Product List',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _nameTEController,
                decoration: const InputDecoration(
                  hintText: 'Name',
                  labelText: 'Name',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _productCodeTEController,
                decoration: const InputDecoration(
                  hintText: 'Product Code',
                  labelText: 'Product Code',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _unitPriceTEController,
                decoration: const InputDecoration(
                  hintText: 'Unit Price',
                  labelText: 'Unit Price',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _quantityTEController,
                decoration: const InputDecoration(
                  hintText: 'Quantity',
                  labelText: 'Quantity',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _totalPriceTEController,
                decoration: const InputDecoration(
                  hintText: 'Total Price',
                  labelText: 'Total Price',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                keyboardType: TextInputType.text,
                controller: _imageTEController,
                decoration: const InputDecoration(
                  hintText: 'Image',
                  labelText: 'Image',
                ),
                validator: (String? value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a valid input';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 12,
              ),
              Visibility(
                visible: _updateProductInProgress == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _updateProduct();
                    }
                  },
                  child: const Text(
                    'Edit Product',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProduct() async {
    _updateProductInProgress = true;
    setState(() {});

    Map<String, dynamic> inputData = {
      'ProductName': _nameTEController.text.trim(),
      "Img": _imageTEController.text.trim(),
      "ProductCode": _productCodeTEController.text,
      "Qty": _quantityTEController.text,
      "TotalPrice": _totalPriceTEController.text,
      "UnitPrice": _unitPriceTEController.text,
    };

    String updateProductUrl =
        'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.productModel.id}';
    Uri uri = Uri.parse(updateProductUrl);
    Response response = await post(
        uri,
        headers: {'content-type': 'application/json'},
        body: jsonEncode(inputData));

    if(response.statusCode == 200){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product Details Updated!'),
        ),
      );
      Navigator.pop(context, true);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Update Product Failed! Please try again.'),
        ),
      );
    }
    _updateProductInProgress = false;
    setState(() {});

  }

  @override
  void dispose() {
    super.dispose();
    _nameTEController.dispose();
    _productCodeTEController.dispose();
    _unitPriceTEController.dispose();
    _quantityTEController.dispose();
    _totalPriceTEController.dispose();
    _imageTEController.dispose();
  }
}
