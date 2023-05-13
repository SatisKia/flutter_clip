import 'package:flutter/cupertino.dart';
import 'package:dart_clip/clip.dart';

class EasyClipTest {
  void mpPrint( MPData val ){
    MultiPrec mp = ClipProc.procMultiPrec();

    int p = mp.getPrec( val );
    int l = mp.getLen( val );
    debugPrint( "len $l" );
    if( p > 0 ){
      debugPrint( "prec $p" );
    }
    if( val.val(0) < 0 ){
      debugPrint( "minus" );
    } else {
      debugPrint( "plus" );
    }

    debugPrint( "data:" );
    String data = "";
    for( int i = 1; i <= l; i++ ){
      if( i % 10 == 1 ){
        if( i != 1 ) {
          debugPrint(data);
          data = "";
        }
      } else {
        data += " ";
      }
      int k = ClipMath.pow( 10, MultiPrec.digit - 1 ).toInt();
      for( int j = 0; j < MultiPrec.digit; j++ ){
        data += "${(val.val(i) ~/ k) % 10}";
        k = k ~/ 10;
      }
    }
    debugPrint( data );

    debugPrint( "value:" );
    if( p == 0 ){
      debugPrint( mp.num2str( val ) );
    } else {
      debugPrint( mp.fnum2str( val ) );
    }
  }

