import 'dart:convert';

ChartsModel chartsModelFromJson(String str) =>
    ChartsModel.fromJson(json.decode(str));

String chartsModelToJson(ChartsModel data) => json.encode(data.toJson());

class ChartsModel {
  String orderID;
  double profit;
  String city;
  String customerName;
  String productName;
  String rowID;
  String country;
  double discount;
  String customerID;
  String region;
  int quantity;
  String segment;
  String state;
  String shipMode;
  String subCategory;
  String postalCode;
  String shipDate;
  String category;
  String productID;
  double sales;
  String orderDate;

  DateTime parseDate() {
    return DateTime(
      int.parse(
        orderDate.length == 10
            ? orderDate.substring(6, 9)
            : orderDate.substring(5, 8),
      ),
    );
  }

  ChartsModel(
      {required this.orderID,
      required this.profit,
      required this.city,
      required this.customerName,
      required this.productName,
      required this.rowID,
      required this.country,
      required this.discount,
      required this.customerID,
      required this.region,
      required this.quantity,
      required this.segment,
      required this.state,
      required this.shipMode,
      required this.subCategory,
      required this.postalCode,
      required this.shipDate,
      required this.category,
      required this.productID,
      required this.sales,
      required this.orderDate});

  factory ChartsModel.fromJson(Map<String, dynamic> json) => ChartsModel(
        orderID: json['Order ID'],
        profit: double.parse(json['Profit']),
        city: json['City'],
        customerName: json['Customer Name'],
        productName: json['Product Name'],
        rowID: json['Row ID'],
        country: json['Country'],
        discount: double.parse(json['Discount']),
        customerID: json['Customer ID'],
        region: json['Region'],
        quantity: int.parse(json['Quantity']),
        segment: json['Segment'],
        state: json['State'],
        shipMode: json['Ship Mode'],
        subCategory: json['Sub-Category'],
        postalCode: json['Postal Code'],
        shipDate: json['Ship Date'],
        category: json['Category'],
        productID: json['Product ID'],
        sales: double.parse(json['Sales']),
        orderDate: json['Order Date'],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Order ID'] = orderID;
    data['Profit'] = profit;
    data['City'] = city;
    data['Customer Name'] = customerName;
    data['Product Name'] = productName;
    data['Row ID'] = rowID;
    data['Country'] = country;
    data['Discount'] = discount;
    data['Customer ID'] = customerID;
    data['Region'] = region;
    data['Quantity'] = quantity;
    data['Segment'] = segment;
    data['State'] = state;
    data['Ship Mode'] = shipMode;
    data['Sub-Category'] = subCategory;
    data['Postal Code'] = postalCode;
    data['Ship Date'] = shipDate;
    data['Category'] = category;
    data['Product ID'] = productID;
    data['Sales'] = sales;
    data['Order Date'] = orderDate;
    return data;
  }
}
