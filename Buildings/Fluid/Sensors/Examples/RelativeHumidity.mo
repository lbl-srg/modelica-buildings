within Buildings.Fluid.Sensors.Examples;
model RelativeHumidity "Test model for relative humidity sensor"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model"
           annotation (choicesAllMatching = true);

  Buildings.Fluid.Sources.Boundary_pT sin(
   redeclare package Medium = Medium,
    use_p_in=false,
    T=293.15,
    nPorts=1)
     annotation (Placement(
        transformation(extent={{80,10},{60,30}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    m_flow=1,
    use_T_in=true,
    use_X_in=true,
    use_m_flow_in=true,
    nPorts=2) "Flow boundary condition"  annotation (Placement(transformation(
          extent={{-30,12},{-10,32}})));
  Modelica.Blocks.Sources.Ramp TDryBul(
    height=10,
    offset=273.15 + 30,
    duration=120) "Dry bulb temperature"
                 annotation (Placement(transformation(extent={{-100,14},{-80,34}})));
  Modelica.Blocks.Sources.Ramp XHum(
    duration=1,
    height=(0.0133 - 0.0175),
    offset=0.0175) "Humidity concentration"
                 annotation (Placement(transformation(extent={{-100,-60},{-80,
            -40}})));
  Modelica.Blocks.Sources.Constant const(k=1) "Constant"
                                         annotation (Placement(transformation(
          extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Math.Feedback dif
    "Difference, used to compute the mass fraction of dry air"
    annotation (Placement(transformation(
          extent={{-68,-20},{-48,0}})));

  Buildings.Fluid.Sensors.RelativeHumidity senRelHum(
    redeclare package Medium = Medium)
    "Relative humidity of the flow source if the medium were outflowing"
                annotation (Placement(transformation(extent={{-16,42},{4,62}})));
    Modelica.Blocks.Sources.Ramp m_flow(
    height=-2,
    offset=1,
    duration=500) "Mass flow rate"
                 annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort relHum(
    redeclare package Medium = Medium, m_flow_nominal=1,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Relative humidity of the passing fluid"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
equation
  connect(TDryBul.y, sou.T_in)          annotation (Line(points={{-79,24},{-32,24},
          {-32,26}},          color={0,0,127}));
  connect(const.y, dif.u1)      annotation (Line(points={{-79,-10},{-66,-10}},
        color={0,0,127}));
  connect(XHum.y, dif.u2)      annotation (Line(points={{-79,-50},{-58,-50},{
          -58,-18}}, color={0,0,127}));
  connect(XHum.y, sou.X_in[1])          annotation (Line(points={{-79,-50},{-40,
          -50},{-40,18},{-32,18}},       color={0,0,127}));
  connect(dif.y, sou.X_in[2])               annotation (Line(points={{-49,-10},
          {-40,-10},{-40,18},{-32,18}},       color={0,0,127}));
  connect(m_flow.y, sou.m_flow_in)          annotation (Line(
      points={{-59,50},{-46,50},{-46,30},{-30,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(relHum.port_b, sin.ports[1]) annotation (Line(
      points={{40,20},{60,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senRelHum.port, sou.ports[1]) annotation (Line(
      points={{-6,42},{-6,24},{-10,24}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], relHum.port_a) annotation (Line(
      points={{-10,20},{20,20}},
      color={0,127,255},
      smooth=Smooth.None));
    annotation (experiment(StopTime=600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Sensors/Examples/RelativeHumidity.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests the relative humidity sensors.
Note that the sensor with one port always measures the humidity
as if the flow would be leaving the source.
</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2010 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RelativeHumidity;
