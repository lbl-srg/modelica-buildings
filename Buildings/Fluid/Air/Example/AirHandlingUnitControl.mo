within Buildings.Fluid.Air.Example;
model AirHandlingUnitControl
  "Model of a air handling unit that tests temperature and humidity control"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Air.Example.BaseClasses.PartialAirHandlerControl(sou_1(
        nPorts=1, p(displayUnit="Pa")), sou_2(nPorts=1),
        masFra(redeclare package Medium = Medium2),
    TSet(table=[0,288.15 + 1; 600,288.15 + 1; 600,288.15 + 1; 1200,288.15 + 1; 1800,
          288.15 + 1; 2400,288.15 + 1; 2400,288.15 + 1]),
    const(k=0.5));
  Buildings.Fluid.Air.AirHandlingUnit ahu(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    allowFlowReversal1=true,
    allowFlowReversal2=true,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dat=dat)
    annotation (Placement(transformation(extent={{46,20},{66,40}})));
  Buildings.Fluid.Air.Example.BaseClasses.TemperatureControl TCon(
    controllerType1=Modelica.Blocks.Types.SimpleController.PI,
    reverseAction=true,
    Ti2=60,
    Ti1=120,
    k1=0.1,
    k2=0.2,
    yMin1=0.9,
    controllerType2=Modelica.Blocks.Types.SimpleController.PI)
    "Temperature controller"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Modelica.Blocks.Sources.Constant uFan(k=1) "Control input for fan"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Modelica.Blocks.Continuous.LimPID masFraCon(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=1,
    yMin=0)
    "Mass fraction controller"
    annotation (Placement(transformation(extent={{0,-60},{20,-80}})));
  Modelica.Blocks.Sources.TimeTable masFraSet(table=[0,0.009; 600,0.009; 600,0.009;
        1200,0.009; 1800,0.009; 2400,0.009; 2400,0.009])
    "Setpoint mass fraction"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
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
    annotation (Line(points={{-21,90},{-1.66667,90}},    color={0,0,127}));
  connect(temSen.T, TCon.T_m) annotation (Line(points={{0,21},{0,21},{0,66},{8.33333,
          66},{8.33333,78}},
                        color={0,0,127}));
  connect(TCon.yEleHea, ahu.uEleHea) annotation (Line(points={{20.8333,86},{30,
          86},{30,31.4},{45,31.4}},
                            color={0,0,127}));
  connect(TCon.yVal, ahu.uWatVal) annotation (Line(points={{20.8333,93},{32,93},
          {32,34},{45,34}},
                    color={0,0,127}));
  connect(uFan.y, ahu.uFan) annotation (Line(points={{21,-30},{30,-30},{30,27},{
          45,27}}, color={0,0,127}));
  connect(masFra.X, masFraCon.u_m) annotation (Line(points={{-36,21},{-36,28},{-20,
          28},{-20,-50},{10,-50},{10,-58}}, color={0,0,127}));
  connect(masFraSet.y, masFraCon.u_s)
    annotation (Line(points={{-19,-70},{-10,-70},{-2,-70}}, color={0,0,127}));
  connect(masFraCon.y, ahu.uMasFra) annotation (Line(points={{21,-70},{32,-70},{
          32,30},{38,30},{38,29.2},{45,29.2}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-120,-100},
            {220,160}})),
experiment(StopTime=3600),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Air/Example/AirHandlingUnitControl.mos"
        "Simulate and PLot"),
Documentation(info="<html>
<p>
This model demonstrates the use of
<a href=\"modelica://Buildings.Fluid.Air.AirHandlingUnit\">
Buildings.Fluid.Air.AirHandlingUnit</a>. The valve on the water-side and 
the electric heater on the air-side is regulated to track a setpoint temperature
for the air outlet. The humidifier on the air-side is manipulated to control the humidity 
of the air outlet.
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end AirHandlingUnitControl;
