within Buildings.Fluids.HeatExchangers.CoolingTowers;
model FixedApproach "Cooling tower with constant approach temperature"
  extends
    Buildings.Fluids.HeatExchangers.CoolingTowers.BaseClasses.PartialStaticTwoPortCoolingTower;
  annotation (Icon(graphics),
                          Diagram(graphics),
    Documentation(info="<html>
<p>
Model for a steady state cooling tower with constant approach temperature.
</p><p>
By connecting a signal that contains either the dry bulb or the wet bulb
temperature, this model can be used to estimate the water return temperature
from a cooling tower. 
For a more detailed model see for example
<a href=\"Modelica:Buildings.Fluids.HeatExchangers.CoolingTowers.YorkCalc\">YorkCalc.mo</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 14, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  parameter Modelica.SIunits.Temperature TApp = 2 "Approach temperature";
equation
  TWatOut_degC = TApp + TAirIn_degC;
end FixedApproach;
