within Buildings.Templates.BaseClasses;
function countUniqueStrings
  "Returns the number of unique elements in a string vector"
  extends Modelica.Icons.Function;

  input String arr[:];
  output Integer cou;
protected
  String arr_sto[size(arr, 1)];
algorithm
  cou := 0;
  if size(arr, 1) > 0 then
    arr_sto := {arr[i] + "_" for i in 1:size(arr, 1)};
    for i in 1:size(arr, 1) loop
      if not Modelica.Math.BooleanVectors.anyTrue(
        {arr[i] == arr_sto[j] for j in 1:size(arr_sto, 1)}) then
        cou := cou + 1;
        arr_sto[cou] := arr[i];
      end if;
    end for;
  end if;
end countUniqueStrings;
