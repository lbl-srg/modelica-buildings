within Buildings.Fluid.HeatExchangers.BaseClasses;
partial model PartialEffectiveness
  "Partial model to implement heat exchangers based on effectiveness model"
  extends Fluid.Interfaces.StaticFourPortHeatMassExchanger(
    prescribedHeatFlowRate1=true,
    prescribedHeatFlowRate2=true,
    show_T=false);

  Medium1.Temperature T_in1 = if allowFlowReversal1 then
    fra_a1 * Medium1.temperature(state_a1_inflow) + fra_b1 * Medium1.temperature(state_b1_inflow) else
    Medium1.temperature(state_a1_inflow)
    "Inlet temperature medium 1";
  Medium2.Temperature T_in2 = if allowFlowReversal2 then
    fra_a2 * Medium2.temperature(state_a2_inflow) + fra_b2 * Medium2.temperature(state_b2_inflow) else
    Medium2.temperature(state_a2_inflow)
    "Inlet temperature medium 2";
  Modelica.Units.SI.ThermalConductance C1_flow=abs(m1_flow)*(if
      allowFlowReversal1 then fra_a1*Medium1.specificHeatCapacityCp(
      state_a1_inflow) + fra_b1*Medium1.specificHeatCapacityCp(state_b1_inflow)
       else Medium1.specificHeatCapacityCp(state_a1_inflow))
    "Heat capacity flow rate medium 1";
  Modelica.Units.SI.ThermalConductance C2_flow=abs(m2_flow)*(if
      allowFlowReversal2 then fra_a2*Medium2.specificHeatCapacityCp(
      state_a2_inflow) + fra_b2*Medium2.specificHeatCapacityCp(state_b2_inflow)
       else Medium2.specificHeatCapacityCp(state_a2_inflow))
    "Heat capacity flow rate medium 2";
  Modelica.Units.SI.ThermalConductance CMin_flow(min=0) = min(C1_flow, C2_flow)
    "Minimum heat capacity flow rate";
  Modelica.Units.SI.HeatFlowRate QMax_flow=CMin_flow*(T_in2 - T_in1)
    "Maximum heat flow rate into medium 1";
protected
  parameter Real delta=1E-3 "Parameter used for smoothing";

  parameter Modelica.Units.SI.SpecificHeatCapacity cp1_default(fixed=false)
    "Specific heat capacity of medium 1 at default medium state";
  parameter Modelica.Units.SI.SpecificHeatCapacity cp2_default(fixed=false)
    "Specific heat capacity of medium 2 at default medium state";
  parameter Modelica.Units.SI.ThermalConductance CMin_flow_small(fixed=false)
    "Small value for smoothing of minimum heat capacity flow rate";
  Real fra_a1(min=0, max=1) = if allowFlowReversal1
    then Modelica.Fluid.Utilities.regStep(
      m1_flow,
      1,
      0,
      m1_flow_small)
    else 1
    "Fraction of incoming state taken from port a1 (used to avoid excessive calls to regStep)";
  Real fra_b1(min=0, max=1) = if allowFlowReversal1
    then 1-fra_a1
    else 0
    "Fraction of incoming state taken from port b1 (used to avoid excessive calls to regStep)";
  Real fra_a2(min=0, max=1) = if allowFlowReversal2
    then Modelica.Fluid.Utilities.regStep(
      m2_flow,
      1,
      0,
      m2_flow_small)
    else 1
    "Fraction of incoming state taken from port a2 (used to avoid excessive calls to regStep)";
  Real fra_b2(min=0, max=1) = if allowFlowReversal2
    then 1-fra_a2
    else 0
    "Fraction of incoming state taken from port b2 (used to avoid excessive calls to regStep)";
initial equation
  cp1_default = Medium1.specificHeatCapacityCp(Medium1.setState_pTX(
    Medium1.p_default,
    Medium1.T_default,
    Medium1.X_default));
  cp2_default = Medium2.specificHeatCapacityCp(Medium2.setState_pTX(
    Medium2.p_default,
    Medium2.T_default,
    Medium2.X_default));
  CMin_flow_small = min(m1_flow_small*cp1_default, m2_flow_small*cp2_default);

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-70,78},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Partial model to implement heat exchanger models.
</p>
<p>
Classes that extend this model need to implement heat and
mass balance equations in a form like
</p>
<pre>
  // transferred heat
  Q1_flow = eps * QMax_flow;
  // no heat loss to ambient
  0 = Q1_flow + Q2_flow;
  // no mass exchange
  mXi1_flow = zeros(Medium1.nXi);
  mXi2_flow = zeros(Medium2.nXi);
</pre>
<p>
Thus, if medium 1 is heated in this device, then <code>Q1_flow &gt; 0</code>
and <code>QMax_flow &gt; 0</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 21, 2019, by Filip Jorissen:<br/>
Revised implementation of all equations
such that a binding equation is used. 
I.e. we set the variable value at the variable definition
instead of using the equation section.
This allows overwriting the equation
when extending the model.<br/>
See
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1102\">#1102</a>.
</li>
<li>
April 30, 2018, by Filip Jorissen:<br/>
Set <code>prescribedHeatFlowRate1=true</code> and 
<code>prescribedHeatFlowRate2=true</code>.<br/>
See
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/907\">#907</a>.
</li>
<li>
June 9, 2015 by Michael Wetter:<br/>
Changed type of <code>T_in1</code> and <code>T_in2</code>
to <code>Medium1.Temperature</code> and <code>Medium2.Temperature</code>
to avoid an error because of conflicting start values if
<a href=\"modelica://Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples.ChillerSetPointControl\">
Buildings.Examples.ChillerPlant.BaseClasses.Controls.Examples.ChillerSetPointControl</a>
is translated using pedantic mode in Dymola 2016.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">#426</a>.
</li>
<li>
October 8, 2011, by Michael Wetter:<br/>
Set <code>show_T=false</code> to avoid state events near zero flow.
</li>
<li>
August 31, 2011, by Michael Wetter:<br/>
Removed unused variables <code>gai1</code> and <code>gai2</code>.
</li>
<li>
February 12, 2010, by Michael Wetter:<br/>
Changed model structure to implement effectiveness-NTU model.
</li>
<li>
January 28, 2010, by Michael Wetter:<br/>
Added regularization near zero flow.
</li>
<li>
October 2, 2009, by Michael Wetter:<br/>
Changed computation of inlet temperatures to use
<code>state_*_inflow</code> which is already known in base class.
</li>
<li>
April 28, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialEffectiveness;
