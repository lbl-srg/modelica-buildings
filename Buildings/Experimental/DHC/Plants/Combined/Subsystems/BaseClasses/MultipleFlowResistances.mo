within Buildings.Experimental.DHC.Plants.Combined.Subsystems.BaseClasses;
model MultipleFlowResistances
  "Parallel arrangement of identical fixed flow resistances and valves in series"

  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final massDynamics=energyDynamics,
    final mSenFac=1);
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal(final min=Modelica.Constants.small)=nUni*mUni_flow_nominal,
    show_T=false,
    port_a(
      h_outflow(start=h_outflow_start)),
    port_b(
      h_outflow(start=h_outflow_start),
      p(start=p_start),
      final m_flow(max = if allowFlowReversal then +Modelica.Constants.inf else 0)));

  parameter Integer nUni(
    final min=1,
    start=1)
    "Number of units (branches in the network)"
    annotation(Evaluate=true);
  parameter Boolean have_mode=false
    "Set to true if an operating mode is used in conjunction with valve command"
    annotation(Evaluate=true);
  parameter Buildings.Experimental.DHC.Types.Valve typVal=
    Buildings.Experimental.DHC.Types.Valve.None
    "Type of valve"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate mUni_flow_nominal(
    final min=Modelica.Constants.small)
    "Nominal mass flow rate (each unit)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(
    displayUnit="Pa",
    min=0)
    "Nominal pressure drop of fully open valve (each unit)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal(
    displayUnit="Pa",
    min=0) = 0
    "Pressure drop of pipe and other resistances that are in series (each unit)"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",
    enable=typVal<>Buildings.Experimental.DHC.Types.Valve.None));
  parameter Modelica.Units.SI.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter and typVal<>Buildings.Experimental.DHC.Types.Valve.None));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter
    and typVal<>Buildings.Experimental.DHC.Types.Valve.None));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter
    and typVal<>Buildings.Experimental.DHC.Types.Valve.None));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1[nUni]
    if typVal == Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition
    "Valve opening command"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
    iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1Mod[nUni]
    if have_mode
    "Operating mode signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y[nUni]
    if typVal == Buildings.Experimental.DHC.Types.Valve.TwoWayModulating
    "Valve commanded position"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
                             iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1_actual[nUni]
    if typVal==Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition
    "Valve open end switch status"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y_actual[nUni]
    if typVal==Buildings.Experimental.DHC.Types.Valve.TwoWayModulating
    "Valve returned position"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,20},{140,60}})));

  Fluid.FixedResistances.Junction junInl[nUni](
    redeclare each final package Medium=Medium,
    each final m_flow_nominal=m_flow_nominal * {1,-1,-1},
    each final dp_nominal=fill(0,3),
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving)
    "Fluid junction"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-60,-20})));
  Fluid.FixedResistances.Junction junOut[nUni](
    redeclare each final package Medium=Medium,
    each final m_flow_nominal=m_flow_nominal * {1,-1,1},
    each final dp_nominal=fill(0,3),
    each final energyDynamics=energyDynamics,
    each final portFlowDirection_1=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering,
    each final portFlowDirection_2=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Leaving,
    each final portFlowDirection_3=if allowFlowReversal then
      Modelica.Fluid.Types.PortFlowDirection.Bidirectional else
      Modelica.Fluid.Types.PortFlowDirection.Entering)
    "Fluid junction"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={60,-20})));
  Fluid.FixedResistances.PressureDrop res[nUni](
    redeclare each final package Medium=Medium,
    each final  m_flow_nominal=mUni_flow_nominal,
    each from_dp=true,
    each final dp_nominal=dpFixed_nominal,
    each final allowFlowReversal=allowFlowReversal)
    if typVal==Buildings.Experimental.DHC.Types.Valve.None
    "Fixed flow resistance - Case with no valve"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage valMod[nUni](
    redeclare each final package Medium=Medium,
    each from_dp=true,
    each final CvData = Buildings.Fluid.Types.CvTypes.OpPoint,
    each final m_flow_nominal=mUni_flow_nominal,
    each final dpValve_nominal=dpValve_nominal,
    each final dpFixed_nominal=dpFixed_nominal,
    each final allowFlowReversal=allowFlowReversal,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTime,
    each final init=init,
    each final y_start=y_start)
    if typVal==Buildings.Experimental.DHC.Types.Valve.TwoWayModulating
    "Modulating valve"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  Fluid.Actuators.Valves.TwoWayPolynomial valTwo[nUni](
    redeclare each final package Medium=Medium,
    each from_dp=true,
    each c={0,1.101898284705380E-01, 2.217227395456580, -7.483401207660790, 1.277617623360130E+01, -6.618045307070130},
    each final CvData = Buildings.Fluid.Types.CvTypes.OpPoint,
    each final m_flow_nominal=mUni_flow_nominal,
    each final dpValve_nominal=dpValve_nominal,
    each final dpFixed_nominal=dpFixed_nominal,
    each final allowFlowReversal=allowFlowReversal,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTime,
    each final init=init,
    each final y_start=y_start)
    if typVal==Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition
    "Two-position valve (butterfly valve characteristic)"
    annotation (Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nUni]
    if typVal==Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition
    "Convert to real"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold evaOpe[nUni](
    each t=0.99,
    each h=0.5E-2)
    if typVal==Buildings.Experimental.DHC.Types.Valve.TwoWayTwoPosition
    "Return true if open (open end switch contact)"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mul[nUni]
    if typVal<>Buildings.Experimental.DHC.Types.Valve.None
    "Factor in optional mode signal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,10})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nUni]
    if have_mode
    "Convert to real"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one[nUni](
    each final k=1) if not have_mode
    "Constant one"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={30,80})));
