within Buildings.Fluid.SolarCollectors.Examples;
model FlatPlate "Test model for FlatPlate"
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Incompressible.Examples.Glycol47
    "Medium in the system";

  Buildings.Fluid.SolarCollectors.ASHRAE93          solCol(
    redeclare package Medium = Medium,
    shaCoe=0,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    rho=0.2,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_GuangdongFSPTY95(),
    nPanels=1,
    nSeg=9,
    lat=0.73097781993588,
    azi=0.3,
    til=0.5) "Flat plate solar collector model"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data input file"
    annotation (Placement(transformation(extent={{-32,20},{-12,40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=1,
    p(displayUnit="bar") = 100000) "Outlet for water flow"
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{32,-20},{52,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium =
    Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-32,-20},{-12,0}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    use_p_in=true,
    p(displayUnit="Pa")) "Inlet for water flow"
    annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-50,-10})));
  Modelica.Blocks.Sources.Sine sine(
    freqHz=3/86400,
    offset=100000,
    amplitude=-solCol.dp_nominal)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
equation
  connect(solCol.port_b, TOut.port_a) annotation (Line(
      points={{20,-10},{32,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, sin.ports[1]) annotation (Line(
      points={{52,-10},{60,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b, solCol.port_a) annotation (Line(
      points={{-12,-10},{0,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1], TIn.port_a) annotation (Line(
      points={{-40,-10},{-32,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-12,30},{-6,30},{-6,-0.4},{0,-0.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sine.y, sou.p_in) annotation (Line(
      points={{-79,-10},{-72,-10},{-72,-18},{-62,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
This example demonstrates the implementation of
<a href=\"modelica://Buildings.Fluid.SolarCollectors.ASHRAE93\">
Buildings.Fluid.SolarCollectors.ASHRAE93</a>.
In it water is passed through a flat plate solar thermal collector while
being heated by the sun in the San Francisco, CA, USA climate.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
September 18, 2014, by Michael Wetter:<br/>
Changed medium from water to glycol.
</li>
<li>
Mar 27, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/FlatPlate.mos"
        "Simulate and Plot"),
 experiment(StopTime=86400.0));
end FlatPlate;
