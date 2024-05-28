within Buildings.Obsolete.Fluid.SolarCollectors.Controls;
model SolarPumpController
  "Controller which activates a circulation pump when solar radiation is above a critical level"
  extends Modelica.Blocks.Icons.Block;

  parameter Real delY(final unit = "W/m2") = 0.01
    "Width of the smoothHeaviside function";
  parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector per
    "Performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{60,60},{80,80}})));

  Modelica.Blocks.Interfaces.RealInput TIn(final unit = "K",
  final displayUnit = "degC", quantity = "ThermodynamicTemperature")
    "Fluid temperature entering the collector"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput y(min=0, max=1, unit="1")
    "On/off control signal for the pump"
    annotation (Placement(transformation(extent={{100,-18},{136,18}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data input"
    annotation (Placement(transformation(extent={{-112,50},{-92,70}})));

  Buildings.Fluid.SolarCollectors.Controls.BaseClasses.GCritCalc criSol(final
      slope=per.slope, final y_intercept=per.y_intercept)
    "Calculates the critical insolation based on collector design and current weather conditions"
    annotation (Placement(transformation(extent={{-58,-20},{-38,0}})));
  Modelica.Blocks.Math.Add add(final k2=-1)
    "Compares the current insolation to the critical insolation"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
protected
  Buildings.Utilities.Math.SmoothHeaviside smoHea(final delta=delY)
    "Creates a smooth 1/0 output"
    annotation (Placement(transformation(extent={{28,-10},{48,10}})));

equation
  connect(TIn, criSol.TIn)    annotation (Line(
      points={{-120,-40},{-84,-40},{-84,-16},{-60,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.TDryBul, criSol.TEnv)    annotation (Line(
      points={{-102,60},{-84,60},{-84,-4},{-60,-4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(weaBus.HDirNor, add.u1) annotation (Line(
      points={{-102,60},{-34,60},{-34,6},{-22,6}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(smoHea.y, y)          annotation (Line(
      points={{49,0},{118,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, smoHea.u)          annotation (Line(
      points={{1,6.66134e-16},{14,6.66134e-16},{14,0},{26,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(criSol.G_TC, add.u2) annotation (Line(
      points={{-36.4,-10},{-30,-10},{-30,-6},{-22,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (    defaultComponentName = "pumCon",
   obsolete = "Obsolete model - use Buildings.Fluid.SolarCollectors.Controls.CollectorPump instead",
    Documentation(info = "<html>
      <p>
        This component models a pump controller which might be used in a solar thermal system.
        It controls whether the pump is active or inactive based on the incident solar radiation
        and the system parameters. The pump is activated when the incident solar radiation is
        greater than the critical radiation.
      </p>
      <p>
        The critical radiation is defined per Equation 6.8.2 in Duffie and Beckman (2006). It is
      </p>
      <p align=\"center\" style=\"font-style:italic;\">
        G<sub>TC</sub>=(F<sub>R</sub>U<sub>L</sub> (T<sub>In</sub>-T<sub>Env</sub>))/(F<sub>R</sub>(&tau;&alpha;))
      </p>
      <p>
        where <i>G<sub>TC</sub></i> is the critical solar radiation, <i>F<sub>R</sub>U<sub>L</sub></i>
        is the heat loss coefficient, <i>T<sub>In</sub></i> is the inlet temperature,
        <i>T<sub>Env</sub></i> is the ambient temperature, and <i>F<sub>R</sub>(&tau;&alpha;)</i>
        is the maximum efficiency.
      </p>
    <h4>References</h4>
      <p>
        J.A. Duffie and W.A. Beckman 2006, Solar Engineering of Thermal Processes (3rd Edition),
        John Wiley &amp; Sons, Inc.<br/>
      </p>
  </html>",
  revisions="<html>
    <ul>
<li>
November 8, 2022, by Michael Wetter:<br/>
Moved to <code>Buildings.Obsolete</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3074\">issue 3074</a>.
</li>
      <li>
        January 15, 2013 by Peter Grant <br/>
        First implementation
      </li>
    </ul>
  </html>"));
end SolarPumpController;
