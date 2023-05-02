import 'package:flutter/cupertino.dart';
import 'package:dart_clip/clip.dart';
import '../widget.dart';

class LoopTest1Widget extends FlutterClipWidget {
  GlobalObjectKey key = const GlobalObjectKey('__HOGE_KEY__'); // 一意の値を渡す

  LoopTest1Widget(double width, double height) : super(width, height) {
    setKey( key );
  }

  // ライフ・ゲーム
  List<List<String>> script = [
    [
      ":ans 0",

      ":gworld (@M + 2) (@N + 2) # オフスクリーンを設定する",

      "#",
      "# 初期形状を盤に配置する",
      "#",
      "@m = int ((@M + 2) / 2 - @@0 0 / 2) # 初期形状が盤の中央にくるようにオフセット計算する",
      "@n = int ((@N + 2) / 2 - @@0 1 / 2) # 初期形状が盤の中央にくるようにオフセット計算する",
      "for @j = 0; @j < @@0 1; @j++",
      "  for @i = 0; @i < @@0 0; @i++",
      "    @@a (@n + @j) (@m + @i) = @@0 (2 + @j * @@0 0 + @i)",
      "  next",
      "next",

      "@g = 1 # 世代"
    ],
    [
      "#",
      "# メイン",
      "#",
      ":gput @@a # 配列の内容をオフスクリーンに描画",
//      ":sprint @@s [\"Generation ] @g",
//      ":gtext @@s 2 9 255",
      "@G = @g",
      "for @i = 1; @i <= @N; @i++",
      "  for @j = 1; @j <= @M; @j++",
      "    if @@a @i @j",
      "      @@b (@i - 1) (@j - 1)++; @@b (@i - 1) @j++; @@b (@i - 1) (@j + 1)++",
      "      @@b  @i      (@j - 1)++;                    @@b  @i      (@j + 1)++",
      "      @@b (@i + 1) (@j - 1)++; @@b (@i + 1) @j++; @@b (@i + 1) (@j + 1)++",
      "    endif",
      "  next",
      "next",
      "for @i = 0; @i <= @N + 1; @i++",
      "  for @j = 0; @j <= @M + 1; @j++",
      "    if @@b @i @j != 2",
      "      if @@b @i @j == 3; @@a @i @j++; else; @@a @i @j = 0; endif",
      "      if @@a @i @j >= 255; @@a @i @j = 1; endif",
      "    endif",
      "    @@b @i @j = 0",
      "  next",
      "next",
      "@g++ # 次の世代"
    ]
  ];

  @override
  void init() {
    // 文字情報を登録する
    regGWorldDefCharInfo( 0 );

    int i;
    clip().newPalette();
    clip().setPaletteColor( 0, 0xE0E0E0 );
    for( i = 1; i < 255; i += 3 ){
      clip().setPaletteColor( i, 0xFFE0FF );
    }
    for( i = 2; i < 255; i += 3 ){
      clip().setPaletteColor( i, 0xFF70FF );
    }
    for( i = 3; i < 255; i += 3 ){
      clip().setPaletteColor( i, 0xFF00FF );
    }
    clip().setPaletteColor( 255, 0x000000 );
    clip().setVector( '0', [7,3,0,1,0,0,0,0,0,0,0,0,1,0,0,0,1,1,0,0,1,1,1] ); // 初期形状：どんぐり
    clip().setValue( 'M', 79 ); // 盤の幅
    clip().setValue( 'N', 79 ); // 盤の高さ
    clip().procScript( script[0] ); // 初期化

    setFrameTime( 500 );
  }

  @override
  bool paint() {
    clip().procScript( script[1] ); // メイン
//		clip().procLine( ":gtext [\"Draw Time ${lastTime()}] 2 (gheight - 2) 255" );
    clip().updateCanvas( scale() );

    Canvas canvas = clip().canvas();
    canvas.setColorRGB( 0x000000 );
    canvas.setFont( 12 );
    canvas.drawString( "Generation ${clip().getValue( 'G' ).toFloat().toInt()}", 4, 16 );
    canvas.drawString( "Draw Time ${lastTime()}", 4, canvas.height() - 4 );

    return true;
  }
}

class LoopTest2Widget extends FlutterClipWidget {
  GlobalObjectKey key = const GlobalObjectKey('__FUGA_KEY__'); // 一意の値を渡す

  LoopTest2Widget(double width, double height) : super(width, height) {
    setKey( key );
  }