  void main() {
    ClipProc.printAnsComplex = ( real, imag ){
      String str = real + imag;
      debugPrint( str );
    };
    ClipProc.printAnsMultiPrec = ( str ){
      debugPrint( str );
    };
    ClipProc.printAnsMatrix = ( param, array ){
      String str = EasyClip.curClip().getArrayTokenString( param, array, 0 );
      debugPrint( str );
    };

    EasyClip clip = EasyClip();
    clip.setMode( ClipGlobal.modeGComplex );

    double value;
    String string;
    bool isMinus;
    List<dynamic> array;
    MathMatrix matrix;
    MathValue mathValue;

    // 変数に値を設定する
    clip.setValue( 'a', 12.345 ); // CLIPでの@a
    clip.setComplex( 'b', 12.3, 4.5 ); // CLIPでの@b
    clip.setFract( 'c', -123, 45 ); // CLIPでの@c

    // 変数の値を確認する
    value = clip.getValue( 'a' ).toFloat(); debugPrint( "toFloat: $value" );
    value = clip.getValue( 'b' ).real();   debugPrint( "real: $value" );
    value = clip.getValue( 'b' ).imag();   debugPrint( "imag: $value" );
    string = clip.getComplexString( 'b' ); debugPrint( "string: $string" );
    isMinus = clip.getValue( 'c' ).fractMinus(); debugPrint( "fractMinus: ${isMinus ? "true" : "false"}" );
    value = clip.getValue( 'c' ).num();          debugPrint( "num: ${value.toInt()}" );
    value = clip.getValue( 'c' ).denom();        debugPrint( "denom: ${value.toInt()}" );
    string = clip.getFractString( 'c', false );  debugPrint( "Improper: $string" );
    string = clip.getFractString( 'c', true );   debugPrint( "Mixed: $string" );
    value = clip.getValue( 'c' ).toFloat();      debugPrint( "toFloat: $value" );

    // 配列に値を設定する
    clip.setVector( 'a', [1,2,3,4,5,6] ); // @@a{1 2 3 4 5 6}
    clip.setComplexVector( 'b', [1,0,2], [0,1,1] ); // @@b{1 i 2\+i}
    clip.setFractVector( 'c', [1,-1], [3,3] );
    clip.setMatrix( 'd', [[1,2,3],[4,5,6],[7,8,9]] ); // @@d{{1 2 3}{4 5 6}{7 8 9}}
    clip.setComplexMatrix( 'e', [[3,2],[2,5]], [[0,1],[-1,0]] ); // @@e{{3 2\+i}{2\-i 5}}
    clip.setFractMatrix( 'f', [[1,-1],[-2,2]], [[3,3],[3,3]] );
    matrix = MathMatrix( 3, 3 );
    matrix.set( 0, 0, 1.0 );
    matrix.set( 1, 1, 1.0 );
    matrix.set( 2, 2, 1.0 );
    clip.setMatrix( 'g', matrix );
    clip.setArrayValue( 'h', [0, 0], 12 ); // @@h 0 0
    clip.setArrayValue( 'h', [0, 1], 34 ); // @@h 0 1
    clip.setArrayValue( 'h', [1, 0], 56 ); // @@h 1 0
    clip.setArrayValue( 'h', [1, 1], 78 ); // @@h 1 1
    clip.setArrayComplex( 'i', [0], 12.3, 4.5 ); // @@i 0
    clip.setArrayFract( 'j', [2], 3, 7 ); // @@j 2
    clip.setString( 's', "Hello World!!" );

    // 配列の値を確認する
    clip.procLine( "@@a{{1.2 2.3}{3.4 4.5}{5.6 6.7}}" ); // @@aに二次元要素を設定
    clip.procLine( "@@a{{{11 22}{33 44}}{{55 66}{77 88}}}" ); // @@aに三次元要素を設定
    string = "@@a = ${clip.getArrayString( 'a', 6 )}"; debugPrint( string );
    array = clip.getArray( 'a' );    debugPrint( "Forcibly convert to Dart Array:" ); debugPrint( array.toString() );
    array = clip.getArray( 'a', 1 ); debugPrint( "One-dimensional element:" ); debugPrint( array.toString() ); // 一次元要素のみを取り出す
    array = clip.getArray( 'a', 2 ); debugPrint( "Two-dimensional element:" ); debugPrint( array.toString() ); // 二次元要素のみを取り出す
    array = clip.getArray( 'a', 3 ); debugPrint( "Three-dimensional element:" ); debugPrint( array.toString() ); // 三次元要素のみを取り出す
    string = "@@b = ${clip.getArrayString( 'b', 6 )}"; debugPrint( string );
    string = "@@c = ${clip.getArrayString( 'c', 6 )}"; debugPrint( string );
    string = "@@d = ${clip.getArrayString( 'd', 6 )}"; debugPrint( string );
    string = "@@e = ${clip.getArrayString( 'e', 6 )}"; debugPrint( string );
    string = "@@f = ${clip.getArrayString( 'f', 6 )}"; debugPrint( string );
    string = "@@g = ${clip.getArrayString( 'g', 6 )}"; debugPrint( string );
    string = "@@h = ${clip.getArrayString( 'h', 6 )}"; debugPrint( string );
    string = "@@i = ${clip.getArrayString( 'i', 6 )}"; debugPrint( string );
    string = "@@j = ${clip.getArrayString( 'j', 6 )}"; debugPrint( string );
    string = clip.getString( 's' ); debugPrint( "@@s = \"$string\"" );

    clip.setAnsFlag( true );

    // 計算結果の値を確認する
    clip.procLine( "@a + @b" );
    value = clip.getAnsValue().real(); debugPrint( "real: $value" );
    value = clip.getAnsValue().imag(); debugPrint( "imag: $value" );
    clip.setMode( ClipGlobal.modeMFract );
    clip.procLine( "[-]@c * 2" );
    isMinus = clip.getAnsValue().fractMinus(); debugPrint( "fractMinus: ${isMinus ? "true" : "false"}" );
    value = clip.getAnsValue().num();     debugPrint( "num: ${value.toInt()}" );
    value = clip.getAnsValue().denom();   debugPrint( "denom: ${value.toInt()}" );
    value = clip.getAnsValue().toFloat(); debugPrint( "toFloat: $value" );
    clip.setMode( ClipGlobal.modeGComplex );
    clip.procLine( "trans @@d / 3" );
    string = "Ans = ${clip.getAnsMatrixString( 6 )}"; debugPrint( string );
    matrix = clip.getAnsMatrix(); // MathMatrixオブジェクト
    debugPrint( "toFloat: " );
    debugPrint( "${matrix.toFloat( 0, 0 )},${matrix.toFloat( 0, 1 )},${matrix.toFloat( 0, 2 )}" );
    debugPrint( "${matrix.toFloat( 1, 0 )},${matrix.toFloat( 1, 1 )},${matrix.toFloat( 1, 2 )}" );
    debugPrint( "${matrix.toFloat( 2, 0 )},${matrix.toFloat( 2, 1 )},${matrix.toFloat( 2, 2 )}" );

    // 時間計算の例
    clip.setMode( ClipGlobal.modeSTime );
    clip.procLine( "48h / 10" );
    mathValue = clip.getAnsValue(); debugPrint( "${mathValue.hour()}h ${mathValue.min()}m ${mathValue.sec()}s ${mathValue.frame()}f" );
    clip.procLine( "12:00:00" );
    mathValue = clip.getAnsValue(); debugPrint( "${mathValue.hour()}h ${mathValue.min()}m ${mathValue.sec()}s ${mathValue.frame()}f" );
    clip.procLine( "+1.5h" );
    mathValue = clip.getAnsValue(); debugPrint( "${mathValue.hour()}h ${mathValue.min()}m ${mathValue.sec()}s ${mathValue.frame()}f" );
    clip.procLine( "+123m" );
    mathValue = clip.getAnsValue(); debugPrint( "${mathValue.hour()}h ${mathValue.min()}m ${mathValue.sec()}s ${mathValue.frame()}f" );
    clip.procLine( "-234" ); // 計算モードがCLIP_MODE_S_TIMEなので、単位は「秒」になる
    mathValue = clip.getAnsValue(); debugPrint( "${mathValue.hour()}h ${mathValue.min()}m ${mathValue.sec()}s ${mathValue.frame()}f" );
    clip.procLine( "+100f" );
    mathValue = clip.getAnsValue(); debugPrint( "${mathValue.hour()}h ${mathValue.min()}m ${mathValue.sec()}s ${mathValue.frame()}f" );

    // 多倍長演算
    clip.setMode( ClipGlobal.modeFMultiPrec, 100, "down" );
    debugPrint( "round down:" );
    clip.procLine( "1/3" );
    clip.setMode( ClipGlobal.modeFMultiPrec, "up" );
    debugPrint( "round up:" );
    clip.procLine( "1/3" );
    clip.setMode( ClipGlobal.modeFMultiPrec, 1000 );
    clip.procLine( "@@a=[-]sqrt 2" );
    mpPrint( clip.getMultiPrec( 'a' ) );
    MultiPrec mp = ClipProc.procMultiPrec();
    MPData mpArray = MPData();
    mp.fsqrt2( mpArray, mp.F( "2.0" ), 1000, 4 );
    mp.fneg( mpArray );
    clip.setMultiPrec( 'b', mpArray );
    if( mp.fcmp( clip.getMultiPrec( 'a' ), clip.getMultiPrec( 'b' ) ) == 0 ){
      debugPrint( "true" );
    } else {
      debugPrint( "false" );
    }
    clip.setMode( ClipGlobal.modeFMultiPrec, "down" );
    debugPrint( "round down:" );
    clip.procLine( "sqr @@b" );
    clip.setMode( ClipGlobal.modeFMultiPrec, "h_even" );
    debugPrint( "round h_even:" );
    clip.procLine( "sqr @@b" );
  }
}
