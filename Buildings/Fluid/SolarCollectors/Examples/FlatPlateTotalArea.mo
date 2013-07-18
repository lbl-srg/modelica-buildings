within Buildings.Fluid.SolarCollectors.Examples;
model FlatPlateTotalArea "Example showing the use of TotalArea and nSeg"
  import Buildings;
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.ConstantPropertyLiquidWater
    "Medium in the system";

  Buildings.Fluid.SolarCollectors.ASHRAE93          solCol(
    redeclare package Medium = Medium,
    shaCoe=0,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nSeg=3,
    rho=0.2,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_SolahartKf(),
    lat=0.73097781993588,
    azi=0.3,
    til=0.5,
    totalArea=30) "Flat plate solar collector model"
             annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
    "Weather data input file"
    annotation (Placement(transformation(extent={{-52,20},{-32,40}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=2) "Outlet for water flow" annotation (Placement(transformation(extent={{80,-40},
            {60,-20}},
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
    nPorts=2,
    p(displayUnit="Pa") = 101325 + solCol.dp_nominal) "Inlet for water flow"   annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-90,-30})));
  Buildings.Fluid.SolarCollectors.ASHRAE93          solCol1(
    redeclare package Medium = Medium,
    shaCoe=0,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    rho=0.2,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Area,
    nSeg=30,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_SolahartKf(),
    lat=0.73097781993588,
    azi=0.3,
    til=0.5,
    totalArea=30) "Flat plate solar collector model"
             annotation (Placement(transformation(extent={{-20,-62},{0,-42}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut1(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{20,-62},{40,-42}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn1(
                                                 redeclare package Medium =
        Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-60,-62},{-40,-42}})));
equation
  connect(solCol.port_b, TOut.port_a) annotation (Line(
      points={{0,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, sin.ports[1]) annotation (Line(
      points={{40,-10},{48,-10},{48,-28},{60,-28}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b, solCol.port_a) annotation (Line(
      points={{-40,-10},{-20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1], TIn.port_a) annotation (Line(
      points={{-80,-28},{-70,-28},{-70,-10},{-60,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-32,30},{-26,30},{-26,-0.4},{-20,-0.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(solCol1.port_b, TOut1.port_a)
                                      annotation (Line(
      points={{0,-52},{20,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn1.port_b, solCol1.port_a)
                                     annotation (Line(
      points={{-40,-52},{-20,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol1.weaBus)
                                        annotation (Line(
      points={{-32,30},{-26,30},{-26,-42.4},{-20,-42.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sou.ports[2], TIn1.port_a) annotation (Line(
      points={{-80,-32},{-70,-32},{-70,-52},{-60,-52}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut1.port_b, sin.ports[2]) annotation (Line(
      points={{40,-52},{48,-52},{48,-32},{60,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,
            100}}), graphics),
    Documentation(info="<html>
<p>
This example demonstrates the implementation of 
<a href=\"modelica://Buildings.Fluid.SolarCollectors.FlatPlate\"> 
Buildings.Fluid.SolarCollectors.FlatPlate</a>. In it water is passed through a 
solar collector while being heated by the sun in the San Francisco, CA, USA 
climate.
</p>
<p>
This model uses <code>TotalArea</code> instead of <code>nPanels</code> to 
define the system size. Aside from that change, this model is identical to 
<a href=\"modelica://Buildings.Fluid.SolarCollectors.Examples.FlatPlate\">
Buildings.Fluid.SolarCollectors.Examples.FlatPlate</a>.
</p>
</html>",revisions="<html>
<ul>
<li>
Mar 27, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/FlatPlateTotalArea.mos"
        "Simulate and Plot"),
    Icon(graphics));
end FlatPlateTotalArea;
