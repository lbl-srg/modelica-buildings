within Buildings.Experimental.DHC.Loads.Steam.BaseClasses.Examples;
model ValveSelfActing
  "Example model to exhibit the performance of self-acting steam valve"
  extends Modelica.Icons.Example;

  package MediumSteam = Buildings.Media.Steam;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.AbsolutePressure pIn=900000 "Inlet pressure";

  parameter Modelica.Units.SI.Temperature TSat=
      MediumSteam.saturationTemperature(pIn) "Saturation temperature";

  Buildings.Experimental.DHC.Loads.Steam.BaseClasses.ValveSelfActing prv(
    redeclare package Medium = MediumSteam,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    pb_nominal=300000) "Self acting valve"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumSteam,
    use_p_in=true,
    p(displayUnit="Pa"),
    T(displayUnit="K") = MediumSteam.saturationTemperature(sou.p),
    nPorts=1) annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntIn(redeclare package
      Medium =
        MediumSteam,
      m_flow_nominal=m_flow_nominal)
                        annotation (Placement(transformation(extent={{-30,-10},
            {-10,10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntOut(redeclare package
      Medium = MediumSteam, m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Modelica.Blocks.Noise.UniformNoise pInSig(
    samplePeriod(displayUnit="s") = 1,
    y_min=900000 + 50000,
    y_max=900000 - 50000)
    "Noisy signal for inlet pressure"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Fluid.Sources.MassFlowSource_T sin(
    redeclare package Medium = MediumSteam,
    use_m_flow_in=true,
    nPorts=1)
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Ramp m_flow_sig(
    height=-1,
    duration=5,
    startTime=5) "Mass flow rate signal"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  inner Modelica.Blocks.Noise.GlobalSeed globalSeed
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(sou.ports[1], speEntIn.port_a)
    annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
  connect(speEntIn.port_b, prv.port_a) annotation (Line(points={{-10,0},{0,
          0}},                                                                  color={0,127,255}));
  connect(prv.port_b, speEntOut.port_a)
    annotation (Line(points={{20,0},{30,0}}, color={0,127,255}));
  connect(pInSig.y, sou.p_in)
    annotation (Line(points={{-79,50},{-70,50},{-70,8},{-62,8}}, color={0,0,127}));
  connect(sin.ports[1], speEntOut.port_b)
    annotation (Line(points={{60,0},{50,0}}, color={0,127,255}));
  connect(m_flow_sig.y, sin.m_flow_in) annotation (Line(points={{81,50},{90,50},
          {90,8},{82,8}},        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
__Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Steam/BaseClasses/Examples/ValveSelfActing.mos"
    "Simulate and plot"),
  experiment(StopTime=15,Tolerance=1e-06),
    Documentation(info="<html>
<p>
Example model for the self-acting two way steam pressure regulating valve model.
</p>
</html>"));
end ValveSelfActing;
