class ProductModel {
  String? id;
  String? productName;
  String? productCode;
  String? img;
  String? unitPrice;
  String? qty;
  String? totalPrice;
  String? createdDate;

  ProductModel({
    this.id,
    this.productName,
    this.productCode,
    this.img,
    this.unitPrice,
    this.qty,
    this.totalPrice,
    this.createdDate});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'] ?? 'Unknown';
    productName = json['ProductName'] ?? 'Unknown';
    productCode = json['ProductCode'] ?? 'Unknown';
    img = json['Img'] ?? 'Unknown';
    unitPrice = json['UnitPrice'] ?? 'Unknown';
    qty = json['Qty'] ?? 'Unknown';
    totalPrice = json['TotalPrice'] ?? 'Unknown';
    createdDate = json['CreatedDate'] ?? 'Unknown';
  }
}