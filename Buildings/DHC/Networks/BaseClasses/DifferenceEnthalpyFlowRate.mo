within Buildings.DHC.Networks.BaseClasses;
model DifferenceEnthalpyFlowRate
  "Sensor outputting the difference between two enthalpy flow rates"
  extends Fluid.Interfaces.PartialFourPortInterface(
    redeclare replaceable package Medium2=Medium1,
    final m1_flow_nominal=m_flow_nominal,
    final m2_flow_nominal=m_flow_nominal,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=allowFlowReversal,
    final m1_flow_small=m_flow_small,
    final m2_flow_small=m_flow_small,
    final show_T=false);
  parameter Boolean have_integrator=false
    "Set to true to output the time integral"
    annotation (Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Time tau(min=0) = 0
    "Time constant at nominal flow rate";
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (InitialState and InitialOutput are identical)"
    annotation (Evaluate=true,Dialog(group="Initialization"));
  parameter Boolean allowFlowReversal=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Modelica.Units.SI.SpecificEnthalpy h1_out_start=
      Medium1.specificEnthalpy_pTX(
      p=Medium1.p_default,
      T=Medium1.T_default,
      X=Medium1.X_default)
    "Initial or guess value of measured specific enthalpy"
    annotation (Dialog(group="Initialization"));
  parameter Modelica.Units.SI.SpecificEnthalpy h2_out_start=
      Medium2.specificEnthalpy_pTX(
      p=Medium2.p_default,
      T=Medium2.T_default,
      X=Medium2.X_default)
    "Initial or guess value of measured specific enthalpy"
    annotation (Dialog(group="Initialization"));
  parameter Medium1.MassFlowRate m_flow_small(min=0)=1E-4*abs(m_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dH_flow(
    final unit="W")
    "Difference in enthalpy flow rate between stream 1 and 2"
    annotation (Placement(transformation(origin={120,20},extent={{-20,-20},{20,20}},rotation=0),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=0,origin={120,30})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput E(
    final unit="J") if have_integrator
    "Time integral of enthalpy flow rate difference between stream 1 and 2"
    annotation (Placement(transformation(origin={120,-20},extent={{-20,-20},{20,20}},rotation=0),
      iconTransformation(extent={{-20,-20},{20,20}},rotation=0,origin={120,-30})));
  Fluid.Sensors.EnthalpyFlowRate senEntFlo1(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=m_flow_nominal,
    final tau=tau,
    final initType=initType,
    final allowFlowReversal=allowFlowReversal,
    final h_out_start=h1_out_start)
    "Enthalpy flow rate of fluid stream 1"
    annotation (Placement(transformation(extent={{-10,70},{10,50}})));
  Fluid.Sensors.EnthalpyFlowRate senEntFlo2(
    redeclare final package Medium=Medium2,
    final m_flow_nominal=m_flow_nominal,
    final tau=tau,
    final initType=initType,
    final allowFlowReversal=allowFlowReversal,
    final h_out_start=h2_out_start)
    "Enthalpy flow rate of fluid stream 2"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dif
    "Compute the difference"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Continuous.Integrator int(
    y(unit="J")) if have_integrator
    "Time integral computation"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
equation
  connect(port_a1,senEntFlo1.port_a)
    annotation (Line(points={{-100,60},{-10,60}},color={0,127,255}));
  connect(senEntFlo1.port_b,port_b1)
    annotation (Line(points={{10,60},{100,60}},color={0,127,255}));
  connect(port_b2,senEntFlo2.port_b)
    annotation (Line(points={{-100,-60},{-10,-60}},color={0,127,255}));
  connect(senEntFlo2.port_a,port_a2)
    annotation (Line(points={{10,-60},{100,-60}},color={0,127,255}));
  connect(dif.y,dH_flow)
    annotation (Line(points={{62,20},{120,20}},color={0,0,127}));
  connect(senEntFlo1.H_flow,dif.u1)
    annotation (Line(points={{0,49},{0,26},{38,26}},color={0,0,127}));
  connect(senEntFlo2.H_flow,dif.u2)
    annotation (Line(points={{0,-49},{0,14},{38,14}},color={0,0,127}));
  connect(int.y,E)
    annotation (Line(points={{61,-20},{120,-20}},color={0,0,127}));
  connect(dif.y,int.u)
    annotation (Line(points={{62,20},{80,20},{80,0},{20,0},{20,-20},{38,-20}},color={0,0,127}));
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
          extent={{173,26},{79,-4}},
          textColor={0,0,0},
          textString="dH_flow"),
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
          color={0,128,255}),
        Text(
          visible=have_integrator,
          extent={{135,-16},{41,-46}},
          textColor={0,0,0},
          textString="E"),
        Text(
          extent={{132,112},{12,62}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(dH_flow,
            leftJustified=false,
            significantDigits=0))),
        Text(
          visible=have_integrator,
          extent={{132,-56},{12,-106}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(E,
            leftJustified=false,
            significantDigits=0)))}),
    Documentation(
      info="<html>
<p>
This model outputs the difference in enthalpy flow rate
between two different streams:
<i>&Delta;H&#775; = m&#775;<sub>1</sub> h<sub>1</sub> - m&#775;<sub>2</sub> h<sub>2</sub></i>.
Optionally the time integral of this quantity can be output.
The sensor is ideal, i.e., it does not influence the fluid.
</p>
<p>
By default
</p>
<ul>
<li>
the parameter <code>tau</code> is zero, so the
specific enthalpy that is used to compute each enthalpy flow rate
is computed in steady-state,
</li>
<li>
the medium is the same in both streams but the model
allows for specifying two different media to represent for
instance the gaseous and liquid state of the same substance.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
October 8, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end DifferenceEnthalpyFlowRate;
