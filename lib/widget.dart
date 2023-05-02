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
    clipCanvas.paint();
    clipCanvas.unlock();

    c.restore();
  }
}

class FlutterClipWidget {
  late EasyClip _clip;

  late double _width;
  late double _height;

  FlutterClipWidget( double width, double height ){
    _clip = EasyClip();
    setClip( _clip );
    _clip.createCanvas();

    _width = width;
    _height = height;

    init();
  }

  GlobalObjectKey? _key;
  void setKey( GlobalObjectKey key ){
    _key = key;
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
  void paint(){
    // 描画処理
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
