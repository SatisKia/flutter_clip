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

class EasyClipTest2 {
  void main() {
    ClipProc.errorProc = ( err, num, func, token ){
      String str = ClipProcError.getDefString( err, token, false, false );
      debugPrint( "$func: $num行: $str" );
    };
    ClipProc.printAnsMultiPrec = ( str ){
      debugPrint( str );
    };
    ClipProc.doCommandPrint = ( topPrint, flag ){
      String str = "";
      ClipProcPrint? cur = topPrint;
      while (cur != null) {
        if (cur.string() != null) {
          ParamString tmp = ParamString(cur.string());
          tmp.replaceNewLine("\n");
          str += tmp.str();
        }
        cur = cur.next();
      }
//      if (flag) {
//        str += "\n";
//      }
      debugPrint( str );
    };

    EasyClip clip = EasyClip();

    List<String> script = [
      "func _mp_param &a[]",
      "    if strlen a > 0 # 文字列の場合",
      "        :ptype",
      "        a = mp a",
      "    end",
      "end",
      "func _mp_abs &rop[]",
      "    :mint",
      "    _mp_param rop",
      "    rop = abs rop",
      "end",
      "func _mp_fabs &rop[]",
      "    :global MP_PREC",
      "    :mfloat MP_PREC",
      "    _mp_param rop",
      "    rop = abs rop",
      "end",
      "func _mp_add &ret[] a[] b[]",
      "    :mint",
      "    _mp_param a",
      "    _mp_param b",
      "    ret = a + b",
      "end",
      "func _mp_fadd &ret[] a[] b[]",
      "    :global MP_PREC",
      "    :mfloat MP_PREC",
      "    _mp_param a",
      "    _mp_param b",
      "    ret = a + b",
      "end",
      "func _mp_div &q[] a[] b[] &r[]",
      "    :mint",
      "    _mp_param a",
      "    _mp_param b",
      "    if b == 0; return TRUE; end",
      "    q = a / b",
      "    r = a % b",
      "    return FALSE",
      "end",
      "func _mp_fdiv2 &ret[] a[] b[] prec",
      "    :mfloat prec",
      "    _mp_param a",
      "    _mp_param b",
      "    if b == 0; return TRUE; end",
      "    ret = a / b",
      "    return FALSE",
      "end",
      "func _mp_mul &ret[] a[] b[]",
      "    :mint",
      "    _mp_param a",
      "    _mp_param b",
      "    ret = a * b",
      "end",
      "func _mp_fmul &ret[] a[] b[] prec",
      "    :mfloat prec",
      "    _mp_param a",
      "    _mp_param b",
      "    ret = a * b",
      "end",
      "func _mp_neg &rop[]",
      "    :mint",
      "    _mp_param rop",
      "    rop = [-]rop",
      "end",
      "func _mp_fneg &rop[]",
      "    :global MP_PREC",
      "    :mfloat MP_PREC",
      "    _mp_param rop",
      "    rop = [-]rop",
      "end",
      "func _mp_set &rop[] op[]",
      "    :mint",
      "    _mp_param op",
      "    rop = op",
      "end",
      "func _mp_fset &rop[] op[]",
      "    :global MP_PREC",
      "    :mfloat MP_PREC",
      "    _mp_param op",
      "    rop = op",
      "end",
      "func _mp_sub &ret[] a[] b[]",
      "    :mint",
      "    _mp_param a",
      "    _mp_param b",
      "    ret = a - b",
      "end",
      "func _mp_fsub &ret[] a[] b[]",
      "    :global MP_PREC",
      "    :mfloat MP_PREC",
      "    _mp_param a",
      "    _mp_param b",
      "    ret = a - b",
      "end",
      "func _mp_fsqrt &ret[] a[] prec",
      "    :mfloat prec",
      "    _mp_param a",
      "    ret = sqrt a",
      "end",
      "func _mp_ftrunc &rop[] op[]",
      "    :global MP_PREC",
      "    :mfloat MP_PREC",
      "    _mp_param op",
      "    rop = int op",
      "end"
    ];
    clip.procScript( script );

    List<String> script2 = [
      "#多倍長計算を行う。エラー時はTRUEを返す。",
      "#_mp <expr> [<prec>]",
      "#precに0を指定すると整数モードになる。",
      "#引数がexprのみの場合、桁数としてグローバル変数MP_PRECの値が参照される。",
      "#",
      "#書式:",
      "#  演算の優先順位を指定する括弧()を使用することができる。",
      "#  括弧は釣り合いがとれていなくても構わない。",
      "#",
      "#定数:",
      "#  12345      符号なし整数",
      "#  \\-6789      符号付き整数",
      "#  12.345     小数点表記の浮動小数点数",
      "#  1.234e\\-5   指数表記の浮動小数点数",
      "#  \\-1.234e+5",
      "#  1.234e5    eの後ろの+は省略できる。",
      "#",
      "#変数:",
      "#  Ans   計算結果用変数（親プロセスでの@@:0）",
      "#  a～z  変数（親プロセスでの@@a～@@z）",
      "#",
      "#演算子:",
      "#  単項  \\-",
      "#  二項  * / % + \\-",
      "#  代入  =",
      "#",
      "#関数:",
      "#  abs(x)    絶対値",
      "#  sqr(x)    自乗",
      "#  sqrt(x)   平方根",
      "#  trunc(x)  小数点以下の切り捨て",
      "#",
      "#制限事項:",
      "#  %は整数モードのみ。",
      "#  sqrt,trunc関数は浮動小数点数モードのみ。",
      "",
      "func checkOp op",
      "    switch op",
      "    case 'N",
      "        return 4",
      "    case '\\*",
      "    case '\\/",
      "    case '\\%",
      "        return 3",
      "    case '\\+",
      "    case '\\-",
      "        return 2",
      "    case '\\=",
      "        return 1",
      "    end",
      "    return 0",
      "end",
      "",
      "func isParenthesis token[] index",
      "    return token index (token index 0) == '\\(",
      "end",
      "",
      "func insToken &token[] &tokenNum pos",
      "    :ans FALSE",
      "    for @i = tokenNum; @i > pos; @i--",
      "        :arraycopy token (@i-1) 0 token @i 0 (1 + token (@i-1) 0)",
      "    end",
      "    tokenNum++",
      "end",
      "",
      "func makeToken expr[] &token[] &tokenNum",
      "    :ans FALSE",
      "",
      "    # 空白を取り除く",
      "    :var exprLen",
      "    exprLen = 0",
      "    for @i = 0; expr @i != 0; @i++",
      "        if expr @i != [' ]",
      "            expr (exprLen++) = expr @i",
      "        end",
      "    end",
      "    expr exprLen = 0 # 文字列終端",
      "",
      "    @c = 0",
      "    :var prev",
      "    @i = 0",
      "    token @i 0 = 0 # 文字数",
      "    @t = 0",
      "    for @j = 0; @j < exprLen; @j++",
      "        prev = @c",
      "        @c = expr @j",
      "        switch @c",
      "        case '\\(",
      "        case '\\)",
      "        case '\\*",
      "        case '\\/",
      "        case '\\%",
      "        case '\\+",
      "        case '\\-",
      "        case '\\=",
      "            if (@c == '\\() && (prev >= 'a && prev <= 'z)",
      "                token @i ([++]@t) = @c",
      "                token @i 0 = @t # 文字数",
      "                @i++",
      "                token @i 0 = 0 # 文字数",
      "                @t = 0",
      "                break",
      "            end",
      "            if (@c == '\\+) || (@c == '\\-)",
      "                if (prev == 'e) || (prev == 'E)",
      "                    token @i ([++]@t) = @c",
      "                    break",
      "                end",
      "            end",
      "            if @t > 0",
      "                token @i 0 = @t # 文字数",
      "                @i++",
      "                token @i 0 = 0 # 文字数",
      "                @t = 0",
      "            elif @c == '\\-",
      "                if (@j < exprLen - 1) && ((expr (@j + 1) >= '0 && expr (@j + 1) <= '9) || expr (@j + 1) == '.)",
      "                    token @i ([++]@t) = @c",
      "                    break",
      "                end",
      "                @c = 'N",
      "            end",
      "            token @i ([++]@t) = @c",
      "            token @i 0 = @t # 文字数",
      "            @i++",
      "            token @i 0 = 0 # 文字数",
      "            @t = 0",
      "            break",
      "        default",
      "            token @i ([++]@t) = @c",
      "            break",
      "        end",
      "    end",
      "    if @t > 0",
      "        token @i 0 = @t # 文字数",
      "        tokenNum = @i + 1",
      "    else",
      "        tokenNum = @i",
      "    end",
      "",
      "    :var cur top end",
      "    :var level topLevel assLevel",
      "    assLevel = checkOp '\\=",
      "    :var retTop retEnd",
      "",
      "    # 演算子の優先順位に従って括弧を付ける",
      "    cur = 0",
      "    while cur < tokenNum",
      "        if (token cur 0 == 1) && (checkOp (token cur 1) > 0)",
      "            # 自分自身の演算子の優先レベルを調べておく",
      "            level = checkOp (token cur 1)",
      "",
      "            retTop = 0",
      "            retEnd = 0",
      "",
      "            # 前方検索",
      "            @i = 0",
      "            top = cur - 1",
      "            while top >= 0",
      "                if isParenthesis token top # 括弧の始まりの場合",
      "                    if @i > 0",
      "                        @i--",
      "                    else",
      "                        retTop = 1",
      "                    end",
      "                elif token top 1 == '\\) # 括弧の終わりの場合",
      "                    @i++",
      "                elif (token top 0 == 1) && (checkOp (token top 1) > 0)",
      "                    if @i == 0",
      "                        topLevel = checkOp (token top 1)",
      "                        if ((topLevel == assLevel) && (level == assLevel)) || (topLevel < level)",
      "                            retTop = 2",
      "                        end",
      "                    end",
      "                end",
      "",
      "                if retTop == 2",
      "                    # 後方検索",
      "                    @i = 0",
      "                    end = cur + 1",
      "                    while end < tokenNum",
      "                        if isParenthesis token end # 括弧の始まりの場合",
      "                            @i++",
      "                        elif token end 1 == '\\) # 括弧の終わりの場合",
      "                            if @i > 0",
      "                                @i--",
      "                            else",
      "                                retEnd = 1",
      "                            end",
      "                        elif (token end 0 == 1) && (checkOp (token end 1) > 0)",
      "                            if @i == 0",
      "                                if (topLevel != assLevel) && (checkOp (token end 1) <= topLevel)",
      "                                    retEnd = 2",
      "                                end",
      "                            end",
      "                        end",
      "                        if retEnd > 0",
      "                            break",
      "                        end",
      "                        end++",
      "                    end",
      "",
      "                    @t = top + 1",
      "                    insToken token tokenNum @t",
      "                    token @t 1 = '\\(",
      "                    token @t 0 = 1 # 文字数",
      "                    cur++",
      "                    end++",
      "",
      "                    if retEnd > 0",
      "                        insToken token tokenNum end",
      "                        token end 1 = '\\)",
      "                        token end 0 = 1 # 文字数",
      "                    end",
      "                end",
      "",
      "                if retTop > 0",
      "                    break",
      "                end",
      "                top--",
      "            end",
      "        end",
      "        cur++",
      "    end",
      "",
      "    # 括弧を整える",
      "    @i = 0",
      "    cur = 0",
      "    while cur < tokenNum",
      "        if isParenthesis token cur # 括弧の始まりの場合",
      "            @i++",
      "        elif token cur 1 == '\\) # 括弧の終わりの場合",
      "            @i--",
      "            for ; @i < 0; @i++",
      "                insToken token tokenNum 0",
      "                token 0 1 = '\\(",
      "                token 0 0 = 1 # 文字数",
      "                cur++",
      "            end",
      "        end",
      "        cur++",
      "    end",
      "    for ; @i > 0; @i--",
      "        token tokenNum 1 = '\\)",
      "        token tokenNum 0 = 1 # 文字数",
      "        tokenNum++",
      "    end",
      "end",
      "",
      "func tokenStr token[] index &str[]",
      "    :ans FALSE",
      "    :arraycopy token index 1 str 0 (token index 0)",
      "    str (token index 0) = 0 # 文字列終端",
      "end",
      "",
      "func mp_abs &rop[]",
      "    :ans FALSE",
      "    if MP_PROC_INT; _mp_abs  rop",
      "    else;           _mp_fabs rop",
      "    end",
      "end",
      "func mp_add &ret[] a[] b[]",
      "    :ans FALSE",
      "    if MP_PROC_INT; _mp_add  ret a b",
      "    else;           _mp_fadd ret a b",
      "    end",
      "end",
      "func mp_div &q[] a[] b[]",
      "    if MP_PROC_INT; @r = _mp_div   q a b",
      "    else;           @r = _mp_fdiv2 q a b MP_PREC",
      "    end",
      "    return @r",
      "end",
      "func mp_mul &ret[] a[] b[]",
      "    :ans FALSE",
      "    if MP_PROC_INT; _mp_mul  ret a b",
      "    else;           _mp_fmul ret a b MP_PREC",
      "    end",
      "end",
      "func mp_neg &rop[]",
      "    :ans FALSE",
      "    if MP_PROC_INT; _mp_neg  rop",
      "    else;           _mp_fneg rop",
      "    end",
      "end",
      "func mp_set &rop[] op[]",
      "    :ans FALSE",
      "    if MP_PROC_INT; _mp_set  rop op",
      "    else;           _mp_fset rop op",
      "    end",
      "end",
      "func mp_sub &ret[] a[] b[]",
      "    :ans FALSE",
      "    if MP_PROC_INT; _mp_sub  ret a b",
      "    else;           _mp_fsub ret a b",
      "    end",
      "end",
      "",
      "func proc token[] tokenNum top &end &ans[]",
      "    :parent @@:0",
      "    for @i = 'a; @i <= 'z; @i++",
      "        :parent @@:@i",
      "    end",
      "",
      "    @f = TRUE # 初回かどうか",
      "    @l = \\-1",
      "    for @i = top; @i < tokenNum; @i++",
      "        tokenStr token @i @@S",
      "        if @f",
      "            @f = FALSE",
      "            if @@S 0 == 'N",
      "                @o = 'N",
      "                @i++",
      "                if @i >= tokenNum",
      "                    :println [\"単項-の右辺がありません]",
      "                    return TRUE",
      "                end",
      "                tokenStr token @i @@S",
      "            end",
      "        elif @@S 0 == '\\) # 括弧の終わりの場合",
      "            end = @i",
      "            mp_set ans @@L",
      "            return FALSE",
      "        else",
      "            @o = @@S 0",
      "            @i++",
      "            if @i >= tokenNum",
      "                !putchar @o",
      "                :println [\"の右辺がありません]",
      "                return TRUE",
      "            end",
      "            tokenStr token @i @@S",
      "            if @@S 0 == '\\) # 括弧の終わりの場合",
      "                !putchar @o",
      "                :println [\"の右辺がありません]",
      "                return TRUE",
      "            end",
      "        end",
      "",
      "        # 左辺または右辺の値を取得する",
      "        if @@S (strlen @@S - 1) == '\\( # 括弧の始まりの場合",
      "            if @l < 0",
      "                @l = '\\(",
      "                @c = 'L",
      "            else",
      "                @c = 'R",
      "            end",
      "            if proc token tokenNum (@i + 1) @i @@:@c",
      "                return TRUE",
      "            end",
      "            if strcmp @@S [\"abs(] == 0",
      "                mp_abs @@:@c",
      "            elif strcmp @@S [\"sqr(] == 0",
      "                mp_mul @@:@c @@:@c @@:@c",
      "            elif strcmp @@S [\"sqrt(] == 0",
      "                if MP_PROC_INT",
      "                    :println [\"sqrtは浮動小数点数モードでしか使えません]",
      "                    return TRUE",
      "                else",
      "                    if _mp_fsqrt @@:@c @@:@c MP_PREC",
      "                        :println [\"sqrtの引数が負の値になりました]",
      "                        return TRUE",
      "                    end",
      "                end",
      "            elif strcmp @@S [\"trunc(] == 0",
      "                if MP_PROC_INT",
      "                    :println [\"truncは浮動小数点数モードでしか使えません]",
      "                    return TRUE",
      "                else",
      "                    _mp_ftrunc @@:@c @@:@c",
      "                end",
      "            end",
      "        else",
      "            @a = strcmp @@S [\"Ans]",
      "            if @l < 0",
      "                @l = (@a == 0) ? 0 (@@S 0)",
      "                @c = 'L",
      "            else",
      "                @c = 'R",
      "            end",
      "            if @a == 0",
      "                mp_set @@:@c @@:0",
      "            elif @@S 0 >= 'a && @@S 0 <= 'z",
      "                mp_set @@:@c @@:(@@S 0)",
      "            else",
      "                mp_set @@:@c @@S",
      "            end",
      "        end",
      "        if @c == 'L",
      "            if @o == 'N",
      "                mp_neg @@L",
      "            end",
      "            continue",
      "        end",
      "",
      "        # 演算結果を左辺の値にする",
      "        switch @o",
      "        case '\\*",
      "            mp_mul @@L @@L @@R",
      "            break",
      "        case '\\/",
      "            if mp_div @@L @@L @@R",
      "                :println [\"ゼロで除算しました]",
      "                return TRUE",
      "            end",
      "            break",
      "        case '\\%",
      "            if MP_PROC_INT",
      "                if _mp_div @@D @@L @@R @@L",
      "                    :println [\"ゼロで除算しました]",
      "                    return TRUE",
      "                end",
      "            else",
      "                :println [\"%は整数モードでしか使えません]",
      "                return TRUE",
      "            end",
      "            break",
      "        case '\\+",
      "            mp_add @@L @@L @@R",
      "            break",
      "        case '\\-",
      "            mp_sub @@L @@L @@R",
      "            break",
      "        case '\\=",
      "            if @l == 0 || (@l >= 'a && @l <= 'z)",
      "                mp_set @@:@l @@R",
      "                mp_set @@L @@:@l",
      "            else",
      "                :println [\"=の左辺は変数でなければなりません]",
      "                return TRUE",
      "            end",
      "            break",
      "        end",
      "    end",
      "",
      "    mp_set ans @@L",
      "    return FALSE",
      "end",
      "",
      "func _mp expr[] prec",
      "    :global MP_PREC MP_PROC_INT",
      "    if @! > 1",
      "        MP_PREC = prec",
      "    end",
      "    MP_PROC_INT = (MP_PREC == 0)",
      "",
      "    :parent @@:0",
      "    for @i = 'a; @i <= 'z; @i++",
      "        :parent @@:@i",
      "    end",
      "",
      "    makeToken expr @@T @T",
      "",
      "    if proc @@T @T 0 @t @@A",
      "        return TRUE",
      "    end",
      "",
      "    mp_set @@:0 @@A",
      "",
      "    return FALSE",
      "end"
    ];
    clip.procScript( script2 );

    List<String> script3 = [
      "#Gauss\\-Legendre(ガウス=ルジャンドル)のアルゴリズム",
      "#pi_out5e <prec> <start> <count>",
      "#startの値は更新されるので、次回呼出しに渡せる。",
      "func pi_out5e prec &start count",
      "    :parent @@:0",
      "    :parent @@a",
      "    :parent @@b",
      "    :parent @@t",
      "    :parent @@p",
      "    @N = int (log prec / log 2) # 繰り返し回数。log2(prec)程度の反復でよい。",
      "    :global MP_PREC",
      "    MP_PREC = prec",
      "    if start == 0",
      "        _mp [\"a=1]",
      "        _mp [\"b=1/sqrt(2)]",
      "        _mp [\"t=1/4]",
      "        _mp [\"p=1]",
      "    end",
      "    for @i = 0; @i < count; @i++",
      "        _mp [\"n=(a+b)/2]",
      "        _mp [\"b=sqrt(a*b)]",
      "        _mp [\"t=t-p*sqr(a-n)]",
      "        _mp [\"p=2*p]",
      "        _mp [\"a=n]",
      "        start++",
      "    end",
      "    _mp [\"sqr(a+b)/(4*t)] prec",
      "    return (start < @N)",
      "end"
    ];
    clip.procScript( script3 );

    clip.procLine( "@0=time" );
    clip.procLine( "@a=0; while pi_out5e 1000 @a 1; end" );
    clip.procScript( [
      "@1 = time",
      "@0 = @1 - @0",
      "@h = int (int @0 / (60 * 60)); @0 -= @h * 60 * 60",
      "@m = int (int @0 /  60      ); @0 -= @m * 60",
      ":println @h [\"h ] @m [\"m ] @0 [\"s]"
    ] );
    clip.procLine( ":mfloat 1000" );
    clip.procLine( ":print @@:0" );
  }
}
