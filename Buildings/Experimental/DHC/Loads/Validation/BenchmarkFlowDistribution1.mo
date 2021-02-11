within Buildings.Experimental.DHC.Loads.Validation;
model BenchmarkFlowDistribution1
  "Performance benchmark of building heating water flow distribution modeling"
  extends Modelica.Icons.Example;
  package Medium1=Buildings.Media.Water
    "Source side medium";
  package Medium2=Buildings.Media.Air
    "Load side medium";
  parameter String filNam="modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos"
    "File name with thermal loads as time series";
  parameter Integer nLoa=5
    "Number of served loads"
    annotation (Evaluate=true);
  parameter Modelica.SIunits.Temperature T_aHeaWat_nominal(
    min=273.15,
    displayUnit="degC")=273.15+40
    "Heating water inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bHeaWat_nominal(
    min=273.15,
    displayUnit="degC")=T_aHeaWat_nominal-5
    "Heating water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaHea_nominal(
    min=273.15,
    displayUnit="degC")=273.15+20
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaHea_flow_nominal(
    min=0)=1
    "Load side mass flow rate at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp_nominal=nLoa*1500*2+2*500+30000
    "Nominal pressure drop in the distribution line";
  parameter Real facMul=10
    "Mulitplier factor for terminal units"
    annotation (Dialog(group="Scaling"));
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=sum(
    ter.mHeaWat_flow_nominal)*facMul
    "Nominal mass flow rate in the distribution line";
  final parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)=Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))/facMul
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  Buildings.Experimental.DHC.Loads.FlowDistribution disFloHea(
    redeclare package Medium=Medium1,
    m_flow_nominal=m_flow_nominal,
    have_pum=true,
    dp_nominal=dp_nominal,
    nPorts_a1=nLoa,
    nPorts_b1=nLoa)
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  BaseClasses.FanCoil2PipeHeating ter[nLoa](
    each final facMul=facMul,
    redeclare each final package Medium1=Medium1,
    redeclare each final package Medium2=Medium2,
    each final QHea_flow_nominal=QHea_flow_nominal,
    each final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    each final T_aHeaWat_nominal=T_aHeaWat_nominal,
    each final T_bHeaWat_nominal=T_bHeaWat_nominal,
    each final T_aLoaHea_nominal=T_aLoaHea_nominal)
    "Heating terminal unit"
    annotation (Placement(transformation(extent={{40,38},{60,58}})));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
      filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Reader for thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    nout=nLoa)
    "Repeat input to output an array"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep1(
    nout=nLoa)
    "Repeat input to output an array"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium=Medium1,
    use_T_in=true,
    nPorts=1)
    "Heating water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-80})));
  Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare package Medium=Medium1,
    p=300000,
    nPorts=1)
    "Sink for heating water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={90,-80})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSup(
    k=max(
      ter.T_aHeaWat_nominal))
    "Supply temperature"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
equation
  connect(ter.port_bHeaWat,disFloHea.ports_a1)
    annotation (Line(points={{60,39.6667},{70,39.6667},{70,-74},{60,-74}},color={0,127,255}));
  connect(disFloHea.ports_b1,ter.port_aHeaWat)
    annotation (Line(points={{40,-74},{30,-74},{30,39.6667},{40,39.6667}},color={0,127,255}));
  connect(reaRep.y,ter.TSetHea)
    annotation (Line(points={{-38,60},{20,60},{20,53},{39.1667,53}},color={0,0,127}));
  connect(loa.y[2],reaRep1.u)
    annotation (Line(points={{-79,0},{-62,0}},color={0,0,127}));
  connect(reaRep1.y,ter.QReqHea_flow)
    annotation (Line(points={{-38,0},{0,0},{0,46.3333},{39.1667,46.3333}},color={0,0,127}));
  connect(supHeaWat.ports[1],disFloHea.port_a)
    annotation (Line(points={{-40,-80},{40,-80}},color={0,127,255}));
  connect(disFloHea.port_b,sinHeaWat.ports[1])
    annotation (Line(points={{60,-80},{80,-80}},color={0,127,255}));
  connect(ter.mReqHeaWat_flow,disFloHea.mReq_flow)
    annotation (Line(points={{60.8333,44.6667},{80,44.6667},{80,-60},{20,-60},{
          20,-84},{39,-84}},                                                                     color={0,0,127}));
  connect(THeaWatSup.y,supHeaWat.T_in)
    annotation (Line(points={{-78,-80},{-72,-80},{-72,-76},{-62,-76}},color={0,0,127}));
  connect(minTSet.y,reaRep.u)
    annotation (Line(points={{-78,60},{-62,60}},color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
This model is part of a computational performance benchmark between
</p>
<ul>
<li>
a simplified modeling of the piping network as implemented in
<a href=\"Buildings.Experimental.DHC.Loads.FlowDistribution\">
Buildings.Experimental.DHC.Loads.FlowDistribution</a>
(see the corresponding example
<a href=\"modelica://Buildings.Experimental.DHC.Loads.Validation.BenchmarkFlowDistribution1\">
Buildings.Experimental.DHC.Loads.Validation.BenchmarkFlowDistribution1</a>), and
</li>
<li>
an explicit modeling of the piping network (see the corresponding example
<a href=\"modelica://Buildings.Experimental.DHC.Loads.Validation.BenchmarkFlowDistribution2\">
Buildings.Experimental.DHC.Loads.Validation.BenchmarkFlowDistribution2</a>).
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-120},{120,120}})),
    experiment(
      StopTime=2000000,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Validation/BenchmarkFlowDistribution1.mos" "Simulate and plot"));
end BenchmarkFlowDistribution1;
