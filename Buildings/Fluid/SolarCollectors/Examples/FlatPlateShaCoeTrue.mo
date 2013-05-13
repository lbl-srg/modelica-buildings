within Buildings.Fluid.SolarCollectors.Examples;
model FlatPlateShaCoeTrue "Test model for FlatPlate with use_shaCoe_in = true"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater
    "Medium in the system";
  Buildings.Fluid.SolarCollectors.FlatPlate         solCol(
    redeclare package Medium = Medium,
    nSeg=3,
    shaCoe=0,
    G_nominal=800,
    from_dp=true,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.SRCC2001002B(),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    lat=0.73097781993588,
    azi=0.3,
    til=0.5,
    TEnv_nominal=283.15,
    TIn_nominal=293.15,
    use_shaCoe_in=true) "Flat plate solar collector model"
             annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data input file"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Outlet for water flow" annotation (Placement(transformation(extent={{80,-20},{60,0}},
          rotation=0)));
  inner Modelica.Fluid.System system(p_ambient=101325) annotation (Placement(
        transformation(extent={{60,60},{80,80}}, rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium =
        Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    use_p_in=false,
    nPorts=1,
    p(displayUnit="Pa") = 101325 + solCol.dp_nominal) "Inlet for water flow"   annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-90,-10})));
  Modelica.Blocks.Sources.Ramp     shaCoe(
    startTime=34040,
    height=1,
    duration=24193)
    annotation (Placement(transformation(extent={{-88,6},{-68,26}})));
equation
  connect(solCol.port_b, TOut.port_a) annotation (Line(
      points={{0,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, sin.ports[1]) annotation (Line(
      points={{40,-10},{60,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b, solCol.port_a) annotation (Line(
      points={{-40,-10},{-20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1], TIn.port_a) annotation (Line(
      points={{-80,-10},{-60,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-20,30},{-7.4,30},{-7.4,0}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(shaCoe.y, solCol.shaCoe_in) annotation (Line(
      points={{-67,16},{-32,16},{-32,-6},{-22,-6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This example demonstrates the use of <code>use_shaCoe_in</code>. Aside from changed use of <code>use_shaCoe_in</code> it is identical to
 <a href=\"modelica://Buildings.Fluid.SolarCollectors.Examples.FlatPlate\"> Buildings.Fluid.SolarCollectors.Examples.FlatPlate</a>.
</p>
</html>",revisions="<html>
<ul>
<li>
May 13, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/FlatPlateShaCoeTrue.mos"
        "Simulate and Plot"),
    Icon(graphics));
end FlatPlateShaCoeTrue;
