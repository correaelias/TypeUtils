unit TypeUtils;

{$mode objfpc}

interface

uses sysutils, typinfo, variants;

function ToStr(var AX; ATypeInfo: PTypeInfo): AnsiString;

implementation

function ToStr(var AX; ATypeInfo: PTypeInfo): AnsiString;
type
  TArray = array of Byte;
var
  I: LongInt;
  TypeData: PTypeData;
  FormatSettings: TFormatSettings;
begin
  FillByte(FormatSettings, SizeOf(TFormatSettings), 0);
  FormatSettings.DecimalSeparator := '.';
  TypeData := GetTypeData(ATypeInfo);
  Result := '';
  case ATypeInfo^.Kind of
    tkChar: Result += '''' + Char(AX) + '''';
    tkWChar: Result += '''' + AnsiString(WChar(AX)) + '''';
    tkBool: Result += BoolToStr(Boolean(AX), True);
    tkInteger:
    begin
      case TypeData^.OrdType of
        otSByte: Result += IntToStr(ShortInt(AX));
        otUByte: Result += IntToStr(Byte(AX));
        otSWord: Result += IntToStr(SmallInt(AX));
        otUWord: Result += IntToStr(Word(AX));
        otSLong: Result += IntToStr(LongInt(AX));
        otULong: Result += IntToStr(LongWord(AX));
      end;
    end;
    tkInt64: Result += IntToStr(Int64(AX));
    tkQWord: Result += IntToStr(QWord(AX));
    tkFloat:
    begin
      case TypeData^.FloatType of
        ftSingle: Result += FormatFloat('0.###', Single(AX), FormatSettings);
        ftDouble: Result += FormatFloat('0.###', Double(AX), FormatSettings);
        ftExtended: Result += FormatFloat('0.###', Extended(AX), FormatSettings);
        ftComp: Result += FormatFloat('0.###', Comp(AX), FormatSettings);
        ftCurr: Result += FormatFloat('0.###', Currency(AX), FormatSettings);
      end;
    end;
    tkSString: Result += '''' + ShortString(AX) + '''';
    tkAString: Result += '''' + AnsiString(AX) + '''';
    tkWString: Result += '''' + AnsiString(WideString(AX)) + '''';
    tkUString: Result += '''' + AnsiString(UnicodeString(AX)) + '''';
    tkRecord:
    begin
      Result += '(';
      for I := 0 to TypeData^.ManagedFldCount - 1 do
      begin
        if I > 0 then Result += ', ';
        with PManagedField(PByte(@TypeData^.ManagedFldCount) + SizeOf(TypeData^.ManagedFldCount) + (I * SizeOf(TManagedField)))^ do
          Result += ToStr((PByte(@AX) + FldOffset)^, TypeRef);
      end;
      Result += ')';
    end;
    tkArray:
    begin
      Result += '[';
      for I := 0 to TypeData^.ArrayData.ElCount - 1 do
      begin
        if I > 0 then Result += ', ';
        Result += ToStr((PByte(@AX) + (I * (TypeData^.ArrayData.Size div TypeData^.ArrayData.ElCount)))^, TypeData^.ArrayData.ElType);
      end;
      Result += ']';
    end;
    tkDynArray:
    begin
      Result += '[';
      for I := 0 to Length(TArray(AX)) - 1 do
      begin
        if I > 0 then Result += ', ';
        Result += ToStr((PByte(@TArray(AX)[0]) + (I * TypeData^.ElSize))^, TypeData^.ElType2);
      end;
      Result += ']';
    end;
    tkClass: Result += TObject(AX).ToString;
    tkEnumeration: Result += GetEnumName(ATypeInfo, Integer(AX));
    tkSet: Result += SetToString(ATypeInfo, Integer(AX), True).Replace(',', ', ');
    tkVariant: Result += VarToStr(Variant(AX)); //TODO: Write VariantToString for consistency (for string and float point numbers)
    else Result += ATypeInfo^.Name + '@' + HexStr(@AX);
  end;
end;

end.
