within Buildings.Fluid.Air.Example;
model AirHandlingUnitMassFlow
  "Model of a air handling unit that tests variable mass flow rates"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Air.Example.BaseClasses.PartialAirHandlerMassFlow(
    sou_2(nPorts=1),
    sin_2(nPorts=1),
    sin_1(nPorts=1),
    sou_1(nPorts=1),
    relHum(k=0.5));
 Buildings.Fluid.Air.AirHandlingUnit ahu(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dat=dat)
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(
    redeclare package Medium = Medium2, m_flow_nominal=dat.nomVal.m2_flow_nominal)
    annotation (Placement(transformation(extent={{68,14},{48,34}})));
  Modelica.Blocks.Sources.Constant uWatVal(k=0.7)
    "Control signal for water valve"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));
  Modelica.Blocks.Sources.Constant uEleHea(k=0)
    "Control input for electric heater"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Modelica.Blocks.Sources.Constant uHum(k=0) "Control input for humidifer"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Modelica.Blocks.Sources.Constant uFan(k=1) "Control input for fan"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSen2(redeclare package Medium = Medium2,
      m_flow_nominal=dat.nomVal.m2_flow_nominal)
    annotation (Placement(transformation(extent={{44,14},{24,34}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSen1(redeclare package Medium = Medium1,
   m_flow_nominal=dat.nomVal.m2_flow_nominal)
    annotation (Placement(transformation(extent={{106,50},{126,70}})));
equation
  connect(ahu.port_a2, sou_2.ports[1]) annotation (Line(
      points={{100,24},{118,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ahu.port_b2, senRelHum.port_a) annotation (Line(
      points={{80,24},{68,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(uWatVal.y, ahu.uWatVal) annotation (Line(points={{61,90},{68,90},{68,34},
          {79,34}}, color={0,0,127}));
  connect(uEleHea.y, ahu.uEleHea) annotation (Line(points={{61,-20},{68,-20},{68,
          31.4},{79,31.4}}, color={0,0,127}));
  connect(uHum.y, ahu.uMasFra) annotation (Line(points={{61,-50},{66,-50},{72,-50},
          {72,29.2},{79,29.2}}, color={0,0,127}));
  connect(uFan.y, ahu.uFan) annotation (Line(points={{61,-80},{76,-80},{76,27},{
          79,27}}, color={0,0,127}));
  connect(sin_2.ports[1], temSen2.port_b)
    annotation (Line(points={{20,24},{24,24}}, color={0,127,255}));
  connect(senRelHum.port_b, temSen2.port_a)
    annotation (Line(points={{48,24},{48,24},{44,24}}, color={0,127,255}));
  connect(sin_1.ports[1], temSen1.port_b)
    annotation (Line(points={{130,60},{130,60},{126,60}}, color={0,127,255}));
  connect(temSen1.port_a, ahu.port_b1) annotation (Line(points={{106,60},{104,60},
          {104,36},{100,36}}, color={0,127,255}));
  connect(sou_1.ports[1], ahu.port_a1) annotation (Line(points={{18,62},{36,62},
          {60,62},{60,36},{80,36}}, color={0,127,255}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{200,200}})),
experiment(StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Air/Example/AirHandlingUnitMassFlow.mos"
        "Simulate and PLot"),
Documentation(info="<html>
<p>
This model demonstrates the use of
<a href=\"modelica://Buildings.Fluid.Air.AirHandlingUnit\">
Buildings.Fluid.Air.AirHandlingUnit</a>
for different inlet conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirHandlingUnitMassFlow;
