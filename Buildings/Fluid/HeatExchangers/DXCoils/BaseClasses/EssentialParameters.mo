within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
partial block EssentialParameters "A partial block for essential parameters"

  replaceable parameter
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer
    datCoi constrainedby
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer
    "Performance data"
    annotation (Placement(transformation(extent={{-80,82},{-68,94}})));

protected
  parameter Integer nSta=datCoi.nSta "Number of stages";
  annotation ( Documentation(info="<html>
<p>
This partial block declares parameters that are required by most classes
in the package
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils\">
Buildings.Fluid.HeatExchangers.DXCoils</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2023, by Karthik Devaprasad and Xing Lu:<br/>
Updated class of data record <code>datCoi</code> from <code>DXCoil</code> to
<a href=\"Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer\">
Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.BaseClasses.CoilHeatTransfer</a>.
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
end EssentialParameters;
