within Buildings.Fluid.Storage.Plant;
model TankBranch
  "(Draft) Model of the tank branch where the tank can potentially be charged remotely"
  extends Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts;

  final parameter Boolean tankIsOpen = nom.plaTyp ==
    Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open "Tank is open";

  Buildings.Fluid.FixedResistances.PressureDrop preDroTanBot(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.mTan_flow_nominal)
    "Flow resistance on tank branch near tank bottom" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={30,0})));
  Modelica.Blocks.Interfaces.RealOutput mTanBot_flow
    "Mass flow rate measured at the bottom of the tank" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={80,110})));
  Buildings.Fluid.Storage.Stratified tan(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    hTan=3,
    dIns=0.3,
    VTan=10,
    nSeg=7,
    show_T=true,
    m_flow_nominal=nom.mTan_flow_nominal,
    T_start=nom.T_CHWS_nominal,
    TFlu_start=linspace(
        nom.T_CHWR_nominal,
        nom.T_CHWS_nominal,
        tan.nSeg)) "Tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Sensors.MassFlowRate senFloBot(redeclare package Medium =
        Medium, final allowFlowReversal=true) "Flow rate sensor at tank bottom"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={50,30})));
  Buildings.Fluid.Sources.Boundary_pT atm(
    redeclare final package Medium = Medium,
    final p(displayUnit="Pa") = 101325,
    final T=nom.T_CHWS_nominal,
    final nPorts=1) if tankIsOpen
                    "Atmosphere pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-10,30})));
  Buildings.Fluid.FixedResistances.PressureDrop preDroTanTop(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.mTan_flow_nominal)
    "Flow resistance on tank branch near tank top" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,0})));
  Modelica.Fluid.Sensors.MassFlowRate senFloTop(redeclare package Medium =
        Medium, final allowFlowReversal=true) "Flow rate sensor at tank top"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-30})));
  Modelica.Blocks.Interfaces.RealOutput mTanTop_flow
    "Mass flow rate measured at the top of the tank" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={40,110})));
equation
  connect(senFloBot.m_flow, mTanBot_flow)
    annotation (Line(points={{61,30},{70,30},{70,110}}, color={0,0,127}));
  connect(port_chiOut, port_CHWS)
    annotation (Line(points={{-100,60},{100,60}}, color={0,127,255}));
  connect(port_chiInl, port_CHWR)
    annotation (Line(points={{-100,-60},{100,-60}}, color={0,127,255}));
  connect(atm.ports[1], tan.port_a)
    annotation (Line(points={{-10,20},{-10,10},{-10,10},{-10,0}},
                                                color={0,127,255}));
  connect(preDroTanBot.port_b, senFloBot.port_a)
    annotation (Line(points={{40,0},{50,0},{50,20}}, color={0,127,255}));
  connect(tan.port_b, preDroTanBot.port_a)
    annotation (Line(points={{10,0},{20,0}}, color={0,127,255}));
  connect(preDroTanTop.port_b, tan.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
  connect(senFloBot.port_b, port_CHWS)
    annotation (Line(points={{50,40},{50,60},{100,60}}, color={0,127,255}));
  connect(preDroTanTop.port_a, senFloTop.port_b)
    annotation (Line(points={{-40,0},{-50,0},{-50,-20}}, color={0,127,255}));
  connect(senFloTop.port_a, port_chiInl) annotation (Line(points={{-50,-40},{
          -50,-60},{-100,-60}}, color={0,127,255}));
  connect(senFloTop.m_flow, mTanTop_flow) annotation (Line(points={{-61,-30},{
          -66,-30},{-66,70},{50,70},{50,110}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={
        Line(points={{-100,-60},{100,-60}}, color={28,108,200}),
        Line(points={{-100,60},{100,60}}, color={28,108,200}),
        Line(points={{0,60},{0,-60}}, color={28,108,200}),
        Rectangle(
          extent={{-20,40},{20,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-26,36},{26,26}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=tankIsOpen),
        Line(
          points={{40,100},{40,40},{24,40}},
          color={0,0,0},
          pattern=LinePattern.Dash),
        Line(
          points={{80,100},{80,-40},{26,-40}},
          color={0,0,0},
          pattern=LinePattern.Dash)}),                           Diagram(
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
