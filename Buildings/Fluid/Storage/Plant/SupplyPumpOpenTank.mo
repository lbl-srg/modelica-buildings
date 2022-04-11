within Buildings.Fluid.Storage.Plant;
model SupplyPumpOpenTank
  "(Draft) Model section with supply pump and valves for an open tank"

  extends Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts;

/*  parameter Boolean allowRemoteCharging = true
    "= true if the tank is allowed to be charged by a remote source";*/

  Buildings.Fluid.Movers.SpeedControlled_y pum(
    redeclare package Medium = Medium,
    per(pressure(dp=nom.dp_nominal*{2,1.2,0}, V_flow=(nom.m_flow_nominal)/1.2*{0,
            1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=nom.T_CHWR_nominal) "Secondary CHW pump" annotation (Placement(
        transformation(
        extent={{-30,-10},{-10,10}},
        rotation=0)));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valDis1(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.m_flow_nominal)
    "Discharging valve, open when the tank NOT being charged remotely"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valCha1(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.m_flow_nominal)
    "Charging valve, open when the tank is being charged remotely"
    annotation (Placement(transformation(extent={{10,50},{-10,70}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valDis2(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.m_flow_nominal)
    "Discharging valve, open when the tank NOT being charged remotely"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={-40,20})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valDis3(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.m_flow_nominal)
    "Discharging valve, open when the tank NOT being charged remotely"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={40,20})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valCha2(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.m_flow_nominal)
    "Charging valve, open when the tank is being charged remotely" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,-20})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valCha3(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.m_flow_nominal)
    "Charging valve, open when the tank is being charged remotely" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-20})));
  FixedResistances.CheckValve                 cheVal(
    redeclare package Medium = Medium,
    m_flow_nominal=nom.m_flow_nominal,
    dpValve_nominal=0.1*nom.dp_nominal,
    dpFixed_nominal=0.1*nom.dp_nominal) "Check valve" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={20,0})));
  Modelica.Blocks.Interfaces.RealOutput yValDis_actual
                                                   "Actual valve position"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,150}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-80,110})));
  Modelica.Blocks.Interfaces.RealOutput yValCha_actual
                                                   "Actual valve position"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-40,150}),  iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-40,110})));
  Modelica.Blocks.Interfaces.RealInput yPum "Secondary pump speed input"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={0,150}),    iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,110})));
  Modelica.Blocks.Interfaces.RealInput yValCha
    "Valve position input" annotation (Placement(transformation(extent={{10,10},
            {-10,-10}},
        rotation=90,
        origin={40,150}),       iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,110})));
  Modelica.Blocks.Interfaces.RealInput yValDis
    "Valve position input" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={80,150}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,110})));
  Controls.OBC.CDL.Continuous.MultiMax mulMaxDis(nin=3)
    "Maximum valve position of discharging valves" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-80,110})));
  Controls.OBC.CDL.Continuous.MultiMax mulMaxCha(nin=3)
    "Maximum valve position of charging valves" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-40,110})));
