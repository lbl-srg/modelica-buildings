within Buildings.Obsolete.Examples.VAVReheat.BaseClasses;
model VAVBranch "Supply branch of a VAV system"
  extends Modelica.Blocks.Icons.Block;
  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air" annotation (choicesAllMatching=true);
  replaceable package MediumW = Modelica.Media.Interfaces.PartialMedium
    "Medium model for water" annotation (choicesAllMatching=true);

  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Mass flow rate of this thermal zone";
  parameter Modelica.Units.SI.Volume VRoo "Room volume";

  Buildings.Fluid.Actuators.Dampers.PressureIndependent vav(
    redeclare package Medium = MediumA,
    m_flow_nominal=m_flow_nominal,
    dpDamper_nominal=220 + 20,
    allowFlowReversal=allowFlowReversal) "VAV box for room" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,40})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU terHea(
    redeclare package Medium1 = MediumA,
    redeclare package Medium2 = MediumW,
    m1_flow_nominal=m_flow_nominal,
    m2_flow_nominal=m_flow_nominal*1000*(50 - 17)/4200/10,
    Q_flow_nominal=m_flow_nominal*1006*(16.7 - 50),
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    dp1_nominal=0,
    from_dp2=true,
    dp2_nominal=0,
    allowFlowReversal1=allowFlowReversal,
    allowFlowReversal2=false,
    T_a1_nominal=289.85,
    T_a2_nominal=355.35) "Heat exchanger of terminal box" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-44,0})));
  Buildings.Fluid.Sources.Boundary_pT sinTer(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 3E5,
    nPorts=1) "Sink for terminal box " annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,-20})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = MediumA)
    "Fluid connector a1 (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}}),
        iconTransformation(extent={{-60,-110},{-40,-90}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_b(
    redeclare package Medium = MediumA)
    "Fluid connector b (positive design flow direction is from port_a1 to port_b1)"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}}),
        iconTransformation(extent={{-60,90},{-40,110}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare package Medium = MediumA,
    allowFlowReversal=allowFlowReversal)
    "Sensor for mass flow rate" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-50,70})));
  Modelica.Blocks.Math.Gain fraMasFlo(k=1/m_flow_nominal)
    "Fraction of mass flow rate, relative to nominal flow"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Blocks.Math.Gain ACH(k=1/VRoo/1.2*3600) "Air change per hour"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Fluid.Sources.MassFlowSource_T souTer(
    redeclare package Medium = MediumW,
    nPorts=1,
    use_m_flow_in=true,
    T=323.15) "Source for terminal box " annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={40,20})));
  Modelica.Blocks.Interfaces.RealInput yVAV "Signal for VAV damper"
                                                            annotation (
      Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput yVal
    "Actuator position for reheat valve (0: closed, 1: open)" annotation (
      Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gaiM_flow(final k=
        m_flow_nominal*1000*15/4200/10) "Gain for mass flow rate"
    annotation (Placement(transformation(extent={{80,2},{60,22}})));
  Modelica.Blocks.Interfaces.RealOutput y_actual "Actual VAV damper position"
    annotation (Placement(transformation(extent={{100,46},{120,66}}),
        iconTransformation(extent={{100,70},{120,90}})));
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
      points={{-2,40},{-24,40},{-24,70},{-39,70}},
      color={0,0,127},
      smooth=Smooth.None,
      pattern=LinePattern.Dash));
  connect(souTer.ports[1], terHea.port_a2) annotation (Line(
      points={{30,20},{-38,20},{-38,10}},
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
  connect(souTer.m_flow_in, gaiM_flow.y)
    annotation (Line(points={{52,12},{58,12}}, color={0,0,127}));
  connect(sinTer.ports[1], terHea.port_b2) annotation (Line(points={{30,-20},{
          -38,-20},{-38,-10}}, color={0,127,255}));
  connect(gaiM_flow.u, yVal) annotation (Line(points={{82,12},{90,12},{90,-40},
          {-120,-40}}, color={0,0,127}));
  connect(vav.y_actual, y_actual)
    annotation (Line(points={{-57,45},{-57,56},{110,56}}, color={0,0,127}));
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
          lineColor={0,0,0})}), Documentation(info="<html>
<p>
Model for a VAV supply branch.
The terminal VAV box has a pressure independent damper and a water reheat coil.
The pressure independent damper model includes an idealized flow rate controller
and requires a discharge air flow rate set-point (normalized to the nominal value)
as a control signal.
</p>
</html>", revisions="<html>
<ul>
<li>
February 25, 2021, by Baptiste Ravache:<br/>
Inverse the sign of <code>terHea.Q_flow_nominal</code> to respect the heat flow convention.
</li>
<li>
February 12, 2021, by Baptiste Ravache:<br/>
Replaced by <code>Buildings.Examples.VAVReheat.BaseClasses.VAVReheatBox</code> and
moved to <code>Obsolete</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2059\">#2024</a>.
</li>
</ul>
</html>"));
end VAVBranch;
