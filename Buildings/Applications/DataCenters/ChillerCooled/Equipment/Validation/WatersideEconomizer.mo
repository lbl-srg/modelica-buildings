within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation;
model WatersideEconomizer
  "Validate model Buildings.Applications.DataCenters.ChillerCooled.Equipment.WatersideEconomizer"
  extends Modelica.Icons.Example;

  package MediumCHW = Buildings.Media.Water "Medium model";
  package MediumCW = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.MassFlowRate mCHW_flow_nominal=2567.1*1000/(4200*
      10) "Nominal mass flow rate at chilled water";

  parameter Modelica.Units.SI.MassFlowRate mCW_flow_nominal=2567.1*1000/(4200*
      8.5) "Nominal mass flow rate at condenser water";
  parameter Modelica.Units.SI.PressureDifference dpCHW_nominal=40000
    "Nominal pressure";
  parameter Modelica.Units.SI.PressureDifference dpCW_nominal=40000
    "Nominal pressure";
  parameter Integer numChi=1 "Number of chillers";

  Buildings.Applications.DataCenters.ChillerCooled.Equipment.WatersideEconomizer WSE(
    redeclare package Medium1 = MediumCW,
    redeclare package Medium2 = MediumCHW,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.4,
    Ti=80,
    m1_flow_nominal=mCW_flow_nominal,
    m2_flow_nominal=mCHW_flow_nominal,
    eta=0.8,
    dp1_nominal=dpCW_nominal,
    dp2_nominal=dpCHW_nominal,
    use_controller=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Waterside economizer"
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));

  Buildings.Fluid.Sources.MassFlowSource_T sou2(
    redeclare package Medium = MediumCHW,
    m_flow=mCHW_flow_nominal,
    nPorts=1,
    use_T_in=true)
    "Source on medium 2 side"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={50,-70})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = MediumCW, nPorts=1)
    "Sink on medium 1 side"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={80,-4})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    use_T_in=true,
    redeclare package Medium = MediumCW,
    m_flow=mCW_flow_nominal,
    T=298.15,
    nPorts=1)
    "Source on medium 1 side"
    annotation (Placement(transformation(extent={{-60,-14},{-40,6}})));
  Modelica.Blocks.Sources.TimeTable TCon_in(
    table=[0,273.15 + 12.78;
          7200,273.15 + 12.78;
          7200,273.15 + 18.33;
          14400,273.15 + 18.33;
          14400,273.15 + 26.67],
    offset=0,
    startTime=0)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    nPorts=1,
    redeclare package Medium = MediumCHW)
    "Sink on medium 2 side"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-80,-70})));
  Modelica.Blocks.Sources.Constant TEva_in(
    k(unit="K",
     displayUnit="degC")=273.15 + 25.28)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,-80},{80,-60}})));
  Modelica.Blocks.Sources.Constant TSet(
    k(unit="K",
     displayUnit="degC") = 273.15 + 13.56)
    "Leaving chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSup(redeclare package Medium =
        MediumCHW, m_flow_nominal=mCHW_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,-54},{-60,-34}})));
  Modelica.Blocks.Sources.BooleanStep onWSE(
    startValue=true,
    startTime=7200)
    "On and off signal for the WSE"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
equation
  connect(TSet.y, WSE.TSet)
    annotation (Line(points={{-79,30},{-79,30},{-20,30},{-20,-38},{-12,-38}},
                                color={0,0,127}));
  connect(WSE.port_b2, TSup.port_a)
    annotation (Line(points={{-10,-44},{-40,-44}}, color={0,127,255}));
  connect(WSE.port_a2, sou2.ports[1])
    annotation (Line(points={{10,-44},{20,-44},{26,-44},{26,-70},{40,-70}},
                                       color={0,127,255}));
  connect(TEva_in.y, sou2.T_in)
    annotation (Line(points={{79,-70},{68,-70},{68,-66},{62,-66}},
                                                          color={0,0,127}));
  connect(TCon_in.y,sou1. T_in)
    annotation (Line(points={{-79,0},{-62,0}},
      color={0,0,127}));
  connect(sin2.ports[1], TSup.port_b) annotation (Line(points={{-70,-70},{-64,-70},
          {-64,-44},{-60,-44}}, color={0,127,255}));
  connect(onWSE.y, WSE.on[1]) annotation (Line(points={{-79,60},{-18,60},{-18,-34},
          {-12,-34}}, color={255,0,255}));
  connect(sou1.ports[1], WSE.port_a1) annotation (Line(points={{-40,-4},{-34,-4},
          {-34,-32},{-10,-32}}, color={0,127,255}));
  connect(WSE.port_b1, sin1.ports[1]) annotation (Line(points={{10,-32},{26,-32},
          {26,-4},{70,-4}}, color={0,127,255}));
  annotation (__Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Equipment/Validation/WatersideEconomizer.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This example demonstrates that the temperature at port_b2 is controlled by setting
<code>use_controller=true</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2017, by Michael Wetter:<br/>
Corrected wrong use of replaceable model in the base class.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/921\">issue 921</a>.
</li>
<li>
July 10, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=14400,
      Tolerance=1e-06));
end WatersideEconomizer;
