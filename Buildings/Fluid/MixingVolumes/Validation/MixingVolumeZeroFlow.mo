within Buildings.Fluid.MixingVolumes.Validation;
model MixingVolumeZeroFlow
  "Mixing volume verification around zero flow with heat exchange"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water;
  Buildings.Fluid.MixingVolumes.MixingVolume volNonLinSys(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false)
    "Steady state mixing volume requiring solution of non-linear system"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true) "Source"
    annotation (Placement(transformation(extent={{-60,-32},{-40,-12}})));
  Buildings.Fluid.Sources.Boundary_pT sin(nPorts=4, redeclare package Medium =
        Medium) "Sink"
    annotation (Placement(transformation(extent={{40,-44},{20,-24}})));
  Modelica.Blocks.Sources.Ramp ramp_m_flow(
    height=-1,
    duration=1,
    offset=1) "Mass flow rate ramp input"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea2
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Modelica.Blocks.Sources.RealExpression reaExp(y=(290 - volNonLinSys.heatPort.T)
        /100*volNonLinSys.heatPort.T^(3/5)*time)
    "Non-linear thermal resistance equation"
    annotation (Placement(transformation(extent={{-100,46},{-48,74}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    "Prescribed temperature"
    annotation (Placement(transformation(extent={{-56,34},{-44,46}})));
  Modelica.Blocks.Sources.Cosine cos1(
    freqHz=1,
    offset=283.15,
    amplitude=0.001) "Cosine input"
    annotation (Placement(transformation(extent={{-76,34},{-64,46}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volT(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false)
    "Steady state mixing volume with prescribed temperature input"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou3(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true) "Source"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volLinSys(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    prescribedHeatFlowRate=false)
    "Steady state mixing volume requiring solution of linear system"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou4(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true) "Source"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalResistor theRes(R=0.001)
    "Thermal resistor for creating linear system" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-22,-64})));
  Modelica.Blocks.Sources.Ramp ramp_T(
    duration=2,
    offset=283.15,
    height=0) "Temperature ramp input"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea1
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volQflow(
    nPorts=2,
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    V=1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    prescribedHeatFlowRate=true)
    "Steady state mixing volume with fixed heat flow rate input"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true) "Source"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Modelica.Blocks.Routing.RealPassThrough reaPasThr
    "Real pass through for unit conversion"
    annotation (Placement(transformation(extent={{-66,74},{-54,86}})));
equation
  connect(sou2.ports[1], volNonLinSys.ports[1]) annotation (Line(points={{-40,-22},
          {-40,-20},{-2,-20}}, color={0,127,255}));
  connect(volNonLinSys.ports[2], sin.ports[1]) annotation (Line(points={{2,-20},
          {2,-20},{20,-20},{20,-31}},
                                    color={0,127,255}));
  connect(reaExp.y, preHea2.Q_flow) annotation (Line(points={{-45.4,60},{-45.4,
          60},{-40,60}},
                     color={0,0,127}));
  connect(preTem.T, cos1.y) annotation (Line(points={{-57.2,40},{-57.2,40},{
          -63.4,40}}, color={0,0,127}));
  connect(volT.ports[1],sou3. ports[1])
    annotation (Line(points={{-2,-50},{-2,-50},{-40,-50}}, color={0,127,255}));
  connect(volT.ports[2], sin.ports[2])
    annotation (Line(points={{2,-50},{20,-50},{20,-33}}, color={0,127,255}));
  connect(volT.heatPort, preTem.port) annotation (Line(points={{-10,-40},{-18,
          -40},{-18,40},{-44,40}},
                              color={191,0,0}));
  connect(sou4.ports[1], volLinSys.ports[1])
    annotation (Line(points={{-40,-90},{-2,-90}}, color={0,127,255}));
  connect(volLinSys.ports[2], sin.ports[3]) annotation (Line(points={{2,-90},{
          20,-90},{20,-35}},   color={0,127,255}));
  connect(theRes.port_a, volLinSys.heatPort)
    annotation (Line(points={{-22,-74},{-22,-80},{-10,-80}}, color={191,0,0}));
  connect(theRes.port_b, preTem.port)
    annotation (Line(points={{-22,-54},{-22,40},{-44,40}}, color={191,0,0}));
  connect(volNonLinSys.heatPort, preHea2.port) annotation (Line(points={{-10,-10},
          {-10,-10},{-14,-10},{-14,60},{-20,60}},
                                              color={191,0,0}));
  connect(volQflow.heatPort, preHea1.port)
    annotation (Line(points={{-10,20},{-10,80},{-20,80}}, color={191,0,0}));
  connect(sou1.ports[1], volQflow.ports[1]) annotation (Line(points={{-40,10},{
          -28,10},{-2,10}},      color={0,127,255}));
  connect(volQflow.ports[2], sin.ports[4])
    annotation (Line(points={{2,10},{20,10},{20,-37}}, color={0,127,255}));
  connect(ramp_m_flow.y, sou1.m_flow_in) annotation (Line(points={{-79,-10},{
          -72,-10},{-72,18},{-62,18}},
                                   color={0,0,127}));
  connect(ramp_m_flow.y, sou2.m_flow_in) annotation (Line(points={{-79,-10},{
          -72,-10},{-72,-14},{-62,-14}},
                                     color={0,0,127}));
  connect(ramp_m_flow.y, sou3.m_flow_in) annotation (Line(points={{-79,-10},{
          -72,-10},{-72,-42},{-62,-42}},
                                     color={0,0,127}));
  connect(ramp_m_flow.y, sou4.m_flow_in) annotation (Line(points={{-79,-10},{
          -72,-10},{-72,-82},{-62,-82}},
                                     color={0,0,127}));
  connect(ramp_T.y, sou1.T_in) annotation (Line(points={{-79,-50},{-74,-50},{-68,
          -50},{-68,14},{-62,14}}, color={0,0,127}));
  connect(ramp_T.y, sou2.T_in) annotation (Line(points={{-79,-50},{-68,-50},{-68,
          -18},{-62,-18}}, color={0,0,127}));
  connect(ramp_T.y, sou3.T_in) annotation (Line(points={{-79,-50},{-68,-50},{-68,
          -46},{-62,-46}}, color={0,0,127}));
  connect(ramp_T.y, sou4.T_in) annotation (Line(points={{-79,-50},{-68,-50},{-68,
          -86},{-62,-86}}, color={0,0,127}));
  connect(reaPasThr.y, preHea1.Q_flow)
    annotation (Line(points={{-53.4,80},{-40,80}}, color={0,0,127}));
  connect(reaPasThr.u, ramp_m_flow.y)
    annotation (Line(points={{-67.2,80},{-79,80},{-79,-10}}, color={0,0,127}));
  annotation (                                                         Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                    graphics={Text(
          extent={{12,30},{106,10}},
          lineColor={28,108,200},
          textString="<- vol.prescribedHeatFlowRate = true")}),
    experiment(
      Tolerance=1E-6, StopTime=2),
    Documentation(revisions="<html>
<ul>
<li>
January 27, 2016, by Filip Jorissen:<br/>
Changed heat flow rate at zero flow to avoid triggering of
conservation of energy check.
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/470\">
issue 470</a>.
</li>
<li>
November 2, 2016, by Michael Wetter:<br/>
Removed assertion as the variable that are tested are already
part of the regression test.
Also, the previous implementation mixed graphical with textual programming,
which we try to avoid.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/441\">issue 441</a>.
</li>
<li>
January 27, 2016, by Michael Wetter:<br/>
Removed algorithm specification in experiment annotation.
</li>
<li>
July 2, 2015 by Michael Wetter:<br/>
Revised example.
</li>
<li>
June 30, 2015 by Filip Jorissen:<br/>
First implementation
to test
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/282\">
issue 282</a>.
</li>
</ul>
</html>", info="<html>
<p>
This model verifies whether the equations in
<a href=\"modelica://Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation\">
Buildings.Fluid.Interfaces.StaticTwoPortConservationEquation</a>
are consisent for all foreseeable cases.
All <code>MixingVolume</code> instances contain the correct
setting for <code>prescribedHeatFlowRate</code>.
Switching the value will result in an error in each case.
This error either is a non-physical solution to the (non-)linear system
or a division by zero, which halts the simulation.
</p>
<p>
If you use Dymola, set <code>Advanced.Define.AimForHighAccuracy = false</code> to
increase the chance of the error being produced for this simple example.
</p>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/MixingVolumes/Validation/MixingVolumeZeroFlow.mos"
        "Simulate and plot"));
end MixingVolumeZeroFlow;
