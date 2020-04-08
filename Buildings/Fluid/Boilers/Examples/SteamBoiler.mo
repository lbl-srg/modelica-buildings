within Buildings.Fluid.Boilers.Examples;
model SteamBoiler "Test model for the steam boiler"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";

  Buildings.Fluid.Boilers.IdealSteamBoiler steamBoiler(m_flow_nominal=
        m_flow_nominal)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Sources.Boundary_pT steSin(
    redeclare package Medium = MediumSte,
    use_p_in=true,
    nPorts=1,
    p(displayUnit="Pa")) "Steam sink"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant pSet(k=1000000) "Steam pressure setpoint"
    annotation (Placement(transformation(extent={{-78,48},{-58,68}})));
  Sources.MassFlowSource_T watSou(
    redeclare package Medium = MediumWat,
    m_flow=m_flow_nominal,
    nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  FixedResistances.PressureDrop preDro_wat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="bar") = 100000)
    "Pressure drop in water pipe network"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Sources.Boundary_pT pRef(
    redeclare package Medium = MediumWat,
    nPorts=1,
    p(displayUnit="bar") = 1200000) "Reference pressure"
    annotation (Placement(transformation(extent={{-20,-50},{-40,-30}})));
equation
  connect(steamBoiler.port_b, steSin.ports[1])
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  connect(pSet.y, steamBoiler.pSte) annotation (Line(points={{-57,58},{-34,58},{
          -34,6},{-11,6}}, color={0,0,127}));
  connect(pSet.y, steSin.p_in) annotation (Line(points={{-57,58},{90,58},{90,8},
          {82,8}}, color={0,0,127}));
  connect(watSou.ports[1], preDro_wat.port_a)
    annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(preDro_wat.port_b, steamBoiler.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
  connect(pRef.ports[1], preDro_wat.port_a) annotation (Line(points={{-40,-40},
          {-50,-40},{-50,0},{-40,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/SteamBoiler.mos"
        "Simulate and plot"));
end SteamBoiler;
