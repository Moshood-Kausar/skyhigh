
import 'dart:convert';

ChartsModel chartsModelFromJson(String str) => ChartsModel.fromJson(json.decode(str));

String chartsModelToJson(ChartsModel data) => json.encode(data.toJson());
class ChartsModel {
  String? orderID;
  String? profit;
  String? city;
  String? customerName;
  String? productName;
  String? rowID;
  String? country;
  String? discount;
  String? customerID;
  String? region;
  String? quantity;
  String? segment;
  String? state;
  String? shipMode;
  String? subCategory;
  String? postalCode;
  String? shipDate;
  String? category;
  String? productID;
  String? sales;
  String? orderDate;

  ChartsModel(
      {this.orderID,
      this.profit,
      this.city,
      this.customerName,
      this.productName,
      this.rowID,
      this.country,
      this.discount,
      this.customerID,
      this.region,
      this.quantity,
      this.segment,
      this.state,
      this.shipMode,
      this.subCategory,
      this.postalCode,
      this.shipDate,
      this.category,
      this.productID,
      this.sales,
      this.orderDate});

  ChartsModel.fromJson(Map<String, dynamic> json) {
    orderID = json['Order ID'];
    profit = json['Profit'];
    city = json['City'];
    customerName = json['Customer Name'];
    productName = json['Product Name'];
    rowID = json['Row ID'];
    country = json['Country'];
    discount = json['Discount'];
    customerID = json['Customer ID'];
    region = json['Region'];
    quantity = json['Quantity'];
    segment = json['Segment'];
    state = json['State'];
    shipMode = json['Ship Mode'];
    subCategory = json['Sub-Category'];
    postalCode = json['Postal Code'];
    shipDate = json['Ship Date'];
    category = json['Category'];
    productID = json['Product ID'];
    sales = json['Sales'];
    orderDate = json['Order Date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Order ID'] = this.orderID;
    data['Profit'] = this.profit;
    data['City'] = this.city;
    data['Customer Name'] = this.customerName;
    data['Product Name'] = this.productName;
    data['Row ID'] = this.rowID;
    data['Country'] = this.country;
    data['Discount'] = this.discount;
    data['Customer ID'] = this.customerID;
    data['Region'] = this.region;
    data['Quantity'] = this.quantity;
    data['Segment'] = this.segment;
    data['State'] = this.state;
    data['Ship Mode'] = this.shipMode;
    data['Sub-Category'] = this.subCategory;
    data['Postal Code'] = this.postalCode;
    data['Ship Date'] = this.shipDate;
    data['Category'] = this.category;
    data['Product ID'] = this.productID;
    data['Sales'] = this.sales;
    data['Order Date'] = this.orderDate;
    return data;
  }
}