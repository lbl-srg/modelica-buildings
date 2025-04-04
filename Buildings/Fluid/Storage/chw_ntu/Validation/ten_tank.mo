within Buildings.Fluid.Storage.chw_ntu.Validation;
model ten_tank "Example that test the tank model"
  extends Modelica.Icons.Example;

  parameter Integer ntank=10;
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
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=ntank)
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    redeclare package Medium = Medium, nPorts=1)
    annotation (Placement(transformation(extent={{200,-40},{180,-20}})));

  Buildings.Fluid.Storage.chw_ntu.Tank iceTanUnc[ntank](
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=dp_nominal,
    T_start=271.65,
    SOC_start=SOC_start,
    redeclare Buildings.Fluid.Storage.chw_ntu.Data.Tank.Experiment per)
    "Uncontrolled ice tank"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Modelica.Blocks.Sources.CombiTimeTable data(
    tableOnFile=true,
    fileName="C:/git/s4b/perso/tank/full_check.txt",
    verboseRead=false,
    columns=2:43,
    tableName="tab1")
    "Reader for \"CoolingTower_VariableSpeed_Merkel.idf\" energy plus example results"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Logical.GreaterThreshold greaterThreshold(threshold=6.8)
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Modelica.Blocks.Logical.LessThreshold lessThreshold(threshold=6.5)
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Modelica.Blocks.Sources.RealExpression realExpression
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Modelica.Blocks.Math.Max max1
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Modelica.Thermal.HeatTransfer.Celsius.ToKelvin toKelvin
    annotation (Placement(transformation(extent={{-60,-36},{-40,-16}})));
  Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium "Water",
    m_flow_nominal=10,
    T_start=273.15)
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  FixedResistances.Junction jun(
    redeclare package Medium = Medium,
    m_flow_nominal={141,-141,141},
    dp_nominal={0,0,0})
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Sensors.TemperatureTwoPort senTem1(
    redeclare package Medium = Medium "Water",
    m_flow_nominal=10,
    T_start=273.15)
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium "Water",
    use_m_flow_in=true,
    use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Sensors.TemperatureTwoPort senTem2(
    redeclare package Medium = Medium "Water",
    m_flow_nominal=10,
    T_start=273.15)
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Modelica.Blocks.Math.Add add(k2=-1)
    annotation (Placement(transformation(extent={{-60,-72},{-40,-52}})));
equation
  for i in 1:ntank loop
      connect(iceTanUnc[i].port_b, senTem.port_a)
    annotation (Line(points={{40,-30},{60,-30}}, color={0,127,255}));
  end for;
  connect(sou.ports, iceTanUnc.port_a)
    annotation (Line(points={{0,-30},{20,-30}},color={0,127,255}));
  connect(realExpression.y, switch1.u3) annotation (Line(points={{-79,50},{-60,50},
          {-60,6},{-12,6},{-12,12},{-2,12}},                     color={0,0,127}));
  connect(lessThreshold.y, switch1.u2)
    annotation (Line(points={{-19,20},{-2,20}}, color={255,0,255}));
  connect(greaterThreshold.y, switch2.u2)
    annotation (Line(points={{-39,80},{-2,80}},   color={255,0,255}));
  connect(realExpression.y, switch2.u3) annotation (Line(points={{-79,50},{-10,50},
          {-10,72},{-2,72}},   color={0,0,127}));
  connect(switch2.y, max1.u1) annotation (Line(points={{21,80},{32,80},{32,56},{
          38,56}},  color={0,0,127}));
  connect(switch1.y, max1.u2) annotation (Line(points={{21,20},{32,20},{32,44},{
          38,44}}, color={0,0,127}));
  connect(sou.m_flow_in, max1.y) annotation (Line(points={{-22,-22},{-30,-22},{-30,
          -10},{80,-10},{80,50},{61,50}},
                                    color={0,0,127}));
  connect(toKelvin.Kelvin, sou.T_in)
    annotation (Line(points={{-39,-26},{-22,-26}}, color={0,0,127}));

  connect(senTem.port_b, jun.port_1)
    annotation (Line(points={{80,-30},{100,-30}}, color={0,127,255}));
  connect(boundary.ports[1], senTem1.port_a)
    annotation (Line(points={{20,-70},{40,-70}}, color={0,127,255}));
  connect(senTem1.port_b, jun.port_3) annotation (Line(points={{60,-70},{110,-70},
          {110,-40}}, color={0,127,255}));
  connect(jun.port_2, senTem2.port_a)
    annotation (Line(points={{120,-30},{140,-30}}, color={0,127,255}));
  connect(senTem2.port_b, bou.ports[1])
    annotation (Line(points={{160,-30},{180,-30}}, color={0,127,255}));
  connect(toKelvin.Kelvin, boundary.T_in) annotation (Line(points={{-39,-26},{-30,
          -26},{-30,-66},{-2,-66}}, color={0,0,127}));
  connect(add.y, boundary.m_flow_in)
    annotation (Line(points={{-39,-62},{-2,-62}}, color={0,0,127}));
  connect(max1.y, add.u2) annotation (Line(points={{61,50},{80,50},{80,-10},{
          -74,-10},{-74,-68},{-62,-68}}, color={0,0,127}));
  connect(data.y[42], greaterThreshold.u) annotation (Line(points={{-79,-30},{
          -70,-30},{-70,80},{-62,80}}, color={0,0,127}));
  connect(data.y[42], lessThreshold.u) annotation (Line(points={{-79,-30},{-70,
          -30},{-70,20},{-42,20}}, color={0,0,127}));
  connect(data.y[28], switch1.u1) annotation (Line(points={{-79,-30},{-70,-30},
          {-70,36},{-10,36},{-10,28},{-2,28}}, color={0,0,127}));
  connect(data.y[28], add.u1) annotation (Line(points={{-79,-30},{-70,-30},{-70,
          -56},{-62,-56}}, color={0,0,127}));
  connect(data.y[20], toKelvin.Celsius) annotation (Line(points={{-79,-30},{-70,
          -30},{-70,-26},{-62,-26}}, color={0,0,127}));
  connect(data.y[17], switch2.u1) annotation (Line(points={{-79,-30},{-70,-30},
          {-70,100},{-20,100},{-20,88},{-2,88}}, color={0,0,127}));
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
end ten_tank;
