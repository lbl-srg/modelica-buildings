within Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible;
model SpeedControlled
  "Sensible heat recovery wheel with a variable speed drive"
  extends
    Buildings.Fluid.HeatExchangers.ThermalWheels.Sensible.BaseClasses.PartialWheel;
  parameter Boolean defaultMotorEfficiencyCurve = true
    "Set to true for using the default motor efficiency curve, or false for using the user-defined motor efficiency curve"
    annotation (Dialog(group="Efficiency"));
  parameter Real table[:,:]=[0.8,1]
    "Table of user-defined motor efficiency curve:(first column:the wheel speed ratio, second column:the percent full-load efficiency)"
    annotation (Dialog(group="Efficiency", enable = not defaultMotorEfficiencyCurve));
  final parameter
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot
      motorEfficiency_default=
        Buildings.Fluid.Movers.BaseClasses.Characteristics.motorEfficiencyCurve(
          P_nominal=P_nominal,
          eta_max=1)
    "Default motor efficiency curve";
  final parameter Real xSpe[:] = if defaultMotorEfficiencyCurve then motorEfficiency_default.y else table[:,1]
    "x-axis support points of the power efficiency curve"
    annotation (Dialog(group="Efficiency"));
  final parameter Real[size(xSpe,1)] yeta = if defaultMotorEfficiencyCurve then motorEfficiency_default.eta else table[:,2]
    "y-axis support points of the power efficiency curve"
    annotation (Dialog(group="Efficiency"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uSpe(
    final unit="1",
    final max=1)
    "Wheel speed ratio"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
protected
  Modelica.Blocks.Sources.RealExpression PEle(
    final y=P_nominal*uSpe/Buildings.Utilities.Math.Functions.smoothInterpolation(
      x=uSpe,
      xSup=xSpe,
      ySup=yeta))
    "Electric power consumption"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

initial equation
  assert(table[end,1] < 1 or defaultMotorEfficiencyCurve,
         "In " + getInstanceName() + ": Power efficiency curve is wrong. 
         No need to define efficiency for the nominal condition",
         level=AssertionLevel.error)
         "Check if the motor efficiency for the nominal condition is defined in the user-defined curve";
equation
  connect(P, PEle.y)
    annotation (Line(points={{120,-90},{81,-90}}, color={0,0,127}));
  connect(port_a1, hex.port_a1) annotation (Line(points={{-180,80},{-60,80},{-60,6},
    {-10,6}}, color={0,127,255}));
  connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{60,-6},{60,-60},
    {100,-60}}, color={0,127,255}));
  connect(effCal.uSpe, uSpe)
    annotation (Line(points={{-102,0},{-200,0}}, color={0,0,127}));
annotation (
        defaultComponentName="whe",
        Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
    graphics={
        Polygon(
          points={{0,100},{0,100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.None)}),
          Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{100,100}})),
Documentation(info="<html>
<p>
Model of a generic, sensible heat recovery wheel, which has the 
wheel speed as the input to control the heat recovery.
</p>
<p>
This model does not require geometric data. The performance is defined by specifying
the part load (75% of the nominal supply flow rate) and nominal sensible heat
exchanger effectiveness in both heating and cooling conditions.
</p>
<p>
The operation of the heat recovery wheel is adjustable by modulating the wheel speed.
</p>
<p>
Accordingly, the power consumption of this wheel is calculated by
</p>
<p align=\"center\" style=\"font-style:italic;\">
P = P_nominal * uSpe / eta,
</p>
<p>
where <code>P_nominal</code> is the nominal wheel power consumption,
<code>uSpe</code> is the wheel speed ratio.
The <code>eta</code> is the motor percent full-load efficiency, i.e.,
the ratio of the motor efficiency to that when the <code>uSpe</code> is <i>1</i>.   
There are two ways to define <code>eta</code>:
</p>
<ul>
<li>
Default curves in U.S. DOE (2014).
</li>
<li>
Polynomial fit based on the user input data table.
</li>
</ul>
<p>
One can switch between those two options with the parameter <code>defaultMotorEfficiencyCurve</code>.
</p>
<p>
The sensible and latent effectiveness is calculated with
<a href=\"modelica://Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.Effectiveness\">
Buildings.Fluid.HeatExchangers.ThermalWheels.Latent.BaseClasses.Effectiveness</a>.
</p>
<h4>References</h4>
<p>
U.S. DOE (2014).
<i>Determining Electric Motor Load and Efficiency.</i>
URL:
<a href=\"https://www.energy.gov/sites/prod/files/2014/04/f15/10097517.pdf\">
https://www.energy.gov/sites/prod/files/2014/04/f15/10097517.pdf</a>
</p>
</html>", revisions="<html>
<ul>
<li>
January 8, 2024, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SpeedControlled;
