within Buildings.Fluid.Actuators.Dampers;
model PressureIndependent
  "Model for an air damper whose mass flow is proportional to the input signal"
  extends Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential(
    final linearized=false,
    final casePreInd=true,
    from_dp=true);
  input Real phi = l + y_internal*(1 - l)
    "Ratio actual to nominal mass flow rate of damper, phi=kDam(y)/kDam(y=1)";
  parameter Real l2(unit="1", min=1e-10) = 0.01
    "Gain for mass flow increase if pressure is above nominal pressure"
    annotation(Dialog(tab="Advanced"));
  parameter Real deltax(unit="1", min=1E-5) = 0.02 "Transition interval for flow rate"
    annotation(Dialog(tab="Advanced"));
protected
  constant Real y_min = 2E-2
    "Minimum value of control signal before zeroing of the opening";
  constant Integer sizeSupSplBnd = 5
    "Number of support points on each quadratic domain for spline interpolation";
  constant Integer sizeSupSpl = 2 * sizeSupSplBnd + 3
    "Total number of support points for spline interpolation";
  constant Real y2dd = 0
    "Second derivative at second support point";

  parameter Real[sizeSupSpl] ySupSpl_raw = cat(
    1,
    linspace(1, yU, sizeSupSplBnd),
    {yU-1/3*(yU-yL), (yU+yL)/2, yU-2/3*(yU-yL)},
    linspace(yL, 0, sizeSupSplBnd))
    "y values of unsorted support points for spline interpolation";
  parameter Real[sizeSupSpl] kSupSpl_raw = Buildings.Fluid.Actuators.BaseClasses.exponentialDamper(
    y=ySupSpl_raw, a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU) .^ 2
    "k values of unsorted support points for spline interpolation";
  parameter Real[sizeSupSpl] ySupSpl(each fixed=false)
    "y values of sorted support points for spline interpolation";
  parameter Real[sizeSupSpl] kSupSpl(each fixed=false)
    "k values of sorted support points for spline interpolation";
  parameter Integer[sizeSupSpl] idx_sorted(each fixed=false)
    "Indices of sorted support points";
  parameter Real[sizeSupSpl] invSplDer(each fixed=false)
    "Derivatives at support points for spline interpolation";
  parameter Real coeff1 = l2/dpDamper_nominal*m_flow_nominal
    "Parameter for avoiding unnecessary computations";
  parameter Real coeff2 = 1/coeff1
    "Parameter for avoiding unnecessary computations";

  Real kSquInv
    "Square inverse of flow coefficient (damper plus fixed resistance)";
  Real kDamSquInv
    "Square inverse of flow coefficient (damper only)";

  Modelica.Units.SI.MassFlowRate m_flow_set "Requested mass flow rate";
  Modelica.Units.SI.PressureDifference dp_min(displayUnit="Pa")
    "Minimum pressure difference required for delivering requested mass flow rate";
  Modelica.Units.SI.PressureDifference dp_x;
  Modelica.Units.SI.PressureDifference dp_x1;
  Modelica.Units.SI.PressureDifference dp_x2;
  Modelica.Units.SI.PressureDifference dp_y2;
  Modelica.Units.SI.PressureDifference dp_y1
    "Support points for interpolation flow functions";
  Modelica.Units.SI.MassFlowRate m_flow_x;
  Modelica.Units.SI.MassFlowRate m_flow_x1;
  Modelica.Units.SI.MassFlowRate m_flow_x2;
  Modelica.Units.SI.MassFlowRate m_flow_y2;
  Modelica.Units.SI.MassFlowRate m_flow_y1
    "Support points for interpolation flow functions";
  Modelica.Units.SI.MassFlowRate m_flow_smooth
    "Smooth interpolation result between two flow regimes";
  Modelica.Units.SI.PressureDifference dp_smooth
    "Smooth interpolation result between two flow regimes";
  Real y_actual_smooth(final unit="1")
    "Fractional opening computed based on m_flow_smooth and dp";

function basicFlowFunction_dp_m_flow
  "Inverse of flow function that computes that computes the square inverse of flow coefficient"
  extends Modelica.Icons.Function;
    input Modelica.Units.SI.MassFlowRate m_flow
      "Mass flow rate in design flow direction";
    input Modelica.Units.SI.PressureDifference dp
      "Pressure difference between port_a and port_b (= port_a.p - port_b.p)";
    input Modelica.Units.SI.MassFlowRate m_flow_small
      "Minimum value of mass flow rate guarding against k=(0)/sqrt(dp)";
    input Modelica.Units.SI.PressureDifference dp_small
      "Minimum value of pressure drop guarding against k=m_flow/(0)";
  output Real kSquInv
    "Square inverse of flow coefficient";
  protected
    Modelica.Units.SI.PressureDifference dpPos=
        Buildings.Utilities.Math.Functions.smoothMax(
        dp,
        -dp,
        dp_small) "Regularized absolute value of pressure drop";
  Real mSqu_flow = Buildings.Utilities.Math.Functions.smoothMax(
    m_flow^2, m_flow_small^2, m_flow_small^2)
    "Regularized square value of mass flow rate";
