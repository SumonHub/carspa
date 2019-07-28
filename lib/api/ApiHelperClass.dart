class CarType {
  var id;
  String name;
  String carImage;

  CarType({this.id, this.name, this.carImage});

  @override
  String toString() {
    return 'CarType {CarType_id: $id, duration: $name, carImage: $carImage,}';
  }
}

class Service {
  /*
  * {
            "id": "1",
            "duration": "120",
            "price": "7.80",
            "car_type_id": "1",
            "addons_id": "a:2:{i:0;s:1:\"1\";i:1;s:1:\"2\";}",
            "image": "service-image/x8smo4AnSzj43xZfLefMxk4HqjPmCvisEiaGpqHS.jpeg",
            "status": "Active",
            "created_at": null,
            "updated_at": null,
            "service_name": "Fast SPA",
            "description": "Trunk and inside vacuum\r\nDashboard and center console\r\nCleaning dust from air vent\r\nExterior: wash with special product\r\nRim and wheels",
            "name": "SUV"
        }
  * */

  var service_id;
  String duration;
  String price;
  String subscription_price;
  String addons_serialized_id;
  String image;
  String service_name;
  String description;

  Service(
      this.service_id,
      this.duration,
      this.price,
      this.subscription_price,
      this.addons_serialized_id,
      this.image,
      this.service_name,
      this.description);

  @override
  String toString() {
    return 'Service{service_id: $service_id, duration: $duration, price: $price, subscription_price : $subscription_price,  addons_id: $addons_serialized_id, image: $image, service_name: $service_name, description: $description }';
  }

/*  Service(this.id, this.duration, this.price, this.car_type_id, this.addons_id,
      this.image, this.status, this.service_name, this.description, this.name);*/

}

class Addons {
  /* "data": [
  {
  "id": "1",
  "duration": "20",
  "price": "2.00",
  "status": "Active",
  "created_at": null,
  "updated_at": null,
  "addons_name": "Air Fresher Clean",
  "locale": "en"
  }
  ]*/

  String addons_id;
  String duration;
  String price;
  String addons_name;

  Addons(this.addons_id, this.duration, this.price, this.addons_name);

  @override
  String toString() {
    return '{ \n Addons{addons_id: $addons_id, \n duration: $duration,\n price: $price,\n addons_name: $addons_name \n }';
  }
}

class Schedule {
  /* {
  "id": "1",
  "opening_time": "8:15 AM",
  "closing_time": "8:15 PM",
  "status": "Active",
  "created_at": null,
  "updated_at": null,
  "day_name": "Sunday"
  },*/
  String schedule_id, openning_time, clossing_time, day_name;

  Schedule(
      {this.schedule_id,
      this.openning_time,
      this.clossing_time,
      this.day_name});

  @override
  String toString() {
    return '{ \n Schedules {schedule_id: $schedule_id, \n openning_time: $openning_time,\n clossing_time: $clossing_time,\n day_name: $day_name \n }';
  }
}

class UserProfile {
  var id;
  String first_name;
  String last_name;
  String email;
  String email_verified_at;
  String phone;
  String address;
  String status;
  String created_at;
  String updated_at;

  UserProfile({
    this.id,
    this.first_name,
    this.last_name,
    this.email,
    this.email_verified_at,
    this.phone,
    this.address,
    this.status,
    this.created_at,
    this.updated_at,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return null;
    }
    return UserProfile(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      email_verified_at: json['email_verified_at'],
      phone: json['phone'],
      address: json['address'],
      status: json['status'],
      created_at: json['created_at'],
      updated_at: json['updated_at'],
    );
  }
}

class OrderHistory {
  String service_name;
  String amount;
  String order_type;
  String status;
  String created_at;

  OrderHistory({
    this.service_name,
    this.amount,
    this.order_type,
    this.status,
    this.created_at,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
      service_name: json['service_name'],
      amount: json['amount'],
      order_type: json['order_type'],
      status: json['status'],
      created_at: json['created_at'],
    );
  }

  @override
  String toString() {
    return 'OrderHistory{service_name: $service_name, amount: $amount, order_type: $order_type, status: $status, created_at: $created_at}';
  }
}

class Address_Book {
  String id;
  String customer_id;
  String selected_area_id;
  String address_name;
  String block;
  String street;
  String building;
  String avenue;
  String floor;
  String apartment;
  String phone_number;
  String area_name;

  Address_Book({
    this.id,
    this.customer_id,
    this.selected_area_id,
    this.address_name,
    this.block,
    this.street,
    this.building,
    this.avenue,
    this.floor,
    this.apartment,
    this.phone_number,
    this.area_name,
  });

/* factory Address_Book.fromJson(Map<String,dynamic> json){
    return Address_Book(
      id: json['id'],
      customer_id: json['customer_id'],
      selected_area_id: json['selected_area_id'],
      address_name: json['address_name'],
      block: json['block'],
      street: json['street'],
      building: json['building'],
      avenue: json['avenue'],
      floor: json['floor'],
      apartment: json['apartment'],
      phone_number: json['phone_number'],
      area_name: json['area_name'],
    );
  }*/
}

class SuggestedArea {
  String checked_area_id;
  String area_name;

  SuggestedArea({
    this.checked_area_id,
    this.area_name,
  });

  factory SuggestedArea.fromJson(Map<String, dynamic> json) {
    return SuggestedArea(
      checked_area_id: json['checked_area_id'],
      area_name: json['area_name'],
    );
  }

  @override
  String toString() {
    return 'area_name : $area_name + checked_area_id : $checked_area_id';
  }
}
