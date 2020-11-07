within Buildings.Experimental.DHC.Networks.BaseClasses;
model DifferenceEnthalpyFlowRate
  "Sensor outputing the difference between two enthalpy flow rates"
  extends Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=Medium,
    final m1_flow_nominal=m_flow_nominal,
    final m2_flow_nominal=m_flow_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final m1_flow_small=m_flow_small,
    final m2_flow_small=m_flow_small,
    final show_T=false);
  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (choices(choice(redeclare package Medium=Buildings.Media.Water "Water"),choice(redeclare package Medium=Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15,X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(
    min=0)
    "Nominal mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Time tau(
    min=0)=0
    "Time constant at nominal flow rate (use tau=0 for steady-state sensor, but see user guide for potential problems)";
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (InitialState and InitialOutput are identical)"
    annotation (Evaluate=true,Dialog(group="Initialization"));
  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Modelica.SIunits.SpecificEnthalpy h_out_start=Medium.specificEnthalpy_pTX(
    p=Medium.p_default,
    T=Medium.T_default,
    X=Medium.X_default)
    "Initial or guess value of measured specific enthalpy"
    annotation (Dialog(group="Initialization"));
  parameter Medium1.MassFlowRate m_flow_small(
    min=0)=1E-4*abs(
    m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dH_flow(
    final unit="W")
    "Difference in enthalpy flow rate between stream 1 and 2"
    annotation (Placement(transformation(origin={120,0},extent={{-20,-20},{20,20}},rotation=0),iconTransformation(extent={{-20,-20},{20,20}},rotation=0,origin={120,0})));
  Fluid.Sensors.EnthalpyFlowRate senEntFlo1(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal,
    final tau=tau,
    final initType=initType,
    final allowFlowReversal=allowFlowReversal,
    final h_out_start=h_out_start)
    "Enthalpy flow rate of fluid stream 1"
    annotation (Placement(transformation(extent={{-10,70},{10,50}})));
  Fluid.Sensors.EnthalpyFlowRate senEntFlo2(
    redeclare final package Medium=Medium,
    final m_flow_nominal=m_flow_nominal,
    final tau=tau,
    final initType=initType,
    final allowFlowReversal=allowFlowReversal,
    final h_out_start=h_out_start)
    "Enthalpy flow rate of fluid stream 2"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2(
    final k1=1,
    final k2=-1)
    "Compute the difference"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(port_a1,senEntFlo1.port_a)
    annotation (Line(points={{-100,60},{-10,60}},color={0,127,255}));
  connect(senEntFlo1.port_b,port_b1)
    annotation (Line(points={{10,60},{100,60}},color={0,127,255}));
  connect(port_b2,senEntFlo2.port_b)
    annotation (Line(points={{-100,-60},{-10,-60}},color={0,127,255}));
  connect(senEntFlo2.port_a,port_a2)
    annotation (Line(points={{10,-60},{100,-60}},color={0,127,255}));
  connect(add2.y,dH_flow)
    annotation (Line(points={{62,0},{120,0}},color={0,0,127}));
  connect(senEntFlo1.H_flow,add2.u1)
    annotation (Line(points={{0,49},{0,6},{38,6}},color={0,0,127}));
  connect(senEntFlo2.H_flow,add2.u2)
    annotation (Line(points={{0,-49},{0,-6},{38,-6}},color={0,0,127}));
  annotation (
    defaultComponentName="senDifEntFlo",
    Icon(
      graphics={
        Ellipse(
          fillColor={245,245,245},
          fillPattern=FillPattern.Solid,
          extent={{-70,-70},{70,70}}),
        Line(
          points={{0,70},{0,40}}),
        Line(
          points={{22.9,32.8},{40.2,57.3}}),
        Line(
          points={{-22.9,32.8},{-40.2,57.3}}),
        Line(
          points={{37.6,13.7},{65.8,23.9}}),
        Line(
          points={{-37.6,13.7},{-65.8,23.9}}),
        Ellipse(
          lineColor={64,64,64},
          fillColor={255,255,255},
          extent={{-12,-12},{12,12}}),
        Polygon(
          rotation=-17.5,
          fillColor={64,64,64},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-5.0,0.0},{-2.0,60.0},{0.0,65.0},{2.0,60.0},{5.0,0.0}},
          origin={0,0}),
        Ellipse(
          fillColor={64,64,64},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-7,-7},{7,7}}),
        Line(
          points={{100,0},{70,0}},
          color={0,0,127}),
        Text(
          extent={{169,-10},{75,-40}},
          lineColor={0,0,0},
          textString="ΔH_flow"),
        Line(
          points={{-100,60},{-36,60}},
          color={0,128,255}),
        Line(
          points={{36,60},{100,60}},
          color={0,128,255}),
        Line(
          points={{-100,-60},{-36,-60}},
          color={0,128,255}),
        Line(
          points={{36,-60},{100,-60}},
          color={0,128,255})}),
    Documentation(
      info="<html>
<p>
This model outputs the difference in enthalphy flow rate of the same 
medium between two different streams: 
<i>&Delta;H&#775; = m&#775;<sub>1</sub> h<sub>1</sub> - m&#775;<sub>2</sub> h<sub>2</sub></i>.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
By default the parameter <code>tau</code> is zero, so the 
specific enthalpy that is used to compute each enthalpy flow rate
is computed in steady-state.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 8, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>"));
end DifferenceEnthalpyFlowRate;
