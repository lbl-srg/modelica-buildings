within Buildings.Experimental.DHC.Networks.Examples;
model Distribution1PipeExample
  "Example of distribution network with 1 pipe for Distribution1PipeAutosize and Distribution1PipePlugFlow"
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
  final parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal[nLoa]=
      terAutoSize.mHeaWat_flow_nominal*facMul
    "Nominal mass flow rate in each connection line";
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=sum(
      mCon_flow_nominal) "Nominal mass flow rate in the distribution line";
  final parameter Modelica.Units.SI.PressureDifference dp_nominal=sum(
      disAutoSize.con.pipDis.dp_nominal) + max(terAutoSize.dpSou_nominal)
    "Nominal pressure drop in the distribution line";
  final parameter Modelica.Units.SI.HeatFlowRate QHea_flow_nominal=
      Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(string="#Peak space heating load", filNam=
      Modelica.Utilities.Files.loadResource(filNam))/facMul
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Design parameter"));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.FanCoil2PipeHeatingValve
    terAutoSize[nLoa](
    each final facMul=facMul,
    redeclare each final package Medium1 = Medium1,
    redeclare each final package Medium2 = Medium2,
    each final QHea_flow_nominal=QHea_flow_nominal,
    each final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    each final T_aHeaWat_nominal=T_aHeaWat_nominal,
    each final T_bHeaWat_nominal=T_bHeaWat_nominal,
    each final T_aLoaHea_nominal=T_aLoaHea_nominal) "Heating terminal unit"
    annotation (Placement(transformation(extent={{50,86},{70,106}})));
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
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant minTSet(
    k=293.15,
    y(final unit="K",
      displayUnit="degC"))
    "Minimum temperature set point"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    nout=nLoa)
    "Repeat input to output an array"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep1(
    nout=nLoa)
    "Repeat input to output an array"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.Sources.Boundary_pT supHeaWatAutoSize(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=2) "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,10})));
  Buildings.Experimental.DHC.Networks.Distribution1PipeAutoSize disAutoSize(
    redeclare final package Medium = Medium1,
    nCon=nLoa,
    allowFlowReversal=false,
    mDis_flow_nominal=m_flow_nominal,
    mCon_flow_nominal=mCon_flow_nominal,
    lDis=fill(6, nLoa),
    lEnd=1) annotation (Placement(transformation(extent={{40,20},{80,40}})));
  Buildings.Fluid.Movers.FlowControlled_dp pumAutoSize(
    redeclare package Medium = Medium1,
    per(final motorCooledByFluid=false),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpPum(
    k=dp_nominal)
    "Prescribed head"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSup(k=max(
        terAutoSize.T_aHeaWat_nominal)) "Supply temperature"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.FanCoil2PipeHeatingValve terPlugFlow[nLoa](
    each final facMul=facMul,
    redeclare each final package Medium1 = Medium1,
    redeclare each final package Medium2 = Medium2,
    each final QHea_flow_nominal=QHea_flow_nominal,
    each final mLoaHea_flow_nominal=mLoaHea_flow_nominal,
    each final T_aHeaWat_nominal=T_aHeaWat_nominal,
    each final T_bHeaWat_nominal=T_bHeaWat_nominal,
    each final T_aLoaHea_nominal=T_aLoaHea_nominal) "Heating terminal unit"
    annotation (Placement(transformation(extent={{50,-16},{70,4}})));
  Buildings.Experimental.DHC.Networks.Distribution1PipePlugFlow disPlugFlow(
    nCon=nLoa,
    redeclare final package Medium = Medium1,
    allowFlowReversal=false,
    mDis_flow_nominal=m_flow_nominal,
    mCon_flow_nominal=mCon_flow_nominal,
    lDis=fill(6, nLoa),
    lEnd=1,
    dIns=0.02,
    kIns=0.2)
            annotation (Placement(transformation(extent={{40,-80},{80,-60}})));
  Buildings.Fluid.Movers.FlowControlled_dp pumPlugFlow(
    redeclare package Medium = Medium1,
    per(final motorCooledByFluid=false),
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Fluid.Sources.Boundary_pT supHeaWatPlugFlow(
    redeclare package Medium = Medium1,
    use_T_in=true,
    nPorts=2) "Heating water supply" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-38,-98})));
  Fluid.FixedResistances.BuriedPipes.PipeGroundCoupling pipeGroundCouplingSup(
    lPip=6,
    rPip=0.04,
    thiGroLay=1.1,
    nSta=5,
    nSeg=nLoa + 1) annotation (Placement(transformation(
        extent={{-11,10},{11,-10}},
        rotation=0,
        origin={61,-100})));
  EnergyTransferStations.BaseClasses.Pump_m_flow pumConAutoSize[nLoa](
    each dp_nominal=5000,
    redeclare final package Medium = Medium1,
    each m_flow_nominal=mLoaHea_flow_nominal) "Distribution network pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={72,60})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep2(nout=nLoa)
    "Repeat input to output an array"
    annotation (Placement(transformation(extent={{114,50},{94,70}})));
  Modelica.Blocks.Sources.RealExpression mFlowConAutosize(y=terAutoSize[1].val.y_actual
        *mLoaHea_flow_nominal)
    annotation (Placement(transformation(extent={{140,50},{120,70}})));
  EnergyTransferStations.BaseClasses.Pump_m_flow pumConPlugFlow[nLoa](
    each dp_nominal=5000,
    redeclare final package Medium = Medium1,
    each m_flow_nominal=mLoaHea_flow_nominal) "Distribution network pump"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={72,-40})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep3(nout=nLoa)
    "Repeat input to output an array"
    annotation (Placement(transformation(extent={{114,-50},{94,-30}})));
  Modelica.Blocks.Sources.RealExpression mFlowConPlugFlow(y=terPlugFlow[1].val.y_actual
        *mLoaHea_flow_nominal)
    annotation (Placement(transformation(extent={{140,-50},{120,-30}})));
