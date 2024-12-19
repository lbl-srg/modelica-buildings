within Buildings.Fluid.CHPs.DistrictCHP;
model Combined "Combined-cycle CHP model"

  package MediumSte = Buildings.Media.Steam
    "Steam medium - Medium model for port_b (outlet)";
  package MediumWat =
      Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - Medium model for port_a (inlet)";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput y
    "Part load ratio"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmb
    "Ambient temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEle
    "Gas turbine electricity generation"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mFue
    "Fuel mass flow rate"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEle_ST
    "Steam turbine electricity generation"
    annotation (Placement(transformation(extent={{100,10},{140,50}}),
        iconTransformation(extent={{100,10},{140,50}})));

  ToppingCycle topCycTab(
    redeclare Buildings.Fluid.CHPs.DistrictCHP.Data.SolarTurbines.NaturalGas.Centaur50_T6200S_NG
      per)
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium =MediumWat)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-10},{-110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium =MediumSte)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));
  BottomingCycle botCycExp
    annotation (Placement(transformation(extent={{14,-10},{34,8}})));

equation
  connect(topCycTab.PEle, PEle) annotation (Line(points={{-38,58},{20,58},{20,90},
          {120,90}}, color={0,0,127}));
  connect(topCycTab.mFue, mFue) annotation (Line(points={{-38,52},{40,52},{40,
          60},{120,60}},
                     color={0,0,127}));
  connect(port_b, port_b)
    annotation (Line(points={{100,0},{100,0}}, color={0,127,255}));
  connect(y, topCycTab.y) annotation (Line(points={{-120,80},{-80,80},{-80,54},{
          -62,54}},  color={0,0,127}));
  connect(TAmb, topCycTab.TSet) annotation (Line(points={{-120,40},{-80,40},{-80,
          46},{-62,46}}, color={0,0,127}));
  connect(port_b, botCycExp.port_b)
    annotation (Line(points={{100,0},{34,0}}, color={0,127,255}));
  connect(port_a, botCycExp.port_a) annotation (Line(points={{-100,0},{14,0}},
          color={0,127,255}));
  connect(botCycExp.TAmb, TAmb) annotation (Line(points={{12,6},{-80,6},{-80,40},
          {-120,40}}, color={0,0,127}));
  connect(topCycTab.mExh, botCycExp.mExh) annotation (Line(points={{-38,42},{-10,
          42},{-10,3},{12,3}}, color={0,0,127}));
  connect(PEle_ST, PEle_ST)
    annotation (Line(points={{120,30},{120,30}}, color={0,0,127}));
  connect(botCycExp.PEle_ST, PEle_ST) annotation (Line(points={{36,8},{60,8},{60,
          30},{120,30}}, color={0,0,127}));
  connect(topCycTab.TExh, botCycExp.TExh) annotation (Line(points={{-38,48},{0,48},
          {0,9},{12,9}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-4},{100,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
March 28, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is the combined-cycle CHP model including the topping cycle and the bottoming cycle models.
</p>
</html>"));
end Combined;
