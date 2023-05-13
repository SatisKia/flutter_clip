import 'package:flutter/cupertino.dart';
import 'package:dart_clip/clip.dart';

class MathTest {
  void test( String s, bool b ){
    String ss = s;
    if( ss.isNotEmpty ) ss += " ";
    ss += b ? "OK" : "NG";
    debugPrint( ss );
  }

  String _toString( dynamic x ){
    String s = "";
    if( x is List ){
      for( int i = 0; i < x.length; i++ ){
        if( i != 0 ){
          s += ", ";
        }
        s += "${x[i]}";
      }
    } else if( x is MathComplex ){
      s += "( ${x.real()}, ${x.imag()} )";
    } else if( x is MathValue ){
      if( x.imag() == 0.0 ){
        s += "${x.real()}";
      } else {
        s += "( ${x.real()}, ${x.imag()} )";
      }
    } else if( x is MathMatrix ){
      int i, j;
      for( i = 0; i < x.row(); i++ ){
        s += (i == 0) ? "[[ " : "[ ";
        for( j = 0; j < x.col(); j++ ){
          if( j != 0 ){
            s += ", ";
          }
          s += _toString( x.val( i, j ) );
        }
        s += (i == x.row() - 1) ? " ]]" : " ],";
      }
    } else {
      s += "${ClipMath.toDouble(x)}";
    }
    return s;
  }

  int time = 0;
  void startTest( String str ){
    time = DateTime.now().millisecondsSinceEpoch;
    debugPrint( str );
  }
  void endTest(){
    debugPrint( "${DateTime.now().millisecondsSinceEpoch - time} ms" );
  }

  void main(){
    testMath1();
    testMath2();
    testMath3();
    testComplex();
    testMatrix();
  }

