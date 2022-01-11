within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation;
model HeatExchanger_ResetController
  "Model that demonstrates use of a waterside economizer with outlet temperature control and temperature controller is reset after a predefined time period"
  extends Modelica.Icons.Example;

  package MediumW = Buildings.Media.Water "Medium model";
  parameter Modelica.Units.SI.MassFlowRate m1_flow_nominal=1000*0.01035
    "Nominal mass flow rate at evaporator";
  parameter Modelica.Units.SI.MassFlowRate m2_flow_nominal=1000*0.01035
    "Nominal mass flow rate at condenser";
  parameter Modelica.Units.SI.Pressure dp1_nominal=60000
    "Nominal pressure difference on medium 1 side";
  parameter Modelica.Units.SI.Pressure dp2_nominal=60000
    "Nominal pressure difference on medium 2 side";
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.HeatExchanger_TSet hex1(
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
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    reset=Buildings.Types.Reset.Parameter,
    y_reset=0)
    "Water-to-water heat exchanger with built-in PID controller to control the temperature at port_b2"
    annotation (Placement(transformation(extent={{-12,48},{8,64}})));

  Buildings.Fluid.Sources.Boundary_pT sin1(
     nPorts=3,
     redeclare package Medium = MediumW)
     "Sink on medium 1 side"
     annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={78,70})));
  Fluid.Sources.Boundary_pT sou1(
    p=MediumW.p_default + 60E3,
    use_T_in=true,
    nPorts=3,
    redeclare package Medium = MediumW,
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
  Buildings.Fluid.Sources.Boundary_pT sin2(
     nPorts=3,
     redeclare package Medium = MediumW)
     "Sink on medium 2 side"
     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-82,-42})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSen1(
    m_flow_nominal=m2_flow_nominal,
    redeclare package Medium = MediumW)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,-32},{-60,-12}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSen2(
    redeclare package Medium = MediumW,
    m_flow_nominal=m2_flow_nominal)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Constant TSet(
    k(unit="K",displayUnit="degC")=273.15+16.56)
    "Leaving chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-90,40},{-70,60}})));
  Fluid.Sources.Boundary_pT sou2_1(
    p=MediumW.p_default + 50E3,
    nPorts=3,
    redeclare package Medium = MediumW,
    use_T_in=true)
    "Source on medium 2 side"
    annotation (Placement(transformation(extent={{60,14},{40,34}})));
  Modelica.Blocks.Sources.Constant TEva_in(k=273.15 + 25.28)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{100,18},{80,38}})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.HeatExchanger_TSet hex2(
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
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    reset=Buildings.Types.Reset.Input)
    "Water-to-water heat exchanger with built-in PID controller to control the temperature at port_b2"
    annotation (Placement(transformation(extent={{-12,-72},{8,-56}})));
  Modelica.Blocks.Sources.BooleanPulse tri(period=900)
    "Trigger controller reset"
    annotation (Placement(transformation(extent={{-90,0},{-70,20}})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.HeatExchanger_TSet hex3(
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
    annotation (Placement(transformation(extent={{-10,-158},{10,-142}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TSen3(redeclare package Medium =
        MediumW, m_flow_nominal=m2_flow_nominal)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,-166},{-50,-146}})));
  Modelica.Blocks.Sources.Constant yRes(k=0) "Reset integrator signal"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
equation
  connect(TSet.y, hex1.TSet) annotation (Line(points={{-69,50},{-62,50},{-62,60},
          {-14,60}}, color={0,0,127}));
  connect(sou1.ports[1], hex1.port_a1) annotation (Line(points={{-40,78.6667},{
          -20,78.6667},{-20,62},{-12,62}},
                                  color={0,127,255}));
  connect(hex1.port_b1, sin1.ports[1]) annotation (Line(points={{8,62},{18,62},
          {18,72.6667},{68,72.6667}},
                            color={0,127,255}));
  connect(TCon_in.y,sou1. T_in)
    annotation (Line(points={{-69,80},{-69,80},{-62,80}},
      color={0,0,127}));
  connect(hex1.port_b2, TSen1.port_a) annotation (Line(points={{-12,50},{-30,50},
          {-30,-22},{-40,-22}},        color={0,127,255}));
  connect(TSen1.port_b, sin2.ports[1])
    annotation (Line(points={{-60,-22},{-70,-22},{-70,-39.3333},{-72,-39.3333}},
      color={0,127,255}));
  connect(TSen2.port_b, sin2.ports[2])
    annotation (Line(points={{-60,-70},{-68,-70},{-68,-42},{-72,-42}},
      color={0,127,255}));
  connect(hex1.port_a2, sou2_1.ports[1]) annotation (Line(points={{8,50},{28,50},
          {28,26.6667},{40,26.6667}},
                                    color={0,127,255}));
  connect(TEva_in.y, sou2_1.T_in)
    annotation (Line(points={{79,28},{62,28}}, color={0,0,127}));
  connect(TSen2.port_a, hex2.port_b2)
    annotation (Line(points={{-40,-70},{-12,-70}}, color={0,127,255}));
  connect(sou1.ports[2], hex2.port_a1) annotation (Line(points={{-40,76},{-22,
          76},{-22,-58},{-12,-58}},
                                color={0,127,255}));
  connect(hex2.port_b1, sin1.ports[2]) annotation (Line(points={{8,-58},{20,-58},
          {20,70},{68,70}}, color={0,127,255}));
  connect(TSet.y, hex2.TSet) annotation (Line(points={{-69,50},{-62,50},{-62,60},
          {-20,60},{-20,-60},{-14,-60}}, color={0,0,127}));
  connect(tri.y, hex1.trigger)
    annotation (Line(points={{-69,10},{-8,10},{-8,46}}, color={255,0,255}));
  connect(sou2_1.ports[2], hex2.port_a2) annotation (Line(points={{40,24},{28,
          24},{28,-70},{8,-70}},
                             color={0,127,255}));
  connect(sin2.ports[3], TSen3.port_b) annotation (Line(points={{-72,-44.6667},
          {-66,-44.6667},{-66,-156},{-50,-156}},color={0,127,255}));
  connect(TSen3.port_a, hex3.port_b2)
    annotation (Line(points={{-30,-156},{-10,-156}}, color={0,127,255}));
  connect(hex3.port_a1, sou1.ports[3]) annotation (Line(points={{-10,-144},{-24,
          -144},{-24,73.3333},{-40,73.3333}}, color={0,127,255}));
  connect(hex3.port_b1, sin1.ports[3]) annotation (Line(points={{10,-144},{22,
          -144},{22,67.3333},{68,67.3333}},
                                      color={0,127,255}));
  connect(hex3.port_a2, sou2_1.ports[3]) annotation (Line(points={{10,-156},{30,
          -156},{30,21.3333},{40,21.3333}}, color={0,127,255}));
  connect(TSet.y, hex3.TSet) annotation (Line(points={{-69,50},{-62,50},{-62,60},
          {-20,60},{-20,-146},{-12,-146}}, color={0,0,127}));
  connect(tri.y, hex2.trigger) annotation (Line(points={{-69,10},{-34,10},{-34,-86},
          {-8,-86},{-8,-74}}, color={255,0,255}));
  connect(yRes.y, hex2.y_reset_in) annotation (Line(points={{-79,-120},{-12,-120},
          {-12,-74}}, color={0,0,127}));
  annotation (__Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Applications/DataCenters/ChillerCooled/Equipment/Validation/HeatExchanger_ResetController.mos"
        "Simulate and Plot"),
Documentation(info="<html>
<p>
This example demonstrates how the PID controller in the heat exchanger model can be reset. We compared three options:
(1) reset with a paramter value; (2) reset with an input signal; (3) without reset.
</p>
</html>", revisions="<html>
<ul>
<li>
May 13, 2021, by Michael Wetter:<br/>
Changed boundary condition model to prescribed pressure rather than prescribed mass flow rate.
Prescribing the mass flow rate caused
unreasonably large pressure drop because the mass flow rate was forced through a closed valve.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2488\">#2488</a>.
</li>
<li>
January 28, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"),
experiment(
      StartTime=0,
      StopTime=3600,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-100,-200},{100,100}})));
end HeatExchanger_ResetController;
