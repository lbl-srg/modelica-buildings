within Buildings.ChillerWSE.BaseClasses;
model WSEWithBypass
  "Water side economizer with hotside outlet temperature control"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
   final computeFlowResistance1=(dp1_nominal > Modelica.Constants.eps),
   final computeFlowResistance2=(dp2_nominal > Modelica.Constants.eps));
  extends Buildings.Fluid.Actuators.BaseClasses.ValveParameters(
   rhoStd=Medium2.density_pTX(101325, 273.15+4, Medium2.X_default),
   final dpValve_nominal=dp2_nominal,
   final m_flow_nominal=m2_flow_nominal,
   final deltaM=deltaM2);

  parameter Modelica.SIunits.Efficiency eps "constant effectiveness";

  parameter Real l(min=1e-10, max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)";
  parameter Real kFixed(unit="", min=0) = 0
    "Flow coefficient of fixed resistance that may be in series with valve, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2).";
  parameter Real R=50 "Rangeability, R=50...100 typically";
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law";
  // Filter opening
  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening"));
  parameter Modelica.SIunits.Time riseTime=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  parameter Real y_start=1 "Initial value of output"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_inputFilter));
  // Advanced
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Blocks.Interfaces.RealInput bypSig(min=0,max=1)
    "Signal for bypass valve(0: closed, 1: open)"
    annotation (Placement(transformation(extent={{-128,-14},{-100,14}}),
        iconTransformation(extent={{-120,-6},{-100,14}})));

  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage bypVal(
    redeclare package Medium = Medium2,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    final dpFixed_nominal=0,
    final allowFlowReversal=allowFlowReversal2,
    final show_T=show_T,
    final from_dp=from_dp2,
    final linearized=linearizeFlowResistance2,
    final CvData=CvData,
    final Kv=Kv,
    final Cv=Cv,
    final Av=Av,
    final rhoStd=rhoStd,
    final deltaM=deltaM,
    final homotopyInitialization=homotopyInitialization,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final y_start=y_start,
    final l=l,
    final kFixed=kFixed,
    final R=R,
    final delta0=delta0)
    "Bypass valve used to control the outlet temperature "
    annotation (Placement(transformation(extent={{10,-50},{-10,-30}})));

  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final show_T=show_T,
    final from_dp1=from_dp1,
    final dp1_nominal=dp1_nominal,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final deltaM1=deltaM1,
    final from_dp2=from_dp2,
    final dp2_nominal=dp2_nominal,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM2=deltaM2,
    final eps=eps,
    final homotopyInitialization=homotopyInitialization)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation

  connect(bypSig,bypVal. y) annotation (Line(points={{-114,1.77636e-15},{-114,0},
          {-60,0},{-60,-20},{0,-20},{0,-28}},
                     color={0,0,127}));
  connect(port_a1, hex.port_a1) annotation (Line(points={{-100,60},{-100,60},{-40,
          60},{-40,6},{-10,6}}, color={0,127,255}));
  connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{40,6},{40,60},{
          100,60}}, color={0,127,255}));
  connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{40,-6},{40,-60},
          {100,-60}}, color={0,127,255}));
  connect(hex.port_b2, port_b2) annotation (Line(points={{-10,-6},{-40,-6},{-40,
          -60},{-100,-60}}, color={0,127,255}));
  connect(bypVal.port_a, port_a2) annotation (Line(points={{10,-40},{40,-40},{40,
          -60},{100,-60}}, color={0,127,255}));
  connect(bypVal.port_b, port_b2) annotation (Line(points={{-10,-40},{-40,-40},{
          -40,-60},{-100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},
            {100,80}}),                                         graphics={
        Text(
          extent={{-142,-162},{172,-132}},
          lineColor={0,0,255},
          textString="%name"),
        Ellipse(
          extent={{-80,80},{120,76}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,62},{120,58}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,40},{120,36}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,22},{120,18}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,2},{120,-2}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,-18},{120,-22}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,-38},{120,-42}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,-58},{120,-62}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-80,-78},{120,-82}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})),
    __Dymola_Commands,
    Documentation(info="<html>
<p>This module simulates a heat exchanger with bypass used to modulate water flow rate.</p>
</html>", revisions="<html>
<ul>
<li>
September 08, 2016, by Yangyang Fu:<br>
Delete parameter: nominal flowrate of temperaure sensors. 
</li>
</ul>
<ul>
<li>
July 30, 2016, by Yangyang Fu:<br>
First implementation.
</li>
</ul>
</html>"));
end WSEWithBypass;
