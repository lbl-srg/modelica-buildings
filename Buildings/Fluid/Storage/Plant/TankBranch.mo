within Buildings.Fluid.Storage.Plant;
model TankBranch
  "(Draft) Model of the tank branch where the tank can potentially be charged remotely"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Boolean allowRemoteCharging = true
    "= true if the tank is allowed to be charged by a remote source";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate mTan_flow_nominal(min=0)
    "Nominal mass flow rate for CHW tank branch";
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure difference";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal=7+273.15
    "Nominal temperature of CHW supply";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal=12+273.15
    "Nominal temperature of CHW return";

  Buildings.Fluid.FixedResistances.PressureDrop preDroTan(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=mTan_flow_nominal) "Flow resistance on tank branch"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={50,30})));
  Modelica.Blocks.Interfaces.RealOutput mTan_flow
    "Mass flow rate through the tank" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-30,110}),  iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,20})));
  Buildings.Fluid.Movers.SpeedControlled_y pum(
    redeclare package Medium = Medium,
    per(pressure(dp=dp_nominal*{2,1.2,0}, V_flow=(m_flow_nominal)/1.2*{0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=T_CHWR_nominal) "Secondary CHW pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-70,-40})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valDis(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=m_flow_nominal)
    if allowRemoteCharging
    "Discharge valve, in series to the pump (normal direction)"
    annotation (Placement(transformation(extent={{0,-42},{20,-22}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valCha(
    redeclare package Medium = Medium,
    dpValve_nominal=0.1*dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=mTan_flow_nominal) if allowRemoteCharging
    "Charging valve, in parallel to the secondary pump (reverse direction)"
    annotation (Placement(transformation(extent={{20,-90},{0,-70}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pasValDis(
      redeclare package Medium = Medium) if not allowRemoteCharging
    "Replaces valDis when remote charging not allowed"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Fluid.Storage.Stratified tan(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    hTan=3,
    dIns=0.3,
    VTan=10,
    nSeg=7,
    show_T=true,
    m_flow_nominal=mTan_flow_nominal,
    T_start=T_CHWS_nominal,
    TFlu_start=linspace(
        T_CHWR_nominal,
        T_CHWS_nominal,
        tan.nSeg)) "Tank"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Modelica.Fluid.Sensors.MassFlowRate sen_m_flow(
    redeclare package Medium = Medium,
    final allowFlowReversal=true) "Flow rate sensor"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.FixedResistances.CheckValve cheVal(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=0.1*dp_nominal,
    dpFixed_nominal=0.1*dp_nominal) "Check valve" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-30,-40})));
  Modelica.Fluid.Interfaces.FluidPort_a port_1(
    redeclare package Medium = Medium)
    "Port that connects CHW return line to the warmer side of the tank"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
        iconTransformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_2(
    redeclare package Medium = Medium)
    "Port that connects the cooler side of the tank to the CHW supply line"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_3(
    redeclare package Medium = Medium)
    "Port that connects the warmer side of the tank to the chiller inlet"
    annotation (Placement(transformation(extent={{-70,90},{-50,110}}),
        iconTransformation(extent={{-50,90},{-30,110}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_4(
    redeclare package Medium = Medium)
    "Port that connects the chiller outlet to the warmer side of the tank"
    annotation (Placement(transformation(extent={{50,90},{70,110}}),
        iconTransformation(extent={{30,92},{50,112}})));
  Modelica.Blocks.Interfaces.RealOutput yValCha_actual if allowRemoteCharging
                                                       "Actual valve position"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,-110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,60})));
  Modelica.Blocks.Interfaces.RealOutput yValDis_actual if allowRemoteCharging
                                                       "Actual valve position"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={40,-110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,100})));
  Modelica.Blocks.Interfaces.RealInput yValCha if allowRemoteCharging
    "Valve position input" annotation (Placement(transformation(extent={{10,10},
            {-10,-10}},
        rotation=-90,
        origin={-40,-110}),     iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,60})));
  Modelica.Blocks.Interfaces.RealInput yValDis if allowRemoteCharging
    "Valve position input" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=-90,
        origin={60,-110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,100})));
  Modelica.Blocks.Interfaces.RealInput yPum "Secondary pump speed input"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-110,-20}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,20})));
