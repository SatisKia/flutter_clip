import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';

import 'package:clip/extras/easyclip.dart';

class _FlutterClipRenderObjectWidget extends SingleChildRenderObjectWidget {
  final RenderBox renderBox;
  const _FlutterClipRenderObjectWidget(this.renderBox, {Key? key}) : super(key: key);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return renderBox;
  }
}

class _FlutterClipRenderBox extends RenderBox {
  FlutterClipWidget clipCanvas;
  GlobalObjectKey key;
  _FlutterClipRenderBox(this.clipCanvas, this.key);

  @override
  bool get sizedByParent => true;

  @override
  void performResize() {
    size = constraints.biggest;
  }

  // view上の描画領域
  double offsetX = 0.0;
  double offsetY = 0.0;
  double width   = 0.0;
  double height  = 0.0;

  @override
  void paint(PaintingContext context, ui.Offset offset) {
    int startTime = DateTime.now().millisecondsSinceEpoch;

    offsetX = offset.dx;
    offsetY = offset.dy;
    width   = key.currentContext!.size!.width;
    height  = key.currentContext!.size!.height;

    ui.Canvas c = context.canvas;
    c.save();

    // 座標軸の移動
    c.translate(offsetX, offsetY);

    // クリッピング
    c.clipRect(ui.Rect.fromLTWH(0, 0, width, height));

    clipCanvas.lock( c, ui.Paint() );
    bool loop = clipCanvas.paint();
    clipCanvas.unlock();

    c.restore();

    if( loop ){
      clipCanvas.setLastTime( DateTime.now().millisecondsSinceEpoch - startTime );
      int sleepTime = clipCanvas.frameTime() - clipCanvas.lastTime();
      if( (sleepTime < 0) || (sleepTime > clipCanvas.frameTime()) ){
        sleepTime = 0;
      }
      Future.delayed( Duration( milliseconds: sleepTime ), (){ markNeedsPaint(); } );
    }
  }
}

class FlutterClipWidget {
  late EasyClip _clip;

  late double _width;
  late double _height;

  late int _frame;
  late int _last;

  FlutterClipWidget( double width, double height ){
    _clip = EasyClip();
    setClip( _clip );
    _clip.createCanvas( width.toInt(), height.toInt() );

    _width = width;
    _height = height;

    _frame = 0;
    _last = 0;

    init();
  }

  GlobalObjectKey? _key;
  void setKey( GlobalObjectKey key ){
    _key = key;
  }

  void setFrameTime( int frameTime ){
    _frame = frameTime;
  }
  int frameTime(){
    return _frame;
  }
  void setLastTime( int lastTime ){
    _last = lastTime;
  }
  int lastTime(){
    return _last;
  }

  EasyClip clip(){
    return _clip;
  }
  double width(){
    return _width;
  }
  double height(){
    return _height;
  }

  void lock( ui.Canvas c, ui.Paint p ){
    _clip.canvas().lock( c, p );
  }
  void unlock(){
    _clip.canvas().unlock();
  }

  // オーバーライドする関数
  void init(){
    // 初期化処理
  }
  bool paint(){
    // 描画処理
    return false;
  }

  Widget build(){
    return SizedBox(
        key: _key,
        width: _width,
        height: _height,
        child: _FlutterClipRenderObjectWidget( _FlutterClipRenderBox( this, _key! ) )
    );
  }
}
