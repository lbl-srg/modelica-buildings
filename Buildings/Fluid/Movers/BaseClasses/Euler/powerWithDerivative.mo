within Buildings.Fluid.Movers.BaseClasses.Euler;
record powerWithDerivative
  "Record for electrical power and its derivative with respect to flow rate"
  extends Modelica.Icons.Record;
  parameter Modelica.Units.SI.VolumeFlowRate V_flow[11](each min=0)
    "Volume flow rate at user-selected operating points";
  parameter Modelica.Units.SI.Power P[11](each min=0)
    "Fan or pump electrical power at these flow rates";
  parameter Real d[11](each unit="J/m3")
    "Derivative of power with respect to volume flow rate";
  annotation (Documentation(info="<html>
<p>
Data record for performance data that describe electrical power and its derivative
versus volumetric flow rate.
This record is specifically constructed for the Euler number method
and is the output type of function
<a href=\"Modelica://Buildings.Fluid.Movers.BaseClasses.Euler.power\">
Buildings.Fluid.Movers.BaseClasses.Euler.power</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 13, 2022, by Hongxiang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end powerWithDerivative;