equation
  connect(sen_m_flow.m_flow, mTan_flow) annotation (Line(points={{-30,41},{-30,110}},
                                      color={0,0,127}));
  connect(preDroTan.port_a, tan.port_b) annotation (Line(points={{40,30},{20,30}},
                                               color={0,127,255}));
  connect(sen_m_flow.port_b, tan.port_a)
    annotation (Line(points={{-20,30},{0,30}},   color={0,127,255}));
  connect(pum.port_b, cheVal.port_a)
    annotation (Line(points={{-60,-40},{-40,-40}}, color={0,127,255}));
  connect(pasValDis.port_a, cheVal.port_b) annotation (Line(points={{0,-50},{-10,
          -50},{-10,-40},{-20,-40}}, color={0,127,255}));
  connect(valDis.port_a, cheVal.port_b) annotation (Line(points={{0,-32},{-10,-32},
          {-10,-40},{-20,-40}}, color={0,127,255}));
  connect(preDroTan.port_b, port_2) annotation (Line(points={{60,30},{70,30},{70,
          -60},{100,-60}}, color={0,127,255}));
  connect(pum.port_a, port_1) annotation (Line(points={{-80,-40},{-90,-40},{-90,
          -60},{-100,-60}}, color={0,127,255}));
  connect(valCha.port_b, port_1) annotation (Line(points={{0,-80},{-90,-80},{-90,
          -60},{-100,-60}}, color={0,127,255}));
  connect(port_2, port_2)
    annotation (Line(points={{100,-60},{100,-60}}, color={0,127,255}));
  connect(sen_m_flow.port_a, valCha.port_a) annotation (Line(points={{-40,30},{-60,
          30},{-60,0},{30,0},{30,-80},{20,-80}}, color={0,127,255}));
  connect(pasValDis.port_b, sen_m_flow.port_a) annotation (Line(points={{20,-50},
          {30,-50},{30,0},{-60,0},{-60,30},{-40,30}}, color={0,127,255}));
  connect(valDis.port_b, sen_m_flow.port_a) annotation (Line(points={{20,-32},{30,
          -32},{30,0},{-60,0},{-60,30},{-40,30}}, color={0,127,255}));
  connect(sen_m_flow.port_a, port_3) annotation (Line(points={{-40,30},{-60,30},
          {-60,100}},          color={0,127,255}));
  connect(preDroTan.port_b, port_4) annotation (Line(points={{60,30},{70,30},{70,
          86},{60,86},{60,100}},
                         color={0,127,255}));
  connect(valCha.y_actual, yValCha_actual)
    annotation (Line(points={{5,-73},{-20,-73},{-20,-110}}, color={0,0,127}));
  connect(valDis.y_actual, yValDis_actual)
    annotation (Line(points={{15,-25},{40,-25},{40,-110}}, color={0,0,127}));
  connect(valCha.y, yValCha)
    annotation (Line(points={{10,-68},{-40,-68},{-40,-110}}, color={0,0,127}));
  connect(yValDis, valDis.y)
    annotation (Line(points={{60,-110},{60,-20},{10,-20}}, color={0,0,127}));
  connect(pum.y, yPum) annotation (Line(points={{-70,-28},{-70,-20},{-110,-20}},
        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={Line(
          points={{-30,-92},{30,-92}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          visible=allowRemoteCharging), Polygon(
          points={{-30,-92},{-10,-86},{-10,-98},{-30,-92}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=allowRemoteCharging),
        Line(points={{-30,-72},{30,-72}},color={28,108,200}),
        Polygon(
          points={{30,-72},{10,-66},{10,-78},{30,-72}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-100,-60},{-40,-60},{-40,-30},{0,-30},{0,30},{40,30},{40,-60},
              {100,-60}}, color={0,0,0}),
        Rectangle(
          extent={{-20,40},{20,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-40,100},{-40,-30}}, color={0,0,0}),
        Line(points={{40,100},{40,30}}, color={0,0,0}),
        Text(
          extent={{-62,-124},{62,-100}},
          textColor={0,0,127},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This plant model has a chiller and a stratified tank.
By setting <code>allowRemoteCharging = false</code>,
this model is effectively replacing a common pipe with a tank.
By setting <code>allowRemoteCharging = true</code>,
the tank can be charged by the CHW network instead of its own chiller.
</p>
<p>
When remote charging is enabled, the plant's operation mode is determined by
two boolean inputs:
</p>
<ul>
<li>
<code>booFloDir</code> determines the direction flow direction of the plant.
It has reverse flow when and only when the tank is being charged remotely.
</li>
<li>
<code>booOnOff</code> determines whether the plant outputs CHW to the network.
When it is off, the plant still allows the tank to be charged remotely
(if the flow direction is set to reverse at the same time).
</li>
</ul>
<p>
When remote charging is allowed, the secondary pump and two conditionally-enabled
control valves are controlled by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.ReversiblePumpValveControl\">
Buildings.Fluid.Storage.Plant.BaseClasses.ReversiblePumpValveControl</a> as such:
</p>
<ul>
<li>
The pump is controlled to track a flow rate setpoint of the tank
(can be both positive [discharging] or negative [charging])
under the following conditions:
<ul>
<li>
The plant is on, AND
</li>
<li>
the flow direction is \"normal\" (<code>= true</code>), AND
</li>
<li>
<code>val2</code> (in parallel to the pump) is at most 5% open.
</li>
</ul>
Otherwise the pump is off.
</li>
<li>
The valve in series with the pump (<code>val1</code>) is controlled to open fully
under the same conditions that allow the pump to be on.
Otherwise the valve is closed.
</li>
<li>
The valve in parallel with the pump (<code>val2</code>) is controlled
to track a negative flow rate setpoint of the tank (charging)
under the following conditions:
<ul>
<li>
The flow direction is \"reverse\" (<code>= false</code>), AND
</li>
<li>
<code>val1</code> (in series to the pump) is at most 5% open.
</li>
</ul>
Otherwise the valve is closed.
Not that it is NOT closed when the plant is \"off\".
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
February 18, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end TankBranch;
