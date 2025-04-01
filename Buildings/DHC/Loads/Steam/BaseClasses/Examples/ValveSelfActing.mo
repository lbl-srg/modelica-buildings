within Buildings.DHC.Loads.Steam.BaseClasses.Examples;
model ValveSelfActing
  "Example model for self-acting steam valve with a noisy inlet pressure input"
  extends Modelica.Icons.Example;
  package MediumSte = Buildings.Media.Steam(p_default=400000,
    T_default=273.15+143.61,
    h_default=2738100) "Medium model";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";

  Buildings.DHC.Loads.Steam.BaseClasses.ValveSelfActing prv(
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
    m_flow_nominal=m_flow_nominal,
    tau=0)
    "Upstream specific enthalpy"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntOut(
    redeclare final package Medium = MediumSte,
    m_flow_nominal=m_flow_nominal,
    tau=0)
    "Downstream specific enthalpy"
    annotation (Placement(transformation(extent={{10,-10},{30,10}})));
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
  Controls.OBC.CDL.Reals.Sources.Ramp pInSig(
    height=400000,
    duration=15,
    offset=500000 - 200000) "Signal for inlet pressure"
    annotation (Placement(transformation(extent={{-120,-2},{-100,18}})));
equation
  connect(sou.ports[1], speEntIn.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(speEntIn.port_b, prv.port_a)
    annotation (Line(points={{-30,0},{-20,0}},
                                             color={0,127,255}));
  connect(prv.port_b, speEntOut.port_a)
    annotation (Line(points={{0,0},{10,0}},  color={0,127,255}));
  connect(sin.ports[1], res.port_b)
    annotation (Line(points={{80,0},{60,0}}, color={0,127,255}));
  connect(res.port_a, speEntOut.port_b)
    annotation (Line(points={{40,0},{30,0}}, color={0,127,255}));
  connect(pInSig.y, sou.p_in)
    annotation (Line(points={{-98,8},{-82,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{100,
            100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Loads/Steam/BaseClasses/Examples/ValveSelfActing.mos"
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
June 13, 2024, by Michael Wetter:<br/>
Changed inlet pressure to be a ramp, and removed dynamics of sensor.<br/>
This is for
<a href=\"https://github.com/OpenModelica/OpenModelica/issues/12569\">OpenModelica, #12569</a>.
</li>
<li>
March 2, 2022 by Saranya Anbarasu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ValveSelfActing;