protected
  parameter Medium1.ThermodynamicState sta_default=Medium1.setState_pTX(
    T=Medium1.T_default,
    p=Medium1.p_default,
    X=Medium1.X_default);
  parameter Modelica.Units.SI.Density rho_default=Medium1.density(sta_default)
    "Density, used to compute fluid volume";
equation
  connect(loa.y[2],reaRep1.u)
    annotation (Line(points={{-79,70},{-62,70}},
                                              color={0,0,127}));
  connect(reaRep.y, terAutoSize.TSetHea) annotation (Line(points={{-38,100},{40,
          100},{40,101},{49.1667,101}},
                                      color={0,0,127}));
  connect(reaRep1.y, terAutoSize.QReqHea_flow) annotation (Line(points={{-38,70},
          {40,70},{40,94.3333},{49.1667,94.3333}}, color={0,0,127}));
  connect(disAutoSize.ports_bCon, terAutoSize.port_aHeaWat) annotation (Line(
        points={{48,40},{46,40},{46,87.6667},{50,87.6667}}, color={0,127,255}));
  connect(pumAutoSize.port_b, disAutoSize.port_aDisSup)
    annotation (Line(points={{20,30},{40,30}}, color={0,127,255}));
  connect(THeaWatSup.y, supHeaWatAutoSize.T_in) annotation (Line(points={{-78,10},
          {-72,10},{-72,14},{-62,14}}, color={0,0,127}));
  connect(dpPum.y, pumAutoSize.dp_in) annotation (Line(points={{-78,40},{-60,40},
          {-60,52},{10,52},{10,42}}, color={0,0,127}));
  connect(reaRep.u,minTSet.y)
    annotation (Line(points={{-62,100},{-78,100}},
                                                color={0,0,127}));
  connect(reaRep.y, terPlugFlow.TSetHea) annotation (Line(points={{-38,100},{30,
          100},{30,-1},{49.1667,-1}},                 color={0,0,127}));
  connect(reaRep1.y, terPlugFlow.QReqHea_flow) annotation (Line(points={{-38,70},
          {26,70},{26,-7.66667},{49.1667,-7.66667}}, color={0,0,127}));
  connect(disPlugFlow.ports_bCon, terPlugFlow.port_aHeaWat) annotation (Line(
        points={{48,-60},{46,-60},{46,-14.3333},{50,-14.3333}},          color={
          0,127,255}));
  connect(pumPlugFlow.port_b, disPlugFlow.port_aDisSup)
    annotation (Line(points={{20,-70},{40,-70}}, color={0,127,255}));
  connect(dpPum.y, pumPlugFlow.dp_in) annotation (Line(points={{-78,40},{-68,40},
          {-68,-46},{10,-46},{10,-58}},                 color={0,0,127}));
  connect(THeaWatSup.y, supHeaWatPlugFlow.T_in) annotation (Line(points={{-78,10},
          {-74,10},{-74,-92},{-50,-92},{-50,-94}}, color={0,0,127}));
  connect(pipeGroundCouplingSup.heatPorts, disPlugFlow.heatPorts) annotation (
      Line(points={{61,-95},{61,-94},{60,-94},{60,-84},{60.4,-84},{60.4,-72.2}},
                                                               color={127,0,0}));
  connect(disAutoSize.port_bDisSup, supHeaWatAutoSize.ports[1]) annotation (
      Line(points={{80,30},{88,30},{88,8},{-40,8},{-40,9}},  color={0,127,255}));
  connect(disPlugFlow.port_bDisSup, supHeaWatPlugFlow.ports[1]) annotation (
      Line(points={{80,-70},{92,-70},{92,-116},{-28,-116},{-28,-99}}, color={0,127,
          255}));
  connect(terAutoSize.port_bHeaWat,pumConAutoSize. port_a) annotation (Line(
        points={{70,87.6667},{72,87.6667},{72,70}},                 color={0,127,
          255}));
  connect(pumConAutoSize.port_b, disAutoSize.ports_aCon) annotation (Line(
        points={{72,50},{72,40}},                 color={0,127,255}));
  connect(mFlowConAutosize.y, reaRep2.u)
    annotation (Line(points={{119,60},{116,60}}, color={0,0,127}));
  connect(reaRep2.y, pumConAutoSize.m_flow_in)
    annotation (Line(points={{92,60},{84,60}}, color={0,0,127}));
  connect(pumConPlugFlow.port_a, terPlugFlow.port_bHeaWat) annotation (Line(
        points={{72,-30},{72,-14.3333},{70,-14.3333}}, color={0,127,255}));
  connect(pumConPlugFlow.port_b, disPlugFlow.ports_aCon)
    annotation (Line(points={{72,-50},{72,-60}}, color={0,127,255}));
  connect(pumConPlugFlow.m_flow_in, reaRep3.y)
    annotation (Line(points={{84,-40},{92,-40}}, color={0,0,127}));
  connect(reaRep3.u, mFlowConPlugFlow.y)
    annotation (Line(points={{116,-40},{119,-40}}, color={0,0,127}));
  connect(pumAutoSize.port_a, supHeaWatAutoSize.ports[2]) annotation (Line(
        points={{0,30},{-20,30},{-20,11},{-40,11}}, color={0,127,255}));
  connect(pumPlugFlow.port_a, supHeaWatPlugFlow.ports[2]) annotation (Line(
        points={{0,-70},{-20,-70},{-20,-97},{-28,-97}}, color={0,127,255}));
  annotation (
    Documentation(
      info="<html>
<p>
Example model of two one-pipe distribution models that could be used i.e for building a reservoir network to connect several agents in series.  It showcases 
<a href=\"modelica://Buildings.Experimental.DHC.Networks.Distribution1PipeAutoSize\">
Buildings.Experimental.DHC.Networks.Distribution1PipeAutoSize</a> and 
<a href=\"modelica://Buildings.Experimental.DHC.Networks.Distribution1PipePlugFlow\">
Buildings.Experimental.DHC.Networks.Distribution1PipePlugFlow</a>. The distribution models create a vector of nLoa connection models <a href=\"modelica://Buildings.Experimental.DHC.Networks.Connections\">
Buildings.Experimental.DHC.Networks.Connections</a> that are connected to a vector of nLoa agents made up by time series heating loads <a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.FanCoil2PipeHeatingValve\">
Buildings.Experimental.DHC.Loads.BaseClasses.Validation.BaseClasses.FanCoil2PipeHeatingValve</a>. Each agent will draw water from the distribution pipe and release it in the same pipe.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 22, 2024, by Ettore Zanetti:<br/>
First implementation.
</li>
</ul>
</html>"),
    experiment(
      StopTime=3600,
      Tolerance=1e-06),
    Icon(
      coordinateSystem(
        preserveAspectRatio=false, extent={{-120,-120},{140,120}})),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-120,-120},{140,120}})),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Networks/Examples/Distribution1PipeExample.mos" "Simulate and plot"));
end Distribution1PipeExample;