  // すべてのセミ数値演算関数のテスト
  void testMath1(){
    startTest( "[testing function, part 1]" );

    ParamInteger x = ParamInteger();
    ParamFloat y = ParamFloat();

    debugPrint( "ceil" );
    test( "", MathValue.floatToValue( -5.1 ).ceil().equal( -5.0 ) );
    test( "", MathValue.floatToValue( -5.0 ).ceil().equal( -5.0 ) );
    test( "", MathValue.floatToValue( -4.9 ).ceil().equal( -4.0 ) );
    test( "", MathValue.floatToValue( 0.0 ).ceil().equal( 0.0 ) );
    test( "", MathValue.floatToValue( 4.9 ).ceil().equal( 5.0 ) );
    test( "", MathValue.floatToValue( 5.0 ).ceil().equal( 5.0 ) );
    test( "", MathValue.floatToValue( 5.1 ).ceil().equal( 6.0 ) );

    debugPrint( "abs" );
    test( "", MathValue.floatToValue( -5.0 ).abs().equal( 5.0 ) );
    test( "", MathValue.floatToValue( 0.0 ).abs().equal( 0.0 ) );
    test( "", MathValue.floatToValue( 5.0 ).abs().equal( 5.0 ) );

    debugPrint( "floor" );
    test( "", MathValue.floatToValue( -5.1 ).floor().equal( -6.0 ) );
    test( "", MathValue.floatToValue( -5.0 ).floor().equal( -5.0 ) );
    test( "", MathValue.floatToValue( -4.9 ).floor().equal( -5.0 ) );
    test( "", MathValue.floatToValue( 0.0 ).floor().equal( 0.0 ) );
    test( "", MathValue.floatToValue( 4.9 ).floor().equal( 4.0 ) );
    test( "", MathValue.floatToValue( 5.0 ).floor().equal( 5.0 ) );
    test( "", MathValue.floatToValue( 5.1 ).floor().equal( 5.0 ) );

    debugPrint( "mod" );
    test( "", MathValue.floatToValue( -7.0 ).mod( 3.0 ).equal( -1.0 ) );
debugPrint( "${MathValue.floatToValue( -7.0 ).mod( 3.0 ).toFloat()} ${-1.0}" );
    test( "", MathValue.floatToValue( -3.0 ).mod( 3.0 ).equal( 0.0 ) );
    test( "", MathValue.floatToValue( -2.0 ).mod( 3.0 ).equal( -2.0 ) );
debugPrint( "${MathValue.floatToValue( -2.0 ).mod( 3.0 ).toFloat()} ${-2.0}" );
    test( "", MathValue.floatToValue( 0.0 ).mod( 3.0 ).equal( 0.0 ) );
    test( "", MathValue.floatToValue( 2.0 ).mod( 3.0 ).equal( 2.0 ) );
    test( "", MathValue.floatToValue( 3.0 ).mod( 3.0 ).equal( 0.0 ) );
    test( "", MathValue.floatToValue( 7.0 ).mod( 3.0 ).equal( 1.0 ) );

    debugPrint( "frexp" );
    test( "", ClipMath.approx( MathValue.floatToValue( -3.0 ).frexp( x ).toFloat(), -0.75 ) && (x.val() == 2) );
    test( "", ClipMath.approx( MathValue.floatToValue( -0.5 ).frexp( x ).toFloat(), -0.5 ) && (x.val() == 0) );
    test( "", MathValue.floatToValue( 0.0 ).frexp( x ).equal( 0.0 ) && (x.val() == 0) );
    test( "", ClipMath.approx( MathValue.floatToValue( 0.33 ).frexp( x ).toFloat(), 0.66 ) && (x.val() == -1) );
    test( "", ClipMath.approx( MathValue.floatToValue( 0.66 ).frexp( x ).toFloat(), 0.66 ) && (x.val() == 0) );
    test( "", ClipMath.approx( MathValue.floatToValue( 96.0 ).frexp( x ).toFloat(), 0.75 ) && (x.val() == 7) );

    debugPrint( "ldexp" );
    test( "", MathValue.floatToValue( -3.0 ).ldexp( 4 ).equal( -48.0 ) );
    test( "", MathValue.floatToValue( -0.5 ).ldexp( 0 ).equal( -0.5 ) );
    test( "", MathValue.floatToValue( 0.0 ).ldexp( 36 ).equal( 0.0 ) );
    test( "", ClipMath.approx( MathValue.floatToValue( 0.66 ).ldexp( -1 ).toFloat(), 0.33 ) );
    test( "", MathValue.floatToValue( 96 ).ldexp( -3 ).equal( 12.0 ) );

    debugPrint( "modf" );
    test( "", MathValue.floatToValue( -11.7 ).modf( y ).equal( -0.7 ) && (y.val() == -11.0) );
    test( "", MathValue.floatToValue( -0.5 ).modf( y ).equal( -0.5 ) && (y.val() == 0.0) );
    test( "", MathValue.floatToValue( 0.0 ).modf( y ).equal( 0.0 ) && (y.val() == 0.0) );
    test( "", MathValue.floatToValue( 0.6 ).modf( y ).equal( 0.6 ) && (y.val() == 0.0) );
    test( "", MathValue.floatToValue( 12.0 ).modf( y ).equal( 0.0 ) && (y.val() == 12.0) );

    endTest();
  }

