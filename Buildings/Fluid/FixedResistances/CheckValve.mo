within Buildings.Fluid.FixedResistances;
model CheckValve "Check valve that avoids flow reversal"
  extends Buildings.Fluid.BaseClasses.PartialResistance(
    dp(nominal=2000),
    final dp_nominal=dpValve_nominal + dpFixed_nominal,
    final m_flow_turbulent=deltaM*abs(m_flow_nominal),
    final from_dp=true,
    final linearized=false,
    allowFlowReversal=true);
  extends Buildings.Fluid.Actuators.BaseClasses.ValveParameters(
    rhoStd=Medium.density_pTX(101325, 273.15 + 4, Medium.X_default));

  parameter Modelica.Units.SI.PressureDifference dpFixed_nominal(
    displayUnit="Pa",
    min=0) = 0 "Pressure drop of pipe and other resistances that are in series"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dpValve_closing=
      dpValve_nominal/2 "Pressure drop when the check valve starts to close"
    annotation (Dialog(group="Nominal condition"));

  parameter Real l(min=1e-10, max=1)=0.001 "Valve leakage, l=Kv(y=0)/Kv(y=1)";

  parameter Real kFixed(unit="", min=0)=
    if dpFixed_nominal > Modelica.Constants.eps then
      m_flow_nominal/sqrt(dpFixed_nominal)
    else 0
    "Flow coefficient of fixed resistance that may be in series with valve,
    k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2).";
protected
  parameter Real k_min=if dpFixed_nominal > Modelica.Constants.eps then
    sqrt(1 / (1 / kFixed ^ 2 + 1 /(l * Kv_SI) ^ 2)) else l * Kv_SI
    "Minimum flow coefficient (valve closed)";
  parameter Real k_max=if dpFixed_nominal > Modelica.Constants.eps then
    sqrt(1 / (1 / kFixed ^ 2 + 1 / Kv_SI ^ 2)) else Kv_SI
    "Maximum flow coefficient (valve fully open)";
  parameter Modelica.Units.SI.MassFlowRate m1_flow = 0
    "Flow rate through closed valve with zero pressure drop";
  parameter Modelica.Units.SI.MassFlowRate m2_flow =
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
      dp=dpValve_closing,
      k=k_max,
      m_flow_turbulent=m_flow_turbulent)
    "Flow rate through fully open valve exposed to dpValve_closing";
  parameter Real dm1_flow_dp =
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der(
      dp=0,
      k=k_min,
      m_flow_turbulent=m_flow_turbulent,
      dp_der=1)
    "Derivative of closed valve flow function at dp=0";
  parameter Real dm2_flow_dp =
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der(
      dp=dpValve_closing,
      k=k_max,
      m_flow_turbulent=m_flow_turbulent,
      dp_der=1)
    "Derivative of open valve flow function at dp=dpValve_closing";
  parameter Real d2m1_flow_dp =
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2(
      dp=0,
      k=k_min,
      m_flow_turbulent=m_flow_turbulent,
      dp_der=1,
      dp_der2=0)
    "Second derivative of closed valve flow function at dp=0";
  parameter Real d2m2_flow_dp =
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2(
      dp=dpValve_closing,
      k=k_max,
      m_flow_turbulent=m_flow_turbulent,
      dp_der=1,
      dp_der2=0)
    "Second derivative of open valve flow function at dp=dpValve_closing";
  Modelica.Units.SI.MassFlowRate m_flow_smooth
    "Smooth interpolation result between two flow regimes";