protected
  final parameter Medium.ThermodynamicState sta_start=Medium.setState_pTX(
    T=T_start,
    p=p_start,
    X=X_start)
    "Medium state at start values";
  final parameter Modelica.Units.SI.SpecificEnthalpy h_outflow_start=
    Medium.specificEnthalpy(sta_start)
    "Start value for outflowing enthalpy";
equation
  if nUni > 1 then
    for i in 1:(nUni - 1) loop
      connect(junOut[i].port_1, junOut[i+1].port_2)
        annotation (Line(points={{60,-30},{60,-40},{80,-40},{80,0},{60,0},{60,-10}},
                                              color={0,127,255}));
      connect(junInl[i].port_2, junInl[i+1].port_1)
        annotation (Line(points={{-60,-30},{-60,-40},{-80,-40},{-80,0},{-60,0},{
              -60,-10}},                        color={0,127,255}));
    end for;
  end if;
  connect(junInl.port_3, valMod.port_a) annotation (Line(points={{-50,-20},{-30,
          -20},{-30,-100},{-10,-100}},
                              color={0,127,255}));
  connect(valMod.port_b, junOut.port_3) annotation (Line(points={{10,-100},{30,-100},
          {30,-20},{50,-20}},
                            color={0,127,255}));
  connect(junInl.port_3, valTwo.port_a) annotation (Line(points={{-50,-20},{-30,
          -20},{-30,-60},{-10,-60}},
                                color={0,127,255}));
  connect(valTwo.port_b, junOut.port_3) annotation (Line(points={{10,-60},{30,-60},
          {30,-20},{50,-20}},
                            color={0,127,255}));
  connect(junOut[1].port_2, port_b)
    annotation (Line(points={{60,-10},{60,0},{100,0}},color={0,127,255}));
  connect(junInl.port_3, res.port_a) annotation (Line(points={{-50,-20},{-10,-20}},
                              color={0,127,255}));
  connect(res.port_b, junOut.port_3) annotation (Line(points={{10,-20},{50,-20}},
                        color={0,127,255}));

  connect(port_a, junInl[1].port_1)
    annotation (Line(points={{-100,0},{-60,0},{-60,-10}},color={0,127,255}));
  connect(valMod.y_actual, y_actual) annotation (Line(points={{5,-93},{92,-93},{
          92,40},{120,40}}, color={0,0,127}));
  connect(y1, booToRea.u)
    annotation (Line(points={{-120,120},{-82,120}},
                                                  color={255,0,255}));
  connect(evaOpe.y, y1_actual)
    annotation (Line(points={{82,-60},{86,-60},{86,80},{120,80}},
                                                color={255,0,255}));
  connect(valTwo.y_actual, evaOpe.u) annotation (Line(points={{5,-53},{54,-53},{
          54,-60},{58,-60}},
                           color={0,0,127}));
  connect(y1Mod, booToRea1.u)
    annotation (Line(points={{-120,80},{-82,80}}, color={255,0,255}));
  connect(booToRea1.y, mul.u2)
    annotation (Line(points={{-58,80},{-26,80},{-26,22}}, color={0,0,127}));
  connect(booToRea.y, mul.u1)
    annotation (Line(points={{-58,120},{-14,120},{-14,22}}, color={0,0,127}));
  connect(mul.y, valTwo.y) annotation (Line(points={{-20,-2},{-20,-40},{0,-40},{
          0,-48}}, color={0,0,127}));
  connect(y, mul.u1)
    annotation (Line(points={{-120,40},{-14,40},{-14,22}}, color={0,0,127}));
  connect(mul.y, valMod.y) annotation (Line(points={{-20,-2},{-20,-80},{0,-80},{
          0,-88}}, color={0,0,127}));
  connect(one.y, mul.u2)
    annotation (Line(points={{18,80},{-26,80},{-26,22}}, color={0,0,127}));
  annotation (
    defaultComponentName="res",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-140},{100,140}})));
end MultipleFlowResistances;
