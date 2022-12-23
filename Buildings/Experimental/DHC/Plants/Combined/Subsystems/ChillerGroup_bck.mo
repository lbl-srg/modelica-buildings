within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model ChillerGroup_bck "Group of multiple identical chillers in parallel"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    final m1_flow_nominal = mConWatChi_flow_nominal,
    final m2_flow_nominal = mChiWatChi_flow_nominal);

  parameter Integer nChi(final min=1, start=1)
    "Number of chillers operating at design conditions"
    annotation(Evaluate=true);
  parameter Buildings.Experimental.DHC.Types.Valve typValChiWat=
    Buildings.Experimental.DHC.Types.Valve.None
    "Type of chiller CHW isolation valve"
    annotation(Evaluate=true);
  parameter Buildings.Experimental.DHC.Types.Valve typValConWat=
    Buildings.Experimental.DHC.Types.Valve.None
    "Type of chiller CW isolation valve"
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
  parameter Modelica.Units.SI.PressureDifference dpChiWatChi_nominal(
    final min=0,
    displayUnit="Pa")
    "Chiller CHW design pressure drop (each chiller)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatChi_nominal(
    final min=0,
    displayUnit="Pa")
    "Chiller CW design pressure drop (each chiller)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpBalChiWatChi_nominal(
    final min=0,
    displayUnit="Pa")=0
    "CHW balancing valve design pressure drop (each valve)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpBalConWatChi_nominal(
    final min=0,
    displayUnit="Pa")=0
    "CW balancing valve design pressure drop (each valve)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpValveChiWatChi_nominal(
    final min=0,
    displayUnit="Pa")=1E3
    "Chiller CHW isolation valve design pressure drop (each valve)"
    annotation(Dialog(group="Nominal condition",
    enable=typValChiWat<>Buildings.Experimental.DHC.Types.Valve.None));
  parameter Modelica.Units.SI.PressureDifference dpValveConWatChi_nominal(
    final min=0,
    displayUnit="Pa")=1E3
    "Chiller CW isolation valve design pressure drop (each valve)"
    annotation(Dialog(group="Nominal condition",
    enable=typValConWat<>Buildings.Experimental.DHC.Types.Valve.None));

  replaceable parameter Fluid.Chillers.Data.ElectricReformulatedEIR.Generic dat
    constrainedby Buildings.Fluid.Chillers.Data.BaseClasses.Chiller
    "Chiller parameters"
    annotation (Placement(transformation(extent={{-10,-88},{10,-68}})));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Boolean use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
    enable=typValChiWat<>Buildings.Experimental.DHC.Types.Valve.None or
    typValConWat<>Buildings.Experimental.DHC.Types.Valve.None));
  parameter Modelica.Units.SI.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter and (typValChiWat<>Buildings.Experimental.DHC.Types.Valve.None or
    typValConWat<>Buildings.Experimental.DHC.Types.Valve.None)));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter
    and (typValChiWat<>Buildings.Experimental.DHC.Types.Valve.None or
    typValConWat<>Buildings.Experimental.DHC.Types.Valve.None)));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter
    and (typValChiWat<>Buildings.Experimental.DHC.Types.Valve.None or
    typValConWat<>Buildings.Experimental.DHC.Types.Valve.None)));

  replaceable Fluid.Chillers.ElectricReformulatedEIR chi(final per=dat)
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
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1Chi[nChi]
    "Chiller On/Off signal"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet
    "CHW supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P
    "Power drawn"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1ValConWat[nChi]
    if typValConWat == Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition
    "Chiller CW isolation valve opening command"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={40,120}), iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-90,120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValConWat[nChi]
    if typValConWat == Buildings.Experimental.DHC.Types.Valve.TwoWayModulating
    "Chiller CW isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={80,120}), iconTransformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={-60,120})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1ValChiWat[nChi]
    if typValChiWat == Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition
    "Chiller CHW isolation valve opening command"
    annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-80,-120}), iconTransformation(extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-90,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yValChiWat[nChi]
    if typValChiWat == Buildings.Experimental.DHC.Types.Valve.TwoWayModulating
    "Chiller CHW isolation valve commanded position"
    annotation (Placement(
        transformation(
        extent={{20,-20},{-20,20}},
        rotation=-90,
        origin={-40,-120}), iconTransformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-58,-120})));

  Fluid.BaseClasses.MassFlowRateMultiplier mulConWatInl(
    redeclare final package Medium=Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_input=true)
    "Multiplier for CW flow"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulConWatOut(
    redeclare final package Medium=Medium1,
    final allowFlowReversal=allowFlowReversal1,
    final use_input=true)
    "Multiplier for CW flow"
    annotation (Placement(transformation(extent={{30,50},{50,70}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulChiWatInl(
    redeclare final package Medium=Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_input=true)
    "Multiplier for CHW flow"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulChiWatOut(
    redeclare final package Medium=Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final use_input=true)
    "Multiplier for CHW flow"
    annotation (Placement(transformation(extent={{-30,-70},{-50,-50}})));
  BaseClasses.MultipleCommands com(final nUni=nChi) "Convert command signals"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulP "Scale chiller power"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  BaseClasses.MultipleFlowResistances valChiWat(
    redeclare final package Medium=Medium2,
    final nUni=nChi,
    final m_flow_nominal=mChiWatChi_flow_nominal,
    final dpFixed_nominal=dpChiWatChi_nominal + dpBalChiWatChi_nominal,
    final dpValve_nominal=dpValveChiWatChi_nominal,
    final typVal=typValChiWat,
    final allowFlowReversal=allowFlowReversal2,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final show_T=show_T)
    "Chiller CHW isolation valves"
    annotation (Placement(transformation(extent={{-70,-50},{-90,-70}})));
  BaseClasses.MultipleFlowResistances valConWat(
    redeclare final package Medium=Medium1,
    final nUni=nChi,
    final m_flow_nominal=mConWatChi_flow_nominal,
    final dpFixed_nominal=dpConWatChi_nominal + dpBalConWatChi_nominal,
    final dpValve_nominal=dpValveConWatChi_nominal,
    final typVal=typValConWat,
    final allowFlowReversal=allowFlowReversal1,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final show_T=show_T)
    "Chiller CW isolation valves"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));

equation
  connect(chi.port_b1, mulConWatOut.port_a) annotation (Line(points={{10,6},{20,
          6},{20,60},{30,60}}, color={0,127,255}));
  connect(mulChiWatInl.port_b, chi.port_a2) annotation (Line(points={{30,-60},{20,
          -60},{20,-6},{10,-6}}, color={0,127,255}));
  connect(TChiWatSupSet, chi.TSet) annotation (Line(points={{-120,-20},{-30,-20},
          {-30,-3},{-12,-3}},
                            color={0,0,127}));
  connect(com.y1One, chi.on) annotation (Line(points={{-58,29},{-30,29},{-30,3},
          {-12,3}}, color={255,0,255}));
  connect(com.nUniOnBou, mulConWatOut.u) annotation (Line(points={{-58,26},{0,26},
          {0,66},{28,66}},      color={0,0,127}));
  connect(mulConWatOut.uInv, mulConWatInl.u) annotation (Line(points={{52,66},{54,
          66},{54,80},{-54,80},{-54,66},{-52,66}}, color={0,0,127}));
  connect(com.nUniOnBou, mulChiWatOut.u) annotation (Line(points={{-58,26},{-24,
          26},{-24,-54},{-28,-54}}, color={0,0,127}));
  connect(mulChiWatOut.uInv, mulChiWatInl.u) annotation (Line(points={{-52,-54},
          {-54,-54},{-54,-40},{54,-40},{54,-54},{52,-54}}, color={0,0,127}));
  connect(port_a1, mulConWatInl.port_a)
    annotation (Line(points={{-100,60},{-50,60}}, color={0,127,255}));
  connect(com.nUniOnBou, mulP.u1) annotation (Line(points={{-58,26},{64,26},{64,
          6},{68,6}}, color={0,0,127}));
  connect(mulP.y, P)
    annotation (Line(points={{92,0},{120,0}}, color={0,0,127}));
  connect(chi.P, mulP.u2)
    annotation (Line(points={{11,9},{60,9},{60,-6},{68,-6}}, color={0,0,127}));
  connect(mulConWatInl.port_b, chi.port_a1) annotation (Line(points={{-30,60},{-20,
          60},{-20,6},{-10,6}}, color={0,127,255}));
  connect(port_a2, mulChiWatInl.port_a)
    annotation (Line(points={{100,-60},{50,-60}}, color={0,127,255}));
  connect(mulConWatOut.port_b, valConWat.port_a)
    annotation (Line(points={{50,60},{70,60}}, color={0,127,255}));
  connect(valConWat.port_b, port_b1)
    annotation (Line(points={{90,60},{100,60}}, color={0,127,255}));
  connect(port_b2, valChiWat.port_b)
    annotation (Line(points={{-100,-60},{-90,-60}}, color={0,127,255}));
  connect(mulChiWatOut.port_b, valChiWat.port_a)
    annotation (Line(points={{-50,-60},{-70,-60}}, color={0,127,255}));
  connect(mulChiWatOut.port_a, chi.port_b2) annotation (Line(points={{-30,-60},{
          -20,-60},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(y1Chi, com.y1)
    annotation (Line(points={{-120,20},{-102,20},{-102,25},{-82,25}},
                                                  color={255,0,255}));
  connect(yValConWat, valConWat.y) annotation (Line(points={{80,120},{80,80},{66,
          80},{66,64},{68,64}}, color={0,0,127}));
  connect(y1ValConWat, valConWat.y1) annotation (Line(points={{40,120},{40,90},{
          60,90},{60,68},{68,68}}, color={255,0,255}));
  connect(yValChiWat, valChiWat.y) annotation (Line(points={{-40,-120},{-40,-80},
          {-60,-80},{-60,-64},{-68,-64}}, color={0,0,127}));
  connect(y1ValChiWat, valChiWat.y1) annotation (Line(points={{-80,-120},{-80,-80},
          {-64,-80},{-64,-68},{-68,-68}}, color={255,0,255}));
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
        coordinateSystem(preserveAspectRatio=false)));
end ChillerGroup_bck;
