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

  Real k(min=Modelica.Constants.small)
    "Flow coefficient of valve and pipe in series in allowed/forward direction,
    k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2).";

protected
  Real a
    "Scaled pressure variable";
  Real cv
    "Twice differentiable Heaviside check valve characteristic";
  Real kCv
    "Smoothed restriction characteristic";

initial equation
  assert(dpFixed_nominal > -Modelica.Constants.eps,
    "In " + getInstanceName() + ": We require dpFixed_nominal >= 0.
    Received dpFixed_nominal = " + String(dpFixed_nominal) + " Pa.");
  assert(l > -Modelica.Constants.eps,
    "In " + getInstanceName() + ": We require l >= 0. Received l = " + String(l));
equation
  a = dp/dpValve_closing;
  cv = smooth(2, max(0, min(1, a^3*(10+a*(-15+6*a)))));
  kCv = Kv_SI*(cv*(1-l) + l);

  if (dpFixed_nominal > Modelica.Constants.eps) then
    k = sqrt(1/(1/kFixed^2 + 1/kCv^2));
  else
    k = kCv;
  end if;

  if homotopyInitialization then
    m_flow = homotopy(
      actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
            dp = dp,
            k = k,
            m_flow_turbulent = m_flow_turbulent),
      simplified = m_flow_nominal_pos*dp/dp_nominal_pos);
  else
    m_flow = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
        dp = dp,
        k = k,
        m_flow_turbulent = m_flow_turbulent);
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
Note that the small reverse flows can still occur with this model.
</p>
<h4>Main equations</h4>
<p>
The basic flow function
</p>
<p align=\"center\" style=\"font-style:italic;\">
  m&#775; = sign(&Delta;p) k  &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>,
</p>
<p>
with regularization near the origin, is used to compute the pressure drop.
The flow coefficient
</p>
<p align=\"center\" style=\"font-style:italic;\">
  k = m&#775; &frasl; &radic;<span style=\"text-decoration:overline;\">&nbsp;&Delta;p &nbsp;</span>
</p>
<p>
is increased from <code>l*KV_Si</code> to <code>KV_Si</code>,
where <code>KV_Si</code> is equal to <code>Kv</code> but in SI units.
Therefore, the flow coefficient <code>k</code> is set to a value close to zero for negative pressure differences, thereby
restricting reverse flow to a small value.
The flow coefficient <code>k</code> saturates to its maximum value at the pressure <code>dpValve_closing</code>.
For larger pressure drops, the pressure drop is a quadratic function of the flow rate.
</p>
<h4>Typical use and important parameters</h4>
<p>
The parameters <code>m_flow_nominal</code> and <code>dpValve_nominal</code>
determine the flow coefficient of the check valve when it is fully opened.
A typical value for a nominal flow rate of <i>1</i> m/s is
<code>dpValve_nominal = 3400 Pa</code>.
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
February 3, 2023, by Michael Wetter:<br/>
Corrected grahpical annotation.
</li>
<li>
September 16, 2019, by Kristoff Six and Filip Jorissen:<br/>
Implementation of a hydraulic check valve. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1198\">issue 1198</a>.
</li>
</ul>
</html>"));
end CheckValve;
