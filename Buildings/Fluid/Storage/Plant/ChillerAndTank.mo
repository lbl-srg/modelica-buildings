within Buildings.Fluid.Storage.Plant;
model ChillerAndTank
  "(Draft) Model of a plant with a chiller and a tank where the tank can potentially be charged remotely"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component";

  parameter Boolean allowRemoteCharging = true
    "Turns the plant to a prosumer";

  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=1
    "Nominal mass flow rate for the chiller branch";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=1
    "Nominal mass flow rate for the tank branch";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=
    p_CHWS_nominal-p_CHWR_nominal
    "Nominal pressure difference";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWS_nominal=800000
    "Nominal pressure of the CHW supply line";
  parameter Modelica.Units.SI.AbsolutePressure p_CHWR_nominal=300000
    "Nominal pressure of the CHW return line";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal=12+273.15
    "Nominal temperature of CHW return";

  Buildings.Fluid.FixedResistances.PressureDrop preDro1(
    redeclare package Medium = Medium,
    final dp_nominal=dp_nominal/10,
    final m_flow_nominal=m1_flow_nominal) "Flow resistance on chiller branch"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Fluid.FixedResistances.Junction jun1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={m1_flow_nominal+m2_flow_nominal,
                   -m1_flow_nominal,-m2_flow_nominal},
    dp_nominal={0,0,0},
    T_start=T_CHWR_nominal) "Junction near the return line"
                                    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-80,0})));
  Buildings.Fluid.FixedResistances.Junction jun2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal={m1_flow_nominal,m2_flow_nominal,
                   -m1_flow_nominal-m2_flow_nominal},
    dp_nominal={0,0,0},
    T_start=T_CHWS_nominal)
    "Junction near the supply line" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={100,0})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro2(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal/10,
    final m_flow_nominal=m2_flow_nominal) "Flow resistance on tank branch"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    p(start=p_CHWR_nominal),
    redeclare package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-190,-10},{-170,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    p(start=p_CHWS_nominal),
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{150,-10},{130,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));
  Modelica.Blocks.Interfaces.RealInput set_mPum1_flow
    "Primary pump mass flow rate setpoint" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,130}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,90})));

  Buildings.Fluid.Storage.Plant.TemperatureSource ideChi(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    p_nominal=p_CHWS_nominal,
    T_a_nominal=T_CHWR_nominal,
    T_b_nominal=T_CHWS_nominal) "Ideal chiller"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Fluid.Storage.Plant.TemperatureSource ideTan(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    m_flow_nominal=m2_flow_nominal,
    p_nominal=p_CHWS_nominal,
    T_a_nominal=T_CHWR_nominal,
    T_b_nominal=T_CHWS_nominal) "Ideal tank"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum1(
    redeclare package Medium = Medium,
    per(pressure(dp=dp_nominal*{2,1.2,0}, V_flow=m1_flow_nominal/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    m_flow_nominal=m1_flow_nominal,
    m_flow_start=0,
    T_start=T_CHWR_nominal) "Primary CHW pump"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));

  Modelica.Blocks.Interfaces.RealOutput mTan_flow
    "Mass flow rate through the tank" annotation (Dialog(group=
          "Time varying output signal"), Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,-110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={90,-110})));
  Buildings.Fluid.Movers.SpeedControlled_y pum2(
    redeclare package Medium = Medium,
    per(pressure(dp=dp_nominal*{2,1.2,0}, V_flow=(m1_flow_nominal +
            m2_flow_nominal)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=T_CHWR_nominal) "Secondary pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,20})));

  Buildings.Fluid.Storage.Plant.BaseClasses.ReversiblePumpValveControl pum2Con
    if allowRemoteCharging
    "Control block for secondary pump-valve group"
    annotation (Placement(transformation(extent={{-140,78},{-120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput booOnOff
    if allowRemoteCharging
    "Plant status: true = online; false = offline" annotation (Placement(
        transformation(extent={{-200,70},{-180,90}}), iconTransformation(extent=
           {{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput booFloDir
    if allowRemoteCharging
    "Flow direction: true = normal; false = reverse" annotation (Placement(
        transformation(extent={{-200,90},{-180,110}}), iconTransformation(
          extent={{-140,-70},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput set_mTan_flow if allowRemoteCharging
    "Tank mass flow rate setpoint" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-160,130}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,50})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    l=1E-10,
    dpValve_nominal=1,
    m_flow_nominal=m1_flow_nominal+m2_flow_nominal) if allowRemoteCharging
    "Valve in series to the pump (normal direction)"
    annotation (Placement(transformation(extent={{-120,22},{-100,42}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = Medium,
    use_inputFilter=false,
    l=1E-10,
    dpValve_nominal=1,
    m_flow_nominal=m2_flow_nominal) if allowRemoteCharging
    "Valve in parallel to the secondary pump (reverse direction)"
    annotation (Placement(transformation(extent={{-120,-30},{-140,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFloDirPum1
    if allowRemoteCharging "Switches off pum1 when tank charged remotely"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-50,90})));
  Modelica.Blocks.Sources.Constant conZero(k=0) if allowRemoteCharging
                                                "Constant y = 0"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-90,90})));
  BaseClasses.FluidThrough pasVal1(redeclare package Medium = Medium)
    if not allowRemoteCharging "Replaces val1 when remote charging not allowed"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  BaseClasses.SignalThrough pasSwiFloDirPum1 if not allowRemoteCharging
    "Replaces swiFloDirPum1 when remote charging not allowed" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,90})));
  Modelica.Blocks.Interfaces.RealInput yPum2 if not allowRemoteCharging
                                             "Secondary pump speed input"
    annotation (Placement(transformation(extent={{-200,50},{-180,70}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-70,110})));
equation
  connect(preDro2.port_b, jun2.port_3)
    annotation (Line(points={{60,-60},{100,-60},{100,-10}},
                                                 color={0,127,255}));
  connect(preDro1.port_b, jun2.port_1)
    annotation (Line(points={{60,40},{84,40},{84,0},{90,0}},
                                                        color={0,127,255}));
  connect(jun2.port_2, port_b)
    annotation (Line(points={{110,0},{140,0}}, color={0,127,255}));
  connect(ideChi.port_b, preDro1.port_a) annotation (Line(points={{10,40},{10,40},
          {10,40},{40,40}}, color={0,127,255}));
  connect(ideTan.port_b, preDro2.port_a)
    annotation (Line(points={{10,-60},{40,-60}}, color={0,127,255}));
  connect(jun1.port_3, ideTan.port_a) annotation (Line(points={{-80,-10},{-80,
          -60},{-10,-60}},   color={0,127,255}));
  connect(pum1.port_b, ideChi.port_a)
    annotation (Line(points={{-40,40},{-10,40}},   color={0,127,255}));
  connect(jun1.port_2, pum1.port_a) annotation (Line(points={{-70,0},{-64,0},{-64,
          40},{-60,40}}, color={0,127,255}));
  connect(ideTan.m_flow,mTan_flow)  annotation (Line(points={{-7,-49},{-7,-46},
          {-40,-46},{-40,-110}}, color={0,0,127}));
  connect(booFloDir, pum2Con.booFloDir) annotation (Line(points={{-190,100},{-174,
          100},{-174,85.7},{-142,85.7}},     color={255,0,255}));
  connect(jun1.port_1, val2.port_a) annotation (Line(points={{-90,0},{-94,0},{-94,
          -20},{-120,-20}}, color={0,127,255}));
  connect(val2.port_b, port_a) annotation (Line(points={{-140,-20},{-164,-20},{-164,
          0},{-180,0}}, color={0,127,255}));
  connect(val1.port_b, jun1.port_1) annotation (Line(points={{-100,32},{-94,32},
          {-94,0},{-90,0}}, color={0,127,255}));
  connect(pum2Con.yVal2, val2.y) annotation (Line(points={{-127,76.9},{-127,40},
          {-130,40},{-130,-8}}, color={0,0,127}));
  connect(pum2Con.yVal1, val1.y) annotation (Line(points={{-123,76.9},{-110,76.9},
          {-110,44}}, color={0,0,127}));
  connect(pum2Con.um_mTan_flow, ideTan.m_flow) annotation (Line(points={{-141,
          96.7},{-170,96.7},{-170,-46},{-8,-46},{-8,-49},{-7,-49}},
        color={0,0,127}));
  connect(pum2Con.us_mTan_flow, set_mTan_flow) annotation (Line(points={{-141,92.3},
          {-160,92.3},{-160,130}},       color={0,0,127}));
  connect(pum2.port_a, port_a) annotation (Line(points={{-160,20},{-164,20},{
          -164,0},{-180,0}}, color={0,127,255}));
  connect(pum2.port_b, val1.port_a)
    annotation (Line(points={{-140,20},{-124,20},{-124,32},{-120,32}},
                                                   color={0,127,255}));
  connect(pum2.y, pum2Con.yPum2) annotation (Line(points={{-150,32},{-150,70},{-131,
          70},{-131,76.9}},      color={0,0,127}));
  connect(swiFloDirPum1.u2, booFloDir) annotation (Line(points={{-50,102},{-50,108},
          {-174,108},{-174,100},{-190,100}},
                                          color={255,0,255}));
  connect(swiFloDirPum1.u1, set_mPum1_flow) annotation (Line(points={{-42,102},{
          -42,116},{-40,116},{-40,130}},
                                   color={0,0,127}));
  connect(pum1.m_flow_in,swiFloDirPum1. y)
    annotation (Line(points={{-50,52},{-50,78}}, color={0,0,127}));
  connect(conZero.y,swiFloDirPum1. u3) annotation (Line(points={{-90,101},{-90,106},
          {-58,106},{-58,102}},
                              color={0,0,127}));
  connect(pum2Con.booOnOff, booOnOff) annotation (Line(points={{-142,81.3},{-142,
          80},{-190,80}},              color={255,0,255}));
  connect(pum2.port_b, pasVal1.port_a) annotation (Line(points={{-140,20},{-124,
          20},{-124,10},{-120,10}}, color={0,127,255}));
  connect(pasSwiFloDirPum1.u, set_mPum1_flow) annotation (Line(points={{-10,101},
          {-10,116},{-40,116},{-40,130}}, color={0,0,127}));
  connect(pasSwiFloDirPum1.y, pum1.m_flow_in) annotation (Line(points={{-10,79},
          {-10,60},{-50,60},{-50,52}}, color={0,0,127}));
  connect(pum2.y, yPum2)
    annotation (Line(points={{-150,32},{-150,60},{-190,60}}, color={0,0,127}));
  connect(pasVal1.port_b, jun1.port_1) annotation (Line(points={{-100,10},{-94,
          10},{-94,0},{-90,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={Line(
          points={{-80,-20},{-20,-20}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          visible=allowRemoteCharging), Polygon(
          points={{-80,-20},{-60,-14},{-60,-26},{-80,-20}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=allowRemoteCharging),
        Line(points={{0,0},{0,-20},{30,-20},{30,-60},{60,-60},{60,0}}, color={0,
              0,0}),
        Line(points={{-90,0},{0,0},{0,60},{60,60},{60,0},{90,0}}, color={0,0,0}),
        Ellipse(
          extent={{10,82},{54,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-10},{50,-72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,20},{-20,20}}, color={28,108,200}),
        Polygon(
          points={{-20,20},{-40,26},{-40,14},{-20,20}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{16,76},{52,68}}, color={0,0,0}),
        Line(points={{52,56},{18,46}}, color={0,0,0})}),         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{140,120}})));
end ChillerAndTank;
