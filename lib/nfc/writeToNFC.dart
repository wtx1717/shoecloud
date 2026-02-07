// ignore: file_names
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'dart:typed_data';

// 该方法用于将鞋的唯一标识符写入NFC标签
Future<void> writeToNFC(String shoeId) async {
  var tag = await FlutterNfcKit.poll(timeout: const Duration(seconds: 20));

  if (tag.ndefWritable == true) {
    // 1. 手动构造 URI 记录
    // NDEF 规范中，0x00 表示没有前缀
    final uriString = 'shoecloud://bind/$shoeId';
    final uriPayload = Uint8List.fromList([0x00, ...uriString.codeUnits]);

    final uriRecord = ndef.NDEFRecord(
      tnf: ndef.TypeNameFormat.nfcWellKnown, // TNF = 1
      type: Uint8List.fromList([0x55]), // Type = "U" (URI)
      payload: uriPayload,
    );

    // 2. 手动构造 AAR 记录
    final aarString = 'android.com:pkg';
    final pkgName = 'com.example.shoecloud';

    final aarRecord = ndef.NDEFRecord(
      tnf: ndef.TypeNameFormat.nfcExternal, // TNF = 4
      type: Uint8List.fromList(aarString.codeUnits),
      payload: Uint8List.fromList(pkgName.codeUnits),
    );

    // 写入：URI 必须在第 1 位，AAR 必须在第 2 位
    await FlutterNfcKit.writeNDEFRecords([uriRecord, aarRecord]);
    print("【写入调试】已尝试用原始 NDEF 格式写入: $uriString");
  }
  await FlutterNfcKit.finish();
}