  // さまざまなπ/4の倍数に対するすべての三角関数のテスト
  void testMath2(){
    startTest( "[testing function, part 2]" );

    double piby4   = 0.78539816339744830962;
    double rthalf  = 0.70710678118654752440;
    double dblMax = 1.7976931348623158e+308;

    debugPrint( "facos" );
    test( "", ClipMath.approx( MathComplex.facos( -1.0 ), 4.0 * piby4 ) );
    test( "", ClipMath.approx( MathComplex.facos( -rthalf ), 3.0 * piby4 ) );
    test( "", ClipMath.approx( MathComplex.facos( 0.0 ), 2.0 * piby4 ) );
    test( "", ClipMath.approx( MathComplex.facos( rthalf ), piby4 ) );
    test( "", ClipMath.approx( MathComplex.facos( 1.0 ), 0.0 ) );

    debugPrint( "fasin" );
    test( "", ClipMath.approx( MathComplex.fasin( -1.0 ), -2.0 * piby4 ) );
    test( "", ClipMath.approx( MathComplex.fasin( -rthalf ), -piby4 ) );
    test( "", ClipMath.approx( MathComplex.fasin( 0.0 ), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.fasin( rthalf ), piby4 ) );
    test( "", ClipMath.approx( MathComplex.fasin( 1.0 ), 2.0 * piby4 ) );

    debugPrint( "fatan" );
    test( "", ClipMath.approx( MathComplex.fatan( -dblMax ), -2.0 * piby4 ) );
    test( "", ClipMath.approx( MathComplex.fatan( -1.0 ), -piby4 ) );
    test( "", ClipMath.approx( MathComplex.fatan( 0.0 ), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.fatan( 1.0 ), piby4 ) );
    test( "", ClipMath.approx( MathComplex.fatan( dblMax ), 2.0 * piby4 ) );

    debugPrint( "fatan2" );
    test( "", ClipMath.approx( MathComplex.fatan2( -1.0, -1.0 ), -3.0 * piby4 ) );
    test( "", ClipMath.approx( MathComplex.fatan2( -1.0, 0.0 ), -2.0 * piby4 ) );
    test( "", ClipMath.approx( MathComplex.fatan2( -1.0, 1.0 ), -piby4 ) );
    test( "", ClipMath.approx( MathComplex.fatan2( 0.0, 1.0 ), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.fatan2( 1.0, 1.0 ), piby4 ) );
    test( "", ClipMath.approx( MathComplex.fatan2( 1.0, 0.0 ), 2.0 * piby4 ) );
    test( "", ClipMath.approx( MathComplex.fatan2( 1.0, -1.0 ), 3.0 * piby4 ) );
    test( "", ClipMath.approx( MathComplex.fatan2( 0.0, -1.0 ), 4.0 * piby4 ) || ClipMath.approx( MathComplex.fatan2( 0.0, -1.0 ), -4.0 * piby4 ) );

    debugPrint( "fcos" );
    test( "", ClipMath.approx( MathComplex.fcos( -3.0 * piby4 ), -rthalf ) );
    test( "", ClipMath.approx( MathComplex.fcos( -2.0 * piby4 ), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.fcos( -piby4 ), rthalf ) );
    test( "", ClipMath.approx( MathComplex.fcos( 0.0 ), 1.0 ) );
    test( "", ClipMath.approx( MathComplex.fcos( piby4 ), rthalf ) );
    test( "", ClipMath.approx( MathComplex.fcos( 2.0 * piby4 ), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.fcos( 3.0 * piby4 ), -rthalf ) );
    test( "", ClipMath.approx( MathComplex.fcos( 4.0 * piby4 ), -1.0 ) );

    debugPrint( "fsin" );
    test( "", ClipMath.approx( MathComplex.fsin( -3.0 * piby4 ), -rthalf ) );
    test( "", ClipMath.approx( MathComplex.fsin( -2.0 * piby4 ), -1.0 ) );
    test( "", ClipMath.approx( MathComplex.fsin( -piby4 ), -rthalf ) );
    test( "", ClipMath.approx( MathComplex.fsin( 0.0 ), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.fsin( piby4 ), rthalf ) );
    test( "", ClipMath.approx( MathComplex.fsin( 2.0 * piby4 ), 1.0 ) );
    test( "", ClipMath.approx( MathComplex.fsin( 3.0 * piby4 ), rthalf ) );
    test( "", ClipMath.approx( MathComplex.fsin( 4.0 * piby4 ), 0.0 ) );

    debugPrint( "ftan" );
    test( "", ClipMath.approx( MathComplex.ftan( -3.0 * piby4 ), 1.0 ) );
    test( "", ClipMath.approx( MathComplex.ftan( -piby4 ), -1.0 ) );
    test( "", ClipMath.approx( MathComplex.ftan( 0.0 ), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.ftan( piby4 ), 1.0 ) );
    test( "", ClipMath.approx( MathComplex.ftan( 3.0 * piby4 ), -1.0 ) );

    endTest();
  }

