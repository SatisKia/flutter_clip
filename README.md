# flutter_clip

"Calculator Language for Immediate Processing"

Provides a function to display graphics drawn by the CLIP engine as widgets.

## Use this package as a library

pubspec.yaml
```yml
dependencies:
  flutter_clip: ^1.0.3
```

## Widget definition and construction

### Definition

1, Create a class that inherits `FlutterClipWidget` and set `GlobalObjectKey` with the `setKey` function.

2, Override the `init` function and write initialization processing that does not involve drawing.

3, Override the `paint` function and describe the drawing process.

Simple Example:
```dart
import 'package:flutter/cupertino.dart';
import 'package:dart_clip/clip.dart';
import 'package:flutter_clip/flutter_clip.dart';

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
    clip().setPalette( colorWin );

    ClipProc.doCommandGUpdate = ( gWorld ){ // Called when ":gupdate TRUE" command is executed
      EasyClip.curClip().updateCanvas();
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

### Animation

By setting the return value of the `paint` function to `true`, the `paint` function will be called repeatedly at millisecond intervals set by the member function `setFrameTime` of `FlutterClipWidget`.

```dart
void setFrameTime( int frameTime )
```

To stop the animation, set the return value of the `paint` function to `false`.

The last drawing time (ms) can be obtained with the member function `lastTime` of `FlutterClipWidget`.

```dart
int lastTime()
```

## Demonstration

lib/main.dart
```dart
import 'package:flutter/material.dart';
import 'package:flutter_clip/flutter_clip.dart';

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
    double size2 = (contentWidth > contentHeight ? contentWidth : contentHeight) / 2;

    Widget body = CanvasTestWidget( size, size ).build();
//    Widget body = Column( children:[ LoopTest1Widget( size2, size2 ).build(), LoopTest2Widget( size2, size2 ).build() ] );
//    Widget body = LoopTest3Widget( size, size ).build();

    return Scaffold(
      appBar: AppBar(
          toolbarHeight: 0
      ),
      body: body,
    );
  }
}
```
