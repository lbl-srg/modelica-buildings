within Buildings.Examples.VAVReheat.ThermalZones;
model VAVBranch "Supply branch of a VAV system"
  extends Modelica.Blocks.Icons.Block;
  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air" annotation (choicesAllMatching=true);
  replaceable package MediumW = Modelica.Media.Interfaces.PartialMedium
    "Medium model for water" annotation (choicesAllMatching=true);
  Buildings.Fluid.Actuators.Dampers.VAVBoxExponential vav(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="Pa") = 220 + 20) "VAV box for room" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,40})));
  Buildings.Fluid.HeatExchangers.DryEffectivenessNTU terHea(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal*1000*(50 - 17)/4200/10,
    Q_flow_nominal=m_flow_nominal*1006*(50 - 16.7),
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    dp1_nominal=0,
    from_dp2=true,
    dp2_nominal=0,
    T_a1_nominal=289.85,
    T_a2_nominal=355.35) "Heat exchanger of terminal box" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-44,0})));
  Buildings.Fluid.Sources.FixedBoundary sinTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 3E5,
    nPorts=1) "Sink for terminal box " annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={80,-20})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(redeclare package Medium =
        MediumA)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}}),
        iconTransformation(extent={{-60,-110},{-40,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_b(redeclare package Medium =
        MediumA)
    "Fluid connector b (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}}),
        iconTransformation(extent={{-60,90},{-40,110}})));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Mass flow rate of this thermal zone";
  parameter Modelica.SIunits.Volume VRoo "Room volume";
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium =
        MediumA) "Sensor for mass flow rate" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-50,70})));
  Modelica.Blocks.Math.Gain fraMasFlo(k=1/m_flow_nominal)
    "Fraction of mass flow rate, relative to nominal flow"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Blocks.Math.Gain ACH(k=1/VRoo/1.2*3600) "Air change per hour"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHea(
    redeclare package Medium = MediumW,
    m_flow_nominal=m_flow_nominal*1000*15/4200/10,
    CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    from_dp=true,
    dpFixed_nominal=6000,
    dpValve_nominal=6000) "Valve at reaheat coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,-30}})));
  Buildings.Fluid.Sources.FixedBoundary souTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 3E5 + 12000,
    nPorts=1,
    T=323.15) "Source for terminal box " annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={82,20})));
  Modelica.Blocks.Interfaces.RealInput yVAV
    "Actuator position for VAV damper (0: closed, 1: open)" annotation (
      Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput yVal
    "Actuator position for reheat valve (0: closed, 1: open)" annotation (
      Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
equation
  connect(fraMasFlo.u, senMasFlo.m_flow) annotation (Line(
      points={{-2,80},{-24,80},{-24,70},{-39,70}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(vav.port_b, senMasFlo.port_a) annotation (Line(
      points={{-50,50},{-50,60}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(ACH.u, senMasFlo.m_flow) annotation (Line(
      points={{-2,50},{-24,50},{-24,70},{-39,70}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(souTer.ports[1], terHea.port_a2) annotation (Line(
      points={{72,20},{-38,20},{-38,10}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(terHea.port_b2, valHea.port_a) annotation (Line(
      points={{-38,-10},{-38,-20},{-10,-20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(valHea.port_b, sinTer.ports[1]) annotation (Line(
      points={{10,-20},{70,-20}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(port_a, terHea.port_a1) annotation (Line(
      points={{-50,-100},{-50,-10}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(senMasFlo.port_b, port_b) annotation (Line(
      points={{-50,80},{-50,100}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=0.5));
  connect(terHea.port_b1, vav.port_a) annotation (Line(
      points={{-50,10},{-50,30}},
      color={0,127,255},
      thickness=0.5));
  connect(vav.y, yVAV) annotation (Line(points={{-62,40},{-120,40}},
                color={0,0,127}));
  connect(valHea.y, yVal) annotation (Line(points={{0,-32},{0,-40},{-120,-40}},
                 color={0,0,127}));
  annotation (Icon(
    graphics={
        Rectangle(
          extent={{-108.07,-16.1286},{93.93,-20.1286}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={-68.1286,6.07},
          rotation=90),
        Rectangle(
          extent={{-68,-20},{-26,-60}},
          fillPattern=FillPattern.Solid,
          fillColor={175,175,175},
          pattern=LinePattern.None),
        Rectangle(
          extent={{100.8,-22},{128.8,-44}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192},
          origin={-82,-76.8},
          rotation=90),
        Rectangle(
          extent={{102.2,-11.6667},{130.2,-25.6667}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          origin={-67.6667,-78.2},
          rotation=90),
        Polygon(
          points={{-62,32},{-34,48},{-34,46},{-62,30},{-62,32}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-68,-28},{-34,-28},{-34,-30},{-68,-30},{-68,-28}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-68,-52},{-34,-52},{-34,-54},{-68,-54},{-68,-52}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-48,-34},{-34,-28},{-34,-30},{-48,-36},{-48,-34}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-48,-34},{-34,-40},{-34,-42},{-48,-36},{-48,-34}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-48,-46},{-34,-52},{-34,-54},{-48,-48},{-48,-46}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-48,-46},{-34,-40},{-34,-42},{-48,-48},{-48,-46}},
          pattern=LinePattern.None,
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0})}));
end VAVBranch;
