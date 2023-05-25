within Buildings.Fluid.DXSystems.BaseClasses;
partial block EssentialCoolingParameters
  "A partial block for essential parameters for cooling DX coils"

 replaceable parameter Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.Coil datCoi
    "Performance data"
    annotation (Placement(transformation(extent={{-80,82},{-68,94}})));

protected
  parameter Integer nSta=datCoi.nSta "Number of stages";
  annotation ( Documentation(info="<html>
<p>
This partial block declares parameters that are required by most classes for cooling DX coils
in the package
<a href=\"modelica://Buildings.Fluid.DXSystems\">
Buildings.Fluid.DXSystems</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2023, by Karthik Devaprasad and Xing Lu:<br/>
Updated class of data record <code>datCoi</code> from <code>DXCoil</code> to
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer\">
Buildings.Fluid.DXSystems.Cooling.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer</a>.
</li>
<li>
February 17, 2017 by Yangyang Fu:<br/>
Added prefix <code>replaceable</code> for the parameter <code>datCoi</code>.
</li>
<li>
January 7, 2013 by Michael Wetter:<br/>
Removed medium declaration to avoid multiple definitions of the medium.
</li>
<li>
August 1, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end EssentialCoolingParameters;
