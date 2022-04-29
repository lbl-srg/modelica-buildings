within Buildings.Fluid.FixedResistances.Examples;
model CheckValve "Example model for check valve"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  Modelica.Blocks.Sources.Ramp P_dp(
    duration=1,
    height=4e5,
    offset=3e5,
    startTime=0)
    "Ramp pressure signal"
    annotation (Placement(transformation(extent={{-92,-2},{-72,18}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 20,
    use_p_in=true,
    nPorts=2)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{-50,-10},{-30,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    p(displayUnit="bar") = 500000,
    nPorts=3)
    "Pressure boundary condition"
    annotation (Placement(transformation(
          extent={{50,-10},{30,10}})));
  Buildings.Fluid.FixedResistances.CheckValve checkValve(
    redeclare package Medium = Buildings.Media.Water,
    m_flow_nominal=2,
    dpValve_nominal=3600)
    "Check valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.FixedResistances.CheckValve checkValveDpFix(
    redeclare package Medium = Media.Water,
    m_flow_nominal=2,
    dpValve_nominal=3600,
    dpFixed_nominal=1e4)
    "Check valve with series resistance"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.Fluid.FixedResistances.CheckValve checkValve_m_flow(
    redeclare package Medium = Media.Water,
    m_flow_nominal=2,
    dpValve_nominal=3600)
    "Check valve where the flow rate is prescribed"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Sources.MassFlowSource_T bou(
    redeclare package Medium = Media.Water,
    use_m_flow_in=true,
    nPorts=1)
    "Mass flow source"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Modelica.Blocks.Sources.Ramp P_m_flow(
    duration=1,
    height=5,
    offset=0,
    startTime=0)
    "Ramp flow rate signal"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
equation
  connect(P_dp.y, sou.p_in)
    annotation (Line(points={{-71,8},{-52,8}}, color={0,0,127}));
  connect(sou.ports[1], checkValve.port_a)
    annotation (Line(points={{-30,2},{-20,2},{-20,0},{-10,0}},
                                               color={0,127,255}));
  connect(checkValve.port_b, sin.ports[1])
    annotation (Line(points={{10,0},{20,0},{20,2.66667},{30,2.66667}},
                                             color={0,127,255}));
  connect(sou.ports[2], checkValveDpFix.port_a)
    annotation (Line(points={{-30,-2},{-30,30},{-10,30}}, color={0,127,255}));
  connect(checkValveDpFix.port_b, sin.ports[2])
    annotation (Line(points={{10,30},{30,30},{30,-2.22045e-16}},
                                                       color={0,127,255}));
  connect(bou.ports[1], checkValve_m_flow.port_a)
    annotation (Line(points={{-30,-40},{-10,-40}}, color={0,127,255}));
  connect(P_m_flow.y, bou.m_flow_in) annotation (Line(points={{-69,-40},{-64,-40},
          {-64,-32},{-52,-32}}, color={0,0,127}));
  connect(checkValve_m_flow.port_b, sin.ports[3]) annotation (Line(points={{10,-40},
          {30,-40},{30,-2.66667}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-06, StopTime=1),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Examples/CheckValve.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
September 16, 2019, by Kristoff Six and Filip Jorissen:<br/>
Implementation of a hydraulic check valve. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1198\">issue 1198</a>.
</li>
</ul>
</html>", info="<html>
<p>
Example model for the use of a hydraulic check valve.
</p>
</html>"));
end CheckValve;