  // ライフ・ゲーム（周期的境界条件）
  List<List<String>> script = [
    [
      ":ans 0",

      "@M--",
      "@N--",

      ":gworld (@M + 1) (@N + 1) # オフスクリーンを設定する",

      "#",
      "# 初期形状を盤に配置する",
      "#",
      "@m = int ((@M + 1) / 2 - @@0 0 / 2) # 初期形状が盤の中央にくるようにオフセット計算する",
      "@n = int ((@N + 1) / 2 - @@0 1 / 2) # 初期形状が盤の中央にくるようにオフセット計算する",
      "for @j = 0; @j < @@0 1; @j++",
      "  for @i = 0; @i < @@0 0; @i++",
      "    @@a (@n + @j) (@m + @i) = @@0 (2 + @j * @@0 0 + @i)",
      "  next",
      "next",

      "@g = 1 # 世代"
    ],
    [
      "#",
      "# メイン",
      "#",
      ":gput @@a # 配列の内容をオフスクリーンに描画",
//      ":sprint @@s [\"Generation ] @g",
//      ":gtext @@s 2 9 255",
      "@G = @g",
      "for @i = 0; @i <= @N; @i++",
      "  for @j = 0; @j <= @M; @j++",
      "    if @@a @i @j",
      "      @@i 0 = @i - 1 < 0 ? @N (@i - 1)",
      "      @@i 1 = @i + 1 > @N ? 0 (@i + 1)",
      "      @@j 0 = @j - 1 < 0 ? @M (@j - 1)",
      "      @@j 1 = @j + 1 > @M ? 0 (@j + 1)",
      "      @@b (@@i 0) (@@j 0)++; @@b (@@i 0) @j++; @@b (@@i 0) (@@j 1)++",
      "      @@b  @i     (@@j 0)++;                   @@b  @i     (@@j 1)++",
      "      @@b (@@i 1) (@@j 0)++; @@b (@@i 1) @j++; @@b (@@i 1) (@@j 1)++",
      "    endif",
      "  next",
      "next",
      "for @i = 0; @i <= @N; @i++",
      "  for @j = 0; @j <= @M; @j++",
      "    if @@b @i @j != 2",
      "      if @@b @i @j == 3; @@a @i @j++; else; @@a @i @j = 0; endif",
      "      if @@a @i @j >= 255; @@a @i @j = 1; endif",
      "    endif",
      "    @@b @i @j = 0",
      "  next",
      "next",
      "@g++ # 次の世代"
    ]
  ];

  @override
  void init() {
    // 文字情報を登録する
    regGWorldDefCharInfo( 0 );

    int i;
    clip().newPalette();
    clip().setPaletteColor( 0, 0xE0E0E0 );
    for( i = 1; i < 255; i += 3 ){
      clip().setPaletteColor( i, 0xE0FFFF );
    }
    for( i = 2; i < 255; i += 3 ){
      clip().setPaletteColor( i, 0x70FFFF );
    }
    for( i = 3; i < 255; i += 3 ){
      clip().setPaletteColor( i, 0x00FFFF );
    }
    clip().setPaletteColor( 255, 0x000000 );
    clip().setVector( '0', [3,3,0,1,1,1,1,0,0,1,0] ); // 初期形状：rペントミノ
    clip().setValue( 'M', 81 ); // 盤の幅
    clip().setValue( 'N', 81 ); // 盤の高さ
    clip().procScript( script[0] ); // 初期化

    setFrameTime( 500 );
  }

  @override
  bool paint() {
    clip().procScript( script[1] ); // メイン
//		clip().procLine( ":gtext [\"Draw Time ${lastTime()}] 2 (gheight - 2) 255" );
    clip().updateCanvas( scale() );

    Canvas canvas = clip().canvas();
    canvas.setColorRGB( 0x000000 );
    canvas.setFont( 12 );
    canvas.drawString( "Generation ${clip().getValue( 'G' ).toFloat().toInt()}", 4, 16 );
    canvas.drawString( "Draw Time ${lastTime()}", 4, canvas.height() - 4 );

    return true;
  }
}

class LoopTest3Widget extends FlutterClipWidget {
  GlobalObjectKey key = const GlobalObjectKey( '__PIYO_KEY__' ); // 一意の値を渡す

  LoopTest3Widget(double width, double height) : super(width, height){
    setKey( key );
  }

