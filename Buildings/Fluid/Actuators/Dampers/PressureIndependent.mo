within Buildings.Fluid.Actuators.Dampers;
model PressureIndependent
  "Pressure independent damper"
  extends Buildings.Fluid.Actuators.Dampers.Exponential(
    dp(nominal=dp_nominal),
    final casePreInd=true,
    final linearized=false,
    final from_dp=true,
    final dp_nominalIncludesDamper=true,
    final k1=2 * rho_default * (A / kDam_1)^2,
    final k0=2 * rho_default * (A / kDam_0)^2);
  parameter Modelica.SIunits.PressureDifference dpFixed_nominal(displayUnit="Pa", min=0) = 0
    "Pressure drop of duct and other resistances that are in series"
     annotation(Dialog(group = "Nominal condition"));
  parameter Real l(min=1e-10, max=1, unit="1") = 0.0001
    "Damper leakage, l=k(y=0)/k(y=1)";
  Modelica.Blocks.Interfaces.RealOutput y_actual(unit="1") "Actual damper position"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
protected
  parameter Real y_min = 2E-2
    "Minimum value of control signal before autozeroing the opening.";
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
  parameter Modelica.SIunits.PressureDifference dp_small = 1E-2 * dp_nominal_pos
    "Pressure drop for sizing the transition regions";
  parameter Real c_regul = 1E-2 "Regularization coefficient";
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
  Modelica.SIunits.PressureDifference dp_0
    "Pressure drop at required flow rate with damper fully closed";
  Modelica.SIunits.PressureDifference dp_1
    "Pressure drop at required flow rate with damper fully open";
initial equation
  kResSqu=if dpFixed_nominal > Modelica.Constants.eps then
    m_flow_nominal^2 / dpFixed_nominal else 0
    "Flow coefficient of fixed resistance in series with damper, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  (kSupSpl, idx_sorted) = Modelica.Math.Vectors.sort(kSupSpl_raw, ascending=true);
  ySupSpl = ySupSpl_raw[idx_sorted];
  invSplDer = Buildings.Utilities.Math.Functions.splineDerivatives(x=kSupSpl, y=ySupSpl);
equation
  dp_0 = max(dp_1 + 2 * dp_small,
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
      m_flow=y_internal * m_flow_nominal * (1 + c_regul),
      k=kTot_0,
      m_flow_turbulent=m_flow_turbulent));
  dp_1 = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
    m_flow=y_internal * m_flow_nominal,
    k=kTot_1,
    m_flow_turbulent=m_flow_turbulent);
  m_flow = smooth(2, noEvent(
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
        y2=y_internal * m_flow_nominal * (1 + c_regul * (dp - dp_1) / (dp_0 - dp_1)),
        y1d=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der(
          dp=dp_1,
          k=kTot_1,
          m_flow_turbulent=m_flow_turbulent,
          dp_der=1),
        y2d=y_internal * m_flow_nominal * c_regul,
        y1dd=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2(
          dp=dp_1,
          k=kTot_1,
          m_flow_turbulent=m_flow_turbulent,
          dp_der=1,
          dp_der2=0),
        y2dd=0)
    elseif dp < dp_0 - dp_small then
      y_internal * m_flow_nominal * (1 + c_regul * (dp - dp_1) / (dp_0 - dp_1))
    elseif dp < dp_0 then
      Buildings.Utilities.Math.Functions.quinticHermite(
        x=dp,
        x1=dp_0 - dp_small,
        x2=dp_0,
        y1=y_internal * m_flow_nominal * (1 + c_regul * (dp - dp_1) / (dp_0 - dp_1)),
        y2=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
          dp=dp_0,
          k=kTot_0,
          m_flow_turbulent=m_flow_turbulent),
        y1d=y_internal * m_flow_nominal * c_regul,
        y2d=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der(
          dp=dp_0,
          k=kTot_0,
          m_flow_turbulent=m_flow_turbulent,
          dp_der=1),
        y1dd=0,
        y2dd=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2(
          dp=dp_0,
          k=kTot_0,
          m_flow_turbulent=m_flow_turbulent,
          dp_der=1,
          dp_der2=0))
    else
      Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
        dp=dp,
        k=kTot_0,
        m_flow_turbulent=m_flow_turbulent)));
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
  y_actual = Buildings.Utilities.Math.Functions.regStep(
    x=y_internal - y_min,
    y1=Buildings.Fluid.Actuators.BaseClasses.exponentialDamper_inv(
      kThetaSqRt=sqrt(kThetaDam), kSupSpl=kSupSpl, ySupSpl=ySupSpl, invSplDer=invSplDer),
    y2=0,
    x_small=1E-3
  );
annotation (
defaultComponentName="preInd",
Documentation(info="<html>
<p>
Model for an air damper whose airflow is proportional to the input signal, assuming
that at <code>y = 1</code>, <code>m_flow = m_flow_nominal</code>. This is unless:
<ul>
<li>
the pressure difference <code>dp</code> is too low, in which case the flow rate is computed
under the assumption of a fully open damper with exponential flow characteristics;
</li>
<li>
the pressure difference <code>dp</code> is too high, in which case the flow rate is computed
under the assumption of a fully closed damper with exponential flow characteristics.
</li>
</p>
<p>
Eventually the fractional opening of the damper is computed under the assumption of an
exponential flow characteristics.
</p>
<p>
The model is similar to
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent\">
Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent</a>, except for adaptations for damper parameters.
Please see that documentation for more information.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Actuators/Dampers/PressureIndependent.svg\"/>
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
