within Buildings.Fluid.Actuators.Dampers;
model PressureIndependent
  "Model for an air damper whose mass flow is proportional to the input signal"
  extends Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential(
    final linearized=false,
    from_dp=true);
  input Real phi = l + y_actual*(1 - l)
    "Ratio actual to nominal mass flow rate of damper, phi=kDam(y)/kDam(y=1)";
  parameter Real l2(unit="1", min=1e-10) = 0.01
    "Gain for mass flow increase if pressure is above nominal pressure"
    annotation(Dialog(tab="Advanced"));
  parameter Real deltax(unit="1", min=1E-5) = 0.02 "Transition interval for flow rate"
    annotation(Dialog(tab="Advanced"));
protected
  parameter Real coeff1 = l2/dpDamper_nominal*m_flow_nominal
    "Parameter for avoiding unnecessary computations";
  parameter Real coeff2 = 1/coeff1
    "Parameter for avoiding unnecessary computations";
  constant Real y2dd = 0
    "Second derivative at second support point";
  Modelica.SIunits.MassFlowRate m_flow_set
    "Requested mass flow rate";
  Modelica.SIunits.PressureDifference dp_min(displayUnit="Pa")
    "Minimum pressure difference required for delivering requested mass flow rate";
  Modelica.SIunits.PressureDifference dp_x, dp_x1, dp_x2, dp_y2, dp_y1
    "Support points for interpolation flow functions";
  Modelica.SIunits.MassFlowRate m_flow_x, m_flow_x1, m_flow_x2, m_flow_y2, m_flow_y1
    "Support points for interpolation flow functions";
  Modelica.SIunits.MassFlowRate m_flow_smooth
    "Smooth interpolation result between two flow regimes";
  Modelica.SIunits.PressureDifference dp_smooth
    "Smooth interpolation result between two flow regimes";
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


  if homotopyInitialization then
    if from_dp then
      m_flow=homotopy(actual=m_flow_smooth,
                      simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
    else
      dp=homotopy(actual=dp_smooth,
                  simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
    end if;
  else
    if from_dp then
      m_flow=m_flow_smooth;
    else
      dp=dp_smooth;
    end if;
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
Buildings.Fluid.Actuators.Valves.TwoWayPressureIndependent</a>, except for adaptations for damper parameters.
Please see that documentation for more information.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 23, 2019 by Antoine Gautier:<br/>
Refactored as the model can now extend directly 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential\">
Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</a>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1188\">#1188</a>.
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
