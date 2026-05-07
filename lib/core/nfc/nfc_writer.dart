/// 写入用于绑定跑鞋记录的 NFC NDEF 数据。
import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;

class NfcWriter {
  /// 构造写入 NFC 标签的应用深链记录。
  static List<ndef.NDEFRecord> buildShoeRecords({
    required String shoeId,
    required String userId,
  }) {
    final uriString = 'shoecloud://bind/$shoeId?userId=$userId';
    final uriPayload = Uint8List.fromList([0x00, ...uriString.codeUnits]);

    final uriRecord = ndef.NDEFRecord(
      tnf: ndef.TypeNameFormat.nfcWellKnown,
      type: Uint8List.fromList([0x55]),
      payload: uriPayload,
    );

    final aarRecord = ndef.NDEFRecord(
      tnf: ndef.TypeNameFormat.nfcExternal,
      type: Uint8List.fromList('android.com:pkg'.codeUnits),
      payload: Uint8List.fromList('com.example.shoecloud'.codeUnits),
    );

    return [uriRecord, aarRecord];
  }

  /// 轮询 NFC 标签并写入跑鞋绑定数据。
  static Future<void> write({
    required String shoeId,
    required String userId,
  }) async {
    try {
      await _checkAvailability();

      final tag = await FlutterNfcKit.poll(
        timeout: const Duration(seconds: 20),
        iosAlertMessage: '请将设备靠近 NFC 芯片',
        androidPlatformSound: true,
      );

      if (tag.ndefWritable != true) {
        throw Exception('标签不可写或已被锁定');
      }

      final records = buildShoeRecords(shoeId: shoeId, userId: userId);
      await FlutterNfcKit.writeNDEFRecords(records);
      await FlutterNfcKit.finish(iosAlertMessage: '绑定成功');
    } on PlatformException catch (error) {
      await _handleError('硬件异常: ${error.message ?? 'unknown'}');
    } catch (error) {
      await _handleError(error.toString());
    } finally {
      try {
        await FlutterNfcKit.finish();
      } catch (_) {}
    }
  }

  static Future<void> _checkAvailability() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    if (availability != NFCAvailability.available) {
      throw Exception('NFC 未开启或设备不支持');
    }
  }

  static Future<void> _handleError(String message) async {
    await FlutterNfcKit.finish(iosErrorMessage: message);
    throw Exception(message);
  }
}
