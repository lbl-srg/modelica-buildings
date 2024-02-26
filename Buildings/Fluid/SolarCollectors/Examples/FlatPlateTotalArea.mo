within Buildings.Fluid.SolarCollectors.Examples;
model FlatPlateTotalArea "Example showing the use of TotalArea and nSeg"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium in the system";

  Buildings.Fluid.SolarCollectors.ASHRAE93          solCol(
    redeclare package Medium = Medium,
    shaCoe=0,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    rho=0.2,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_SolahartKf(),
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=10,
    nSeg=9,
    azi=0.3,
    til=0.5) "Flat plate solar collector model"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data input file"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=2) "Outlet for water flow"
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium =
    Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    T=273.15 + 10,
    use_p_in=false,
    nPorts=2,
    p(displayUnit="Pa") = 101325 + solCol.dp_nominal) "Inlet for water flow"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-60,0})));

  Buildings.Fluid.SolarCollectors.ASHRAE93 solCol1(
    redeclare package Medium = Medium,
    shaCoe=0,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    rho=0.2,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_SolahartKf(),
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=10,
    nSeg=27,
    azi=0.3,
    til=0.5) "Flat plate solar collector model"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut1(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn1(
    redeclare package Medium =
    Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(solCol.port_b, TOut.port_a) annotation (Line(
      points={{10,30},{20,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, sin.ports[1]) annotation (Line(
      points={{40,30},{50,30},{50,-1}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b, solCol.port_a) annotation (Line(
      points={{-20,30},{-10,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1], TIn.port_a) annotation (Line(
      points={{-50,-1},{-50,30},{-40,30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-40,70},{-14,70},{-14,38},{-10,38},{-10,38}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(solCol1.port_b, TOut1.port_a)
                                      annotation (Line(
      points={{10,-30},{20,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn1.port_b, solCol1.port_a)
                                     annotation (Line(
      points={{-20,-30},{-10,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol1.weaBus)
                                        annotation (Line(
      points={{-40,70},{-14,70},{-14,-22},{-10,-22}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(sou.ports[2], TIn1.port_a) annotation (Line(
      points={{-50,1},{-50,-30},{-40,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut1.port_b, sin.ports[2]) annotation (Line(
      points={{40,-30},{50,-30},{50,1}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
This model uses <code>TotalArea</code> instead of <code>nPanels</code> to
define the system size.
Aside from that change, this model is identical to
<a href=\"modelica://Buildings.Fluid.SolarCollectors.Examples.FlatPlate\">
Buildings.Fluid.SolarCollectors.Examples.FlatPlate</a>.
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
Mar 27, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/FlatPlateTotalArea.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=86400.0));
end FlatPlateTotalArea;
