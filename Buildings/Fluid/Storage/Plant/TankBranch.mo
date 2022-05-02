within Buildings.Fluid.Storage.Plant;
model TankBranch
  "Model of the tank branch of a storage plant"
  extends Buildings.Fluid.Storage.Plant.BaseClasses.PartialBranchPorts;

  parameter Boolean tankIsOpen = nom.plaTyp ==
    Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open "Tank is open";

  Buildings.Fluid.FixedResistances.PressureDrop preDroTanBot(
    redeclare final package Medium = Medium,
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
        origin={60,110})));
  Buildings.Fluid.Storage.Stratified tan(
    redeclare final package Medium = Medium,
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
  Modelica.Fluid.Sensors.MassFlowRate senFloBot(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true) "Flow rate sensor at tank bottom"
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
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final m_flow_nominal=nom.mTan_flow_nominal)
    "Flow resistance on tank branch near tank top" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,0})));
  Modelica.Fluid.Sensors.MassFlowRate senFloTop(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true) "Flow rate sensor at tank top"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-30})));
  Modelica.Blocks.Interfaces.RealOutput mTanTop_flow if tankIsOpen
    "Mass flow rate measured at the top of the tank" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={50,110}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={20,110})));
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
        Line(
          points={{20,100},{20,50},{0,50}},
          color={0,0,0},
          pattern=LinePattern.Dash,
          visible=tankIsOpen),
        Line(
          points={{60,100},{60,-52},{40,-52}},
          color={0,0,0},
          pattern=LinePattern.Dash),
        Line(points={{-42,-60}}, color={28,108,200}),
        Line(points={{-40,-60},{-40,50},{0,50},{0,-52},{40,-52},{40,60}}, color=
             {28,108,200}),
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
          visible=tankIsOpen)}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This model is part of a storage plant model. This branch has a stratified tank.
This tank can potentially be charged remotely by a chiller from its district
CHW network other than its own local chiller. To model an open storage tank, set
<code>nom.plaTyp = Buildings.Fluid.Storage.Plant.BaseClasses.Types.Setup.Open</code>,
and a volume at atmospheric pressure is added and connected to the top of the tank.
Otherwise, the tank is closed and pressurised.
</p>
<p>
Because an open tank exposes the hydraulic loop to the atmospheric pressure,
the mass flow rate of the water through the top port and bottom port of the tank
is not conserved. Flow rate sensors are therefore put on both the top and bottom
sides of the tank to allow the pumps and valves implemented in
<a href=\"Modelica://Buildings.Fluid.Storage.Plant.NetworkConnection\">
Buildings.Fluid.Storage.Plant.NetworkConnection</a>
to balance the flow, so that the open tank is not flooded or drained.
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
end TankBranch;
