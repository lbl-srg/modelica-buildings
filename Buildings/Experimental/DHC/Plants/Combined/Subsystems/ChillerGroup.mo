within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model ChillerGroup
  "Model of multiple identical chillers in parallel"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal = mConWat_flow_nominal,
    final m2_flow_nominal = mChiWat_flow_nominal);

  parameter Integer nUni(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation(Evaluate=true);
  parameter Boolean have_switchOver=false
    "Set to true for heat recovery chiller with built-in switchover"
    annotation(Evaluate=true);
  parameter Boolean is_cooling=true
    "Set to true for cooling mode, false for heating mode"
    annotation(Dialog(enable=have_switchOver), Evaluate=true);
  parameter Buildings.Experimental.DHC.Types.Valve typValEva=
    Buildings.Experimental.DHC.Types.Valve.None
    "Type of chiller evaporator isolation valve"
    annotation(Evaluate=true);
  parameter Buildings.Experimental.DHC.Types.Valve typValCon=
    Buildings.Experimental.DHC.Types.Valve.None
    "Type of chiller condenser isolation valve"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.Temperature TCasEnt_nominal=20 + 273.15
    "Design value of chiller entering temperature in cascade configuration";
  final parameter Modelica.Units.SI.Temperature TChiWatSup_nominal=
    dat.TEvaLvg_nominal
    "Design (minimum) CHW supply temperature";
  final parameter Modelica.Units.SI.Temperature THeaWatSup_nominal=
    dat.TConLvg_nominal
    "Design (maximum) HW supply temperature";
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatUni_flow_nominal=
    dat.QEva_flow_nominal
    "Cooling design heat flow rate (each unit, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWatUni_flow_nominal=
    -dat.QEva_flow_nominal * (1 + 1 / dat.COP_nominal * dat.etaMotor)
    "Heating design heat flow rate in direct heat recovery mode (each unit, >0)"
    annotation(Dialog(group="Nominal condition", enable=have_switchOver));
  final parameter Modelica.Units.SI.Efficiency COPCas_nominal( fixed=false)
    "Coefficient of performance in cascading mode";
  final parameter Modelica.Units.SI.Temperature TCasLvg_nominal(fixed=false)
    "Design value of chiller leaving temperature in cascade configuration";
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatCasUni_flow_nominal(
    fixed=false,
    start=QChiWatUni_flow_nominal * (1 + 2E-2 * (
      if is_cooling then -(TCasEnt_nominal -
        (dat.TConLvg_nominal - QHeaWatUni_flow_nominal / mConWatUni_flow_nominal / cpCas))
      else TCasEnt_nominal -
        (dat.TEvaLvg_nominal - QChiWatUni_flow_nominal / mChiWatUni_flow_nominal / cpCas))))
    "Cooling design heat flow rate in cascading mode (each unit, <0)"
    annotation(Dialog(group="Nominal condition", enable=have_switchOver));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWatCasUni_flow_nominal=
    -QChiWatCasUni_flow_nominal * (1 + 1 / COPCas_nominal * dat.etaMotor)
    "Heating design heat flow rate in cascading mode (each unit, >0)"
    annotation(Dialog(group="Nominal condition", enable=have_switchOver));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWat_flow_nominal=
    nUni * QChiWatUni_flow_nominal
    "Cooling design heat flow rate (all units, <0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWat_flow_nominal=
    nUni * QHeaWatUni_flow_nominal
    "Heating design heat flow rate (all units, >0)"
    annotation(Dialog(group="Nominal condition", enable=have_switchOver));
  final parameter Modelica.Units.SI.HeatFlowRate QChiWatCas_flow_nominal=
    nUni * QChiWatCasUni_flow_nominal
    "Cooling design heat flow rate in cascading mode (all units, <0)"
    annotation(Dialog(group="Nominal condition", enable=have_switchOver));
  final parameter Modelica.Units.SI.HeatFlowRate QHeaWatCas_flow_nominal=
    nUni * QHeaWatCasUni_flow_nominal
    "Heating design heat flow rate in cascading mode (all units, >0)"
    annotation(Dialog(group="Nominal condition", enable=have_switchOver));
  final parameter Modelica.Units.SI.MassFlowRate mChiWatUni_flow_nominal(
    final min=0)=dat.mEva_flow_nominal
    "Chiller CHW design mass flow rate (each unit)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatUni_flow_nominal(
    final min=0)=dat.mCon_flow_nominal
    "Chiller CW design mass flow rate (each unit)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)=nUni * mChiWatUni_flow_nominal
    "CHW design mass flow rate (all units)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)=nUni * mConWatUni_flow_nominal
    "CW design mass flow rate (all units)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(
    final min=0,
    displayUnit="Pa")
    "Chiller evaporator design pressure drop (each unit)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(
    final min=0,
    displayUnit="Pa")
    "Chiller condenser design pressure drop (each unit)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpBalEva_nominal(
    final min=0,
    displayUnit="Pa")=0
    "Evaporator-side balancing valve design pressure drop (each valve)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpBalCon_nominal(
    final min=0,
    displayUnit="Pa")=0
    "Condenser-side balancing valve design pressure drop (each valve)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpValveEva_nominal(
    final min=0,
    displayUnit="Pa")=if typValEva==Buildings.Experimental.DHC.Types.Valve.None
    then 0 else 1E3
    "Chiller evaporator isolation valve design pressure drop (each valve)"
    annotation(Dialog(group="Nominal condition",
    enable=typValEva<>Buildings.Experimental.DHC.Types.Valve.None));
  parameter Modelica.Units.SI.PressureDifference dpValveCon_nominal(
    final min=0,
    displayUnit="Pa")=if typValCon==Buildings.Experimental.DHC.Types.Valve.None
    then 0 else 1E3
    "Chiller condenser isolation valve design pressure drop (each valve)"
    annotation(Dialog(group="Nominal condition",
    enable=typValCon<>Buildings.Experimental.DHC.Types.Valve.None));

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic dat
    "Chiller parameters (each unit)"
    annotation (Placement(transformation(extent={{-10,-134},{10,-114}})));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Boolean use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
      enable=typValEva<>Buildings.Experimental.DHC.Types.Valve.None or
      typValCon<>Buildings.Experimental.DHC.Types.Valve.None));
  parameter Modelica.Units.SI.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter and (typValEva<>Buildings.Experimental.DHC.Types.Valve.None or
      typValCon<>Buildings.Experimental.DHC.Types.Valve.None)));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter
      and (typValEva<>Buildings.Experimental.DHC.Types.Valve.None or
      typValCon<>Buildings.Experimental.DHC.Types.Valve.None)));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter
      and (typValEva<>Buildings.Experimental.DHC.Types.Valve.None or
      typValCon<>Buildings.Experimental.DHC.Types.Valve.None)));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1Chi[nUni]
    "Chiller On/Off command"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1Coo[nUni]
    if have_switchOver
    "Chiller switchover command: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K", displayUnit="degC")
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-140,-110},{-100, -70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(
    final unit="W")
    "Power drawn"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1ValCon[nUni]
    if typValCon == Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition
    "Chiller condenser isolation valve opening command"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-90,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValCon[nUni](
    each final unit="1", each final min=0, each final max=1)
    if typValCon == Buildings.Experimental.DHC.Types.Valve.TwoWayModulating
    "Chiller condenser isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={80,180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1ValEva[nUni]
    if typValEva == Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition
    "Chiller evaporator isolation valve opening command" annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-80,-180}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-90,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValEva[nUni](
    each final unit="1", each final min=0, each final max=1)
    if typValEva == Buildings.Experimental.DHC.Types.Valve.TwoWayModulating
    "Chiller evaporator isolation valve commanded position"
    annotation (
      Placement(transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-40,-180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-58,-120})));

  Fluid.Chillers.ElectricReformulatedEIR chi(
    PLR1(start=0),
    final per=dat,
    redeclare final package Medium1=Medium1,
    redeclare final package Medium2=Medium2,
    final have_switchOver=have_switchOver,
    final dp1_nominal=0,
    final dp2_nominal=0,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final energyDynamics=energyDynamics,
    final show_T=show_T)
    "Chiller"
    annotation (Placement(transformation(extent={{-2,-10},{18,10}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulConInl(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulConOut(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulEvaInl(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulEvaOut(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{-30,-70},{-50,-50}})));
  BaseClasses.MultipleCommands com(final nUni=nUni, final have_mode=
        have_switchOver) "Convert command signals"
    annotation (Placement(transformation(extent={{-94,100},{-74,120}})));
  BaseClasses.MultipleFlowResistances valEva(
    redeclare final package Medium = Medium2,
    final nUni=nUni,
    final mUni_flow_nominal=mChiWatUni_flow_nominal,
    final have_mode=have_switchOver,
    final dpFixed_nominal=dpEva_nominal + dpBalEva_nominal,
    final dpValve_nominal=dpValveEva_nominal,
    final typVal=typValEva,
    final allowFlowReversal=allowFlowReversal2,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final show_T=show_T)
    "Chiller evaporator isolation valves"
    annotation (Placement(transformation(extent={{-70,-50},{-90,-70}})));
  BaseClasses.MultipleFlowResistances valCon(
    redeclare final package Medium = Medium1,
    final nUni=nUni,
    final mUni_flow_nominal=mConWatUni_flow_nominal,
    final have_mode=have_switchOver,
    final dpFixed_nominal=dpCon_nominal + dpBalCon_nominal,
    final dpValve_nominal=dpValveCon_nominal,
    final typVal=typValCon,
    final allowFlowReversal=allowFlowReversal1,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final show_T=show_T)
    "Chiller condenser isolation valves"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulP "Scale power"
    annotation (Placement(transformation(extent={{70,30},{90,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant modOpe(
    final k=is_cooling) if have_switchOver
    "Operating mode (fixed)"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-80,140})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi if have_switchOver
    "In cooling mode: use y1ModOne, in heating mode: use y1NotModOne"
    annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-40,136})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep(final nout=nUni)
    if have_switchOver "Replicate operating mode signal (fixed)"
    annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={24,130})));
  Buildings.Controls.OBC.CDL.Logical.Not modHea[nUni] if have_switchOver
    "Returns true if heating mode" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,90})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nUni] if have_switchOver
    "In cooling mode: use y1Coo, in heating mode: use NOT y1Coo"
    annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={40,100})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiNumUniBou if have_switchOver
    "In cooling mode: use nUniOnModBou, in heating mode: use nUniOnNotModBou"
    annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-40,20})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swiNumUni if have_switchOver
    "In cooling mode: use nUniOnMod, in heating mode: use nUniOnNotMod"
    annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-40,-20})));
