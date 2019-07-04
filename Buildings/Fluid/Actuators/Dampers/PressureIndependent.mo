within Buildings.Fluid.Actuators.Dampers;
model PressureIndependent
  "Pressure independent damper"
  extends Buildings.Fluid.Actuators.Dampers.Exponential(
    dp(nominal=dp_nominal),
    final casePreInd=true,
    final linearized=false,
    final from_dp=true,
    final dp_nominalIncludesDamper=true,
    final dpTot_nominal=dp_nominal+dpFixed_nominal,
    final k1=2 * rho_default * (A / kDam_1)^2,
    final k0=2 * rho_default * (A / kDam_0)^2);
  parameter Modelica.SIunits.PressureDifference dpFixed_nominal(displayUnit="Pa", min=0) = 0
    "Pressure drop of duct and other resistances that are in series"
     annotation(Dialog(group = "Nominal condition"));
  parameter Real l(min=1e-10, max=1, unit="1") = 0.0001
    "Damper leakage, l=k(y=0)/k(y=1)";
  Modelica.Blocks.Interfaces.RealOutput y_actual(unit="1") "Actual damper position"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  parameter Modelica.SIunits.PressureDifference dp_small = 1E-2 * dpTot_nominal
    "Pressure drop for sizing the transition regions"
    annotation(Dialog(tab="Advanced"));
  parameter Real c_regul(unit="s.m") = 1E-4
    "Regularization coefficient"
    annotation(Dialog(tab="Advanced"));
  Modelica.SIunits.PressureDifference dp_lim(displayUnit="Pa")
    "Pressure drop limit before interpolation between pressure independent and leakage flow"
    annotation(Dialog(tab="Advanced"));
  parameter Real tol_m = 1E-2;
  Modelica.SIunits.MassFlowRate m_flow_lim;
protected
  Modelica.SIunits.MassFlowRate m_flow_smooth
    "Smooth interpolation result between the three flow regimes";
  Real y_actual_smooth
    "Fractional opening computed based on m_flow_smooth and dp";
  parameter Real y_min = 2E-2
    "Minimum value of control signal before zeroing the opening.";
  parameter Real kDam_1 = m_flow_nominal / sqrt(dp_nominal_pos)
    "Flow coefficient of damper fully open, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  parameter Real kTot_1 = if dpFixed_nominal > Modelica.Constants.eps then
    sqrt(1 / (1 / kResSqu + 1 / kDam_1^2)) else kDam_1
    "Flow coefficient of damper fully open + fixed resistance, with unit=(kg.m)^(1/2)";
  parameter Real kDam_0 = l * kDam_1
    "Flow coefficient of damper fully closed, with unit=(kg.m)^(1/2)";
  parameter Real kTot_0 = if dpFixed_nominal > Modelica.Constants.eps then
    sqrt(1 / (1 / kResSqu + 1 / kDam_0^2)) else kDam_0
    "Flow coefficient of damper fully closed + fixed resistance, with unit=(kg.m)^(1/2)";
  parameter Integer sizeSupSplBnd = 5 "Number of support points on each quadratic domain for spline interpolation";
  parameter Integer sizeSupSpl = 2 * sizeSupSplBnd + 3 "Total number of support points for spline interpolation";
  parameter Real[sizeSupSpl] ySupSpl_raw = cat(
    1,
    linspace(1, yU, sizeSupSplBnd),
    {yU-1/3*(yU-yL), (yU+yL)/2, yU-2/3*(yU-yL)},
    linspace(yL, 0, sizeSupSplBnd))
    "y values of unsorted support points for spline interpolation";
  parameter Real[sizeSupSpl] kSupSpl_raw = Buildings.Fluid.Actuators.BaseClasses.exponentialDamper(
      y=ySupSpl_raw, a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU) "k values of unsorted support points for spline interpolation";
  parameter Real[sizeSupSpl] ySupSpl(fixed=false) "y values of sorted support points for spline interpolation";
  parameter Real[sizeSupSpl] kSupSpl(fixed=false) "k values of sorted support points for spline interpolation";
  parameter Integer[sizeSupSpl] idx_sorted(fixed=false) "Indexes of sorted support points";
  parameter Real[sizeSupSpl] invSplDer(fixed=false) "Derivatives at support points for spline interpolation";
  Real kThetaDam(unit="1") "Loss coefficient of damper in actual position";
  Real kThetaTot(unit="1") "Loss coefficient of damper + fixed resistance";
  Modelica.SIunits.PressureDifference dp_0(displayUnit="Pa")
    "Pressure drop at required flow rate with damper fully closed";
  Modelica.SIunits.PressureDifference dp_1(displayUnit="Pa")
    "Pressure drop at required flow rate with damper fully open";
