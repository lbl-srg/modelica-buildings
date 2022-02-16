within Buildings.Fluid.Storage.Plant;
model ChillerAndTank
  "(Draft) Model of a plant with a chiller and a tank where the tank can potentially be charged remotely"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal = m2_flow_nominal,
    final m2_flow_nominal = mChi_flow_nominal + mTan_flow_nominal);

  parameter Boolean allowRemoteCharging = true
    "Turns the plant to a prosumer";

  parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal=1
    "Nominal mass flow rate for the chiller branch";
  parameter Modelica.Units.SI.MassFlowRate mTan_flow_nominal=1
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
    redeclare package Medium = Medium2,
    final dp_nominal=dp_nominal/10,
    final m_flow_nominal=mChi_flow_nominal) "Flow resistance on chiller branch"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,-10})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro2(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    final dp_nominal=dp_nominal/10,
    final m_flow_nominal=mTan_flow_nominal) "Flow resistance on tank branch"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={72,-70})));
  Modelica.Blocks.Interfaces.RealInput set_mPum1_flow
    "Primary pump mass flow rate setpoint" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,130}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,90})));

  Buildings.Fluid.Storage.Plant.TemperatureSource ideChi(
    redeclare package Medium = Medium2,
    m_flow_nominal=mChi_flow_nominal,
    p_nominal=p_CHWS_nominal,
    T_a_nominal=T_CHWR_nominal,
    T_b_nominal=T_CHWS_nominal) "Ideal chiller"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Fluid.Storage.Plant.TemperatureSource ideTan(
    redeclare package Medium = Medium2,
    final allowFlowReversal=true,
    m_flow_nominal=mTan_flow_nominal,
    p_nominal=p_CHWS_nominal,
    T_a_nominal=T_CHWR_nominal,
    T_b_nominal=T_CHWS_nominal) "Ideal tank"
    annotation (Placement(transformation(extent={{18,-80},{38,-60}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum1(
    redeclare package Medium = Medium2,
    per(pressure(dp=dp_nominal*{2,1.2,0}, V_flow=mChi_flow_nominal/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    m_flow_nominal=mChi_flow_nominal,
    m_flow_start=0,
    T_start=T_CHWR_nominal) "Primary CHW pump"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  Modelica.Blocks.Interfaces.RealOutput mTan_flow
    "Mass flow rate through the tank" annotation (Dialog(group=
          "Time varying output signal"), Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={10,-110}),  iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,-20})));
  Buildings.Fluid.Movers.SpeedControlled_y pum2(
    redeclare package Medium = Medium2,
    per(pressure(dp=dp_nominal*{2,1.2,0}, V_flow=(mChi_flow_nominal +
            mTan_flow_nominal)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=T_CHWR_nominal) "Secondary pump" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-78,-20})));

  Buildings.Fluid.Storage.Plant.BaseClasses.ReversiblePumpValveControl pum2Con
    if allowRemoteCharging
    "Control block for secondary pump-valve group"
    annotation (Placement(transformation(extent={{-58,80},{-38,102}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput booOnOff
    if allowRemoteCharging
    "Plant status: true = online; false = offline" annotation (Placement(
        transformation(extent={{-120,70},{-100,90}}), iconTransformation(extent=
           {{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput booFloDir
    if allowRemoteCharging
    "Flow direction: true = normal; false = reverse" annotation (Placement(
        transformation(extent={{-120,90},{-100,110}}), iconTransformation(
          extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput set_mTan_flow if allowRemoteCharging
    "Tank mass flow rate setpoint" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,130}),  iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,20})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium2,
    use_inputFilter=false,
    l=1E-10,
    dpValve_nominal=1,
    m_flow_nominal=mChi_flow_nominal+mTan_flow_nominal) if allowRemoteCharging
    "Valve in series to the pump (normal direction)"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage val2(
    redeclare package Medium = Medium2,
    use_inputFilter=false,
    l=1E-10,
    dpValve_nominal=1,
    m_flow_nominal=mTan_flow_nominal) if allowRemoteCharging
    "Valve in parallel to the secondary pump (reverse direction)"
    annotation (Placement(transformation(extent={{-40,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiFloDirPum1
    if allowRemoteCharging "Switches off pum1 when tank charged remotely"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={30,90})));
  Modelica.Blocks.Sources.Constant conZero(k=0) if allowRemoteCharging
                                                "Constant y = 0"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,90})));
  BaseClasses.FluidThrough pasVal1(redeclare package Medium = Medium2)
    if not allowRemoteCharging "Replaces val1 when remote charging not allowed"
    annotation (Placement(transformation(extent={{-60,-42},{-40,-22}})));
  BaseClasses.SignalThrough pasSwiFloDirPum1 if not allowRemoteCharging
    "Replaces swiFloDirPum1 when remote charging not allowed" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,90})));
  Modelica.Blocks.Interfaces.RealInput yPum2 if not allowRemoteCharging
                                             "Secondary pump speed input"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,110})));
