# TypeUtils

Utility functions based on Object Pascal's runtime type information (RTTI)

## Usage

Include 'TypeUtils.pas' file in your project folder and add it to 'uses' clause (see examples bellow).

To run the tests just compile and run 'TypeUtilsTests.pas'.

## Exported Function

```pascal
function ToStr(const AValue; ATypeInfo: PTypeInfo): AnsiString;
```
### Description
Automatically converts any value to a string representation, including records and arrays, in the same spirit of 'print' functions found in scripting languages. Its usefull for logging and debugging.

### Parametes
* AValue: The variable to convert to string.
* ATypeInfo: The type information returned by 'TypeInfo' compiler intrinsic.

### Return
The string representation of the first parameter.

### Examples
Print an array of integers:
```pascal
program Test;
uses TypeUtils;
var
  Arr: array[1 .. 3] of Integer = (1, 2, 3);
begin
  WriteLn(ToStr(Arr, TypeInfo(Arr))); //Outputs: [1, 2, 3]
end.
```
Print an array of records:
```pascal
program Test;
uses TypeUtils, SysUtils;
type
  TEmployee = record
    FName: ShortString;
    FId: LongInt;
    FSalary: Currency;
  end;
var
  Employees: array of TEmployee;
  I: LongInt;
begin
  SetLength(Employees, 2);
  for I := 0 to High(Employees) do
  begin
    with Employees[I] do
    begin
      FName := 'John Doe ' + I.ToString;
      FId := I;
      FSalary := 2000.25 * I;
    end;
  end;
  WriteLn(ToStr(Employees, TypeInfo(Employees))); // Outputs: [('John Doe 0', 0, 0), ('John Doe 1', 1, 2000.25)]
end.
```
