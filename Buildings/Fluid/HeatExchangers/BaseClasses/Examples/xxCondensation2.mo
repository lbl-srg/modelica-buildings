within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model xxCondensation2
  "Test model for water condensation process - WaterIF97_R2pT model"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";

  Buildings.Fluid.HeatExchangers.BaseClasses.Condensation con(
    redeclare package Medium_a = MediumSte,
    redeclare package Medium_b = MediumWat,                   m_flow_nominal=
        m_flow_nominal)
    "Condensation process"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Sources.Boundary_pT watSin(redeclare package Medium = MediumWat,
    use_p_in=true,                                                 nPorts=1)
                             "Water (100% liquid) sink"
    annotation (Placement(transformation(extent={{70,0},{50,20}})));
  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal)
                                               "Mass flow rate"
    annotation (Placement(transformation(extent={{-90,26},{-70,46}})));
  Modelica.Blocks.Sources.Constant pIn(k=1000000) "Steam pressure (Pa)"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Modelica.Blocks.Sources.Constant TIn(k=273.15 + 179.9)
    "Steam inlet temperature (K)"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumWat,
    m_flow_nominal=0,            V=1, nPorts=1)
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Sources.Boundary_pT pRef(redeclare package Medium = MediumWat,
                           nPorts=1) "Pressure reference"
    annotation (Placement(transformation(extent={{90,-80},{70,-60}})));

  HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Sources.MassFlowSource_T boundary(
    redeclare package Medium = MediumSte,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Math.Product QMea_flow "Measured Q_flow"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Modelica.Blocks.Math.Gain inv(k=-1) "Inverse"
    annotation (Placement(transformation(extent={{-60,-46},{-40,-26}})));
equation
  connect(pRef.ports[1], vol.ports[1])
    annotation (Line(points={{70,-70},{60,-70},{60,-40}}, color={0,127,255}));
  connect(con.port_b, watSin.ports[1])
    annotation (Line(points={{40,10},{50,10}}, color={0,127,255}));
  connect(preHeaFlo.port, vol.heatPort)
    annotation (Line(points={{40,-30},{50,-30}}, color={191,0,0}));
  connect(boundary.m_flow_in, m_flow.y) annotation (Line(points={{-22,18},{-40,
          18},{-40,36},{-69,36}}, color={0,0,127}));
  connect(TIn.y, boundary.T_in) annotation (Line(points={{-69,0},{-60,0},{-60,
          14},{-22,14}}, color={0,0,127}));
  connect(boundary.ports[1], con.port_a)
    annotation (Line(points={{0,10},{20,10}}, color={0,127,255}));
  connect(pIn.y, watSin.p_in) annotation (Line(points={{-69,70},{80,70},{80,18},
          {72,18}}, color={0,0,127}));
  connect(QMea_flow.y, preHeaFlo.Q_flow)
    annotation (Line(points={{1,-30},{20,-30}}, color={0,0,127}));
  connect(m_flow.y, QMea_flow.u1) annotation (Line(points={{-69,36},{-40,36},{
          -40,-24},{-22,-24}}, color={0,0,127}));
  connect(inv.y, QMea_flow.u2)
    annotation (Line(points={{-39,-36},{-22,-36}}, color={0,0,127}));
  connect(con.dh, inv.u) annotation (Line(points={{41,16},{44,16},{44,-60},{-72,
          -60},{-72,-36},{-62,-36}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/Condensation.mos"
        "Simulate and plot"));
end xxCondensation2;
