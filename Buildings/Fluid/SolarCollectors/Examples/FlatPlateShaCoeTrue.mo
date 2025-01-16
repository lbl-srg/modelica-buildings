within Buildings.Fluid.SolarCollectors.Examples;
model FlatPlateShaCoeTrue "Test model for FlatPlate with use_shaCoe_in = true"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium in the system";
  Buildings.Fluid.SolarCollectors.ASHRAE93          solCol(
    redeclare package Medium = Medium,
    shaCoe=0,
    from_dp=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_shaCoe_in=true,
    per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_GuangdongFSPTY95(),
    rho=0.2,
    azi=0,
    nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=5,
    sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series,
    nSeg=9,
    til=0.5235987755983) "Flat plate solar collector with 3 segments"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
    Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    "Weather data input file"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Outlet for water flow"
    annotation (Placement(transformation(extent={{70,-10},{50,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TOut(
    redeclare package Medium = Medium,
    T_start(displayUnit="K"),
    m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TIn(redeclare package Medium =
    Medium, m_flow_nominal=solCol.m_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    nPorts=1,
    T=273.15 + 10,
    p(displayUnit="Pa") = 101325 + 5*solCol.per.dp_nominal)
    "Inlet for water flow"
    annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-60,0})));
  Modelica.Blocks.Sources.Ramp shaCoe(
    startTime=34040,
    height=1,
    duration=24193) "Varying shading coefficient"
    annotation (Placement(transformation(extent={{-58,30},{-38,50}})));
equation
  connect(solCol.port_b, TOut.port_a) annotation (Line(
      points={{10,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port_b, sin.ports[1]) annotation (Line(
      points={{40,0},{50,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TIn.port_b, solCol.port_a) annotation (Line(
      points={{-20,0},{-10,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1], TIn.port_a) annotation (Line(
      points={{-50,0},{-50,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(shaCoe.y, solCol.shaCoe_in) annotation (Line(
      points={{-37,40},{-16,40},{-16,4},{-12,4},{-12,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaDat.weaBus, solCol.weaBus) annotation (Line(
      points={{-20,70},{-10,70},{-10,8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  annotation (
    Documentation(info="<html>
<p>
This example demonstrates the use of <code>use_shaCoe_in</code>.
Aside from changed use of <code>use_shaCoe_in</code> it is identical to
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
May 13, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/Examples/FlatPlateShaCoeTrue.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=86400.0));
end FlatPlateShaCoeTrue;
