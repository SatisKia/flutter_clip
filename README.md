# flutter_clip

Calculator Language for Immediate Processing

pubspec.yaml
```yml
dependencies:
  flutter_clip:
    git:
      url: https://github.com/SatisKia/flutter_clip.git
      ref: HEAD
```

Widget:
```dart
import 'package:flutter/cupertino.dart';

import 'package:clip/extras/canvas.dart';
import 'package:clip/extras/color_win.dart';
import 'package:clip/extras/defcharinfo.dart';
import 'package:clip/extras/easyclip.dart';
import 'package:clip/proc.dart';
import 'package:flutter_clip/widget.dart';

class HogeWidget extends FlutterClipWidget {
  GlobalObjectKey hogeKey = const GlobalObjectKey( '__HOGE_KEY__' ); // 一意の値を渡す

  HogeWidget(double width, double height) : super(width, height){
    setKey( hogeKey );
  }

  @override
  void init() {
    // 文字情報を登録する
    regGWorldDefCharInfo( 0 );

    // カラー・パレットを登録する
    clip().setPalette( COLOR_WIN );

    doCommandGWorld = ( width, height ){ // ":gworld"コマンドが実行された時に呼ばれる
      Canvas canvas = curClip().resizeCanvas( width, height );
      canvas.setFont( 10 );
    };
    doCommandGUpdate = ( gWorld ){ // ":gupdate TRUE"が実行された時に呼ばれる
      curClip().updateCanvas();
    };
  }

  @override
  void paint() {
    clip().procScript( [
      ":ans FALSE",
      ":gworld 255 255",
      ":gupdate FALSE",
      "@C = 0",
      "@Y = 0",
      "for @y = 0; @y < 16; @y++",
      "  for @x = 0; @x < 16; @x++",
      "    :gfill (@x * 16) @Y 15 15 @C",
      "    if @C < 10",
      "      :sprint @@C [\"0] @C",
      "    else",
      "      :sprint @@C @C",
      "    endif",
      "    :gtext @@C (@x * 16 + 1) (@Y + 8) (255 - @C)",
      "    @C++",
      "  next",
      "  @Y += 16",
      "next",
      ":gupdate TRUE"
    ] );
  }
}
```

```dart
Widget hogeWidget = HogeWidget(width, height).build();
```

Example:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_clip/test/canvas.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State createState() => _MyHomePageState();
}

class _MyHomePageState extends State {
  double contentWidth  = 0.0;
  double contentHeight = 0.0;

  @override
  Widget build(BuildContext context) {
    contentWidth  = MediaQuery.of( context ).size.width;
    contentHeight = MediaQuery.of( context ).size.height - MediaQuery.of( context ).padding.top - MediaQuery.of( context ).padding.bottom;

    double size = contentWidth < contentHeight ? contentWidth : contentHeight;

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0
      ),
      body: CanvasTestWidget( size, size ).build(),
    );
  }
}
```
