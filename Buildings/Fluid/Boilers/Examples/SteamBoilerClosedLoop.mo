within Buildings.Fluid.Boilers.Examples;
model SteamBoilerClosedLoop
  "Test model for the steam boiler with a closed fluid loop"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";

  Buildings.Fluid.Boilers.SteamBoiler boi(m_flow_nominal=m_flow_nominal)
    "Steam boiler"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Sources.Boundary_pT PRef(
    redeclare package Medium = MediumSte,
    use_p_in=true,
    p(displayUnit="Pa"),
    nPorts=1) "Reference pressure"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Blocks.Sources.Constant pSet(k=1000000) "Steam pressure setpoint"
    annotation (Placement(transformation(extent={{-78,48},{-58,68}})));
  HeatExchangers.SteamHeatExchanger hex "Steam heat exchanger"
    annotation (Placement(transformation(extent={{0,-70},{-20,-50}})));
  FixedResistances.PressureDrop preDro_ste(
    redeclare package Medium = MediumSte,
    m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="bar") = 100000)
    "Pressure drop in steam pipe network"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  FixedResistances.PressureDrop preDro_wat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="bar") = 100000)
    "Pressure drop in water pipe network"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Movers.FlowControlled_m_flow pumCNR(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    nominalValuesDefineDefaultPressureCurve=true) "Condensate return pump"
    annotation (Placement(transformation(extent={{-40,-70},{-60,-50}})));
equation
  connect(pSet.y, boi.pSte) annotation (Line(points={{-57,58},{-10,58},{-10,6},
          {-1,6}}, color={0,0,127}));
  connect(preDro_wat.port_b, boi.port_a)
    annotation (Line(points={{-30,0},{0,0}}, color={0,127,255}));
  connect(boi.port_b, preDro_ste.port_a) annotation (Line(points={{20,0},{60,0},
          {60,-60},{50,-60}}, color={0,127,255}));
  connect(preDro_ste.port_b, hex.port_a)
    annotation (Line(points={{30,-60},{0,-60}}, color={0,127,255}));
  connect(hex.port_b, pumCNR.port_a)
    annotation (Line(points={{-20,-60},{-40,-60}}, color={0,127,255}));
  connect(pumCNR.port_b, preDro_wat.port_a) annotation (Line(points={{-60,-60},
          {-70,-60},{-70,0},{-50,0}}, color={0,127,255}));
  connect(pSet.y, PRef.p_in) annotation (Line(points={{-57,58},{-10,58},{-10,38},
          {18,38}}, color={0,0,127}));
  connect(PRef.ports[1], boi.port_b) annotation (Line(points={{40,30},{50,30},{
          50,0},{20,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/SteamBoiler.mos"
        "Simulate and plot"));
end SteamBoilerClosedLoop;
