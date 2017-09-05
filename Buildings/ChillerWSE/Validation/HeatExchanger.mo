within Buildings.ChillerWSE.Validation;
model HeatExchanger
  "Model that demonstrates use of a waterside economizer with outlet temperature control"
  extends Modelica.Icons.Example;

  package MediumW = Buildings.Media.Water "Medium model";
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=1000 * 0.01035
    "Nominal mass flow rate at evaporator";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=1000 * 0.01035
    "Nominal mass flow rate at condenser";
  parameter Modelica.SIunits.Pressure dp1_nominal=60000
    "Nominal pressure difference on medium 1 side";
  parameter Modelica.SIunits.Pressure dp2_nominal=60000
    "Nominal pressure difference on medium 2 side";
  Buildings.ChillerWSE.HeatExchanger hx1(
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    eta=0.8,
    dp1_nominal=dp1_nominal,
    dp2_nominal=dp2_nominal,
    T_start=273.15 + 10,
    use_controller=true,
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    Ti=40,
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Water-to-water heat exchanger with built-in PID controller to control the temperature at port_b2"
    annotation (Placement(transformation(extent={{-12,48},{8,64}})));

  Buildings.ChillerWSE.HeatExchanger hx2(
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    eta=0.8,
    dp1_nominal=dp1_nominal,
    dp2_nominal=dp2_nominal,
    T_start=273.15 + 10,
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumW,
    use_controller=false)
    "Water-to-water heat exchanger without built-in controllers to control the temperature at port_b2"
    annotation (Placement(transformation(extent={{-12,-30},{8,-14}})));
  Buildings.Fluid.Sources.FixedBoundary sin1(
     nPorts=2,
     redeclare package Medium = MediumW)
     "Sink on medium 1 side"
     annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={90,72})));
  Buildings.Fluid.Sources.MassFlowSource_T sou1(
    use_T_in=true,
    nPorts=2,
    redeclare package Medium = MediumW,
    m_flow=2*m1_flow_nominal,
    T=298.15)
    "Source on medium 1 side"
    annotation (Placement(transformation(extent={{-60,66},{-40,86}})));
  Modelica.Blocks.Sources.TimeTable TCon_in(
    table=[0,273.15 + 12.78;
           7200,273.15 + 12.78;
           7200,273.15 + 18.33;
           14400,273.15 + 18.33;
           14400,273.15 + 26.67],
    offset=0,
    startTime=0)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Fluid.Sources.FixedBoundary sin2(
     nPorts=2,
     redeclare package Medium = MediumW)
     "Sink on medium 2 side"
     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-90,-70})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2_2(
    nPorts=1,
    redeclare package Medium = MediumW,
    m_flow=m2_flow_nominal,
    use_T_in=true)
    "Source on medium 2 side"
    annotation (Placement(transformation(extent={{58,-84},{38,-64}})));
  Modelica.Blocks.Sources.Constant TEva_in(k=273.15 + 25.28)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,-80},{80,-60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSen1(
    m_flow_nominal=m2_flow_nominal,
    redeclare package Medium = MediumW)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,10},{-60,30}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSen2(
    redeclare package Medium = MediumW,
    m_flow_nominal=m2_flow_nominal)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,-38},{-60,-18}})));
  Modelica.Blocks.Sources.Constant TSet(
    k(unit="K",displayUnit="degC")=273.15+16.56)
    "Leaving chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou2_1(
    nPorts=1,
    redeclare package Medium = MediumW,
    m_flow=m2_flow_nominal,
    use_T_in=true)
    "Source on medium 2 side"
    annotation (Placement(transformation(extent={{54,14},{34,34}})));
  Modelica.Blocks.Sources.Constant TEva_in1( k=273.15 + 25.28)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{96,18},{76,38}})));
equation
  connect(TSet.y, hx1.TSet)
    annotation (Line(points={{-69,50},{-62,50},{-62,60},{-14,60}},
                 color={0,0,127}));
  connect(sou1.ports[1], hx1.port_a1)
    annotation (Line(points={{-40,78},{-20,78},
      {-20,62},{-12,62}}, color={0,127,255}));
  connect(hx1.port_b1, sin1.ports[1])
    annotation (Line(points={{8,62},{60,62},{60,74},{80,74}},
      color={0,127,255}));
  connect(TCon_in.y,sou1. T_in)
    annotation (Line(points={{-69,80},{-69,80},{-62,80}},
      color={0,0,127}));
  connect(sou2_2.T_in, TEva_in.y)
    annotation (Line(points={{60,-70},{79,-70}}, color={0,0,127}));
  connect(hx1.port_b2, TSen1.port_a)
    annotation (Line(points={{-12,50},{-22,50},{-30,50},{-30,20},{-40,20}},
                                   color={0,127,255}));
  connect(TSen1.port_b, sin2.ports[1])
    annotation (Line(points={{-60,20},{-70,20},{-70,-68},{-80,-68}},
      color={0,127,255}));
  connect(sou1.ports[2], hx2.port_a1)
    annotation (Line(points={{-40,74},{-22,74},{-22,74},{-22,-16},{-12,-16}},
      color={0,127,255}));
  connect(hx2.port_b2, TSen2.port_a)
    annotation (Line(points={{-12,-28},{-40,-28}}, color={0,127,255}));
  connect(TSen2.port_b, sin2.ports[2])
    annotation (Line(points={{-60,-28},{-68,-28},{-68,-72},{-80,-72}},
      color={0,127,255}));
  connect(hx2.port_b1, sin1.ports[2])
    annotation (Line(points={{8,-16},{30,-16},{60,-16},{60,70},{80,70}},
      color={0,127,255}));
  connect(hx2.port_a2, sou2_2.ports[1])
    annotation (Line(points={{8,-28},{20,-28},{20,-74},{38,-74}},
      color={0,127,255}));
  connect(hx1.port_a2, sou2_1.ports[1])
    annotation (Line(points={{8,50},{18,50},{28,50},{28,24},{34,24}},
      color={0,127,255}));
  connect(TEva_in1.y, sou2_1.T_in)
    annotation (Line(points={{75,28},{56,28}}, color={0,0,127}));
  annotation (
__Dymola_Commands(file="Resources/Scripts/Dymola/ChillerWSE/Validation/HeatExchanger.mos"
        "Simulate and Plot"),
Documentation(info="<html>
<p>
This example demonstrates how the parameter <code>use_controller</code> influences
the temperautre at <code>port_b2</code>. The temperature at <code>port_b2</code> 
can be controlled in <code>hex1</code> where the controller is activated.
</p>
</html>", revisions="<html>
<ul>
<li>
July 22, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=3600,
      Tolerance=1e-06));
end HeatExchanger;