equation
  connect(port_chiOut, valCha1.port_b)
    annotation (Line(points={{-100,60},{-10,60}}, color={0,127,255}));
  connect(valCha1.port_a, port_CHWS)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(port_CHWR, valDis1.port_a)
    annotation (Line(points={{100,-60},{10,-60}}, color={0,127,255}));
  connect(valDis1.port_b, port_chiInl)
    annotation (Line(points={{-10,-60},{-100,-60}}, color={0,127,255}));
  connect(port_chiInl, valCha2.port_a) annotation (Line(points={{-100,-60},{-40,
          -60},{-40,-30}}, color={0,127,255}));
  connect(valCha2.port_b, pum.port_a)
    annotation (Line(points={{-40,-10},{-40,0},{-30,0}}, color={0,127,255}));
  connect(valCha3.port_b, port_CHWR)
    annotation (Line(points={{40,-30},{40,-60},{100,-60}}, color={0,127,255}));
  connect(port_CHWS, valDis3.port_b)
    annotation (Line(points={{100,60},{40,60},{40,30}}, color={0,127,255}));
  connect(pum.port_a, valDis2.port_b)
    annotation (Line(points={{-30,0},{-40,0},{-40,10}}, color={0,127,255}));
  connect(valDis2.port_a, port_chiOut)
    annotation (Line(points={{-40,30},{-40,60},{-100,60}}, color={0,127,255}));
  connect(pum.port_b, cheVal.port_a) annotation (Line(points={{-10,0},{0,0},{0,1.72085e-15},
          {10,1.72085e-15}}, color={0,127,255}));
  connect(cheVal.port_b, valDis3.port_a) annotation (Line(points={{30,-7.21645e-16},
          {40,-7.21645e-16},{40,10}}, color={0,127,255}));
  connect(cheVal.port_b, valCha3.port_a) annotation (Line(points={{30,-7.21645e-16},
          {40,-7.21645e-16},{40,-10}}, color={0,127,255}));
  connect(pum.y, yPum) annotation (Line(points={{-20,12},{-20,134},{0,134},{0,150}},
        color={0,0,127}));
  connect(valCha1.y, yValCha) annotation (Line(points={{0,72},{0,80},{40,80},{40,
          150}}, color={0,0,127}));
  connect(valCha3.y, yValCha) annotation (Line(points={{52,-20},{60,-20},{60,80},
          {40,80},{40,150}}, color={0,0,127}));
  connect(valCha2.y, yValCha) annotation (Line(points={{-52,-20},{-56,-20},{-56,
          -36},{60,-36},{60,80},{40,80},{40,150}}, color={0,0,127}));
  connect(valDis2.y, yValDis) annotation (Line(points={{-52,20},{-60,20},{-60,-40},
          {80,-40},{80,150}}, color={0,0,127}));
  connect(valDis3.y, yValDis)
    annotation (Line(points={{52,20},{80,20},{80,150}}, color={0,0,127}));
  connect(valDis1.y, yValDis) annotation (Line(points={{0,-48},{0,-40},{80,-40},
          {80,150}}, color={0,0,127}));
  connect(valDis1.y_actual, mulMaxDis.u[1]) annotation (Line(points={{-5,-53},{
          -5,-52},{-79.3333,-52},{-79.3333,98}},
                                              color={0,0,127}));
  connect(valDis3.y_actual, mulMaxDis.u[2]) annotation (Line(points={{47,25},{48,
          25},{48,40},{-80,40},{-80,98}}, color={0,0,127}));
  connect(valDis2.y_actual, mulMaxDis.u[3]) annotation (Line(points={{-47,15},{
          -48,15},{-48,12},{-80,12},{-80,98},{-80.6667,98}},
                                                         color={0,0,127}));
  connect(mulMaxDis.y, yValDis_actual)
    annotation (Line(points={{-80,122},{-80,150}}, color={0,0,127}));
  connect(valCha2.y_actual, mulMaxCha.u[1]) annotation (Line(points={{-47,-15},
          {-68,-15},{-68,92},{-39.3333,92},{-39.3333,98}},color={0,0,127}));
  connect(valCha1.y_actual, mulMaxCha.u[2]) annotation (Line(points={{-5,67},{-5,
          92},{-40,92},{-40,98}}, color={0,0,127}));
  connect(valCha3.y_actual, mulMaxCha.u[3]) annotation (Line(points={{47,-25},{
          46,-25},{46,-28},{68,-28},{68,92},{-40.6667,92},{-40.6667,98}},
                                                                       color={0,
          0,127}));
  connect(mulMaxCha.y, yValCha_actual)
    annotation (Line(points={{-40,122},{-40,150}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={
        Line(points={{-100,-60},{100,-60}}, color={28,108,200}),
        Line(points={{-100,60},{100,60}}, color={28,108,200}),
        Line(points={{-60,60},{-60,-60}}, color={28,108,200}),
        Line(points={{60,60},{60,-60}}, color={28,108,200}),
        Line(points={{-60,0},{60,0}}, color={28,108,200}),
        Ellipse(
          extent={{-20,20},{20,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{20,0},{-10,16},{-10,-16},{20,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Polygon(
          points={{10,0},{-10,10},{-10,-10},{10,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={60,-40},
          rotation=90),
        Polygon(
          points={{-10,0},{10,10},{10,-10},{-10,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={60,-20},
          rotation=90),
        Polygon(
          points={{0,60},{-20,70},{-20,50},{0,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,60},{20,70},{20,50},{0,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-60},{-20,-50},{-20,-70},{0,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-60},{20,-50},{20,-70},{0,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{10,0},{-10,10},{-10,-10},{10,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-60,20},
          rotation=90),
        Polygon(
          points={{-10,0},{10,10},{10,-10},{-10,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-60,40},
          rotation=90),
        Polygon(
          points={{10,0},{-10,10},{-10,-10},{10,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-60,-40},
          rotation=90),
        Polygon(
          points={{-10,0},{10,10},{10,-10},{-10,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-60,-20},
          rotation=90),
        Polygon(
          points={{10,0},{-10,10},{-10,-10},{10,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={60,20},
          rotation=90),
        Polygon(
          points={{-10,0},{10,10},{10,-10},{-10,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={60,40},
          rotation=90)}),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,140}})),
    Documentation(info="<html>
<p>
Documentation pending.
</p>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end SupplyPumpOpenTank;
