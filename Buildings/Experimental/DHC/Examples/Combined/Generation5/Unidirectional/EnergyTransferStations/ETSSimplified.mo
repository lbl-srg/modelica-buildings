within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.EnergyTransferStations;
model ETSSimplified
  "Simplified model of a substation producing heating hot water (heat pump) and chilled water (HX)"
  extends
    Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.PartialETS(
    final have_weaBus=false,
    final have_chiWat=true,
    final have_heaWat=true,
    final have_hotWat=false,
    final have_eleHea=true,
    final have_eleCoo=false,
    final have_pum=true,
    final have_fan=false,
    nPorts_aHeaWat=1,
    nPorts_bHeaWat=1,
    nPorts_aChiWat=1,
    nPorts_bChiWat=1);
  outer
    Data.DesignDataSeries datDes "DHC systenm design data";
  // SYSTEM GENERAL
  parameter Modelica.SIunits.TemperatureDifference dT_nominal = 5
    "Water temperature drop/increase accross load and source-side HX (always positive)"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature TChiWatSup_nominal = 273.15 + 18
    "Chilled water supply temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature TChiWatRet_nominal=
    TChiWatSup_nominal + dT_nominal
    "Chilled water return temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature THeaWatSup_nominal = 273.15 + 40
    "Heating water supply temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Temperature THeaWatRet_nominal=
    THeaWatSup_nominal - dT_nominal
    "Heating water return temperature"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa") = 50000
    "Pressure difference at nominal flow rate (for each flow leg)"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate mHeaWat_flow_nominal(min=0)=
    abs(QHeaWat_flow_nominal / cp_default / (THeaWatSup_nominal - THeaWatRet_nominal))
    "Heating water mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal(min=0)=
    abs(QChiWat_flow_nominal / cp_default / (TChiWatSup_nominal - TChiWatRet_nominal))
    "Heating water mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    MediumBui.specificHeatCapacityCp(MediumBui.setState_pTX(
      p = MediumBui.p_default,
      T = MediumBui.T_default,
      X = MediumBui.X_default))
    "Specific heat capacity of the fluid";
  // HEAT PUMP
  parameter Real COP_nominal(unit="1") = 5
    "Heat pump COP"
    annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.Temperature TConLvg_nominal = THeaWatSup_nominal
    "Condenser leaving temperature"
     annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.Temperature TConEnt_nominal = THeaWatRet_nominal
    "Condenser entering temperature"
     annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.Temperature TEvaLvg_nominal=
    TEvaEnt_nominal - dT_nominal
    "Evaporator leaving temperature"
     annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.Temperature TEvaEnt_nominal = datDes.TLooMin
    "Evaporator entering temperature"
     annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate mCon_flow_nominal(min=0)=
    abs(QHeaWat_flow_nominal / cp_default / (TConLvg_nominal - TConEnt_nominal))
    "Condenser mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate mEva_flow_nominal(min=0)=
    abs(heaPum.QEva_flow_nominal / cp_default / (TEvaLvg_nominal - TEvaEnt_nominal))
    "Evaporator mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  // CHW HX
  final parameter Modelica.SIunits.Temperature T1HexChiEnt_nominal=
    datDes.TLooMax
    "CHW HX primary entering temperature"
     annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.Temperature T2HexChiEnt_nominal=
    TChiWatRet_nominal
    "CHW HX secondary entering temperature"
     annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate m1HexChi_flow_nominal(min=0)=
    abs(QChiWat_flow_nominal / cp_default / dT_nominal)
    "CHW HX primary mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate m2HexChi_flow_nominal(min=0)=
    abs(QChiWat_flow_nominal / cp_default / (THeaWatSup_nominal - THeaWatRet_nominal))
    "CHW HX secondary mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  // Diagnostics
   parameter Boolean show_T = true
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
  parameter Modelica.Fluid.Types.Dynamics mixingVolumeEnergyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Formulation of energy balance for mixing volume at inlet and outlet"
     annotation(Dialog(tab="Dynamics"));
  // IO CONNECTORS
  Modelica.Blocks.Interfaces.RealInput TSetHeaWat
    "Heating water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,80}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,40})));
  Modelica.Blocks.Interfaces.RealInput TSetChiWat "Chilled water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,-80}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,-40})));
  Modelica.Blocks.Interfaces.RealOutput mHea_flow
    "District water mass flow rate used for heating service"
    annotation ( Placement(transformation(extent={{300,-160},{340,-120}}),
        iconTransformation(extent={{300,-142},{340,-102}})));
  Modelica.Blocks.Interfaces.RealOutput mCoo_flow
    "District water mass flow rate used for cooling service"
    annotation ( Placement(transformation(extent={{300,-200},{340,-160}}),
        iconTransformation(extent={{300,-182},{340,-142}})));
  Modelica.Blocks.Interfaces.RealOutput PCom(final unit="W")
    "Power drawn by compressor"
    annotation (Placement(transformation(extent={{300,-120},{340,-80}}),
        iconTransformation(extent={{300,-102},{340,-62}})));
  // COMPONENTS
  Buildings.Fluid.Delays.DelayFirstOrder volMixDis_a(
    redeclare final package Medium = MediumDis,
    nPorts=3,
    final m_flow_nominal=(mEva_flow_nominal + m1HexChi_flow_nominal)/2,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{-270,-360},{-250,-380}})));
  Buildings.Fluid.Delays.DelayFirstOrder volMixDis_b(
    redeclare final package Medium = MediumDis,
    nPorts=3,
    final m_flow_nominal=(mEva_flow_nominal + m1HexChi_flow_nominal)/2,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{250,-360},{270,-380}})));
  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare final package Medium1 = MediumBui,
    redeclare final package Medium2 = MediumDis,
    final m1_flow_nominal=mCon_flow_nominal,
    final m2_flow_nominal=mEva_flow_nominal,
    final dTEva_nominal=TEvaLvg_nominal - TEvaEnt_nominal,
    final dTCon_nominal=TConLvg_nominal - TConEnt_nominal,
    final allowFlowReversal1=allowFlowReversalBui,
    final allowFlowReversal2=allowFlowReversalDis,
    final use_eta_Carnot_nominal=false,
    final COP_nominal=COP_nominal,
    final QCon_flow_nominal=QHeaWat_flow_nominal,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=dp_nominal)
    "Heat pump (index 1 for condenser side)"
    annotation (Placement(transformation(extent={{10,116},{-10,136}})));
  Networks.BaseClasses.Pump_m_flow pumEva(
    redeclare final package Medium = MediumDis,
    final m_flow_nominal=mEva_flow_nominal,
    final allowFlowReversal=allowFlowReversalDis)
    "Heat pump evaporator water pump"
    annotation (Placement(transformation(extent={{-110,110},{-90,130}})));
  Networks.BaseClasses.Pump_m_flow pum1HexChi(
    redeclare final package Medium = MediumDis,
    final m_flow_nominal=m1HexChi_flow_nominal,
    final allowFlowReversal=allowFlowReversalDis)
    "Chilled water HX primary pump"
    annotation (Placement(transformation(extent={{130,-270},{110,-250}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexChi(
    redeclare final package Medium1 = MediumDis,
    redeclare final package Medium2 = MediumBui,
    final m1_flow_nominal=m1HexChi_flow_nominal,
    final m2_flow_nominal=m2HexChi_flow_nominal,
    final dp1_nominal=dp_nominal/2,
    final dp2_nominal=dp_nominal/2,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final Q_flow_nominal=QChiWat_flow_nominal,
    final T_a1_nominal=T1HexChiEnt_nominal,
    final T_a2_nominal=T2HexChiEnt_nominal,
    final allowFlowReversal1=allowFlowReversalDis,
    final allowFlowReversal2=allowFlowReversalBui)
    "Chilled water HX"
    annotation (Placement(transformation(extent={{10,-244},{-10,-264}})));
  Buildings.Fluid.Delays.DelayFirstOrder volHeaWatRet(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=mCon_flow_nominal,
    final allowFlowReversal=allowFlowReversalBui,
    tau=60,
    final energyDynamics=mixingVolumeEnergyDynamics,
    nPorts=3)
    "Mixing volume representing building HHW primary"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={150,180})));
  Networks.BaseClasses.Pump_m_flow pumCon(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=mCon_flow_nominal,
    final allowFlowReversal=allowFlowReversalBui)
    "Heat pump condenser water pump"
    annotation (Placement(transformation(extent={{110,130},{90,150}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2HexChiLvg(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=m2HexChi_flow_nominal,
    tau=1) "CHW HX secondary water leaving temperature (measured)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-240})));
  Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold have_reqHea(
    uLow=1E-4*mHeaWat_flow_nominal,
    uHigh=0.01*mHeaWat_flow_nominal,
    trueHoldDuration=0,
    falseHoldDuration=30)
    "Outputs true in case of heating request from the building"
    annotation (Placement(transformation(extent={{-210,210},{-190,230}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloHeaWat(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui)
    "Heating water mass flow rate (measured)"
    annotation (Placement(transformation(extent={{-270,270},{-250,250}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=mCon_flow_nominal)
    annotation (Placement(transformation(extent={{-140,210},{-120,230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-180,210},{-160,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=mEva_flow_nominal)
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Buildings.Fluid.Delays.DelayFirstOrder volChiWat(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=m1HexChi_flow_nominal,
    final allowFlowReversal=allowFlowReversalBui,
    tau=60,
    final energyDynamics=mixingVolumeEnergyDynamics,
    nPorts=3)
    "Mixing volume representing building CHW primary"
    annotation (Placement(transformation(extent={{-110,-200},{-90,-180}})));
  Networks.BaseClasses.Pump_m_flow pum2CooHex(
    redeclare package Medium = MediumBui,
    final m_flow_nominal=m2HexChi_flow_nominal,
    final allowFlowReversal=allowFlowReversalBui)
    "Chilled water HX secondary pump"
    annotation (Placement(transformation(extent={{-70,-250},{-50,-230}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloChiWat(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui)
    "Chilled water mass flow rate (measured)"
    annotation (Placement(transformation(extent={{-270,-30},{-250,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold have_reqCoo(
    uLow=1E-4*mChiWat_flow_nominal,
    uHigh=0.01*mChiWat_flow_nominal,
    trueHoldDuration=0,
    falseHoldDuration=30)
    "Outputs true in case of cooling request from the building"
    annotation (Placement(transformation(extent={{-214,-130},{-194,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(
    final k=m1HexChi_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConLvg(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=mCon_flow_nominal)
    "Condenser water leaving temperature (measured)"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,140})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat(
    k=0.1,
    Ti=120,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseActing=false,
    yMin=0,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{-170,-130},{-150,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai4(k=1.1)
    annotation (Placement(transformation(extent={{-140,-170},{-120,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=1)
    annotation (Placement(transformation(extent={{230,310},{250,330}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=1)
    annotation (Placement(transformation(extent={{230,350},{250,370}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumHea(nin=2)
    "Total power drawn by pumps motors for space heating (ETS included, building excluded)"
    annotation (Placement(transformation(extent={{190,410},{210,430}})));
  Buildings.Fluid.Sources.Boundary_pT bouHeaWat(redeclare final package Medium
      = MediumBui, nPorts=1)
    "Pressure boundary condition representing the expansion vessel"
    annotation (Placement(transformation(extent={{170,130},{150,150}})));
  Buildings.Fluid.Sources.Boundary_pT bouChiWat(redeclare final package Medium
      = MediumBui, nPorts=1)
    "Pressure boundary condition representing the expansion vessel"
    annotation (Placement(transformation(extent={{-162,-210},{-142,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumCoo(nin=3)
    "Total power drawn by pumps motors for space cooling (ETS included, building excluded)"
    annotation (Placement(transformation(extent={{190,370},{210,390}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=2)
    annotation (Placement(transformation(extent={{230,390},{250,410}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(
    redeclare final package Medium=MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=mHeaWat_flow_nominal)
    "Heating water supply temperature (measured)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={200,260})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatSup(
    redeclare final package Medium=MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled water supply temperature (measured)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={160,-60})));
  SwitchBox switchBox(
    redeclare final package Medium = MediumDis,
    final m_flow_nominal=max(mHeaWat_flow_nominal, mChiWat_flow_nominal))
    "Flow switch box"
    annotation (Placement(transformation(extent={{-10,-390},{10,-370}})));
  Buildings.Controls.OBC.CDL.Continuous.Product swiOff
    "Switch off the pump in case of no cooling request"
    annotation (Placement(transformation(extent={{-134,-130},{-114,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{-170,-100},{-150,-80}})));
  Fluid.Sensors.TemperatureTwoPort senT2HexChiEnt(
    redeclare final package Medium = MediumBui,
    final allowFlowReversal=allowFlowReversalBui,
    final m_flow_nominal=m2HexChi_flow_nominal)
    "CHW HX secondary water entering temperature (measured)" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-100,-240})));
  Modelica.Blocks.Sources.RealExpression heaFloChiWat(
    y=pum2CooHex.m_flow_actual*(senT2HexChiLvg.T - senT2HexChiEnt.T)*cp_default)
    "Heat flow rate for chilled water production (<=0)"
    annotation (Placement(transformation(extent={{246,110},{266,130}})));
  Networks.BaseClasses.Junction bypHeaWatSup(
   redeclare final package Medium = MediumBui,
   final m_flow_nominal=mCon_flow_nominal*{1,-1,-1})
   "Bypass heating water (supply)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,260})));
  Networks.BaseClasses.Junction bypHeaWatRet(
   redeclare final package Medium = MediumBui,
   final m_flow_nominal=mCon_flow_nominal*{1,-1,1})
   "Bypass heating water (return)"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={110,240})));
  Networks.BaseClasses.Junction bypChiWatRet(
   redeclare final package Medium = MediumBui,
   final m_flow_nominal=m2HexChi_flow_nominal*{1,-1,1})
   "Bypass chilled water (return)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-40})));
  Networks.BaseClasses.Junction bypChiWatSup(
   redeclare final package Medium = MediumBui,
   final m_flow_nominal=m2HexChi_flow_nominal*{1,-1,-1})
   "Bypass chilled water (supply)"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={110,-60})));
  // MISCELLANEOUS VARIABLES
  MediumDis.ThermodynamicState sta_aDis=if allowFlowReversalDis then
    MediumDis.setState_phX(port_aDis.p,
      noEvent(actualStream(port_aDis.h_outflow)),
      noEvent(actualStream(port_aDis.Xi_outflow))) else
    MediumDis.setState_phX(port_aDis.p,
      inStream(port_aDis.h_outflow),
      inStream(port_aDis.Xi_outflow)) if show_T
    "Medium properties in port_aDis";
  MediumDis.ThermodynamicState sta_bDis=if allowFlowReversalDis then
    MediumDis.setState_phX(port_bDis.p,
      noEvent(actualStream(port_bDis.h_outflow)),
      noEvent(actualStream(port_bDis.Xi_outflow))) else
    MediumDis.setState_phX(port_bDis.p,
      port_bDis.h_outflow,
      port_bDis.Xi_outflow) if  show_T
    "Medium properties in port_bDis";
equation
  connect(pumEva.port_a, volMixDis_a.ports[1]) annotation (Line(points={{-110,
          120},{-240,120},{-240,-340},{-260,-340},{-260,-360},{-262.667,-360}},
        color={0,127,255}));
  connect(senMasFloHeaWat.m_flow, have_reqHea.u) annotation (Line(points={{-260,
          249},{-260,220},{-212,220}}, color={0,0,127}));
  connect(TSetHeaWat, heaPum.TSet) annotation (Line(points={{-320,80},{16,80},{
          16,135},{12,135}},  color={0,0,127}));
  connect(have_reqHea.y, booToRea.u)
    annotation (Line(points={{-188,220},{-182,220}}, color={255,0,255}));
  connect(booToRea.y, gai.u)
    annotation (Line(points={{-158,220},{-142,220}}, color={0,0,127}));
  connect(gai.y, pumCon.m_flow_in) annotation (Line(points={{-118,220},{100,220},
          {100,152}},  color={0,0,127}));
  connect(gai1.y, pumEva.m_flow_in)
    annotation (Line(points={{-118,180},{-100,180},{-100,132}},
                                                             color={0,0,127}));
  connect(booToRea.y, gai1.u) annotation (Line(points={{-158,220},{-150,220},{
          -150,180},{-142,180}},
                          color={0,0,127}));
  connect(senMasFloChiWat.m_flow, have_reqCoo.u)
    annotation (Line(points={{-260,-51},{-260,-120},{-216,-120}},
                                                            color={0,0,127}));
  connect(senT2HexChiLvg.T, conTChiWat.u_m) annotation (Line(points={{40,-229},
          {40,-140},{-160,-140},{-160,-132}},color={0,0,127}));
  connect(TSetChiWat, conTChiWat.u_s) annotation (Line(points={{-320,-80},{-180,
          -80},{-180,-120},{-172,-120}},
                  color={0,0,127}));
  connect(gai4.y, pum2CooHex.m_flow_in) annotation (Line(points={{-118,-160},{
          -60,-160},{-60,-228}},
                              color={0,0,127}));
  connect(senMasFloChiWat.m_flow, gai4.u) annotation (Line(points={{-260,-51},{
          -260,-160},{-142,-160}}, color={0,0,127}));
  connect(heaPum.P, PCom) annotation (Line(points={{-11,126},{-20,126},{-20,100},
          {280,100},{280,-100},{320,-100}},
                 color={0,0,127}));
  connect(pumCon.P, PPumHea.u[1]) annotation (Line(points={{89,149},{80,149},{
          80,200},{188,200},{188,421}},  color={0,0,127}));
  connect(pumEva.P, PPumHea.u[2]) annotation (Line(points={{-89,129},{-89,126},
          {-80,126},{-80,418},{188,418},{188,419}},
                                              color={0,0,127}));
  connect(pum1HexChi.P, PPumCoo.u[1]) annotation (Line(points={{109,-251},{100,
          -251},{100,-238},{180,-238},{180,380},{184,380},{184,381.333},{188,
          381.333}},                      color={0,0,127}));
  connect(pum2CooHex.P, PPumCoo.u[2]) annotation (Line(points={{-49,-231},{-20,
          -231},{-20,-220},{178,-220},{178,380},{188,380}},     color={0,0,127}));
  connect(PPumHea.y, mulSum1.u[1]) annotation (Line(points={{212,420},{220,420},
          {220,360},{228,360}}, color={0,0,127}));
  connect(PPumCoo.y, mulSum.u[1]) annotation (Line(points={{212,380},{210,380},
          {210,320},{228,320}},color={0,0,127}));
  connect(PPumHea.y, mulSum2.u[1]) annotation (Line(points={{212,420},{220,420},
          {220,401},{228,401}}, color={0,0,127}));
  connect(PPumCoo.y, mulSum2.u[2]) annotation (Line(points={{212,380},{210,380},
          {210,399},{228,399}}, color={0,0,127}));
  connect(pum1HexChi.port_b, hexChi.port_a1) annotation (Line(points={{110,-260},
          {10,-260}},                              color={0,127,255}));
  connect(pum2CooHex.port_b, hexChi.port_a2)
    annotation (Line(points={{-50,-240},{-20,-240},{-20,-248},{-10,-248}},
                                                  color={0,127,255}));
  connect(pumEva.port_b, heaPum.port_a2)
    annotation (Line(points={{-90,120},{-10,120}}, color={0,127,255}));
  connect(heaPum.port_b2, volMixDis_b.ports[1]) annotation (Line(points={{10,120},
          {240,120},{240,-340},{258,-340},{258,-360},{257.333,-360}}, color={0,127,
          255}));
  connect(heaPum.port_b1, senTConLvg.port_a) annotation (Line(points={{-10,132},
          {-20,132},{-20,140},{-30,140}},      color={0,127,255}));
  connect(pumCon.port_b, heaPum.port_a1) annotation (Line(points={{90,140},{20,
          140},{20,132},{10,132}},    color={0,127,255}));
  connect(pum1HexChi.m_flow_actual, mCoo_flow) annotation (Line(points={{109,-255},
          {102,-255},{102,-240},{280,-240},{280,-180},{320,-180}},
                                                                 color={0,0,127}));
  connect(pumEva.m_flow_actual, mHea_flow) annotation (Line(points={{-89,125},{-78,
          125},{-78,104},{286,104},{286,-140},{320,-140}},
                                                         color={0,0,127}));
  connect(volMixDis_a.ports[2], switchBox.port_bSup) annotation (Line(points={{-260,
          -360},{-4,-360},{-4,-370}}, color={0,127,255}));
  connect(switchBox.port_aRet, volMixDis_b.ports[2]) annotation (Line(points={{4,
          -370},{4,-360},{260,-360}}, color={0,127,255}));
  connect(volMixDis_b.ports[3], pum1HexChi.port_a) annotation (Line(points={{262.667,
          -360},{254,-360},{254,-350},{220,-350},{220,-260},{130,-260}}, color={
          0,127,255}));
  connect(hexChi.port_b1, volMixDis_a.ports[3]) annotation (Line(points={{-10,
          -260},{-220,-260},{-220,-350},{-257.333,-350},{-257.333,-360}},
                                                                    color={0,127,
          255}));
  connect(pum1HexChi.m_flow_actual, switchBox.mFreCoo_flow) annotation (Line(
        points={{109,-255},{110,-255},{110,-254},{100,-254},{100,-340},{-20,
          -340},{-20,-383.2},{-11.2,-383.2}}, color={0,0,127}));
  connect(pumEva.m_flow_actual, switchBox.mSpaHea_flow) annotation (Line(points={{-89,125},
          {-89,126},{-80,126},{-80,60},{-40,60},{-40,-375.2},{-11.2,-375.2}},
                                                                      color={0,
          0,127}));
  connect(have_reqCoo.y, conTChiWat.trigger) annotation (Line(points={{-192,
          -120},{-188,-120},{-188,-140},{-166,-140},{-166,-132}},
                                                      color={255,0,255}));
  connect(booToRea1.y, swiOff.u1) annotation (Line(points={{-148,-90},{-140,-90},
          {-140,-114},{-136,-114}},
                              color={0,0,127}));
  connect(have_reqCoo.y, booToRea1.u) annotation (Line(points={{-192,-120},{
          -188,-120},{-188,-90},{-172,-90}},
                                color={255,0,255}));
  connect(swiOff.y, gai2.u)
    annotation (Line(points={{-112,-120},{-102,-120}},
                                                 color={0,0,127}));
  connect(conTChiWat.y, swiOff.u2) annotation (Line(points={{-148,-120},{-140,
          -120},{-140,-126},{-136,-126}},
                               color={0,0,127}));
  connect(gai2.y, pum1HexChi.m_flow_in)
    annotation (Line(points={{-78,-120},{120,-120},{120,-248}},
                                                          color={0,0,127}));
  connect(switchBox.port_bRet, port_bDis) annotation (Line(points={{4,-390},
          {4,-400},{280,-400},{280,-260},{300,-260}}, color={0,127,255}));
  connect(switchBox.port_aSup, port_aDis) annotation (Line(points={{-4,-390},
          {-4,-400},{-280,-400},{-280,-260},{-300,-260}}, color={0,127,255}));
  connect(mulSum2.y, PPum) annotation (Line(points={{252,400},{272,400},{272,
          -60},{320,-60}},
                      color={0,0,127}));
  connect(pumCon.P, PPumCoo.u[3]) annotation (Line(points={{89,149},{80,149},{
          80,200},{188,200},{188,378.667}}, color={0,0,127}));
  connect(senT2HexChiEnt.port_b, pum2CooHex.port_a)
    annotation (Line(points={{-90,-240},{-70,-240}},   color={0,127,255}));
  connect(heaPum.P, PHea) annotation (Line(points={{-11,126},{-20,126},{-20,100},
          {280,100},{280,60},{320,60}},               color={0,0,127}));
  connect(ports_aHeaWat[1], senMasFloHeaWat.port_a) annotation (Line(points={{-300,
          260},{-296,260},{-296,260},{-270,260}},      color={0,127,255}));
  connect(bypHeaWatSup.port_2, senTHeaWatSup.port_a)
    annotation (Line(points={{120,260},{190,260}}, color={0,127,255}));
  connect(senTHeaWatSup.port_b, ports_bHeaWat[1])
    annotation (Line(points={{210,260},{300,260}}, color={0,127,255}));
  connect(senTConLvg.port_b, bypHeaWatSup.port_1) annotation (Line(points={{-50,140},
          {-60,140},{-60,260},{100,260}},      color={0,127,255}));
  connect(senMasFloHeaWat.port_b, bypHeaWatRet.port_1) annotation (Line(points=
          {{-250,260},{-150,260},{-150,240},{100,240}}, color={0,127,255}));
  connect(bypHeaWatRet.port_2, volHeaWatRet.ports[1]) annotation (Line(points={{120,240},
          {140,240},{140,177.333}},           color={0,127,255}));
  connect(pumCon.port_a, volHeaWatRet.ports[2]) annotation (Line(points={{110,
          140},{140,140},{140,180}}, color={0,127,255}));
  connect(bouHeaWat.ports[1], volHeaWatRet.ports[3]) annotation (Line(points={{150,140},
          {140,140},{140,182.667}},          color={0,127,255}));
  connect(senMasFloChiWat.port_b, bypChiWatRet.port_1)
    annotation (Line(points={{-250,-40},{100,-40}}, color={0,127,255}));
  connect(ports_aChiWat[1], senMasFloChiWat.port_a) annotation (Line(points={{
          -300,200},{-280,200},{-280,-40},{-270,-40}}, color={0,127,255}));
  connect(senT2HexChiLvg.port_a, hexChi.port_b2) annotation (Line(points={{30,
          -240},{20,-240},{20,-248},{10,-248}}, color={0,127,255}));
  connect(volChiWat.ports[1], bypChiWatRet.port_2) annotation (Line(points={{
          -102.667,-200},{140,-200},{140,-40},{120,-40}}, color={0,127,255}));
  connect(volChiWat.ports[2], senT2HexChiEnt.port_a) annotation (Line(points={{
          -100,-200},{-120,-200},{-120,-240},{-110,-240}}, color={0,127,255}));
  connect(bouChiWat.ports[1], volChiWat.ports[3])
    annotation (Line(points={{-142,-200},{-97.3333,-200}}, color={0,127,255}));
  connect(bypChiWatSup.port_2, senTChiWatSup.port_a)
    annotation (Line(points={{120,-60},{150,-60}}, color={0,127,255}));
  connect(senTChiWatSup.port_b, ports_bChiWat[1]) annotation (Line(points={{170,
          -60},{200,-60},{200,200},{300,200}}, color={0,127,255}));
  connect(senT2HexChiLvg.port_b, bypChiWatSup.port_1) annotation (Line(points={{50,-240},
          {80,-240},{80,-60},{100,-60}},           color={0,127,255}));
  connect(bypChiWatSup.port_3, bypChiWatRet.port_3)
    annotation (Line(points={{110,-50},{110,-50}}, color={0,127,255}));
  connect(bypHeaWatRet.port_3, bypHeaWatSup.port_3)
    annotation (Line(points={{110,250},{110,250}}, color={0,127,255}));
  annotation (
  defaultComponentName="ets",
  Documentation(info="<html>
<p>
Heating hot water is produced at low temperature (typically 40°C) with a water-to-water heat pump.
Chilled water is produced at high temperature (typically 19°C) with a heat exchanger.
</p>
<p>
The time series data are interpolated using
Fritsch-Butland interpolation. This uses
cubic Hermite splines such that y preserves the monotonicity and
der(y) is continuous, also if extrapolated.
</p>
<p>
There is a control volume at each of the two fluid ports
that are exposed by this model. These approximate the dynamics
of the substation, and they also generally avoid nonlinear system
of equations if multiple substations are connected to each other.
</p>
</html>",
  revisions="<html>
<ul>
<li>
December 12, 2017, by Michael Wetter:<br/>
Removed call to <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1097\">issue 1097</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-300,-420},{300,440}})));
end ETSSimplified;
