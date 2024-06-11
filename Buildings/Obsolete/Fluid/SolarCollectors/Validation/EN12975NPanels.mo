within Buildings.Obsolete.Fluid.SolarCollectors.Validation;
model EN12975NPanels
  "Validation model for collector according to EN12975 with different settings for nPanel"
  extends Modelica.Icons.Example;
  replaceable package Medium = Buildings.Media.Water "Medium in the system";

  parameter Integer nPanels=10 "Number of panels";

  Buildings.Obsolete.Fluid.SolarCollectors.EN12975 solCol(
    redeclare package Medium = Medium,
    per=datSolCol,
    shaCoe=0,
    azi=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    rho=0.2,
    nColType=Buildings.Obsolete.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nPanels=1,
    nSeg=30,
    til=0.78539816339745)
    "Flat plate solar collector model, has been modified for validation purposes"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
      computeWetBulbTemperature=false)
    "Weather data file reader"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Outlet for water flow"
    annotation (Placement(transformation(extent={{80,20},{60,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=false,
    T=303.15) "Inlet for water flow, at a prescribed flow rate and temperature"
    annotation (Placement(transformation(extent={{-12,20},{8,40}})));

  Buildings.Obsolete.Fluid.SolarCollectors.EN12975 solCol1(
    redeclare package Medium = Medium,
    per=datSolCol,
    shaCoe=0,
    azi=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    rho=0.2,
    nColType=Buildings.Obsolete.Fluid.SolarCollectors.Types.NumberSelection.Number,
    nSeg=30,
    til=0.78539816339745,
    nPanels=nPanels)
    "Flat plate solar collector model, has been modified for validation purposes"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Fluid.Sources.Boundary_pT sou1(
    redeclare package Medium = Medium,
    use_p_in=false,
    p(displayUnit="Pa") = 101325,
    nPorts=1) "Outlet for water flow"
    annotation (Placement(transformation(extent={{80,-40},{60,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou1(
    nPorts=1,
    redeclare package Medium = Medium,
    use_m_flow_in=true,
    use_T_in=false,
    T=303.15) "Inlet for water flow, at a prescribed flow rate and temperature"
    annotation (Placement(transformation(extent={{-12,-40},{8,-20}})));
  Modelica.Blocks.Math.Gain gaiNPan(k=nPanels) "Gain for number of panels"
    annotation (Placement(transformation(extent={{-52,-32},{-32,-12}})));
  Modelica.Blocks.Sources.RealExpression difHeaGai(y=solCol.heaGai[30].Q_flow
         - solCol1.heaGai[30].Q_flow/nPanels)
    "Difference in heat gain at last panel between model with 1 and with 30 panels"
    annotation (Placement(transformation(extent={{-68,-72},{-48,-52}})));
  Modelica.Blocks.Sources.RealExpression difHeaLos(y=solCol.QLos[30].Q_flow -
        solCol1.QLos[30].Q_flow/nPanels)
    "Difference in heat loss at last panel between model with 1 and with 30 panels"
    annotation (Placement(transformation(extent={{-68,-92},{-48,-72}})));
  Modelica.Blocks.Sources.Constant m_flow_nominal(k=datSolCol.A*datSolCol.mperA_flow_nominal)
    "Nominal flow rate for one panel"
    annotation (Placement(transformation(extent={{-88,30},{-68,50}})));
  parameter Data.Concentrating.C_VerificationModel datSolCol
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
equation
  connect(weaDat.weaBus, solCol1.weaBus) annotation (Line(
      points={{-20,70},{14,70},{14,-20},{20,-20},{20,-20.4}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(bou1.ports[1], solCol1.port_a) annotation (Line(
      points={{8,-30},{20,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou1.ports[1], solCol1.port_b) annotation (Line(
      points={{60,-30},{40,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(gaiNPan.y, bou1.m_flow_in)
    annotation (Line(points={{-31,-22},{-14,-22}}, color={0,0,127}));
  connect(solCol.port_a, bou.ports[1])
    annotation (Line(points={{20,30},{8,30}}, color={0,127,255}));
  connect(solCol.port_b, sou.ports[1])
    annotation (Line(points={{40,30},{60,30}}, color={0,127,255}));
  connect(solCol.weaBus, weaDat.weaBus) annotation (Line(
      points={{20,39.6},{18,39.6},{18,40},{14,40},{14,70},{-20,70}},
      color={255,204,51},
      thickness=0.5));
  connect(m_flow_nominal.y, bou.m_flow_in) annotation (Line(points={{-67,40},{-22,
          40},{-22,38},{-14,38}}, color={0,0,127}));
  connect(gaiNPan.u, m_flow_nominal.y) annotation (Line(points={{-54,-22},{-60,
          -22},{-60,40},{-67,40}}, color={0,0,127}));
  annotation (
    Documentation(info="<html>
<p>
This model validates the solar collector model
<a href=\"modelica://Buildings.Obsolete.Fluid.SolarCollectors.EN12975\">
Buildings.Obsolete.Fluid.SolarCollectors.EN12975</a>
for the case
where the number of panels is <i>1</i> for the instance <code>solCol</code>
and <i>10</i> for the instance <code>solCol1</code>.
The instances <code>difHeaGai</code> and <code>difHeaLos</code>
compare the heat gain and heat loss between the two models.
The output of these blocks should be zero, except for rounding errors.
</p>
</html>", revisions="<html>
<ul>
<li>
December 13, 2023, by Michael Wetter.<br/>
Moved to <code>Obsolete</code> package.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
September 16, 2021, by Michael Wetter:<br/>
Removed parameter assignment for <code>lat</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1477\">IBPSA, #1477</a>.
</li>
<li>
November 21, 2017, by Michael Wetter:<br/>
First implementation to validate
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1073\">#1073</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Fluid/SolarCollectors/Validation/EN12975NPanels.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=86400));
end EN12975NPanels;
