within Buildings.Obsolete.Fluid.SolarCollectors.Examples;
model Tubular "Example showing the use of Tubular"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium in the system";
  Buildings.Obsolete.Fluid.SolarCollectors.ASHRAE93 solCol(
    redeclare package Medium = Medium,
    shaCoe=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_shaCoe_in=false,
    per=Buildings.Obsolete.Fluid.SolarCollectors.Data.Tubular.T_AMKCollectraAGOWR20(),
    nPanels=10,
    sysConfig=Buildings.Obsolete.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel,
    nColType=Buildings.Obsolete.Fluid.SolarCollectors.Types.NumberSelection.Number,
    rho=0.2,
    nSeg=9,
    azi=0.3,
    til=0.5) "Tubular solar collector model"
             annotation (Placement(transformation(extent={{12,-20},{32,0}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data input file"
    annotation (Placement(transformation(extent={{-28,20},{-8,40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Inlet for fluid flow" annotation (Placement(transformation(extent={{100,-20},
            {80,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{50,-20},{70,0}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium =
    Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
  Modelica.Blocks.Sources.Sine sine(
    f=3/86400,
    offset=101325,
    amplitude=-0.1*solCol.dp_nominal)
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
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
equation
  connect(solCol.port_b,TOut. port_a) annotation (Line(
      points={{32,-10},{50,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b,sin. ports[1]) annotation (Line(
      points={{70,-10},{80,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b,solCol. port_a) annotation (Line(
      points={{-10,-10},{12,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-8,30},{0,30},{0,-0.4},{12,-0.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sine.y, sou.p_in) annotation (Line(
      points={{-79,-10},{-70,-10},{-70,-18},{-62,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], TIn.port_a) annotation (Line(
      points={{-40,-10},{-30,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (__Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Fluid/SolarCollectors/Examples/Tubular.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=86400.0),
    Documentation(info="<html>
      <p>
        This example models a tubular solar thermal collector. It uses the
        <a href=\"modelica://Buildings.Obsolete.Fluid.SolarCollectors.ASHRAE93\">
        Buildings.Obsolete.Fluid.SolarCollectors.ASHRAE93</a> model and references
        data in the <a href=\"modelica://Buildings.Obsolete.Fluid.SolarCollectors.Data.Tubular\">
        Buildings.Obsolete.Fluid.SolarCollectors.Data.Tubular</a> package.
      </p>
    </html>",
revisions="<html>
<ul>
<li>
December 13, 2023, by Michael Wetter.<br/>
Moved to <code>Obsolete</code> package.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
December 11, 2023, by Michael Wetter:<br/>
Changed design flow rate. This is due to correction for the
implementation of the pressure drop calculation for the situation where collectors are in parallel,
e.g., if <code>sysConfig == Buildings.Obsolete.Fluid.SolarCollectors.Types.SystemConfiguration.Parallel</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3597\">Buildings, #3597</a>.
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
March 27, 2013 by Peter Grant:<br/>
First implementation
</li>
</ul>
</html>"));
end Tubular;
