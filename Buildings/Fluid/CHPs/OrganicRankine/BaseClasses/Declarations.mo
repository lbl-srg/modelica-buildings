within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses;
model Declarations
  "Common declarations for organic Rankine cycle models"

  parameter Buildings.Fluid.CHPs.OrganicRankine.Data.Generic pro
    "Property records of the working fluid"
    annotation(Dialog(group="ORC inputs"),choicesAllMatching = true);

  parameter Modelica.Units.SI.Temperature TEva
    "Evaporator temperature"
    annotation(Dialog(group="ORC inputs"));
  parameter Modelica.Units.SI.Temperature TCon
    "Condenser temperature"
    annotation(Dialog(group="ORC inputs"));
  parameter Modelica.Units.SI.TemperatureDifference dTSup = 0
    "Superheating differential temperature"
    annotation(Dialog(group="ORC inputs"));
  parameter Modelica.Units.SI.Efficiency etaExp "Expander efficiency"
    annotation(Dialog(group="ORC inputs"));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This class contains parameter declarations used by all ORC component models.
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end Declarations;
