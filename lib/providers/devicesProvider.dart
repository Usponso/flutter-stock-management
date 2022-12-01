import 'dart:collection';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stock_management/constants.dart';
import '../modal/Device.dart';
import 'dart:core';

class DevicesProvider extends ChangeNotifier {
  String barcodeScanned = '';
  List<Device> _devices = [];

  UnmodifiableListView<Device> get devices => UnmodifiableListView(_devices);

  void postDevice(String name, String serialNumber, String price,
      String stockQuantity) async {
    Device device = Device(
        name: name,
        serialNumber: serialNumber,
        price: double.parse(price),
        stockQuantity: int.parse(stockQuantity));

    var id = await Dio().post('$API_URL/devices',
        options: Options(headers: {
          HttpHeaders.contentTypeHeader: "application/json",
        }),
        data: device.toJson());

    device.id = int.parse(id.data.toString());
    addDevice(device);
  }

  void addDevice(Device device) async {
    _devices.add(device);
    notifyListeners();
  }

  void remove(Device device) {
    _devices.remove(device);
    notifyListeners();
  }

  Future<void> refresh() async {
    getDevices(true);
  }

  Future<void> getDevices(bool refresh) async {
    if (_devices.isNotEmpty && !refresh) return;
    var response = await Dio().get('$API_URL/devices');
    _devices =
        List<Device>.from(response.data.map((value) => Device.fromJson(value)));
    notifyListeners();
  }

  Future<Device> getDeviceByScanOrClick(bool scan, String scannedSerialNumber) async {
    var response = await Dio().get('$API_URL/devices/$scannedSerialNumber?scan=$scan');
    Device device = Device.fromJson(response.data[0]);
    return device;
  }
}
