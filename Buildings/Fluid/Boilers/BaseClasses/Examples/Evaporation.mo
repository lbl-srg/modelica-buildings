within Buildings.Fluid.Boilers.BaseClasses.Examples;
model Evaporation "Test model for water evaporation process"
  extends Modelica.Icons.Example;

  package MediumSte = Buildings.Media.Steam "Steam medium";
  package MediumWat = Buildings.Media.Water "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSatHig=1000000
    "Nominal steam pressure";

  Modelica.Blocks.Sources.Constant pSet(k(start=1000000)=pSatHig)
    "Steam pressure setpoint"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    height=m_flow_nominal,
    duration=50,
    startTime=25)
    "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
  Buildings.Fluid.Sources.MassFlowSource_T watSou(
    redeclare package Medium = MediumWat,
    use_m_flow_in=true,
    nPorts=1)
    "Water source"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Fluid.Sources.Boundary_pT steSin(
    redeclare package Medium = MediumSte,
    use_p_in=true,
    nPorts=1)
    "Steam sink"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  Buildings.Fluid.Boilers.BaseClasses.Evaporation eva(
    redeclare package MediumWat = MediumWat,
    redeclare package MediumSte = MediumSte,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    pSatHig=pSatHig)
    "Evaporation process"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(watSou.m_flow_in, m_flow.y)
    annotation (Line(points={{-42,18},{-59,18}}, color={0,0,127}));
  connect(pSet.y, steSin.p_in) annotation (Line(points={{81,50},{86,50},{86,18},
          {62,18}}, color={0,0,127}));
  connect(watSou.ports[1], eva.port_a)
    annotation (Line(points={{-20,10},{0,10}}, color={0,127,255}));
  connect(eva.port_b, steSin.ports[1])
    annotation (Line(points={{20,10},{40,10}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/BaseClasses/Examples/Evaporation.mos"
        "Simulate and plot"));
end Evaporation;
