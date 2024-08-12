within Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses;
partial model PartialReversibleRefrigerantMachine
  "Model for reversible heat pumps and chillers with a refrigerant cycle"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1 = MediumCon,
    redeclare final package Medium2 = MediumEva,
    final m1_flow_nominal=mCon_flow_nominal,
    final m2_flow_nominal=mEva_flow_nominal,
    final allowFlowReversal1=allowFlowReversalCon,
    final allowFlowReversal2=allowFlowReversalEva,
    final m1_flow_small=1E-4*abs(mCon_flow_nominal),
    final m2_flow_small=1E-4*abs(mEva_flow_nominal));

  //General
  replaceable package MediumCon =
    Modelica.Media.Interfaces.PartialMedium "Medium on condenser side"
    annotation (choicesAllMatching=true);
  replaceable package MediumEva =
    Modelica.Media.Interfaces.PartialMedium "Medium on evaporator side"
    annotation (choicesAllMatching=true);
  replaceable PartialModularRefrigerantCycle refCyc constrainedby
    PartialModularRefrigerantCycle(final use_rev=use_rev)
    "Model of the refrigerant cycle" annotation (Placement(transformation(
          extent={{-18,-18},{18,18}}, rotation=90)));
  parameter Modelica.Units.SI.HeatFlowRate PEle_nominal
    "Nominal electrical power consumption"
    annotation (Dialog(group="Nominal condition"));

  replaceable model RefrigerantCycleInertia =
     Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia
    constrainedby
    Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.BaseClasses.PartialInertia
      "Inertia between the refrigerant cycle outputs and the heat exchangers."
    annotation (choicesAllMatching=true, Dialog(group="Inertia"));
  parameter Boolean use_rev=true
    "=true if the chiller or heat pump is reversible"
    annotation(choices(checkBox=true));
  parameter Boolean allowDifferentDeviceIdentifiers=false
    "if use_rev=true, device data for cooling and heating need to entered. Set allowDifferentDeviceIdentifiers=true to allow different device identifiers devIde"
    annotation(Dialog(tab="Advanced", enable=use_rev));

  //Condenser
  parameter Modelica.Units.SI.Time tauCon=30
    "Condenser heat transfer time constant at nominal flow"
    annotation (Dialog(tab="Condenser", group="Dynamics"));
  parameter Modelica.Units.SI.TemperatureDifference dTCon_nominal
    "Nominal temperature difference in condenser medium, used to calculate mass flow rate"
    annotation (Dialog(group="Nominal condition - Pressure losses"));
  parameter Modelica.Units.SI.MassFlowRate mCon_flow_nominal
    "Nominal mass flow rate of the condenser medium"
    annotation (Dialog(group="Nominal condition - Pressure losses"));

  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition - Pressure losses"));
  parameter Real deltaMCon=0.1
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
    annotation (Dialog(tab="Condenser", group="Flow resistance"));
  parameter Boolean use_conCap=true
    "=true if using capacitor model for condenser heat loss estimation"
    annotation (Dialog(group="Heat Losses", tab="Condenser"),
                                          choices(checkBox=true));
  parameter Modelica.Units.SI.HeatCapacity CCon=0
    "Heat capacity of the condenser"
    annotation (Dialog(
      group="Heat Losses",
      tab="Condenser",
      enable=use_conCap));
  parameter Modelica.Units.SI.ThermalConductance GConOut=0
    "Outer thermal conductance for condenser heat loss calculations"
    annotation (Dialog(
      group="Heat Losses",
      tab="Condenser",
      enable=use_conCap));
  parameter Modelica.Units.SI.ThermalConductance GConIns=0
    "Inner thermal conductance for condenser heat loss calculations"
    annotation (Dialog(
      group="Heat Losses",
      tab="Condenser",
      enable=use_conCap));

  final parameter Modelica.Units.SI.Density rhoCon=MediumCon.density(staCon_nominal)
    "Condenser medium density";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpCon=
      MediumCon.specificHeatCapacityCp(staCon_nominal)
    "Condenser medium specific heat capacity";

  //Evaporator
  parameter Modelica.Units.SI.Time tauEva=30
    "Evaporator heat transfer time constant at nominal flow"
    annotation (Dialog(tab="Evaporator", group="Dynamics"));
  parameter Modelica.Units.SI.TemperatureDifference dTEva_nominal
    "Nominal temperature difference in evaporator medium, used to calculate mass flow rate"
    annotation (Dialog(group="Nominal condition - Pressure losses"));
  parameter Modelica.Units.SI.MassFlowRate mEva_flow_nominal
    "Nominal mass flow rate of the evaporator medium"
    annotation (Dialog(group="Nominal condition - Pressure losses"));

  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(displayUnit="Pa")
    "Pressure drop at nominal mass flow rate"
    annotation (Dialog(group="Nominal condition - Pressure losses"));
  parameter Real deltaMEva=0.1
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
    annotation (Dialog(tab="Evaporator", group="Flow resistance"));
  parameter Boolean use_evaCap=true
    "=true if using capacitor model for evaporator heat loss estimation"
    annotation (Dialog(group="Heat Losses", tab="Evaporator"),
                                          choices(checkBox=true));
  parameter Modelica.Units.SI.HeatCapacity CEva=0
    "Heat capacity of the evaporator"
    annotation ( Dialog(
      group="Heat Losses",
      tab="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Units.SI.ThermalConductance GEvaOut=0
    "Outer thermal conductance for evaporator heat loss calculations"
    annotation ( Dialog(
      group="Heat Losses",
      tab="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Units.SI.ThermalConductance GEvaIns=0
    "Inner thermal conductance for evaporator heat loss calculations"
    annotation ( Dialog(
      group="Heat Losses",
      tab="Evaporator",
      enable=use_evaCap));
  final parameter Modelica.Units.SI.Density rhoEva=MediumEva.density(staEva_nominal)
    "Evaporator medium density";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpEva=
      MediumEva.specificHeatCapacityCp(staEva_nominal)
    "Evaporator medium specific heat capacity";

  // Safety control
  parameter Boolean use_intSafCtr=true
    "=true to enable internal safety control"
    annotation (Dialog(group="Safety control"), choices(checkBox=true));
  replaceable parameter
    Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021 safCtrPar
    constrainedby
    Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Generic
    "Safety control parameters" annotation (Dialog(enable=use_intSafCtr,
    group="Safety control"),
      choicesAllMatching=true,
      Placement(transformation(extent={{42,-18},{58,-2}})));


//Assumptions
  parameter Boolean allowFlowReversalEva=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(group="Evaporator", tab="Assumptions"));
  parameter Boolean allowFlowReversalCon=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(group="Condenser", tab="Assumptions"));

//Initialization
  parameter Modelica.Blocks.Types.Init initType=
    Modelica.Blocks.Types.Init.InitialState
    "Type of initialization for refrigerant cycle dynamics (InitialState and InitialOutput are identical)"
    annotation (Dialog(tab="Initialization", group="Parameters"));
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure pCon_start=
      MediumCon.p_default "Start value of pressure"
    annotation (Dialog(tab="Initialization", group="Condenser"));
  parameter Modelica.Media.Interfaces.Types.Temperature TCon_start=
    MediumCon.T_default
    "Start value of temperature"
    annotation (Dialog(tab="Initialization", group="Condenser"));
  parameter Modelica.Units.SI.Temperature TConCap_start=MediumCon.T_default
    "Initial temperature of heat capacity of condenser" annotation (Dialog(
      tab="Initialization",
      group="Condenser",
      enable=use_conCap));
  parameter Modelica.Media.Interfaces.Types.MassFraction XCon_start[MediumCon.nX]=
     MediumCon.X_default "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group="Condenser"));
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure pEva_start=
      MediumEva.p_default "Start value of pressure"
    annotation (Dialog(tab="Initialization", group="Evaporator"));
  parameter Modelica.Media.Interfaces.Types.Temperature TEva_start=
    MediumEva.T_default
    "Start value of temperature"
    annotation (Dialog(tab="Initialization", group="Evaporator"));
  parameter Modelica.Units.SI.Temperature TEvaCap_start=MediumEva.T_default
    "Initial temperature of heat capacity at evaporator" annotation (Dialog(
      tab="Initialization",
      group="Evaporator",
      enable=use_evaCap));
  parameter Modelica.Media.Interfaces.Types.MassFraction XEva_start[MediumEva.nX]=
     MediumEva.X_default "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", group="Evaporator"));

//Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options)
    or steady state (only affects fluid-models)"
    annotation (Dialog(tab="Dynamics", group="Equation"));
//Advanced
  parameter Boolean from_dp=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Advanced", group="Flow resistance"));
  parameter Boolean linearized=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Advanced", group="Flow resistance"));
  parameter Real ySet_small(min=0.002)=0.01
    "Threshold for relative speed for the device to be considered on"
    annotation (Dialog(tab="Advanced", group="Diagnostics"));
  parameter Boolean calEff=true
    "=false to disable efficiency calculation, may speed up the simulation"
    annotation(Dialog(tab="Advanced"));
  parameter Real limWarSca(final unit="1") = 0.05
    "Allowed difference in scaling '|scaFacHea - scaFacCoo| / scaFacHea', if exceeded, a warning will be issued"
    annotation(Dialog(tab="Advanced"));

  Modelica.Units.SI.HeatFlowRate Q1_flow = QCon_flow
    "Heat transferred into the medium 1";
  Modelica.Units.SI.HeatFlowRate Q2_flow = QEva_flow
    "Heat transferred into the medium 2";

  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.EvaporatorCondenserWithCapacity con(
    redeclare final package Medium = MediumCon,
    final allowFlowReversal=allowFlowReversalCon,
    final m_flow_small=1E-4*abs(mCon_flow_nominal),
    final show_T=show_T,
    final deltaM=deltaMCon,
    final tau=tauCon,
    final T_start=TCon_start,
    final p_start=pCon_start,
    final use_cap=use_conCap,
    final X_start=XCon_start,
    final from_dp=from_dp,
    final energyDynamics=energyDynamics,
    final isCon=true,
    final C=CCon,
    final TCap_start=TConCap_start,
    final GOut=GConOut,
    final m_flow_nominal=mCon_flow_nominal,
    final dp_nominal=dpCon_nominal,
    final GInn=GConIns) "Heat exchanger model for the condenser"
    annotation (Placement(transformation(extent={{-20,80},{20,120}})));
  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.EvaporatorCondenserWithCapacity eva(
    redeclare final package Medium = MediumEva,
    final deltaM=deltaMEva,
    final tau=tauEva,
    final use_cap=use_evaCap,
    final allowFlowReversal=allowFlowReversalEva,
    final m_flow_small=1E-4*abs(mEva_flow_nominal),
    final show_T=show_T,
    final T_start=TEva_start,
    final p_start=pEva_start,
    final X_start=XEva_start,
    final from_dp=from_dp,
    final energyDynamics=energyDynamics,
    final isCon=false,
    final C=CEva,
    final m_flow_nominal=mEva_flow_nominal,
    final dp_nominal=dpEva_nominal,
    final TCap_start=TEvaCap_start,
    final GOut=GEvaOut,
    final GInn=GEvaIns) "Heat exchanger model for the evaporator"
    annotation (Placement(transformation(extent={{20,-80},{-20,-120}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature varTOutEva
    if use_evaCap "Forces heat losses according to ambient temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,-130})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature varTOutCon
    if use_conCap "Forces heat losses according to ambient temperature"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,130})));
  Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Safety safCtr(
    final mEva_flow_nominal=mEva_flow_nominal,
    final mCon_flow_nominal=mCon_flow_nominal,
    safCtrPar=safCtrPar,
    final ySet_small=ySet_small) if use_intSafCtr "Safety control models"
    annotation (Placement(transformation(extent={{-112,-20},{-92,0}})));
  Modelica.Blocks.Interfaces.RealInput ySet if not use_busConOnl
    "Relative compressor speed between 0 and 1" annotation (Placement(
        transformation(extent={{-164,8},{-140,32}}), iconTransformation(extent={{-120,10},
            {-102,28}})));

  Modelica.Blocks.Interfaces.RealInput TEvaAmb(final unit="K", displayUnit="degC")
    if use_evaCap and not use_busConOnl
    "Ambient temperature on the evaporator side" annotation (Placement(
        transformation(
        extent={{12,-12},{-12,12}},
        rotation=180,
        origin={-152,-130}),iconTransformation(extent={{9,-9},{-9,9}},
          origin={-111,-91},
        rotation=180)));
  Modelica.Blocks.Interfaces.RealInput TConAmb(final unit="K", displayUnit="degC")
    if use_conCap and not use_busConOnl
    "Ambient temperature on the condenser side" annotation (Placement(
        transformation(
        extent={{-12,12},{12,-12}},
        rotation=0,
        origin={-152,120}),iconTransformation(
        extent={{-9,9},{9,-9}},
        rotation=0,
        origin={-111,89})));

  Buildings.Fluid.Sensors.MassFlowRate mEva_flow(redeclare final package Medium =
        MediumEva, final allowFlowReversal=allowFlowReversalEva)
    "Mass flow sensor at the evaporator" annotation (Placement(transformation(
        origin={70,-60},
        extent={{10,-10},{-10,10}},
        rotation=0)));
  Buildings.Fluid.Sensors.MassFlowRate mCon_flow(final allowFlowReversal=
        allowFlowReversalEva, redeclare final package Medium = MediumCon)
    "Mass flow sensor at the evaporator" annotation (Placement(transformation(
        origin={-50,100},
        extent={{-10,10},{10,-10}},
        rotation=0)));

  Modelica.Blocks.Logical.Hysteresis hys(
    final uLow=0.001,
    final uHigh=ySet_small,
    final pre_y_start=false) "Use default ySet value" annotation (Placement(
        transformation(extent={{10,10},{-10,-10}}, rotation=180,
        origin={-110,-90})));

  RefrigerantCycleInertia refCycIneCon "Inertia model for condenser side"
      annotation(Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,50})));
  RefrigerantCycleInertia refCycIneEva "Inertia model for evaporator side"
      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-50})));

  Modelica.Blocks.Sources.RealExpression senTConIn(
    final y(
      final unit="K",
      displayUnit="degC")=MediumCon.temperature(MediumCon.setState_phX(
        port_a1.p,
        inStream(port_a1.h_outflow),
        inStream(port_a1.Xi_outflow))))
    "Real expression for condenser inlet temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-98,32})));
  Modelica.Blocks.Sources.RealExpression senTEvaIn(
    final y(
      final unit="K",
      displayUnit="degC")=MediumEva.temperature(MediumEva.setState_phX(
        port_a2.p,
        inStream(port_a2.h_outflow),
        inStream(port_a2.Xi_outflow))))
    "Real expression for evaporator inlet temperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-98,12})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final quantity="HeatFlowRate",
      final unit="W") "Actual heating heat flow rate added to fluid 1"
    annotation (Placement(transformation(extent={{140,120},{160,140}}),
        iconTransformation(extent={{100,80},{120,100}})));
  Modelica.Blocks.Interfaces.RealOutput P(final quantity="Power", final unit="W")
    "Electric power consumed by compressor"
    annotation (Placement(transformation(extent={{140,-10},{160,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final quantity="HeatFlowRate",
      final unit="W") "Actual cooling heat flow rate removed from fluid 2"
    annotation (Placement(transformation(extent={{140,-140},{160,-120}}),
        iconTransformation(extent={{100,-100},{120,-80}})));
  Modelica.Blocks.Interfaces.RealOutput EER(unit="1") if use_EER
    "Energy efficieny ratio" annotation (Placement(transformation(extent={{140,-40},
            {160,-20}}), iconTransformation(extent={{100,-40},{120,-20}})));
  Modelica.Blocks.Interfaces.RealOutput COP(unit="1") if use_COP
    "Coefficient of performance" annotation (Placement(transformation(extent={{140,
            20},{160,40}}), iconTransformation(extent={{100,20},{120,40}})));

  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.CalculateEfficiency
    eff(PEleMin=PEle_nominal*0.1) if calEff "Calculate efficiencies of device"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={110,30})));
// To avoid using the bus, set the section below to protected
protected
  RefrigerantMachineControlBus sigBus
    "Bus with model outputs and possibly inputs" annotation (Placement(transformation(
          extent={{-156,-58},{-126,-24}}),iconTransformation(extent={{-108,-52},
            {-90,-26}})));

  parameter Boolean use_busConOnl=false
    "=true to allow input to bus connector,
    not applicable with internal safety control"
    annotation(choices(checkBox=true), Dialog(group="Input Connectors", enable=not
          use_intSafCtr));

// <!-- @include_AixLib
protected
// -->
  parameter Boolean use_COP "=true to enable COP output";
  parameter Boolean use_EER "=true to enable EER output";
  parameter MediumCon.ThermodynamicState staCon_nominal=MediumCon.setState_pTX(
      T=MediumCon.T_default, p=MediumCon.p_default, X=MediumCon.X_default)
      "Nominal state of condenser medium";

  parameter MediumEva.ThermodynamicState staEva_nominal=MediumEva.setState_pTX(
      T=MediumEva.T_default, p=MediumEva.p_default, X=MediumEva.X_default)
      "Nominal state of evaporator medium";

equation

  // Non bus connections
  connect(safCtr.sigBus, sigBus) annotation (Line(
      points={{-111.917,-16.0833},{-111.917,-16},{-116,-16},{-116,-40},{-140,
          -40},{-140,-41},{-141,-41}},
      color={255,204,51},
      thickness=0.5));
  connect(safCtr.yOut, sigBus.yMea) annotation (Line(points={{-91.1667,-10},{
          -84,-10},{-84,-40},{-138,-40},{-138,-42},{-140,-42},{-140,-41},{-141,
          -41}},                                    color={0,0,127}));
  connect(ySet, safCtr.ySet) annotation (Line(points={{-152,20},{-120,20},{-120,
          -10},{-113.333,-10}},
                       color={0,0,127}));
  connect(TConAmb, varTOutCon.T) annotation (Line(
      points={{-152,120},{-110,120},{-110,130},{-62,130}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(varTOutCon.port, con.port_out) annotation (Line(
      points={{-40,130},{0,130},{0,120}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(TEvaAmb, varTOutEva.T) annotation (Line(
      points={{-152,-130},{-130,-130},{-130,-150},{-70,-150},{-70,-130},{-62,-130}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(eva.port_out, varTOutEva.port) annotation (Line(
      points={{0,-120},{0,-130},{-40,-130}},
      color={191,0,0},
      pattern=LinePattern.Dash));
  connect(mEva_flow.port_a, port_a2)
    annotation (Line(points={{80,-60},{100,-60}}, color={0,127,255}));
  connect(port_a1,mCon_flow. port_a)
    annotation (Line(points={{-100,60},{-68,60},{-68,100},{-60,100}},
                                                  color={0,127,255}));
  connect(mEva_flow.port_b, eva.port_a) annotation (Line(points={{60,-60},{32,-60},
          {32,-100},{20,-100}},
                              color={0,127,255}));
  connect(eva.port_b, port_b2) annotation (Line(points={{-20,-100},{-80,-100},{-80,
          -60},{-100,-60}}, color={0,127,255}));
  connect(refCyc.QEva_flow, refCycIneEva.u) annotation (Line(points={{-1.22125e-15,
          -19.8},{-1.22125e-15,-28.9},{2.22045e-15,-28.9},{2.22045e-15,-38}},
        color={0,0,127}));
  connect(eva.Q_flow,refCycIneEva. y) annotation (Line(points={{0,-76},{0,-65.9},
          {-1.9984e-15,-65.9},{-1.9984e-15,-61}},                     color={0,0,
          127}));
  connect(refCycIneCon.y, con.Q_flow) annotation (Line(points={{6.66134e-16,61},
          {6.66134e-16,69.9},{0,69.9},{0,76}},                       color={0,0,
          127}));
  connect(refCycIneCon.u, refCyc.QCon_flow) annotation (Line(points={{-8.88178e-16,
          38},{-8.88178e-16,28.9},{1.22125e-15,28.9},{1.22125e-15,19.8}}, color=
         {0,0,127}));
  connect(mCon_flow.port_b, con.port_a)
    annotation (Line(points={{-40,100},{-20,100}},
                                                 color={0,127,255}));
  connect(con.port_b, port_b1) annotation (Line(points={{20,100},{100,100},{100,
          60}},      color={0,127,255}));
  // External bus connections
  connect(mEva_flow.m_flow, sigBus.mEvaMea_flow) annotation (Line(points={{70,-49},
          {70,-40},{26,-40},{26,-30},{-20,-30},{-20,-40},{-138,-40},{-138,-41},{-141,
          -41}},                                                color={0,0,127}),
      Text(
      string="%second",
      index=1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));
  connect(mCon_flow.m_flow, sigBus.mConMea_flow) annotation (Line(points={{-50,89},
          {-50,32},{-76,32},{-76,-40},{-134,-40},{-134,-42},{-138,-42},{-138,-41},
          {-141,-41}},                           color={0,0,127}));
  connect(refCyc.sigBus, sigBus) annotation (Line(
      points={{-17.82,0.18},{-40,0.18},{-40,-40},{-138,-40},{-138,-42},{-140,-42},
          {-140,-41},{-141,-41}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(refCyc.PEle, sigBus.PEleMea) annotation (Line(points={{19.89,0.09},{26,
          0.09},{26,-30},{-20,-30},{-20,-40},{-138,-40},{-138,-41},{-141,-41}},
        color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(hys.y, sigBus.onOffMea) annotation (Line(points={{-99,-90},{-88,-90},{
          -88,-70},{-128,-70},{-128,-40},{-134,-40},{-134,-41},{-141,-41}},
                                           color={255,0,255}));
  connect(TConAmb, sigBus.TConAmbMea) annotation (Line(
      points={{-152,120},{-128,120},{-128,50},{-76,50},{-76,-42},{-78,-42},{-78,
          -41},{-141,-41}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(TEvaAmb, sigBus.TEvaAmbMea) annotation (Line(
      points={{-152,-130},{-130,-130},{-130,-110},{-76,-110},{-76,-41},{-141,-41}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(hys.u, sigBus.yMea) annotation (Line(points={{-122,-90},{-132,-90},{-132,
          -40},{-136,-40},{-136,-41},{-141,-41}},
                       color={0,0,127}));
  connect(con.T, sigBus.TConOutMea) annotation (Line(points={{22.4,90},{38,90},{
          38,32},{-76,32},{-76,-40},{-140,-40},{-140,-41},{-141,-41}},
                                                 color={0,0,127}));
  connect(senTConIn.y, sigBus.TConInMea) annotation (Line(points={{-87,32},{-76,
          32},{-76,-40},{-140,-40},{-140,-41},{-141,-41}},
                                                       color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(eva.T, sigBus.TEvaOutMea) annotation (Line(points={{-22.4,-90},{-76,-90},
          {-76,-40},{-142,-40},{-142,-41},{-141,-41}},
                                 color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(senTEvaIn.y, sigBus.TEvaInMea) annotation (Line(points={{-87,12},{-76,
          12},{-76,-40},{-148,-40},{-148,-41},{-141,-41}},              color={0,
          0,127}));
  if not use_intSafCtr then
    connect(ySet, sigBus.yMea) annotation (Line(points={{-152,20},{-120,20},{-120,
            -40},{-136,-40},{-136,-41},{-141,-41}},
                       color={0,0,127}));
  end if;
  connect(ySet, sigBus.ySet) annotation (Line(points={{-152,20},{-120,20},{-120,
          -40},{-136,-40},{-136,-41},{-141,-41}},
                     color={0,0,127}));
  connect(refCyc.PEle, P) annotation (Line(points={{19.89,0.09},{26,0.09},{26,0},{
          150,0}}, color={0,0,127}));
  connect(refCycIneEva.y, QEva_flow) annotation (Line(points={{-1.9984e-15,-61},{-1.9984e-15,
          -68},{50,-68},{50,-130},{150,-130}}, color={0,0,127}));
  connect(refCycIneCon.y, QCon_flow) annotation (Line(points={{8.88178e-16,61},{8.88178e-16,
          70},{70,70},{70,130},{150,130}}, color={0,0,127}));
  connect(eff.PEle, refCyc.PEle) annotation (Line(points={{98,23},{48,23},{48,0.09},
          {19.89,0.09}}, color={0,0,127}));
  connect(eff.COP, COP) annotation (Line(points={{121,36},{130,36},{130,30},{150,30}},
        color={0,0,127}));
  connect(eff.EER, EER) annotation (Line(points={{121,24},{130,24},{130,-30},{150,
          -30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
                   graphics={
        Rectangle(
          extent={{-102,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16,60},{16,-60}},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          origin={0,-64},
          rotation=90),
        Rectangle(
          extent={{-16,60},{16,-60}},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0},
          origin={0,60},
          rotation=90),
        Line(
          points={{-9,40},{9,40},{-5,-2},{9,-40},{-9,-40}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-3,-60},
          rotation=-90),
        Line(
          points={{9,40},{-9,40},{5,-2},{-9,-40},{9,-40}},
          color={0,0,0},
          smooth=Smooth.None,
          origin={-5,56},
          rotation=-90),
        Rectangle(
          extent={{-60,42},{60,-46}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
    Line(
    origin={-75.5,-80.333},
    points={{43.5,8.3333},{37.5,0.3333},{25.5,-1.667},{33.5,-9.667},{17.5,-11.667},{27.5,-21.667},{13.5,-23.667},
              {11.5,-31.667}},
      smooth=Smooth.Bezier,
      visible=use_evaCap),
        Polygon(
          points={{-70,-122},{-68,-108},{-58,-114},{-70,-122}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          visible=use_evaCap),
    Line( origin={24.5,93.667},
          points={{39.5,6.333},{37.5,0.3333},{25.5,-1.667},{33.5,-9.667},{17.5,
              -11.667},{27.5,-21.667},{13.5,-23.667},{11.5,-27.667}},
          smooth=Smooth.Bezier,
          visible=use_conCap),
        Polygon(
          points={{70,110},{68,96},{58,102},{70,110}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={0,0,0},
          visible=use_conCap),
        Line(
          points={{-42,72},{34,72}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled},
          thickness=0.5),
        Line(
          points={{-38,0},{38,0}},
          color={0,0,0},
          arrow={Arrow.None,Arrow.Filled},
          thickness=0.5,
          origin={0,-74},
          rotation=180),
        Text(
          extent={{-96,100},{-68,78}},
          textColor={0,0,127},
          visible=use_conCap and not use_busConOnl,
          textString="TConAmb"),
        Text(
          extent={{-96,28},{-74,10}},
          textColor={0,0,127},
          visible=not use_busConOnl,
          textString="ySet"),
        Text(
          extent={{-96,-80},{-68,-102}},
          textColor={0,0,127},
          visible=use_evaCap and not use_busConOnl,
          textString="TEvaAmb"),
        Text(
          extent={{64,104},{96,76}},
          textColor={0,0,127},
          textString="QCon_flow"),
        Text(
          extent={{64,-74},{96,-102}},
          textColor={0,0,127},
          textString="QEva_flow"),
        Text(
          extent={{72,10},{96,-6}},
          textColor={0,0,127},
          textString="P"),
        Text(
          extent={{72,40},{96,16}},
          textColor={0,0,127},
          visible=use_COP,
          textString="COP"),
        Text(
          extent={{72,-18},{96,-42}},
          textColor={0,0,127},
          visible=use_EER,
          textString="EER"),
        Rectangle(
          extent={{34,42},{38,-46}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{14,22},{58,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{36,22},{18,-10},{54,-10},{36,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-46,42},{-42,-46}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-44,2},{-54,-10},{-34,-10},{-44,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-44,2},{-54,12},{-34,12},{-44,2}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
       Diagram(coordinateSystem(extent={{-140,-160},{140,160}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>July 15, 2024</i> by Fabian Wuellhorst:<br/>
    Adjust hysteresis bandwidth (see issue
    <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1908\">IBPSA #1908</a>)
  </li>
  <li>
    May 2, 2024, by Michael Wetter:<br/>
    Refactored check for device identifiers.<br/>
    This is for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">IBPSA, #1576</a>.
  </li>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    Adjusted based on the discussion in this issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
  <li>
    <i>May 22, 2019</i> by Julian Matthes:<br/>
    Rebuild due to the introducion of the thermal machine partial model
    (see issue <a href=
    \"https://github.com/RWTH-EBC/Buildings/issues/715\">#715</a>)
  </li>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/Buildings/issues/577\">#577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  This partial model defines all components which are equally required
  for heat pump and chillers. This encompasses
</p>
<ul>
<li>the heat exchangers (evaporator and condenser),</li>
<li>sensors for temperature and mass flow rates,</li>
<li>the replaceable model for refrigerant inertia,</li>
<li>safety controls,</li>
<li>connectors and parameters,</li>
<li>and the replaceable refrigerant cycle model <code>refCyc</code></li>
</ul>
<p>
  The model <code>refCyc</code> is replaced in the ModularReversible
  model for heat pumps and chillers, e.g. by
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycle\">
  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantCycle</a>
  in <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Modular\">
  Buildings.Fluid.HeatPumps.ModularReversible.Modular</a>.
</p>
<p>
  For more information on the approach, please read the
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.UsersGuide\">
  UsersGuide</a>.
</p>
</html>"));
end PartialReversibleRefrigerantMachine;