  // 指数関数、対数関数、特殊べき乗関数のすべてのテスト
  void testMath3(){
    startTest( "[testing function, part 3]" );

    double e      = 2.71828182845904523536;
    double ln2    = 0.69314718055994530942;
    double rthalf = 0.70710678118654752440;

    debugPrint( "facosh" );
    test( "", ClipMath.approx( MathComplex.facosh( 1.0 ), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.facosh( (e + 1.0 / e) / 2.0 ), 1.0 ) );

    debugPrint( "fasinh" );
    test( "", ClipMath.approx( MathComplex.fasinh( -(e - 1.0 / e) / 2.0 ), -1.0 ) );
    test( "", ClipMath.approx( MathComplex.fasinh( 0.0 ), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.fasinh( (e - 1.0 / e) / 2.0 ), 1.0 ) );

    debugPrint( "fatanh" );
    test( "", ClipMath.approx( MathComplex.fatanh( -(e * e - 1.0) / (e * e + 1.0) ), -1.0 ) );
    test( "", ClipMath.approx( MathComplex.fatanh( 0.0 ), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.fatanh( (e * e - 1.0) / (e * e + 1.0) ), 1.0 ) );

    debugPrint( "fcosh" );
    test( "", ClipMath.approx( MathComplex.fcosh( -1.0 ), (e + 1.0 / e) / 2.0 ) );
    test( "", ClipMath.approx( MathComplex.fcosh( 0.0 ), 1.0 ) );
    test( "", ClipMath.approx( MathComplex.fcosh( 1.0 ), (e + 1.0 / e) / 2.0 ) );

    debugPrint( "exp" );
    test( "", ClipMath.approx( MathComplex.floatToComplex( -1.0 ).exp().toFloat(), 1.0 / e ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 0.0 ).exp().toFloat(), 1.0 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( ln2 ).exp().toFloat(), 2.0 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 1.0 ).exp().toFloat(), e ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 3.0 ).exp().toFloat(), e * e * e ) );

    debugPrint( "exp10" );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 0.0 ).exp10().toFloat(), 1.0 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 1.0 - MathComplex.floatToComplex( 2.0 ).log10().toFloat() ).exp10().toFloat(), 5.0 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 5.0 ).exp10().toFloat(), 1e5 ) );