initial equation
  assert(dpFixed_nominal > - Modelica.Constants.eps, "In " + getInstanceName() +
    ": We require dpFixed_nominal >= 0.
    Received dpFixed_nominal = " + String(dpFixed_nominal) + " Pa.");
  assert(l > - Modelica.Constants.eps, "In " + getInstanceName() +
    ": We require l >= 0. Received l = " + String(l));
equation
  m_flow_smooth=noEvent(smooth(2,
    if dp <= 0 then Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
      dp=dp,
      k=k_min,
      m_flow_turbulent=m_flow_turbulent)
    elseif dp >= dpValve_closing then Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
      dp=dp,
      k=k_max,
      m_flow_turbulent=m_flow_turbulent)
    else Buildings.Utilities.Math.Functions.quinticHermite(
      x=dp,
      x1=0,
      x2=dpValve_closing,
      y1=0,
      y2=m2_flow,
      y1d=dm1_flow_dp,
      y2d=dm2_flow_dp,
      y1dd=d2m1_flow_dp,
      y2dd=d2m2_flow_dp)));
  if homotopyInitialization then
    m_flow=homotopy(
      actual=m_flow_smooth,
      simplified=m_flow_nominal_pos * dp / dp_nominal_pos);
  else
    m_flow=m_flow_smooth;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}), graphics={
        Polygon(
          points={{100,-42},{-100,-42},{-100,40},{100,40},{100,-42}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-100,0},{-70,0}},
          color={0,128,255},
          thickness=0.5),
        Line(
          points={{0,70},{-70,0}},
          color={0,128,255},
          thickness=0.5),
        Line(
          points={{0,-70},{-70,0}},
          color={0,128,255},
          thickness=0.5),
        Ellipse(
          extent={{-40,-55},{70,55}},
          lineColor={0,128,255},
          fillColor={255,255,255},
          lineThickness=0.5,
          fillPattern=FillPattern.Solid),
        Line(
          points={{70,0},{100,0}},
          color={0,128,255},
          thickness=0.5)}),
defaultComponentName="cheVal",
Documentation(info="<html>
<p>
Implementation of a hydraulic check valve.
Note that small reverse flows can still occur with this model.
</p>
<h4>Main equations</h4>
<p>
The basic flow function
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775; = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>,
</p>
<p>
with regularization near the origin, is used to compute the mass flow rate
through the fully closed and fully open valve, respectively.
The valve is considered fully closed when subjected to a negative pressure drop,
and its flow coefficient <i>k</i> is then equal to <code>l * Kv_SI</code>,
where <code>Kv_SI</code> is equal to <code>Kv</code> but in SI units.
The valve is considered fully open when the pressure drop exceeds
<code>dpValve_closing</code>,
and its flow coefficient <i>k</i> is then equal to <code>Kv_SI</code>.
For valve positions between these two extremes, a quintic spline interpolation
is applied to determine the mass flow rate as a function of
the pressure drop across the valve.
</p>
<h4>Typical use and important parameters</h4>
<p>
The parameters <code>m_flow_nominal</code> and <code>dpValve_nominal</code>
determine the flow coefficient of the check valve when it is fully open.
The leakage ratio <code>l</code> determines the minimum flow coefficient,
for negative pressure differences.
The parameter <code>dpFixed_nominal</code> allows to include a series
pressure drop with a fixed flow coefficient into the model.
The parameter <code>dpValve_closing</code> determines when the
flow coefficient starts to increase,
which is typically in the order of <code>dpValve_nominal</code>.
</p>
<h4>Implementation</h4>
<p>
The check valve implementation approximates the physics
where a forward pressure difference opens the valve such that
the valve opening increases, causing a growing orifice area
and thus increasing the flow coefficient.
Near <code>dp=dpValve_closing</code>, the valve is fully open and the flow coefficient saturates
to the flow coefficient value determined by <code>dpValve_nominal</code> and <code>m_flow_nominal</code>.
For typical valve diameters, the check valve is only fully open
near nominal mass flow rate. Therefore, the model sets <code>dpValve_closing=dpValve_nominal/2</code>
by default.
</p>
</html>", revisions="<html>
<ul>
<li>
October 14, 2024, by Antoine Gautier:<br/>
Refactored using a spline interpolation. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1937\">issue 1937</a>.
</li>
<li>
February 3, 2023, by Michael Wetter:<br/>
Corrected graphical annotation.
</li>
<li>
September 16, 2019, by Kristoff Six and Filip Jorissen:<br/>
Implementation of a hydraulic check valve. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1198\">issue 1198</a>.
</li>
</ul>
</html>"));
end CheckValve;
