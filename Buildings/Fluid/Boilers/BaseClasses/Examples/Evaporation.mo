within Buildings.Fluid.Boilers.BaseClasses.Examples;
model Evaporation "Test model for water evaporation process"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSte_nominal=1000000
    "Nominal steam pressure";

  Modelica.Blocks.Sources.Constant pSet(k=pSte_nominal)
                                                   "Steam pressure setpoint"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal) "Mass flow rate"
    annotation (Placement(transformation(extent={{-82,8},{-62,28}})));
  Sources.MassFlowSource_T watSou(
    redeclare package Medium = MediumWat,
    use_m_flow_in=true,
    nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{-50,0},{-30,20}})));
  Sources.Boundary_pT steSin(
    redeclare package Medium = MediumSte,
    use_p_in=true,
    nPorts=1) "Steam sink"
    annotation (Placement(transformation(extent={{78,0},{58,20}})));
  Buildings.Fluid.Boilers.BaseClasses.Evaporation eva(
    redeclare package Medium_a = MediumWat,
    redeclare package Medium_b = MediumSte,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    pSte_nominal=pSte_nominal)                       "Evaporation process"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
equation
  connect(watSou.m_flow_in, m_flow.y)
    annotation (Line(points={{-52,18},{-61,18}}, color={0,0,127}));
  connect(eva.port_b, steSin.ports[1])
    annotation (Line(points={{20,10},{58,10}},   color={0,127,255}));
  connect(pSet.y, steSin.p_in) annotation (Line(points={{41,50},{86,50},{86,18},
          {80,18}}, color={0,0,127}));
  connect(watSou.ports[1],eva. port_a) annotation (Line(points={{-30,10},{0,10}},
                              color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/BaseClasses/Examples/Evaporation.mos"
        "Simulate and plot"));
end Evaporation;
