within Buildings.Fluid.BaseClasses;
block IndexMassFraction
  "Computes the index of a substance in the mass fraction vector Xi"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choicesAllMatching = true);
  parameter String substanceName="" "Name of species substance";

protected
  parameter Integer i_x(fixed=false) "Index of substance";
initial algorithm
  // Compute index of species vector that carries the substance name
  i_x :=-1;
    for i in 1:Medium.nXi loop
      if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                            string2=substanceName,
                                            caseSensitive=false) then
        i_x :=i;
      end if;
    end for;
  assert(i_x > 0, "Substance '" + substanceName + "' is not present in medium '"
                  + Medium.mediumName + "'.\n"
                  + "Change medium model to one that has '" + substanceName + "' as a substance.");

  annotation (Documentation(info="<html>
<p>
This block computes the index that the subtance with name
<code>substanceName</code> has in the mass fraction vector <code>X</code>.
If the medium model has no component called <code>substanceName</code>,
then the block writes an error message and terminates the simulation.
</p>
<p>
This block is used for example to obtain the index of the subtance 'water'
to obtain the water vapor concentration, or to measure any other mass fraction.
</p>
</html>", revisions="<html>
<ul>
<li>
August 31, 2013, by Michael Wetter:<br/>
Revised the model and added the parameter <code>substanceName</code>.
</li>
<li>
December 18, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end IndexMassFraction;
