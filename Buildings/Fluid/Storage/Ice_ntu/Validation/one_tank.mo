within Buildings.Fluid.Storage.Ice_ntu.Validation;
model one_tank "Example that test the tank model"
  extends Modelica.Icons.Example;

  parameter Integer ntank=1;
  package Medium = Buildings.Media.Antifreeze.EthyleneGlycolWater (
    property_T=293.15,
    X_a=0.33) "Fluid medium";

  parameter Modelica.Units.SI.Mass SOC_start=3/4
    "Start value of ice mass in the tank";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=100000
    "Pressure difference";

  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=ntank)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium, nPorts=ntank)
    annotation (Placement(transformation(extent={{86,-10},{66,10}})));

  Buildings.Fluid.Storage.Ice_ntu.Tank iceTanUnc[ntank](
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    SOC_start=SOC_start,
    redeclare Buildings.Fluid.Storage.Ice_ntu.Data.Tank.Experiment per,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Uncontrolled ice tank"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Modelica.Blocks.Sources.CombiTimeTable data(
    tableOnFile=true,
    fileName="C:/git/s4b/perso/tank/test_tank_new.txt",
    verboseRead=false,
    columns=2:13,
    tableName="tab1",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"CoolingTower_VariableSpeed_Merkel.idf\" energy plus example results"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=6.8)
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=6.5)
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Modelica.Blocks.Math.Max max1
    annotation (Placement(transformation(extent={{42,70},{62,90}})));
equation
  connect(data.y[4], sou.T_in) annotation (Line(points={{-79,0},{-68,0},{-68,4},
          {-42,4}}, color={0,0,127}));
  connect(sou.ports, iceTanUnc.port_a)
    annotation (Line(points={{-20,0},{0,0}},   color={0,127,255}));
  connect(iceTanUnc.port_b, bou.ports)
    annotation (Line(points={{20,0},{66,0}},color={0,127,255}));
  connect(data.y[1], greaterThreshold.u) annotation (Line(points={{-79,0},{-68,0},
          {-68,110},{-62,110}}, color={0,0,127}));
  connect(data.y[1], lessThreshold.u) annotation (Line(points={{-79,0},{-68,0},{
          -68,66},{-52,66},{-52,50},{-42,50}}, color={0,0,127}));
  connect(data.y[5], switch1.u1) annotation (Line(points={{-79,0},{-68,0},{-68,66},
          {-12,66},{-12,58},{-2,58}}, color={0,0,127}));
  connect(realExpression.y, switch1.u3) annotation (Line(points={{-79,80},{-72,80},
          {-72,42},{-64,42},{-64,36},{-12,36},{-12,42},{-2,42}}, color={0,0,127}));
  connect(lessThreshold.y, switch1.u2)
    annotation (Line(points={{-19,50},{-2,50}}, color={255,0,255}));
  connect(greaterThreshold.y, switch2.u2)
    annotation (Line(points={{-39,110},{-2,110}}, color={255,0,255}));
  connect(data.y[6], switch2.u1) annotation (Line(points={{-79,0},{-68,0},{-68,126},
          {-12,126},{-12,118},{-2,118}}, color={0,0,127}));
  connect(realExpression.y, switch2.u3) annotation (Line(points={{-79,80},{-10,80},
          {-10,102},{-2,102}}, color={0,0,127}));
  connect(switch2.y, max1.u1) annotation (Line(points={{21,110},{32,110},{32,86},
          {40,86}}, color={0,0,127}));
  connect(switch1.y, max1.u2) annotation (Line(points={{21,50},{32,50},{32,74},{
          40,74}}, color={0,0,127}));
  connect(sou.m_flow_in, max1.y) annotation (Line(points={{-42,8},{-52,8},{-52,28},
          {72,28},{72,80},{63,80}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=432000,
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
end one_tank;
