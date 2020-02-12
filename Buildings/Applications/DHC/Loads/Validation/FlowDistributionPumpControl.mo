within Buildings.Applications.DHC.Loads.Validation;
model FlowDistributionPumpControl
  "Validation of the pump head computation in the flow distribution model"
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
  parameter Modelica.SIunits.PressureDifference dpDis_nominal[nLoa](
    min=0, displayUnit="Pa")=
    1/2 .* cat(1, {dp_nominal*0.2}, fill(dp_nominal*0.8 / (nLoa-1), nLoa-1))
    "Pressure drop between each connected unit at nominal conditions (supply line)";
  parameter Modelica.SIunits.PressureDifference dpSet=max(terUniHea.dp_nominal)
    "Pressure difference setpoint";
  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal=
    sum(terUniHea.mHeaWat_flow_nominal)
    "Nominal mass flow rate in the distribution line";
  final parameter Modelica.SIunits.PressureDifference dp_nominal=
    max(terUniHea.dp_nominal) + 2 * nLoa * 5000
    "Nominal pressure drop in the distribution line";
  final parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal=
    Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.getPeakLoad(
      string="#Peak space heating load",
      filNam=Modelica.Utilities.Files.loadResource(filPat))
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Nominal condition"));
  BaseClasses.FanCoil2PipeHeatingValve terUniHea[nLoa](
    redeclare each final package Medium1 = Medium1,
    redeclare each final package Medium2 = Medium2,
    each final QHea_flow_nominal=QHea_flow_nominal,
    each final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    each final T_aHeaWat_nominal=T_aHeaWat_nominal,
    each final T_bHeaWat_nominal=T_bHeaWat_nominal,
    each final T_aLoaHea_nominal=T_aLoaHea_nominal,
    each final have_speVar=false)
    "Heating terminal unit"
    annotation (Placement(transformation(extent={{40,-122},{60,-102}})));
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
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20)
    "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=nLoa)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep1(nout=nLoa)
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup(y=T_aHeaWat_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-140,-174},{-120,-154}})));
  Fluid.Sources.Boundary_pT supHeaWat(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=2) "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-160})));
  BaseClasses.Distribution2Pipe dis(
    redeclare final package Medium = Medium1,
    nCon=nLoa,
    allowFlowReversal=false,
    iConDpSen=nLoa,
    mDis_flow_nominal={sum(terUniHea[i:nLoa].mHeaWat_flow_nominal) for i in 1:
        nLoa},
    mCon_flow_nominal=terUniHea.mHeaWat_flow_nominal,
    dpDis_nominal=dpDis_nominal)
    annotation (Placement(transformation(extent={{0,-170},{40,-150}})));
  Fluid.Movers.FlowControlled_dp pum(
    redeclare package Medium = Medium1,
    per(final motorCooledByFluid=false),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{-30,-170},{-10,-150}})));
  Fluid.MixingVolumes.MixingVolume vol(
    final prescribedHeatFlowRate=true,
    redeclare final package Medium = Medium1,
    V=m_flow_nominal*tau/rho_default,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    "Volume for fluid stream"
     annotation (Placement(transformation(extent={{-71,-160},{-51,-140}})));
  Fluid.Sources.Boundary_pT           supHeaWat1(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=1) "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,60})));
  Modelica.Blocks.Sources.RealExpression THeaWatSup1(y=T_aHeaWat_nominal)
    "Heating water supply temperature"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    redeclare package Medium = Medium1,
    m_flow_nominal=m_flow_nominal,
    have_pum=true,
    typCtr=Buildings.Applications.DHC.Loads.Types.PumpControlType.ConstantDp,
    dp_nominal=dp_nominal,
    dpDis_nominal=dpDis_nominal,
    dpMin=dpSet,
    mUni_flow_nominal=terUniHea1.mHeaWat_flow_nominal,
    nPorts_a1=nLoa,
    nPorts_b1=nLoa)
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Fluid.Sources.Boundary_pT sinHeaWat(
    redeclare package Medium = Medium1,
    p=300000,
    nPorts=1) "Sink for heating water" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={150,60})));
  Buildings.Controls.Continuous.LimPID conPID(controllerType=Modelica.Blocks.Types.SimpleController.PI)
    annotation (Placement(transformation(extent={{-110,-130},{-90,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=dp_nominal)
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=1/dpSet)
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1)
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  BaseClasses.FanCoil2PipeHeating terUniHea1 [nLoa](
    redeclare each final package Medium1 = Medium1,
    redeclare each final package Medium2 = Medium2,
    each final QHea_flow_nominal=QHea_flow_nominal,
    each final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    each final T_aHeaWat_nominal=T_aHeaWat_nominal,
    each final T_bHeaWat_nominal=T_bHeaWat_nominal,
    each final T_aLoaHea_nominal=T_aLoaHea_nominal,
    each final have_speVar=false)
    "Heating terminal unit"
    annotation (Placement(transformation(extent={{-10,98},{10,118}})));
protected
  parameter Medium1.ThermodynamicState sta_default=Medium1.setState_pTX(
      T=Medium1.T_default,
      p=Medium1.p_default,
      X=Medium1.X_default);
  parameter Modelica.SIunits.Density rho_default=Medium1.density(sta_default)
    "Density, used to compute fluid volume";
equation
  connect(loa.y[2], reaRep1.u)
    annotation (Line(points={{-159,-40},{-142,-40}},
                                               color={0,0,127}));
  connect(minTSet.y, from_degC1.u)
    annotation (Line(points={{-158,30},{-142,30}},
                                                 color={0,0,127}));
  connect(from_degC1.y, reaRep.u)
    annotation (Line(points={{-118,30},{-102,30}},
                                                 color={0,0,127}));
  connect(reaRep.y, terUniHea.TSetHea) annotation (Line(points={{-78,30},{-40,
          30},{-40,-106},{39.1667,-106},{39.1667,-107}},
                                          color={0,0,127}));
  connect(reaRep1.y, terUniHea.QReqHea_flow) annotation (Line(points={{-118,-40},
          {-46,-40},{-46,-113.667},{39.1667,-113.667},{39.1667,-113.667}},
                                     color={0,0,127}));
  connect(THeaWatSup.y, supHeaWat.T_in) annotation (Line(points={{-119,-164},{-112,
          -164},{-112,-156},{-102,-156}},
                                     color={0,0,127}));
  connect(terUniHea.port_bHeaWat, dis.ports_aCon) annotation (Line(points={{60,
          -120.333},{60,-120},{80,-120},{80,-140},{32,-140},{32,-150}},
                                                                color={0,127,255}));
  connect(dis.ports_bCon, terUniHea.port_aHeaWat) annotation (Line(points={{8,-150},
          {8,-120},{40,-120},{40,-120.333}},        color={0,127,255}));
  connect(pum.port_b, dis.port_aDisSup)
    annotation (Line(points={{-10,-160},{0,-160}},
                                                 color={0,127,255}));
  connect(dis.port_bDisRet, supHeaWat.ports[1]) annotation (Line(points={{0,-166},
          {-8,-166},{-8,-180},{-80,-180},{-80,-158}},
                                                  color={0,127,255}));
  connect(vol.ports[1], pum.port_a)
    annotation (Line(points={{-63,-160},{-30,-160}},
                                                 color={0,127,255}));
  connect(supHeaWat.ports[2], vol.ports[2]) annotation (Line(points={{-80,-162},
          {-80,-160},{-59,-160}},        color={0,127,255}));
  connect(disFloHea.port_b, sinHeaWat.ports[1])
    annotation (Line(points={{10,60},{140,60}}, color={0,127,255}));
  connect(supHeaWat1.ports[1], disFloHea.port_a)
    annotation (Line(points={{-120,60},{-10,60}}, color={0,127,255}));
  connect(THeaWatSup1.y, supHeaWat1.T_in) annotation (Line(points={{-159,60},{-152,
          60},{-152,64},{-142,64}}, color={0,0,127}));
  connect(conPID.y, gai.u)
    annotation (Line(points={{-89,-120},{-82,-120}}, color={0,0,127}));
  connect(gai.y, pum.dp_in) annotation (Line(points={{-58,-120},{-20,-120},{-20,
          -148}}, color={0,0,127}));
  connect(dis.dp, gai1.u) annotation (Line(points={{41,-154},{60,-154},{60,-190},
          {-160,-190},{-160,-140},{-142,-140}}, color={0,0,127}));
  connect(gai1.y, conPID.u_m) annotation (Line(points={{-118,-140},{-100,-140},{
          -100,-132}}, color={0,0,127}));
  connect(one.y, conPID.u_s)
    annotation (Line(points={{-158,-120},{-112,-120}}, color={0,0,127}));
  connect(terUniHea1.port_bHeaWat, disFloHea.ports_a1) annotation (Line(
        points={{10,99.6667},{20,99.6667},{20,66},{10,66}},
        color={0,127,255}));
  connect(disFloHea.ports_b1, terUniHea1.port_aHeaWat) annotation (Line(
        points={{-10,66},{-20,66},{-20,99.6667},{-10,99.6667}},
        color={0,127,255}));
  connect(reaRep.y, terUniHea1.TSetHea) annotation (Line(points={{-78,30},{-40,
          30},{-40,113},{-10.8333,113}},
                                     color={0,0,127}));
  connect(reaRep1.y, terUniHea1.QReqHea_flow) annotation (Line(points={{-118,
          -40},{-46,-40},{-46,106},{-30,106},{-30,106.333},{-10.8333,106.333}},
        color={0,0,127}));
  connect(terUniHea1.mReqHeaWat_flow, disFloHea.mReq_flow) annotation (Line(
        points={{10.8333,104.667},{40,104.667},{40,40},{-20,40},{-20,56},{-11,
          56}},
        color={0,0,127}));
    annotation (Placement(transformation(extent={{40,-90},{80,-70}})),
    experiment(
      StopTime=400000,
      __Dymola_NumberOfIntervals=500,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-200},{180,
            200}})),
    __Dymola_Commands(file=
          "Resources/Scripts/Dymola/Applications/DHC/Loads/Validation/FlowDistributionPumpControl.mos"
        "Simulate and plot"));
end FlowDistributionPumpControl;
