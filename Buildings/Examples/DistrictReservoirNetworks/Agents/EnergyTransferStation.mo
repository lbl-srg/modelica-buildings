within Buildings.Examples.DistrictReservoirNetworks.Agents;
model EnergyTransferStation
  "Substation for heating, free cooling and domestic hot water with load as a time series. Instead of a chiller FC HEX is implemented. A new simple FC HEX used. With new contolling strategz"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium model for water"
      annotation (choicesAllMatching = true);
  parameter Real gaiMFlow(min=0) = 0.95 "Gain to scale m_nominal";
  parameter Real gaiCoo(min=0) = 1 "Gain to scale cooling load";
  parameter Real gaiHea(min=0) = gaiCoo "Gain to scale heating load";
  parameter Real gaiHotWat(min=0) = gaiHea "Gain to scale hot water load";
//  parameter Modelica.SIunits.Temperature TColMin = 273.15+8
//    "Minimum temperature of district cold water supply";
//  parameter Modelica.SIunits.Temperature THotMax = 273.15+18
//    "Maximum temperature of district hot water supply";
  final parameter Modelica.SIunits.TemperatureDifference dTCooCon_nominal(
    min=0.5,
    displayUnit="K") = 4
    "Temperature difference condenser of the chiller (positive)"
    annotation(Dialog(group="Design parameter"));
  final parameter Modelica.SIunits.TemperatureDifference dTHeaEva_nominal(
    max=-0.5,
    displayUnit="K") = -4
    "Temperature difference evaporator of the heat pump for space heating (negative)"
    annotation(Dialog(group="Design parameter"));
  final parameter Modelica.SIunits.TemperatureDifference dTCooEva_nominal=-4
    "Temperature difference evaporator of the chiller";
  parameter String filNam "Name of data file with heating and cooling load"
   annotation (Dialog(
    loadSelector(filter="Load file (*.mos)",
                 caption="Select load file")));
  final parameter Modelica.SIunits.HeatFlowRate QCoo_flow_nominal(max=-Modelica.Constants.eps)=
       scaFacLoa*gaiCoo*
    Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space cooling load", filNam=filNam) "Design heat flow rate"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.SIunits.HeatFlowRate QHea_flow_nominal(min=Modelica.Constants.eps)=
       scaFacLoa*gaiHea*
    Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak space heating load", filNam=filNam) "Design heat flow rate"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.SIunits.HeatFlowRate QHotWat_flow_nominal(min=
        Modelica.Constants.eps) = scaFacLoa*
    gaiHotWat*
    Buildings.Experimental.DHC.Loads.BaseClasses.getPeakLoad(
    string="#Peak water heating load", filNam=filNam)
    "Design heat flow rate for domestic hot water"
    annotation (Dialog(group="Design parameter"));
  final parameter Modelica.SIunits.Temperature TChiSup_nominal = 273.15 + 18
    "Chilled water leaving temperature at the evaporator"
     annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.Temperature THeaSup_nominal = 273.15+38
    "Supply temperature space heating system at TOut_nominal"
    annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.Temperature THeaRet_nominal = 273.15+34
    "Return temperature space heating system at TOut_nominal"
    annotation (Dialog(group="Nominal conditions"));
