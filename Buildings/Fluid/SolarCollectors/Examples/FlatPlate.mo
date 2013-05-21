within Buildings.Fluid.SolarCollectors.Examples;
model FlatPlate "Test model for FlatPlate"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater
    "Medium in the system";

  Buildings.Fluid.SolarCollectors.FlatPlate         solCol(
    redeclare package Medium = Medium,
    shaCoe=0,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    SysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.ThermaLiteHS20(),
    nSeg=3,
    TotalArea=3.94,
    lat=0.73097781993588,
    azi=0.3,
    til=0.5,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=2) "Flat plate solar collector model"
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
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This example demonstrates the implementation of <a href=\"modelica://Buildings.Fluid.SolarCollectors.FlatPlate\"> Buildings.Fluid.SolarCollectors.FlatPlate</a>. 
In it water is passed through a solar collector while being heated by the sun in the San Francisco, CA, USA climate.
</p>
</html>",revisions="<html>
<ul>
<li>
Mar 27, 2013, by Peter Grant:<br>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/FlatPlate.mos"
        "Simulate and Plot"),
    Icon(graphics));
end FlatPlate;