initial equation
  kResSqu=if dpFixed_nominal > Modelica.Constants.eps then
    m_flow_nominal^2 / dpFixed_nominal else 0
    "Flow coefficient of fixed resistance in series with damper, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  (kSupSpl, idx_sorted) = Modelica.Math.Vectors.sort(kSupSpl_raw, ascending=true);
  ySupSpl = ySupSpl_raw[idx_sorted];
  invSplDer = Buildings.Utilities.Math.Functions.splineDerivatives(x=kSupSpl, y=ySupSpl);
equation
  dp_lim = dp_1 + tol_m * m_flow_nominal / c_regul;
  m_flow_lim = y_internal * m_flow_nominal + 2 * tol_m * m_flow_nominal;
  dp_0 = max(dp_lim + dp_small,
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
      m_flow=m_flow_lim,
      k=kTot_0,
      m_flow_turbulent=y_min * m_flow_nominal));
  // basicFlowFunction_m_flow and basicFlowFunction_dp are not strict inverse!
  dp_1 = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
    m_flow=y_internal * m_flow_nominal,
    k=kTot_1,
    m_flow_turbulent=m_flow_turbulent);
  m_flow_smooth = smooth(2, noEvent(
    if dp <= dp_1 then
      Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
        dp=dp,
        k=kTot_1,
        m_flow_turbulent=m_flow_turbulent)
    elseif dp <= dp_1 + dp_small then
      Buildings.Utilities.Math.Functions.quinticHermite(
        x=dp,
        x1=dp_1,
        x2=dp_1 + dp_small,
        y1=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
          dp=dp_1,
          k=kTot_1,
          m_flow_turbulent=m_flow_turbulent),
        y2=y_internal * m_flow_nominal + c_regul * dp_small,
        y1d=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der(
          dp=dp_1,
          k=kTot_1,
          m_flow_turbulent=m_flow_turbulent,
          dp_der=1),
        y2d=c_regul,
        y1dd=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2(
          dp=dp_1,
          k=kTot_1,
          m_flow_turbulent=m_flow_turbulent,
          dp_der=1,
          dp_der2=0),
        y2dd=0)
    elseif dp < dp_lim then
      y_internal * m_flow_nominal + c_regul * (dp - dp_1)
    elseif dp < dp_0 then
      Buildings.Utilities.Math.Functions.quinticHermite(
        x=dp,
        x1=dp_lim,
        x2=dp_0,
        y1=y_internal * m_flow_nominal + c_regul * (dp_lim - dp_1),
        y2=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
          dp=dp_0,
          k=kTot_0,
          m_flow_turbulent=y_min * m_flow_nominal),
        y1d=c_regul,
        y2d=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der(
          dp=dp_0,
          k=kTot_0,
          m_flow_turbulent=y_min * m_flow_nominal,
          dp_der=1),
        y1dd=0,
        y2dd=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2(
          dp=dp_0,
          k=kTot_0,
          m_flow_turbulent=y_min * m_flow_nominal,
          dp_der=1,
          dp_der2=0))
    else
      Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
        dp=dp,
        k=kTot_0,
        m_flow_turbulent=y_min * m_flow_nominal)));
  // Computation of damper opening
  kThetaTot = Buildings.Utilities.Math.Functions.regStep(
    x=dp - dp_1 - dp_small / 2,
    y1=Buildings.Utilities.Math.Functions.regStep(
      x=dp - dp_0 + dp_small / 2,
      y1=2 * rho * A^2 / kTot_0^2,
      y2=2 * rho * A^2 / Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_inv(
        m_flow=m_flow,
        dp=dp, m_flow_turbulent=m_flow_turbulent, m_flow_small=m_flow_small, dp_small=dp_small,
        k_min=kTot_0, k_max=kTot_1),
      x_small=dp_small / 2),
    y2=2 * rho * A^2 / kTot_1^2,
    x_small=dp_small / 2);
  kThetaDam = if dpFixed_nominal > Modelica.Constants.eps then
    kThetaTot - 2 * rho * A^2 / kResSqu else kThetaTot;
  y_actual_smooth = Buildings.Utilities.Math.Functions.regStep(
    x=y_internal - y_min,
    y1=Buildings.Fluid.Actuators.BaseClasses.exponentialDamper_inv(
      kThetaSqRt=sqrt(kThetaDam), kSupSpl=kSupSpl, ySupSpl=ySupSpl, invSplDer=invSplDer),
    y2=0,
    x_small=1E-3);
  // Homotopy transformation
  if homotopyInitialization then
    m_flow = homotopy(
      actual=m_flow_smooth,
      simplified=m_flow_nominal_pos * dp / dp_nominal_pos);
    y_actual = homotopy(
      actual=y_actual_smooth,
      simplified=dp / dp_nominal_pos);
  else
    m_flow = m_flow_smooth;
    y_actual = y_actual_smooth;
  end if;
