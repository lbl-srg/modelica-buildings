within Buildings.Fluid.SolarCollectors.Controls.BaseClasses;
model GCritCalc "Model calculating the critical insolation level"

  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer slope
    "Slope from ratings data";
  parameter Real y_intercept(final unit="1") "y_intercept from ratings data";

  Modelica.Blocks.Interfaces.RealInput TIn(
    final unit="K",
    displayUnit = "degC",
    quantity = "ThermodynamicTemperature")
    "Temperature of water entering the collector"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealOutput G_TC(
    final unit="W/m2",
    quantity = "RadiantEnergyFluenceRate") "Critical radiation level"
    annotation (Placement(transformation(extent={{100,-16},{132,16}})));
  Modelica.Blocks.Interfaces.RealInput TEnv(
    final unit="K",
    displayUnit = "degC",
    quantity = "ThermodynamicTemperature")
    "Ambient temperature at the collector"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));

equation
  G_TC = -slope * (TIn - TEnv) / y_intercept;
  annotation (defaultComponentName="criSol",
  Documentation(info="<html>
<p>
This component calculates the solar radiation necessary for the fluid
in the collector to gain heat. It is used in the model
<a href=\"modelica://Buildings.Fluid.SolarCollectors.Controls.CollectorPump\">
Buildings.Fluid.SolarCollectors.Controls.CollectorPump</a>.
</p>
<p>
The critical solar radiation level is calculated using Equation 6.8.2 in
Duffie and Beckman (2006).
It is
</p>
<p align=\"center\" style=\"font-style:italic;\">
G<sub>TC</sub>=F<sub>R</sub>U<sub>L</sub> (T<sub>In</sub>-T<sub>Env</sub>)
/(F<sub>R</sub>(&tau;&alpha;))
</p>
<p>
where <i>G<sub>TC</sub></i> is the critical solar radiation,
<i>F<sub>R</sub>U<sub>L</sub></i> is the heat loss coefficient,
<i>T<sub>In</sub></i> is the inlet temperature, <i>T<sub>Env</sub></i> is the
ambient temperature, and <i>F<sub>R</sub>(&tau;&alpha;)</i> is the maximum
efficiency.
</p>
<h4>References</h4>
<p>
J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd
Edition), John Wiley &amp; Sons, Inc.<br/>
</p>
</html>",
revisions = "<html>
<ul>
<li>
February 15, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
  February 15, 2013 by Peter Grant <br/>
  First implementation
</li>
</ul>
</html>"));
end GCritCalc;
