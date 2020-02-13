within Buildings.Applications.DHC.Loads.Validation;
model BenchmarkFlowDistribution2
  "Performance benchmark of building heating water flow distribution modeling"
  extends Modelica.Icons.Example;
  package Medium1 = Buildings.Media.Water
    "Source side medium";
  package Medium2 = Buildings.Media.Air
    "Load side medium";
  parameter String filPat=
    "modelica://Buildings/Applications/DHC/Examples/Resources/SwissResidential_20190916.mos"
    "Library path of the file with thermal loads as time series";
  parameter Integer nLoa=5
    "Number of served loads"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.Temperature T_aHeaWat_nominal(
    min=273.15, displayUnit="degC") = 273.15 + 40
    "Heating water inlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bHeaWat_nominal(
    min=273.15, displayUnit="degC") = T_aHeaWat_nominal - 5
    "Heating water outlet temperature at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaHea_nominal(
    min=273.15, displayUnit="degC") = 273.15 + 20
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate mLoaHea_flow_nominal(min=0) = 10
    "Load side mass flow rate at nominal conditions in heating mode"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Time tau = 120
    "Time constant of fluid temperature variation at nominal flow rate"
    annotation (Dialog(tab="Dynamics", group="Nominal condition"));
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=sum(ter.mHeaWat_flow_nominal)
    "Nominal mass flow rate in the distribution line";
  final parameter Modelica.SIunits.PressureDifference dp_nominal=sum(dis.con.pipDisSup.dp_nominal)
       + sum(dis.con.pipDisRet.dp_nominal) + max(ter.dp_nominal)
    "Nominal pressure drop in the distribution line";
  final parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal=
    Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.getPeakLoad(
      string="#Peak space heating load",
      filNam=Modelica.Utilities.Files.loadResource(filPat))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  BaseClasses.FanCoil2PipeHeatingValve ter[nLoa](
    redeclare each final package Medium1 = Medium1,
    redeclare each final package Medium2 = Medium2,
    each final QHea_flow_nominal=QHea_flow_nominal,
    each final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    each final T_aHeaWat_nominal=T_aHeaWat_nominal,
    each final T_bHeaWat_nominal=T_bHeaWat_nominal,
    each final T_aLoaHea_nominal=T_aLoaHea_nominal) "Heating terminal unit"
    annotation (Placement(transformation(extent={{40,38},{60,58}})));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filPat),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Reader for thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20)
    "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.UnitConversions.From_degC minTSet_K
    "Minimum temperature setpoint (K)"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=nLoa)
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep1(nout=nLoa)
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=2) "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-80})));
  BaseClasses.Distribution2Pipe dis(
    redeclare final package Medium = Medium1,
    nCon=nLoa,
    allowFlowReversal=false,
    mDis_flow_nominal={sum(ter[i:nLoa].mHeaWat_flow_nominal) for i in 1:nLoa},
    mCon_flow_nominal=ter.mHeaWat_flow_nominal,
    dpDis_nominal=fill(1500, nLoa))
    annotation (Placement(transformation(extent={{40,-90},{80,-70}})));
  Fluid.Movers.FlowControlled_dp pum(
    redeclare package Medium = Medium1,
    per(final motorCooledByFluid=false),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Fluid.MixingVolumes.MixingVolume vol(
    final prescribedHeatFlowRate=true,
    redeclare final package Medium = Medium1,
    V=m_flow_nominal*tau/rho_default,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    "Volume for fluid stream"
     annotation (Placement(transformation(extent={{-31,-80},{-11,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dpPum(k=dp_nominal)
    "Prescribed head"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSup(k=max(ter.T_aHeaWat_nominal))
    "Supply temperature"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
protected
  parameter Medium1.ThermodynamicState sta_default=Medium1.setState_pTX(
      T=Medium1.T_default,
      p=Medium1.p_default,
      X=Medium1.X_default);
  parameter Modelica.SIunits.Density rho_default=Medium1.density(sta_default)
    "Density, used to compute fluid volume";
equation
  connect(loa.y[2], reaRep1.u)
    annotation (Line(points={{-79,0},{-62,0}}, color={0,0,127}));
  connect(minTSet.y, minTSet_K.u)
    annotation (Line(points={{-78,70},{-62,70}}, color={0,0,127}));
  connect(minTSet_K.y, reaRep.u)
    annotation (Line(points={{-38,70},{-22,70}}, color={0,0,127}));
  connect(reaRep.y, ter.TSetHea) annotation (Line(points={{2,70},{20,70},{20,53},
          {39.1667,53}}, color={0,0,127}));
  connect(reaRep1.y, ter.QReqHea_flow) annotation (Line(points={{-38,0},{0,0},{
          0,46.3333},{39.1667,46.3333}},
                                       color={0,0,127}));
  connect(ter.port_bHeaWat, dis.ports_aCon) annotation (Line(points={{60,
          39.6667},{80,39.6667},{80,0},{72,0},{72,-70}},
                                                color={0,127,255}));
  connect(dis.ports_bCon, ter.port_aHeaWat) annotation (Line(points={{48,-70},{
          48,0},{20,0},{20,39.6667},{40,39.6667}},
                                                color={0,127,255}));
  connect(pum.port_b, dis.port_aDisSup)
    annotation (Line(points={{30,-80},{40,-80}}, color={0,127,255}));
  connect(dis.port_bDisRet, supHeaWat.ports[1]) annotation (Line(points={{40,-86},
          {32,-86},{32,-98},{-40,-98},{-40,-78}}, color={0,127,255}));
  connect(vol.ports[1], pum.port_a)
    annotation (Line(points={{-23,-80},{10,-80}},color={0,127,255}));
  connect(supHeaWat.ports[2], vol.ports[2]) annotation (Line(points={{-40,-82},{
          -40,-80},{-19,-80}},           color={0,127,255}));
  connect(THeaWatSup.y, supHeaWat.T_in) annotation (Line(points={{-78,-80},{-70,
          -80},{-70,-76},{-62,-76}}, color={0,0,127}));
  connect(dpPum.y, pum.dp_in)
    annotation (Line(points={{-78,-40},{20,-40},{20,-68}}, color={0,0,127}));
    annotation (Placement(transformation(extent={{40,-90},{80,-70}})),
    experiment(
      StopTime=2000000,
      __Dymola_NumberOfIntervals=500,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/Loads/Validation/BenchmarkFlowDistribution2.mos"
        "Simulate and plot"));
end BenchmarkFlowDistribution2;
