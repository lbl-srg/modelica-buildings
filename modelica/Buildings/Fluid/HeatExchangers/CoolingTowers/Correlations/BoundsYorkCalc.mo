within Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations;
record BoundsYorkCalc "Coefficient data record for properties of perfect gases"
  extends BaseClasses.Bounds(TAirInWB_min = 273.15-34.4,
  TAirInWB_max = 273.15+26.7,
  TRan_min =     1.1,
  TRan_max =     22.2,
  TApp_min =     1.1,
  TApp_max =     40,
  FRWat_min =     0.75,
  FRWat_max =    1.25,
  liqGasRat_max = 8);

 annotation (Documentation(info="<HTML>
<p>
This data record contains the bounds for the YorkCalc cooling tower correlations.
</p>
</HTML>"), revisions="<html>
<ul>
<li>
May 16, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>");
end BoundsYorkCalc;
