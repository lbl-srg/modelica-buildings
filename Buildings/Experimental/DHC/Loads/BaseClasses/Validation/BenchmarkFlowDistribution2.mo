within Buildings.Experimental.DHC.Loads.BaseClasses.Validation;
model BenchmarkFlowDistribution2
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
  parameter Modelica.Units.SI.Temperature T_aHeaWat_nominal=273.15 + 40
    "Heating water inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_bHeaWat_nominal(
    min=273.15,
    displayUnit="degC") = T_aHeaWat_nominal - 5
    "Heating water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T_aLoaHea_nominal=273.15 + 20
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mLoaHea_flow_nominal=1
    "Load side mass flow rate at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Time tau=120
    "Time constant of fluid temperature variation at nominal flow rate"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  parameter Real facMul=10
    "Mulitplier factor for terminal units"
    annotation (Dialog(group="Scaling"));
  final parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal[nLoa]=ter.mHeaWat_flow_nominal
      *facMul "Nominal mass flow rate in each connection line";
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=sum(
      mCon_flow_nominal) "Nominal mass flow rate in the distribution line";
  final parameter Modelica.Units.SI.PressureDifference dp_nominal=sum(dis.con.pipDisSup.dp_nominal)
       + sum(dis.con.pipDisRet.dp_nominal) + max(ter.dpSou_nominal)
    "Nominal pressure drop in the distribution line";
  final parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=
      Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(string="#Peak space heating load", filNam=
      Modelica.Utilities.Files.loadResource(filNam))/facMul
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.FanCoil2PipeHeatingValve ter[nLoa](
    each final facMul=facMul,
    redeclare each final package Medium1=Medium1,
    redeclare each final package Medium2=Medium2,
    each final QHea_flow_nominal=QHea_flow_nominal,
    each final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    each final T_aHeaWat_nominal=T_aHeaWat_nominal,
    each final T_bHeaWat_nominal=T_bHeaWat_nominal,
    each final T_aLoaHea_nominal=T_aLoaHea_nominal)
    "Heating terminal unit"
    annotation (Placement(transformation(extent={{50,38},{70,58}})));
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
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTSet(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    nout=nLoa)
    "Repeat input to output an array"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(
    nout=nLoa)
    "Repeat input to output an array"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium=Medium1,
    use_T_in=true,
    nPorts=2)
    "Heating water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-80})));
  Buildings.Experimental.DHC.Networks.Distribution2PipeAutoSize dis(
    redeclare final package Medium=Medium1,
    nCon=nLoa,
    allowFlowReversal=false,
    mDis_flow_nominal=m_flow_nominal,
    mCon_flow_nominal=mCon_flow_nominal,
    mEnd_flow_nominal=m_flow_nominal,
    lDis=fill(6, nLoa),
    lEnd=1)
    annotation (Placement(transformation(extent={{40,-90},{80,-70}})));
  Fluid.Movers.FlowControlled_dp pum(
    redeclare package Medium=Medium1,
    per(
      final motorCooledByFluid=false),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Fluid.MixingVolumes.MixingVolume vol(
    final prescribedHeatFlowRate=true,
    redeclare final package Medium=Medium1,
    V=m_flow_nominal*tau/rho_default,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    "Volume for fluid stream"
    annotation (Placement(transformation(extent={{-31,-80},{-11,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpPum(
    k=dp_nominal)
    "Prescribed head"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSup(
    k=max(
      ter.T_aHeaWat_nominal))
    "Supply temperature"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
protected
  parameter Medium1.ThermodynamicState sta_default=Medium1.setState_pTX(
    T=Medium1.T_default,
    p=Medium1.p_default,
    X=Medium1.X_default);
  parameter Modelica.Units.SI.Density rho_default=Medium1.density(sta_default)
    "Density, used to compute fluid volume";
equation
  connect(loa.y[2],reaRep1.u)
    annotation (Line(points={{-79,0},{-62,0}},color={0,0,127}));
  connect(reaRep.y,ter.TSetHea)
    annotation (Line(points={{-38,60},{20,60},{20,53},{49.1667,53}},color={0,0,127}));
  connect(reaRep1.y,ter.QReqHea_flow)
    annotation (Line(points={{-38,0},{0,0},{0,46.3333},{49.1667,46.3333}},color={0,0,127}));
  connect(ter.port_bHeaWat,dis.ports_aCon)
    annotation (Line(points={{70,39.6667},{80,39.6667},{80,0},{72,0},{72,-70}},color={0,127,255}));
  connect(dis.ports_bCon,ter.port_aHeaWat)
    annotation (Line(points={{48,-70},{48,0},{40,0},{40,39.6667},{50,39.6667}},color={0,127,255}));
  connect(pum.port_b,dis.port_aDisSup)
    annotation (Line(points={{30,-80},{40,-80}},color={0,127,255}));
  connect(dis.port_bDisRet,supHeaWat.ports[1])
    annotation (Line(points={{40,-86},{32,-86},{32,-100},{-40,-100},{-40,-81}},color={0,127,255}));
  connect(vol.ports[1],pum.port_a)
    annotation (Line(points={{-22,-80},{10,-80}},color={0,127,255}));
  connect(supHeaWat.ports[2],vol.ports[2])
    annotation (Line(points={{-40,-79},{-40,-80},{-20,-80}},color={0,127,255}));
  connect(THeaWatSup.y,supHeaWat.T_in)
    annotation (Line(points={{-78,-80},{-70,-80},{-70,-76},{-62,-76}},color={0,0,127}));
  connect(dpPum.y,pum.dp_in)
    annotation (Line(points={{-78,-40},{20,-40},{20,-68}},color={0,0,127}));
  connect(reaRep.u,minTSet.y)
    annotation (Line(points={{-62,60},{-78,60}},color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
This model is part of a computational performance benchmark between
</p>
<ul>
<li>
a simplified modeling of the piping network as implemented in
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.Experimental.DHC.Loads.BaseClasses.FlowDistribution</a>
(see the corresponding example
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BenchmarkFlowDistribution1\">
Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BenchmarkFlowDistribution1</a>), and
</li>
<li>
an explicit modeling of the piping network (see the corresponding example
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BenchmarkFlowDistribution2\">
Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BenchmarkFlowDistribution2</a>).
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
    experiment(
      StopTime=2000000,
      Tolerance=1e-06),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-120},{120,120}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/BaseClasses/Validation/BenchmarkFlowDistribution2.mos" "Simulate and plot"));
end BenchmarkFlowDistribution2;
