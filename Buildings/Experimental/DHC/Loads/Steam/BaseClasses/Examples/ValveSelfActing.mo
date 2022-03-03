within Buildings.Experimental.DHC.Loads.Steam.BaseClasses.Examples;
model ValveSelfActing
  "Self-acting steam valve with a noisy inlet pressure and ramp mass flow rate"
  extends Modelica.Icons.Example;
  package MediumSte = Buildings.Media.Steam "Medium model";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";

  Buildings.Experimental.DHC.Loads.Steam.BaseClasses.ValveSelfActing prv(
    redeclare package Medium = MediumSte,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    pb_nominal=300000) "Self acting pressure reducing valve"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumSte,
    use_p_in=true,
    p(displayUnit="Pa"),
    T(displayUnit="K") = MediumSte.saturationTemperature(sou.p),
    nPorts=1) "Source"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntIn(
    redeclare package Medium = MediumSte,
    m_flow_nominal=m_flow_nominal)
    "Upstream specific enthalpy"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntOut(
    redeclare package Medium = MediumSte,
    m_flow_nominal=m_flow_nominal)
    "Downstream specific enthalpy"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Noise.UniformNoise pInSig(
    samplePeriod(displayUnit="s") = 1,
    y_min=500000 + 400000,
    y_max=500000 - 400000)
    "Noisy signal for inlet pressure"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Fluid.Sources.MassFlowSource_T sin(
    redeclare package Medium = MediumSte,
    use_m_flow_in=true,
    nPorts=1) "Sink (ideal)"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Ramp m_flow_sig(
    height=-1,
    duration=5,
    startTime=5) "Mass flow rate signal"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  inner Modelica.Blocks.Noise.GlobalSeed globalSeed
    "Setting for sublibrary noise"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(sou.ports[1], speEntIn.port_a)
    annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
  connect(speEntIn.port_b, prv.port_a)
    annotation (Line(points={{-10,0},{0,0}}, color={0,127,255}));
  connect(prv.port_b, speEntOut.port_a)
    annotation (Line(points={{20,0},{30,0}}, color={0,127,255}));
  connect(pInSig.y, sou.p_in) annotation (Line(points={{-79,50},{-70,50},{-70,8},
          {-62,8}}, color={0,0,127}));
  connect(sin.ports[1], speEntOut.port_b)
    annotation (Line(points={{60,0},{50,0}}, color={0,127,255}));
  connect(m_flow_sig.y, sin.m_flow_in)
    annotation (Line(points={{81,50},{90,50},{90,8},{82,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Steam/BaseClasses/Examples/ValveSelfActing.mos"
    "Simulate and plot"),
    experiment(StopTime=15, Tolerance=1e-06),
    Documentation(info="<html>
<p>
This example model demonstrates the performance of self-acting steam pressure regulator 
with a noisy/varying inlet pressure signal and a ramped mass flow rate signal. The inlet 
pressure conditions are selected to demonstrate how the downstream pressure is maintained 
at the setpoint, unless the inlet pressure drops below the setpoint (pressure drop is then zero).
</p>
</html>",revisions="<html>
<ul>
<li>
March 2, 2022 by Saranya Anbarasu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ValveSelfActing;
