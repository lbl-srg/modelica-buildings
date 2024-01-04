within Buildings.Fluid.SolarCollectors.Validation;
model EN12975_Series
  "Validation model for collector according to EN12975 with different panels in series"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium in the system";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=solCol.per.A*
      solCol.per.mperA_flow_nominal "Nominal mass flow rate";

  model Collector
    extends Buildings.Fluid.SolarCollectors.EN12975(
    redeclare final package Medium = Buildings.Media.Water,
    final show_T = true,
    final per=Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate.FP_VerificationModel(),
    final shaCoe=0,
    final azi=0,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final rho=0.2,
    final nColType=Buildings.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=1,
    final til=0.78539816339745,
    final C=385*per.mDry,
    final use_shaCoe_in=false,
    final sysConfig=Buildings.Fluid.SolarCollectors.Types.SystemConfiguration.Series);

  end Collector;

  Collector solCol(nPanels=2, nSeg=6)
    "Flat plate solar collector model, has been modified for validation purposes"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Collector solCol1(nSeg=3, nPanels=1)
    "Flat plate solar collector model, has been modified for validation purposes"
    annotation (Placement(transformation(extent={{-50,-40},{-30,-20}})));

  Collector solCol2(nSeg=3, nPanels=1)
    "Flat plate solar collector model, has been modified for validation purposes"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
      computeWetBulbTemperature=false)
    "Weather data file reader"
    annotation (Placement(transformation(extent={{-88,60},{-68,80}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Outlet for water flow"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=false,
    m_flow=m_flow_nominal,
    T=303.15) "Inlet for water flow, at a prescribed flow rate and temperature"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

  Buildings.Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Outlet for water flow"
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou1(
    nPorts=1,
    redeclare package Medium = Medium,
    use_T_in=false,
    m_flow=m_flow_nominal,
    T=303.15) "Inlet for water flow, at a prescribed flow rate and temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Sensors.TemperatureTwoPort senTem(
     redeclare package Medium = Medium,
     tau=0,
     m_flow_nominal=m_flow_nominal)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{20,40},{40,20}})));
  Sensors.TemperatureTwoPort senTem1(
    redeclare package Medium = Medium,
    tau=0,
    m_flow_nominal=m_flow_nominal)
    "Temperature sensor"
    annotation (Placement(transformation(extent={{20,-20},{40,-40}})));
  Modelica.Blocks.Math.Add dT(final k2=-1) "Temperature difference (must be zero)"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
equation
  connect(weaDat.weaBus, solCol1.weaBus) annotation (Line(
      points={{-68,70},{-50,70},{-50,-21}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bou1.ports[1], solCol1.port_a) annotation (Line(
      points={{-60,-30},{-50,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(solCol.port_a, bou.ports[1]) annotation (Line(points={{-20,30},{-60,30}},
                           color={0,127,255}));
  connect(solCol.weaBus, weaDat.weaBus) annotation (Line(
      points={{-20,39},{-20,70},{-68,70}},
      color={255,204,51},
      thickness=0.5));
  connect(solCol2.port_a, solCol1.port_b)
    annotation (Line(points={{-20,-30},{-30,-30}},
                                                color={0,127,255}));
  connect(weaDat.weaBus, solCol2.weaBus) annotation (Line(
      points={{-68,70},{-20,70},{-20,-21}},
      color={255,204,51},
      thickness=0.5));
  connect(solCol.port_b, senTem.port_a)
    annotation (Line(points={{0,30},{20,30}}, color={0,127,255}));
  connect(senTem.port_b, sou.ports[1])
    annotation (Line(points={{40,30},{60,30}}, color={0,127,255}));
  connect(sou1.ports[1], senTem1.port_b)
    annotation (Line(points={{60,-30},{40,-30}}, color={0,127,255}));
  connect(senTem1.port_a, solCol2.port_b)
    annotation (Line(points={{20,-30},{0,-30}}, color={0,127,255}));
  connect(dT.u1, senTem.T) annotation (Line(points={{58,-64},{50,-64},{50,0},{30,
          0},{30,19}},  color={0,0,127}));
  connect(senTem1.T, dT.u2) annotation (Line(points={{30,-41},{30,-76},{58,-76}},
                                       color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
This model validates the solar collector model
<a href=\"modelica://Buildings.Fluid.SolarCollectors.EN12975\">
Buildings.Fluid.SolarCollectors.EN12975</a>
for the case where one model has multiple panels in series,
versus the case where two models are in series, each having one panel.
The output of the block <code>dT</code> must be zero, as both
cases must have the same outlet temperatures.
</p>
</html>", revisions="<html>
<ul>
<li>
January, 2024, by Jelger Jansen:<br/>
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
December 12, 2017, by Michael Wetter:<br/>
First implementation to validate
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1100\">#1100</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/SolarCollectors/Validation/EN12975_Series.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=86400));
end EN12975_Series;
