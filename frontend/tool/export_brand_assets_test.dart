// Executado explicitamente com flutter test para usar o rasterizador do Flutter.
// Não faz parte da suíte test/: é uma ferramenta de exportação de identidade.
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('exportar marca RTM a partir do SVG fonte', () async {
    final source = await File('assets/brand/rtm-mark.svg').readAsString();
    final lightSource = source.replaceAll('#FF6978', '#B82D49');
    final brand = Directory('../docs/design/brand');
    await brand.create(recursive: true);
    await File('${brand.path}/rtm-mark.svg').writeAsString(source);
    await File('${brand.path}/rtm-mark-light.svg').writeAsString(lightSource);
    final appIcon = source
        .replaceFirst('viewBox="0 0 64 64"', 'viewBox="0 0 80 80"')
        .replaceFirst(
          '<path ',
          '<rect width="80" height="80" fill="#100F14"/><g transform="translate(8 8)"><path ',
        )
        .replaceFirst('</svg>', '</g></svg>');
    await File('${brand.path}/rtm-app-icon.svg').writeAsString(appIcon);
    final mark = await vg.loadPicture(SvgStringLoader(source), null);
    final light = await vg.loadPicture(SvgStringLoader(lightSource), null);
    final icon = await vg.loadPicture(SvgStringLoader(appIcon), null);

    Future<Uint8List> png(PictureInfo picture, int size) async {
      final recorder = ui.PictureRecorder();
      final canvas = ui.Canvas(recorder)
        ..scale(size / picture.size.width, size / picture.size.height);
      canvas.drawPicture(picture.picture);
      final rendered = recorder.endRecording();
      final image = await rendered.toImage(size, size);
      final Uint8List bytes;
      if (identical(picture, icon)) {
        // Ícones Apple exigem PNG sem canal alfa, mesmo se opaco.
        final rgba = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!.buffer.asUint8List();
        bytes = opaquePng(rgba, size);
      } else {
        bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer
            .asUint8List();
      }
      image.dispose();
      rendered.dispose();
      return bytes;
    }

    final cache = <int, Uint8List>{};
    Future<void> writeIcon(String path, int size) async {
      final data = cache[size] ??= await png(icon, size);
      await File(path).writeAsBytes(data);
    }

    await File('${brand.path}/rtm-mark.png')
        .writeAsBytes(await png(mark, 1024));
    await File('${brand.path}/rtm-mark-light.png')
        .writeAsBytes(await png(light, 1024));
    await writeIcon('${brand.path}/rtm-app-icon.png', 1024);
    for (final entry in {
      'mdpi': 48,
      'hdpi': 72,
      'xhdpi': 96,
      'xxhdpi': 144,
      'xxxhdpi': 192,
    }.entries) {
      await writeIcon(
        'android/app/src/main/res/mipmap-${entry.key}/ic_launcher.png',
        entry.value,
      );
    }
    for (final platform in ['ios', 'macos']) {
      final folder = '$platform/Runner/Assets.xcassets/AppIcon.appiconset';
      final manifest = jsonDecode(
        await File('$folder/Contents.json').readAsString(),
      ) as Map<String, dynamic>;
      for (final image
          in (manifest['images'] as List).cast<Map<String, dynamic>>()) {
        final size = double.parse((image['size'] as String).split('x').first);
        final scale = double.parse(
          (image['scale'] as String).replaceAll('x', ''),
        );
        await writeIcon('$folder/${image['filename']}', (size * scale).round());
      }
    }
    await writeIcon('web/favicon.png', 32);
    for (final size in [192, 512]) {
      await writeIcon('web/icons/Icon-$size.png', size);
      await writeIcon('web/icons/Icon-maskable-$size.png', size);
    }
    // ICO contém PNGs em múltiplas resoluções, sem biblioteca adicional.
    final entries = <Uint8List>[];
    final sizes = [16, 24, 32, 48, 64, 128, 256];
    for (final size in sizes) {
      entries.add(cache[size] ??= await png(icon, size));
    }
    final header = ByteData(6 + entries.length * 16)
      ..setUint16(2, 1, Endian.little)
      ..setUint16(4, entries.length, Endian.little);
    var offset = header.lengthInBytes;
    for (var i = 0; i < entries.length; i++) {
      final p = 6 + i * 16;
      header.setUint8(p, sizes[i] == 256 ? 0 : sizes[i]);
      header.setUint8(p + 1, sizes[i] == 256 ? 0 : sizes[i]);
      header.setUint16(p + 4, 1, Endian.little);
      header.setUint16(p + 6, 32, Endian.little);
      header.setUint32(p + 8, entries[i].length, Endian.little);
      header.setUint32(p + 12, offset, Endian.little);
      offset += entries[i].length;
    }
    await File('windows/runner/resources/app_icon.ico').writeAsBytes(
      (BytesBuilder()
            ..add(header.buffer.asUint8List())
            ..add(entries.expand((e) => e).toList()))
          .takeBytes(),
    );

    final font = FontLoader('Poppins')
      ..addFont(
        Future.value(
          ByteData.sublistView(
            await File('fonts/Poppins-Bold.ttf').readAsBytes(),
          ),
        ),
      );
    await font.load();
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    canvas.drawColor(const ui.Color(0xFF100F14), ui.BlendMode.src);
    canvas.drawRect(
      const ui.Rect.fromLTWH(720, 0, 720, 800),
      ui.Paint()..color = const ui.Color(0xFFFFFBFF),
    );
    void text(String value, double x, double y, double size, ui.Color color) {
      final builder =
          ui.ParagraphBuilder(
              ui.ParagraphStyle(fontFamily: 'Poppins', fontSize: size),
            )
            ..pushStyle(ui.TextStyle(color: color))
            ..addText(value);
      final paragraph = builder.build()
        ..layout(const ui.ParagraphConstraints(width: 600));
      canvas.drawParagraph(paragraph, ui.Offset(x, y));
    }

    void draw(PictureInfo picture, double x, double y, double size) {
      canvas.save();
      canvas.translate(x, y);
      canvas.scale(size / picture.size.width);
      canvas.drawPicture(picture.picture);
      canvas.restore();
    }

    for (var i = 0; i < 2; i++) {
      final x = i * 720.0;
      final fg = ui.Color(i == 0 ? 0xFFF6F1F4 : 0xFF241E28);
      final secondary = ui.Color(i == 0 ? 0xFFB5ADBD : 0xFF65596D);
      final picture = i == 0 ? mark : light;
      text('RTM / PROPOSTA DE MARCA', x + 64, 46, 16, secondary);
      draw(picture, x + 48, 144, 220);
      text('RTM', x + 290, 160, 100, fg);
      text('Rate That Movie', x + 296, 300, 22, secondary);
      canvas.drawLine(
        ui.Offset(x + 64, 420),
        ui.Offset(x + 656, 420),
        ui.Paint()..color = secondary.withValues(alpha: .25),
      );
      text(i == 0 ? 'TEMA ESCURO' : 'TEMA CLARO', x + 64, 454, 13, secondary);
      var sx = x + 64;
      for (final size in [24, 32, 48, 64]) {
        draw(picture, sx, 510, size.toDouble());
        text('$size', sx, 600, 12, secondary);
        sx += 90;
      }
      final rect = ui.RRect.fromRectAndRadius(
        ui.Rect.fromLTWH(x + 514, 490, 120, 120),
        const ui.Radius.circular(28),
      );
      canvas.save();
      canvas.clipRRect(rect);
      draw(icon, x + 514, 490, 120);
      canvas.restore();
      text('Ingresso + estrela', x + 64, 696, 20, fg);
      text('Cinema e avaliação em uma só forma.', x + 64, 735, 15, secondary);
    }
    final board = recorder.endRecording();
    final image = await board.toImage(1440, 800);
    await File('${brand.path}/rtm-brand-preview.png').writeAsBytes(
      (await image.toByteData(format: ui.ImageByteFormat.png))!.buffer
          .asUint8List(),
    );
    image.dispose();
    board.dispose();
    mark.picture.dispose();
    light.picture.dispose();
    icon.picture.dispose();
  });
}

