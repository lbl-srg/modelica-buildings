within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model ChillerGroup
  "Model of multiple identical chillers in parallel"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal = mConWatChi_flow_nominal,
    final m2_flow_nominal = mChiWatChi_flow_nominal);

  parameter Integer nChi(final min=1, start=1)
    "Number of chillers operating at design conditions"
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
  final parameter Modelica.Units.SI.HeatFlowRate capChi_nominal(
    final min=0)=abs(dat.QEva_flow_nominal)
    "Chiller design capacity (each chiller, >0)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWatChi_flow_nominal(
    final min=0)=dat.mEva_flow_nominal
    "Chiller CHW design mass flow rate (each chiller)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWatChi_flow_nominal(
    final min=0)=dat.mCon_flow_nominal
    "Chiller CW design mass flow rate (each chiller)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal(
    final min=0)=nChi * mChiWatChi_flow_nominal
    "CHW design mass flow rate (all chillers)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)=nChi * mConWatChi_flow_nominal
    "CW design mass flow rate (all chillers)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpEva_nominal(
    final min=0,
    displayUnit="Pa")
    "Chiller evaporator design pressure drop (each chiller)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpCon_nominal(
    final min=0,
    displayUnit="Pa")
    "Chiller condenser design pressure drop (each chiller)"
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
    displayUnit="Pa")=1E3
    "Chiller evaporator isolation valve design pressure drop (each valve)"
    annotation(Dialog(group="Nominal condition",
    enable=typValEva<>Buildings.Experimental.DHC.Types.Valve.None));
  parameter Modelica.Units.SI.PressureDifference dpValveCon_nominal(
    final min=0,
    displayUnit="Pa")=1E3
    "Chiller condenser isolation valve design pressure drop (each valve)"
    annotation(Dialog(group="Nominal condition",
    enable=typValCon<>Buildings.Experimental.DHC.Types.Valve.None));

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic dat
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters"
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

  replaceable Fluid.Chillers.ElectricReformulatedEIR chi(
    final per=dat)
    constrainedby Buildings.Fluid.Chillers.BaseClasses.PartialElectric(
      PLR1(start=0),
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1Chi[nChi]
    "Chiller On/Off signal"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1Coo[nChi]
    if have_switchOver
    "Chiller switchover signal: true for cooling, false for heating"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-140,-110},{-100, -70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P
    "Power drawn"
    annotation (Placement(transformation(extent={{100,0},{140,40}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1ValCon[nChi]
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValCon[nChi]
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
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1ValEva[nChi]
    if typValEva == Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition
    "Chiller evaporator isolation valve opening command" annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-80,-180}), iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-90,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValEva[nChi]
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
  BaseClasses.MultipleCommands com(final nUni=nChi, final have_mode=
        have_switchOver) "Convert command signals"
    annotation (Placement(transformation(extent={{-94,100},{-74,120}})));
  BaseClasses.MultipleFlowResistances valEva(
    redeclare final package Medium = Medium2,
    final nUni=nChi,
    final m_flow_nominal=mChiWatChi_flow_nominal,
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
    final nUni=nChi,
    final m_flow_nominal=mConWatChi_flow_nominal,
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
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulP
    "Scale chiller power"
    annotation (Placement(transformation(extent={{70,30},{90,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant modOpe(
    final k=is_cooling) if have_switchOver "Operating mode (fixed)"
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
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator rep(nout=nChi)
    if have_switchOver "Replicate operating mode signal (fixed)" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={24,130})));
  Buildings.Controls.OBC.CDL.Logical.Not modHea[nChi] if have_switchOver
    "Returns true if heating mode" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-30,90})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[nChi] if have_switchOver
    "In cooling mode: use y1Coo, in heating mode: use NOT y1Coo" annotation (
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
  connect(mulConOut.port_b, valCon.port_a)
    annotation (Line(points={{50,60},{70,60}}, color={0,127,255}));
  connect(valCon.port_b, port_b1)
    annotation (Line(points={{90,60},{100,60}}, color={0,127,255}));
  connect(port_b2, valEva.port_b)
    annotation (Line(points={{-100,-60},{-90,-60}}, color={0,127,255}));
  connect(mulEvaOut.port_b, valEva.port_a)
    annotation (Line(points={{-50,-60},{-70,-60}}, color={0,127,255}));
  connect(mulEvaOut.port_a, chi.port_b2)
    annotation (Line(points={{-30,-60},{-20,-60},{-20,-6},{-2,-6}},
                                                   color={0,127,255}));
  connect(y1Chi, com.y1)
    annotation (Line(points={{-120,120},{-94,120},{-94,115},{-96,115}},
                                                  color={255,0,255}));
  connect(chi.P, mulP.u1) annotation (Line(points={{19,9},{16,9},{16,14},{68,14}},
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
  annotation (
    defaultComponentName="chiHea",
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,160}})));
end ChillerGroup;
