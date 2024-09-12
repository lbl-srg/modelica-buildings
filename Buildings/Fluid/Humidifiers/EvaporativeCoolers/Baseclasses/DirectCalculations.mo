within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses;
block DirectCalculations
  "Calculates the water vapor mass flow rate of a direct evaporative coolder"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium";

  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media evaporative pad";

  parameter Modelica.Units.SI.Length dep
    "Depth of the rigid media evaporative pad";

  Real eff(
    final unit="1")
    "Evaporative humidifier efficiency";

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
    final quantity="AbsolutePressure")
    "Pressure"
    annotation (Placement(transformation(origin={-120,-60},extent={{-20,-20},{20,20}}),
      iconTransformation(origin={-120,-60}, extent={{-20,-20},{20,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dmWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "Water vapor mass flow rate difference between inlet and outlet"
    annotation (Placement(transformation(origin={120,0}, extent={{-20,-20},{20,20}}),
      iconTransformation(origin={120,0}, extent={{-20,-20},{20,20}})));

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Xi_TDryBulTWetBul
    XiOut(redeclare package Medium = Medium)
    "Water vapor mass fraction at the outlet";

  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.Xi_TDryBulTWetBul
    XiIn(redeclare package Medium =  Medium)
    "Water vapor mass fraction at the inlet";

  Modelica.Units.SI.Velocity vel
    "Air velocity";

  Modelica.Units.SI.ThermodynamicTemperature TDryBulOut(
    displayUnit="degC")
    "Dry bulb temperature of the outlet air";

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default)
    "Default state of medium";

  parameter Modelica.Units.SI.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";

  parameter Real effCoe[11] = {0.792714, 0.958569, -0.25193, -1.03215, 0.0262659,
                               0.914869, -1.48241, -0.018992, 1.13137, 0.0327622,
                               -0.145384}
    "Coefficients for evaporative medium efficiency calculation";

equation
  vel =abs(V_flow)/padAre;
  eff = effCoe[1] + effCoe[2]*(dep) + effCoe[3]*(vel)  + effCoe[4]*(dep^2) +
    effCoe[5]*(vel^2) + effCoe[6]*(dep*vel)  + effCoe[7]*(vel*dep^2) +
    effCoe[8]*(dep*vel^3) + effCoe[9]*(dep^3*vel) + effCoe[10]*(vel^3*dep^2) +
    effCoe[11]*(dep^3*vel^2);
  TDryBulOut = TDryBulIn - eff*(TDryBulIn - TWetBulIn);
  TDryBulIn = XiIn.TDryBul;
  TWetBulIn = XiIn.TWetBul;
  p = XiIn.p;
  TWetBulIn = XiOut.TWetBul;
  p = XiOut.p;
  TDryBulOut = XiOut.TDryBul;
  dmWat_flow = (XiOut.Xi[1] - XiIn.Xi[1])*V_flow*rho_default;

annotation (Documentation(info="<html>
<p>
Block that calculates the water vapor mass flow rate addition in the 
direct evaporative cooler component. The calculations are based on the direct 
evaporative cooler model in the Engineering Reference document from EnergyPlus v23.1.0.
</p>
<p>
The effectiveness of the evaporative media <code>eff</code> is calculated using 
the curve
</p>
<p align=\"center\" style=\"font-style:italic;\">
  eff = effCoe[1] + effCoe[2]*(dep) + effCoe[3]*(vel)  + effCoe[4]*(dep<sup>2</sup>) +
    effCoe[5]*(vel<sup>2</sup>) + effCoe[6]*(dep*vel)  + effCoe[7]*(vel*dep<sup>2</sup>) +
    effCoe[8]*(dep*vel<sup>3</sup>) + effCoe[9]*(dep<sup>3</sup>*vel) + effCoe[10]*(vel<sup>3</sup>*dep<sup>2</sup>) +
    effCoe[11]*(dep<sup>3</sup>*vel<sup>2</sup>)
</p>
<p>
where <code>effCoe[:]</code> is the evaporative efficiency coefficients for the
CelDek rigid media pad used in evaporative coolers. It is currently protected from
modification by the user, but can be modified for other materials within this class
by advanced users. <code>dep</code> is the depth of the evaporative media, and
<code>vel</code> is the velocity of the fluid media which is calculated from the volume flowrate
<code>V_flow</code> and evaporative media cross-sectional area <code>padAre</code>
using
</p>
<p align=\"center\" style=\"font-style:italic;\">
vel = V_flow/padAre
</p>
<p>
The outlet air drybulb temperature <code>TDryBulOut</code> is calculated using
the heat-balance equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
TDryBulOut = TDryBulIn - eff*(TDryBulIn - TWetBulIn)
</p>
<p>
where <code>TDryBulIn</code> is the inlet air drybulb temperature and 
<code>TWetBulIn</code> is the inlet air wetbulb temperature.
</p>
<p>
The humidity ratio difference between the inlet and outlet air is used to 
calculate the added mass of water vapor <code>dmWat_flow</code>, with the humidity 
ratios being determined from psychrometric relationships, while assuming the 
outlet air wetbulb temperature is the same as inlet air wetbulb temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
September 14, 2023 by Cerrina Mouchref, Karthikeya Devaprasad, Lingzhe Wang:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
  Text(extent={{-152,144},{148,104}}, textString="%name", textColor={0,0,255}),
  Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,0},
     fillColor={255,255,255}, fillPattern=FillPattern.Solid)}));
end DirectCalculations;
