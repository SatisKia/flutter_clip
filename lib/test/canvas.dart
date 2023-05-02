import 'package:flutter/cupertino.dart';
import 'package:dart_clip/clip.dart';
import '../widget.dart';

class CanvasTestWidget extends FlutterClipWidget {
  GlobalObjectKey hogeKey = const GlobalObjectKey( '__HOGE_KEY__' ); // 一意の値を渡す

  CanvasTestWidget(double width, double height) : super(width, height){
    setKey( hogeKey );
  }

  @override
  void init() {
    // 文字情報を登録する
    regGWorldDefCharInfo( 0 );

    // カラー・パレットを登録する
    clip().setPalette( COLOR_WIN );

    EasyCanvas easyCanvas = EasyCanvas();
    gWorldLine = ( gWorld, x1, y1, x2, y2 ){
      Canvas canvas = curCanvas();
      if( gWorld.color() == 252 ){
        canvas.setStrokeWidth( 0.5 );
      } else {
        canvas.setStrokeWidth( 1.0 );
      }
      canvas.line( x1.toDouble(), y1.toDouble(), x2.toDouble(), y2.toDouble() );
    };

    errorProc = ( err, num, func, token ){
      if( func.isNotEmpty ){
        debugPrint( "$func: $num行: ${getProcErrorDefString( err, token, false, false )}" );
      } else {
        debugPrint( "$num行: ${getProcErrorDefString( err, token, false, false )}" );
      }
    };
    doCommandGWorld = ( width, height ){
      curCanvas().setFont( 10 );
    };

    // 関数の定義など、初回のみの処理はここで行ってしまう
    clip().procScript( [
      "func text3d_x",
      "    :ans FALSE",
      "    :sprint @@s @0",
      "    :gtext @@s (gx @1 - 4) (gy @2 + 9) @3",
      "end",
      "func text3d_y",
      "    :ans FALSE",
      "    :sprint @@s @0",
      "    :gtext @@s (gx @1 + 3) (gy @2 + 7) @3",
      "end",
      "func text3d_z",
      "    :ans FALSE",
      "    :sprint @@s (@0 * @4)",
      "    :gtextr @@s (gx @1) (gy @2 + 3) @3",
      "end",
      "func window3d l b r t x y z every z_scale",
      "    :ans FALSE",
      "    :window l b r t",
      "    :gclear \\xFF",
      "    for @i = [-]x, @j = 0; @i >= l; @i -= x, @j++",
      "        if @j != 0 && (@j % every) == 0",
      "            text3d_x @i @i 0 \\xF7",
      "        end",
      "    end",
      "    for @i = x, @j = 1; @i <= r; @i += x, @j++",
      "        if (@j % every) == 0",
      "            text3d_x @i @i 0 \\xF7",
      "        end",
      "    end",
      "    for @i = [-]z, @j = 0; @i >= b; @i -= z, @j++",
      "        if @j != 0 && (@j % every) == 0",
      "            text3d_z @i 0 @i \\xF7 z_scale",
      "        end",
      "    end",
      "    for @i = z, @j = 1; @i <= t; @i += z, @j++",
      "        if (@j % every) == 0",
      "            text3d_z @i 0 @i \\xF7 z_scale",
      "        end",
      "    end",
      "    for @i = [-]y, @j = 0; ; @i -= y, @j++",
      "        if @j != 0 && (@j % every) == 0",
      "            text3d_y @i (@i * \\-0.5) (@i * \\-0.5) \\xF7",
      "            if gcx < 0 || gcx >= gwidth || gcy < 0 || gcy >= gheight",
      "                break",
      "            end",
      "        end",
      "    end",
      "    for @i = y, @j = 1; ; @i += y, @j++",
      "        if (@j % every) == 0",
      "            text3d_y @i (@i * \\-0.5) (@i * \\-0.5) \\xF7",
      "            if gcx < 0 || gcx >= gwidth || gcy < 0 || gcy >= gheight",
      "                break",
      "            end",
      "        end",
      "    end",
      "    :wline l 0 r 0 \\xF7",
      "    :wline 0 b 0 t \\xF7",
      "    if b < 0 && t > 0",
      "        :wline b b 0 0 \\xF7",
      "        :wline 0 0 t t \\xF7",
      "    else",
      "        :wline b b t t \\xF7",
      "    end",
      "    :gtext [\"0] (gx 0 + 2) (gy 0 + 9) \\xF7",
      "end",
      "func proj2d &x2 &z2 x1 y1 z1",
      "    :ans FALSE",
      "    y1 *= 0.5",
      "    x2 = x1 + y1",
      "    z2 = z1 + y1",
      "end",
      "func draw3d x1 y1 z1 x2 y2 z2 color",
      "    :ans FALSE",
      "    proj2d x1 z1 x1 y1 z1",
      "    proj2d x2 z2 x2 y2 z2",
      "    :wline x1 z1 x2 z2 color",
      "end",
      "func plot3d expr[] x1 x2 x_step y1 y2 y_step z_step every z_scale",
      "    :ans FALSE",
      "    if x1 > x2; @t = x1; x1 = x2; x2 = @t; end",
      "    if y1 > y2; @t = y1; y1 = y2; y2 = @t; end",
      "    if x_step < 0; x_step = abs x_step; end",
      "    if y_step < 0; y_step = abs y_step; end",
      "    if z_step < 0; z_step = abs z_step; end",
      "    every = int every; if every == 0; every = 1; elif every < 0; every = abs every; end",
      "    if z_scale == 0; z_scale = 1; elif z_scale < 0; z_scale = abs z_scale; end",
      "    :global x y",
      "    for y = y1, @i = 0; y <= y2; y += y_step, @i++",
      "        for x = x1, @j = 0; x <= x2; x += x_step, @j++",
      "            @@a @i @j 0 = x",
      "            @@a @i @j 1 = y",
      "            @@a @i @j 2 = eval expr * z_scale",
      "        end",
      "        @X = @j",
      "    end",
      "    @Y = @i",
      "    @l = @b = @r = @t = 0",
      "    @f = TRUE # 初回フラグ",
      "    for @i = 0; @i < @Y; @i++",
      "        for @j = 0; @j < @X; @j++",
      "            proj2d @x @z (@@a @i @j 0) (@@a @i @j 1) (@@a @i @j 2)",
      "            if @f",
      "                @f = FALSE",
      "                @l = @x",
      "                @r = @x",
      "                @b = @z",
      "                @t = @z",
      "            else",
      "                if @x < @l; @l = @x; end",
      "                if @x > @r; @r = @x; end",
      "                if @z < @b; @b = @z; end",
      "                if @z > @t; @t = @z; end",
      "            end",
      "        end",
      "    end",
      "    # 正方形領域にする",
      "    if @r - @l > @t - @b",
      "        @s = ((@r - @l) - (@t - @b)) / 2",
      "        @t += @s",
      "        @b -= @s",
      "    else",
      "        @s = ((@t - @b) - (@r - @l)) / 2",
      "        @r += @s",
      "        @l -= @s",
      "    end",
      "    @c = gcolor # 現在色を取得しておく",
      "    window3d @l @b @r @t x_step y_step z_step every z_scale",
      "    if x2 - x1 >= y2 - y1",
      "        for @i = 0; @i < @Y; @i++",
      "            for @j = 1; @j < @X; @j++",
      "                @k = @j - 1",
      "                draw3d (@@a @i @k 0) (@@a @i @k 1) (@@a @i @k 2) (@@a @i @j 0) (@@a @i @j 1) (@@a @i @j 2) @c",
      "            end",
      "        end",
      "    end",
      "    if x2 - x1 <= y2 - y1",
      "        for @i = 1; @i < @Y; @i++",
      "            @k = @i - 1",
      "            for @j = 0; @j < @X; @j++",
      "                draw3d (@@a @k @j 0) (@@a @k @j 1) (@@a @k @j 2) (@@a @i @j 0) (@@a @i @j 1) (@@a @i @j 2) @c",
      "            end",
      "        end",
      "    end",
      "    :gcolor @c # 現在色を戻す",
      "end"
    ] );
  }

  @override
  bool paint() {
    clip().commandGWorld( width().toInt(), height().toInt() );
    clip().commandGColor( 252 );
    clip().procLine( "plot3d [\"exp([-\\](x*x+y*y] \\-2 2 0.2 \\-2 2 0.2 0.2 5 1" );
//    clip().updateCanvas();
    return false;
  }
}
