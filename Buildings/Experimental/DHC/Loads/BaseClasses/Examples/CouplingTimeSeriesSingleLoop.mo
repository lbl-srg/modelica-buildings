within Buildings.Experimental.DHC.Loads.BaseClasses.Examples;
model CouplingTimeSeriesSingleLoop
  "Example illustrating the coupling of a building model to heating water or chilled water loops"
  extends Modelica.Icons.Example;
  package Medium1=Buildings.Media.Water
    "Source side medium";
  parameter Modelica.Units.SI.Time perAve=600
    "Period for time averaged variables";
  Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.BuildingTimeSeries buiCoo(
    have_heaWat=false,
    filNam="modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    facMulCoo=40,
    nPorts_aChiWat=1,
    nPorts_bChiWat=1)
    "Building wint cooling only"
    annotation (Placement(transformation(extent={{-10,100},{10,120}})));
  Buildings.Fluid.Sources.Boundary_pT sinChiWat(
    redeclare package Medium=Medium1,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={110,104})));
  Modelica.Blocks.Sources.RealExpression TChiWatSup(
    y=buiCoo.T_aChiWat_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,98},{-120,118}})));
  Fluid.Sources.Boundary_pT supChiWat(
    redeclare package Medium=Medium1,
    use_T_in=true,
    nPorts=1)
    "Chilled water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-70,104})));
  Modelica.Blocks.Continuous.Integrator ECooReq(
    y(unit="J"))
    "Time integral of cooling load"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage QAveCooReq_flow(y(unit=
          "W"), final delta=perAve) "Time average of cooling load"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage QAveCooAct_flow(y(unit=
          "W"), final delta=perAve) "Time average of cooling heat flow rate"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Modelica.Blocks.Continuous.Integrator ECooAct(
    y(unit="J"))
    "Actual energy used for cooling"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.BuildingTimeSeries buiHea(
    have_chiWat=false,
    filNam="modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    facMulHea=10,
    nPorts_aChiWat=1,
    nPorts_bChiWat=1,
    nPorts_aHeaWat=1,
    nPorts_bHeaWat=1)
    "Building with heating only"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(
    y=buiHea.T_aHeaWat_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-140,-18},{-120,2}})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium=Medium1,
    use_T_in=true,
    nPorts=1)
    "Heating water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-70,-12})));
  Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare package Medium=Medium1,
    nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={110,-12})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage QAveHeaReq_flow(y(unit=
          "W"), final delta=perAve) "Time average of heating load"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Modelica.Blocks.Continuous.Integrator EHeaReq(
    y(unit="J"))
    "Time integral of heating load"
    annotation (Placement(transformation(extent={{40,-70},{60,-50}})));
  Modelica.Blocks.Continuous.Integrator EHeaAct(
    y(unit="J"))
    "Actual energy used for heating"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingAverage QAveHeaAct_flow(y(unit=
          "W"), final delta=perAve) "Time average of heating heat flow rate"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));
equation
  connect(TChiWatSup.y,supChiWat.T_in)
    annotation (Line(points={{-119,108},{-82,108}},color={0,0,127}));
  connect(supChiWat.ports[1],buiCoo.ports_aChiWat[1])
    annotation (Line(points={{-60,104},{-10,104}},color={0,127,255}));
  connect(sinChiWat.ports[1],buiCoo.ports_bChiWat[1])
    annotation (Line(points={{100,104},{10,104}},color={0,127,255}));
  connect(buiCoo.QReqCoo_flow,ECooReq.u)
    annotation (Line(points={{8,98.6667},{8,70},{38,70}},            color={0,0,127}));
  connect(buiCoo.QReqCoo_flow,QAveCooReq_flow.u)
    annotation (Line(points={{8,98.6667},{8,30},{38,30}},            color={0,0,127}));
  connect(buiCoo.QCoo_flow,ECooAct.u)
    annotation (Line(points={{10.6667,117.333},{70,117.333},{70,70},{78,70}},color={0,0,127}));
  connect(buiCoo.QCoo_flow,QAveCooAct_flow.u)
    annotation (Line(points={{10.6667,117.333},{70,117.333},{70,30},{78,30}},color={0,0,127}));
  connect(THeaWatSup.y,supHeaWat.T_in)
    annotation (Line(points={{-119,-8},{-82,-8}},color={0,0,127}));
  connect(supHeaWat.ports[1],buiHea.ports_aHeaWat[1])
    annotation (Line(points={{-60,-12},{-10,-12}},color={0,127,255}));
  connect(buiHea.ports_bHeaWat[1],sinHeaWat.ports[1])
    annotation (Line(points={{10,-12},{100,-12}},color={0,127,255}));
  connect(buiHea.QReqHea_flow,EHeaReq.u)
    annotation (Line(points={{6.66667,-21.3333},{6.66667,-60},{38,-60}},color={0,0,127}));
  connect(buiHea.QReqHea_flow,QAveHeaReq_flow.u)
    annotation (Line(points={{6.66667,-21.3333},{6.66667,-100},{38,-100}},color={0,0,127}));
  connect(buiHea.QHea_flow,EHeaAct.u)
    annotation (Line(points={{10.6667,-1.33333},{70,-1.33333},{70,-60},{78,-60}},color={0,0,127}));
  connect(buiHea.QHea_flow,QAveHeaAct_flow.u)
    annotation (Line(points={{10.6667,-1.33333},{70,-1.33333},{70,-100},{78,
          -100}},                                                                  color={0,0,127}));
  annotation (
    experiment(
      StopTime=604800,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
This example illustrates the use of
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding\">
Buildings.Experimental.DHC.Loads.BaseClasses.PartialBuilding</a>,
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.Experimental.DHC.Loads.BaseClasses.PartialTerminalUnit</a>
and
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.Experimental.DHC.Loads.BaseClasses.FlowDistribution</a>
in a configuration with
</p>
<ul>
<li>
a single connection with a heating water distribution system, see
component <code>buiHea</code> (resp. with a chilled water distribution
system, see component <code>buiCoo</code>),
</li>
<li>
space heating and cooling loads provided as time series, and
</li>
<li>
secondary pumps.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
September 18, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-140},{160,140}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/BaseClasses/Examples/CouplingTimeSeriesSingleLoop.mos" "Simulate and plot"));
end CouplingTimeSeriesSingleLoop;
