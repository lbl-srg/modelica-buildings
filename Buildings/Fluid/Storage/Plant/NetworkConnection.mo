within Buildings.Fluid.Storage.Plant;
model NetworkConnection
  "Storage plant section with supply pump and valves"

  extends Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts;

  parameter Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup plaTyp=
    nom.plaTyp
    "Type of plant setup";

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
    if plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp ==
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
    if plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Charging valve, modulated when tank is being charged remotely"
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pasValSupOut(
    redeclare final package Medium = Medium)
    if plaTyp ==
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
    if plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp ==
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
    if plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    or plaTyp ==
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
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
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
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
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
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Charging valve, open when tank is being charged remotely"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valRetOut(
    redeclare final package Medium = Medium,
    dpValve_nominal=0.1*nom.dp_nominal,
    use_inputFilter=true,
    y_start=0,
    l=1E-5,
    m_flow_nominal=nom.mTan_flow_nominal)
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Output valve, modulated when tank NOT being charged remotely"
    annotation (Placement(transformation(extent={{40,-100},{20,-80}})));
  Buildings.Fluid.Storage.Plant.BaseClasses.FluidPassThrough pasRet(
    redeclare final package Medium = Medium)
    if plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedLocal
    or plaTyp ==
      Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
    "Replaces the pump and valves on the return branch when the tank is closed"
    annotation (Placement(transformation(extent={{40,-40},{20,-20}})));
  Modelica.Blocks.Interfaces.RealOutput yRet_actual[2]
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Positions of 1: valRetOut, 2: valRetCha" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-90,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-100,110})));
  Modelica.Blocks.Interfaces.RealInput yRet[2]
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Control signals for the valves on the return line" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={70,110}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={98,110})));
  Modelica.Blocks.Interfaces.RealInput yPumRet
    if plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open
    "Speed input of the auxiliary pump on the return line" annotation (
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
            {100,100}}),       graphics={
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
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,60},{56,70},{56,50},{40,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Line(
          points={{80,60},{80,32},{-80,32},{-80,60}},
          color={28,108,200},
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,32},{24,42},{24,22},{40,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,32},{56,42},{56,22},{40,32}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.ClosedRemote
               or plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{-20,60},{-50,76},{-50,44},{-20,60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None),
        Ellipse(
          extent={{-60,-40},{-20,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=360,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-60},{24,-50},{24,-70},{40,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-60},{56,-50},{56,-70},{40,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Line(
          points={{80,-60},{80,-88},{-80,-88},{-80,-60}},
          color={28,108,200},
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-88},{24,-78},{24,-98},{40,-88}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{40,-88},{56,-78},{56,-98},{40,-88}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open),
        Polygon(
          points={{-20,-60},{-50,-44},{-50,-76},{-20,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.None,
          visible=plaTyp == Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open)}),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    defaultComponentName = "netCon",
    Documentation(info="<html>
<p>
This model is part of a storage plant model.
This branch has the following components:
</p>
<ul>
<li>
A CHW supply pump <code>pumSup</code> that is always enabled.
</li>
<li>
Valves on the supply side <code>valSupOut</code> and <code>valSupCha</code>
that are only enabled when the tank is configured to allow remote charging,
i.e. <code>plaTyp</code> has the value
<code>.ClosedRemote</code> or <code>.Open</code>.
</li>
<li>
An auxiliary CHW pump <code>pumRet</code> and valves <code>valRetOut</code> and
<code>valRetCha</code> that are only enabled when the tank is open,
i.e. <code>plaTyp</code> has the value <code>.Open</code>.
</li>
</ul>
<p>
Under configurations where remote charging is allowed, these components are
controlled by
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.BaseClasses.PumpValveControl\">
Buildings.Fluid.Storage.Plant.BaseClasses.PumpValveControl</a>.
</p>
<table summary= \"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\">
<thead>
  <tr>
    <th>Component</th>
    <th>Enabled</th>
    <th>Control Objective</th>
    <th>Condition 1</th>
    <th>AND Condition 2</th>
    <th>AND Condition 3</th>
  </tr>
</thead>
<tbody>
  <tr>
    <td>Supply pump<br/>pumSup</td>
    <td>Always</td>
    <td>Outputs CHW from the plant,<br/>tracks the flow rate at tank bottom</td>
    <td rowspan=\"6\">The plant is online.*</td>
    <td rowspan=\"2\">The tank is NOT being charged remotely.</td>
    <td rowspan=\"2\">Charging valve(s) are at most 1% open.</td>
  </tr>
  <tr>
    <td>Supply output valve<br/>valSupOut</td>
    <td rowspan=\"2\">Closed tank allowing<br/>
        remote charging<br/>
        or open tank</td>
    <td>Opens when the supply pump is on,<br/>
        otherwise closes to isolate the pump</td>
  </tr>
  <tr>
    <td>Supply charging valve<br/>
        valSupCha</td>
    <td>Charges the tank,<br/>
        tracks the flow rate at tank top,<br/>
        prevents the water from draining into the open tank</td>
    <td>The tank is being charged remotely.</td>
    <td>Output valve(s) are at most 1% open.</td>
  </tr>
  <tr>
    <td>Auxiliary pump<br/>
        pumRet</td>
    <td rowspan=\"3\">Open tank</td>
    <td>Pumps water to the pressurised return line<br/>
        from the open tank when it is being charged remotely</td>
    <td rowspan=\"2\">The tank is being charged remotely.</td>
    <td rowspan=\"2\">Output valve(s) are at most 1% open.</td>
  </tr>
  <tr>
    <td>Return charging valve<br/>
        valRetCha</td>
    <td>Opens when the auxiliary pump is on,<br/>
        otherwise closes to isolate the pump</td>
  </tr>
  <tr>
    <td>Return output valve<br/>
        valRetOut</td>
    <td>Discharges the tank,<br/>
        tracks the flow rate at tank top,<br/>
        prevents the water from draining into the open tank</td>
    <td>The tank is NOT being charged remotely.</td>
    <td>Charging valve(s) are at most 1% open.</td>
  </tr>
</tbody>
</table>
<p>
*The plant being online means that it is connected to the district CHW network.
When it is offline, although the valves cut the plant off of the network,
it can still charge its tank locally.
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
end NetworkConnection;
