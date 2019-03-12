within Buildings.Fluid.Actuators.Dampers;
model PressureIndependent
  "Pressure independent damper"
  // TODO:
  //  Guard for multiple solution from roots
  //  Allow flow reversal when computing kThetaSqRt
  //  Relax limits for k0 & k1 in PartialDamperExponential based on ASHRAE Dampers and Airflow Control
  // HACK:
  //  l(min=1e-10, max=1) = 0.001
  //  v_nominal=3
  //  assert(k1 <= 5, "k1 must be between 0.2 and 0.5.");
  //  assert(k0 <= 1e8, "k0 must be between k1 and 1e6.");
  //
  // kResSqu >= 0
  extends Buildings.Fluid.Actuators.Dampers.VAVBoxExponential(
    dp(nominal=dp_nominal),
    final preInd=true,
    final linearized=false,
    final from_dp=true,
    final dp_nominalIncludesDamper=true,
    final k1=2 * rho_default * (A / kDam_1)^2,
    final k0=2 * rho_default * (A / kDam_0)^2,
    v_nominal=3);
  parameter Modelica.SIunits.PressureDifference dpFixed_nominal(displayUnit="Pa", min=0) = 0
    "Pressure drop of duct and other resistances that are in series"
     annotation(Dialog(group = "Nominal condition"));
  parameter Real l(min=1e-10, max=1) = 0.001
    "Damper leakage, l=k(y=0)/k(y=1)";
  Modelica.Blocks.Interfaces.RealOutput y_open "Fractional damper opening"
    annotation (Placement(transformation(extent={{40,90},{60,110}}),
        iconTransformation(extent={{40,90},{60,110}})));
  Medium.Density rho "Medium density";
  Real test_kthsqrt;
  Real[4] test_char_inv;
  Real[4] y_dum;
  Real[2, 2] roots;
protected
  parameter Medium.Density rho_default = Medium.density(sta_default)
    "Density, used to compute fluid volume";
  parameter Real facRouDuc = if roundDuct then sqrt(Modelica.Constants.pi) / 2 else 1;
  parameter Real kDam_1 = m_flow_nominal / sqrt(dp_nominal_pos)
    "Flow coefficient of damper fully open, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  // parameter Real kFixed=if dpFixed_nominal > Modelica.Constants.eps then
  //   m_flow_nominal / sqrt(dpFixed_nominal) else 0
  //   "Flow coefficient of fixed resistance in series with damper, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  parameter Real kTot_1 = if dpFixed_nominal > Modelica.Constants.eps then
    sqrt(1 / (1 / kResSqu + 1 / kDam_1^2)) else kDam_1
    "Flow coefficient of damper fully open plus fixed resistance";
  parameter Real kDam_0 = l * kDam_1 "Flow coefficient of damper fully closed in metric unit (kg.m)^(1/2)";
  parameter Real kTot_0 = if dpFixed_nominal > Modelica.Constants.eps then
    sqrt(1 / (1 / kResSqu + 1 / kDam_0^2)) else kDam_0
    "Flow coefficient of damper fully closed + fixed resistance in metric unit (kg.m)^(1/2)";
  Real kThetaSqRt "Square root of damper loss coefficient, with unit (-)";
  Modelica.SIunits.MassFlowRate m_flow_lin;
  Modelica.SIunits.PressureDifference dp_0;
  Modelica.SIunits.PressureDifference dp_1;
  parameter Modelica.SIunits.PressureDifference dp_small = 1E-4 * dp_nominal_pos;
  parameter Real c_regul = 1E-4 * m_flow_nominal_pos / dp_nominal_pos
    "Regularization coefficient";
  Modelica.SIunits.PressureDifference dpDam
    "Pressure drop at damper boundaries, excluding fixed resistance";
initial equation
  kResSqu=if dpFixed_nominal > Modelica.Constants.eps then
    m_flow_nominal^2 / dpFixed_nominal else 0
    "Flow coefficient of fixed resistance in series with damper, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
