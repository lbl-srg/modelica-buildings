within Buildings.Applications.DHC.CentralPlants.Subsystems;
model CoolingTowerParellel "Multipul cooling towers in parallel connection"
  replaceable package MediumCW =
      Buildings.Media.Water
    "Medium in the  condenser water side";
  parameter Modelica.SIunits.Power P_nominal
    "Nominal cooling tower power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTCW_nominal
    "Temperature difference between the outlet and inlet of the tower ";
  parameter Modelica.SIunits.TemperatureDifference dTApp_nominal
    "Nominal approach temperature";
  parameter Modelica.SIunits.Temperature TWetBul_nominal
    "Nominal wet bulb temperature";
  parameter Modelica.SIunits.Pressure dP_nominal
    "Pressure difference between the outlet and inlet of the tower ";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal
    "Nominal mass flow rate at condenser water wide";
  parameter Real GaiPi "Gain of the tower PI controller";
  parameter Real tIntPi "Integration time of the tower PI controller";
  parameter Real v_flow_rate[:] "Air volume flow rate ratio";
  parameter Real eta[:] "Fan efficiency";
  parameter Modelica.SIunits.Temperature TCW_start
    "The start temperature of condenser water side";
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumCW)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        MediumCW)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul
    "Entering air wet bulb temperature"
    annotation (Placement(transformation(extent={{-118,-69},{-100,-51}})));
  Modelica.Blocks.Interfaces.RealInput TCWSet
    "Temperature set point of the condenser water"
    annotation (Placement(transformation(extent={{-118,70},{-100,88}})));
  WaterSide.BaseClasses.Components.VSDCoolingTower ct2(
    redeclare package MediumCW = MediumCW,
    P_nominal=P_nominal,
    dTCW_nominal=dTCW_nominal,
    dTApp_nominal=dTApp_nominal,
    TWetBul_nominal=TWetBul_nominal,
    dP_nominal=dP_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    GaiPi=GaiPi,
    tIntPi=tIntPi,
    eta=eta,
    TCW_start=TCW_start,
    v_flow_rate=v_flow_rate)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  WaterSide.BaseClasses.Components.VSDCoolingTower ct3(
    redeclare package MediumCW = MediumCW,
    P_nominal=P_nominal,
    dTCW_nominal=dTCW_nominal,
    dTApp_nominal=dTApp_nominal,
    TWetBul_nominal=TWetBul_nominal,
    dP_nominal=dP_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    GaiPi=GaiPi,
    tIntPi=tIntPi,
    eta=eta,
    TCW_start=TCW_start,
    v_flow_rate=v_flow_rate)
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Modelica.Blocks.Interfaces.RealInput On[3]
    "Temperature set point of the condenser water"
    annotation (Placement(transformation(extent={{-118,30},{-100,48}})));
equation
  connect(ct2.port_a_CW, port_a) annotation (Line(
      points={{-10,0},{-100,0}},
      color={0,127,255},
      thickness=1));
  connect(ct3.port_a_CW, port_a) annotation (Line(
      points={{-10,-60},{-60,-60},{-60,0},{-100,0}},
      color={0,127,255},
      thickness=1));
  connect(ct2.port_b_CW, port_b) annotation (Line(
      points={{10,0},{100,0}},
      color={0,127,255},
      thickness=1));
  connect(ct3.port_b_CW, port_b) annotation (Line(
      points={{10,-60},{60,-60},{60,0},{100,0}},
      color={0,127,255},
      thickness=1));
  connect(ct2.TSet, TCWSet) annotation (Line(
      points={{-12,8},{-40,8},{-40,68},{-56,68},{-56,79},{-109,79}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ct3.TSet, TCWSet) annotation (Line(
      points={{-12,-52},{-40,-52},{-40,68},{-56,68},{-56,79},{-109,79}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TWetBul, ct3.TWetBul) annotation (Line(
      points={{-109,-60},{-68,-60},{-68,-64},{-12,-64}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ct2.TWetBul, ct3.TWetBul) annotation (Line(
      points={{-12,-4},{-68,-4},{-68,-64},{-12,-64}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(On[3], ct3.On) annotation (Line(
      points={{-109,45},{-50,45},{-50,-56},{-12,-56}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(ct2.On, On[2]) annotation (Line(
      points={{-12,4},{-12,4},{-78,4},{-78,39},{-109,39}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}})),           Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-44,-144},{50,-112}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-14,68},{14,40}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,76},{10,68}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,72},{-2,70}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{2,72},{10,70}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-8,60},{-10,54}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-8,60},{-6,54}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,60},{-2,54}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,60},{2,54}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{8,60},{6,54}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{8,60},{10,54}},
          color={255,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-14,8},{14,-20}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,16},{10,8}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,12},{-2,10}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{2,12},{10,10}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-8,0},{-10,-6}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-8,0},{-6,-6}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,0},{-2,-6}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,0},{2,-6}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{8,0},{6,-6}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{8,0},{10,-6}},
          color={255,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-14,-52},{14,-80}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,-44},{10,-52}},
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-10,-48},{-2,-50}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{2,-48},{10,-50}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-8,-60},{-10,-66}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-8,-60},{-6,-66}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,-60},{-2,-66}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{0,-60},{2,-66}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{8,-60},{6,-66}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{8,-60},{10,-66}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-100,0},{-40,0},{-40,60},{8,60}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,0},{8,0}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{-40,0},{-40,-60},{8,-60}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{14,40},{40,40},{40,0},{90,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{14,-20},{40,-20},{40,0}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{14,-80},{40,-80},{40,-20}},
          color={0,0,255},
          smooth=Smooth.None)}),
    Documentation(revisions="<html>
<ul>
<li>
March 30, 2014 by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingTowerParellel;
