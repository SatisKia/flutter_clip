import 'package:flutter/cupertino.dart';
import 'package:dart_clip/clip.dart';

class MyMultiPrec extends MultiPrec {
  // 離散フーリエ変換
  void dft( List<MathComplex> ret, int retNum, List<int> src, int srcStart, int srcNum ){
    double T = 6.28318530717958647692 / retNum;
    int t, x;
    double U, V;
    for( t = retNum - 1; t >= 0; t-- ){
      U = T * t;
      ret[t] = MathComplex();
      for( x = 0; x < srcNum; x++ ){
        V = U * x;
        ret[t].setReal( ret[t].real() + src[srcStart + x] * ClipMath.cos( V ) );
        ret[t].setImag( ret[t].imag() - src[srcStart + x] * ClipMath.sin( V ) );
      }
    }
  }

  // 逆離散フーリエ変換
  void idft( List<int> ret, int retStart, int retNum, List<MathComplex> src, int srcNum ){
    double T = 6.28318530717958647692 / retNum;
    int x, t;
    double U, V;
    double tmp;
    for( x = retNum - 1; x >= 0; x-- ){
      U = T * x;
      tmp = 0;
      for( t = 0; t < srcNum; t++ ){
        V = U * t;
        tmp += src[t].real() * ClipMath.cos( V ) - src[t].imag() * ClipMath.sin( V );
      }
      tmp /= retNum;
      ret[retStart + x] = (tmp + 0.5).toInt();
    }
  }

  // 畳み込み
  void conv( List<int> ret, int retStart, int retNum, List<int> x, int xStart, int xNum, List<int> y, int yStart, int yNum ){
    List<MathComplex> X = MathComplex.newArray( retNum );
    List<MathComplex> Y = MathComplex.newArray( retNum );
    dft( X, retNum, x, xStart, xNum );
    dft( Y, retNum, y, yStart, yNum );

    for( int i = retNum - 1; i >= 0; i-- ){
      X[i].mulAndAss( Y[i] );
    }

    idft( ret, retStart, retNum, X, retNum );
  }

  // 多倍長整数同士の乗算
  @override
  void mul( MPData ret, MPData a, MPData b ){
    a = clone( a );
    b = clone( b );

    bool isMinus = false;
    if( a.val(0) < 0 && b.val(0) >= 0 ){ isMinus = true; }
    if( b.val(0) < 0 && a.val(0) >= 0 ){ isMinus = true; }

    int la = getLen( a );
    int lb = getLen( b );
    if( la == 0 || lb == 0 ){
      ret.set( 0, 0 );
      return;
    }
    int n = la + lb;

    ret.set( n + 1, 0 ); // 配列の確保
    List<int> r = ret.data();
    conv( r, 1, n, a.data(), 1, la, b.data(), 1, lb );

    int i = 1, c = 0, rr;
    for( ; i < n; i++ ){
      rr = r[i] + c;
      r[i] = ClipMath.imod( rr, MultiPrec.element );
      c = rr ~/ MultiPrec.element;
    }
    r[i] = c;

    setLen( ret, c != 0 ? n : n - 1, isMinus );
  }
}

class MultiPrecTest {
  late MultiPrec mp;

  MPData pi = MPData();
  MPData a  = MPData();
  MPData b  = MPData();
  MPData t  = MPData();
  MPData p  = MPData();
  int start = 0;
  bool piOut5( int prec, int count, int order ){
    int N = ClipMath.log( prec.toDouble() ) ~/ ClipMath.log( 2 ); // 繰り返し回数。log2(prec)程度の反復でよい。
    MPData T = MPData();
    if( start == 0 ){
      mp.set( a, mp.F( "1" ) );
      switch( order ){
      case 0 : mp.fsqrt3( T, mp.F( "2" ), prec ); break;
      case 1 : mp.fsqrt ( T, mp.F( "2" ), prec ); break;
      default: mp.fsqrt2( T, mp.F( "2" ), prec, order ); break;
      }
      mp.fdiv( b, mp.F( "1" ), T, prec );
      mp.fdiv( t, mp.F( "1" ), mp.F( "4" ), prec );
      mp.set( p, mp.F( "1" ) );
    }
    MPData U = MPData();
    for( int i = 0; i < count; i++ ){
      mp.fadd( T, a, b );
      mp.fmul( U, T, mp.F( "0.5" ), prec );
      mp.fmul( T, a, b, prec );
      switch( order ){
      case 0 : mp.fsqrt3( b, T, prec ); break;
      case 1 : mp.fsqrt ( b, T, prec ); break;
      default: mp.fsqrt2( b, T, prec, order ); break;
      }
      mp.fsub( T, a, U );
      mp.fmul( T, T, T, prec );
      mp.fmul( T, p, T, prec );
      mp.fsub( t, t, T );
      mp.fmul( p, mp.F( "2" ), p, prec );
      mp.set( a, U );
      start++;
    }
    mp.fadd( T, a, b );
    mp.fmul( T, T, T, prec );
    mp.fmul( U, mp.F( "4" ), t, prec );
    mp.fdiv2( pi, T, U, prec );
    return (start < N);
  }

