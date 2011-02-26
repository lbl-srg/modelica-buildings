within Buildings.Fluid.HeatExchangers.CoolingTowers;
model FixedApproach "Cooling tower with constant approach temperature"
  extends
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.PartialStaticTwoPortCoolingTower;
  parameter Modelica.SIunits.TemperatureDifference TApp(min=0, displayUnit="K") = 2
    "Approach temperature difference";
equation
 Q_flow = m_flow * (Medium.specificEnthalpy(Medium.setState_pTX(port_b.p, TAir+TApp, inStream(port_b.Xi_outflow)))-inStream(port_a.h_outflow));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}),
                                  graphics),
    Documentation(info="<html>
<p>
Model for a steady state cooling tower with constant approach temperature.
</p><p>
By connecting a signal that contains either the dry bulb or the wet bulb
temperature, this model can be used to estimate the water return temperature
from a cooling tower. 
For a more detailed model, use for example the
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc\">YorkCalc</a>
model.
</p>
</html>", revisions="<html>
<ul>
<li>
April 7, 2009, by Michael Wetter:<br>
Changed interface to new Modelica.Fluid stream concept.
</li>
<li>
May 14, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end FixedApproach;
