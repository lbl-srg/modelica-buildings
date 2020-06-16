within Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.EnergyTransferStations;
model ETSSimplified_bck
  "Simplified model of a substation producing heating hot water (heat pump) and chilled water (HX)"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model for water"
    annotation (choicesAllMatching = true);
  outer
    Buildings.Applications.DHC.Examples.FifthGeneration.Unidirectional.Data.DesignDataSeries
    datDes "DHC systenm design data";
  // SYSTEM GENERAL
  parameter Boolean allowFlowReversalBui = false
    "Set to true to allow flow reversal on the building side"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalDis = false
    "Set to true to allow flow reversal on the district side"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Integer nSup = 0
    "Number of supply lines"
    annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    max=0)
    "Design cooling heat flow rate (<=0)"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=0)
    "Design heating heat flow rate (>=0)"
    annotation (Dialog(group="Nominal conditions"));
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
    abs(QHea_flow_nominal / cp_default / (THeaWatSup_nominal - THeaWatRet_nominal))
    "Heating water mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate mChiWat_flow_nominal(min=0)=
    abs(QCoo_flow_nominal / cp_default / (TChiWatSup_nominal - TChiWatRet_nominal))
    "Heating water mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(Medium.setState_pTX(
      p = Medium.p_default,
      T = Medium.T_default,
      X = Medium.X_default))
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
    abs(QHea_flow_nominal / cp_default / (TConLvg_nominal - TConEnt_nominal))
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
    abs(QCoo_flow_nominal / cp_default / dT_nominal)
    "CHW HX primary mass flow rate"
    annotation(Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.MassFlowRate m2HexChi_flow_nominal(min=0)=
    abs(QCoo_flow_nominal / cp_default / (THeaWatSup_nominal - THeaWatRet_nominal))
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
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversalDis then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a"
    annotation (Placement(transformation(extent={{-290,-410},{-270,-390}}),
    iconTransformation(extent={{-300,-20},{-260,20}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversalDis then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector b"
    annotation (Placement(transformation(extent={{290,-410},{270,-390}}),
      iconTransformation(extent={{300,-20},{260,20}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nSup](
    redeclare each final package Medium = Medium,
    each m_flow(min=if allowFlowReversalBui then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors a (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{-290,80},{-270,160}}),
      iconTransformation(extent={{-300,-260},{-260,-100}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nSup](
    redeclare each final package Medium = Medium,
    each m_flow(max=if allowFlowReversalBui then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{270,80},{290,160}}),
      iconTransformation(extent={{260,-260},{300,-100}})));
  Modelica.Blocks.Interfaces.RealInput TSetHeaWat
    "Heating water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-300,200}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-300,240})));
  Modelica.Blocks.Interfaces.RealInput TSetChiWat "Chilled water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-300,40}),   iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-300,160})));
  Modelica.Blocks.Interfaces.RealOutput mHea_flow
    "District water mass flow rate used for heating service"
    annotation ( Placement(transformation(extent={{280,260},{320,300}}),
        iconTransformation(extent={{280,80},{320,120}})));
  Modelica.Blocks.Interfaces.RealOutput mCoo_flow
    "District water mass flow rate used for cooling service"
    annotation ( Placement(transformation(extent={{280,220},{320,260}}),
        iconTransformation(extent={{280,40},{320,80}})));
  Modelica.Blocks.Interfaces.RealOutput PCom(final unit="W")
    "Power drawn by compressor"
    annotation (Placement(transformation(extent={{280,420},{320,460}}),
        iconTransformation(extent={{280,240},{320,280}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W")
    "Power drawn by pumps motors"
    annotation (Placement(transformation(extent={{280,380},{320,420}}),
        iconTransformation(extent={{280,200},{320,240}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(unit="W")
    "Total power consumed for space heating"
    annotation (Placement(transformation(extent={{280,340},{320,380}}),
        iconTransformation(extent={{280,160},{320,200}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(unit="W")
    "Total power consumed for space cooling"
    annotation (Placement(transformation(extent={{280,300},{320,340}}),
        iconTransformation(extent={{280,120},{320,160}})));
  // COMPONENTS
  Buildings.Fluid.Delays.DelayFirstOrder volMix_a(
    redeclare final package Medium = Medium,
    nPorts=3,
    final m_flow_nominal=(mEva_flow_nominal + m1HexChi_flow_nominal)/2,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{-270,-360},{-250,-380}})));
  Buildings.Fluid.Delays.DelayFirstOrder volMix_b(
    redeclare final package Medium = Medium,
    nPorts=3,
    final m_flow_nominal=(mEva_flow_nominal + m1HexChi_flow_nominal)/2,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{250,-360},{270,-380}})));
  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final m1_flow_nominal=mCon_flow_nominal,
    final m2_flow_nominal=mEva_flow_nominal,
    final dTEva_nominal=TEvaLvg_nominal - TEvaEnt_nominal,
    final dTCon_nominal=TConLvg_nominal - TConEnt_nominal,
    final allowFlowReversal1=allowFlowReversalBui,
    final allowFlowReversal2=allowFlowReversalDis,
    final use_eta_Carnot_nominal=false,
    final COP_nominal=COP_nominal,
    final QCon_flow_nominal=QHea_flow_nominal,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=dp_nominal)
    "Heat pump (index 1 for condenser side)"
    annotation (Placement(transformation(extent={{10,116},{-10,136}})));
  Networks.BaseClasses.Pump_m_flow pumEva(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mEva_flow_nominal,
    final allowFlowReversal=allowFlowReversalDis)
    "Evaporator pump"
    annotation (Placement(transformation(extent={{-110,110},{-90,130}})));
  Networks.BaseClasses.Pump_m_flow pum1HexChi(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m1HexChi_flow_nominal,
    final allowFlowReversal=allowFlowReversalDis)
    "Chilled water HX primary pump"
    annotation (Placement(transformation(extent={{130,-270},{110,-250}})));
  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hexChi(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final m1_flow_nominal=m1HexChi_flow_nominal,
    final m2_flow_nominal=m2HexChi_flow_nominal,
    final dp1_nominal=dp_nominal/2,
    final dp2_nominal=dp_nominal/2,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final Q_flow_nominal=QCoo_flow_nominal,
    final T_a1_nominal=T1HexChiEnt_nominal,
    final T_a2_nominal=T2HexChiEnt_nominal,
    final allowFlowReversal1=allowFlowReversalDis,
    final allowFlowReversal2=allowFlowReversalBui)
    "Chilled water HX"
    annotation (Placement(transformation(extent={{10,-244},{-10,-264}})));
  Buildings.Fluid.Delays.DelayFirstOrder volHeaWatRet(
    redeclare final package Medium = Medium,
    nPorts=3,
    m_flow_nominal=mCon_flow_nominal,
    allowFlowReversal=allowFlowReversalBui,
    tau=60,
    energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume representing building HHW primary"
    annotation (Placement(transformation(extent={{12,220},{32,240}})));
  Networks.BaseClasses.Pump_m_flow pumCon(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mCon_flow_nominal,
    final allowFlowReversal=allowFlowReversalBui)
    "Condenser pump"
    annotation (Placement(transformation(extent={{110,150},{90,170}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2HexChiLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=allowFlowReversalBui,
    m_flow_nominal=m2HexChi_flow_nominal,
    tau=1)
    "CHW HX secondary water leaving temperature (measured)"
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
    redeclare final package Medium = Medium,
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
    redeclare final package Medium = Medium,
    nPorts=3,
    m_flow_nominal=m1HexChi_flow_nominal,
    allowFlowReversal=allowFlowReversalBui,
    tau=60,
    energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume representing building CHW primary"
    annotation (Placement(transformation(extent={{-190,-160},{-170,-140}})));
  Networks.BaseClasses.Pump_m_flow pum2CooHex(
    redeclare package Medium = Medium,
    final m_flow_nominal=m2HexChi_flow_nominal,
    final allowFlowReversal=allowFlowReversalBui)
    "Chilled water HX secondary pump"
    annotation (Placement(transformation(extent={{-110,-230},{-90,-210}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloChiWat(
    redeclare package Medium = Medium,
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
    redeclare final package Medium = Medium,
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
  Buildings.Fluid.Sources.Boundary_pT bouHea(
    redeclare final package Medium = Medium, nPorts=1)
    "Pressure boundary condition representing the expansion vessel"
    annotation (Placement(transformation(extent={{60,230},{40,250}})));
  Buildings.Fluid.Sources.Boundary_pT bouChi(
    redeclare final package Medium = Medium, nPorts=1)
              "Pressure boundary condition representing the expansion vessel"
    annotation (Placement(transformation(extent={{-220,-150},{-200,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumCoo(nin=2)
    "Total power drawn by pumps motors for space cooling (ETS included, building excluded)"
    annotation (Placement(transformation(extent={{170,370},{190,390}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=2)
    annotation (Placement(transformation(extent={{230,390},{250,410}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTHeaWatSup(
    redeclare final package Medium=Medium,
    allowFlowReversal=allowFlowReversalBui,
    m_flow_nominal=mHeaWat_flow_nominal)
    "Heating water supply temperature (measured)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,380})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTChiWatSup(
    redeclare final package Medium=Medium,
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
    redeclare final package Medium=Medium,
    m_flow_nominal=mHeaWat_flow_nominal,
    nPorts_a=2,
    nPorts_b=2)
    "Primary-secondary decoupler"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,350})));
  Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader
  decChiWat(
    redeclare final package Medium=Medium,
    m_flow_nominal=mChiWat_flow_nominal,
    nPorts_a=2,
    nPorts_b=2)
    "Primary-secondary decoupler"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-90})));
  SwitchBox switchBox(redeclare final package Medium = Medium, m_flow_nominal=
        max(mHeaWat_flow_nominal, mChiWat_flow_nominal)) "Flow switch box"
    annotation (Placement(transformation(extent={{-10,-390},{10,-370}})));
  // MISCELLANEOUS VARIABLES
  Medium.ThermodynamicState sta_a=if allowFlowReversalDis then
    Medium.setState_phX(port_a.p,
      noEvent(actualStream(port_a.h_outflow)),
      noEvent(actualStream(port_a.Xi_outflow))) else
  Medium.setState_phX(port_a.p,
      inStream(port_a.h_outflow),
      inStream(port_a.Xi_outflow)) if show_T
    "Medium properties in port_a";
  Medium.ThermodynamicState sta_b=if allowFlowReversalDis then
    Medium.setState_phX(port_b.p,
      noEvent(actualStream(port_b.h_outflow)),
      noEvent(actualStream(port_b.Xi_outflow))) else
    Medium.setState_phX(port_b.p,
      port_b.h_outflow,
      port_b.Xi_outflow) if  show_T
    "Medium properties in port_b";
  Buildings.Controls.OBC.CDL.Continuous.Product swiOff
    "Switch off the pump in case of no cooling request"
    annotation (Placement(transformation(extent={{-134,-10},{-114,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{-170,20},{-150,40}})));
initial equation
  assert(QCoo_flow_nominal <= 0,
    "In " + getInstanceName() +
    ": Nominal cooling heat flow rate must be negative. Obtained QCoo_flow_nominal = " +
    String(QCoo_flow_nominal));
  assert(QHea_flow_nominal > 0,
    "In " + getInstanceName() +
    ": Nominal heating heat flow rate must be positive. Obtained QHea_flow_nominal = " +
    String(QHea_flow_nominal));
equation
  connect(pumEva.port_a, volMix_a.ports[1])
    annotation (Line(points={{-110,120},{-240,120},{-240,-340},{-260,-340},{
          -260,-360},{-262.667,-360}},                     color={0,127,255}));
  connect(senMasFloHeaWat.m_flow, have_reqHea.u) annotation (Line(points={{-220,
          349},{-220,280},{-212,280}}, color={0,0,127}));
  connect(TSetHeaWat, heaPum.TSet) annotation (Line(points={{-300,200},{20,200},
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
  connect(TSetChiWat, conTChiWat.u_s) annotation (Line(points={{-300,40},{-180,
          40},{-180,0},{-172,0}},
                  color={0,0,127}));
  connect(gai4.y, pum2CooHex.m_flow_in) annotation (Line(points={{-118,-40},{-100,
          -40},{-100,-208}},  color={0,0,127}));
  connect(senMasFloChiWat.m_flow, gai4.u) annotation (Line(points={{-220,-69},{-220,
          -40},{-142,-40}},        color={0,0,127}));
  connect(PPum, PPum)
    annotation (Line(points={{300,400},{300,400}}, color={0,0,127}));
  connect(heaPum.P, PCom) annotation (Line(points={{-11,126},{-28,126},{-28,100},
          {160,100},{160,440},{300,440}},
                 color={0,0,127}));
  connect(mulSum.y, PCoo)
    annotation (Line(points={{252,320},{300,320}}, color={0,0,127}));
  connect(mulSum1.y, PHea)
    annotation (Line(points={{252,360},{300,360}}, color={0,0,127}));
  connect(pumCon.P, PPumHea.u[1]) annotation (Line(points={{89,169},{40,169},{40,
          200},{168,200},{168,421}},     color={0,0,127}));
  connect(pumEva.P, PPumHea.u[2]) annotation (Line(points={{-89,129},{-89,128},{
          -80,128},{-80,180},{162,180},{162,420},{168,420},{168,419}},
                                              color={0,0,127}));
  connect(pum1HexChi.P, PPumCoo.u[1]) annotation (Line(points={{109,-251},{100,-251},
          {100,-238},{160,-238},{160,381},{168,381}},
                                          color={0,0,127}));
  connect(pum2CooHex.P, PPumCoo.u[2]) annotation (Line(points={{-89,-211},{-89,-201},
          {182,-201},{182,24},{264,24},{264,379},{168,379}},    color={0,0,127}));
  connect(PPumHea.y, mulSum1.u[1]) annotation (Line(points={{192,420},{220,420},
          {220,360},{228,360}}, color={0,0,127}));
  connect(PPumCoo.y, mulSum.u[1]) annotation (Line(points={{192,380},{210,380},{
          210,320},{228,320}}, color={0,0,127}));
  connect(PPumHea.y, mulSum2.u[1]) annotation (Line(points={{192,420},{200,420},
          {200,401},{228,401}}, color={0,0,127}));
  connect(PPumCoo.y, mulSum2.u[2]) annotation (Line(points={{192,380},{200,380},
          {200,340},{214,340},{214,399},{228,399}},
                                color={0,0,127}));
  connect(mulSum2.y, PPum)
    annotation (Line(points={{252,400},{300,400}}, color={0,0,127}));
  connect(pum1HexChi.port_b, hexChi.port_a1) annotation (Line(points={{110,-260},
          {10,-260}},                              color={0,127,255}));
  connect(pum2CooHex.port_b, hexChi.port_a2)
    annotation (Line(points={{-90,-220},{-20,-220},{-20,-248},{-10,-248}},
                                                  color={0,127,255}));
  connect(pumEva.port_b, heaPum.port_a2)
    annotation (Line(points={{-90,120},{-10,120}}, color={0,127,255}));
  connect(heaPum.port_b2, volMix_b.ports[1]) annotation (Line(points={{10,120},
          {240,120},{240,-340},{258,-340},{258,-360},{257.333,-360}},
                                               color={0,127,255}));
  connect(heaPum.port_b1, senTConLvg.port_a) annotation (Line(points={{-10,132},
          {-30,132},{-30,160},{-150,160}},     color={0,127,255}));
  connect(pumCon.port_b, heaPum.port_a1) annotation (Line(points={{90,160},{40,160},
          {40,132},{10,132}},         color={0,127,255}));
  connect(ports_a1[1], senMasFloHeaWat.port_a) annotation (Line(points={{-280,
          120},{-280,140},{-260,140},{-260,360},{-230,360}},
                                             color={0,127,255}));
  connect(ports_a1[2], senMasFloChiWat.port_a) annotation (Line(points={{-280,
          120},{-260,120},{-260,-80},{-230,-80}},
                                               color={0,127,255}));
  connect(senTHeaWatSup.port_b, ports_b1[1]) annotation (Line(points={{50,380},
          {140,380},{140,140},{280,140},{280,120}},
                                         color={0,127,255}));
  connect(senTChiWatSup.port_b, ports_b1[2]) annotation (Line(points={{50,-60},
          {260,-60},{260,120},{280,120}},  color={0,127,255}));
  connect(pum1HexChi.m_flow_actual, mCoo_flow) annotation (Line(points={{109,-255},
          {102,-255},{102,-240},{162,-240},{162,240},{300,240}}, color={0,0,127}));
  connect(pumEva.m_flow_actual, mHea_flow) annotation (Line(points={{-89,125},{-78,
          125},{-78,180},{162,180},{162,280},{300,280}}, color={0,0,127}));
  connect(bouHea.ports[1], volHeaWatRet.ports[1]) annotation (Line(points={{40,240},
          {40,220},{19.3333,220}}, color={0,127,255}));
  connect(bouChi.ports[1], volChiWat.ports[1]) annotation (Line(points={{-200,
          -140},{-200,-160},{-182.667,-160}},
                                  color={0,127,255}));
  connect(volHeaWatRet.ports[2], pumCon.port_a) annotation (Line(points={{22,220},
          {120,220},{120,160},{110,160}},      color={0,127,255}));
  connect(volChiWat.ports[2], pum2CooHex.port_a) annotation (Line(points={{-180,
          -160},{-220,-160},{-220,-220},{-110,-220}},
                                                   color={0,127,255}));
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
  connect(decChiWat.ports_b[2], volChiWat.ports[3]) annotation (Line(points={{2,-100},
          {0,-100},{0,-160},{-177.333,-160}},      color={0,127,255}));
  connect(port_a, switchBox.port_aSup) annotation (Line(points={{-280,-400},{-4,
          -400},{-4,-390}}, color={0,127,255}));
  connect(switchBox.port_bRet, port_b) annotation (Line(points={{4,-390},{4,-400},
          {280,-400}}, color={0,127,255}));
  connect(volMix_a.ports[2], switchBox.port_bSup) annotation (Line(points={{-260,
          -360},{-4,-360},{-4,-370}}, color={0,127,255}));
  connect(switchBox.port_aRet, volMix_b.ports[2]) annotation (Line(points={{4,-370},
          {4,-360},{260,-360}}, color={0,127,255}));
  connect(volMix_b.ports[3], pum1HexChi.port_a) annotation (Line(points={{262.667,
          -360},{254,-360},{254,-350},{220,-350},{220,-260},{130,-260}},
                                                   color={0,127,255}));
  connect(hexChi.port_b1, volMix_a.ports[3]) annotation (Line(points={{-10,-260},
          {-220,-260},{-220,-350},{-257.333,-350},{-257.333,-360}},
                                            color={0,127,255}));
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
    Icon(coordinateSystem(extent={{-280,-280},{280,280}}, preserveAspectRatio=false),
     graphics={Rectangle(
        extent={{-280,-280},{280,280}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{18,-38},{46,-10}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-169,-344},{131,-384}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-280,0},{280,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-280,0},{280,-8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(extent={{-280,-460},{280,460}},
          preserveAspectRatio=false), graphics={Text(
          extent={{-110,-6},{-42,-34}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="Add minimum pump flow rate")}));
end ETSSimplified_bck;
