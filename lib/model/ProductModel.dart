// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

ProductModel productModelFromJson(String str) => ProductModel.fromJson(json.decode(str));

String productModelToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
    ProductModel({
        this.date,
        this.description,
        this.name,
        this.orderBy,
        this.price,
        this.time,
        this.urls,
        this.userAddress,
        this.userCity,
        this.userName,
        this.userPhone,
    });

    String date;
    String description;
    String name;
    String orderBy;
    String price;
    String time;
    Urls urls;
    String userAddress;
    String userCity;
    String userName;
    String userPhone;

    factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        date: json["date"],
        description: json["description"],
        name: json["name"],
        orderBy: json["orderBy"],
        price: json["price"],
        time: json["time"],
        urls: Urls.fromJson(json["urls"]),
        userAddress: json["userAddress"],
        userCity: json["userCity"],
        userName: json["userName"],
        userPhone: json["userPhone"],
    );

    Map<String, dynamic> toJson() => {
        "date": date,
        "description": description,
        "name": name,
        "orderBy": orderBy,
        "price": price,
        "time": time,
        "urls": urls.toJson(),
        "userAddress": userAddress,
        "userCity": userCity,
        "userName": userName,
        "userPhone": userPhone,
    };
}

class Urls {
    Urls();

    factory Urls.fromJson(Map<String, dynamic> json) => Urls(
    );

    Map<String, dynamic> toJson() => {
    };
}