within Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses;
model CoolingTowerVariableSpeed "Base class for cooling towers with variable speed fan"
  extends Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower;

  import cha =
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics;

  parameter Modelica.Units.SI.Power PFan_nominal
    "Fan power at full speed" annotation (Dialog(group="Fan"));

  parameter Real yMin(min=0.01, max=1, final unit="1") = 0.3
    "Minimum control signal until fan is switched off (used for smoothing
    between forced and free convection regime)"
    annotation (Dialog(group="Fan"));

  parameter cha.fan fanRelPow(
       r_V = {0, 0.1,   0.3,   0.6,   1},
       r_P = {0, 0.1^3, 0.3^3, 0.6^3, 1})
    "Fan relative power consumption as a function of control signal, fanRelPow=P(y)/P(y=1)"
    annotation (
    Placement(transformation(extent={{22,70},{42,90}})),
    Dialog(group="Fan"));

  Modelica.Blocks.Interfaces.RealInput TAir(
    final min=0,
    final unit="K",
    displayUnit="degC")
    "Entering air wet bulb temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput y(unit="1") "Fan control signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealOutput PFan(
    final quantity="Power",
    final unit="W")
    "Electric power consumed by fan"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));

protected
  parameter Real fanRelPowDer[size(fanRelPow.r_V,1)] =
    Buildings.Utilities.Math.Functions.splineDerivatives(
        x=fanRelPow.r_V,
        y=fanRelPow.r_P,
        ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
          x=fanRelPow.r_P,
          strict=false))
    "Coefficients for fan relative power consumption as a function of control signal";

  Modelica.Blocks.Sources.RealExpression PFan_y(
    y(
    final quantity="Power",
      final unit="W") =
      Buildings.Utilities.Math.Functions.spliceFunction(
        pos=cha.normalizedPower(per=fanRelPow, r_V=y, d=fanRelPowDer) * PFan_nominal,
        neg=0,
        x=y-yMin+yMin/20,
        deltax=yMin/20))
      "Electricity use of fan"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
initial equation
  // Check validity of relative fan power consumption at y=yMin and y=1
  assert(cha.normalizedPower(per=fanRelPow, r_V=yMin, d=fanRelPowDer) > -1E-4,
    "The fan relative power consumption must be non-negative for y=0."
  + "\n   Obtained fanRelPow(0) = "
  + String(cha.normalizedPower(per=fanRelPow, r_V=yMin, d=fanRelPowDer))
  + "\n   You need to choose different values for the parameter fanRelPow.");
  assert(abs(1-cha.normalizedPower(per=fanRelPow, r_V=1, d=fanRelPowDer))<1E-4,
  "The fan relative power consumption must be one for y=1."
  + "\n   Obtained fanRelPow(1) = "
  + String(cha.normalizedPower(per=fanRelPow, r_V=1, d=fanRelPowDer))
  + "\n   You need to choose different values for the parameter fanRelPow.");

equation
  connect(PFan_y.y, PFan)
    annotation (Line(points={{81,80},{110,80}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-98,100},{-86,84}},
          textColor={0,0,127},
          textString="y"),
        Text(
          extent={{-104,70},{-70,32}},
          textColor={0,0,127},
          textString="TWB"),
        Rectangle(
          extent={{-100,81},{-70,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-54,62},{0,50}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,62},{54,50}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,82},{100,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,56},{82,52}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,54},{82,80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{64,114},{98,76}},
          textColor={0,0,127},
          textString="PFan"),
        Rectangle(
          extent={{-100,41},{-70,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(
info="<html>
<p>
Base model for a steady-state or dynamic cooling tower with a variable speed fan.
This base model is used for both the Merkel and York calculation.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 18, 2026, by Michael Wetter:<br/>
Moved <code>TAirInWB_nominal</code> to parent classes to allow this model to also
be used for a dry cooler.
</li>
<li>
August 26, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingTowerVariableSpeed;
