within Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples;
model SingleCircuitMultipleCircuitEpsilonNTU
  "Model that tests the radiant slab with multiple parallel circuits and epsilon-NTU configuration"
  extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water;
  Sources.Boundary_ph sin(redeclare package Medium = Medium, nPorts=3,
    p(displayUnit="Pa") = 300000) "Sink"
    annotation (Placement(transformation(extent={{132,-30},{112,-10}})));
  Modelica.Blocks.Sources.Pulse pulse(
    startTime=0,
    amplitude=50*400,
    offset=300000 - 50*200,
    width=50,
    period=86400/2)
    annotation (Placement(transformation(extent={{-100,-22},{-80,-2}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla1(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    layers=layers,
    iLayPip=1,
    pipe=pipe,
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    disPip=0.2,
    A=A,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true) "Slabe with embedded pipes"
    annotation (Placement(transformation(extent={{-14,10},{6,30}})));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.167
    "Nominal mass flow rate for each circuit";
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TAbo(T=293.15)
    "Air temperature above the slab"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TBel(T=293.15)
    "Radiant temperature below the slab"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conAbo1(G=20*A)
    "Combined convection and radiation resistance above the slab"
    annotation (Placement(transformation(extent={{-20,110},{-40,130}})));
  parameter Modelica.Units.SI.Area A=10 "Heat transfer area for each circuit";
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel1(G=20*A)
    "Combined convection and radiation resistance below the slab"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  parameter HeatTransfer.Data.OpaqueConstructions.Generic layers(nLay=3, material={
        Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.08,
        k=1.13,
        c=1000,
        d=1400,
        nSta=5),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.05,
        k=0.04,
        c=1400,
        d=10),Buildings.HeatTransfer.Data.Solids.Generic(
        x=0.2,
        k=1.8,
        c=1100,
        d=2400)})
    "Material layers from surface a to b (8cm concrete, 5 cm insulation, 20 cm reinforced concrete)"
    annotation (Placement(transformation(extent={{80,100},{100,120}})));
  parameter Data.Pipes.PEX_RADTEST pipe "Pipe material"
    annotation (Placement(transformation(extent={{80,72},{100,92}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conAbo2(G=20*A)
    "Combined convection and radiation resistance above the slab"
    annotation (Placement(transformation(extent={{-20,80},{-40,100}})));
  Buildings.Fluid.HeatExchangers.RadiantSlabs.SingleCircuitSlab sla2(
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    layers=layers,
    iLayPip=1,
    pipe=pipe,
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    disPip=0.2,
    A=A,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true) "Slabe with embedded pipes"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel2(G=20*A)
    "Combined convection and radiation resistance below the slab"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel3(G=nCir*20*A)
    "Combined convection and radiation resistance below the slab"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  ParallelCircuitsSlab sla3(
    redeclare package Medium = Medium,
    layers=layers,
    iLayPip=1,
    pipe=pipe,
    sysTyp=Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor,
    disPip=0.2,
    nCir=nCir,
    A=nCir*A,
    m_flow_nominal=nCir*m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    from_dp=true) "Slabe with embedded pipes"
    annotation (Placement(transformation(extent={{30,-70},{50,-50}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conAbo3(G=nCir*20*A)
    "Combined convection and radiation resistance above the slab"
    annotation (Placement(transformation(extent={{-20,50},{-40,70}})));
  Sensors.TemperatureTwoPort senTem1(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal/2) "Temperature sensor"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  Sensors.TemperatureTwoPort senTem2(redeclare package Medium = Medium,
      m_flow_nominal=m_flow_nominal/2) "Temperature sensor"
    annotation (Placement(transformation(extent={{70,-30},{90,-10}})));
  Sensors.TemperatureTwoPort senTem3(redeclare package Medium = Medium,
      m_flow_nominal=nCir*m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));
  Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    nPorts=3,
    use_p_in=true,
    T=313.15) "Source"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  parameter Integer nCir=2 "Number of parallel circuits for slab 3";
equation
  connect(TBel.port, conBel1.port_a)    annotation (Line(
      points={{-60,-80},{-40,-80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conBel1.port_b, sla1.surf_b)
                                      annotation (Line(
      points={{-20,-80},{6.66134e-16,-80},{6.66134e-16,10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla1.surf_a, conAbo1.port_a)    annotation (Line(
      points={{6.66134e-16,30},{0,30},{0,120},{-20,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAbo.port, conAbo1.port_b) annotation (Line(
      points={{-60,120},{-40,120}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAbo.port, conAbo2.port_b) annotation (Line(
      points={{-60,120},{-52,120},{-52,90},{-40,90}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conAbo2.port_a, sla2.surf_a)    annotation (Line(
      points={{-20,90},{24,90},{24,-10}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TBel.port, conBel2.port_a) annotation (Line(
      points={{-60,-80},{-50,-80},{-50,-110},{-40,-110}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TBel.port, conBel3.port_a) annotation (Line(
      points={{-60,-80},{-50,-80},{-50,-140},{-40,-140}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAbo.port, conAbo3.port_b) annotation (Line(
      points={{-60,120},{-52,120},{-52,60},{-40,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conAbo3.port_a, sla3.surf_a)    annotation (Line(
      points={{-20,60},{44,60},{44,-50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(conBel3.port_b, sla3.surf_b)    annotation (Line(
      points={{-20,-140},{44,-140},{44,-70}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(sla1.port_b, senTem1.port_a)    annotation (Line(
      points={{6,20},{70,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla2.port_b, senTem2.port_a)    annotation (Line(
      points={{30,-20},{70,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sla3.port_b, senTem3.port_a)    annotation (Line(
      points={{50,-60},{70,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem1.port_b, sin.ports[1]) annotation (Line(
      points={{90,20},{100,20},{100,-17.3333},{112,-17.3333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem2.port_b, sin.ports[2]) annotation (Line(
      points={{90,-20},{112,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTem3.port_b, sin.ports[3]) annotation (Line(
      points={{90,-60},{100,-60},{100,-22.6667},{112,-22.6667}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(conBel2.port_b, sla2.surf_b) annotation (Line(
      points={{-20,-110},{24,-110},{24,-30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(pulse.y, sou.p_in) annotation (Line(
      points={{-79,-12},{-72,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], sla1.port_a) annotation (Line(
      points={{-50,-17.3333},{-38,-17.3333},{-38,20},{-14,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], sla2.port_a) annotation (Line(
      points={{-50,-20},{10,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[3], sla3.port_a) annotation (Line(
      points={{-50,-22.6667},{-40,-22.6667},{-40,-60},{30,-60}},
      color={0,127,255},
      smooth=Smooth.None));

 annotation(__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/RadiantSlabs/Examples/SingleCircuitMultipleCircuitEpsilonNTU.mos"
        "Simulate and plot"),
         Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,-160},
            {160,160}})),
Documentation(info="<html>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.SingleCircuitMultipleCircuitFiniteDifference\">
Buildings.Fluid.HeatExchangers.RadiantSlabs.Examples.SingleCircuitMultipleCircuitFiniteDifference</a>
except that the number of segments in the slab is set to <i>1</i>
and the heat transfer between the fluid and the slab is computed using
an epsilon-NTU model.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
October 7, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=86400,
      Tolerance=1e-6));
end SingleCircuitMultipleCircuitEpsilonNTU;