  // 迷路
  List<List<String>> script = [
    [
      ":label width     @0",
      ":label height    @1",
      ":label forecolor @2",
      ":label backcolor @3",
      ":ans 0",

      "@@d { # 変位ベクトル",
      "  { 2 0 \\-2 0 } # X方向",
      "  { 0 2 0 \\-2 } # Y方向",
      "}",
      "@@t { # 方向表",
      "  { 0 1 2 3 } { 0 1 3 2 } { 0 2 1 3 } { 0 2 3 1 } { 0 3 1 2 } { 0 3 2 1 }",
      "  { 1 0 2 3 } { 1 0 3 2 } { 1 2 0 3 } { 1 2 3 0 } { 1 3 0 2 } { 1 3 2 0 }",
      "  { 2 0 1 3 } { 2 0 3 1 } { 2 1 0 3 } { 2 1 3 0 } { 2 3 0 1 } { 2 3 1 0 }",
      "  { 3 0 1 2 } { 3 0 2 1 } { 3 1 0 2 } { 3 1 2 0 } { 3 2 0 1 } { 3 2 1 0 }",
      "}",

      "width  = int (width  / 2) * 2 # 偶数にする",
      "height = int (height / 2) * 2 # 偶数にする",
      ":gworld (width + 1) (height + 1) # オフスクリーンを設定する",
      ":srand time # 時刻で乱数を初期化",

      "#",
      "# 地図を初期化",
      "#",
      ":gfill 0 0 (width + 1) (height + 1) forecolor",
      ":gfill 3 3 (width - 5) (height - 5) backcolor",
      ":gput 2 3 backcolor # スタート地点",
      ":gput (width - 2) (height - 3) backcolor # ゴール地点",

      "#",
      "# サイトを加える",
      "#",
      "@s = 0",
      "for @i = 4; @i <= width - 4; @i += 2",
      "  @@x @s = @i; @@y @s = 2;          @s++",
      "  @@x @s = @i; @@y @s = height - 2; @s++",
      "next",
      "for @j = 4; @j <= height - 4; @j += 2",
      "  @@x @s = 2;         @@y @s = @j; @s++",
      "  @@x @s = width - 2; @@y @s = @j; @s++",
      "next",

      "@S = TRUE"
    ],
    [
      "if [!]@S || @s [!=] 0",
      "  do",
      "    if @S",
      "      #",
      "      # サイトを選ぶ",
      "      #",
      "      @s--; @r = int (@s * (rand / (RAND_MAX + 1.0)))",
      "      @i = @@x @r; @@x @r = @@x @s",
      "      @j = @@y @r; @@y @r = @@y @s",
      "      @S = FALSE",
      "    endif",

      "    #",
      "    # そこから延ばしていく",
      "    #",
      "    @T = int (24 * (rand / (RAND_MAX + 1.0)))",
      "    for @d = 3; @d >= 0; @d--",
      "      @t = @@t @T @d; @I = @i + @@d 0 @t; @J = @j + @@d 1 @t",
      "      if gget @I @J == backcolor; break; endif",
      "    next",
      "    if @d < 0; @S = TRUE; endif",
      "  until @S && @s [!=] 0",

      "  if [!]@S",
      "    :gput ((@i + @I) / 2) ((@j + @J) / 2) forecolor",
      "    @i = @I; @j = @J; :gput @i @j forecolor",
      "    @@x @s = @i; @@y @s = @j; @s++",
      "  endif",
      "endif"
    ]
  ];

  @override
  void init() {
    clip().newPalette();
    clip().setPaletteColor( 0, 0x000000 );
    clip().setPaletteColor( 1, 0xFFFFFF );
    clip().setValue( '0', 80 ); // 迷路の横の大きさ
    clip().setValue( '1', 80 ); // 迷路の縦の大きさ
    clip().setValue( '2', 0 ); // 前景色
    clip().setValue( '3', 1 ); // 背景色
    clip().procScript( script[0] ); // 初期化

    setFrameTime( 0 );
  }

  @override
  bool paint() {
    clip().procScript( script[1] ); // メイン
    if( clip().getValue( 'S' ).toFloat() != 0 && clip().getValue( 's' ).toFloat() == 0 ){
      clip().setPaletteColor( 0, 0xFF0000 );
      clip().updateCanvas( scale() );
      return false;
    }
    clip().updateCanvas( scale() );
    return true;
  }
}