  String round( String str, int prec ){
    String ret = "";
    for( int i = 0; i <= 8; i++ ){
      if( i != 0 ){
        ret += " ";
      }
      MPData a = MPData();
      mp.fset( a, mp.F( str ) );
      mp.fround( a, prec, i );
      String tmp = mp.fnum2str( a, prec );
      ret += tmp;
    }
    return ret;
  }

  void main(){
    testSqrt( 1000 );
    testRound1();
    testRound2();
    testFactorial();
  }

  void testSqrt( int prec ){
    int i, j;

    for( int order = 0; order <= 7; order++ ){
      switch( order ){
      case 0 : debugPrint( "fsqrt3:" ); break;
      case 1 : debugPrint( "fsqrt:" ); break;
      case 7 : debugPrint( "fsqrt2 order=4 dft:" ); break;
      default: debugPrint( "fsqrt2 order=$order:" ); break;
      }

      int time = DateTime.now().millisecondsSinceEpoch;
      pi = MPData();
      start = 0;
      if( order == 7 ){
        mp = MyMultiPrec();
        while( piOut5( prec, 1, 4 ) ){}
      } else {
        mp = MultiPrec();
        while( piOut5( prec, 1, order ) ){}
      }
      debugPrint( "${DateTime.now().millisecondsSinceEpoch - time} ms" );
      String str = mp.fnum2str( pi, prec );

      List<String> tmp = str.split( "." );
      debugPrint( "${tmp[0]}." );
      if( tmp.length >= 2 ){
        for( i = 0; i < tmp[1].length; i += 100 ){
          j = i + 100; if( j > tmp[1].length ) j = tmp[1].length;
          debugPrint( tmp[1].substring( i, j ) );
        }
      }
    }
  }

  void testRound1(){
    mp = MultiPrec();

    debugPrint( "       UP DOWN CEILING FLOOR H_UP H_DOWN H_EVEN H_DOWN2 H_EVEN2" );
    debugPrint( "5.501  ${round( "5.501" , 0 )}" );
    debugPrint( "5.5    ${round( "5.5"   , 0 )}" );
    debugPrint( "2.501  ${round( "2.501" , 0 )}" );
    debugPrint( "2.5    ${round( "2.5"   , 0 )}" );
    debugPrint( "1.6    ${round( "1.6"   , 0 )}" );
    debugPrint( "1.1    ${round( "1.1"   , 0 )}" );
    debugPrint( "1.0    ${round( "1.0"   , 0 )}" );
    debugPrint( "-1.0   ${round( "-1.0"  , 0 )}" );
    debugPrint( "-1.1   ${round( "-1.1"  , 0 )}" );
    debugPrint( "-1.6   ${round( "-1.6"  , 0 )}" );
    debugPrint( "-2.5   ${round( "-2.5"  , 0 )}" );
    debugPrint( "-2.501 ${round( "-2.501", 0 )}" );
    debugPrint( "-5.5   ${round( "-5.5"  , 0 )}" );
    debugPrint( "-5.501 ${round( "-5.501", 0 )}" );
  }

