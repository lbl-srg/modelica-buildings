within Buildings.Experimental.DHC.Plants.Combined.Subsystems.BaseClasses;
partial model PartialChillerGroup
  "Base class for modeling a group of multiple identical chillers in parallel"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal = mConWatChi_flow_nominal,
    final m2_flow_nominal = mChiWatChi_flow_nominal);

  parameter Integer nChi(final min=1, start=1)
    "Number of chillers operating at design conditions"
    annotation(Evaluate=true);
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
      redeclare final package Medium1=Medium1,
      redeclare final package Medium2=Medium2,
      final dp1_nominal=0,
      final dp2_nominal=0,
      final allowFlowReversal1=allowFlowReversal1,
      final allowFlowReversal2=allowFlowReversal2,
      final energyDynamics=energyDynamics,
      final show_T=show_T)
    "Chiller"
    annotation (Placement(transformation(extent={{-10,-64},{10,-44}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1Chi[nChi]
    "Chiller On/Off signal"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet
    "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P
    "Power drawn"
    annotation (Placement(transformation(extent={{100,100},{140,140}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1ValCon[nChi]
    if typValCon == Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition
    "Chiller condenser isolation valve opening command" annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,180}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-90,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValCon[nChi]
    if typValCon == Buildings.Experimental.DHC.Types.Valve.TwoWayModulating
    "Chiller condenser isolation valve commanded position" annotation (
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
    "Chiller evaporator isolation valve commanded position" annotation (
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
    final use_input=true) "Flow rate multiplier"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulConOut(
    redeclare final package Medium = Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_input=true) "Flow rate multiplier"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulEvaInl(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_input=true) "Flow rate multiplier"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulEvaOut(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_input=true) "Flow rate multiplier"
    annotation (Placement(transformation(extent={{-30,-70},{-50,-50}})));
  MultipleCommands com(final nUni=nChi) "Convert command signals"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  BaseClasses.MultipleFlowResistances valEva(
    redeclare final package Medium = Medium2,
    final nUni=nChi,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dpFixed_nominal=dpEva_nominal + dpBalEva_nominal,
    final dpValve_nominal=dpValveEva_nominal,
    final typVal=typValEva,
    final allowFlowReversal=allowFlowReversal2,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final show_T=show_T) "Chiller evaporator isolation valves"
    annotation (Placement(transformation(extent={{-70,-50},{-90,-70}})));
  BaseClasses.MultipleFlowResistances valCon(
    redeclare final package Medium = Medium1,
    final nUni=nChi,
    final m_flow_nominal=mConWatChi_flow_nominal,
    final dpFixed_nominal=dpCon_nominal + dpBalCon_nominal,
    final dpValve_nominal=dpValveCon_nominal,
    final typVal=typValCon,
    final allowFlowReversal=allowFlowReversal1,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final show_T=show_T) "Chiller condenser isolation valves"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulP "Scale chiller power"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
equation
  connect(mulEvaInl.port_b, chi.port_a2)
    annotation (Line(points={{30,-60},{10,-60}}, color={0,127,255}));
  connect(TChiWatSupSet, chi.TSet) annotation (Line(points={{-120,-90},{-20,-90},
          {-20,-57},{-12,-57}},
                            color={0,0,127}));
  connect(com.y1One, chi.on) annotation (Line(points={{-68,129},{-56,129},{-56,-40},
          {-24,-40},{-24,-51},{-12,-51}},
                    color={255,0,255}));
  connect(mulConOut.uInv, mulConInl.u) annotation (Line(points={{52,66},{54,66},
          {54,80},{-54,80},{-54,66},{-52,66}}, color={0,0,127}));
  connect(com.nUniOnBou, mulEvaOut.u) annotation (Line(points={{-68,126},{-58,126},
          {-58,-48},{-26,-48},{-26,-54},{-28,-54}}, color={0,0,127}));
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
    annotation (Line(points={{-30,-60},{-10,-60}}, color={0,127,255}));
  connect(y1Chi, com.y1)
    annotation (Line(points={{-120,120},{-94,120},{-94,125},{-92,125}},
                                                  color={255,0,255}));
  connect(chi.P, mulP.u1) annotation (Line(points={{11,-45},{16,-45},{16,-94},{28,
          -94}}, color={0,0,127}));
  connect(com.nUniOn, mulP.u2) annotation (Line(points={{-68,123},{-60,123},{-60,
          -106},{28,-106}}, color={0,0,127}));
  connect(yValCon, valCon.y) annotation (Line(points={{80,180},{80,140},{64,140},
          {64,64},{68,64}}, color={0,0,127}));
  connect(y1ValCon, valCon.y1) annotation (Line(points={{40,180},{40,140},{62,140},
          {62,68},{68,68}}, color={255,0,255}));
  connect(yValEva, valEva.y) annotation (Line(points={{-40,-180},{-40,-140},{-64,
          -140},{-64,-64},{-68,-64}}, color={0,0,127}));
  connect(y1ValEva, valEva.y1) annotation (Line(points={{-80,-180},{-80,-140},{-66,
          -140},{-66,-68},{-68,-68}}, color={255,0,255}));

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
end PartialChillerGroup;
