class VerifyDetailModel {
  int? status;
  String? message;
  Data? data;

  VerifyDetailModel({this.status, this.message, this.data});

  VerifyDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  GetVeifyDetails? getVeifyDetails;

  Data({this.getVeifyDetails});

  Data.fromJson(Map<String, dynamic> json) {
    getVeifyDetails = json['GetVeifyDetails'] != null
        ? GetVeifyDetails.fromJson(json['GetVeifyDetails'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (getVeifyDetails != null) {
      data['GetVeifyDetails'] = getVeifyDetails!.toJson();
    }
    return data;
  }
}

class GetVeifyDetails {
  String? sId;
  String? wiFiIP;
  int? radius;
  double? latitude;
  double? longitude;
  String? createdAt;
  String? updatedAt;
  int? iV;

  GetVeifyDetails(
      {this.sId,
        this.wiFiIP,
        this.radius,
        this.latitude,
        this.longitude,
        this.createdAt,
        this.updatedAt,
        this.iV});

  GetVeifyDetails.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    wiFiIP = json['WiFi_IP'];
    radius = json['radius'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['WiFi_IP'] = wiFiIP;
    data['radius'] = radius;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}