protected
  parameter Medium1.ThermodynamicState staCas1=Medium1.setState_pTX(
    T=TCasEnt_nominal,
    p=Medium1.p_default,
    X=Medium1.X_default)
    "State of source medium in cascade configuration";
  parameter Medium2.ThermodynamicState staCas2=Medium2.setState_pTX(
    T=TCasEnt_nominal,
    p=Medium2.p_default,
    X=Medium2.X_default)
    "State of source medium in cascade configuration";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCas=
    if is_cooling then Medium1.specificHeatCapacityCp(state=staCas1)
    else Medium2.specificHeatCapacityCp(state=staCas2)
    "Heat capacity of source medium in cascade configuration";
initial equation
  TCasLvg_nominal = TCasEnt_nominal +
    (if is_cooling then QHeaWatCasUni_flow_nominal
    else QChiWatCasUni_flow_nominal) / cpCas /
    (if is_cooling then mConWatUni_flow_nominal
    else mChiWatUni_flow_nominal);
  QChiWatCasUni_flow_nominal = dat.QEva_flow_nominal *
    Buildings.Utilities.Math.Functions.biquadratic(
      a=dat.capFunT,
      x1=Modelica.Units.Conversions.to_degC(
        if is_cooling then TChiWatSup_nominal else TCasLvg_nominal),
      x2=Modelica.Units.Conversions.to_degC(
        if is_cooling then TCasLvg_nominal else THeaWatSup_nominal));
  COPCas_nominal = dat.COP_nominal /
    Buildings.Utilities.Math.Functions.biquadratic(
      a=dat.EIRFunT,
      x1=Modelica.Units.Conversions.to_degC(
        if is_cooling then TChiWatSup_nominal else TCasLvg_nominal),
      x2=Modelica.Units.Conversions.to_degC(
        if is_cooling then TCasLvg_nominal else THeaWatSup_nominal));
