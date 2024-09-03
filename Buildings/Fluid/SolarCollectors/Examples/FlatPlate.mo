within Buildings.Fluid.SolarCollectors.Examples;
model FlatPlate "Test model for FlatPlate"
  extends Modelica.Icons.Example;
  replaceable package Medium = Modelica.Media.Incompressible.Examples.Glycol47
    "Medium in the system";

  Buildings.Fluid.SolarCollectors.ASHRAE93 solCol(
    redeclare package Medium = Medium,
    shaCoe=0,
    rho=0.2,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Array,
    nPanelsSer=5,
    nPanelsPar=5,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_GuangdongFSPTY95(),
    nPanels=25,
    nSeg=9,
    azi=0.3,
    til=0.5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
    "Flat plate solar collector model"
    annotation (Placement(transformation(extent={{2,-10},{22,10}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data input file"
    annotation (Placement(transformation(extent={{-28,60},{-8,80}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="bar") = 100000,
    nPorts=1) "Outlet for water flow"
    annotation (Placement(transformation(extent={{82,-10},{62,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium =
    Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    nPorts=1,
    use_p_in=true) "Inlet for water flow"
    annotation (Placement(
      transformation(
      extent={{10,-10},{-10,10}},
      rotation=180,
      origin={-48,0})));
  Modelica.Blocks.Sources.Sine sine(
    f=3/86400,
    amplitude=-solCol.dp_nominal,
    offset=1E5) "Pressure source"
    annotation (Placement(transformation(extent={{-88,-18},{-68,2}})));
equation
  connect(solCol.port_b, TOut.port_a) annotation (Line(
      points={{22,0},{32,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1], TIn.port_a) annotation (Line(
      points={{-38,0},{-28,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-8,70},{2,70},{2,8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(TIn.port_b, solCol.port_a)
    annotation (Line(points={{-8,0},{2,0}},               color={0,127,255}));
  connect(TOut.port_b, sin.ports[1])
    annotation (Line(points={{52,0},{62,0}},              color={0,127,255}));
  connect(sine.y, sou.p_in) annotation (Line(points={{-67,-8},{-60,-8}},
                           color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
This example demonstrates the implementation of
<a href=\"modelica://Buildings.Fluid.SolarCollectors.ASHRAE93\">
Buildings.Fluid.SolarCollectors.ASHRAE93</a>
for a variable fluid flow rate and weather data from San Francisco, CA, USA.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 15, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter assignment for <code>lat</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
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
        "Simulate and plot"),
 experiment(Tolerance=1e-6, StopTime=86400.0));
end FlatPlate;