debugPrint( "${MathComplex.floatToComplex( 5.0 ).exp10().toFloat()} ${1e5}" );

    debugPrint( "log" );
    test( "", MathComplex.floatToComplex( 1.0 ).log().toFloat() == 0.0 );
    test( "", ClipMath.approx( MathComplex.floatToComplex( e ).log().toFloat(), 1.0 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( (e * e * e) ).log().toFloat(), 3.0 ) );

    debugPrint( "log10" );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 1.0 ).log10().toFloat(), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 5.0 ).log10().toFloat(), 1.0 - MathComplex.floatToComplex( 2.0 ).log10().toFloat() ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 1e5 ).log10().toFloat(), 5.0 ) );

    debugPrint( "pow" );
    test( "", ClipMath.approx( MathComplex.floatToComplex( -2.5 ).pow( 2.0 ).toFloat(), 6.25 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( -2.0 ).pow( -3.0 ).toFloat(), -0.125 ) );
    test( "", MathComplex.floatToComplex( 0.0 ).pow( 6.0 ).toFloat() == 0.0 );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 2.0 ).pow( -0.5 ).toFloat(), rthalf ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 3.0 ).pow( 4.0 ).toFloat(), 81.0 ) );

    debugPrint( "fsinh" );
    test( "", ClipMath.approx( MathComplex.fsinh( -1.0 ), -(e - 1.0 / e) / 2.0 ) );
    test( "", ClipMath.approx( MathComplex.fsinh( 0.0 ), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.fsinh( 1.0 ), (e - 1.0 / e) / 2.0 ) );

    debugPrint( "sqr" );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 0.0 ).sqr().toFloat(), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( rthalf ).sqr().toFloat(), 0.5 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 1.0 ).sqr().toFloat(), 1.0 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 1.0 / rthalf ).sqr().toFloat(), 2.0 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 12.0 ).sqr().toFloat(), 144.0 ) );

    debugPrint( "sqrt" );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 0.0 ).sqrt().toFloat(), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 0.5 ).sqrt().toFloat(), rthalf ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 1.0 ).sqrt().toFloat(), 1.0 ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 2.0 ).sqrt().toFloat(), 1.0 / rthalf ) );
    test( "", ClipMath.approx( MathComplex.floatToComplex( 144.0 ).sqrt().toFloat(), 12.0 ) );

    debugPrint( "ftanh" );
    test( "", ClipMath.approx( MathComplex.ftanh( -1.0 ), -(e * e - 1.0) / (e * e + 1.0) ) );
    test( "", ClipMath.approx( MathComplex.ftanh( 0.0 ), 0.0 ) );
    test( "", ClipMath.approx( MathComplex.ftanh( 1.0 ), (e * e - 1.0) / (e * e + 1.0) ) );

    endTest();
  }

  // complexのテスト
  void testComplex(){
    startTest( "[testing complex]" );

    // complexの性質のテスト
    MathComplex fc0 = MathComplex();
    MathComplex fc1 = MathComplex.floatToComplex( 1 );
    MathComplex fc2 = MathComplex( 2, 2 );
    test( "fc0=${_toString( fc0 )}", fc0.real() == 0 && fc0.imag() == 0 );
    test( "fc1=${_toString( fc1 )}", fc1.real() == 1 && fc1.imag() == 0 );
    test( "fc2=${_toString( fc2 )}", fc2.real() == 2 && fc2.imag() == 2 );
    fc0.addAndAss( fc2 ); test( "addAndAss", fc0.real() ==  2 && fc0.imag() == 2 );
    fc0.subAndAss( fc1 ); test( "subAndAss", fc0.real() ==  1 && fc0.imag() == 2 );
    fc0.mulAndAss( fc2 ); test( "mulAndAss", fc0.real() == -2 && fc0.imag() == 6 );
    fc0.divAndAss( fc2 ); test( "divAndAss", fc0.real() ==  1 && fc0.imag() == 2 );

    // 算術のテスト
    fc0.ass( MathComplex( -4, -5 ) );                   test( "ass"  , fc0.real() == -4 && fc0.imag() == -5 );
    fc0.ass( MathComplex.floatToComplex( 2 ).add( fc2 ).add( 3 ) ); test( "add"  , fc0.real() ==  7 && fc0.imag() ==  2 );
    fc0.ass( MathComplex.floatToComplex( 2 ).sub( fc2 ).sub( 3 ) ); test( "sub"  , fc0.real() == -3 && fc0.imag() == -2 );
    fc0.ass( MathComplex.floatToComplex( 2 ).mul( fc2 ).mul( 3 ) ); test( "mul"  , fc0.real() == 12 && fc0.imag() == 12 );
    fc0.ass( MathComplex.floatToComplex( 8 ).div( fc2 ).div( 2 ) ); test( "div"  , fc0.real() ==  1 && fc0.imag() == -1 );
    fc0.ass( fc1.add( fc2.minus() ) );                  test( "minus", fc0.real() == -1 && fc0.imag() == -2 );
    test( "equal"   , fc2.equal   ( fc2 ) && fc1.equal   ( 1 ) && MathComplex.floatToComplex( 1 ).equal   ( fc1 ) );
    test( "notEqual", fc1.notEqual( fc2 ) && fc1.notEqual( 0 ) && MathComplex.floatToComplex( 3 ).notEqual( fc1 ) );

    // 数学関数のテスト
    double e      = 2.7182818284590452353602875;
    double ln2    = 0.6931471805599453094172321;
    double piby4  = 0.7853981633974483096156608;
    double rthalf = 0.7071067811865475244008444;
    double c1 = rthalf * (e + 1 / e) / 2;
    double s1 = rthalf * (e - 1 / e) / 2;
    test( "fabs", ClipMath.approx( MathComplex( 5, -12 ).fabs(), 13 ) );
    test( "farg", fc1.farg() == 0 && ClipMath.approx( fc2.farg(), piby4 ) );
    test( "conjg", fc2.conjg().equal( MathComplex( 2, -2 ) ) );
    fc0.ass( MathComplex( piby4, -1 ).cos() );  test( "cos" , ClipMath.approx( fc0.real(), c1 ) && ClipMath.approx( fc0.imag(), s1 ) );
    fc0.ass( MathComplex( -1, piby4 ).cosh() ); test( "cosh", ClipMath.approx( fc0.real(), c1 ) && ClipMath.approx( fc0.imag(), -s1 ) );
    fc0.ass( fc1.exp() );                       test( "exp" , ClipMath.approx( fc0.real(), e ) && fc0.imag() == 0 );
    fc0.ass( MathComplex( 1, -piby4 ).exp() );  test( "exp" , ClipMath.approx( fc0.real(), e * rthalf ) && ClipMath.approx( fc0.imag(), -e * rthalf ) );
    fc0.ass( MathComplex( 1, -1 ).log() );      test( "log" , ClipMath.approx( fc0.real(), ln2 / 2 ) && ClipMath.approx( fc0.imag(), -piby4 ) );
    test( "norm", MathComplex( 3, -4 ).fnorm() == 25 && fc2.fnorm() == 8 );
    fc0.polar( 1, -piby4 ); test( "polar", ClipMath.approx( fc0.real(), rthalf ) && ClipMath.approx( fc0.imag(), -rthalf ) );
    fc0.ass( fc2.pow( fc2 ) );
    fc0.ass( fc2.pow( 5 ) ); test( "pow", ClipMath.approx( fc0.real(), -128 ) && ClipMath.approx( fc0.imag(), -128 ) );
debugPrint( _toString( fc0 ) );
    fc0.ass( fc2.pow( 2 ) ); test( "pow", ClipMath.approx( fc0.real(), 0 ) && ClipMath.approx( fc0.imag(), 8 ) );
debugPrint( _toString( fc0 ) );
    fc0.ass( MathComplex.floatToComplex( 2 ).pow( fc2 ) );
    fc0.ass( MathComplex( piby4, -1 ).sin() );       test( "sin" , ClipMath.approx( fc0.real(), c1 ) && ClipMath.approx( fc0.imag(), -s1 ) );
    fc0.ass( MathComplex( -1, piby4 ).sinh() );      test( "sinh", ClipMath.approx( fc0.real(), -s1 ) && ClipMath.approx( fc0.imag(), c1 ) );
    fc0.ass( MathComplex( rthalf, -rthalf ).sqr() ); test( "sqr" , ClipMath.approx( fc0.real(), 0 ) && ClipMath.approx( fc0.imag(), -1 ) );
    fc0.ass( MathComplex( 0, -1 ).sqrt() );          test( "sqrt", ClipMath.approx( fc0.real(), rthalf ) && ClipMath.approx( fc0.imag(), -rthalf ) );

    endTest();
  }

  // 行列のテスト
  void testMatrix(){
    startTest( "[testing matrix]" );

    /*
     * 算術のテスト
     */

    MathMatrix matI = MathMatrix.arrayToMatrix( [[ 1, 0, 0 ],[ 0, 1, 0 ],[ 0, 0, 1 ]] );

    debugPrint( "test 1" );
    MathMatrix matA, matB, matC;
    matA = MathMatrix.arrayToMatrix( [[ -4,  6, 3 ],[ 0, 1, 2 ]] );
    matB = MathMatrix.arrayToMatrix( [[  5, -1, 0 ],[ 3, 1, 0 ]] );
    matC = MathMatrix.arrayToMatrix( [[  1,  5, 3 ],[ 3, 2, 2 ]] );
    test( "", matC.equal( matA.add( matB ) ) );

    debugPrint( "test 2" );
    matA = MathMatrix.arrayToMatrix( [[ 2.7, -1.8 ],[ 0.9, 3.6 ]] );
    matB = MathMatrix.arrayToMatrix( [[ 5.4, -3.6 ],[ 1.8, 7.2 ]] );
    matC = MathMatrix.arrayToMatrix( [[ 3  , -2   ],[ 1  , 4   ]] );
    test( "", matA.add( matA ).equal( MathMatrix.floatToMatrix( 2 ).mul( matA ) ) );
    test( "", matA.add( matA ).equal( matB ) );
    test( "", MathMatrix.floatToMatrix( 2 ).mul( matA ).equal( matB ) );
    test( "", ClipMath.approxM( MathMatrix.floatToMatrix( 10 / 9 ).mul( matA ), matC ) );

    debugPrint( "test 3" );
    matA = MathMatrix.arrayToMatrix( [[ 5, -8, 1 ],[ 4, 0, 0 ]] );
    matB = MathMatrix.arrayToMatrix( [[ 5, 4 ],[ -8, 0 ],[ 1, 0 ]] );
    test( "", matA.trans().equal( matB ) );

    debugPrint( "test 4" );
    matA = MathMatrix.arrayToMatrix( [[ 7, 5, -2 ]] );
    matB = MathMatrix.arrayToMatrix( [[ 7 ],[ 5 ],[ -2 ]] );
    test( "", matA.trans().equal( matB ) );

    debugPrint( "test 5" );
    MathMatrix matR, matS;
    matA = MathMatrix.arrayToMatrix( [[ 2,  3 ],[ 5, -1 ]] );
    matR = MathMatrix.arrayToMatrix( [[ 2,  4 ],[ 4, -1 ]] );
    matS = MathMatrix.arrayToMatrix( [[ 0, -1 ],[ 1,  0 ]] );
    test( "", matA.add( matA.trans() ).div( 2 ).equal( matR ) );
    test( "", matA.sub( matA.trans() ).div( 2 ).equal( matS ) );

    debugPrint( "test 6" );
    matA = MathMatrix.arrayToMatrix( [[  2, -3 ],[  0,  4 ]] );
    matB = MathMatrix.arrayToMatrix( [[ -5,  2 ],[  2,  1 ]] );
    matC = MathMatrix.arrayToMatrix( [[  7, -5 ],[ -2,  3 ]] ); test( "", matA.sub( matB ).equal( matC ) );
    matC = MathMatrix.arrayToMatrix( [[ -7,  5 ],[  2, -3 ]] ); test( "", matB.sub( matA ).equal( matC ) );
    matC = MathMatrix.arrayToMatrix( [[  2,  0 ],[ -3,  4 ]] ); test( "", matA.trans().equal( matC ) );
    test( "", matB.trans().equal( matB ) );
    test( "", matB.trans().trans().equal( matB ) );
    matC = MathMatrix.arrayToMatrix( [[  4, -3 ],[ -3, 8 ]] ); test( "", matA.add( matA.trans() ).equal( matC ) );
    matC = MathMatrix.arrayToMatrix( [[  0, -3 ],[  3, 0 ]] ); test( "", matA.sub( matA.trans() ).equal( matC ) );
    matC = MathMatrix.arrayToMatrix( [[ -3,  2 ],[ -1, 5 ]] ); test( "", matA.add( matB ).trans().equal( matC ) );
    test( "", matA.trans().add( matB.trans() ).equal( matC ) );

    debugPrint( "test 7" );
    MathMatrix matK, matM, matN, matL;
    matK = MathMatrix.arrayToMatrix( [[ 1, 3, 5 ],[ 0, 4, 2 ],[ 0, 0, 6 ]] );
    matM = MathMatrix.arrayToMatrix( [[ 2, 0, 0 ],[ -1, 1, 0 ],[ 4, -3, 0 ]] );
    matN = MathMatrix.arrayToMatrix( [[ 6, 7 ],[ 0, -2 ],[ 3, 8 ]] );
    matL = MathMatrix.arrayToMatrix( [[ 18, 0, 9 ],[ 21, -6, 24 ]] );
    test( "", MathMatrix.floatToMatrix( 3 ).mul( matN ).trans().equal( matL ) );
    test( "", MathMatrix.floatToMatrix( 3 ).mul( matN.trans() ).equal( matL ) );
    matL = MathMatrix.arrayToMatrix( [[ -1, 3, 5 ],[ 1, 3, 2 ],[ -4, 3, 6 ]] );
    test( "", matK.sub( matM ).equal( matL ) );
    test( "", matM.sub( matK ).equal( matL.minus() ) );
    matL = MathMatrix.arrayToMatrix( [[ 3, 3, 5 ],[ -1, 5, 2 ],[ 4, -3, 6 ]] );
    test( "", matK.add( matM ).equal( matL ) );
    test( "", matM.add( matK ).equal( matL ) );

    debugPrint( "test 8" );
    matA = MathMatrix.arrayToMatrix( [[ 2,  1 ],[  3, 4 ]] );
    matB = MathMatrix.arrayToMatrix( [[ 1, -2 ],[  5, 3 ]] );
    matC = MathMatrix.arrayToMatrix( [[ 7, -1 ],[ 23, 6 ]] );
    test( "", matA.mul( matB ).equal( matC ) );

    debugPrint( "test 9" );
    matA = MathMatrix.arrayToMatrix( [[ 3, 2, -1 ],[  0,  4,  6 ]] );
    matB = MathMatrix.arrayToMatrix( [[ 1, 0,  2 ],[  5,  3,  1 ],[ 6, 4, 2 ]] );
    matC = MathMatrix.arrayToMatrix( [[ 7, 2,  6 ],[ 56, 36, 16 ]] );
    test( "", matA.mul( matB ).equal( matC ) );

    debugPrint( "test 10" );
    matA = MathMatrix.arrayToMatrix( [[ 3, 4, 2 ],[ 6, 0, -1 ],[ -5, -2, 1 ]] );
    matB = MathMatrix.arrayToMatrix( [[ 1 ],[ 3 ],[ 2 ]] );
    matC = MathMatrix.arrayToMatrix( [[ 19 ],[ 4 ],[ -9 ]] );
    test( "", matA.mul( matB ).equal( matC ) );

    debugPrint( "test 11" );
    matA = MathMatrix.arrayToMatrix( [[ 3, 6, 1 ]] );
    matB = MathMatrix.arrayToMatrix( [[ 1 ],[ 2 ],[ 4 ]] );
    matC = MathMatrix.arrayToMatrix( [[ 3, 6, 1 ],[ 6, 12, 2 ],[ 12, 24, 4 ]] );
    test( "", MathMatrix.floatToMatrix( 3 ).notEqual( matA ) );
    test( "", matA.notEqual( 3 ) );
    test( "", matA.mul( matB ).equal( 19 ) );
    test( "", matB.mul( matA ).equal( matC ) );

    debugPrint( "test 12" );
    matA = MathMatrix.arrayToMatrix( [[ 1, 0 ],[ 0, 0 ]] );
    matB = MathMatrix.arrayToMatrix( [[ 0, 1 ],[ 1, 0 ]] );
    matC = MathMatrix.arrayToMatrix( [[ 0, 1 ],[ 0, 0 ]] ); test( "", matA.mul( matB ).equal( matC ) );
    matC = MathMatrix.arrayToMatrix( [[ 0, 0 ],[ 1, 0 ]] ); test( "", matB.mul( matA ).equal( matC ) );

    debugPrint( "test 13" );
    matA = MathMatrix.arrayToMatrix( [[  1, 1 ],[ 2,  2 ]] );
    matB = MathMatrix.arrayToMatrix( [[ -1, 1 ],[ 1, -1 ]] );
    matC = MathMatrix.arrayToMatrix( [[  0, 0 ],[ 0,  0 ]] ); test( "", matA.mul( matB ).equal( matC ) );

    debugPrint( "test 14" );
    MathMatrix matD;
    matA = MathMatrix.arrayToMatrix( [[ 4, 6, -1 ],[ 3, 0, 2 ],[ 1, -2, 5 ]] );
    matB = MathMatrix.arrayToMatrix( [[ 2, 4 ],[ 0, 1 ],[ -1, 2 ]] );
    matC = MathMatrix.arrayToMatrix( [[ 3 ],[ 1 ],[ 2 ]] );
    matD = MathMatrix.arrayToMatrix( [[ 33, 26, 3 ],[ 14, 14, 7 ],[ 3, -4, 20 ]] );
    test( "", matA.mul( matA ).equal( matD ) );
    matD = MathMatrix.arrayToMatrix( [[ 4 ],[ 17 ]] );
    test( "", matB.trans().mul( matC ).equal( matD ) );
    matD = MathMatrix.arrayToMatrix( [[ 4, 17 ]] );
    test( "", matC.trans().mul( matB ).equal( matD ) );
    matD = MathMatrix.arrayToMatrix( [[ 20, 4, 6 ],[ 4, 1, 2 ],[ 6, 2, 5 ]] );
    test( "", matB.mul( matB.trans() ).equal( matD ) );
    matD = MathMatrix.arrayToMatrix( [[ 5, 6 ],[ 6, 21 ]] );
    test( "", matB.trans().mul( matB ).equal( matD ) );
    matD = MathMatrix.arrayToMatrix( [[ 43, 44, 0 ],[ 23, 12, 13 ],[ 6, -10, 33 ]] );
    test( "", matA.mul( matA ).add( MathMatrix.floatToMatrix( 3 ).mul( matA ) ).sub( MathMatrix.floatToMatrix( 2 ).mul( matI ) ).equal( matD ) );
    matD = MathMatrix.arrayToMatrix( [[ 25, 100 ]] );
    test( "", matC.trans().mul( matA ).mul( matB ).equal( matD ) );
    matD = MathMatrix.arrayToMatrix( [[ 25 ],[ 100 ]] );
    test( "", matA.mul( matB ).trans().mul( matC ).equal( matD ) );

    debugPrint( "test 15" );
    matA = MathMatrix.arrayToMatrix( [[  2, -1,  0 ],[ 0, -2,  1 ],[ 1,  0,  1 ]] );
    matB = MathMatrix.arrayToMatrix( [[ -2,  1, -1 ],[ 1,  2, -2 ],[ 2, -1, -4 ]] );
    matC = MathMatrix.arrayToMatrix( [[ -5,  0,  0 ],[ 0, -5,  0 ],[ 0,  0, -5 ]] );
    test( "", matA.mul( matB ).equal( matB.mul( matA ) ) );
    test( "", matA.mul( matB ).equal( matC ) );
    test( "", matB.mul( matA ).equal( matC ) );

    endTest();
  }
}