equation
  connect(mulEvaInl.port_b, chi.port_a2)
    annotation (Line(points={{30,-60},{26,-60},{26,-6},{18,-6}},
                                                 color={0,127,255}));
  connect(TSet, chi.TSet) annotation (Line(points={{-120,-90},{-20,-90},{-20,-3},
          {-4,-3}},  color={0,0,127}));
  connect(mulConOut.uInv, mulConInl.u) annotation (Line(points={{52,66},{54,66},
          {54,40},{-54,40},{-54,66},{-52,66}}, color={0,0,127}));
  connect(mulEvaOut.uInv, mulEvaInl.u) annotation (Line(points={{-52,-54},{-54,-54},
          {-54,-80},{56,-80},{56,-54},{52,-54}}, color={0,0,127}));
  connect(port_a1, mulConInl.port_a)
    annotation (Line(points={{-100,60},{-50,60}}, color={0,127,255}));
  connect(port_a2, mulEvaInl.port_a)
    annotation (Line(points={{100,-60},{50,-60}}, color={0,127,255}));
  connect(port_b2, valEva.port_b)
    annotation (Line(points={{-100,-60},{-90,-60}}, color={0,127,255}));
  connect(mulEvaOut.port_b, valEva.port_a)
    annotation (Line(points={{-50,-60},{-70,-60}}, color={0,127,255}));
  connect(mulEvaOut.port_a, chi.port_b2)
    annotation (Line(points={{-30,-60},{-20,-60},{-20,-6},{-2,-6}},
                                                   color={0,127,255}));
  connect(y1Chi, com.y1)
    annotation (Line(points={{-120,120},{-98,120},{-98,115},{-96,115}},
                                                  color={255,0,255}));
  connect(chi.P, mulP.u1) annotation (Line(points={{19,9},{24,9},{24,14},{68,14}},
                 color={0,0,127}));
  connect(com.nUniOn, mulP.u2) annotation (Line(points={{-72,115},{16,115},{16,26},
          {68,26}},         color={0,0,127}));
  connect(yValCon, valCon.y) annotation (Line(points={{80,180},{80,140},{64,140},
          {64,64},{68,64}}, color={0,0,127}));
  connect(y1ValCon, valCon.y1) annotation (Line(points={{40,180},{40,140},{62,140},
          {62,68},{68,68}}, color={255,0,255}));
  connect(yValEva, valEva.y) annotation (Line(points={{-40,-180},{-40,-140},{-64,
          -140},{-64,-64},{-68,-64}}, color={0,0,127}));
  connect(y1ValEva, valEva.y1) annotation (Line(points={{-80,-180},{-80,-140},{-66,
          -140},{-66,-68},{-68,-68}}, color={255,0,255}));

  connect(mulConInl.port_b, chi.port_a1) annotation (Line(points={{-30,60},{-20,
          60},{-20,6},{-2,6}},  color={0,127,255}));
  connect(chi.port_b1, mulConOut.port_a) annotation (Line(points={{18,6},{26,6},
          {26,60},{30,60}}, color={0,127,255}));
  connect(y1Coo, com.y1Mod) annotation (Line(points={{-120,90},{-98,90},{-98,105},
          {-96,105}}, color={255,0,255}));
  connect(mulP.y, P)
    annotation (Line(points={{92,20},{120,20}}, color={0,0,127}));
  connect(modOpe.y, chi.coo)
    annotation (Line(points={{-68,140},{-60,140},{-60,152},{0,152},{0,14}},
                                                        color={255,0,255}));
  connect(com.nUniOnBou, mulConOut.u) annotation (Line(points={{-72,117},{20,117},
          {20,66},{28,66}},      color={0,0,127}));
  connect(mulConInl.uInv, mulEvaOut.u) annotation (Line(points={{-28,66},{-24,
          66},{-24,-54},{-28,-54}}, color={0,0,127}));
  connect(modOpe.y, swi.u2) annotation (Line(points={{-68,140},{-60,140},{-60,136},
          {-52,136}},      color={255,0,255}));
  connect(com.y1ModOne, swi.u1) annotation (Line(points={{-72,111},{-56,111},{-56,
          144},{-52,144}},     color={255,0,255}));
  connect(com.y1NotModOne, swi.u3) annotation (Line(points={{-72,105},{-54,105},
          {-54,128},{-52,128}}, color={255,0,255}));
  connect(y1Coo, modHea.u)
    annotation (Line(points={{-120,90},{-42,90}}, color={255,0,255}));
  connect(modHea.y, swi1.u3) annotation (Line(points={{-18,90},{24,90},{24,92},{
          28,92}}, color={255,0,255}));
  connect(rep.y, swi1.u2) annotation (Line(points={{24,118},{24,100},{28,100}},
                 color={255,0,255}));
  connect(y1Coo, swi1.u1) annotation (Line(points={{-120,90},{-44,90},{-44,108},
          {28,108}}, color={255,0,255}));
  connect(swi1.y, valCon.y1Mod) annotation (Line(points={{52,100},{60,100},{60,55},
          {68,55}}, color={255,0,255}));
  connect(swi1.y, valEva.y1Mod) annotation (Line(points={{52,100},{60,100},{60,-40},
          {-60,-40},{-60,-55},{-68,-55}}, color={255,0,255}));
  connect(swi.y, chi.on) annotation (Line(points={{-28,136},{-16,136},{-16,3},{-4,
          3}}, color={255,0,255}));
  connect(com.nUniOnModBou, swiNumUniBou.u1) annotation (Line(points={{-72,109},
          {-68,109},{-68,110},{-58,110},{-58,28},{-52,28}},
                                          color={0,0,127}));
  connect(com.nUniOnNotModBou, swiNumUniBou.u3) annotation (Line(points={{-72,103},
          {-62,103},{-62,12},{-52,12}},   color={0,0,127}));
  connect(modOpe.y, swiNumUniBou.u2) annotation (Line(points={{-68,140},{-60,140},
          {-60,20},{-52,20}},   color={255,0,255}));
  connect(swiNumUniBou.y, mulConOut.u) annotation (Line(points={{-28,20},{24,20},
          {24,66},{28,66}}, color={0,0,127}));
  connect(com.nUniOnMod, swiNumUni.u1) annotation (Line(points={{-72,107},{-66,107},
          {-66,-12},{-52,-12}}, color={0,0,127}));
  connect(com.nUniOnNotMod, swiNumUni.u3) annotation (Line(points={{-72,101},{-68,
          101},{-68,-28},{-52,-28}}, color={0,0,127}));
  connect(modOpe.y, swiNumUni.u2) annotation (Line(points={{-68,140},{-60,140},{
          -60,-20},{-52,-20}},
                     color={255,0,255}));
  connect(swiNumUni.y, mulP.u2) annotation (Line(points={{-28,-20},{40,-20},{40,
          26},{68,26}},
                    color={0,0,127}));
  connect(com.y1One, chi.on) annotation (Line(points={{-72,119},{-16,119},{-16,3},
          {-4,3}},                  color={255,0,255}));
  connect(modOpe.y, rep.u) annotation (Line(points={{-68,140},{-60,140},{-60,152},
          {24,152},{24,142}}, color={255,0,255}));
  connect(valCon.port_b, port_b1)
    annotation (Line(points={{90,60},{100,60}}, color={0,127,255}));
  connect(mulConOut.port_b, valCon.port_a)
    annotation (Line(points={{50,60},{70,60}}, color={0,127,255}));
  annotation (
    defaultComponentName="chi",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,160}})),
    Documentation(info="<html>
<p>
This model represents a set of identical chillers in parallel.
If the parameter <code>have_switchOver</code> is <code>true</code>
then an additional operating mode signal <code>y1Coo</code> is used
to switch <i>On/Off</i> the chillers and actuate the chiller isolation 
valves based on the following logic.
</p>
<ul>
<li>
If the parameter <code>is_cooling</code> is <code>true</code>
(resp. <code>false</code>)
then the chiller <code>#i</code> is commanded <i>On</i> if 
<code>y1Chi[i]</code> is <code>true</code> and <code>y1Coo[i]</code> 
is <code>true</code> (resp. <code>false</code>). 
</li>
<li>
When the chiller <code>#i</code> is commanded <i>On</i>
the isolation valve input signal <code>y*Val*[i]</code> is used to 
control the valve opening. 
Otherwise the valve is closed whatever the value of 
<code>y*Val*[i]</code>.
</li>
<li>
Configured this way, the model represents the set of heat 
recovery chillers operating in cooling mode
(resp. heating mode), i.e., tracking the CHW (resp. HW) supply 
temperature setpoint.
</li>
</ul>
<p>
Note that the input signal <code>y1Coo</code> is different 
from the input signal <code>coo</code> that is used in the model
<a href=\"modelica://Buildings.Fluid.Chillers.ElectricReformulatedEIR\">
Buildings.Fluid.Chillers.ElectricReformulatedEIR</a>
where it allows switching the chiller operating mode from cooling
to heating.
The current chiller group model rather represents a set of chillers
that are <i>all</i> operating in the same mode, either cooling or heating.
The mode is fixed as specified by the parameter <code>is_cooling</code>
and each chiller which is commanded to operate in a different mode
is considered <i>Off</i>.
</p>
<h4>
Chiller performance data
</h4>
<p>
When modeling heat recovery chillers (by setting the parameter
<code>have_switchOver</code> to <code>true</code>) the chiller performance
data should cover the chiller lift envelope.
That is when the chiller is operating in \"direct\" heat recovery mode, 
i.e., producing CHW and HW at their setpoint value at full load.
In this case, and to allow for \"cascading\" heat recovery where
a third fluid circuit is used to generate a cascade of thermodynamic cycles,
an additional parameter <code>TCasEnt_nominal</code> 
is exposed to specify the chiller <i>entering</i> temperature of the third fluid 
circuit.
This fluid circuit is connected either to the chiller evaporator barrel 
when the chiller is operating in heating mode, or to the chiller condenser
barrel when the chiller is operating in cooling mode.
The parameter <code>TCasEnt_nominal</code> is then used to assess the 
design chiller capacity in heating and cooling mode, respectively.
The value of that parameter should typically differ when configuring 
this model for heating (<code>is_cooling=false</code>) or 
cooling (<code>is_cooling=true</code>).
</p>
</html>"));
end ChillerGroup;