equation
  connect(ideChi.port_b, preDro1.port_a) annotation (Line(points={{40,-10},{60,-10}},
                            color={0,127,255}));
  connect(ideTan.port_b, preDro2.port_a)
    annotation (Line(points={{38,-70},{62,-70}}, color={0,127,255}));
  connect(pum1.port_b, ideChi.port_a)
    annotation (Line(points={{0,-10},{20,-10}},    color={0,127,255}));
  connect(ideTan.m_flow,mTan_flow)  annotation (Line(points={{21,-59},{10,-59},{
          10,-110}},             color={0,0,127}));
  connect(booFloDir, pum2Con.booFloDir) annotation (Line(points={{-110,100},{-90,
          100},{-90,87.7},{-60,87.7}},       color={255,0,255}));
  connect(pum2Con.yVal2, val2.y) annotation (Line(points={{-41,78.9},{-41,8},{-32,
          8},{-32,-52},{-50,-52},{-50,-58}},
                                color={0,0,127}));
  connect(pum2Con.yVal1, val1.y) annotation (Line(points={{-45,78.9},{-46,78.9},
          {-46,8},{-50,8},{-50,2}},
                      color={0,0,127}));
  connect(pum2Con.um_mTan_flow, ideTan.m_flow) annotation (Line(points={{-59,98.7},
          {-62,98.7},{-62,106},{-26,106},{-26,22},{10,22},{10,-59},{21,-59}},
        color={0,0,127}));
  connect(pum2Con.us_mTan_flow, set_mTan_flow) annotation (Line(points={{-59,94.3},
          {-80,94.3},{-80,130}},         color={0,0,127}));
  connect(pum2.port_b, val1.port_a)
    annotation (Line(points={{-68,-20},{-64,-20},{-64,-10},{-60,-10}},
                                                   color={0,127,255}));
  connect(pum2.y, pum2Con.yPum2) annotation (Line(points={{-78,-8},{-78,20},{-49,
          20},{-49,78.9}},       color={0,0,127}));
  connect(swiFloDirPum1.u2, booFloDir) annotation (Line(points={{30,102},{30,110},
          {-90,110},{-90,100},{-110,100}},color={255,0,255}));
  connect(swiFloDirPum1.u1, set_mPum1_flow) annotation (Line(points={{38,102},{38,
          110},{40,110},{40,130}}, color={0,0,127}));
  connect(pum1.m_flow_in,swiFloDirPum1. y)
    annotation (Line(points={{-10,2},{-10,70},{30,70},{30,78}},
                                                 color={0,0,127}));
  connect(conZero.y,swiFloDirPum1. u3) annotation (Line(points={{-10,101},{-10,106},
          {22,106},{22,102}}, color={0,0,127}));
  connect(pum2Con.booOnOff, booOnOff) annotation (Line(points={{-60,83.3},{-60,84},
          {-80,84},{-80,80},{-110,80}},color={255,0,255}));
  connect(pum2.port_b, pasVal1.port_a) annotation (Line(points={{-68,-20},{-64,-20},
          {-64,-32},{-60,-32}},     color={0,127,255}));
  connect(pasSwiFloDirPum1.u, set_mPum1_flow) annotation (Line(points={{70,101},
          {70,110},{40,110},{40,130}},    color={0,0,127}));
  connect(pasSwiFloDirPum1.y, pum1.m_flow_in) annotation (Line(points={{70,79},{
          70,70},{-10,70},{-10,2}},    color={0,0,127}));
  connect(pum2.y, yPum2)
    annotation (Line(points={{-78,-8},{-78,20},{-110,20}},   color={0,0,127}));
  connect(preDro1.port_b, port_a2) annotation (Line(points={{80,-10},{86,-10},{86,
          -60},{100,-60}}, color={0,127,255}));
  connect(preDro2.port_b, port_a2) annotation (Line(points={{82,-70},{86,-70},{86,
          -60},{100,-60}}, color={0,127,255}));
  connect(pasVal1.port_b, pum1.port_a) annotation (Line(points={{-40,-32},{-26,-32},
          {-26,-10},{-20,-10}}, color={0,127,255}));
  connect(val1.port_b, pum1.port_a)
    annotation (Line(points={{-40,-10},{-20,-10}}, color={0,127,255}));
  connect(val2.port_a, pum1.port_a) annotation (Line(points={{-40,-70},{-26,-70},
          {-26,-10},{-20,-10}}, color={0,127,255}));
  connect(ideTan.port_a, pum1.port_a) annotation (Line(points={{18,-70},{-26,-70},
          {-26,-10},{-20,-10}}, color={0,127,255}));
  connect(pum2.port_a, port_b2) annotation (Line(points={{-88,-20},{-88,-60},{-100,
          -60}}, color={0,127,255}));
  connect(val2.port_b, port_b2) annotation (Line(points={{-60,-70},{-88,-70},{-88,
          -60},{-100,-60}}, color={0,127,255}));
  connect(port_b1, port_a1)
    annotation (Line(points={{100,60},{-100,60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={Line(
          points={{-30,-110},{30,-110}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          visible=allowRemoteCharging), Polygon(
          points={{-30,-110},{-10,-104},{-10,-116},{-30,-110}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=allowRemoteCharging),
        Line(points={{-60,0},{-60,-20},{0,-20},{0,-60},{60,-60},{60,0}},
                                                                       color={0,
              0,0}),
        Line(points={{-100,0},{-60,0},{-60,60},{60,60},{60,0},{100,0}},
                                                                  color={0,0,0}),
        Ellipse(
          extent={{-22,80},{22,38}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-20,-8},{20,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-30,-90},{30,-90}},color={28,108,200}),
        Polygon(
          points={{30,-90},{10,-84},{10,-96},{30,-90}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-16,74},{20,66}},color={0,0,0}),
        Line(points={{20,54},{-14,44}},color={0,0,0})}),         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,120}})));
end ChillerAndTank;
