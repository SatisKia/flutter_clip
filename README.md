# flutter_clip

"Calculator Language for Immediate Processing"

Provides a function to display images drawn by the CLIP engine as widgets.

## Use this package as a library

pubspec.yaml
```yml
dependencies:
  flutter_clip:
    git:
      url: https://github.com/SatisKia/flutter_clip.git
      ref: HEAD
```

## Widget definition and construction

### Definition

1, Create a class that inherits FlutterClipWidget and set GlobalObjectKey with the setKey function.

2, Override the init function and write initialization processing that does not involve drawing.

3, Override the paint function and describe the drawing process.

Simple Example:
```dart
import 'package:flutter/cupertino.dart';

import 'package:clip/extras/canvas.dart';
import 'package:clip/extras/color_win.dart';
import 'package:clip/extras/defcharinfo.dart';
import 'package:clip/extras/easyclip.dart';
import 'package:clip/proc.dart';
import 'package:flutter_clip/widget.dart';

class HogeWidget extends FlutterClipWidget {
  GlobalObjectKey hogeKey = const GlobalObjectKey( '__HOGE_KEY__' ); // Pass unique value

  HogeWidget(double width, double height) : super(width, height){
    setKey( hogeKey );
  }

  @override
  void init() {
    // Register character information
    regGWorldDefCharInfo( 0 );

    // Register color palette
    clip().setPalette( COLOR_WIN );

    doCommandGWorld = ( width, height ){ // Called when ":gworld" command is executed
      Canvas canvas = curClip().resizeCanvas( width, height );
      canvas.setFont( 10 );
    };
    doCommandGUpdate = ( gWorld ){ // Called when ":gupdate TRUE" command is executed
      curClip().updateCanvas();
    };
  }

  @override
  bool paint() {
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
    return false;
  }
}
```

### Construction

```dart
Widget hogeWidget = HogeWidget(width, height).build();
```

## Demonstration

lib/main.dart
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
