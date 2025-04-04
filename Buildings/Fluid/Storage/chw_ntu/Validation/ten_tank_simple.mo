within Buildings.Fluid.Storage.chw_ntu.Validation;
model ten_tank_simple "Example that test the tank model"
  extends Modelica.Icons.Example;

  parameter Integer ntank=50;
  package Medium = Buildings.Media.Antifreeze.EthyleneGlycolWater (
    property_T=273.15-3.8,
    X_a=0.33) "Fluid medium";

  parameter Modelica.Units.SI.Mass SOC_start=3/4
    "Start value of ice mass in the tank";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=100000
    "Pressure difference";

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=141.728,
    use_T_in=true,
    T=274.25,
    nPorts=ntank)
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{80,0},{60,20}})));

  Buildings.Fluid.Storage.chw_ntu.Tank iceTanUnc[ntank](
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal/ntank,
    dp_nominal=dp_nominal,
    T_start=279.85,
    SOC_start=SOC_start,
    redeclare Buildings.Fluid.Storage.chw_ntu.Data.Tank.Experiment per)
    "Uncontrolled ice tank"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium "Water",
    m_flow_nominal=10,
    T_start=273.15)
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Modelica.Blocks.Sources.Step step(
    height=-5.6,
    offset=6.7 + 273.15,
    startTime(displayUnit="min") = 120000)
    annotation (Placement(transformation(extent={{-100,4},{-80,24}})));
equation
  for i in 1:ntank loop
      connect(iceTanUnc[i].port_b, senTem.port_a)
    annotation (Line(points={{0,10},{20,10}},    color={0,127,255}));
  end for;

  connect(senTem.port_b, bou.ports[1])
    annotation (Line(points={{40,10},{60,10}}, color={0,127,255}));
  connect(sou.ports, iceTanUnc.port_a)
    annotation (Line(points={{-40,10},{-20,10}}, color={0,127,255}));
  connect(step.y, sou.T_in)
    annotation (Line(points={{-79,14},{-62,14}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=240000,
      Interval=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Validation/Tank.mos"
        "Simulate and Plot"),
    Documentation(info="<html>
<p>
This example is to verify the ice tank model <a href=\"modelica://Buildings.Fluid.Storage.Ice\">Buildings.Fluid.Storage.Ice</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
December 14, 2021, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ten_tank_simple;
