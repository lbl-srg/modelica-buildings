within Buildings.Fluid.Sensors.Examples;
model TemperatureDryBulb "Test model for the dry bulb temperature sensor"
  extends Modelica.Icons.Example;

 package Medium = Buildings.Media.PerfectGases.MoistAirUnsaturated
    "Medium model";
  Buildings.Fluid.Sources.Boundary_pT amb(
    redeclare package Medium = Medium,
    T=298.15,
    nPorts=1)
    "Ambient conditions, used to test the relative temperature sensor"
     annotation (Placement(
        transformation(extent={{10,-10},{-10,10}},
                                                 rotation=180,
        origin={-2,-40})));
  Buildings.Fluid.Sources.MassFlowSource_T masFloRat(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) "Flow boundary condition"  annotation (Placement(transformation(
          extent={{-36,-2},{-16,18}}, rotation=0)));
  Modelica.Blocks.Sources.Ramp TDryBul(
    height=10,
    duration=1,
    offset=273.15 + 30) "Dry bulb temperature"
                 annotation (Placement(transformation(extent={{-100,20},{-80,40}},
          rotation=0)));
  Modelica.Blocks.Sources.Ramp XHum(
    height=(0.0133 - 0.0175),
    offset=0.0175,
    duration=60) "Humidity concentration"
                 annotation (Placement(transformation(extent={{-100,-60},{-80,
            -40}}, rotation=0)));
  Modelica.Blocks.Sources.Constant const(k=1)
   annotation (Placement(transformation(
          extent={{-100,-20},{-80,0}}, rotation=0)));
  Modelica.Blocks.Math.Feedback dif
    "Difference, used to compute the mass fraction of dry air"
    annotation (Placement(transformation(
          extent={{-70,-20},{-50,0}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort temSteSta(
   redeclare package Medium = Medium,
   m_flow_nominal=2,
   tau=0) "Steady state temperature sensor"
    annotation (Placement(transformation(extent={{0,-2},{20,18}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
    Modelica.Blocks.Sources.Pulse m_flow(
    offset=-1,
    amplitude=2,
    period=30) "Mass flow rate"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}},
          rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort temDyn(
    redeclare package Medium = Medium,
    m_flow_nominal=2,
    initType=Modelica.Blocks.Types.Init.InitialState,
    T_start=293.15) "Dynamic temperature sensor"
    annotation (Placement(transformation(extent={{30,-2},{50,18}})));
  RelativeTemperature senRelTem(redeclare package Medium = Medium)
    "Temperature difference sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={38,-40})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=2,
    T=293.15) "Flow boundary condition"
     annotation (Placement(
        transformation(extent={{88,-4},{68,16}}, rotation=0)));
equation
  connect(TDryBul.y, masFloRat.T_in)    annotation (Line(points={{-79,30},{-60,30},
          {-60,12},{-38,12}}, color={0,0,127}));
  connect(const.y, dif.u1)      annotation (Line(points={{-79,-10},{-68,-10}},
        color={0,0,127}));
  connect(XHum.y, dif.u2)      annotation (Line(points={{-79,-50},{-60,-50},{
          -60,-18}}, color={0,0,127}));
  connect(XHum.y, masFloRat.X_in[1])    annotation (Line(points={{-79,-50},{-40,
          -50},{-40,4},{-38,4}},         color={0,0,127}));
  connect(dif.y, masFloRat.X_in[2])         annotation (Line(points={{-51,-10},
          {-44,-10},{-44,4},{-38,4}},         color={0,0,127}));
  connect(masFloRat.ports[1], temSteSta.port_a) annotation (Line(
      points={{-16,8},{-5.55112e-16,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(m_flow.y, masFloRat.m_flow_in) annotation (Line(
      points={{-79,70},{-58,70},{-58,16},{-36,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(temSteSta.port_b, temDyn.port_a) annotation (Line(
      points={{20,8},{30,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(temDyn.port_b, sin.ports[1]) annotation (Line(
      points={{50,8},{68,8}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(amb.ports[1], senRelTem.port_a) annotation (Line(
      points={{8,-40},{28,-40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelTem.port_b, sin.ports[2]) annotation (Line(
      points={{48,-40},{62,-40},{62,4},{68,4}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                        graphics),
experiment(StopTime=60),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/TemperatureDryBulb.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the dry bulb temperature sensors.
One sensor is configured to be a steady-state model,
and the other sensor is configured to be a dynamic sensor.
</p>
</html>", revisions="<html>
<ul>
<li>
September 10, 2008 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end TemperatureDryBulb;
