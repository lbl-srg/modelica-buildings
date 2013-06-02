within Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.BaseClasses;
record Bounds "Coefficient data record for properties of cooling tower model"
  extends Modelica.Icons.Record;
  Modelica.SIunits.Temperature TAirInWB_min
    "Minimum air inlet wet bulb temperature";
  Modelica.SIunits.Temperature TAirInWB_max
    "Maximum air inlet wet bulb temperature";
  Modelica.SIunits.Temperature TRan_min "Minimum range temperature";
  Modelica.SIunits.Temperature TRan_max "Minimum range temperature";
  Modelica.SIunits.Temperature TApp_min "Minimum approach temperature";
  Modelica.SIunits.Temperature TApp_max "Minimum approach temperature";
  Modelica.SIunits.MassFraction FRWat_min "Minimum water flow ratio";
  Modelica.SIunits.MassFraction FRWat_max "Maximum water flow ratio";
  Modelica.SIunits.MassFraction liqGasRat_max "Maximum liquid to gas ratio";

 annotation (Documentation(info="<html>
<p>
This data record contains the bounds for the cooling tower correlations.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 16, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Bounds;
