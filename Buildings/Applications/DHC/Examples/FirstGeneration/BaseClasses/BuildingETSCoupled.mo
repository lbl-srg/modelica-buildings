within Buildings.Applications.DHC.Examples.FirstGeneration.BaseClasses;
model BuildingETSCoupled "Model to simulate the demand side"
    replaceable package Medium =
      Buildings.Media.Water "Medium water";
    parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate ";
    parameter Modelica.SIunits.Pressure dP_nominal "Nominal pressure drop";
    parameter Modelica.SIunits.Temperature TBuiSetPoi
    "Set point of the building temperature";
    parameter Real GaiPi "Gain of the PI controller";
    parameter Real tIntPi "Integration time of the PI controller";
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow prescribedHeatFlow
    annotation (Placement(transformation(extent={{-84,30},{-64,50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        Medium)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(redeclare package Medium =
        Medium)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Modelica.Blocks.Interfaces.RealInput Loa "Cooling load"
    annotation (Placement(transformation(extent={{-118,31},{-100,49}})));
  Modelica.Blocks.Interfaces.RealOutput dP "Pressure difference"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial,
    nPorts=2,
    m_flow_nominal=m_flow_nominal,
    V=V,
    T_start=TBuiSetPoi)
          annotation (Placement(transformation(extent={{-42,0},{-22,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTLeaPri(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-80,10},{-60,-10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTEntPri(redeclare package
      Medium = Medium, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{60,10},{80,-10}})));
  Modelica.Blocks.Interfaces.RealOutput TEntPri
    "Temperature of the passing fluid"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealOutput TLeaPri
    "Temperature of the passing fluid"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Sources.RealExpression dPVal(y=val.dp)
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Modelica.Blocks.Sources.RealExpression yVal(y=val.y)
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Modelica.Blocks.Interfaces.RealOutput y "Value of Real output"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  parameter Modelica.SIunits.Volume V=4000
    "Volume of water in the secondary loop";
  Buildings.Fluid.Sensors.MassFlowRate senMasFloCHWPri(redeclare package Medium
      = Medium)
    annotation (Placement(transformation(extent={{-18,-10},{0,10}})));
  Modelica.Blocks.Sources.RealExpression LoaCal(y=senMasFloCHWPri.m_flow*(
        senTEntPri.T - senTLeaPri.T)*4200)
    annotation (Placement(transformation(extent={{-74,-70},{-54,-50}})));
  Modelica.Blocks.Interfaces.RealOutput LoaCalSig "Value of Real output"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
equation
  connect(prescribedHeatFlow.Q_flow, Loa) annotation (Line(
      points={{-84,40},{-109,40}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(vol.ports[1], senTLeaPri.port_b) annotation (Line(
      points={{-34,0},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senTLeaPri.port_a, port_a) annotation (Line(
      points={{-80,0},{-100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senTEntPri.port_b, port_b) annotation (Line(
      points={{80,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(senTEntPri.T, TEntPri) annotation (Line(
      points={{70,-11},{70,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(senTLeaPri.T, TLeaPri) annotation (Line(
      points={{-70,-11},{-70,-40},{110,-40}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(dPVal.y, dP) annotation (Line(
      points={{61,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(yVal.y, y) annotation (Line(
      points={{61,80},{110,80}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(vol.ports[2], senMasFloCHWPri.port_a) annotation (Line(
      points={{-30,0},{-18,0}},
      color={0,127,255},
      thickness=1));
  connect(LoaCal.y, LoaCalSig) annotation (Line(
      points={{-53,-60},{-18,-60},{20,-60},{20,-100},{110,-100}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(senMasFloCHWPri.port_b, senTEntPri.port_a) annotation (Line(
      points={{0,0},{60,0}},
      color={0,127,255},
      thickness=1));
  connect(prescribedHeatFlow.port, vol.heatPort) annotation (Line(points={{-64,
          40},{-50,40},{-50,10},{-42,10}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Text(
          extent={{-32,-114},{40,-142}},
          lineColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{0,80},{-80,40},{80,40},{0,80}},
          lineColor={0,0,127},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,40},{60,-80}},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{0,0},{0,0}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,10},{0,0},{-10,-10},{-10,10}},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{10,10},{0,0},{10,-10},{10,10}},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(
          points={{-100,0},{-10,0}},
          color={255,0,0},
          smooth=Smooth.None),
        Line(
          points={{10,0},{90,0}},
          smooth=Smooth.None,
          color={0,0,255}),
        Ellipse(
          extent={{-42,-24},{-20,-50}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{-36,-30},{-26,-46}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="T"),
        Line(
          points={{-20,-36},{0,-36},{0,0}},
          color={0,0,0},
          smooth=Smooth.None,
          pattern=LinePattern.Dash)}),      Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(revisions="<html>
<ul>
<li>
March 19, 2014 by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingETSCoupled;