algorithm
  kSquInv := dpPos / mSqu_flow;
annotation (smoothOrder=1);
end basicFlowFunction_dp_m_flow;

function exponentialDamper_inv
  "Inverse function of the exponential damper characteristics"
  extends Modelica.Icons.Function;
  input Real kTheta "Loss coefficient";
  input Real[:] kSupSpl "k values of support points";
  input Real[:] ySupSpl "y values of support points";
  input Real[:] invSplDer "Derivatives at support points";
  output Real y "Fractional opening";
  protected
  parameter Integer sizeSupSpl = size(kSupSpl, 1) "Number of spline support points";
  Integer i "Integer to select data interval";
algorithm
  i := 1;
  for j in 2:sizeSupSpl loop
    if kTheta <= kSupSpl[j] then
      i := j;
      break;
    end if;
  end for;
  y := Buildings.Utilities.Math.Functions.smoothLimit(
    Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
      x=kTheta,
      x1=kSupSpl[i - 1],
      x2=kSupSpl[i],
      y1=ySupSpl[i - 1],
      y2=ySupSpl[i],
      y1d=invSplDer[i - 1],
      y2d=invSplDer[i]),
    0,
    1,
    1E-3);
annotation (smoothOrder=1);
end exponentialDamper_inv;

initial equation
  (kSupSpl, idx_sorted) = Modelica.Math.Vectors.sort(kSupSpl_raw, ascending=true);
  // The sum below is a trick to avoid in OPTIMICA the warning
  // Variable array index in equation can result in slow simulation time.
  // This warning was issued for the formulation ySupSpl = ySupSpl_raw[idx_sorted];
  for i in 1:sizeSupSpl loop
    ySupSpl[i] = sum((if k == idx_sorted[i] then ySupSpl_raw[k] else 0) for k in 1:sizeSupSpl);
  end for;
  invSplDer = Buildings.Utilities.Math.Functions.splineDerivatives(x=kSupSpl_raw, y=ySupSpl_raw);
