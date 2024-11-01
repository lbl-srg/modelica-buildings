within Buildings.Fluid.HeatPumps.ModularReversible.Validation.Comparative.BaseClasses;
partial model PartialComparison
  "Partial model to allow heat pump and chiller model comparison"
  package Medium1 = Buildings.Media.Water "Medium model";
  package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.HeatFlowRate QUse_flow_nominal = 30E3
    "Nominal capacity";

  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator outlet-inlet";
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";

  parameter Modelica.Units.SI.Pressure dp1_nominal=6000
    "Pressure difference over condenser";
  parameter Modelica.Units.SI.Pressure dp2_nominal=6000
    "Pressure difference over evaporator";
  parameter Real etaCarnot_nominal=0.3
    "Carnot effectiveness (=COP/COP_Carnot) used during simulation if use_eta_Carnot_nominal = true";
  parameter Modelica.Units.SI.Time tau1=60
    "Time constant at nominal flow rate (used if energyDynamics1 <> Modelica.Fluid.Types.Dynamics.SteadyState)";
  parameter Modelica.Units.SI.Temperature T1_start=303.15
    "Initial or guess value of set point";
  parameter Modelica.Units.SI.Time tau2=60
    "Time constant at nominal flow rate (used if energyDynamics2 <> Modelica.Fluid.Types.Dynamics.SteadyState)";
  parameter Modelica.Units.SI.Temperature T2_start=278.15
    "Initial or guess value of set point";

  parameter Modelica.Units.SI.Temperature TConIn_nominal=303.15
    "Nominal condenser inlet temperature";
  parameter Modelica.Units.SI.Temperature TEvaIn_nominal=288.15
    "Nominal condenser inlet temperature";

  parameter Modelica.Units.SI.Temperature TCon_nominal=TConIn_nominal + dTCon_nominal
    "Nominal condenser temperature";
  parameter Modelica.Units.SI.Temperature TEva_nominal=TEvaIn_nominal -
      dTEva_nominal
    "Nominal evaporator temperature";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal
    "Nominal mass flow rate at condenser water wide";
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    redeclare package Medium = Medium1,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15) "Condenser mass flow source"
    annotation (Placement(transformation(extent={{-60,-4},{-40,16}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = Medium2,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15) "Evaporator mass flow source"
    annotation (Placement(transformation(extent={{60,-16},{40,4}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(redeclare package Medium = Medium1)
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={70,30})));
  Buildings.Fluid.Sources.Boundary_pT sin2(redeclare package Medium = Medium2)
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-50,-30})));
  Modelica.Blocks.Sources.Ramp uCom(
    height=-1,
    duration=60,
    offset=1,
    startTime=1800) "Compressor control signal"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Sources.Ramp TCon_in(
    height=10,
    duration=60,
    offset=TConIn_nominal - 10,
    startTime=60) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Modelica.Blocks.Sources.Ramp TEva_in(
    height=10,
    duration=60,
    startTime=900,
    offset=TEvaIn_nominal) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{50,-50},{70,-30}})));
equation
  connect(TCon_in.y,sou1. T_in) annotation (Line(
      points={{-69,10},{-62,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEva_in.y,sou2. T_in) annotation (Line(
      points={{71,-40},{80,-40},{80,-2},{62,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Documentation(revisions="<html>
<ul>
<li>
November 13, 2023 by Fabian Wuellhorst:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Partial model which is based on
<a href=\"modelica://Buildings.Fluid.HeatPumps.Examples.Carnot_y\">
Buildings.Fluid.HeatPumps.Examples.Carnot_y</a>
to validate the modular reversible models by means of
comparison to the <a href=\"modelica://Buildings.Fluid.HeatPumps.Carnot_y\">
Buildings.Fluid.HeatPumps.Carnot_y</a> model.
</p>
</html>"));
end PartialComparison;
