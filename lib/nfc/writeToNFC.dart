// ignore: file_names
import 'package:flutter/services.dart'; // 用于捕获 PlatformException
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;

class NDEFBuilder {
  /// 构造鞋子绑定的 URI 记录和 AAR 记录
  static List<ndef.NDEFRecord> buildShoeRecords(String shoeId) {
    // URI 记录
    final uriString = 'shoecloud://bind/$shoeId';
    final uriPayload = Uint8List.fromList([0x00, ...uriString.codeUnits]);
    final uriRecord = ndef.NDEFRecord(
      tnf: ndef.TypeNameFormat.nfcWellKnown,
      type: Uint8List.fromList([0x55]),
      payload: uriPayload,
    );

    // AAR 记录
    final aarRecord = ndef.NDEFRecord(
      tnf: ndef.TypeNameFormat.nfcExternal,
      type: Uint8List.fromList('android.com:pkg'.codeUnits),
      payload: Uint8List.fromList('com.example.shoecloud'.codeUnits),
    );

    return [uriRecord, aarRecord];
  }
}

Future<void> writeToNFC(String shoeId) async {
  try {
    // 1. 环境预检
    await _checkNFCAvailability();

    // 2. 扫描标签
    var tag = await FlutterNfcKit.poll(
      timeout: const Duration(seconds: 20),
      iosAlertMessage: "请靠近 NFC 芯片",
      androidPlatformSound: true,
    );

    // 3. 状态校验 (卫语句)
    if (tag.ndefWritable != true) throw Exception("该标签不可写");

    // 4. 执行写入
    final records = NDEFBuilder.buildShoeRecords(shoeId);
    await FlutterNfcKit.writeNDEFRecords(records);

    await FlutterNfcKit.finish(iosAlertMessage: "绑定成功！");
  } on PlatformException catch (e) {
    await _handleNFCError("硬件异常: ${e.message}");
  } catch (e) {
    await _handleNFCError(e.toString());
  } finally {
    await FlutterNfcKit.finish();
  }
}

/// 检查 NFC 是否可用
Future<void> _checkNFCAvailability() async {
  var availability = await FlutterNfcKit.nfcAvailability;
  if (availability != NFCAvailability.available) {
    throw Exception("NFC 功能未开启或不支持");
  }
}

/// 统一的错误收尾
Future<void> _handleNFCError(String message) async {
  print("【NFC Error】: $message");
  await FlutterNfcKit.finish(iosErrorMessage: message);
  throw Exception(message); // 抛出给 UI 层展示
}
