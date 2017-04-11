within Buildings.Fluid.Actuators.Dampers;
model PressureIndependent
  "Model for an air damper whose mass flow is proportional to the input signal"
  extends Buildings.Fluid.BaseClasses.PartialResistance(
    m_flow_turbulent=if use_deltaM then deltaM * m_flow_nominal else
    eta_default*ReC*sqrt(A)*facRouDuc,
    final linearized = false,
    from_dp=true);
  extends Buildings.Fluid.Actuators.BaseClasses.ActuatorSignal;
  parameter Boolean use_deltaM = true
    "Set to true to use deltaM for turbulent transition, else ReC is used";
  parameter Real deltaM = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
   annotation(Dialog(enable=use_deltaM));
  parameter Modelica.SIunits.Velocity v_nominal = 1 "Nominal face velocity";
  final parameter Modelica.SIunits.Area A=m_flow_nominal/rho_default/v_nominal
    "Face area";

  parameter Boolean roundDuct = false
    "Set to true for round duct, false for square cross section"
   annotation(Dialog(enable=not use_deltaM));
  parameter Real ReC=4000 "Reynolds number where transition to turbulent starts"
   annotation(Dialog(enable=not use_deltaM));
  parameter Boolean use_constant_density=true
    "Set to true to use constant density for flow friction"
   annotation (Evaluate=true, Dialog(tab="Advanced"));
  parameter Modelica.SIunits.PressureDifference dpFixed_nominal(displayUnit="Pa", min=0) = 0
    "Pressure drop of duct and other resistances that are in series"
     annotation(Dialog(group = "Nominal condition"));
  parameter Real l(min=1e-10, max=1) = 0.0001
    "Damper leakage, l=kDam(y=0)/kDam(y=1)"
    annotation(Dialog(tab="Advanced"));
  input Real phi = l + y_actual*(1 - l)
    "Ratio actual to nominal mass flow rate of damper, phi=kDam(y)/kDam(y=1)";
  parameter Real l2(unit="1", min=1e-10) = 0.01
    "Gain for mass flow increase if pressure is above nominal pressure"
    annotation(Dialog(tab="Advanced"));
  parameter Real deltax = 0.1 "Transition interval for flow rate"
    annotation(Dialog(tab="Advanced"));
  Medium.Density rho "Medium density";
protected
  parameter Medium.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";
  parameter Real facRouDuc= if roundDuct then sqrt(Modelica.Constants.pi)/2 else 1;
  parameter Real kDam(unit="") = m_flow_nominal/sqrt(dp_nominal_pos)
    "Flow coefficient of damper, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  parameter Real kFixed(unit="") = if dpFixed_nominal > Modelica.Constants.eps
    then m_flow_nominal / sqrt(dpFixed_nominal) else 0
    "Flow coefficient of fixed resistance in series with damper, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
  parameter Real k = if (dpFixed_nominal > Modelica.Constants.eps) then sqrt(1/(1/kFixed^2 + 1/kDam^2)) else kDam
    "Flow coefficient of damper plus fixed resistance";
  parameter Real kLin = l2*m_flow_nominal/dp_nominal
    "Linear k value times l2, used to avoid duplicate computations";
  parameter Real kLinInv = 1/kLin
    "Inverse of linear k value times l2, used to avoid duplicate computations";
  Modelica.SIunits.MassFlowRate m_flow_set "Requested mass flow rate";
  Modelica.SIunits.PressureDifference dp_min(displayUnit="Pa")
    "Minimum pressure difference required for delivering requested mass flow rate";
initial equation
  assert(m_flow_turbulent > 0, "m_flow_turbulent must be bigger than zero.");
equation
  rho = if use_constant_density then
          rho_default
        else
          Medium.density(Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow)));
  // From TwoWayPressureIndependent valve model
  m_flow_set = m_flow_nominal*phi;
  dp_min = Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
              m_flow=m_flow_set,
              k=k,
              m_flow_turbulent=m_flow_turbulent);
  if homotopyInitialization then
   if from_dp then
       m_flow=homotopy(actual=Buildings.Utilities.Math.Functions.regStep(
                          x=dp-dp_min,
                          y1= m_flow_set + (dp-dp_min)*kLin,
                          y2= Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                                dp=dp,
                                k=k,
                                m_flow_turbulent=m_flow_turbulent),
                          x_small=dp_nominal_pos*deltax),
                       simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
   else
       dp=homotopy(actual=Buildings.Utilities.Math.Functions.regStep(
                          x=m_flow-m_flow_set,
                          y1= dp_min + (m_flow-m_flow_set)*kLinInv,
                          y2= Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                                m_flow=m_flow,
                                k=k,
                                m_flow_turbulent=m_flow_turbulent),
                          x_small=m_flow_nominal_pos*deltax*l2),
                   simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
   end if;
  else // do not use homotopy
   if from_dp then
     m_flow=Buildings.Utilities.Math.Functions.regStep(
                          x=dp-dp_min,
                          y1= m_flow_set + (dp-dp_min)*kLin,
                          y2= Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                                dp=dp,
                                k=k,
                                m_flow_turbulent=m_flow_turbulent),
                          x_small=dp_nominal_pos*deltax);
    else
      dp=Buildings.Utilities.Math.Functions.regStep(
                          x=m_flow-m_flow_set,
                          y1= dp_min + (m_flow-m_flow_set)*kLinInv,
                          y2= Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                                m_flow=m_flow,
                                k=k,
                                m_flow_turbulent=m_flow_turbulent),
                          x_small=m_flow_nominal_pos*deltax*l2);
    end if;
  end if; // homotopyInitialization
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
