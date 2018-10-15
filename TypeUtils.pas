{$mode objfpc}

{
TODO:
- Write my own VariantToString for consistency (for string and float point numbers)
- Write multimensional arrays like a table???
}

unit TypeUtils;

interface

uses sysutils, typinfo, variants;

function ToStr(const AValue; ATypeInfo: PTypeInfo): AnsiString;

implementation

function ToStr(const AValue; ATypeInfo: PTypeInfo): AnsiString;
type
  TArray = array of Byte;
var
  I: LongInt;
  FormatSettings: TFormatSettings;
  FirstField, Field: PManagedField;
  ElementSize: SizeInt;
begin
  case ATypeInfo^.Kind of
    tkChar: Result := QuotedStr(Char(AValue));
    tkWChar: Result := QuotedStr(AnsiString(WChar(AValue)));
    tkBool: Result := BoolToStr(Boolean(AValue), True);
    tkInt64: Result := IntToStr(Int64(AValue));
    tkQWord: Result := IntToStr(QWord(AValue));
    tkSString: Result := QuotedStr(ShortString(AValue));
    tkAString: Result := QuotedStr(AnsiString(AValue));
    tkWString: Result := QuotedStr(AnsiString(WideString(AValue)));
    tkUString: Result := QuotedStr(AnsiString(UnicodeString(AValue)));
    tkClass: Result := TObject(AValue).ToString;
    tkEnumeration: Result := GetEnumName(ATypeInfo, Integer(AValue));
    tkSet: Result := SetToString(ATypeInfo, Integer(AValue), True).Replace(',', ', ');
    tkVariant: Result := VarToStr(Variant(AValue));
    tkInteger:
    begin
      case GetTypeData(ATypeInfo)^.OrdType of
        otSByte: Result := IntToStr(ShortInt(AValue));
        otUByte: Result := IntToStr(Byte(AValue));
        otSWord: Result := IntToStr(SmallInt(AValue));
        otUWord: Result := IntToStr(Word(AValue));
        otSLong: Result := IntToStr(LongInt(AValue));
        otULong: Result := IntToStr(LongWord(AValue));
      end;
    end;
    tkFloat:
    begin
      FillByte(FormatSettings, SizeOf(TFormatSettings), 0);
      FormatSettings.DecimalSeparator := '.';
      case GetTypeData(ATypeInfo)^.FloatType of
        ftSingle: Result := FormatFloat('0.######', Single(AValue), FormatSettings);
        ftDouble: Result := FormatFloat('0.######', Double(AValue), FormatSettings);
        ftExtended: Result := FormatFloat('0.######', Extended(AValue), FormatSettings);
        ftComp: Result := FormatFloat('0.######', Comp(AValue), FormatSettings);
        ftCurr: Result := FormatFloat('0.######', Currency(AValue), FormatSettings);
      end;
    end;
    tkRecord:
    begin
      Result := '(';
      with GetTypeData(ATypeInfo)^ do
      begin
        {$IFNDEF VER3_0} //ifdef needed because of a field rename in trunk (ManagedFldCount to TotalFieldCount)
        FirstField := PManagedField(PByte(@TotalFieldCount) + SizeOf(TotalFieldCount));
        for I := 0 to TotalFieldCount - 1 do
        {$ELSE}
        FirstField := PManagedField(PByte(@ManagedFldCount) + SizeOf(ManagedFldCount));
        for I := 0 to ManagedFldCount - 1 do
        {$ENDIF}
        begin
          if I > 0 then Result += ', ';
          Field := PManagedField(PByte(FirstField) + (I * SizeOf(TManagedField)));
          Result += ToStr((PByte(@AValue) + Field^.FldOffset)^, Field^.TypeRef);
        end;
      end;
      Result += ')';
    end;
    tkArray:
    begin
      Result := '[';
      with GetTypeData(ATypeInfo)^ do
      begin
        ElementSize := ArrayData.Size div ArrayData.ElCount;
        for I := 0 to ArrayData.ElCount - 1 do
        begin
          if I > 0 then Result += ', ';
          Result += ToStr((PByte(@AValue) + (I * ElementSize))^, ArrayData.ElType);
        end;
      end;
      Result += ']';
    end;
    tkDynArray:
    begin
      Result := '[';
      with GetTypeData(ATypeInfo)^ do
      begin
        for I := 0 to Length(TArray(AValue)) - 1 do
        begin
          if I > 0 then Result += ', ';
          Result += ToStr((PByte(@TArray(AValue)[0]) + (I * ElSize))^, ElType2);
        end;
      end;
      Result += ']';
    end;
    else Result := Format('%s@%p', [ATypeInfo^.Name, @AValue]);
  end;
end;

end.