annotation (
defaultComponentName="preInd",
Documentation(info="<html>
<p>
Model for an air damper with ideal pressure independent flow control and exponential characteristics.
</p>
<p>
The input control signal <code>y</code> is the required fractional mass flow rate
(<code>m_flow_setpoint/m_flow_nominal</code>).
</p>
<p>
When the model is exposed to a pressure drop whithin the controllable range, the flow rate is equal
to the setpoint within a 1% tolerance.
</p>
<h4>Main equations</h4>
<p>
First the boundaries of the controllable range <code>dp_0</code> and <code>dp_1</code> are computed based
on the required mass flow rate and the flow coefficient of the damper
in a fully closed and fully open position.
</p>
<p>
Three flow domains are then considered depending on the actual pressure drop at the damper's boundaries:
</p>
<ol>
<li>
Between <code>dp_0</code> and <code>dp_1</code> (controllable domain): an ideal flow control is considered and
the mass flow rate is computed as the setpoint <code>y*m_flow_nominal</code> plus a regularization term so that
the derivative <code>d(m_flow)/d(dp)</code> is not zeroed (which may introduce singularities, for instance when
connecting this component with a fixed mass flow source). The regularization term is such that the error on the
computed flow rate is less than 1% of its nominal value.
</li>
<li>
Above <code>dp_0</code> (leakage domain): the flow rate is computed using the loss coefficient <code>k0</code>
corresponding to the fully closed position.
</li>
<li>
Below <code>dp_1</code> (low flow domain): the flow rate is computed using the loss coefficient <code>k1</code>
corresponding to the fully open position.
</li>
</ol>
<p>
In the transition intervals between these domains, a quintic spline interpolation is used so that the relationship
between the flow rate and the pressure drop is C<sup>2</sup>.
</p>
<p align=\"left\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Actuators/Dampers/PressureIndependent.png\"/>
</p>
<h4>Fractional opening </h4>
<p>
The fractional opening of the damper is then computed by:
</p>
<ul>
<li>
inverting the quadratic flow function (see <a href=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow>
Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow</a>)
to compute the flow coefficient from the flow rate and the pressure drop values;
</li>
<li>
inverting the exponential characteristics (see <a href=Buildings.Fluid.Actuators.Dampers.Exponential>
Buildings.Fluid.Actuators.Dampers.Exponential</a>) to compute
the fractional opening from the loss coefficient value (directly yielded from the flow coefficient).
</li>
</ul>
<p>
Below a threshold value of the input control signal (fixed at 0.02) the fractional opening is forced to zero and
no more related to the actual flow coefficient of the damper.
This avoids steep transient of the computed opening while transiting from reverse flow. This is to be considered
as a modeling workaround to prevent control chattering during shut off period (while avoiding an additional state
variable).
</p>
<h4>Optional fixed flow resistance</h4>
<p>
The model allows for the definition of an optional fixed flow resistance in series with the damper.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 19, 2019, by Antoine Gautier:<br/>
Added opening calculation, improved leakage modeling and fixed mass flow rate drift at high pressure drop.<br/>
This is for
<a href=\https://github.com/lbl-srg/modelica-buildings/issues/1298\">#1298</a>.
</li>
<li>
March 21, 2017 by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end PressureIndependent;