//  parameter Modelica.SIunits.Temperature TOut_nominal
//    "Outside design temperature for heating"
//    annotation (Dialog(group="Nominal conditions"));
  final parameter Modelica.SIunits.TemperatureDifference dTHotWatCon_nominal(min=0)=63-15
    "Temperature difference condenser of hot water heat pump";
  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=50000
    "Pressure difference at nominal flow rate (for each flow leg)"
    annotation(Dialog(group="Design parameter"));
  final parameter Modelica.SIunits.MassFlowRate mCooCon_flow_nominal(min=0)=
    -QCoo_flow_nominal/cp_default/dTCooCon_nominal
    "Design mass flow rate for cooling at district side"
    annotation(Dialog(group="Design parameter"));
  final parameter Modelica.SIunits.MassFlowRate mHeaEva_flow_nominal(min=0)=
    -QHea_flow_nominal/cp_default/dTHeaEva_nominal
    "Design mass flow rate for space heating at district side"
    annotation(Dialog(group="Design parameter"));
  final parameter Modelica.SIunits.MassFlowRate mHotWatEva_flow_nominal(min=0)=
    QHotWat_flow_nominal/cp_default/dTHotWatCon_nominal
    "Design mass flow rate for domestic hot water at district side"
    annotation(Dialog(group="Design parameter"));
  // Diagnostics
   parameter Boolean show_T = true
    "= true, if actual temperature at port is computed"
    annotation(Dialog(tab="Advanced",group="Diagnostics"));
  parameter Modelica.Fluid.Types.Dynamics mixingVolumeEnergyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Formulation of energy balance for mixing volume at inlet and outlet"
     annotation(Dialog(tab="Dynamics"));
  Modelica.Blocks.Interfaces.RealOutput PCom(final unit="W")
    "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{280,430},{300,450}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(final unit="W")
    "Electric power consumed by pumps"
    annotation (Placement(transformation(extent={{280,390},{300,410}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(unit="W")
    "Electrical power consumed for space heating"
    annotation (Placement(transformation(extent={{280,270},{300,290}})));
  Modelica.Blocks.Interfaces.RealOutput PHotWat(unit="W")
    "Electrical power consumed for hot water"
    annotation (Placement(transformation(extent={{280,230},{300,250}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(unit="W")
    "Electrical power consumed for space cooling"
    annotation (Placement(transformation(extent={{280,190},{300,210}})));
  Modelica.Blocks.Interfaces.RealOutput QHea_flow(unit="W")
    "Space heating thermal load"
    annotation (Placement(transformation(extent={{280,130},{300,150}})));
  Modelica.Blocks.Interfaces.RealOutput QHotWat_flow(unit="W")
    "Hot water thermal load"
    annotation (Placement(transformation(extent={{280,90},{300,110}})));
  Modelica.Blocks.Interfaces.RealOutput QCoo_flow(unit="W")
    "Space cooling thermal load"
    annotation (Placement(transformation(extent={{280,50},{300,70}})));
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
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_a
    "Heat port for sensible heat input into volume a"
    annotation (Placement(transformation(extent={{-290,-100},{-270,-80}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort_b
    "Heat port for sensible heat input into volume b"
    annotation (Placement(transformation(extent={{270,-100},{290,-80}})));
  Medium.ThermodynamicState sta_a=
      Medium.setState_phX(port_a.p,
                          noEvent(actualStream(port_a.h_outflow)),
                          noEvent(actualStream(port_a.Xi_outflow))) if
         show_T "Medium properties in port_a";

  Medium.ThermodynamicState sta_b=
      Medium.setState_phX(port_b.p,
                          noEvent(actualStream(port_b.h_outflow)),
                          noEvent(actualStream(port_b.Xi_outflow))) if
          show_T "Medium properties in port_b";
  Medium.ThermodynamicState staHea_a2=
      Medium.setState_phX(heaPum.port_a2.p,
                          noEvent(actualStream(heaPum.port_a2.h_outflow)),
                          noEvent(actualStream(heaPum.port_a2.Xi_outflow))) if
       show_T "Medium properties in port_a2 of space heating heat pump intake";
  Medium.ThermodynamicState staHea_b2=
      Medium.setState_phX(heaPum.port_b2.p,
                          noEvent(actualStream(heaPum.port_b2.h_outflow)),
                          noEvent(actualStream(heaPum.port_b2.Xi_outflow))) if
       show_T "Medium properties in port_b2 of space heating heat pump outlet";
  Medium.ThermodynamicState staHotWat_a2=
      Medium.setState_phX(heaPumHotWat.port_a2.p,
                          noEvent(actualStream(heaPumHotWat.port_a2.h_outflow)),
                          noEvent(actualStream(heaPumHotWat.port_a2.Xi_outflow))) if
       show_T "Medium properties in port_a2 of hot water heat pump intake";
  Medium.ThermodynamicState staHotWat_b2=
      Medium.setState_phX(heaPumHotWat.port_b2.p,
                          noEvent(actualStream(heaPumHotWat.port_b2.h_outflow)),
                          noEvent(actualStream(heaPumHotWat.port_b2.Xi_outflow))) if
       show_T "Medium properties in port_b2 of hot water heat pump outlet";

  Buildings.Fluid.Delays.DelayFirstOrder volMix_a(
    redeclare final package Medium = Medium,
    nPorts=4,
    final m_flow_nominal=(mHeaEva_flow_nominal + mCooCon_flow_nominal +
        mHotWatEva_flow_nominal)/2,
    final allowFlowReversal=true,
    tau=600,
    final energyDynamics=mixingVolumeEnergyDynamics)
    "Mixing volume to break algebraic loops and to emulate the delay of the substation"
    annotation (Placement(transformation(extent={{-270,10},{-250,30}})));
  Buildings.Fluid.Delays.DelayFirstOrder volMix_b(
    redeclare final package Medium = Medium,
    nPorts=4,
    final m_flow_nominal=(mHeaEva_flow_nominal + mCooCon_flow_nominal +
        mHotWatEva_flow_nominal)/2,
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
  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    final dTEva_nominal=dTHeaEva_nominal,
    final dTCon_nominal=THeaSup_nominal-THeaRet_nominal,
    final allowFlowReversal1=false,
    final allowFlowReversal2=allowFlowReversal,
    final use_eta_Carnot_nominal=true,
    final etaCarnot_nominal=0.5,
    final QCon_flow_nominal=QHea_flow_nominal,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=dp_nominal,
    m2_flow_nominal = gaiMFlow*heaPum.QEva_flow_nominal/cp_default/heaPum.dTEva_nominal)
    "Heat pump"
    annotation (Placement(transformation(extent={{22,212},{42,232}})));
  Examples.BaseClasses.Pump_m_flow pumHea(
    redeclare package Medium = Medium,
    final m_flow_nominal=mHeaEva_flow_nominal)
    "Pump for space heating heat pump"
    annotation (Placement(transformation(extent={{30,290},{50,310}})));
  Examples.BaseClasses.Pump_m_flow pumHotWat(
    redeclare package Medium = Medium,
    final m_flow_nominal=mHotWatEva_flow_nominal)
    "Pump"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  Buildings.Fluid.HeatPumps.Carnot_TCon heaPumHotWat(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    final dTEva_nominal=dTHeaEva_nominal,
    final allowFlowReversal1=false,
    final allowFlowReversal2=allowFlowReversal,
    final use_eta_Carnot_nominal=true,
    final etaCarnot_nominal=0.5,
    final dp1_nominal=dp_nominal,
    final dp2_nominal=dp_nominal,
    final QCon_flow_nominal=QHotWat_flow_nominal,
    final dTCon_nominal=dTHotWatCon_nominal,
    m2_flow_nominal = gaiMFlow*heaPumHotWat.QEva_flow_nominal/cp_default/heaPumHotWat.dTEva_nominal) "Heat pump"
    annotation (Placement(transformation(extent={{20,-92},{40,-72}})));
  Examples.BaseClasses.Pump_m_flow pumChi(
    redeclare package Medium = Medium,
    final m_flow_nominal=gaiMFlow*mCooCon_flow_nominal)
    "Pump"
    annotation (Placement(transformation(extent={{-130,-350},{-110,-330}})));
  Fluid.Sensors.TemperatureTwoPort
    senTem1(                         redeclare package Medium = Medium,
      allowFlowReversal=true,
    m_flow_nominal=gaiMFlow*mCooCon_flow_nominal)
                               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-10,-340})));
  Fluid.Sensors.TemperatureTwoPort
    senTem(                       redeclare package Medium = Medium,
      allowFlowReversal=true,
    m_flow_nominal=gaiMFlow*mCooCon_flow_nominal)
                               annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-172,-340})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_HPSH "in kg/s"
    annotation (Placement(transformation(extent={{274,-150},{294,-130}}),
        iconTransformation(extent={{274,-150},{294,-130}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_HPDHW "in kg/s"
    annotation (Placement(transformation(extent={{274,-210},{294,-190}}),
        iconTransformation(extent={{274,-210},{294,-190}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_FC "in kg/s" annotation (
     Placement(transformation(extent={{274,-270},{294,-250}}),
        iconTransformation(extent={{274,-270},{294,-250}})));
  Buildings.Fluid.Sources.MassFlowSource_T souHotWat(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=false,
    final T=288.15) "Mass flow source"
    annotation (Placement(transformation(extent={{-22,-86},{-2,-66}})));
  Modelica.Blocks.Sources.Constant TSetHotWat(final k=273.15 + 63)
    "Set point for hot water temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-120,-20}})));
  Modelica.Blocks.Math.Add3 sumPPum "Sum for pump power"
    annotation (Placement(transformation(extent={{120,120},{140,140}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu1(threShold=0.001*
        QHea_flow_nominal,                                             message="Heat pump for hot water does not meet load")
    "Tests whether load is met"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Buildings.Utilities.Diagnostics.AssertEquality assEqu2(threShold=0.001*
        QHotWat_flow_nominal,                                          message="Heat pump for space heating does not meet load")
    "Tests whether load is met"
    annotation (Placement(transformation(extent={{60,250},{80,270}})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u hex(
    redeclare package Medium = Medium,
    m_flow_nominal= gaiMFlow*mCooCon_flow_nominal,
    show_T=true,
    dp_nominal=dp_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=1) "Heat exchanger for free-cooling" annotation (
      Placement(transformation(extent={{-60,-350},{-40,-330}})));
  Agents.Controls.HeatingCurve heaTemRes(
    final THeaSup_nominal=THeaSup_nominal,
    final THeaRet_nominal=THeaRet_nominal,
    final THeaSupZer=273.15 + 28) "Reset of heating temperatures"
    annotation (Placement(transformation(extent={{-140,240},{-120,260}})));
protected
  constant Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default[1:Medium.nXi]) "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default_check=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Loads"
    annotation (Placement(transformation(extent={{-270,400},{-250,420}})));
  Modelica.Blocks.Routing.DeMultiplex3 deMul "De multiplex"
    annotation (Placement(transformation(extent={{-178,400},{-158,420}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    use_m_flow_in=true,
    use_T_in=true) "Mass flow source"
    annotation (Placement(transformation(extent={{-40,218},{-20,238}})));
  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={70,230})));
  Modelica.Blocks.Math.Division mConFlow "Mass flow rate for condenser"
    annotation (Placement(transformation(extent={{-170,240},{-150,260}})));
  Modelica.Blocks.Math.Add QEva_flow(k1=-1) "Heat flow rate at evaporator"
    annotation (Placement(transformation(extent={{-40,320},{-20,340}})));
  Modelica.Blocks.Math.Add PHeaAct "Power consumption for heating"
    annotation (Placement(transformation(extent={{80,310},{100,330}})));
  Modelica.Blocks.Math.Add QEvaHotWat_flow(k1=-1)
    "Heat flow rate at evaporator"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  Modelica.Blocks.Math.Add PHotWatAct "Power consumption for heating"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Fluid.Sources.Boundary_pT sinHotWat(
    redeclare package Medium = Medium,
    nPorts=1) "Pressure source" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}}, origin={62,-74})));
  Modelica.Blocks.Math.Division mConHotWatFlow "Mass flow rate for condenser"
    annotation (Placement(transformation(extent={{-60,-78},{-40,-58}})));
  Modelica.Blocks.Sources.Constant gainHotWat(k=dTHotWatCon_nominal*cp_default)
    "Gain for hot water"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Math.Gain gaiLoa[3](final k=scaFacLoa
        *{1,1,1})
    "Gain that can be used to scale the individual loads up or down. Components are cooling, heating and hot water"
    annotation (Placement(transformation(extent={{-220,400},{-200,420}})));
  Modelica.Blocks.Math.Gain mPumHotWat_flow(
    final k=1/(cp_default*dTHeaEva_nominal))
    "Mass flow rate for hot water loop"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Modelica.Blocks.Math.Gain mPumHea_flow(
    final k=1/(cp_default*dTHeaEva_nominal)) "Mass flow rate for heating loop"
    annotation (Placement(transformation(extent={{0,320},{20,340}})));
  Modelica.Blocks.Math.Gain coolingLoadInPositive(k=-1)
    "gain for cooling to get positive values" annotation (Placement(
        transformation(extent={{-180,-404},{-160,-384}})));
  Modelica.Blocks.Math.Add sumPCom "Power consumption for compressor"
    annotation (Placement(transformation(extent={{220,430},{240,450}})));
  Modelica.Blocks.Sources.Constant QHea_nominal(k=QHea_flow_nominal)
    "Nominal heating load from building"
    annotation (Placement(transformation(extent={{-220,200},{-200,220}})));
  Modelica.Blocks.Math.Gain mHea_flow(k=1/cp_default/(THeaSup_nominal -
        THeaRet_nominal))
    "Water flow rate for space heating circuit, constant flow rate, variable dT"
    annotation (Placement(transformation(extent={{-168,200},{-148,220}})));
  Modelica.Blocks.Math.Gain mHea_flow1(k=1/cp_default/4)
    "Water flow rate for space heating circuit, constant flow rate, variable dT"
    annotation (Placement(transformation(extent={{-122,-404},{-102,-384}})));
protected
  constant Real scaFacLoa = 10 "Scaling factor for load profiles";

initial equation
  assert(abs((cp_default-cp_default_check)/cp_default) < 0.1, "Wrong cp_default value. Check cp_default constant.");
  assert(QCoo_flow_nominal < 0,
    "Nominal cooling rate must be strictly negative. Obtained QCoo_flow_nominal = "
    + String(QCoo_flow_nominal));
  assert(QHea_flow_nominal > 0,
    "Nominal heating rate must be strictly positive. Obtained QHea_flow_nominal = "
    + String(QHea_flow_nominal));
  assert(QHotWat_flow_nominal > 0,
    "Nominal hot water heating rate must be strictly positive. Obtained QHotWat_flow_nominal = "
    + String(QHotWat_flow_nominal));
equation
  connect(pumHea.port_b, heaPum.port_a2) annotation (Line(points={{50,300},{50,
          300},{100,300},{100,216},{42,216}},
                                            color={0,127,255}));
  connect(mConFlow.u1, deMul.y2[1]) annotation (Line(points={{-172,256},{-180,256},
          {-180,280},{-154,280},{-154,410},{-157,410}}, color={0,0,127}));
  connect(sou.ports[1], heaPum.port_a1) annotation (Line(points={{-20,228},{10,
          228},{22,228}},    color={0,127,255}));
  connect(heaPum.port_b1, sin1.ports[1]) annotation (Line(points={{42,228},{42,
          228},{60,228},{60,230}},
                              color={0,127,255}));
  connect(QEva_flow.u1, deMul.y2[1]) annotation (Line(points={{-42,336},{-100,336},
          {-100,398},{-100,410},{-157,410}}, color={0,0,127}));
  connect(QEva_flow.u2, heaPum.P) annotation (Line(points={{-42,324},{-60,324},{
          -60,280},{-30,280},{48,280},{48,222},{43,222}},
                                                   color={0,0,127}));
  connect(PHeaAct.y, PHea) annotation (Line(points={{101,320},{220,320},{220,
          280},{290,280}},
                      color={0,0,127}));
  connect(PHeaAct.u1, pumHea.P) annotation (Line(points={{78,326},{58,326},{58,309},
          {51,309}},      color={0,0,127}));
  connect(PHeaAct.u2, heaPum.P) annotation (Line(points={{78,314},{60,314},{60,
          280},{48,280},{48,222},{43,222}},
                                      color={0,0,127}));
  connect(QEvaHotWat_flow.u2, heaPumHotWat.P) annotation (Line(points={{-42,34},
          {-50,34},{-50,0},{-50,-20},{48,-20},{48,-82},{41,-82}},      color={0,
          0,127}));
  connect(PHotWatAct.u2, heaPumHotWat.P) annotation (Line(points={{98,14},{60,
          14},{60,-20},{48,-20},{48,-82},{41,-82}}, color={0,0,127}));
  connect(PHotWatAct.u1, pumHotWat.P) annotation (Line(points={{98,26},{58,26},{
          58,9},{51,9}},      color={0,0,127}));
  connect(heaPumHotWat.port_b1, sinHotWat.ports[1]) annotation (Line(points={{40,-76},
          {40,-74},{46,-74},{52,-74}},          color={0,127,255}));
  connect(souHotWat.ports[1], heaPumHotWat.port_a1) annotation (Line(points={{-2,-76},
          {0,-76},{20,-76}},                  color={0,127,255}));
  connect(mConHotWatFlow.y, souHotWat.m_flow_in) annotation (Line(points={{-39,-68},
          {-24,-68}},                        color={0,0,127}));
  connect(gainHotWat.y, mConHotWatFlow.u2) annotation (Line(points={{-79,-90},{
          -80,-90},{-80,-90},{-78,-90},{-70,-90},{-70,-74},{-62,-74}},
                                 color={0,0,127}));
  connect(QEvaHotWat_flow.u1, deMul.y3[1]) annotation (Line(points={{-42,46},{-42,
          44},{-92,44},{-92,403},{-157,403}},       color={0,0,127}));
  connect(PHotWatAct.y, PHotWat) annotation (Line(points={{121,20},{160,20},{
          160,240},{290,240}},
                           color={0,0,127}));
  connect(pumHotWat.port_b, heaPumHotWat.port_a2) annotation (Line(points={{50,0},{
          64,0},{80,0},{80,-88},{40,-88}},        color={0,127,255},
      thickness=0.5));
  connect(mConHotWatFlow.u1, deMul.y3[1]) annotation (Line(points={{-62,-62},{-92,
          -62},{-92,403},{-157,403}},  color={0,0,127}));
  connect(TSetHotWat.y, heaPumHotWat.TSet) annotation (Line(points={{-119,-30},{
          8,-30},{8,-73},{18,-73}},   color={0,0,127}));
  connect(volMix_a.ports[1], port_a) annotation (Line(points={{-263,10},{
          -263,0},{-280,0}}, color={0,127,255}));
  connect(pumHea.port_a, volMix_a.ports[2]) annotation (Line(points={{30,
          300},{30,300},{-242,300},{-242,2},{-262,2},{-262,0},{-262,6},{-261,
          6},{-261,10}}, color={0,127,255}));
  connect(pumHotWat.port_a, volMix_a.ports[3]) annotation (Line(
      points={{30,0},{-94,0},{-258,0},{-259,0},{-259,10}},
      color={0,127,255},
      thickness=0.5));
  connect(heaPum.port_b2, volMix_b.ports[1]) annotation (Line(points={{22,
          216},{18,216},{18,180},{200,180},{200,6},{257,6},{257,10},{257,
          10}}, color={0,127,255}));
  connect(heaPumHotWat.port_b2, volMix_b.ports[2]) annotation (Line(
      points={{20,-88},{10,-88},{10,-120},{259,-120},{259,10}},
      color={0,127,255},
      thickness=0.5));
  connect(port_b, volMix_b.ports[3]) annotation (Line(points={{280,0},{
          261,0},{261,10}}, color={0,127,255}));
  connect(deMul.y2[1], QHea_flow) annotation (Line(points={{-157,410},{
          242,410},{242,140},{290,140}},  color={0,0,127}));
  connect(deMul.y3[1], QHotWat_flow) annotation (Line(points={{-157,403},{-157,404},
          {236,404},{236,100},{290,100}},      color={0,0,127}));
  connect(deMul.y1[1], QCoo_flow) annotation (Line(points={{-157,417},{232,417},
          {232,60},{290,60}}, color={0,0,127}));
  connect(loa.y, gaiLoa.u)
    annotation (Line(points={{-249,410},{-222,410}}, color={0,0,127}));
  connect(gaiLoa.y, deMul.u)
    annotation (Line(points={{-199,410},{-180,410}}, color={0,0,127}));
  connect(volMix_a.heatPort, heatPort_a) annotation (Line(points={{-270,
          20},{-276,20},{-276,-90},{-280,-90}}, color={191,0,0}));
  connect(volMix_b.heatPort, heatPort_b) annotation (Line(points={{250,20},
          {244,20},{244,-90},{254,-90},{280,-90}}, color={191,0,0}));
  connect(QEvaHotWat_flow.y, mPumHotWat_flow.u)
    annotation (Line(points={{-19,40},{-2,40}}, color={0,0,127}));
  connect(mPumHotWat_flow.y, pumHotWat.m_flow_in)
    annotation (Line(points={{21,40},{40,40},{40,12}},     color={0,0,127}));
  connect(QEva_flow.y, mPumHea_flow.u)
    annotation (Line(points={{-19,330},{-2,330},{-2,330}}, color={0,0,127}));
  connect(mPumHea_flow.y, pumHea.m_flow_in) annotation (Line(points={{21,330},{40,
          330},{40,312}},   color={0,0,127}));
  connect(pumChi.P, PCoo) annotation (Line(points={{-109,-331},{-80,-331},
          {-80,-224},{220,-224},{220,200},{290,200}},
                      color={0,0,127}));
  connect(senTem1.port_b, volMix_a.ports[4]) annotation (Line(
      points={{0,-340},{0,-200},{-228,-200},{-228,10},{-257,10}},
      color={0,127,255},
      thickness=0.5));
  connect(deMul.y1[1], coolingLoadInPositive.u) annotation (Line(points={{-157,
          417},{-140,417},{-140,440},{-240,440},{-240,-394},{-182,-394}},
                  color={0,0,127}));
  connect(senTem.port_a, volMix_b.ports[4]) annotation (Line(points={{-182,-340},
          {-200,-340},{-200,-240},{260,-240},{260,-146},{263,-146},{263,10}},
        color={0,127,255}));
  connect(senTem.port_b, pumChi.port_a)
    annotation (Line(points={{-162,-340},{-130,-340}}, color={0,127,255}));
  connect(mPumHea_flow.y, m_flow_HPSH) annotation (Line(points={{21,330},
          {40,330},{40,360},{180,360},{180,-140},{284,-140}}, color={0,
          0,127}));
  connect(mPumHotWat_flow.y, m_flow_HPDHW) annotation (Line(points={{21,
          40},{38,40},{38,58},{140,58},{140,-200},{284,-200}}, color={0,
          0,127}));
  connect(heaPum.P, sumPCom.u1) annotation (Line(points={{43,222},{48,222},{48,280},
          {200,280},{200,446},{218,446}}, color={0,0,127}));
  connect(heaPumHotWat.P, sumPCom.u2) annotation (Line(points={{41,-82},{48,-82},
          {48,-20},{166,-20},{166,434},{218,434}}, color={0,0,127}));
  connect(sumPCom.y, PCom) annotation (Line(points={{241,440},{264,440},{264,440},
          {290,440}}, color={0,0,127}));
  connect(sumPPum.u1, pumHea.P) annotation (Line(points={{118,138},{110,138},{110,
          309},{51,309}}, color={0,0,127}));
  connect(pumHotWat.P, sumPPum.u2) annotation (Line(points={{51,9},{58,9},{58,130},
          {118,130}}, color={0,0,127}));
  connect(pumChi.P, sumPPum.u3) annotation (Line(points={{-109,-331},{-80,
          -331},{-80,-160},{88,-160},{88,122},{118,122}},
                                                    color={0,0,127}));
  connect(PPum, sumPPum.y) annotation (Line(points={{290,400},{260,400},{260,130},
          {141,130}}, color={0,0,127}));
  connect(deMul.y3[1], assEqu1.u1) annotation (Line(points={{-157,403},{-92,403},
          {-92,-44},{98,-44}}, color={0,0,127}));
  connect(heaPumHotWat.QCon_flow, assEqu1.u2)
    annotation (Line(points={{41,-73},{41,-56},{98,-56}}, color={0,0,127}));
  connect(assEqu2.u2, heaPum.QCon_flow) annotation (Line(points={{58,254},{46,254},
          {46,231},{43,231}}, color={0,0,127}));
  connect(deMul.y2[1], assEqu2.u1) annotation (Line(points={{-157,410},{-100,410},
          {-100,266},{58,266}}, color={0,0,127}));
  connect(senTem1.port_a, hex.port_b)
    annotation (Line(points={{-20,-340},{-40,-340}}, color={0,127,255}));
  connect(hex.port_a, pumChi.port_b) annotation (Line(points={{-60,-340},
          {-110,-340}}, color={0,127,255}));
  connect(coolingLoadInPositive.y, hex.u) annotation (Line(points={{-159,-394},
          {-146,-394},{-146,-368},{-70,-368},{-70,-334},{-62,-334}},
        color={0,0,127}));
  connect(heaTemRes.THeaRet, sou.T_in) annotation (Line(points={{-118,244},{-54,
          244},{-54,232},{-42,232}}, color={0,0,127}));
  connect(heaTemRes.THeaSup, heaPum.TSet) annotation (Line(points={{-118,256},{0,
          256},{0,231},{20,231}}, color={0,0,127}));
  connect(QHea_nominal.y, mHea_flow.u) annotation (Line(points={{-199,210},{-170,
          210}},                       color={0,0,127}));
  connect(mHea_flow.y, sou.m_flow_in) annotation (Line(points={{-147,210},{-46,210},
          {-46,236},{-42,236}}, color={0,0,127}));
  connect(QHea_nominal.y, mConFlow.u2) annotation (Line(points={{-199,210},{-190,
          210},{-190,244},{-172,244}}, color={0,0,127}));
  connect(heaTemRes.u, mConFlow.y)
    annotation (Line(points={{-142,250},{-149,250}}, color={0,0,127}));
  connect(coolingLoadInPositive.y, mHea_flow1.u)
    annotation (Line(points={{-159,-394},{-124,-394}}, color={0,0,127}));
  connect(mHea_flow1.y, pumChi.m_flow_in) annotation (Line(points={{-101,-394},
          {-90,-394},{-90,-320},{-120,-320},{-120,-328}}, color={0,0,127}));
  connect(mHea_flow1.y, m_flow_FC) annotation (Line(points={{-101,-394},{258,
          -394},{258,-260},{284,-260}}, color={0,0,127}));
  annotation (
  defaultComponentName="bui",
  Documentation(info="<html>
<p>
Model for a substation with space heating, space cooling and domestic hot water.
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
        extent={{-280,-280},{280,460}},
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
          extent={{2,8},{282,-8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-278,-8},{2,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(
          extent={{-180,180},{174,-220}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
      Rectangle(
        extent={{36,42},{108,114}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-124,42},{-52,114}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-126,-122},{-54,-50}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{40,-122},{112,-50}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{0,264},{-218,164},{220,164},{0,264}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95})}),
    Diagram(coordinateSystem(extent={{-280,-460},{280,460}},
          preserveAspectRatio=false)));
end EnergyTransferStation;
