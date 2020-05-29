within Buildings.Fluid.Boilers.Examples;
model SteamBoilerIdeal "Test model for the ideal steam boiler"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSte_nominal= 1000000
    "Nominal steam pressure";

  Buildings.Fluid.Boilers.SteamBoilerIdeal boi(
    redeclare package Medium_a = MediumWat,
    redeclare package Medium_b = MediumSte,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    pSte_nominal=pSte_nominal)     "Steam boiler"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Sources.Boundary_pT steSin(
    redeclare package Medium = MediumSte,
    use_p_in=true,
    nPorts=1,
    p(displayUnit="Pa")) "Steam sink"
    annotation (Placement(transformation(extent={{80,-10},{60,10}})));
  Modelica.Blocks.Sources.Constant pSet(k=pSte_nominal) "Steam pressure setpoint"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  FixedResistances.PressureDrop dp_wat(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    dp_nominal(displayUnit="bar") = 100000)
    "Pressure drop in water pipe network"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Sources.Boundary_pT watSou(
    redeclare package Medium = MediumWat,
    p(displayUnit="Pa"),
    nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Movers.FlowControlled_m_flow pum(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)       "Pump"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(boi.port_b, steSin.ports[1])
    annotation (Line(points={{40,0},{60,0}}, color={0,127,255}));
  connect(pSet.y, steSin.p_in) annotation (Line(points={{61,40},{90,40},{90,8},
          {82,8}}, color={0,0,127}));
  connect(dp_wat.port_b, boi.port_a)
    annotation (Line(points={{0,0},{20,0}}, color={0,127,255}));
  connect(watSou.ports[1], pum.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(pum.port_b, dp_wat.port_a)
    annotation (Line(points={{-30,0},{-20,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/SteamBoilerIdeal.mos"
        "Simulate and plot"));
end SteamBoilerIdeal;