/// PNG RGB (tipo 2), sem alfa e sem dependência de um encoder adicional.
Uint8List opaquePng(Uint8List rgba, int size) {
  final rows = BytesBuilder();
  for (var y = 0; y < size; y++) {
    rows.addByte(0); // Filtro PNG None.
    for (var x = 0; x < size; x++) {
      final p = (y * size + x) * 4;
      if (rgba[p + 3] != 255) throw StateError('O ícone deve ter fundo opaco.');
      rows.add([rgba[p], rgba[p + 1], rgba[p + 2]]);
    }
  }
  final output = BytesBuilder()..add([137, 80, 78, 71, 13, 10, 26, 10]);
  void chunk(String name, Uint8List data) {
    final type = ascii.encode(name);
    var crc = 0xFFFFFFFF;
    for (final byte in [...type, ...data]) {
      crc ^= byte;
      for (var b = 0; b < 8; b++) {
        crc = (crc & 1) != 0 ? (crc >> 1) ^ 0xEDB88320 : crc >> 1;
      }
    }
    output.add(
      (ByteData(4)..setUint32(0, data.length, Endian.big)).buffer.asUint8List(),
    );
    output.add(type);
    output.add(data);
    output.add(
      (ByteData(
        4,
      )..setUint32(0, crc ^ 0xFFFFFFFF, Endian.big)).buffer.asUint8List(),
    );
  }

  final header = ByteData(13)
    ..setUint32(0, size, Endian.big)
    ..setUint32(4, size, Endian.big)
    ..setUint8(8, 8)
    ..setUint8(9, 2);
  chunk('IHDR', header.buffer.asUint8List());
  chunk('IDAT', Uint8List.fromList(ZLibEncoder().convert(rows.takeBytes())));
  chunk('IEND', Uint8List(0));
  return output.takeBytes();
}
