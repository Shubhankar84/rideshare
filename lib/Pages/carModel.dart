class CarModel {
  String? carName;
  String? carNo;
  int? seats;
  String? sId;

  CarModel({this.carName, this.carNo, this.seats, this.sId});

  CarModel.fromJson(Map<String, dynamic> json) {
    carName = json['carName'];
    carNo = json['carNo'];
    seats = json['seats'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['carName'] = this.carName;
    data['carNo'] = this.carNo;
    data['seats'] = this.seats;
    data['_id'] = this.sId;
    return data;
  }
}