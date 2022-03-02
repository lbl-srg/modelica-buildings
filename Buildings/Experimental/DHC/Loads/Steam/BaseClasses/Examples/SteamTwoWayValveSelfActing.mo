within Buildings.Experimental.DHC.Loads.Steam.BaseClasses.Examples;
model SteamTwoWayValveSelfActing
  "Example model to exhibit the performance of self-acting steam valve"
  extends Modelica.Icons.Example;

  package MediumSteam = Buildings.Media.Steam;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.AbsolutePressure pIn=900000 "Inlet pressure";

  parameter Modelica.Units.SI.Temperature TSat=
      MediumSteam.saturationTemperature(pIn) "Saturation temperature";

  Buildings.Experimental.DHC.Loads.Steam.BaseClasses.SteamTwoWayValveSelfActing
                                                      prv(
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
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumSteam,
    p(displayUnit="bar") = 300000,
    T(displayUnit="K") = MediumSteam.saturationTemperature(sin.p),
    nPorts=1) annotation (Placement(transformation(extent={{100,-10},{80,10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntIn(redeclare package
      Medium =
        MediumSteam,
      m_flow_nominal=m_flow_nominal)
                        annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntOu(redeclare package
      Medium =
        MediumSteam,
      m_flow_nominal=m_flow_nominal)
                        annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Noise.UniformNoise pInSig(
    samplePeriod(displayUnit="s") = 10,
    y_min=900000 + 50000,
    y_max=900000 - 50000)
                       "Noisy signal for inlet pressure"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
equation
  connect(sou.ports[1], speEntIn.port_a)
    annotation (Line(points={{-40,0},{-30,0}}, color={0,127,255}));
  connect(speEntIn.port_b, prv.port_a) annotation (Line(points={{-10,0},{0,0}}, color={0,127,255}));
  connect(prv.port_b, speEntOu.port_a) annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(speEntOu.port_b,sin. ports[1])
    annotation (Line(points={{60,0},{80,0}}, color={0,127,255}));
  connect(pInSig.y, sou.p_in)
    annotation (Line(points={{-79,50},{-70,50},{-70,8},{-62,8}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
__Dymola_Commands(file=
    "modelica://DES/Resources/Scripts/Dymola/Heating/Loads/Valves/Examples/SteamTwoWayValveSelfActing.mos"
    "Simulate and plot"),
  experiment(StopTime=1000,Tolerance=1e-06),
    Documentation(info="<html>
<p>
Example model for the self-acting two way steam pressure regulating valve model.
</p>
</html>"));
end SteamTwoWayValveSelfActing;
