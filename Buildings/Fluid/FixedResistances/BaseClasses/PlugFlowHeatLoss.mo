within Buildings.Fluid.FixedResistances.BaseClasses;
model PlugFlowHeatLoss
  "Heat loss model for pipe with delay as an input variable"
  extends Fluid.Interfaces.PartialTwoPortTransport(
    final allowFlowReversal=true,
    final dp_start=0);
    // allowFlowReversal set to true because this model is used for inlet and outlets

  parameter Real C(unit="J/(K.m)")
    "Thermal capacity per unit length of pipe";
  parameter Real R(unit="(m.K)/W")
    "Thermal resistance per unit length from fluid to boundary temperature";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal "Nominal mass flow rate";
  parameter Modelica.SIunits.Temperature T_start
    "Initial output temperature";

  final parameter Modelica.SIunits.Time tau_char=R*C "Characteristic delay time";

  Modelica.Blocks.Interfaces.RealInput tau(unit="s") "Time delay at pipe level"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-60,100})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort
    "Heat port to connect environment (negative if heat is lost to ambient)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));

  Modelica.SIunits.Temperature T_a_inflow(start=T_start)
    "Temperature at port_a for inflowing fluid";
  Modelica.SIunits.Temperature T_b_outflow(start=T_start)
    "Temperature at port_b for outflowing fluid";
  Modelica.SIunits.Temperature TAmb=heatPort.T "Environment temperature";

protected
  parameter Medium.ThermodynamicState sta_default=Medium.setState_pTX(
      T=Medium.T_default,
      p=Medium.p_default,
      X=Medium.X_default) "Default medium state";
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(state=sta_default)
    "Heat capacity of medium";

equation
  dp = 0;

  port_a.h_outflow = inStream(port_b.h_outflow);

  port_b.h_outflow =Medium.specificEnthalpy(
    Medium.setState_pTX(
      port_a.p,
      T_b_outflow,
      port_b.Xi_outflow)) "Calculate enthalpy of output state";

    T_a_inflow = Medium.temperature(
      Medium.setState_phX(
        port_a.p,
        inStream(port_a.h_outflow),
        port_b.Xi_outflow));

  // Heat losses
  T_b_outflow = TAmb + (T_a_inflow - TAmb)*Modelica.Math.exp(-tau/tau_char);

  heatPort.Q_flow = -Buildings.Utilities.Math.Functions.spliceFunction(
    pos=(T_a_inflow - T_b_outflow)*cp_default,
    neg=0,
    x=port_a.m_flow,
    deltax=m_flow_nominal/1000)*port_a.m_flow;

  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
          extent={{-80,80},{80,-68}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-52,2},{42,2},{42,8},{66,0},{42,-8},{42,-2},{-52,-2},{-52,2}},
          lineColor={0,128,255},
          fillPattern=FillPattern.Solid,
          fillColor={170,213,255}),
        Polygon(
          points={{0,60},{38,2},{20,2},{20,-46},{-18,-46},{-18,2},{-36,2},{0,60}},
          lineColor={0,0,0},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
Component that calculates the heat losses at the end of a plug flow pipe
when the flow goes in the design direction.
</p>
<h4>Main equations</h4>
<p>
The governing equations are
</p>
<p align=\"center\" style=\"font-style:italic;\">
T<sub>out</sub> = T<sub>b</sub> + (T<sub>in</sub> - T<sub>b</sub>)
exp((t<sub>out</sub> - t<sub>in</sub>)/tau<sub>char</sub>)
</p>
<p>
with
</p>
<p align=\"center\" style=\"font-style:italic;\">
tau<sub>char</sub> = R C
</p>
<h4>Assumptions and limitations</h4>
<p>
This model is based on the following assumptions:
</p>
<ul>
<li>The water temperature is uniform in the cross section.</li>
<li>There is no axial heat transfer in the water or surrounding.</li>
<li>The boundary temperature along the pipe is uniform.</li>
<li>Heat losses are steady-state.</li>
</ul>
<h4>Implementation</h4>
<p>
Heat losses are only considered in design flow direction.
For heat loss consideration in both directions, use one of these models at
both ends of a
<a href=\"modelica://Buildings.Fluid.FixedResistances.BaseClasses.PlugFlow\">
Buildings.Fluid.FixedResistances.BaseClasses.PlugFlow</a> model.
The outlet temperature is calculated as in the equation above,
using the inlet temperature at <code>port_a</code> and the instantaneous
time delay and boundary temperature.
The boundary temperature can be either the air temperature
or the undisturbed ground temperature, depending on the definition of the
thermal resistance <i>R</i>.
</p>
<p>
This component requires the delay time and the instantaneous ambient temperature
as an input.
This component is to be used in single pipes or in more advanced configurations
where no influence from other pipes is considered.</p>
</html>",
revisions="<html>
<ul>
<li>
December 6, 2017, by Michael Wetter:<br/>
Reformulated call to medium function.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/869\">
issue 869</a>.
</li>
<li>
October 20, 2017, by Michael Wetter:<br/>
Revised implementation to avoid graphical and textual modeling.
Revised variable names and documentation to follow guidelines.
</li>
<li>
November 6, 2015 by Bram van der Heijde:<br/>
Make time delay input instead of calculation inside this model.
</li>
<li>
September, 2015 by Marcus Fuchs:<br/>
First implementation.</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})));
end PlugFlowHeatLoss;
