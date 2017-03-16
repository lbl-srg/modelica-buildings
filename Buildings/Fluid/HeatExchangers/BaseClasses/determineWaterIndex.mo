within Buildings.Fluid.HeatExchangers.BaseClasses;
function determineWaterIndex
  "Determine the index of water in a 2-component medium model"
  input String[:] substanceNames "names of substances of media";
  output Integer idxWat "index of water";
protected
  Boolean found(fixed=false) "Flag, used for error checking";
  Integer N = size(substanceNames, 1) "number of substances";
algorithm
  assert(N==2, "The implementation is only valid if Medium.nX=2.");
  found:=false;
  idxWat := 1;
  for i in 1:N loop
    if Modelica.Utilities.Strings.isEqual(
        string1=substanceNames[i],
        string2="water",
        caseSensitive=false) then
        idxWat := i;
        found := true;
    end if;
  end for;
  assert(found,
    "Did not find medium species 'water' in the medium model. " +
    "Change medium model.");
end determineWaterIndex;
