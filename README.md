# TypeUtils

Utility functions based on Object Pascal's runtime type information (RTTI)

## Exported Function

```pascal
function ToStr(var AX; ATypeInfo: PTypeInfo): AnsiString;
```
### Description
Automatically converts any value to a string representation, including records and arrays, in the same spirit of 'print' functions found in scripting languages. Its usefull for logging and debugging.

### Parametes
* AX: The variable to convert to string.
* ATypeInfo: The type information returned by 'TypeInfo' compiler intrinsic.

### Return
The string representation of the first parameter.

### Example
```pascal
program test;
uses TypeUtils;
var
  Arr: array[1 .. 3] of Integer = (1, 2, 3);
begin
  WriteLn(ToStr(Arr, TypeInfo(Arr)));
end.
```