equation
  m_flow_lin = y_actual * m_flow_nominal;
  dp_0 = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
    m_flow=m_flow_lin,
    k=kTot_0,
    m_flow_turbulent=m_flow_turbulent);
  dp_1 = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
    m_flow=m_flow_lin,
    k=kTot_1,
    m_flow_turbulent=m_flow_turbulent);
  m_flow = smooth(2, noEvent(
    if dp <= dp_1 then
    // damper fully open (covers also dp <= 0 i.e. flow reversal or zero pressure drop)
      Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
      dp=dp,
      k=kTot_1,
      m_flow_turbulent=m_flow_turbulent)
    elseif dp <= dp_1 + dp_small then
    // transition towards m_flow_lin
    Buildings.Utilities.Math.Functions.quinticHermite(
      x=dp,
      x1=dp_1 - dp_small,
      x2=dp_1,
      y1=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
        dp=dp_1 - dp_small,
        k=kTot_1,
        m_flow_turbulent=m_flow_turbulent),
      y2=m_flow_lin + c_regul * dp,
      y1d=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der(
        dp=dp_1 - dp_small,
        k=kTot_1,
        m_flow_turbulent=m_flow_turbulent,
        dp_der=1),
      y2d=c_regul,
      y1dd=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp_der2(
        dp=dp_1 - dp_small,
        k=kTot_1,
        m_flow_turbulent=m_flow_turbulent,
        dp_der=1,
        dp_der2=0),
      y2dd=0)
    elseif dp < dp_0 - dp_small then
    // damper controlling flow rate
    m_flow_lin + c_regul * dp elseif dp < dp_0 then
    // transition towards leakage (damper fully closed)
    Buildings.Utilities.Math.Functions.quinticHermite(
      x=dp,
      x1=dp_0 - dp_small,
      x2=dp_0,
      y1=m_flow_lin + c_regul * dp,
      y2=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
        dp=dp_0,
        k=kTot_0,
        m_flow_turbulent=m_flow_turbulent),
      y1d=c_regul,
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
    // leakage (damper fully closed)
    Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
      dp=dp,
      k=kTot_0,
      m_flow_turbulent=m_flow_turbulent)
  ));
  // Computation of damper opening
  dpDam = if dpFixed_nominal > Modelica.Constants.eps then
    dp - Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
      m_flow=m_flow,
      k=sqrt(kResSqu),
      m_flow_turbulent=m_flow_turbulent) else dp;
  // kThetaSqRt = noEvent(
  //   if dp <= dp_1 then sqrt(k1)  // covers also dp <= 0 i.e. flow reversal or zero pressure drop
  //   elseif dp >= dp_0 then sqrt(k0)  // covers also zero demand (y = 0 implies dp_0 = 0)
  //   else sqrt(2 * rho) * A / Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_inv(
  //   m_flow=m_flow, dp=dpDam, m_flow_turbulent=m_flow_turbulent)
  // );
  kThetaSqRt = sqrt(2 * rho) * A / Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_inv(
    m_flow=m_flow, dp=dpDam, m_flow_turbulent=m_flow_turbulent, m_flow_small=m_flow_small, dp_small=dp_small
  );

  test_kthsqrt = Buildings.Fluid.Actuators.BaseClasses.exponentialDamper(
      y=y_actual, a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU);

  (test_char_inv[1], test_char_inv[2], test_char_inv[3], test_char_inv[4]) =
    Buildings.Fluid.Actuators.BaseClasses.exponentialDamper_inv(
      kThetaSqRt=test_kthsqrt, a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU);

  roots = Modelica.Math.Vectors.Utilities.roots({cU[1], cU[2],
      -2*Modelica.Math.log(test_kthsqrt) + cU[3]});

  (y_dum[1], y_dum[2], y_dum[3], y_dum[4]) = Buildings.Fluid.Actuators.BaseClasses.exponentialDamper_inv(
    kThetaSqRt=kThetaSqRt, a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU);

  y_open = Buildings.Utilities.Math.Functions.regStep(
    x=dp - dp_1,  // covers also dp <= 0 i.e. flow reversal or zero pressure drop)
    y1=Buildings.Utilities.Math.Functions.regStep(
      x=dp - dp_0,  // covers also zero demand (y = 0 implies dp_0 = 0)
      y1=0,
      y2=y_dum[1]
    ),
    y2=1,
    x_small=dp_small
  );

  // y_open = y_dum[1];

annotation(Documentation(info="<html>
<p>
Model for an air damper whose airflow is proportional to the input signal, assuming
that at <code>y = 1</code>, <code>m_flow = m_flow_nominal</code>. This is unless the pressure difference
<code>dp</code> is too low,
in which case a <code>kDam = m_flow_nominal/sqrt(dp_nominal)</code> characteristic is used.
</p>
<p>
The model is similar to
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent\">
Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent</a>, except for adaptations for damper parameters.
Please see that documentation for more information.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 21, 2017 by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"), Icon(graphics={
        Line(
          points={{0,100},{40,100}})}));
end PressureIndependent;
