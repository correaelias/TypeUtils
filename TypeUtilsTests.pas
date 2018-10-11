program TypeUtilsTests;

{$mode objfpc}
{$assertions on}

uses TypeUtils;

type
  TPoint = record
    FX, FY: Integer;
  end;

  TColor = (cBlack, cRed, cBlue);
  
var
  C: Char = 'A';
  WC: WChar = 'B';
  BoolFalse: Boolean = False;
  BoolTrue: Boolean = True;
  
  I8: ShortInt = -128;
  I16: SmallInt = -32768;
  I32: LongInt = -2147483648;
  I64: Int64 = -9223372036854775808;
  
  U8: Byte = 255;
  U16: Word = 65535;
  U32: DWord = 4294967295;
  U64: QWord = 18446744073709551615;
  
  F32: Single = 1.5;
  F64: Double = 2.5;
  FExt: Extended = 3.5;
  FCurr: Currency = 4.5;
  
  ShortStr: ShortString = 'abc';
  AnsiStr: AnsiString = 'def';
  WideStr: WideString = 'ghi';
  UnicodeStr: UnicodeString = 'jkl';
  
  Point: TPoint;
  
  StaticArr: array[1 .. 5] of Integer = (1, 2, 3, 4, 5);
  DynArr: array of Integer;
  
  Obj: TObject;
  
  Color: TColor = cRed;
  
  ColorSet: set of TColor = [cBlack, cBlue];
  
  V: Variant;
begin
  Assert(ToStr(C, TypeInfo(C)) = '''A''', 'Char to string failed.');
  Assert(ToStr(WC, TypeInfo(WC)) = '''B''', 'WChar to string failed.');
  Assert(ToStr(BoolFalse, TypeInfo(BoolFalse)) = 'False', 'Boolean to string failed.');
  Assert(ToStr(BoolTrue, TypeInfo(BoolTrue)) = 'True', 'Boolean to string failed.');
  
  Assert(ToStr(I8, TypeInfo(I8)) = '-128', 'ShortInt to string failed.');
  Assert(ToStr(I16, TypeInfo(I16)) = '-32768', 'SmallInt to string failed.');
  Assert(ToStr(I32, TypeInfo(I32)) = '-2147483648', 'LongInt to string failed.');
  Assert(ToStr(I64, TypeInfo(I64)) = '-9223372036854775808', 'Int64 to string failed.');
  
  Assert(ToStr(U8, TypeInfo(U8)) = '255', 'Byte to string failed.');
  Assert(ToStr(U16, TypeInfo(U16)) = '65535', 'Word to string failed.');
  Assert(ToStr(U32, TypeInfo(U32)) = '4294967295', 'DWord to string failed.');
  Assert(ToStr(U64, TypeInfo(U64)) = '18446744073709551615', 'QWord to string failed.');
  
  Assert(ToStr(F32, TypeInfo(F32)) = '1.5', 'Single to string failed.');
  Assert(ToStr(F64, TypeInfo(F64)) = '2.5', 'Double to string failed.');
  Assert(ToStr(FExt, TypeInfo(FExt)) = '3.5', 'Extended to string failed.');
  Assert(ToStr(FCurr, TypeInfo(FCurr)) = '4.5', 'Currency to string failed.');
  
  Assert(ToStr(ShortStr, TypeInfo(ShortStr)) = '''abc''', 'ShortString to string failed.');
  Assert(ToStr(AnsiStr, TypeInfo(AnsiStr)) = '''def''', 'AnsiString to string failed.');
  Assert(ToStr(WideStr, TypeInfo(WideStr)) = '''ghi''', 'WideString to string failed.');
  Assert(ToStr(UnicodeStr, TypeInfo(UnicodeStr)) = '''jkl''', 'UnicodeString to string failed.');
  
  with Point do
  begin
    FX := 1;
    FY := 2;
  end;
  Assert(ToStr(Point, TypeInfo(Point)) = '(1, 2)', 'Record to string failed.');
  
  Assert(ToStr(StaticArr, TypeInfo(StaticArr)) = '[1, 2, 3, 4, 5]', 'Static array to string failed.');
  
  SetLength(DynArr, 3);
  DynArr[0] := 0;
  DynArr[1] := 1;
  DynArr[2] := 2;
  Assert(ToStr(DynArr, TypeInfo(DynArr)) = '[0, 1, 2]', 'Dynamic array to string failed.');
  
  Obj := TObject.Create;
  Assert(ToStr(Obj, TypeInfo(Obj)) = 'TObject', 'Class to string failed.');
  Obj.Free;
  
  Assert(ToStr(Color, TypeInfo(Color)) = 'cRed', 'Enumeration to string failed.');
  
  Assert(ToStr(ColorSet, TypeInfo(ColorSet)) = '[cBlack, cBlue]', 'Enumeration to string failed.');
  
  V := 123;
  Assert(ToStr(V, TypeInfo(V)) = '123', 'Variant to string failed.');
  V := 'abc';
  Assert(ToStr(V, TypeInfo(V)) = 'abc', 'Variant to string failed.');
  V := True;
  Assert(ToStr(V, TypeInfo(V)) = 'True', 'Variant to string failed.');
  
  WriteLn('All tests passed!');
end.