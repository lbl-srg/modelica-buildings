within Buildings.Fluid.BaseClasses;
block IndexMassFraction
  "Computes the index of a substance in the mass fraction vector Xi"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air")));
  parameter String substanceName="" "Name of species substance";

protected
  parameter Integer i_x = sum(
    if Modelica.Utilities.Strings.isEqual(string1=Medium.substanceNames[i],
                                          string2=substanceName,
                                          caseSensitive=false) then i else 0
                                          for i in 1:Medium.nXi) "Index of substance"
                                          annotation(Evaluate=true);
initial equation
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
November 14, 2019, by Michael Wetter:<br/>
Rewrote assignment of <code>i_x</code> to avoid a variable array index.<br/>
This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1250\">#1250</a>.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice to moist air only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
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
