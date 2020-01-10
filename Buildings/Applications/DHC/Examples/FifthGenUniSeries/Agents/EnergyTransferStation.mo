within Buildings.Applications.DHC.Examples.FifthGenUniSeries.Agents;
model EnergyTransferStation
  "Model of a substation for heating hot water and chilled water production"
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium
    "Medium model for water"
    annotation (choicesAllMatching = true);
  outer
    Buildings.Applications.DHC.Examples.FifthGenUniSeries.Examples.DesignDataDHC
    datDes "DHC systenm design data";
  // SYSTEM GENERAL
  parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(
    min=Modelica.Constants.eps)
    "Design cooling thermal power (always positive)"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(
    min=Modelica.Constants.eps)
    "Design heating thermal power (always positive)"
    annotation (Dialog(group="Nominal conditions"));
  parameter Modelica.SIunits.TemperatureDifference dT_nominal = 5
    "Water temperature drop/increase accross CHW HX, condenser or evaporator (always positive)"
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
  Modelica.Blocks.Interfaces.RealOutput PCom(final unit="W")
    "Power drawn by compressor"
    annotation (Placement(transformation(extent={{280,360},{320,400}}),
        iconTransformation(extent={{280,250},{300,270}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W")
    "Power drawn by pumps motors"
    annotation (Placement(transformation(extent={{280,320},{320,360}}),
        iconTransformation(extent={{280,230},{300,250}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(unit="W")
    "Total power consumed for space heating"
    annotation (Placement(transformation(extent={{280,280},{320,320}}),
        iconTransformation(extent={{280,210},{300,230}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(unit="W")
    "Total power consumed for space cooling"
    annotation (Placement(transformation(extent={{280,240},{320,280}}),
        iconTransformation(extent={{280,190},{300,210}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default)) "Fluid connector a"
    annotation (Placement(transformation(extent={{-290,-10},{-270,10}}),
        iconTransformation(extent={{-300,-20},{-260,20}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default)) "Fluid connector b"
    annotation (Placement(transformation(extent={{290,-10},{270,10}}),
        iconTransformation(extent={{298,-20},{258,20}})));
  Medium.ThermodynamicState sta_a=
    Medium.setState_phX(port_a.p,
      noEvent(actualStream(port_a.h_outflow)),
      noEvent(actualStream(port_a.Xi_outflow))) if show_T
    "Medium properties in port_a";
  Medium.ThermodynamicState sta_b=
    Medium.setState_phX(port_b.p,
      noEvent(actualStream(port_b.h_outflow)),
      noEvent(actualStream(port_b.Xi_outflow))) if show_T
    "Medium properties in port_b";
  Buildings.Fluid.Delays.DelayFirstOrder volMix_a(
    redeclare final package Medium = Medium,
    nPorts=3,
    final m_flow_nominal=(mEva_flow_nominal + m1HexChi_flow_nominal)/2,
    final allowFlowReversal=true,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{-270,10},{-250,30}})));
  Buildings.Fluid.Delays.DelayFirstOrder volMix_b(
    redeclare final package Medium = Medium,
    nPorts=3,
    final m_flow_nominal=(mEva_flow_nominal + m1HexChi_flow_nominal)/2,
    final allowFlowReversal=true,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{250,10},{270,30}})));
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(Medium.setState_pTX(
      p = Medium.p_default,
      T = Medium.T_default,
      X = Medium.X_default))
    "Specific heat capacity of the fluid";
  // Components
  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final m1_flow_nominal=mCon_flow_nominal,
    final m2_flow_nominal=mEva_flow_nominal,
    final dTEva_nominal=TEvaLvg_nominal - TEvaEnt_nominal,
    final dTCon_nominal=TConLvg_nominal - TConEnt_nominal,
    final allowFlowReversal1=false,
    final allowFlowReversal2=allowFlowReversal,
    final use_eta_Carnot_nominal=false,
    final COP_nominal=COP_nominal,
    final QCon_flow_nominal=QHea_flow_nominal,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=dp_nominal)
    "Heat pump (index 1 for condenser)"
    annotation (Placement(transformation(extent={{-20,56},{0,76}})));
  Examples.BaseClasses.Pump_m_flow pumEva(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mEva_flow_nominal) "Evaporator pump"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Examples.BaseClasses.Pump_m_flow pum1HexChi(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m1HexChi_flow_nominal)
    "Chilled water HX primary pump"
    annotation (Placement(transformation(extent={{10,-310},{-10,-290}})));
  Modelica.Blocks.Interfaces.RealOutput mHea_flow
    "Mass flow rate used for heating (heat pump evaporator)" annotation (
      Placement(transformation(extent={{280,200},{320,240}}),
        iconTransformation(extent={{280,130},{300,150}})));
  Modelica.Blocks.Interfaces.RealOutput mCoo_flow
    "Mass flow rate used for cooling (CHW HX primary)"      annotation (
     Placement(transformation(extent={{280,160},{320,200}}),
        iconTransformation(extent={{280,110},{300,130}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aHeaWat(
    redeclare package Medium = Medium,
    h_outflow(start=Medium.h_default))
    "Fluid connector a"
    annotation (Placement(transformation(extent={{-290,410},{-270,430}}),
        iconTransformation(extent={{-300,-140},{-260,-100}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bHeaWat(
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default))
    "Fluid connector b"
    annotation (Placement(transformation(extent={{290,410},{270,430}}),
        iconTransformation(extent={{300,-140},{260,-100}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aChi(
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default))
    "Fluid connector a"
    annotation (Placement(transformation(extent={{-290,-430},{-270,-410}}),
        iconTransformation(extent={{-300,-260},{-260,-220}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bChi(
    redeclare final package Medium = Medium,
    h_outflow(start=Medium.h_default))
    "Fluid connector b"
    annotation (Placement(transformation(extent={{290,-430},{270,-410}}),
        iconTransformation(extent={{300,-262},{260,-222}})));
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
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal) "Chilled water HX"
    annotation (Placement(transformation(extent={{-60,-324},{-40,-344}})));
  Modelica.Blocks.Interfaces.RealInput TSetHeaWat
    "Heating water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-300,200}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-290,262})));
  Modelica.Blocks.Interfaces.RealInput TSetChiWat
    "Chilled water set point"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-300,-360}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-290,178})));
  Buildings.Fluid.Delays.DelayFirstOrder volHeaWat(
    redeclare final package Medium = Medium,
    nPorts=5,
    final m_flow_nominal=mCon_flow_nominal,
    final allowFlowReversal=true,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume representing the decoupler of the HHW distribution system"
    annotation (Placement(transformation(extent={{-10,420},{10,440}})));
  Examples.BaseClasses.Pump_m_flow pumCon(
    redeclare package Medium = Medium,
    final m_flow_nominal=mCon_flow_nominal)
    "Condenser pump"
    annotation (Placement(transformation(extent={{-110,110},{-90,130}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senT2HexChiLvg(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m2HexChi_flow_nominal)
    "Chilled water supply temperature (sensed)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-340})));
  Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysWitHol(
    uLow=1E-4*mHeaWat_flow_nominal,
    uHigh=0.01*mHeaWat_flow_nominal,
    trueHoldDuration=0,
    falseHoldDuration=30)
    annotation (Placement(transformation(extent={{-220,130},{-200,150}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloHeaWat(
    redeclare final package Medium = Medium,
    allowFlowReversal=allowFlowReversal)
    "Heating water mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{-250,430},{-230,410}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=mCon_flow_nominal)
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    annotation (Placement(transformation(extent={{-190,130},{-170,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=mEva_flow_nominal)
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Fluid.Delays.DelayFirstOrder volChiWat(
    redeclare final package Medium = Medium,
    nPorts=5,
    final m_flow_nominal=m2HexChi_flow_nominal,
    final allowFlowReversal=true,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume representing the decoupler of the CHW distribution system"
    annotation (Placement(transformation(extent={{-10,-420},{10,-440}})));
  Examples.BaseClasses.Pump_m_flow pum2CooHex(
    redeclare package Medium = Medium,
    final m_flow_nominal=m2HexChi_flow_nominal)
    "Chilled water HX secondary pump"
    annotation (Placement(transformation(extent={{-110,-350},{-90,-330}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloChiWat(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal)
    "Chilled water mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{-250,-430},{-230,-410}})));
  Buildings.Controls.OBC.CDL.Continuous.HysteresisWithHold hysWitHol1(
    uLow=1E-4*mChiWat_flow_nominal,
    uHigh=0.01*mChiWat_flow_nominal,
    trueHoldDuration=0,
    falseHoldDuration=30)
    annotation (Placement(transformation(extent={{-220,-250},{-200,-230}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    annotation (Placement(transformation(extent={{-190,-250},{-170,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(k=m1HexChi_flow_nominal)
    annotation (Placement(transformation(extent={{-140,-250},{-120,-230}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTConLvg(
    redeclare final package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=mCon_flow_nominal)
    "Condenser water leaving temperature (sensed)"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={20,72})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat(
    each Ti=120,
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    reverseAction=true,
    each yMin=0) "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{-170,-190},{-150,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro
    annotation (Placement(transformation(extent={{-88,-250},{-68,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai4(k=1.1)
    annotation (Placement(transformation(extent={{-140,-290},{-120,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=1)
    annotation (Placement(transformation(extent={{230,250},{250,270}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(nin=2)
    annotation (Placement(transformation(extent={{230,290},{250,310}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumHea(nin=2)
    "Total power drawn by pumps motors for space heating (ETS included, building excluded)"
    annotation (Placement(transformation(extent={{190,350},{210,370}})));
  Buildings.Fluid.Sources.Boundary_pT bouHea(
    redeclare final package Medium = Medium,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-40,370},{-20,390}})));
  Buildings.Fluid.Sources.Boundary_pT bouChi(
    redeclare final package Medium = Medium,
    nPorts=1)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-40,-390},{-20,-370}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum PPumCoo(nin=2)
    "Total power drawn by pumps motors for space cooling (ETS included, building excluded)"
    annotation (Placement(transformation(extent={{190,310},{210,330}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum2(nin=2)
    annotation (Placement(transformation(extent={{230,330},{250,350}})));
protected
  constant Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi])
    "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default_check=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";
initial equation
  assert(abs((cp_default - cp_default_check) / cp_default) < 0.1,
    "In " + getInstanceName() +
    ": Wrong cp_default value. Check cp_default constant.");
  assert(QCoo_flow_nominal > 0,
    "In " + getInstanceName() +
    "Nominal cooling rate must be strictly positive. Obtained QCoo_flow_nominal = " +
    String(QCoo_flow_nominal));
  assert(QHea_flow_nominal > 0,
    "In " + getInstanceName() +
    "Nominal heating rate must be strictly positive. Obtained QHea_flow_nominal = " +
    String(QHea_flow_nominal));
equation
  connect(pumEva.port_b, heaPum.port_a2) annotation (Line(points={{-90,0},{40,0},
          {40,60},{0,60}}, color={0,127,255}));
  connect(volMix_a.ports[1], port_a) annotation (Line(points={{-262.667,10},{
          -262.667,0},{-280,0}},
                             color={0,127,255}));
  connect(pumEva.port_a, volMix_a.ports[2])
    annotation (Line(points={{-110,0},{-260,0},{-260,10}}, color={0,127,255}));
  connect(heaPum.port_b2, volMix_b.ports[1]) annotation (Line(points={{-20,60},
          {-60,60},{-60,20},{200,20},{200,0},{258,0},{258,10},{257.333,10}},
                color={0,127,255}));
  connect(port_b, volMix_b.ports[2]) annotation (Line(points={{280,0},{260,0},{260,
          10}},             color={0,127,255}));

  connect(volHeaWat.ports[1], port_bHeaWat)
    annotation (Line(points={{-3.2,420},{280,420}},
                                                  color={0,127,255}));
  connect(pumCon.port_b, heaPum.port_a1) annotation (Line(points={{-90,120},{-60,
          120},{-60,72},{-20,72}}, color={0,127,255}));
  connect(volHeaWat.ports[2], pumCon.port_a) annotation (Line(points={{-1.6,420},
          {-1.6,400},{-260,400},{-260,120},{-110,120}},
                                                     color={0,127,255}));
  connect(hexChi.port_b1, senT2HexChiLvg.port_a)
    annotation (Line(points={{-40,-340},{30,-340}}, color={0,127,255}));
  connect(hexChi.port_a2, pum1HexChi.port_b) annotation (Line(points={{-40,-328},
          {-20,-328},{-20,-300},{-10,-300}}, color={0,127,255}));
  connect(volMix_b.ports[3], pum1HexChi.port_a) annotation (Line(points={{262.667,
          10},{262.667,14},{262,14},{262,8},{260,8},{260,-300},{10,-300}},
        color={0,127,255}));
  connect(hexChi.port_b2, volMix_a.ports[3]) annotation (Line(points={{-60,-328},
          {-80,-328},{-80,-300},{-260,-300},{-260,10},{-257.333,10}}, color={0,127,
          255}));
  connect(port_aHeaWat, senMasFloHeaWat.port_a)
    annotation (Line(points={{-280,420},{-250,420}}, color={0,127,255}));
  connect(senMasFloHeaWat.port_b, volHeaWat.ports[3])
    annotation (Line(points={{-230,420},{0,420}}, color={0,127,255}));
  connect(senMasFloHeaWat.m_flow, hysWitHol.u) annotation (Line(points={{-240,409},
          {-240,140},{-222,140}}, color={0,0,127}));
  connect(TSetHeaWat, heaPum.TSet) annotation (Line(points={{-300,200},{-30,200},
          {-30,75},{-22,75}}, color={0,0,127}));
  connect(hysWitHol.y, booToRea.u)
    annotation (Line(points={{-198,140},{-192,140}}, color={255,0,255}));
  connect(booToRea.y, gai.u)
    annotation (Line(points={{-168,140},{-142,140}}, color={0,0,127}));
  connect(gai.y, pumCon.m_flow_in) annotation (Line(points={{-118,140},{-100,140},
          {-100,132}}, color={0,0,127}));
  connect(gai1.y, pumEva.m_flow_in)
    annotation (Line(points={{-118,80},{-100,80},{-100,12}}, color={0,0,127}));
  connect(booToRea.y, gai1.u) annotation (Line(points={{-168,140},{-160,140},{-160,
          80},{-142,80}}, color={0,0,127}));
  connect(volChiWat.ports[1], port_bChi)
    annotation (Line(points={{-3.2,-420},{280,-420}},
                                                    color={0,127,255}));
  connect(hexChi.port_a1, pum2CooHex.port_b)
    annotation (Line(points={{-60,-340},{-90,-340}}, color={0,127,255}));
  connect(volChiWat.ports[2], pum2CooHex.port_a) annotation (Line(points={{-1.6,
          -420},{-1.6,-400},{-200,-400},{-200,-340},{-110,-340}},
                                                          color={0,127,255}));
  connect(senT2HexChiLvg.port_b, volChiWat.ports[3]) annotation (Line(points={{50,-340},
          {80,-340},{80,-400},{4,-400},{4,-420},{0,-420}},       color={0,127,255}));
  connect(port_aChi, senMasFloChiWat.port_a)
    annotation (Line(points={{-280,-420},{-250,-420}}, color={0,127,255}));
  connect(senMasFloChiWat.port_b, volChiWat.ports[4])
    annotation (Line(points={{-230,-420},{1.6,-420}},
                                                    color={0,127,255}));
  connect(senMasFloChiWat.m_flow, hysWitHol1.u) annotation (Line(points={{-240,-409},
          {-240,-240},{-222,-240}}, color={0,0,127}));
  connect(hysWitHol1.y, booToRea1.u)
    annotation (Line(points={{-198,-240},{-192,-240}}, color={255,0,255}));
  connect(booToRea1.y, gai2.u)
    annotation (Line(points={{-168,-240},{-142,-240}}, color={0,0,127}));
  connect(senT2HexChiLvg.T, conTChiWat.u_m) annotation (Line(points={{40,-329},{
          40,-180},{-160,-180},{-160,-188}}, color={0,0,127}));
  connect(TSetChiWat, conTChiWat.u_s) annotation (Line(points={{-300,-360},{-248,
          -360},{-248,-200},{-172,-200}}, color={0,0,127}));
  connect(gai2.y, pro.u2) annotation (Line(points={{-118,-240},{-100,-240},{-100,
          -246},{-90,-246}}, color={0,0,127}));
  connect(pro.y, pum1HexChi.m_flow_in)
    annotation (Line(points={{-66,-240},{0,-240},{0,-288}}, color={0,0,127}));
  connect(conTChiWat.y, pro.u1) annotation (Line(points={{-148,-200},{-100,-200},
          {-100,-234},{-90,-234}}, color={0,0,127}));
  connect(gai4.y, pum2CooHex.m_flow_in) annotation (Line(points={{-118,-280},{-100,
          -280},{-100,-328}}, color={0,0,127}));
  connect(senMasFloChiWat.m_flow, gai4.u) annotation (Line(points={{-240,-409},{
          -240,-280},{-142,-280}}, color={0,0,127}));
  connect(heaPum.port_b1, senTConLvg.port_a)
    annotation (Line(points={{0,72},{10,72}}, color={0,127,255}));
  connect(senTConLvg.port_b, volHeaWat.ports[4]) annotation (Line(points={{30,72},
          {40,72},{40,400},{2,400},{2,420},{1.6,420}},
                                                     color={0,127,255}));
  connect(PPum, PPum)
    annotation (Line(points={{300,340},{300,340}}, color={0,0,127}));
  connect(heaPum.P, PCom) annotation (Line(points={{1,66},{260,66},{260,380},{300,
          380}}, color={0,0,127}));
  connect(gai1.y, mHea_flow) annotation (Line(points={{-118,80},{-100,80},{-100,
          100},{264,100},{264,220},{300,220}}, color={0,0,127}));
  connect(gai4.y, mCoo_flow) annotation (Line(points={{-118,-280},{220,-280},{220,
          180},{300,180}}, color={0,0,127}));
  connect(mulSum.y, PCoo)
    annotation (Line(points={{252,260},{300,260}}, color={0,0,127}));
  connect(mulSum1.y, PHea)
    annotation (Line(points={{252,300},{300,300}}, color={0,0,127}));
  connect(pumCon.P, PPumHea.u[1]) annotation (Line(points={{-89,129},{160,129},{
          160,360},{188,360},{188,361}},
                                  color={0,0,127}));
  connect(pumEva.P, PPumHea.u[2]) annotation (Line(points={{-89,9},{-89,20},{160,
          20},{160,360},{188,360},{188,359}}, color={0,0,127}));
  connect(bouHea.ports[1], volHeaWat.ports[5]) annotation (Line(points={{-20,380},
          {3.2,380},{3.2,420}}, color={0,127,255}));
  connect(bouChi.ports[1], volChiWat.ports[5]) annotation (Line(points={{-20,-380},
          {0,-380},{0,-420},{3.2,-420}}, color={0,127,255}));
  connect(pum1HexChi.P, PPumCoo.u[1]) annotation (Line(points={{-11,-291},{180,-291},
          {180,320},{188,320},{188,321}}, color={0,0,127}));
  connect(pum2CooHex.P, PPumCoo.u[2]) annotation (Line(points={{-89,-331},{-86,-331},
          {-86,-228},{180,-228},{180,320},{188,320},{188,319}}, color={0,0,127}));
  connect(PPumHea.y, mulSum1.u[1]) annotation (Line(points={{212,360},{224,360},
          {224,301},{228,301}}, color={0,0,127}));
  connect(gai1.y, mulSum1.u[2]) annotation (Line(points={{-118,80},{-100,80},{-100,
          100},{200,100},{200,300},{228,300},{228,299}}, color={0,0,127}));
  connect(PPumCoo.y, mulSum.u[1]) annotation (Line(points={{212,320},{218,320},{
          218,260},{228,260}}, color={0,0,127}));
  connect(PPumHea.y, mulSum2.u[1]) annotation (Line(points={{212,360},{218,360},
          {218,341},{228,341}}, color={0,0,127}));
  connect(PPumCoo.y, mulSum2.u[2]) annotation (Line(points={{212,320},{218,320},
          {218,339},{228,339}}, color={0,0,127}));
  connect(mulSum2.y, PPum)
    annotation (Line(points={{252,340},{300,340}}, color={0,0,127}));
  annotation (
  defaultComponentName="bui",
  Documentation(info="<html>
<p>
Model for a substation with space heating and space cooling.
</p>
<p>
The model takes as parameters
the temperature lift on the primary side and
and then draws the required amount of water.
The load is specified by a file that contains
time series for the load profiles. This file needs to have
the following format:
</p>
<pre>
#1
#Heating and Cooling Model loads for a SF large office
#First column: Seconds in the year (loads are hourly)
#Second column: cooling loads in Watts (as negative numbers).
#Third column: space heating loads in Watts. Heating is a combination of electric space heating, gas space heating
#Gas heaters in the model were 80% efficient where electric heaters were 100% efficient. Here the total watts = electric watts + .80*(gas watts)
#Fourth column: water heating = 0.8 * gas water watts
#Peak space cooling load = -383165.6989 Watts
#Peak space heating load = 893931.4335 Watts
#Peak water heating load = 19496.90012 Watts
double tab1(8760,4)
0,0,5972.314925,16
3600,0,4925.839944,1750.915684
7200,0,7470.393385,1750.971979
[to be continued]
</pre>
<p>
Values at intermediate times are interpolated using cubic Hermite splines.
</p>
<h4>Implementation</h4>
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
</html>", revisions="<html>
<ul>
<li>
December 12, 2017, by Michael Wetter:<br/>
Removed call to <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1097\">issue 1097</a>.
</li>
<li>
November 28, 2016, by Michael Wetter:<br/>
Added call to <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/585\">#585</a>.
</li>
<li>
August 8, 2016, by Michael Wetter:<br/>
Changed default temperature to compute COP to be the leaving temperature as
use of the entering temperature can violate the 2nd law if the temperature
lift is small.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/497\">
Annex 60, issue 497</a>.
</li>
<li>
June 26, 2016, by Michael Wetter:<br/>
Changed interpolation for combi table with load data
to use cubic hermite splines.
This is because previously, the table did not generate events
when using linear interpolation, which caused the
solver to take too big steps, missing data points in the table.
This is due to Dassault SR00312338.
</li>
<li>
April 21, 2016, by Michael Wetter:<br/>
Added gains to scale loads and peak load.
</li>
<li>
February 23, 2016, by Michael Wetter:<br/>
Removed the wrong attributes <code>port_a.m_flow.min</code> and <code>port_b.m_flow.max</code>,
which were used by the solver and hence caused non-convergence.
This is for Dassault SR 312338.
</li>
<li>
December 1, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-280,-280},{280,280}}, preserveAspectRatio=false),
                                                           graphics={
                                Rectangle(
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
          extent={{-282,-234},{280,-250}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-280,-128},{280,-112}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-280,0},{280,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-280,0},{282,-8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(extent={{-280,-460},{280,460}},
          preserveAspectRatio=false), graphics={Text(
          extent={{-106,-256},{-38,-284}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="Add minimum pump flow rate")}));
end EnergyTransferStation;
