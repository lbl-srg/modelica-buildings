within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model Condensation "Test model for water condensation process"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water "Water medium";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";

  Buildings.Fluid.HeatExchangers.BaseClasses.Condensation con
    "Condensation process"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Sources.Boundary_pT steSou(
    redeclare package Medium = MediumSte,
                             use_p_in=true, use_T_in=true,
    nPorts=1)
    "Steam (100% vapor) source"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Sources.Boundary_pT watSin(redeclare package Medium = MediumWat, nPorts=1)
                             "Water (100% liquid) sink"
    annotation (Placement(transformation(extent={{70,0},{50,20}})));
  Movers.FlowControlled_m_flow floCon(
    redeclare package Medium = MediumSte,
    m_flow_nominal=m_flow_nominal,    addPowerToMedium=false,
      nominalValuesDefineDefaultPressureCurve=true)
    "Ideal mass flow controller"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Modelica.Blocks.Sources.Constant m_flow(k=m_flow_nominal)
                                               "Mass flow rate"
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
  Modelica.Blocks.Sources.Constant pIn(k=1000000) "Steam pressure (Pa)"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
  Modelica.Blocks.Sources.Constant TIn(k=273.15 + 179.9)
    "Steam inlet temperature (K)"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumWat,
    m_flow_nominal=0,            V=1, nPorts=1)
    annotation (Placement(transformation(extent={{50,-40},{70,-20}})));
  Sources.Boundary_pT pRef(redeclare package Medium = MediumWat,
                           nPorts=1) "Pressure reference"
    annotation (Placement(transformation(extent={{90,-80},{70,-60}})));

equation
  connect(floCon.m_flow_in, m_flow.y)
    annotation (Line(points={{0,22},{0,70},{-9,70}},  color={0,0,127}));
  connect(steSou.p_in, pIn.y) annotation (Line(points={{-42,18},{-50,18},{-50,70},
          {-69,70}}, color={0,0,127}));
  connect(steSou.T_in, TIn.y) annotation (Line(points={{-42,14},{-60,14},{-60,30},
          {-69,30}}, color={0,0,127}));
  connect(pRef.ports[1], vol.ports[1])
    annotation (Line(points={{70,-70},{60,-70},{60,-40}}, color={0,127,255}));
  connect(steSou.ports[1], floCon.port_a)
    annotation (Line(points={{-20,10},{-10,10}}, color={0,127,255}));
  connect(floCon.port_b, con.port_a)
    annotation (Line(points={{10,10},{20,10}}, color={0,127,255}));
  connect(con.port_b, watSin.ports[1])
    annotation (Line(points={{40,10},{50,10}}, color={0,127,255}));
  connect(vol.heatPort, con.port_h)
    annotation (Line(points={{50,-30},{30,-30},{30,0}}, color={191,0,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(Tolerance=1e-6, StopTime=100.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/Condensation.mos"
        "Simulate and plot"));
end Condensation;
