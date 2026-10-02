within Buildings.Fluid.DataCenters.Racks.Hybrid.Data.AirLiquid;
record Generic
  "Generic data record for hybrid liquid-cooled single-phase and air-cooled rack"
  extends Modelica.Icons.Record;

  parameter Buildings.Fluid.DataCenters.Racks.Liquid.Data.Generic liq
    "Performance data for liquid-cooled component"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));

  parameter Buildings.Fluid.DataCenters.Racks.Air.Data.Generic air
    "Performance data for air-cooled component"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

annotation (
  defaultComponentName="dat",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic data record for hybrid IT racks that combine liquid-cooled single-phase
and air-cooled components.
</p>
<p>
This record contains two nested data records:
</p>
<ul>
<li>
<code>liq</code>: Performance data for the liquid-cooled component, based on
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.Liquid.Data.Generic\">
Buildings.Fluid.DataCenters.Racks.Liquid.Data.Generic</a>
</li>
<li>
<code>air</code>: Performance data for the air-cooled component, based on
<a href=\"modelica://Buildings.Fluid.DataCenters.Racks.Air.Data.Generic\">
Buildings.Fluid.DataCenters.Racks.Air.Data.Generic</a>
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
July 14, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic;
