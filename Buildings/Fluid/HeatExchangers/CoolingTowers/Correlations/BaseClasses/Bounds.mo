within Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.BaseClasses;
record Bounds "Coefficient data record for properties of cooling tower model"
  extends Modelica.Icons.Record;
  Modelica.Units.SI.Temperature TAirInWB_min
    "Minimum air inlet wet bulb temperature";
  Modelica.Units.SI.Temperature TAirInWB_max
    "Maximum air inlet wet bulb temperature";
  Modelica.Units.SI.Temperature TRan_min "Minimum range temperature";
  Modelica.Units.SI.Temperature TRan_max "Minimum range temperature";
  Modelica.Units.SI.Temperature TApp_min "Minimum approach temperature";
  Modelica.Units.SI.Temperature TApp_max "Minimum approach temperature";
  Real FRWat_min(final min=0, final max=1) "Minimum water flow ratio";
  Real FRWat_max(final min=0) "Maximum water flow ratio";
  Real liqGasRat_max(final min=0) "Maximum liquid to gas ratio";

 annotation (Documentation(info="<html>
<p>
This data record contains the bounds for the cooling tower correlations.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 26, 2013 by Michael Wetter:<br/>
Corrected wrong type for <code>FRWat_min</code>, <code>FRWat_max</code>
and <code>liqGasRat_max</code>.
They were declared as <code>Modelica.Units.SI.MassFraction</code>,
which is incorrect as, for example, <code>FRWat_max</code> can be larger than one.
</li>
<li>
May 16, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Bounds;
