within Buildings.Fluid.Storage.Plant;
model TankBranch
  "(Draft) Model of the tank branch where the tank can potentially be charged remotely"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Buildings.Fluid.Storage.Plant.BaseClasses.NominalValues nom
    "Nominal values";

  Buildings.Fluid.FixedResistances.PressureDrop preDroTan(
    redeclare package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.mTan_flow_nominal) "Flow resistance on tank branch"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,30})));
  Modelica.Blocks.Interfaces.RealOutput mTan_flow
    "Mass flow rate through the tank" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,110}),   iconTransformation(
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
  Modelica.Fluid.Sensors.MassFlowRate sen_m_flow(
    redeclare package Medium = Medium,
    final allowFlowReversal=true) "Flow rate sensor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={-30,-30})));
  Modelica.Fluid.Interfaces.FluidPort_a port_CHWR(redeclare package Medium =
        Medium)
    "Port that connects CHW return line to the warmer side of the tank"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_CHWS(redeclare package Medium =
        Medium)
    "Port that connects the cooler side of the tank to the CHW supply line"
    annotation (Placement(transformation(extent={{90,50},{110,70}}),
        iconTransformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_chiInl(redeclare package Medium =
        Medium)
    "Port that connects the warmer side of the tank to the chiller inlet"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
        iconTransformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_chiOut(redeclare package Medium =
        Medium)
    "Port that connects the chiller outlet to the warmer side of the tank"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));
equation
  connect(sen_m_flow.m_flow, mTan_flow) annotation (Line(points={{-19,-30},{80,-30},
          {80,110}},                  color={0,0,127}));
  connect(preDroTan.port_a, tan.port_b) annotation (Line(points={{30,20},{30,0},
          {10,0}},                             color={0,127,255}));
  connect(sen_m_flow.port_b, tan.port_a)
    annotation (Line(points={{-30,-20},{-30,0},{-10,0}},
                                                 color={0,127,255}));
  connect(preDroTan.port_b, port_CHWS)
    annotation (Line(points={{30,40},{30,60},{100,60}}, color={0,127,255}));
  connect(port_CHWS, port_CHWS)
    annotation (Line(points={{100,60},{100,60}}, color={0,127,255}));
  connect(sen_m_flow.port_a, port_chiInl) annotation (Line(points={{-30,-40},{-30,
          -60},{-100,-60}}, color={0,127,255}));
  connect(preDroTan.port_b, port_chiOut)
    annotation (Line(points={{30,40},{30,60},{-100,60}}, color={0,127,255}));
  connect(port_CHWR, sen_m_flow.port_a) annotation (Line(points={{100,-60},{-30,
          -60},{-30,-40}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={
        Text(
          extent={{-62,-122},{62,-98}},
          textColor={0,0,127},
          textString="%name"),
        Line(points={{-100,-60},{100,-60}}, color={28,108,200}),
        Line(points={{-100,60},{100,60}}, color={28,108,200}),
        Line(points={{0,60},{0,-60}}, color={28,108,200}),
        Rectangle(
          extent={{-20,40},{20,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
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
