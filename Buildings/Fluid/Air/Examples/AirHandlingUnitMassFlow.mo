within Buildings.Fluid.Air.Examples;
model AirHandlingUnitMassFlow
  "Model of a air handling unit that tests variable mass flow rates"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Air.Examples.BaseClasses.PartialAirHandlerMassFlow(
      sou_2(nPorts=1), relHum(k=0.5));
  Buildings.Fluid.Air.AirHandlingUnit ahu(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dat=dat,
    addPowerToMedium=false,
    yValve_start=0,
    tauEleHea=1,
    tauHum=1,
    y1Low=0,
    y1Hig=0.02,
    y2Hig=0.1,
    y2Low(displayUnit="degC") = -0.1) "Air handling unit"
    annotation (Placement(transformation(extent={{54,16},{74,36}})));

  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(
    redeclare package Medium = Medium2, m_flow_nominal=dat.nomVal.m2_flow_nominal)
    "Sensor for relative humidity"
    annotation (Placement(transformation(extent={{34,10},{14,30}})));
  Modelica.Blocks.Sources.Constant uWatVal(k=0.2)
    "Control signal for water valve"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Sources.Constant temSet(k=15 + 273.15)
    "Temperature setpoint "
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Modelica.Blocks.Sources.Constant XSet(k=0.01) "Mass fraction set point"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Modelica.Blocks.Sources.Constant uFan(k=1) "Control input for fan"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
equation
  connect(ahu.port_a2, sou_2.ports[1]) annotation (Line(
      points={{74,20},{120,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(ahu.port_b2, senRelHum.port_a) annotation (Line(
      points={{54,20},{34,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(uWatVal.y, ahu.uWatVal) annotation (Line(points={{21,90},{46,90},{46,
          31},{53,31}},
                    color={0,0,127}));
  connect(uFan.y, ahu.uFan) annotation (Line(points={{21,-80},{48,-80},{48,16},
          {48,23},{50,23},{53,23}},
                   color={0,0,127}));
  connect(temSet.y, ahu.TSet) annotation (Line(points={{21,-20},{40,-20},{40,26},
          {53,26}}, color={0,0,127}));
  connect(XSet.y, ahu.XSet_w) annotation (Line(points={{21,-50},{44,-50},{44,26},
          {44,28},{44,28.6},{48,28.6},{53,28.6}},         color={0,0,127}));
  connect(temSenAir2.port_a, senRelHum.port_b)
    annotation (Line(points={{0,20},{14,20}}, color={0,127,255}));
  connect(temSenWat1.port_b, ahu.port_a1) annotation (Line(points={{0,60},{20,
          60},{40,60},{40,32},{54,32}}, color={0,127,255}));
  connect(temSenWat2.port_a, ahu.port_b1) annotation (Line(points={{88,60},{80,
          60},{80,32},{74,32}}, color={0,127,255}));
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
