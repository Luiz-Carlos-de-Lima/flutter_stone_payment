class StoneDeviceInfo {
  final String seriallNumber;
  final String deviceModel;

  StoneDeviceInfo({required this.seriallNumber, required this.deviceModel});

  static StoneDeviceInfo fromJson({required Map json}) {
    return StoneDeviceInfo(seriallNumber: json['serialNumber'], deviceModel: json['deviceModel']);
  }

  Map<String, dynamic> toJson() {
    return {'serialNumber': seriallNumber, 'deviceModel': deviceModel};
  }
}
