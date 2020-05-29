within Buildings.Fluid.HeatExchangers.Examples;
model SteamHeatExchangerIdeal
  "Example model for the ideal two-port steam heat exchanger"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.WaterHighTemperature "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal= 1
    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSte_nominal= 1000000
    "Nominal steam pressure";

  Buildings.Fluid.HeatExchangers.SteamHeatExchangerIdeal hex(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    pSte_nominal=pSte_nominal)
    "Steam heat exchanger"
    annotation (Placement(transformation(extent={{10,-20},{30,0}})));
  Sources.Boundary_pT sinWat(redeclare package Medium = MediumWat, nPorts=1)
    "Water sink" annotation (Placement(transformation(extent={{90,-20},{70,0}})));
  Modelica.Blocks.Math.Product mAct_flow "Actual mass flow rate"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Sources.RealExpression mMax_flow(y=m_flow_nominal)
    "Maximum (nominal) mass flow rate"
    annotation (Placement(transformation(extent={{-80,34},{-60,54}})));
  Modelica.Blocks.Sources.TimeTable y(table=[0,0; 1800,1; 1800,0; 2400,0; 2400,1;
        3600,1])
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Movers.FlowControlled_m_flow pum(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)       "Pump"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Sources.Boundary_pT souSte(
    redeclare package Medium = MediumSte,
    p(displayUnit="Pa") = pSte_nominal,
    T=523.15,
    nPorts=1) "Steam source"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
equation
  connect(y.y, mAct_flow.u1) annotation (Line(points={{-59,70},{-50,70},{-50,56},
          {-42,56}}, color={0,0,127}));
  connect(mMax_flow.y, mAct_flow.u2)
    annotation (Line(points={{-59,44},{-42,44}}, color={0,0,127}));
  connect(souSte.ports[1], hex.port_a)
    annotation (Line(points={{0,-10},{10,-10}}, color={0,127,255}));
  connect(hex.port_b, pum.port_a)
    annotation (Line(points={{30,-10},{40,-10}}, color={0,127,255}));
  connect(pum.port_b, sinWat.ports[1]) annotation (Line(points={{60,-10},{66,-10},
          {66,-10},{70,-10}}, color={0,127,255}));
  connect(pum.m_flow_in, mAct_flow.y)
    annotation (Line(points={{50,2},{50,50},{-19,50}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/Examples/SteamHeatExchangerIdeal.mos"
        "Simulate and plot"));
end SteamHeatExchangerIdeal;
