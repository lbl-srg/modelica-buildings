within Buildings.Fluid.SolarCollectors.Controls;
model SolarPumpController
  "Controller which activates a circulation pump when solar radiation is above a critical level"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.Angle azi(displayUnit="deg")
    "Surface azimuth (0 for south-facing; -90 degree for east-facing; +90 degree for west facing";
  parameter Modelica.Units.SI.Angle til(displayUnit="deg")
    "Surface tilt (0 for horizontally mounted collector)";
  parameter Real rho(
    final min=0,
    final max=1,
    final unit = "1") = 0.2 "Ground reflectance";

  parameter Real delY(final unit = "W/m2") = 0.01
    "Width of the smoothHeaviside function"
    annotation(Dialog(tab="Advanced"));

  parameter Buildings.Fluid.SolarCollectors.Data.GenericSolarCollector per
    "Performance data"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{60,60},{80,80}})));

  Modelica.Blocks.Interfaces.RealInput TIn(
    final unit = "K",
    final displayUnit = "degC",
    quantity = "ThermodynamicTemperature")
    "Fluid temperature entering the collector"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput y(
    final min=0,
    final max=1,
    final unit="1")
    "On/off control signal for the pump"
    annotation (Placement(transformation(extent={{100,-18},{136,18}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data input"
    annotation (Placement(transformation(extent={{-112,50},{-92,70}})));

  Buildings.Fluid.SolarCollectors.Controls.BaseClasses.GCritCalc criSol(
    final slope=per.slope,
    final ercept=per.y_intercept)
    "Calculates the critical insolation based on collector design and current weather conditions"
    annotation (Placement(visible = true, transformation(origin = {-2, 0}, extent = {{-58, -20}, {-38, 0}}, rotation = 0)));
  Modelica.Blocks.Math.Add add(
    final k1=1,
    final k2=-1,
    u1(final unit="W/m2"),
    u2(final unit="W/m2"),
    y(final unit="W/m2"))
    "Compares the current insolation to the critical insolation"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  BoundaryConditions.SolarIrradiation.DiffusePerez HDifTilIso(
    final til=til,
    final azi=azi,
    final rho=rho) "Diffuse solar irradiation on a tilted surface"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
    final til=til,
    final azi=azi)
      "Direct solar irradiation on a tilted surface"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add HTotTil(
    final k1 = 1,
    final k2 = 1,
    u1(final unit="W/m2"),
    u2(final unit="W/m2"),
    y(final unit="W/m2"))
    "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
protected
  Buildings.Utilities.Math.SmoothHeaviside smoHea(final delta=delY)
    "Creates a smooth 1/0 output"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

equation
  connect(TIn, criSol.TIn)    annotation (Line(
      points = {{-120, -40}, {-84, -40}, {-84, -16}, {-62, -16}},
      color={0,0,127}));
  connect(weaBus.TDryBul, criSol.TEnv)    annotation (Line(points = {{-102, 60}, {-84, 60}, {-84, -4}, {-62, -4}}, color = {255, 204, 51}, thickness = 0.5));
  connect(smoHea.y, y)          annotation (Line(
      points={{81,0},{118,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, smoHea.u)          annotation (Line(
      points={{41,6.66134e-16},{50,6.66134e-16},{50,0},{58,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(criSol.G_TC, add.u2) annotation (Line(
      points={{-38.4,-10},{-30,-10},{-30,-6},{18,-6}},
      color={0,0,127}));
  connect(HDirTil.weaBus, weaBus) annotation (Line(
      points={{-60,30},{-84,30},{-84,60},{-102,60}},
      color={255,204,51},
      thickness=0.5));
  connect(HDifTilIso.weaBus, weaBus) annotation (Line(
      points={{-60,60},{-102,60}},
      color={255,204,51},
      thickness=0.5));
  connect(HDifTilIso.H, HTotTil.u1) annotation (Line(points={{-39,60},{-30,60},{
          -30,56},{-22,56}}, color={0,0,127}));
  connect(HDirTil.H, HTotTil.u2) annotation (Line(points={{-39,30},{-30,30},{-30,
          44},{-22,44}}, color={0,0,127}));
  connect(HTotTil.y, add.u1)
    annotation (Line(points={{1,50},{10,50},{10,6},{18,6}}, color={0,0,127}));
  annotation (
  defaultComponentName = "pumCon",
Documentation(info="<html>
<p>
This component models a pump controller which might be used in a solar thermal system.
It outputs whether the pump should be active or inactive based on the incident solar radiation,
the collector inlet temperature,
and the system parameters. The pump is commanded on when the incident solar radiation is
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
revisions = "<html>
<ul>
<li>
November 7, 2022, by Michael Wetter:<br/>
Corrected implementation to make comparison based on total irradiation on tilted surface
rather than the direct normal irradiation.
This required adding parameters for the azimuth, tilt and ground reflectance.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3074\">issue 3074</a>.
</li>
<li>
January 15, 2013 by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
      Text(
        extent={{226,60},{106,10}},
        textColor={0,0,0},
        textString=DynamicSelect("",String(y,
          leftJustified=false,
          significantDigits=3)))}));
end SolarPumpController;
