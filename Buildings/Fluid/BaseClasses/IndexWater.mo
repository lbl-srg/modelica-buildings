within Buildings.Fluid.BaseClasses;
block IndexWater "Computes the index of the water substance"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choicesAllMatching = true);
protected
  parameter Integer i_w(fixed=false) "Index for water substance";
initial algorithm
  // Compute index of species vector that carries the water vapor concentration
  i_w :=-1;
    for i in 1:Medium.nXi loop
      if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2="water",
                                            caseSensitive=false) then
        i_w :=i;
      end if;
    end for;
  assert(i_w > 0, "Substance 'water' is not present in medium '"
                  + Medium.mediumName + "'.\n"
                  + "Change medium model to one that has 'water' as a substance.");

  annotation (Documentation(info="<html>
<p>
This block computes the index that water has in the mass fraction vector <code>X</code>.
If the medium model has not component called <code>water</code>, 
then the block writes an error message and terminates the simulation.
</p>
</html>", revisions="<html>
<ul>
<li>
December 18, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end IndexWater;
