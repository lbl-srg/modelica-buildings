within Buildings.Experimental.DHC.Plants.Combined.Subsystems.BaseClasses;
model MultipleValves
  "Parallel arrangement of identical two-way modulating valves"
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

  parameter Boolean use_inputFilter=true
    "Opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Modelica.Units.SI.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered opening",
      enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));

  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput y[nUni]
    "Valve commanded position"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y_actual[nUni]
    "Valve returned position"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,40},{140,80}})));

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
        origin={-60,0})));
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
        origin={60,0})));
  replaceable Fluid.Actuators.Valves.TwoWayEqualPercentage val[nUni]
    constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv(
    redeclare each final package Medium = Medium,
    each final from_dp=from_dp,
    each final linearized=linearized,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final m_flow_nominal=mUni_flow_nominal,
    each final dpValve_nominal=dpValve_nominal,
    each final dpFixed_nominal=dpFixed_nominal,
    each final allowFlowReversal=allowFlowReversal,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTime,
    each final init=init,
    each final y_start=y_start)
    "Modulating valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
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
        annotation (Line(points={{60,-10},{60,-20},{40,-20},{40,20},{60,20},{60,
              10}},                           color={0,127,255}));
      connect(junInl[i].port_2, junInl[i+1].port_1)
        annotation (Line(points={{-60,-10},{-60,-20},{-40,-20},{-40,20},{-60,20},
              {-60,10}},                        color={0,127,255}));
    end for;
  end if;
  connect(junInl.port_3, val.port_a) annotation (Line(points={{-50,-6.66134e-16},
          {-30,-6.66134e-16},{-30,0},{-10,0}}, color={0,127,255}));
  connect(val.port_b, junOut.port_3) annotation (Line(points={{10,0},{30,0},{30,
          4.44089e-16},{50,4.44089e-16}}, color={0,127,255}));
  connect(junOut[1].port_2, port_b)
    annotation (Line(points={{60,10},{60,20},{80,20},{80,0},{100,0}},
                                                      color={0,127,255}));

  connect(port_a, junInl[1].port_1)
    annotation (Line(points={{-100,0},{-80,0},{-80,20},{-60,20},{-60,10}},
                                                         color={0,127,255}));
  connect(val.y_actual, y_actual)
    annotation (Line(points={{5,7},{20,7},{20,60},{120,60}}, color={0,0,127}));
  connect(y, val.y)
    annotation (Line(points={{-120,60},{0,60},{0,12}}, color={0,0,127}));
  annotation (
    defaultComponentName="res",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This model represents a set of control valves piped in 
parallel.
An optional fixed resistance may be included in series with each valve.
</p>
</html>"));
end MultipleValves;
