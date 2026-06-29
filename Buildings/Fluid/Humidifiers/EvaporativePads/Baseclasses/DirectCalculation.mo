within Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses;
block DirectCalculation
  "Calculates the water vapor mass flow rate of a direct evaporative pad"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium";
  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media evaporative pad";
  replaceable parameter Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic per
    constrainedby Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic
    "Record with performance data for evaporative pads"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,60},{80,80}})));
  final parameter Real etaDer[size(per.efficiency.v,1)]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
    x=per.efficiency.v,
    y=per.efficiency.eta,
    ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
      x=per.efficiency.eta,
      strict=false));
  Real eta(
    final unit="1")
    "Evaporative humidifier efficiency";
  Modelica.Units.SI.Velocity v
    "Air velocity";
  Modelica.Units.SI.ThermodynamicTemperature TDryBulOut(
    displayUnit="degC")
    "Dry bulb temperature of the outlet air";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput V_flow(
    final unit="m3/s",
    final quantity = "VolumeFlowRate")
    "Air volume flow rate"
    annotation (Placement(transformation(origin={-120,-20},extent={{-20,-20},{20,20}}),
      iconTransformation(origin={-120,-20}, extent={{-20,-20},{20,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDryBulIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Dry bulb temperature of the inlet air"
    annotation (Placement(transformation(origin={-120,60},extent={{-20,-20},{20,20}}),
      iconTransformation(origin={-120,20}, extent={{-20,-20},{20,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWetBulIn(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Wet bulb temperature of the inlet air"
    annotation (Placement(transformation(origin={-120,20}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={-120,60}, extent={{-20,-20},{20,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput p(
    final unit="Pa",
    final quantity="Pressure")
    "Inlet air pressure"
    annotation (Placement(transformation(origin={-120,-60},extent={{-20,-20},{20,20}}),
      iconTransformation(origin={-120,-60}, extent={{-20,-20},{20,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dmWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "Water vapor mass flow rate difference between inlet and outlet"
    annotation (Placement(transformation(origin={120,0}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={120,0}, extent={{-20,-20},{20,20}})));
  Buildings.Utilities.Psychrometrics.Xw_TDryBulTWetBul XWOut(
    redeclare package Medium = Medium)
    "Water vapor mass fraction at the outlet";
  Buildings.Utilities.Psychrometrics.Xw_TDryBulTWetBul XWIn(
    redeclare package Medium =  Medium)
    "Water vapor mass fraction at the inlet";
protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default)
    "Default state of medium";
  parameter Modelica.Units.SI.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";
equation
  v =abs(V_flow)/padAre;
  eta =
    Buildings.Fluid.Humidifiers.EvaporativePads.Baseclasses.Characteristics.saturationEfficiency(
    per=per.efficiency,
    v=v,
    d=etaDer);
  TDryBulOut = TDryBulIn - eta*(TDryBulIn - TWetBulIn);
  TDryBulIn = XWIn.TDryBul;
  TWetBulIn = XWIn.TWetBul;
  p = XWIn.p;
  TWetBulIn = XWOut.TWetBul;
  p = XWOut.p;
  TDryBulOut = XWOut.TDryBul;
  dmWat_flow = (XWOut.X_w - XWIn.X_w)*V_flow*rho_default;

annotation (defaultComponentName="dirEvaPadCal",
  Icon(graphics={
  Text(extent={{-152,144},{148,104}}, textString="%name", textColor={0,0,255}),
  Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0},
     fillColor={255,255,255}, fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This block calculates the water vapor mass flow rate addition into the air stream
from the direct evaporative pad.
</p>
<p>
The saturation efficiency of an evaporative pad <code>eta</code> is calculated using 
a data record <code>per</code>, which is an instance of
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic\">
Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic</a>. This data record
provides a performance map of discrete data points on how <code>eta</code> varies as
a function of the velocity of the air stream <code>v</code>.
</p>
<p>
<code>v</code> is calculated from the volume flow rate <code>V_flow</code> and
evaporative media cross-sectional area <code>padAre</code> using:
</p>
<p align=\"center\" style=\"font-style:italic;\">
v = V_flow/padAre
</p>
<p>
The outlet air drybulb temperature <code>TDryBulOut</code> is calculated using the
heat-balance equation:
</p>
<p align=\"center\" style=\"font-style:italic;\">
TDryBulOut = TDryBulIn - eta*(TDryBulIn - TWetBulIn)
</p>
<p>
where <code>TDryBulIn</code> is the inlet air drybulb temperature and
<code>TWetBulIn</code> is the inlet air wetbulb temperature.
</p>
<p>
The humidity ratio difference between the inlet and outlet air is used to calculate
the added mass of water vapor <code>dmWat_flow</code>, with the humidity ratios
being determined from psychrometric relationships, while assuming the outlet air
wetbulb temperature is the same as inlet air wetbulb temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
June 26, 2026, by Weiping Huang:<br/>
Replaced the EnergyPlus equation with a Modelica data record.
</li>
<li>
September 14, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end DirectCalculation;