  void testRound2(){
    mp = MultiPrec();

    MPData a = MPData();
    mp.fsqrt( a, mp.F( "2" ), 45 );

    MPData b = MPData();
    String s;
    for( int i = 0; i < 45; i++ ){
      s = mp.fnum2str( a, 45 );
      debugPrint( s.substring( 0, i + 3 ) );
      debugPrint( s.substring( i + 3 ) );

      for( int mode = 0; mode <= 8; mode++ ){
        mp.fset( b, a );
        mp.fround( b, i, mode );
        s = mp.fnum2str( b, i );
        switch( mode ){
        case MultiPrec.froundUp       : debugPrint( "UP      $s" ); break;
        case MultiPrec.froundDown     : debugPrint( "DOWN    $s" ); break;
        case MultiPrec.froundCeiling  : debugPrint( "CEILING $s" ); break;
        case MultiPrec.froundFloor    : debugPrint( "FLOOR   $s" ); break;
        case MultiPrec.froundHalfUp   : debugPrint( "H_UP    $s" ); break;
        case MultiPrec.froundHalfDown : debugPrint( "H_DOWN  $s" ); break;
        case MultiPrec.froundHalfEven : debugPrint( "H_EVEN  $s" ); break;
        case MultiPrec.froundHalfDown2: debugPrint( "H_DOWN2 $s" ); break;
        case MultiPrec.froundHalfEven2: debugPrint( "H_EVEN2 $s" ); break;
        }
      }
    }
  }

  MPData _mpCombination( int n, int r ){
    MPData ret;

    ret = MPData();
    if( n < r ){
      mp.set( ret, mp.I( "0" ) );
      return ret;
    }
    if( n - r < r ) r = n - r;
    if( r == 0 ){
      mp.set( ret, mp.I( "1" ) );
      return ret;
    }
    if( r == 1 ){
      mp.str2num( ret, "$n" );
      return ret;
    }

    List<int> numer = List.filled( r, 0 );
    List<int> denom = List.filled( r, 0 );

    int i, k;
    int pivot;
    int offset;

    for( i = 0; i < r; i++ ){
      numer[i] = n - r + i + 1;
      denom[i] = i + 1;
    }

    for( k = 2; k <= r; k++ ){
      pivot = denom[k - 1];
      if( pivot > 1 ){
        offset = ClipMath.imod( n - r, k );
        for( i = k - 1; i < r; i += k ){
          numer[i - offset] = numer[i - offset] ~/ pivot;
          denom[i] = denom[i] ~/ pivot;
        }
      }
    }

    ret = MPData();
    mp.set( ret, mp.I( "1" ) );
    MPData ii = MPData();
    for( i = 0; i < r; i++ ){
      if( numer[i] > 1 ){
        mp.str2num( ii, "${numer[i]}" );
        mp.mul( ret, ret, ii );
      }
    }
    return ret;
  }
  MPData _mpFactorial( int n ){
    if( n == 0 ){
      MPData ret = MPData();
      mp.set( ret, mp.I( "1" ) );
      return ret;
    }
    MPData value = _mpFactorial( n ~/ 2 );
    mp.mul( value, value, value );
    mp.mul( value, value, _mpCombination( n, n ~/ 2 ) );
    if( (n & 1) != 0 ){
      MPData tmp = MPData();
      mp.str2num( tmp, "${(n + 1) ~/ 2}" );
      mp.mul( value, value, tmp );
    }
    return value;
  }
  void mpFactorial( MPData ret, int x ){
    bool m = false;
    if( x < 0 ){
      m = true;
      x = 0 - x;
    }
    mp.str2num( ret, "1" );
    MPData ii = MPData();
    for( int i = 2; i <= x; i++ ){
      mp.str2num( ii, "$i" );
      mp.mul( ret, ret, ii );
    }
    if( m ){
      mp.neg( ret );
    }
  }
  void mpFactorial2( MPData ret, int x ){
    bool m = false;
    if( x < 0 ){
      m = true;
      x = 0 - x;
    }
    mp.set( ret, _mpFactorial( x ) );
    if( m ){
      mp.neg( ret );
    }
  }
  void testFactorial(){
    mp = MultiPrec();

    int i, j;
    int time;
    MPData a;
    String s;

    time = DateTime.now().millisecondsSinceEpoch;
    a = MPData();
    mpFactorial( a, 999 );
    s = mp.num2str( a );
    for( i = 0; i < s.length; i += 100 ){
      j = i + 100; if( j > s.length ) j = s.length;
      debugPrint( s.substring( i, j ) );
    }
    debugPrint( "${DateTime.now().millisecondsSinceEpoch - time} ms" );

    time = DateTime.now().millisecondsSinceEpoch;
    a = MPData();
    mpFactorial2( a, 999 );
    s = mp.num2str( a );
    for( i = 0; i < s.length; i += 100 ){
      j = i + 100; if( j > s.length ) j = s.length;
      debugPrint( s.substring( i, j ) );
    }
    debugPrint( "${DateTime.now().millisecondsSinceEpoch - time} ms" );
  }
}
