within Buildings.Fluid.Boilers.Data;
record Generic "Generic data record for boiler efficiency curves"
  extends Modelica.Icons.Record;

  parameter Modelica.SIunits.Efficiency effCur[:,:]=
    [0, 1; 1, 1]
    "Efficiency curves as a table: First row = inlet temp(K), First column = firing rates or PLR";

  annotation (
  defaultComponentName="effCur",
  defaultComponentPrefixes = "parameter",
  Documentation(info="<html>
<p>
This record is used as a template for performance data
for the boiler model
<a href=\"Modelica://Buildings.Fluid.Boilers.BoilerTable\">
Buildings.Fluid.Boilers.BoilerTable</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 2, 2021 by Hongxiang Fu:<br/>
First implementation. 
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
end Generic;
