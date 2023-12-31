// To parse this JSON data, do
//
//     final orderListModel = orderListModelFromJson(jsonString);

import 'dart:convert';

OrderListModel orderListModelFromJson(String str) =>
    OrderListModel.fromJson(json.decode(str));

String orderListModelToJson(OrderListModel data) => json.encode(data.toJson());

class OrderListModel {
  List<OrderItem>? items;
  int? total;
  int? perPage;
  int? start;
  int? end;

  OrderListModel({
    this.items,
    this.total,
    this.perPage,
    this.start,
    this.end,
  });

  factory OrderListModel.fromJson(Map<String, dynamic> json) => OrderListModel(
        items: json["items"] == null
            ? []
            : List<OrderItem>.from(
                json["items"]!.map((x) => OrderItem.fromJson(x))),
        total: json["total"],
        perPage: json["per_page"],
        start: json["start"],
        end: json["end"],
      );

  Map<String, dynamic> toJson() => {
        "items": items == null
            ? []
            : List<dynamic>.from(items!.map((x) => x.toJson())),
        "total": total,
        "per_page": perPage,
        "start": start,
        "end": end,
      };
}

class OrderItem {
  String? id;
  dynamic totalPrice;
  dynamic deliveryFee;
  String? assignedStatus;
  String? deliveryStatus;
  Client? client;
  String? code;
  DeliveryAddress? deliveryAddress;
  List<Orderitem>? orderitems;
  DateTime? created;

  OrderItem({
    this.id,
    this.totalPrice,
    this.deliveryFee,
    this.assignedStatus,
    this.deliveryStatus,
    this.client,
    this.code,
    this.deliveryAddress,
    this.orderitems,
    this.created,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        id: json["id"],
        totalPrice: json["total_price"],
        deliveryFee: json["delivery_fee"],
        assignedStatus: json["assigned_status"],
        deliveryStatus: json["delivery_status"],
        client: json["client"] == null ? null : Client.fromJson(json["client"]),
        code: json["code"],
        deliveryAddress: json["delivery_address"] == null
            ? null
            : DeliveryAddress.fromJson(json["delivery_address"]),
        orderitems: json["orderitems"] == null
            ? []
            : List<Orderitem>.from(
                json["orderitems"]!.map((x) => Orderitem.fromJson(x))),
        created:
            json["created"] == null ? null : DateTime.parse(json["created"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "total_price": totalPrice,
        "delivery_fee": deliveryFee,
        "assigned_status": assignedStatus,
        "delivery_status": deliveryStatus,
        "client": client?.toJson(),
        "code": code,
        "delivery_address": deliveryAddress?.toJson(),
        "orderitems": orderitems == null
            ? []
            : List<dynamic>.from(orderitems!.map((x) => x.toJson())),
        "created": created?.toIso8601String(),
      };
}

class Client {
  int? id;
  String? email;
  String? username;
  String? phone;
  String? firstName;
  String? lastName;
  dynamic image;
  String? code;

  Client({
    this.id,
    this.email,
    this.username,
    this.phone,
    this.firstName,
    this.lastName,
    this.image,
    this.code,
  });

  factory Client.fromJson(Map<String, dynamic> json) => Client(
        id: json["id"],
        email: json["email"],
        username: json["username"],
        phone: json["phone"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        image: json["image"],
        code: json["code"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "username": username,
        "phone": phone,
        "first_name": firstName,
        "last_name": lastName,
        "image": image,
        "code": code,
      };
}

class DeliveryAddress {
  String? id;
  String? streetAddress;
  dynamic user;
  String? title;
  String? details;
  String? recipientName;
  String? phone;
  String? country;
  String? state;
  String? city;
  bool? isCurrent;

  DeliveryAddress({
    this.id,
    this.streetAddress,
    this.user,
    this.title,
    this.details,
    this.recipientName,
    this.phone,
    this.country,
    this.state,
    this.city,
    this.isCurrent,
  });

  factory DeliveryAddress.fromJson(Map<String, dynamic> json) =>
      DeliveryAddress(
        id: json["id"],
        streetAddress: json["street_address"],
        user: json["user"],
        title: json["title"],
        details: json["details"],
        recipientName: json["recipient_name"],
        phone: json["phone"],
        country: json["country"],
        state: json["state"],
        city: json["city"],
        isCurrent: json["is_current"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "street_address": streetAddress,
        "user": user,
        "title": title,
        "details": details,
        "recipient_name": recipientName,
        "phone": phone,
        "country": country,
        "state": state,
        "city": city,
        "is_current": isCurrent,
      };
}

class Orderitem {
  String? id;
  String? product;
  int? quantity;

  Orderitem({
    this.id,
    this.product,
    this.quantity,
  });

  factory Orderitem.fromJson(Map<String, dynamic> json) => Orderitem(
        id: json["id"],
        product: json["product"],
        quantity: json["quantity"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "product": product,
        "quantity": quantity,
      };
}
