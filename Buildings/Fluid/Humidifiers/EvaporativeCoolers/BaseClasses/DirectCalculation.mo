within Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses;
block DirectCalculation
  "Calculates the saturation efficiency and the water vapor mass flow rate of a direct evaporative pad"

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium";
  parameter Modelica.Units.SI.Area padAre
    "Area of the rigid media evaporative pad";
  replaceable parameter Buildings.Fluid.Humidifiers.EvaporativeCoolers.Data.Generic per
    constrainedby Buildings.Fluid.Humidifiers.EvaporativeCoolers.Data.Generic
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
    annotation (Placement(transformation(origin={120,-50},
      extent={{-20,-20},{20,20}}), iconTransformation(origin={120,-50},
      extent={{-20,-20},{20,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput eta(final unit="1")
    "Evaporative humidifier efficiency"
    annotation (Placement(transformation(origin={120,50},extent={{-20,-20},{20,20}}),
      iconTransformation(origin={120,50},extent={{-20,-20},{20,20}})));
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
  eta = min(1, max(0,
    Buildings.Fluid.Humidifiers.EvaporativeCoolers.BaseClasses.Characteristics.saturationEfficiency(
      per=per.efficiency,
      v=v,
      d=etaDer)));
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
     fillColor={255,255,255}, fillPattern=FillPattern.Solid),
        Line(
          points={{-80,82},{-50,80},{-2,64},{26,38}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-84,88},{-84,36}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-84,36},{36,36}},
          color={0,0,0},
          smooth=Smooth.Bezier),
  Rectangle(lineColor={255, 255, 255}, fillColor={217,203,0},
            fillPattern=FillPattern.Solid, extent={{0,16},{-60,24}}),
  Rectangle(lineColor={255, 255, 255}, fillColor={217,203,0},
            fillPattern=FillPattern.Solid, extent={{-52,-88},{-60,16}}),
  Rectangle(lineColor={255, 255, 255}, fillColor={217,203,0},
            fillPattern=FillPattern.Solid, extent={{0,-96},{-60,-88}}),
  Rectangle(lineColor={255, 255, 255}, fillColor={217,203,0},
            fillPattern=FillPattern.Solid, extent={{0,-88},{-8,16}}),
        Polygon(
          points={{-48,2},{-50,-8},{-44,-12},{-36,-8},{-38,2},{-44,14},{-48,2}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-48,-34},{-50,-44},{-44,-48},{-36,-44},{-38,-34},{-44,-22},{-48,
              -34}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-48,-68},{-50,-78},{-44,-82},{-36,-78},{-38,-68},{-44,-56},{-48,
              -68}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-24,2},{-26,-8},{-20,-12},{-12,-8},{-14,2},{-20,14},{-24,2}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-24,-34},{-26,-44},{-20,-48},{-12,-44},{-14,-34},{-20,-22},{-24,
              -34}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Polygon(
          points={{-24,-68},{-26,-78},{-20,-82},{-12,-78},{-14,-68},{-20,-56},{-24,
              -68}},
          lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          smooth=Smooth.Bezier),
        Text(extent={{58,60},{100,40}},
          textColor={0,0,127},
          textString="eta"),
        Text(extent={{38,-40},{98,-60}},
          textColor={0,0,127},
          textString="dmWat_flow")}),

    Documentation(info="<html>
<p>
This block calculates the saturation efficiency of the direct evaporative pad, as
well as the water vapor mass flow rate addition into the air stream from the direct
evaporative pad.
</p>
<p>
The saturation efficiency of an evaporative pad <code>eta</code> is calculated using 
a data record <code>per</code>, which is an instance of
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.Data.Generic\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.Data.Generic</a>. This data record
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
<p>
This block also enforces the saturation efficiency value <code>eta</code> to be
between <i>0</i> and <i>1</i>.
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
