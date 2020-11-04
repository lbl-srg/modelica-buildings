within Buildings.Experimental.DHC.Loads.Validation;
model FlowDistributionPumpControl
  "Validation of the pump head computation in FlowDistribution"
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
  parameter Real facSca=10
    "Scaling factor to be applied to each extensive quantity"
    annotation (Dialog(group="Scaling"));
  parameter Modelica.SIunits.MassFlowRate mLoaHea_flow_nominal=1
    "Load side mass flow rate at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aHeaWat_nominal=273.15+40
    "Heating water inlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_bHeaWat_nominal(
    min=273.15,
    displayUnit="degC")=T_aHeaWat_nominal-5
    "Heating water outlet temperature at nominal conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T_aLoaHea_nominal=273.15+20
    "Load side inlet temperature at nominal conditions in heating mode"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Time tau=120
    "Time constant of fluid temperature variation at nominal flow rate"
    annotation (Dialog(tab="Dynamics",group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpDis_nominal[nLoa](
    each min=0,
    each displayUnit="Pa")=1/2 .* cat(
    1,
    {dp_nominal*0.2},
    fill(
      dp_nominal*0.8/(nLoa-1),
      nLoa-1))
    "Pressure drop between each connected unit at nominal conditions (supply line)";
  parameter Modelica.SIunits.PressureDifference dpSet=max(
    terUniHea.dp_nominal)
    "Pressure difference set point";
  final parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal[nLoa]=terUniHea.mHeaWat_flow_nominal*facSca
    "Nominal mass flow rate in each connection line";
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=sum(
    mCon_flow_nominal)
    "Nominal mass flow rate in the distribution line";
  final parameter Modelica.SIunits.PressureDifference dp_nominal=max(
    terUniHea.dp_nominal)+2*nLoa*5000
    "Nominal pressure drop in the distribution line";
  final parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal=Loads.BaseClasses.getPeakLoad(
    string="#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam))/facSca
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Nominal condition"));
  BaseClasses.FanCoil2PipeHeatingValve terUniHea[nLoa](
    redeclare each final package Medium1=Medium1,
    redeclare each final package Medium2=Medium2,
    each final facSca=facSca,
    each final QHea_flow_nominal=QHea_flow_nominal,
    each final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    each final T_aHeaWat_nominal=T_aHeaWat_nominal,
    each final T_bHeaWat_nominal=T_bHeaWat_nominal,
    each final T_aLoaHea_nominal=T_aLoaHea_nominal,
    each final have_speVar=false)
    "Heating terminal unit"
    annotation (Placement(transformation(extent={{50,-122},{70,-102}})));
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(
      filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(
      each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Reader for thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(
    k=20+273.15,
    y(
      final unit="K",
      displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    nout=nLoa)
    "Repeat input to output an array"
    annotation (Placement(transformation(extent={{-128,60},{-108,80}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep1(
    nout=nLoa)
    "Repeat input to output an array"
    annotation (Placement(transformation(extent={{-128,20},{-108,40}})));
  BaseClasses.Distribution2Pipe dis(
    redeclare final package Medium=Medium1,
    final nCon=nLoa,
    final allowFlowReversal=false,
    final iConDpSen=nLoa,
    final mDis_flow_nominal=m_flow_nominal,
    final mCon_flow_nominal=mCon_flow_nominal,
    final dpDis_nominal=dpDis_nominal)
    "Distribution network"
    annotation (Placement(transformation(extent={{40,-180},{80,-160}})));
  Fluid.Movers.FlowControlled_dp pumCstDp(
    redeclare package Medium=Medium1,
    per(
      final motorCooledByFluid=false),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=dp_nominal,
    prescribeSystemPressure=true)
    "Pump controlled to track a pressure drop over the last connected load"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  Fluid.MixingVolumes.MixingVolume vol(
    final prescribedHeatFlowRate=true,
    redeclare final package Medium=Medium1,
    V=m_flow_nominal*tau/rho_default,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    "Volume for fluid stream"
    annotation (Placement(transformation(extent={{-59,-160},{-39,-140}})));
  Fluid.Sources.Boundary_pT supHeaWat1(
    redeclare package Medium=Medium1,
    use_T_in=true,
    nPorts=3)
    "Heating water source"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-130,0})));
  Buildings.Experimental.DHC.Loads.FlowDistribution disCstDp(
    redeclare package Medium=Medium1,
    m_flow_nominal=m_flow_nominal,
    have_pum=true,
    typCtr=Buildings.Experimental.DHC.Loads.Types.PumpControlType.ConstantDp,
    dp_nominal=dp_nominal,
    dpDis_nominal=dpDis_nominal,
    dpMin=dpSet,
    mUni_flow_nominal=mCon_flow_nominal,
    nPorts_a1=nLoa,
    nPorts_b1=nLoa)
    "Distribution system with pump controlled to track a pressure drop over the last connected unit"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare package Medium=Medium1,
    p=300000,
    nPorts=3)
    "Sink for heating water"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={150,0})));
  BaseClasses.FanCoil2PipeHeating terUniHea1[nLoa](
    redeclare each final package Medium1=Medium1,
    redeclare each final package Medium2=Medium2,
    each final facSca=facSca,
    each final QHea_flow_nominal=QHea_flow_nominal,
    each final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    each final T_aHeaWat_nominal=T_aHeaWat_nominal,
    each final T_bHeaWat_nominal=T_bHeaWat_nominal,
    each final T_aLoaHea_nominal=T_aLoaHea_nominal,
    each final have_speVar=false)
    "Heating terminal unit"
    annotation (Placement(transformation(extent={{-10,-22},{10,-2}})));
  Fluid.Movers.SpeedControlled_y pumCstSpe(
    redeclare package Medium=Medium1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per(
      pressure(
        V_flow=m_flow_nominal/rho_default .* {0,1,2},
        dp=dp_nominal .* {1.5,1,0.5})),
    addPowerToMedium=false,
    use_inputFilter=false)
    "Pump controlled at constant speed"
    annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
  Fluid.Movers.BaseClasses.IdealSource pipPre(
    redeclare final package Medium=Medium1,
    dp_start=dp_nominal,
    m_flow_start=m_flow_nominal,
    m_flow_small=1E-4*m_flow_nominal,
    final show_T=false,
    final show_V_flow=false,
    final control_m_flow=true,
    final control_dp=false)
    "Fictitious pipe used to prescribe pump flow rate"
    annotation (Placement(transformation(extent={{-8,170},{12,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one1(
    k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-180,190},{-160,210}})));
  BaseClasses.FanCoil2PipeHeating terUniHea2[nLoa](
    redeclare each final package Medium1=Medium1,
    redeclare each final package Medium2=Medium2,
    each final facSca=facSca,
    each final QHea_flow_nominal=QHea_flow_nominal,
    each final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    each final T_aHeaWat_nominal=T_aHeaWat_nominal,
    each final T_bHeaWat_nominal=T_bHeaWat_nominal,
    each final T_aLoaHea_nominal=T_aLoaHea_nominal,
    each final have_speVar=false)
    "Heating terminal unit"
    annotation (Placement(transformation(extent={{-10,118},{10,138}})));
  Buildings.Experimental.DHC.Loads.FlowDistribution disCstSpe(
    redeclare package Medium=Medium1,
    m_flow_nominal=m_flow_nominal,
    have_pum=true,
    typCtr=Buildings.Experimental.DHC.Loads.Types.PumpControlType.ConstantSpeed,
    dp_nominal=dp_nominal,
    dpDis_nominal=dpDis_nominal,
    dpMin=dpSet,
    mUni_flow_nominal=mCon_flow_nominal,
    nPorts_a1=5,
    nPorts_b1=5)
    "Distribution system with pump controlled at constant speed"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSup(
    k=T_aHeaWat_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium=Medium1,
    use_T_in=true,
    nPorts=2)
    "Heating water source"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-130,-180})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setDp(
    k=dpSet)
    "Pressure difference set-point"
    annotation (Placement(transformation(extent={{-180,-140},{-160,-120}})));
protected
  parameter Medium1.ThermodynamicState sta_default=Medium1.setState_pTX(
    T=Medium1.T_default,
    p=Medium1.p_default,
    X=Medium1.X_default);
  parameter Modelica.SIunits.Density rho_default=Medium1.density(
    sta_default)
    "Density, used to compute fluid volume";
equation
  connect(loa.y[2],reaRep1.u)
    annotation (Line(points={{-159,30},{-130,30}},color={0,0,127}));
  connect(reaRep.y,terUniHea.TSetHea)
    annotation (Line(points={{-106,70},{-40,70},{-40,-106},{49.1667,-106},{49.1667,-107}},color={0,0,127}));
  connect(reaRep1.y,terUniHea.QReqHea_flow)
    annotation (Line(points={{-106,30},{-46,30},{-46,-113.667},{49.1667,-113.667}},color={0,0,127}));
  connect(terUniHea.port_bHeaWat,dis.ports_aCon)
    annotation (Line(points={{70,-120.333},{70,-120},{80,-120},{80,-140},{72,-140},{72,-160}},color={0,127,255}));
  connect(dis.ports_bCon,terUniHea.port_aHeaWat)
    annotation (Line(points={{48,-160},{48,-140},{40,-140},{40,-120.333},{50,-120.333}},color={0,127,255}));
  connect(pumCstDp.port_b,dis.port_aDisSup)
    annotation (Line(points={{10,-160},{20,-160},{20,-170},{40,-170}},color={0,127,255}));
  connect(vol.ports[1],pumCstDp.port_a)
    annotation (Line(points={{-51,-160},{-10,-160}},color={0,127,255}));
  connect(disCstDp.port_b,sinHeaWat.ports[1])
    annotation (Line(points={{10,-60},{120,-60},{120,2.66667},{140,2.66667}},color={0,127,255}));
  connect(supHeaWat1.ports[1],disCstDp.port_a)
    annotation (Line(points={{-120,2.66667},{-100,2.66667},{-100,-60},{-10,-60}},color={0,127,255}));
  connect(terUniHea1.port_bHeaWat,disCstDp.ports_a1)
    annotation (Line(points={{10,-20.3333},{20,-20.3333},{20,-54},{10,-54}},color={0,127,255}));
  connect(disCstDp.ports_b1,terUniHea1.port_aHeaWat)
    annotation (Line(points={{-10,-54},{-20,-54},{-20,-20.3333},{-10,-20.3333}},color={0,127,255}));
  connect(reaRep.y,terUniHea1.TSetHea)
    annotation (Line(points={{-106,70},{-40,70},{-40,-7},{-10.8333,-7}},color={0,0,127}));
  connect(reaRep1.y,terUniHea1.QReqHea_flow)
    annotation (Line(points={{-106,30},{-46,30},{-46,-13.6667},{-10.8333,-13.6667},{-10.8333,-13.6667}},color={0,0,127}));
  connect(terUniHea1.mReqHeaWat_flow,disCstDp.mReq_flow)
    annotation (Line(points={{10.8333,-15.3333},{26,-15.3333},{26,-80},{-20,-80},{-20,-64},{-11,-64}},color={0,0,127}));
  connect(supHeaWat1.ports[2],pumCstSpe.port_a)
    annotation (Line(points={{-120,-2.22045e-16},{-100,-2.22045e-16},{-100,180},{-80,180}},color={0,127,255}));
  connect(pumCstSpe.port_b,pipPre.port_a)
    annotation (Line(points={{-60,180},{-8,180}},color={0,127,255}));
  connect(pipPre.port_b,sinHeaWat.ports[2])
    annotation (Line(points={{12,180},{120,180},{120,0},{140,0}},color={0,127,255}));
  connect(one1.y,pumCstSpe.y)
    annotation (Line(points={{-158,200},{-70,200},{-70,192}},color={0,0,127}));
  connect(supHeaWat1.ports[3],disCstSpe.port_a)
    annotation (Line(points={{-120,-2.66667},{-116,-2.66667},{-116,-2},{-100,-2},{-100,80},{-10,80}},color={0,127,255}));
  connect(disCstSpe.port_b,sinHeaWat.ports[3])
    annotation (Line(points={{10,80},{120,80},{120,-2.66667},{140,-2.66667}},color={0,127,255}));
  connect(disCstSpe.ports_b1[1:5],terUniHea2.port_aHeaWat)
    annotation (Line(points={{-10,89.2},{-20,89.2},{-20,120},{-10,120},{-10,119.667}},color={0,127,255}));
  connect(terUniHea2.port_bHeaWat,disCstSpe.ports_a1[1:5])
    annotation (Line(points={{10,119.667},{20,119.667},{20,89.2},{10,89.2}},color={0,127,255}));
  connect(terUniHea2.mReqHeaWat_flow,disCstSpe.mReq_flow)
    annotation (Line(points={{10.8333,124.667},{26,124.667},{26,60},{-20,60},{-20,76},{-11,76}},color={0,0,127}));
  connect(reaRep.y,terUniHea2.TSetHea)
    annotation (Line(points={{-106,70},{-40,70},{-40,132},{-10.8333,132},{-10.8333,133}},color={0,0,127}));
  connect(reaRep1.y,terUniHea2.QReqHea_flow)
    annotation (Line(points={{-106,30},{-46,30},{-46,126},{-10.8333,126},{-10.8333,126.333}},color={0,0,127}));
  connect(disCstSpe.mReqTot_flow,pipPre.m_flow_in)
    annotation (Line(points={{11,76},{40,76},{40,200},{-4,200},{-4,188}},color={0,0,127}));
  connect(THeaWatSup.y,supHeaWat1.T_in)
    annotation (Line(points={{-158,0},{-152,0},{-152,4},{-142,4}},color={0,0,127}));
  connect(dis.port_bDisRet,supHeaWat.ports[1])
    annotation (Line(points={{40,-176},{20,-176},{20,-200},{-120,-200},{-120,-178}},color={0,127,255}));
  connect(supHeaWat.ports[2],vol.ports[2])
    annotation (Line(points={{-120,-182},{-120,-174},{-80,-174},{-80,-160},{-47,-160}},color={0,127,255}));
  connect(THeaWatSup.y,supHeaWat.T_in)
    annotation (Line(points={{-158,0},{-152,0},{-152,-176},{-142,-176}},color={0,0,127}));
  connect(minTSet.y,reaRep.u)
    annotation (Line(points={{-158,70},{-130,70}},color={0,0,127}));
  connect(dis.dp,pumCstDp.dpMea)
    annotation (Line(points={{81,-167},{120,-167},{120,-190},{-20,-190},{-20,-140},{-8,-140},{-8,-148}},color={0,0,127}));
  connect(setDp.y,pumCstDp.dp_in)
    annotation (Line(points={{-158,-130},{0,-130},{0,-148}},color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
This model validates the pump head computation algorithm implemented in
<a href=\"modelica://Buildings.Experimental.DHC.Loads.FlowDistribution\">
Buildings.Experimental.DHC.Loads.FlowDistribution</a>.
</p>
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
      StopTime=400000,
      Tolerance=1e-06),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-220,-240},{200,240}})),
    __Dymola_Commands(
      file="Resources/Scripts/Dymola/Experimental/DHC/Loads/Validation/FlowDistributionPumpControl.mos" "Simulate and plot"));
end FlowDistributionPumpControl;