equation
  // From TwoWayPressureIndependent valve model
  m_flow_set = m_flow_nominal*phi;
  dp_min = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
              m_flow=m_flow_set,
              k=kTotMax,
              m_flow_turbulent=m_flow_turbulent);

  if from_dp then
    m_flow_x=0;
    m_flow_x1=0;
    m_flow_x2=0;
    dp_y1=0;
    dp_y2=0;
    dp_smooth=0;

    dp_x = dp-dp_min;
    dp_x1 = -dp_x2;
    dp_x2 = deltax*dp_min;
    // min function ensures that m_flow_y1 does not increase further for dp_x > dp_x1
    m_flow_y1 = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                                  dp=min(dp, dp_min+dp_x1),
                                  k=kTotMax,
                                  m_flow_turbulent=m_flow_turbulent);
    // max function ensures that m_flow_y2 does not decrease further for dp_x < dp_x2
    m_flow_y2 = m_flow_set + coeff1*max(dp_x,dp_x2);

    m_flow_smooth = noEvent(smooth(2,
        if dp_x <= dp_x1
        then m_flow_y1
        elseif dp_x >=dp_x2
        then m_flow_y2
        else Buildings.Utilities.Math.Functions.quinticHermite(
                 x=dp_x,
                 x1=dp_x1,
                 x2=dp_x2,
                 y1=m_flow_y1,
                 y2=m_flow_y2,
                 y1d= Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der(
                                     dp=dp_min + dp_x1,
                                     k=kTotMax,
                                     m_flow_turbulent=m_flow_turbulent,
                                     dp_der=1),
                 y2d=coeff1,
                 y1dd=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2(
                                     dp=dp_min + dp_x1,
                                     k=kTotMax,
                                     m_flow_turbulent=m_flow_turbulent,
                                     dp_der=1,
                                     dp_der2=0),
                 y2dd=y2dd)));
  else
    dp_x=0;
    dp_x1=0;
    dp_x2=0;
    m_flow_y1=0;
    m_flow_y2=0;
    m_flow_smooth=0;

    m_flow_x = m_flow-m_flow_set;
    m_flow_x1 = -m_flow_x2;
    m_flow_x2 = deltax*m_flow_set;
    // min function ensures that dp_y1 does not increase further for m_flow_x > m_flow_x1
    dp_y1 = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                                     m_flow=min(m_flow, m_flow_set + m_flow_x1),
                                     k=kTotMax,
                                     m_flow_turbulent=m_flow_turbulent);
    // max function ensures that dp_y2 does not decrease further for m_flow_x < m_flow_x2
    dp_y2 = dp_min + coeff2*max(m_flow_x, m_flow_x2);

    dp_smooth = noEvent(smooth(2,
        if m_flow_x <= m_flow_x1
        then dp_y1
        elseif m_flow_x >=m_flow_x2
        then dp_y2
        else Buildings.Utilities.Math.Functions.quinticHermite(
                 x=m_flow_x,
                 x1=m_flow_x1,
                 x2=m_flow_x2,
                 y1=dp_y1,
                 y2=dp_y2,
                 y1d=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der(
                                     m_flow=m_flow_set + m_flow_x1,
                                     k=kTotMax,
                                     m_flow_turbulent=m_flow_turbulent,
                                     m_flow_der=1),
                 y2d=coeff2,
                 y1dd=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow_der2(
                                     m_flow=m_flow_set + m_flow_x1,
                                     k=kTotMax,
                                     m_flow_turbulent=m_flow_turbulent,
                                     m_flow_der=1,
                                     m_flow_der2=0),
                 y2dd=y2dd)));
  end if;
  // Computation of damper opening
  kSquInv = basicFlowFunction_dp_m_flow(
    m_flow=m_flow,
    dp=dp,
    m_flow_small=1E-3*abs(m_flow_nominal),
    dp_small=1E-4*dp_nominal_pos);
  kDamSquInv = if dpFixed_nominal > Modelica.Constants.eps then
    kSquInv - 1 / kFixed^2 else kSquInv;
  // Use of regStep might no longer be needed when the leakage flow modeling is updated.
  y_actual_smooth = Buildings.Utilities.Math.Functions.regStep(
    x=y_internal - y_min,
    y1=exponentialDamper_inv(
      kTheta=kDamSquInv*2*rho*A^2, kSupSpl=kSupSpl, ySupSpl=ySupSpl, invSplDer=invSplDer),
    y2=0,
    x_small=1E-3);
  // Homotopy transformation
  if homotopyInitialization then
    if from_dp then
      m_flow=homotopy(actual=m_flow_smooth,
                      simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
    else
      dp=homotopy(actual=dp_smooth,
                  simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
    end if;
    y_actual = homotopy(
      actual=y_actual_smooth,
      simplified=y);
  else
    if from_dp then
      m_flow=m_flow_smooth;
    else
      dp=dp_smooth;
    end if;
    y_actual = y_actual_smooth;
  end if;
annotation (
  defaultComponentName="damPreInd",
  Documentation(info="<html>
<p>
Model for an air damper whose airflow is proportional to the input signal, assuming
that at <code>y = 1</code>, <code>m_flow = m_flow_nominal</code>. This is unless the pressure difference
<code>dp</code> is too low,
in which case a <code>kDam = m_flow_nominal/sqrt(dp_nominal)</code> characteristic is used.
</p>
<p>
The model is similar to
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent\">
Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent</a>,
except for adaptations for damper parameters.
Please see that documentation for more information.
</p>
<h4>Computation of the damper opening</h4>
<p>
The fractional opening of the damper is computed by
</p>
<ul>
<li>
inverting the quadratic flow function to compute the flow coefficient
from the flow rate and the pressure drop values (under the assumption
of a turbulent flow regime);
</li>
<li>
inverting the exponential characteristics to compute the fractional opening
from the loss coefficient value (directly derived from the flow coefficient).
</li>
</ul>
<p>
The quadratic interpolation used outside the exponential domain in the function
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.exponentialDamper\">
Buildings.Fluid.Actuators.BaseClasses.exponentialDamper</a>
yields a local extremum.
Therefore, the formal inversion of the function is not possible.
A cubic spline is used instead to fit the inverse of the damper characteristics.
The central domain of the characteritics having a monotonous exponential profile, its
inverse can be properly approximated with three equidistant support points.
However, the quadratic functions used outside of the exponential domain can have
various profiles depending on the damper coefficients.
Therefore, five linearly distributed support points are used on each side domain to
ensure a good fit of the inverse.
</p>
<p>
Note that below a threshold value of the input control signal (fixed at 0.02),
the fractional opening is forced to zero and no more related to the actual
flow coefficient of the damper.
This avoids steep transients of the computed opening while transitioning from reverse flow.
This is to be considered as a modeling workaround (avoiding the introduction of
an additional state variable) to prevent control chattering during
shut off operation where the pressure difference at the damper boundaries
can vary between slightly positive and negative values due to outdoor pressure
variations.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 11, 2021, by Michael Wetter:<br/>
Reformulated initial equation section to avoid warning in OPTIMICA about
variable array index.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1513\">IBPSA #1513</a>.
</li>
<li>
June 10, 2021, by Michael Wetter:<br/>
Changed implementation of the filter and changed the parameter <code>order</code> to a constant
as most users need not change this value.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1498\">IBPSA #1498</a>.
</li>
<li>
April 6, 2020, by Antoine Gautier:<br/>
Added the computation of the damper opening.
</li>
<li>
December 23, 2019 by Antoine Gautier:<br/>
Refactored as the model can now extend directly
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</a>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1188\">IBPSA #1188</a>.
</li>
<li>
March 21, 2017 by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
   Icon(graphics={Line(
         points={{0,100},{0,-24}}),
        Rectangle(
          extent={{-100,40},{100,-42}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,22},{100,-24}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255})}));
end PressureIndependent;
