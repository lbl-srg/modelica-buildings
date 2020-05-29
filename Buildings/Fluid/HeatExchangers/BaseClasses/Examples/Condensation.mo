within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model Condensation
  "Test model for water condensation process - WaterIF97_R2pT model"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSte_nominal=1000000
    "Nominal steam pressure";

  Buildings.Fluid.HeatExchangers.BaseClasses.Condensation con(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,                   m_flow_nominal=
        m_flow_nominal,
    pSte_nominal=pSte_nominal)
    "Condensation process"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Sources.Boundary_pT watSin(redeclare package Medium = MediumWat,
    use_p_in=true,                                                 nPorts=1)
                             "Water (100% liquid) sink"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal)
                                               "Mass flow rate"
    annotation (Placement(transformation(extent={{-80,-2},{-60,18}})));
  Modelica.Blocks.Sources.Constant pIn(k=pSte_nominal)
                                                  "Steam pressure (Pa)"
    annotation (Placement(transformation(extent={{30,40},{50,60}})));

  Sources.MassFlowSource_T boundary(
    redeclare package Medium = MediumSte,
    use_m_flow_in=true,
    T=273.15 + 179.9,
    nPorts=1) annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(con.port_b, watSin.ports[1])
    annotation (Line(points={{20,0},{40,0}},   color={0,127,255}));
  connect(boundary.m_flow_in, m_flow.y) annotation (Line(points={{-42,8},{-59,8}},
                                  color={0,0,127}));
  connect(boundary.ports[1], con.port_a)
    annotation (Line(points={{-20,0},{0,0}},  color={0,127,255}));
  connect(pIn.y, watSin.p_in) annotation (Line(points={{51,50},{70,50},{70,8},{
          62,8}},   color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/Condensation.mos"
        "Simulate and plot"));
end Condensation;
