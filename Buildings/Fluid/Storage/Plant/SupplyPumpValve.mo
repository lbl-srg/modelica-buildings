within Buildings.Fluid.Storage.Plant;
model SupplyPumpValve
  "(Draft) Plant section with supply pump and valves"

  extends Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts;

  Buildings.Fluid.Movers.SpeedControlled_y pumSup(
    redeclare final package Medium = Medium,
    per(pressure(dp=nom.dp_nominal*{2,1.2,0}, V_flow=(nom.m_flow_nominal)/1.2*{
            0,1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=nom.T_CHWR_nominal) "CHW supply pump" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,60})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valSupOut(
    redeclare final package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.m_flow_nominal)
    if nom.plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or nom.plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Output valve, open when tank NOT being charged remotely"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valSupCha(
    redeclare final package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.mTan_flow_nominal)
    if nom.plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or nom.plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Charging valve, modulated when tank is being charged remotely"
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pasValSupOut(
    redeclare final package Medium = Medium)
    if nom.plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedLocal
    "Replaces valSupOut when remote charging not allowed"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Fluid.FixedResistances.CheckValve cheValSup(
    redeclare final package Medium = Medium,
    m_flow_nominal=nom.m_flow_nominal,
    dpValve_nominal=0.1*nom.dp_nominal,
    dpFixed_nominal=0.1*nom.dp_nominal) "Check valve" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,60})));
  Modelica.Blocks.Interfaces.RealOutput ySup_actual[2]
    if nom.plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or nom.plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Positions of 1: valSupOut, 2: valSupCha" annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-70,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-60,110})));
  Modelica.Blocks.Interfaces.RealInput yValSup[2]
    if nom.plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or nom.plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Positions of the valves on the supply line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={30,108}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={20,110})));
  Modelica.Blocks.Interfaces.RealInput yPumSup "Speed input of the supply pump"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={10,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,110})));

  Buildings.Fluid.Movers.SpeedControlled_y pumRet(
    redeclare final package Medium = Medium,
    per(pressure(dp=nom.dp_nominal*{2,1.2,0}, V_flow=(nom.m_flow_nominal)/1.2*{0,
            1.2,2})),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    allowFlowReversal=true,
    addPowerToMedium=false,
    y_start=0,
    T_start=nom.T_CHWR_nominal)
    if nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Auxilliary CHW pump on the return line" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-60})));
  Buildings.Fluid.FixedResistances.CheckValve cheValRet(
    redeclare final package Medium = Medium,
    m_flow_nominal=nom.m_flow_nominal,
    dpValve_nominal=0.1*nom.dp_nominal,
    dpFixed_nominal=0.1*nom.dp_nominal)
    if nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Check valve" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-10,-60})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear valRetCha(
    redeclare final package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.m_flow_nominal)
    if nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Charging valve, open when tank is being charged remotely"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valRetOut(
    redeclare final package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.mTan_flow_nominal)
    if nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Output valve, modulated when tank NOT being charged remotely"
    annotation (Placement(transformation(extent={{40,-100},{20,-80}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pasRet(
    redeclare final package Medium = Medium)
    if nom.plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedLocal
    or nom.plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    "Replaces the pump and valves on the return branch when the tank is closed"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Modelica.Blocks.Interfaces.RealOutput yRet_actual[2]
    if nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Positions of 1: valRetOut, 2: valRetCha" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-90,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-100,110})));
  Modelica.Blocks.Interfaces.RealInput yRet[2]
    if nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Control signals for the valves on the return line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={70,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={98,110})));
  Modelica.Blocks.Interfaces.RealInput yPumRet
    if nom.plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Speed input of the auxilliary pump on the return line" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={50,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={60,110})));
equation
  connect(pumSup.port_b, cheValSup.port_a)
    annotation (Line(points={{-40,60},{-20,60}}, color={0,127,255}));
  connect(pasValSupOut.port_a, cheValSup.port_b) annotation (Line(points={{20,30},
          {10,30},{10,60},{-1.77636e-15,60}},     color={0,127,255}));
  connect(pumSup.y, yPumSup) annotation (Line(points={{-50,72},{-50,96},{10,96},
          {10,110}}, color={0,0,127}));
  connect(port_chiOut, pumSup.port_a)
    annotation (Line(points={{-100,60},{-60,60}}, color={0,127,255}));
  connect(port_chiOut, valSupCha.port_b) annotation (Line(points={{-100,60},{-80,
          60},{-80,0},{20,0}},     color={0,127,255}));
  connect(valSupCha.port_a, port_CHWS) annotation (Line(points={{40,0},{60,0},{60,
          60},{100,60}},     color={0,127,255}));
  connect(pasValSupOut.port_b, port_CHWS) annotation (Line(points={{40,30},{60,30},
          {60,60},{100,60}},     color={0,127,255}));
  connect(cheValSup.port_b, valSupOut.port_a)
    annotation (Line(points={{-1.77636e-15,60},{20,60}}, color={0,127,255}));
  connect(valSupOut.port_b, port_CHWS)
    annotation (Line(points={{40,60},{100,60}}, color={0,127,255}));
  connect(ySup_actual, ySup_actual)
    annotation (Line(points={{-70,110},{-70,110}}, color={0,0,127}));
  connect(valSupOut.y_actual, ySup_actual[1]) annotation (Line(points={{35,67},{
          44,67},{44,22},{-70,22},{-70,107.5}},  color={0,0,127}));
  connect(valSupCha.y_actual, ySup_actual[2]) annotation (Line(points={{25,7},{14,
          7},{14,22},{-70,22},{-70,112.5}},         color={0,0,127}));
  connect(valSupOut.y, yValSup[1]) annotation (Line(points={{30,72},{30,105.5}},
                                           color={0,0,127}));
  connect(valSupCha.y, yValSup[2]) annotation (Line(points={{30,12},{50,12},{50,
          80},{30,80},{30,110.5}},        color={0,0,127}));
  connect(port_chiInl, pumRet.port_a)
    annotation (Line(points={{-100,-60},{-60,-60}}, color={0,127,255}));
  connect(pumRet.port_b, cheValRet.port_a)
    annotation (Line(points={{-40,-60},{-20,-60}}, color={0,127,255}));
  connect(cheValRet.port_b, valRetCha.port_a)
    annotation (Line(points={{-1.77636e-15,-60},{20,-60}}, color={0,127,255}));
  connect(valRetCha.port_b, port_CHWR)
    annotation (Line(points={{40,-60},{100,-60}}, color={0,127,255}));
  connect(valRetOut.port_a, port_CHWR) annotation (Line(points={{40,-90},{80,-90},
          {80,-60},{100,-60}}, color={0,127,255}));
  connect(valRetOut.port_b, port_chiInl) annotation (Line(points={{20,-90},{-70,
          -90},{-70,-60},{-100,-60}}, color={0,127,255}));
  connect(port_CHWR, pasRet.port_a) annotation (Line(points={{100,-60},{90,-60},
          {90,-30},{40,-30}}, color={0,127,255}));
  connect(pasRet.port_b, port_chiInl) annotation (Line(points={{20,-30},{-80,-30},
          {-80,-60},{-100,-60}}, color={0,127,255}));
  connect(valRetCha.y_actual, yRet_actual[2]) annotation (Line(points={{35,-53},
          {52,-53},{52,-96},{-90,-96},{-90,112.5}}, color={0,0,127}));
  connect(valRetOut.y_actual, yRet_actual[1]) annotation (Line(points={{25,-83},
          {14,-83},{14,-96},{-90,-96},{-90,107.5}}, color={0,0,127}));
  connect(valRetOut.y, yRet[1])
    annotation (Line(points={{30,-78},{70,-78},{70,107.5}}, color={0,0,127}));
  connect(valRetCha.y, yRet[2])
    annotation (Line(points={{30,-48},{70,-48},{70,112.5}}, color={0,0,127}));
  connect(pumRet.y, yPumRet) annotation (Line(points={{-50,-48},{-50,-26},{66,-26},
          {66,96},{50,96},{50,110}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={Line(
          points={{-20,0},{40,0}},
          color={28,108,200},
          pattern=LinePattern.Dash,
          visible=allowRemoteCharging), Polygon(
          points={{-20,0},{0,6},{0,-6},{-20,0}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          visible=allowRemoteCharging),
        Line(points={{-20,80},{40,80}},  color={28,108,200}),
        Polygon(
          points={{40,80},{20,86},{20,74},{40,80}},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Line(points={{-100,60},{100,60}}, color={28,108,200}),
        Line(points={{-100,-60},{100,-60}}, color={28,108,200}),
        Ellipse(
          extent={{-60,80},{-20,40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,60},{24,70},{24,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,60},{56,70},{56,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{80,60},{80,20},{-80,20},{-80,60}},
          color={28,108,200},
          visible=allowRemoteCharging),
        Polygon(
          points={{40,20},{24,30},{24,10},{40,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowRemoteCharging),
        Polygon(
          points={{40,20},{56,30},{56,10},{40,20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=allowRemoteCharging),
        Polygon(
          points={{-20,60},{-50,76},{-50,44},{-20,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None)}),                       Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
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
end SupplyPumpValve;
