within Buildings.ChillerWSE.Validation.BaseClasses;
partial model PartialChillerWSE
  "Partial examples for chillers and WSE configurations"
  extends Modelica.Icons.Example;

  package MediumCHW = Buildings.Media.Water "Medium model";
  package MediumCW = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=2567.1*1000/(
      4200*10) "Nominal mass flow rate at chilled water";

  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=2567.1*1000/ (
      4200*8.5) "Nominal mass flow rate at condenser water";

  parameter Modelica.SIunits.PressureDifference dpCHW_nominal = 40000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dpCW_nominal = 40000
    "Nominal pressure";
  parameter Integer nChi=1 "Number of chillers";
  parameter Buildings.Fluid.Movers.Data.Generic[nChi] perPum(
    each pressure=
          Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters(
          V_flow=mCHW_flow_nominal/1000*{0.2,0.6,1.0,1.2}, dp=dpCHW_nominal*{1.2,
          1.1,1.0,0.6}));

  Fluid.Sources.FixedBoundary           sin1(
              redeclare package Medium = MediumCW) "Sink on medium 1 side"
                                        annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={90,-4})));
  Fluid.Sources.MassFlowSource_T           sou1(
    use_T_in=true,
    redeclare package Medium = MediumCW,
    m_flow=mCW_flow_nominal,
    T=298.15) "Source on medium 1 side"
    annotation (Placement(transformation(extent={{-60,-14},{-40,6}})));
  Modelica.Blocks.Sources.TimeTable TCon_in(
    table=[0,273.15 + 12.78; 7200,273.15 + 12.78; 7200,273.15 + 18.33; 14400,273.15
         + 18.33; 14400,273.15 + 26.67],
    offset=0,
    startTime=0)      "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Fluid.Sources.FixedBoundary           sin2(
    nPorts=1, redeclare package Medium = MediumCHW) "Sink on medium 2 side"
                                        annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-90,-70})));
  redeclare replaceable Fluid.Sources.Boundary_pT                sou2(T=291.15)
  constrainedby Modelica.Fluid.Sources.BaseClasses.PartialSource(
    use_T_in=true,
    redeclare package Medium = MediumCHW,
    T=291.15) "Source on medium 2 side"
    annotation (Placement(transformation(extent={{58,-84},{38,-64}})));
  Modelica.Blocks.Sources.Constant
                               TEva_in(k=273.15 + 25.28)
                   "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,-80},{80,-60}})));
  Modelica.Blocks.Sources.Constant TSet(k(unit="K",displayUnit="degC")=273.15+15.56)
    "Leaving chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Fluid.Sensors.TemperatureTwoPort TSup(redeclare package Medium = MediumCHW,
      m_flow_nominal=mCHW_flow_nominal)
    annotation (Placement(transformation(extent={{-40,-54},{-60,-34}})));
equation
  connect(TCon_in.y,sou1. T_in)
    annotation (Line(points={{-79,-10},{-72,-10},{-72,0},{-62,0}},
                                                   color={0,0,127}));
  connect(sou2.T_in, TEva_in.y)
    annotation (Line(points={{60,-70},{79,-70}},          color={0,0,127}));
  connect(sin2.ports[1], TSup.port_b) annotation (Line(points={{-80,-70},{-70,
          -70},{-70,-44},{-60,-44}},
                      color={0,127,255}));
end PartialChillerWSE;
