within Buildings.Fluid.Air.Example;
model AirHandlingUnitControl
  "Model of a air handling unit that tests temperature and humidity control"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Air.Example.BaseClasses.PartialAirHandlerControl(sou_1(
        nPorts=1, p(displayUnit="Pa")), sou_2(nPorts=1),
    massFraction(redeclare package Medium = Medium2),
    TSet(table=[0,288.15+4; 600,288.15+4;  600,288.15+4;  1200,288.15+4;  1800,
          288.15+4;  2400,288.15+4;  2400,288.15+4]),
    TWat(height=5, startTime=4000));

  AirHandlingUnit ahu(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dat=dat)
    annotation (Placement(transformation(extent={{46,20},{66,40}})));
  Buildings.Fluid.Air.BaseClasses.TemperatureControl TCon(
    controllerType1=Modelica.Blocks.Types.SimpleController.PI,
    yMin1=0.3,
    reverseAction=true,
    controllerType2=Modelica.Blocks.Types.SimpleController.PI,
    Ti2=60,
    k1=0.1,
    Ti1=60)
    "Temperature controller"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Sources.Constant uFan(k=1) "Control input for fan"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Continuous.LimPID masFraCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    yMin=0)                                   "Mass fraction controller"
    annotation (Placement(transformation(extent={{0,-60},{20,-80}})));
  Modelica.Blocks.Sources.TimeTable masFraSet(table=[0,288.15; 600,288.15; 600,298.15;
        1200,298.15; 1800,283.15; 2400,283.15; 2400,288.15])
    "Setpoint mass fraction"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Sources.Constant uHum(k=0) "Control input for fan"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
equation
  connect(sou_1.ports[1], ahu.port_a1) annotation (Line(points={{-22,50},{20,50},
          {20,36},{46,36}}, color={0,127,255}));
  connect(ahu.port_b1, res_1.port_a) annotation (Line(points={{66,36},{80,36},{80,
          50},{88,50}}, color={0,127,255}));
  connect(temSen.port_a, ahu.port_b2) annotation (Line(points={{10,10},{20,10},{
          20,24},{46,24}}, color={0,127,255}));
  connect(ahu.port_a2, sou_2.ports[1]) annotation (Line(points={{66,24},{80,24},
          {80,10},{118,10}}, color={0,127,255}));
  connect(TSet.y, TCon.T_s)
    annotation (Line(points={{-21,90},{-10,90},{-2,90}}, color={0,0,127}));
  connect(temSen.T, TCon.T_m) annotation (Line(points={{0,21},{0,21},{0,66},{10,
          66},{10,78}}, color={0,0,127}));
  connect(TCon.yEleHea, ahu.uEleHea) annotation (Line(points={{21,87},{30,87},{30,
          31.4},{45,31.4}}, color={0,0,127}));
  connect(TCon.yVal, ahu.uWatVal) annotation (Line(points={{21,93},{32,93},{32,34},
          {45,34}}, color={0,0,127}));
  connect(uFan.y, ahu.uFan) annotation (Line(points={{21,-30},{30,-30},{30,27},{
          45,27}}, color={0,0,127}));
  connect(massFraction.X, masFraCon.u_m) annotation (Line(points={{-36,21},{-36,
          28},{-20,28},{-20,-50},{10,-50},{10,-58}}, color={0,0,127}));
  connect(masFraSet.y, masFraCon.u_s)
    annotation (Line(points={{-19,-70},{-10,-70},{-2,-70}}, color={0,0,127}));
  connect(uHum.y, ahu.uMasFra) annotation (Line(points={{61,-50},{64,-50},{64,10},
          {36,10},{36,29.2},{45,29.2}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-120,-100},
            {220,160}})),
experiment(StopTime=3600),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Air/Example/AirHandlingUnitControl.mos"
        "Simulate and PLot"),
Documentation(info="<html>
<p>
This model demonstrates the use of
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a>
for different inlet conditions.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
May 27, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirHandlingUnitControl;
