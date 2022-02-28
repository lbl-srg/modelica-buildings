within Buildings.Templates.BaseClasses;
function getUniqueStrings
  "Returns the unique elements in a string vector"
  extends Modelica.Icons.Function;

  input String arr[:];
  output String uni[countUniqueStrings(arr)];
protected
  Integer ite;
algorithm
  ite := 1;
  uni := fill(arr[1], size(uni, 1));
  if size(arr, 1) > 1 then
    for i in 2:size(arr, 1) loop
      if not Modelica.Math.BooleanVectors.anyTrue(
        {arr[i] == uni[j] for j in 1:size(uni, 1)}) then
        ite := ite + 1;
        uni[ite] := arr[i];
      end if;
    end for;
  end if;
end getUniqueStrings;
