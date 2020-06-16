within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.EnergyTransferStations;
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
    nPorts_aBui=2,
    nPorts_bBui=2,
    nPorts_bDis=1,
    nPorts_aDis=1);
  outer
    DHC.Examples.FifthGeneration.Unidirectional.Data.DesignDataSeries
    datDes "DHC systenm design data";
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
        origin={-320,200}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,40})));
  Modelica.Blocks.Interfaces.RealInput TSetChiWat "Chilled water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-320,40}),   iconTransformation(
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
    nPorts=3,
    m_flow_nominal=mCon_flow_nominal,
    allowFlowReversal=allowFlowReversalBui,
    tau=60,
    energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume representing building HHW primary"
    annotation (Placement(transformation(extent={{12,220},{32,240}})));
  Networks.BaseClasses.Pump_m_flow pumCon(
    redeclare final package Medium = MediumBui,
    final m_flow_nominal=mCon_flow_nominal,
    final allowFlowReversal=allowFlowReversalBui)
    "Heat pump condenser water pump"
    annotation (Placement(transformation(extent={{110,150},{90,170}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2HexChiLvg(
    redeclare final package Medium = MediumBui,
    allowFlowReversal=allowFlowReversalBui,
    m_flow_nominal=m2HexChi_flow_nominal,
    tau=1) "CHW HX secondary water leaving temperature (measured)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={80,-220})));
  Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold have_reqHea(
    uLow=1E-4*mHeaWat_flow_nominal,
    uHigh=0.01*mHeaWat_flow_nominal,
    trueHoldDuration=0,
    falseHoldDuration=30)
    "Outputs true in case of heating request from the building"
    annotation (Placement(transformation(extent={{-210,270},{-190,290}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloHeaWat(
    redeclare final package Medium = MediumBui,
    allowFlowReversal=allowFlowReversalBui)
    "Heating water mass flow rate (measured)"
    annotation (Placement(transformation(extent={{-230,370},{-210,350}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=mCon_flow_nominal)
    annotation (Placement(transformation(extent={{-140,270},{-120,290}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-180,270},{-160,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=mEva_flow_nominal)
    annotation (Placement(transformation(extent={{-140,230},{-120,250}})));
  Buildings.Fluid.Delays.DelayFirstOrder volChiWat(
    redeclare final package Medium = MediumBui,
    nPorts=3,
    m_flow_nominal=m1HexChi_flow_nominal,
    allowFlowReversal=allowFlowReversalBui,
    tau=60,
    energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume representing building CHW primary"
    annotation (Placement(transformation(extent={{-190,-160},{-170,-140}})));
  Networks.BaseClasses.Pump_m_flow pum2CooHex(
    redeclare package Medium = MediumBui,
    final m_flow_nominal=m2HexChi_flow_nominal,
    final allowFlowReversal=allowFlowReversalBui)
    "Chilled water HX secondary pump"
    annotation (Placement(transformation(extent={{-110,-230},{-90,-210}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloChiWat(
    redeclare package Medium = MediumBui,
    allowFlowReversal=allowFlowReversalBui)
    "Chilled water mass flow rate (measured)"
    annotation (Placement(transformation(extent={{-230,-90},{-210,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold have_reqCoo(
    uLow=1E-4*mChiWat_flow_nominal,
    uHigh=0.01*mChiWat_flow_nominal,
    trueHoldDuration=0,
    falseHoldDuration=30)
    "Outputs true in case of cooling request from the building"
    annotation (Placement(transformation(extent={{-214,-10},{-194,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(k=m1HexChi_flow_nominal)
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConLvg(
    redeclare final package Medium = MediumBui,
    allowFlowReversal=allowFlowReversalBui,
    m_flow_nominal=mCon_flow_nominal)
    "Condenser water leaving temperature (measured)"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-160,160})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat(
    k=0.1,
    Ti=120,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=true,
    yMin=0,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
    "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{-170,-10},{-150,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai4(k=1.1)
    annotation (Placement(transformation(extent={{-140,-50},{-120,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=1)
    annotation (Placement(transformation(extent={{230,310},{250,330}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=1)
    annotation (Placement(transformation(extent={{230,350},{250,370}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumHea(nin=2)
    "Total power drawn by pumps motors for space heating (ETS included, building excluded)"
    annotation (Placement(transformation(extent={{170,410},{190,430}})));
  Buildings.Fluid.Sources.Boundary_pT bouHeaWat(redeclare final package Medium =
        MediumBui, nPorts=1)
    "Pressure boundary condition representing the expansion vessel"
    annotation (Placement(transformation(extent={{60,230},{40,250}})));
  Buildings.Fluid.Sources.Boundary_pT bouChiWat(redeclare final package Medium =
        MediumBui, nPorts=1)
    "Pressure boundary condition representing the expansion vessel"
    annotation (Placement(transformation(extent={{-220,-150},{-200,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumCoo(nin=3)
    "Total power drawn by pumps motors for space cooling (ETS included, building excluded)"
    annotation (Placement(transformation(extent={{170,370},{190,390}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=2)
    annotation (Placement(transformation(extent={{230,390},{250,410}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(
    redeclare final package Medium=MediumBui,
    allowFlowReversal=allowFlowReversalBui,
    m_flow_nominal=mHeaWat_flow_nominal)
    "Heating water supply temperature (measured)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,380})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatSup(
    redeclare final package Medium=MediumBui,
    allowFlowReversal=allowFlowReversalBui,
    m_flow_nominal=mHeaWat_flow_nominal)
    "Chilled water supply temperature (measured)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-60})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
  decHeaWat(
    redeclare final package Medium=MediumBui,
    final m_flow_nominal=mHeaWat_flow_nominal,
    nPorts_a=2,
    nPorts_b=2)
    "Primary-secondary decoupler"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,350})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
  decChiWat(
    redeclare final package Medium=MediumBui,
    final m_flow_nominal=mChiWat_flow_nominal,
    nPorts_a=2,
    nPorts_b=2)
    "Primary-secondary decoupler"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-90})));
  SwitchBox switchBox(
    redeclare final package Medium = MediumDis,
    final m_flow_nominal=max(mHeaWat_flow_nominal, mChiWat_flow_nominal))
    "Flow switch box"
    annotation (Placement(transformation(extent={{-10,-390},{10,-370}})));
  Buildings.Controls.OBC.CDL.Continuous.Product swiOff
    "Switch off the pump in case of no cooling request"
    annotation (Placement(transformation(extent={{-134,-10},{-114,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{-170,20},{-150,40}})));
  // MISCELLANEOUS VARIABLES
  MediumDis.ThermodynamicState sta_aDis[nPorts_aDis]=if allowFlowReversalDis then
    MediumDis.setState_phX(ports_aDis.p,
      noEvent(actualStream(ports_aDis.h_outflow)),
      noEvent(actualStream(ports_aDis.Xi_outflow))) else
    MediumDis.setState_phX(ports_aDis.p,
      inStream(ports_aDis.h_outflow),
      inStream(ports_aDis.Xi_outflow)) if show_T
    "Medium properties in port_aDis";
  MediumDis.ThermodynamicState sta_bDis[nPorts_bDis]=if allowFlowReversalDis then
    MediumDis.setState_phX(ports_bDis.p,
      noEvent(actualStream(ports_bDis.h_outflow)),
      noEvent(actualStream(ports_bDis.Xi_outflow))) else
    MediumDis.setState_phX(ports_bDis.p,
      ports_bDis.h_outflow,
      ports_bDis.Xi_outflow) if  show_T
    "Medium properties in port_bDis";
  Fluid.Sensors.TemperatureTwoPort senT2HexChiEnt(
    redeclare final package Medium = MediumBui,
    allowFlowReversal=allowFlowReversalBui,
    m_flow_nominal=m2HexChi_flow_nominal,
    tau=1) "CHW HX secondary water entering temperature (measured)" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-220})));
  Modelica.Blocks.Sources.RealExpression heaFloChiWat(y=pum2CooHex.m_flow_actual
        *(senT2HexChiLvg.T - senT2HexChiEnt.T)*cp_default)
    "Heat flow rate for chilled water production (<=0)"
    annotation (Placement(transformation(extent={{246,110},{266,130}})));
equation
  connect(pumEva.port_a, volMixDis_a.ports[1]) annotation (Line(points={{-110,
          120},{-240,120},{-240,-340},{-260,-340},{-260,-360},{-262.667,-360}},
        color={0,127,255}));
  connect(senMasFloHeaWat.m_flow, have_reqHea.u) annotation (Line(points={{-220,
          349},{-220,280},{-212,280}}, color={0,0,127}));
  connect(TSetHeaWat, heaPum.TSet) annotation (Line(points={{-320,200},{20,200},
          {20,135},{12,135}}, color={0,0,127}));
  connect(have_reqHea.y, booToRea.u)
    annotation (Line(points={{-188,280},{-182,280}}, color={255,0,255}));
  connect(booToRea.y, gai.u)
    annotation (Line(points={{-158,280},{-142,280}}, color={0,0,127}));
  connect(gai.y, pumCon.m_flow_in) annotation (Line(points={{-118,280},{100,280},
          {100,172}},  color={0,0,127}));
  connect(gai1.y, pumEva.m_flow_in)
    annotation (Line(points={{-118,240},{-100,240},{-100,132}},
                                                             color={0,0,127}));
  connect(booToRea.y, gai1.u) annotation (Line(points={{-158,280},{-150,280},{-150,
          240},{-142,240}},
                          color={0,0,127}));
  connect(senMasFloChiWat.m_flow, have_reqCoo.u)
    annotation (Line(points={{-220,-69},{-220,0},{-216,0}}, color={0,0,127}));
  connect(senT2HexChiLvg.T, conTChiWat.u_m) annotation (Line(points={{80,-209},
          {80,-180},{-160,-180},{-160,-12}}, color={0,0,127}));
  connect(TSetChiWat, conTChiWat.u_s) annotation (Line(points={{-320,40},{-180,40},
          {-180,0},{-172,0}},
                  color={0,0,127}));
  connect(gai4.y, pum2CooHex.m_flow_in) annotation (Line(points={{-118,-40},{-100,
          -40},{-100,-208}},  color={0,0,127}));
  connect(senMasFloChiWat.m_flow, gai4.u) annotation (Line(points={{-220,-69},{-220,
          -40},{-142,-40}},        color={0,0,127}));
  connect(heaPum.P, PCom) annotation (Line(points={{-11,126},{-28,126},{-28,100},
          {280,100},{280,-100},{320,-100}},
                 color={0,0,127}));
  connect(pumCon.P, PPumHea.u[1]) annotation (Line(points={{89,169},{40,169},{40,
          200},{168,200},{168,421}},     color={0,0,127}));
  connect(pumEva.P, PPumHea.u[2]) annotation (Line(points={{-89,129},{-89,128},{
          -80,128},{-80,180},{162,180},{162,420},{168,420},{168,419}},
                                              color={0,0,127}));
  connect(pum1HexChi.P, PPumCoo.u[1]) annotation (Line(points={{109,-251},{100,
          -251},{100,-238},{160,-238},{160,381.333},{168,381.333}},
                                          color={0,0,127}));
  connect(pum2CooHex.P, PPumCoo.u[2]) annotation (Line(points={{-89,-211},{-89,
          -210},{-80,-210},{-80,-200},{158,-200},{158,380},{168,380}},
                                                                color={0,0,127}));
  connect(PPumHea.y, mulSum1.u[1]) annotation (Line(points={{192,420},{220,420},
          {220,360},{228,360}}, color={0,0,127}));
  connect(PPumCoo.y, mulSum.u[1]) annotation (Line(points={{192,380},{210,380},
          {210,320},{228,320}},color={0,0,127}));
  connect(PPumHea.y, mulSum2.u[1]) annotation (Line(points={{192,420},{220,420},
          {220,401},{228,401}}, color={0,0,127}));
  connect(PPumCoo.y, mulSum2.u[2]) annotation (Line(points={{192,380},{210,380},
          {210,399},{228,399}}, color={0,0,127}));
  connect(pum1HexChi.port_b, hexChi.port_a1) annotation (Line(points={{110,-260},
          {10,-260}},                              color={0,127,255}));
  connect(pum2CooHex.port_b, hexChi.port_a2)
    annotation (Line(points={{-90,-220},{-20,-220},{-20,-248},{-10,-248}},
                                                  color={0,127,255}));
  connect(pumEva.port_b, heaPum.port_a2)
    annotation (Line(points={{-90,120},{-10,120}}, color={0,127,255}));
  connect(heaPum.port_b2, volMixDis_b.ports[1]) annotation (Line(points={{10,120},
          {240,120},{240,-340},{258,-340},{258,-360},{257.333,-360}}, color={0,127,
          255}));
  connect(heaPum.port_b1, senTConLvg.port_a) annotation (Line(points={{-10,132},
          {-30,132},{-30,160},{-150,160}},     color={0,127,255}));
  connect(pumCon.port_b, heaPum.port_a1) annotation (Line(points={{90,160},{40,160},
          {40,132},{10,132}},         color={0,127,255}));
  connect(pum1HexChi.m_flow_actual, mCoo_flow) annotation (Line(points={{109,-255},
          {102,-255},{102,-240},{280,-240},{280,-180},{320,-180}},
                                                                 color={0,0,127}));
  connect(pumEva.m_flow_actual, mHea_flow) annotation (Line(points={{-89,125},{-78,
          125},{-78,104},{286,104},{286,-140},{320,-140}},
                                                         color={0,0,127}));
  connect(bouHeaWat.ports[1], volHeaWatRet.ports[1]) annotation (Line(points={{40,240},
          {40,220},{19.3333,220}},      color={0,127,255}));
  connect(bouChiWat.ports[1], volChiWat.ports[1]) annotation (Line(points={{-200,
          -140},{-200,-160},{-182.667,-160}}, color={0,127,255}));
  connect(volHeaWatRet.ports[2], pumCon.port_a) annotation (Line(points={{22,220},
          {120,220},{120,160},{110,160}},      color={0,127,255}));
  connect(senTConLvg.port_b, decHeaWat.ports_a[1]) annotation (Line(points={{-170,
          160},{-220,160},{-220,220},{-20,220},{-20,360},{2,360}},      color={
          0,127,255}));
  connect(decHeaWat.ports_a[2], senTHeaWatSup.port_a) annotation (Line(points={{-2,360},
          {0,360},{0,380},{30,380}},                  color={0,127,255}));
  connect(senMasFloHeaWat.port_b, decHeaWat.ports_b[1]) annotation (Line(points=
         {{-210,360},{-40,360},{-40,340},{-2,340}}, color={0,127,255}));
  connect(decHeaWat.ports_b[2], volHeaWatRet.ports[3]) annotation (Line(points={{2,340},
          {0,340},{0,220},{24.6667,220}},          color={0,127,255}));
  connect(senMasFloChiWat.port_b, decChiWat.ports_b[1]) annotation (Line(points={{-210,
          -80},{-24,-80},{-24,-100},{-2,-100}},       color={0,127,255}));
  connect(decChiWat.ports_b[2], volChiWat.ports[2]) annotation (Line(points={{2,-100},
          {0,-100},{0,-160},{-180,-160}},          color={0,127,255}));
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
  connect(hexChi.port_b2, senT2HexChiLvg.port_a) annotation (Line(points={{10,-248},
          {20,-248},{20,-220},{70,-220}}, color={0,127,255}));
  connect(senT2HexChiLvg.port_b, decChiWat.ports_a[1]) annotation (Line(points={
          {90,-220},{140,-220},{140,-80},{2,-80}}, color={0,127,255}));
  connect(decChiWat.ports_a[2], senTChiWatSup.port_a)
    annotation (Line(points={{-2,-80},{-2,-60},{30,-60}}, color={0,127,255}));
  connect(pum1HexChi.m_flow_actual, switchBox.mFreCoo_flow) annotation (Line(
        points={{109,-255},{110,-255},{110,-254},{100,-254},{100,-340},{-20,
          -340},{-20,-383.2},{-11.2,-383.2}}, color={0,0,127}));
  connect(pumEva.m_flow_actual, switchBox.mSpaHea_flow) annotation (Line(points=
         {{-89,125},{-89,126},{-40,126},{-40,-375.2},{-11.2,-375.2}}, color={0,
          0,127}));
  connect(have_reqCoo.y, conTChiWat.trigger) annotation (Line(points={{-192,0},
          {-188,0},{-188,-20},{-168,-20},{-168,-12}}, color={255,0,255}));
  connect(booToRea1.y, swiOff.u1) annotation (Line(points={{-148,30},{-140,30},
          {-140,6},{-136,6}}, color={0,0,127}));
  connect(have_reqCoo.y, booToRea1.u) annotation (Line(points={{-192,0},{-188,0},
          {-188,30},{-172,30}}, color={255,0,255}));
  connect(swiOff.y, gai2.u)
    annotation (Line(points={{-112,0},{-102,0}}, color={0,0,127}));
  connect(conTChiWat.y, swiOff.u2) annotation (Line(points={{-148,0},{-140,0},{
          -140,-6},{-136,-6}}, color={0,0,127}));
  connect(gai2.y, pum1HexChi.m_flow_in)
    annotation (Line(points={{-78,0},{120,0},{120,-248}}, color={0,0,127}));
  connect(ports_aBui[1], senMasFloHeaWat.port_a) annotation (Line(points={{-300,
          240},{-300,280},{-260,280},{-260,360},{-230,360}}, color={0,127,255}));
  connect(ports_aBui[2], senMasFloChiWat.port_a) annotation (Line(points={{-300,
          280},{-300,240},{-260,240},{-260,-80},{-230,-80}}, color={0,127,255}));
  connect(senTHeaWatSup.port_b, ports_bBui[1]) annotation (Line(points={{50,380},
          {120,380},{120,280},{300,280},{300,240}}, color={0,127,255}));
  connect(senTChiWatSup.port_b, ports_bBui[2]) annotation (Line(points={{50,-60},
          {220,-60},{220,240},{300,240},{300,280}}, color={0,127,255}));
  connect(switchBox.port_bRet, ports_bDis[1]) annotation (Line(points={{4,-390},
          {4,-400},{280,-400},{280,-260},{300,-260}}, color={0,127,255}));
  connect(switchBox.port_aSup, ports_aDis[1]) annotation (Line(points={{-4,-390},
          {-4,-400},{-280,-400},{-280,-260},{-300,-260}}, color={0,127,255}));
  connect(mulSum2.y, PPum) annotation (Line(points={{252,400},{272,400},{272,-40},
          {320,-40}}, color={0,0,127}));
  connect(pumCon.P, PPumCoo.u[3]) annotation (Line(points={{89,169},{40,169},{
          40,200},{168,200},{168,378.667}}, color={0,0,127}));
  connect(heaPum.QCon_flow, QHeaWat_flow) annotation (Line(points={{-11,135},{
          -20,135},{-20,140},{280,140},{280,200},{320,200}}, color={0,0,127}));
  connect(volChiWat.ports[3], senT2HexChiEnt.port_a) annotation (Line(points={{
          -177.333,-160},{-220,-160},{-220,-220},{-160,-220}}, color={0,127,255}));
  connect(senT2HexChiEnt.port_b, pum2CooHex.port_a)
    annotation (Line(points={{-140,-220},{-110,-220}}, color={0,127,255}));
  connect(heaFloChiWat.y, QChiWat_flow) annotation (Line(points={{267,120},{286,
          120},{286,120},{320,120}}, color={0,0,127}));
  connect(heaPum.P, PHea) annotation (Line(points={{-11,126},{-28.2353,126},{
          -28.2353,100},{280,100},{280,80},{320,80}}, color={0,0,127}));
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
