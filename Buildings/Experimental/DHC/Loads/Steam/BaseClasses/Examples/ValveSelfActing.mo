within Buildings.Experimental.DHC.Loads.Steam.BaseClasses.Examples;
model ValveSelfActing
  "Example model for self-acting steam valve with a noisy inlet pressure input"
  extends Modelica.Icons.Example;
  package MediumSte = Buildings.Media.Steam(p_default=400000,
    T_default=273.15+143.61,
    h_default=2738100) "Medium model";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";

  Buildings.Experimental.DHC.Loads.Steam.BaseClasses.ValveSelfActing prv(
    redeclare final package Medium = MediumSte,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    pb_nominal=300000,
    dp_start(displayUnit="Pa"))
     "Self acting pressure reducing valve"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare final package Medium = MediumSte,
    use_p_in=true,
    p(displayUnit="Pa"),
    T(displayUnit="K") = MediumSte.saturationTemperature(sou.p),
    nPorts=1) "Source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntIn(
    redeclare final package Medium = MediumSte,
    m_flow_nominal=m_flow_nominal)
    "Upstream specific enthalpy"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntOut(
    redeclare final package Medium = MediumSte,
    m_flow_nominal=m_flow_nominal)
    "Downstream specific enthalpy"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
  Modelica.Blocks.Noise.UniformNoise pInSig(
    samplePeriod(displayUnit="s") = 1,
    y_min=500000 + 200000,
    y_max=500000 - 200000) "Noisy signal for inlet pressure"
    annotation (Placement(transformation(extent={{-60,40},{-80,60}})));
  Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = MediumSte,
    p=200000,
    T=MediumSte.saturationTemperature(sin.p),
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumSte,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1000) "Pressure drop"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  inner Modelica.Blocks.Noise.GlobalSeed globalSeed
    "Setting for sublibrary noise"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
equation
  connect(sou.ports[1], speEntIn.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(speEntIn.port_b, prv.port_a)
    annotation (Line(points={{-30,0},{-20,0}},
                                             color={0,127,255}));
  connect(prv.port_b, speEntOut.port_a)
    annotation (Line(points={{0,0},{10,0}},  color={0,127,255}));
  connect(pInSig.y, sou.p_in) annotation (Line(points={{-81,50},{-90,50},{-90,8},
          {-82,8}}, color={0,0,127}));
  connect(sin.ports[1], res.port_b)
    annotation (Line(points={{80,0},{60,0}}, color={0,127,255}));
  connect(res.port_a, speEntOut.port_b)
    annotation (Line(points={{40,0},{30,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Steam/BaseClasses/Examples/ValveSelfActing.mos"
    "Simulate and plot"),
    experiment(StopTime=15, Tolerance=1e-06),
    Documentation(info="<html>
<p>
This example model demonstrates the performance of self-acting steam pressure
regulator with a noisy/varying inlet pressure signal. The inlet pressure
conditions are selected to demonstrate how the downstream pressure is maintained
at the setpoint, unless the inlet pressure drops below the setpoint
(pressure drop is then zero).
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
