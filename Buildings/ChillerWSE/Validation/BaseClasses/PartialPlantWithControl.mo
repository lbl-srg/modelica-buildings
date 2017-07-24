within Buildings.ChillerWSE.Validation.BaseClasses;
partial model PartialPlantWithControl
  "Partial model that tests source plant with temperature control"
  extends Modelica.Icons.Example;
 package Medium1 = Buildings.Media.Water "Medium model";
 package Medium2 = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=1000 * 0.01035
    "Nominal mass flow rate at evaporator";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=1000 * 0.01035
    "Nominal mass flow rate at condenser";
  parameter Modelica.SIunits.Pressure dp1_nominal=60000
    "Nominal pressure difference on medium 1 side";
  parameter Modelica.SIunits.Pressure dp2_nominal=60000
    "Nominal pressure difference on medium 2 side";

  Buildings.Fluid.Sources.MassFlowSource_T           sou1(
    redeclare package Medium = Medium1,
    use_T_in=true,
    m_flow=m1_flow_nominal,
    T=298.15) "Source on medium 1 side"
    annotation (Placement(transformation(extent={{-62,16},{-42,36}})));
  Modelica.Blocks.Sources.Step T1_in(
    height=2,
    offset=273.15 + 5,
    startTime=300)    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T           sou2(
    redeclare package Medium = Medium2,
    use_T_in=true,
    m_flow=m2_flow_nominal,
    T=291.15) "Source on medium 2 side"
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));
  Modelica.Blocks.Sources.Constant
                               T2_in(k=273.15 + 15)
                   "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{58,-60},{78,-40}})));
  Buildings.Fluid.Sources.FixedBoundary           sin1(
    redeclare package Medium = Medium1,
    nPorts=1) "Sink on medium 1 side"   annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={90,48})));
  Buildings.Fluid.FixedResistances.PressureDrop           res1(
    redeclare package Medium = Medium1,
    dp_nominal=6000,
    m_flow_nominal=m1_flow_nominal)
                     "Flow resistance"
    annotation (Placement(transformation(extent={{40,38},{60,58}})));
  Buildings.Fluid.Sources.FixedBoundary           sin2(
    redeclare package Medium = Medium2,
    nPorts=1) "Sink on medium 2 side"   annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-90,-20})));
 Buildings.Fluid.FixedResistances.PressureDrop           res2(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    dp_nominal=6000)                  "Flow resistance"
    annotation (Placement(transformation(extent={{-52,-30},{-72,-10}})));
  Modelica.Blocks.Sources.Constant
                               TSet(k=273.15 + 12)
              "Set point for leaving chilled water temperature"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
equation
  connect(T1_in.y, sou1.T_in) annotation (Line(
      points={{-79,30},{-64,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T2_in.y, sou2.T_in) annotation (Line(
      points={{79,-50},{96,-50},{96,-6},{82,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(res2.port_b,sin2. ports[1]) annotation (Line(
      points={{-72,-20},{-80,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res1.port_b, sin1.ports[1])
    annotation (Line(points={{60,48},{80,48}},         color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ChillerWSE/Examples/ElectricChillerParallel.mos"
        "Simulate and Plot"));
end PartialPlantWithControl;
