within Buildings.Fluid.Actuators.BaseClasses;
partial model PartialDamperExponential
  "Partial model for air dampers with exponential opening characteristics"
   extends Buildings.Fluid.BaseClasses.PartialResistance(
      m_flow_turbulent=if use_deltaM then deltaM * m_flow_nominal else
      eta_default*ReC*sqrt(A)*facRouDuc);
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
 parameter Real a(unit="")=-1.51 "Coefficient a for damper characteristics"
  annotation(Dialog(tab="Damper coefficients"));
 parameter Real b(unit="")=0.105*90 "Coefficient b for damper characteristics"
  annotation(Dialog(tab="Damper coefficients"));
 parameter Real yL = 15/90 "Lower value for damper curve"
  annotation(Dialog(tab="Damper coefficients"));
 parameter Real yU = 55/90 "Upper value for damper curve"
  annotation(Dialog(tab="Damper coefficients"));
 parameter Real k0(min=0) = 1E6
    "Flow coefficient for y=0, k0 = pressure drop divided by dynamic pressure"
  annotation(Dialog(tab="Damper coefficients"));
 parameter Real k1(min=0) = 0.45
    "Flow coefficient for y=1, k1 = pressure drop divided by dynamic pressure"
  annotation(Dialog(tab="Damper coefficients"));
 parameter Boolean use_constant_density=true
    "Set to true to use constant density for flow friction"
   annotation (Evaluate=true, Dialog(tab="Advanced"));
 Medium.Density rho "Medium density";
 parameter Real kFixed(unit="")
    "Flow coefficient of fixed resistance that may be in series with damper, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2).";
 Real kDam(unit="")
    "Flow coefficient of damper, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
 Real k(unit="")
    "Flow coefficient of damper plus fixed resistance, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)";
protected
 parameter Medium.Density rho_default=Medium.density(sta_default)
    "Density, used to compute fluid volume";
 parameter Real[3] cL=
    {(Modelica.Math.log(k0) - b - a)/yL^2,
      (-b*yL - 2*Modelica.Math.log(k0) + 2*b + 2*a)/yL,
      Modelica.Math.log(k0)} "Polynomial coefficients for curve fit for y < yl";
 parameter Real[3] cU=
    {(Modelica.Math.log(k1) - a)/(yU^2 - 2*yU + 1),
    (-b*yU^2 - 2*Modelica.Math.log(k1)*yU - (-2*b - 2*a)*yU - b)/(yU^2 - 2*yU + 1),
    (Modelica.Math.log(k1)*yU^2 + b*yU^2 + (-2*b - 2*a)*yU + b + a)/(yU^2 - 2*yU + 1)}
    "Polynomial coefficients for curve fit for y > yu";
 parameter Real facRouDuc= if roundDuct then sqrt(Modelica.Constants.pi)/2 else 1;
initial equation
  assert(k0 > k1, "k0 must be between k1 and 1e6.");
  assert(m_flow_turbulent > 0, "m_flow_turbulent must be bigger than zero.");
  assert(k1 >= 0.2, "k1 must be between 0.2 and 0.5.");
  assert(k1 <= 0.5, "k1 must be between 0.2 and 0.5.");
  assert(k0 <= 1e6, "k0 must be between k1 and 1e6.");
equation
  rho = if use_constant_density then
          rho_default
        else
          Medium.density(Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow)));
  // flow coefficient, k=m_flow/sqrt(dp)
  kDam=sqrt(2*rho)*A/Buildings.Fluid.Actuators.BaseClasses.exponentialDamper(
    y=y_actual,
    a=a,
    b=b,
    cL=cL,
    cU=cU,
    yL=yL,
    yU=yU);
  k = if (kFixed>Modelica.Constants.eps) then sqrt(1/(1/kFixed^2 + 1/kDam^2)) else kDam;
  // Pressure drop calculation
  if linearized then
    m_flow*m_flow_nominal_pos = k^2*dp;
  else
    if homotopyInitialization then
      if from_dp then
        m_flow=homotopy(
           actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                  dp=dp, k=k,
                  m_flow_turbulent=m_flow_turbulent),
           simplified=m_flow_nominal_pos*dp/dp_nominal_pos);
      else
        dp=homotopy(
           actual=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                  m_flow=m_flow, k=k,
                  m_flow_turbulent=m_flow_turbulent),
           simplified=dp_nominal_pos*m_flow/m_flow_nominal_pos);
       end if;  // from_dp
    else // do not use homotopy
      if from_dp then
        m_flow=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_dp(
                 dp=dp, k=k, m_flow_turbulent=m_flow_turbulent);
      else
        dp=Buildings.Fluid.BaseClasses.FlowModels.basicFlowFunction_m_flow(
                 m_flow=m_flow, k=k, m_flow_turbulent=m_flow_turbulent);
      end if;  // from_dp
    end if; // homotopyInitialization
  end if; // linearized
annotation(Documentation(info="<html>
<p>
Partial model for air dampers with exponential opening characteristics.
This is the base model for air dampers and variable air volume flow boxes.
The model implements the functions that relate the opening signal,
the pressure drop and the mass flow rate.
The model also defines parameters that are used by different air damper
models.
</p>
<p>
For a description of the opening characteristics and typical parameter values, see the damper model
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.Exponential\">
Buildings.Fluid.Actuators.Dampers.Exponential</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 22, 2017, by Michael Wetter:<br/>
Added back <code>v_nominal</code>, but set the assignment of <code>A</code>
to be final. This allows scaling the model with <code>m_flow_nominal</code>,
which is generally known in the flow leg,
and <code>v_nominal</code>, for which a default value can be specified.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/544\">#544</a>.
</li>
<li>
October 12, 2016 by David Blum:<br/>
Removed parameter <code>v_nominal</code> and variable <code>area</code>,
to simplify parameterization of the model.
Also added assertion statements upon initialization
for parameters <code>k0</code> and <code>k1</code> so that they fall within
suggested ranges found in ASHRAE 825-RP. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/544\">#544</a>.
</li>
<li>
January 27, 2015 by Michael Wetter:<br/>
Set <code>Evaluate=true</code> for <code>use_constant_density</code>.
This is a structural parameter. Adding this annotation leads to fewer
numerical Jacobians for
<code>Buildings.Examples.VAVReheat.ClosedLoop</code>
with
<code>Buildings.Media.PerfectGases.MoistAirUnsaturated</code>.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li>
January 16, 2012 by Michael Wetter:<br/>
To simplify object inheritance tree, revised base classes
<code>Buildings.Fluid.BaseClasses.PartialResistance</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValve</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialDamperExponential</code>,
<code>Buildings.Fluid.Actuators.BaseClasses.PartialActuator</code>
and model
<code>Buildings.Fluid.FixedResistances.PressureDrop</code>.
</li>
<li>
August 5, 2011, by Michael Wetter:<br/>
Moved linearized pressure drop equation from the function body to the equation
section. With the previous implementation,
the symbolic processor may not rearrange the equations, which can lead
to coupled equations instead of an explicit solution.
</li>
<li>
June 22, 2008 by Michael Wetter:<br/>
Extended range of control signal from 0 to 1 by implementing the function
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.exponentialDamper\">
exponentialDamper</a>.
</li>
<li>
June 10, 2008 by Michael Wetter:<br/>
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
end PartialDamperExponential;
