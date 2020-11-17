within Buildings.Experimental.DHC.Loads.Examples;
model CouplingTimeSeries_Residential
  "Example illustrating the coupling of a residential building model to 
    heating water and chilled water loops"
  extends Modelica.Icons.Example;
  package MeduimW=Buildings.Media.Water
    "Source side medium";
  parameter Modelica.SIunits.Time perAve=600
    "Period for time averaged variables";
  Buildings.Experimental.DHC.Loads.Examples.BaseClasses.BuildingTimeSeries bui(
    filNam="modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    delTAirCoo(
      displayUnit="degC")=6,
    delTAirHea(
      displayUnit="degC")=18,
    k=1,
    Ti=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_inputFilter=false,
    nPorts_aHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bHeaWat=1,
    nPorts_bChiWat=1)
    "Residential building with time series heating and cooling loads"
    annotation (Placement(transformation(extent={{8,-2},{28,18}})));
  Buildings.Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare package Medium=MeduimW,
    p=300000,
    nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={130,20})));
  Buildings.Fluid.Sources.Boundary_pT sinChiWat(
    redeclare package Medium=MeduimW,
    p=300000,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={130,-20})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(
    y=bui.T_aHeaWat_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Sources.RealExpression TChiWatSup(
    y=bui.T_aChiWat_nominal)
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));
  Buildings.Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium=MeduimW,
    use_T_in=true,
    nPorts=1)
    "Heating water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,40})));
  Buildings.Fluid.Sources.Boundary_pT supChiWat(
    redeclare package Medium=MeduimW,
    use_T_in=true,
    nPorts=1)
    "Chilled water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-20})));
  Modelica.Blocks.Continuous.Integrator EHeaReq(
    y(
      unit="J"))
    "Time integral of heating load"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Modelica.Blocks.Continuous.Integrator EHeaAct(
    y(
      unit="J"))
    "Actual energy used for heating"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));
  Modelica.Blocks.Continuous.Integrator ECooReq(
    y(
      unit="J"))
    "Time integral of cooling load"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Modelica.Blocks.Continuous.Integrator ECooAct(
    y(
      unit="J"))
    "Actual energy used for cooling"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveHeaReq_flow(
    y(
      unit="W"),
    final delta=perAve)
    "Time average of heating load"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveHeaAct_flow(
    y(
      unit="W"),
    final delta=perAve)
    "Time average of heating heat flow rate"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveCooReq_flow(
    y(
      unit="W"),
    final delta=perAve)
    "Time average of cooling load"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.MovingMean QAveCooAct_flow(
    y(
      unit="W"),
    final delta=perAve)
    "Time average of cooling heat flow rate"
    annotation (Placement(transformation(extent={{100,-110},{120,-90}})));
equation
  connect(supHeaWat.T_in,THeaWatSup.y)
    annotation (Line(points={{-62,44},{-80,44},{-80,40},{-99,40}},color={0,0,127}));
  connect(TChiWatSup.y,supChiWat.T_in)
    annotation (Line(points={{-99,-20},{-80,-20},{-80,-16},{-62,-16}},color={0,0,127}));
  connect(supHeaWat.ports[1],bui.ports_aHeaWat[1])
    annotation (Line(points={{-40,40},{0,40},{0,6},{8,6}},color={0,127,255}));
  connect(supChiWat.ports[1],bui.ports_aChiWat[1])
    annotation (Line(points={{-40,-20},{0,-20},{0,2},{8,2}},color={0,127,255}));
  connect(bui.ports_bHeaWat[1],sinHeaWat.ports[1])
    annotation (Line(points={{28,6},{60,6},{60,20},{120,20}},color={0,127,255}));
  connect(sinChiWat.ports[1],bui.ports_bChiWat[1])
    annotation (Line(points={{120,-20},{60,-20},{60,2},{28,2}},color={0,127,255}));
  connect(bui.QHea_flow,EHeaAct.u)
    annotation (Line(points={{28.6667,16.6667},{40,16.6667},{40,60},{90,60},{90,80},{98,80}},color={0,0,127}));
  connect(bui.QReqHea_flow,EHeaReq.u)
    annotation (Line(points={{24.6667,-2.66667},{24.6667,-8},{36,-8},{36,80},{58,80}},color={0,0,127}));
  connect(bui.QReqCoo_flow,ECooReq.u)
    annotation (Line(points={{26.6667,-2.66667},{26.6667,-60},{58,-60}},color={0,0,127}));
  connect(bui.QCoo_flow,ECooAct.u)
    annotation (Line(points={{28.6667,15.3333},{40,15.3333},{40,-40},{90,-40},{90,-60},{98,-60}},color={0,0,127}));
  connect(bui.QReqHea_flow,QAveHeaReq_flow.u)
    annotation (Line(points={{24.6667,-2.66667},{24.6667,-7.90323},{35.9677,-7.90323},{35.9677,120},{58,120}},color={0,0,127}));
  connect(bui.QHea_flow,QAveHeaAct_flow.u)
    annotation (Line(points={{28.6667,16.6667},{40,16.6667},{40,60},{90,60},{90,120},{98,120}},color={0,0,127}));
  connect(bui.QReqCoo_flow,QAveCooReq_flow.u)
    annotation (Line(points={{26.6667,-2.66667},{28.6316,-2.66667},{28.6316,-100},{58,-100}},color={0,0,127}));
  connect(bui.QCoo_flow,QAveCooAct_flow.u)
    annotation (Line(points={{28.6667,15.3333},{40,15.3333},{40,-40},{90,-40},{90,-100},{98,-100}},color={0,0,127}));
  annotation (
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-160,-140},{160,140}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Examples/CouplingTimeSeries_Residential.mos" "Simulate and plot"),
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
<a href=\"modelica://Buildings.Experimental.DHC.Loads.FlowDistribution\">
Buildings.Experimental.DHC.Loads.FlowDistribution</a>
in a configuration with
</p>
<ul>
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
October 20, 2020, by Hagar Elarga:<br/>
The default values of <code>facScaHeac</code>
and <code>facScaCoo</code> are assigned to one.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2201\">issue 2201</a> and
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2202\">issue 2202</a>.
</li>  
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end CouplingTimeSeries_Residential;
