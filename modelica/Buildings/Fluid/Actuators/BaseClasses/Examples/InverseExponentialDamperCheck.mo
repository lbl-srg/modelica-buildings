within Buildings.Fluid.Actuators.BaseClasses.Examples;
model InverseExponentialDamperCheck
  "Test model to check implementation of inverse functions"
  extends Modelica.Icons.Example;
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
 parameter Real[3] cL=
    {(Modelica.Math.log(k0) - b - a)/yL^2,
      (-b*yL - 2*Modelica.Math.log(k0) + 2*b + 2*a)/yL,
      Modelica.Math.log(k0)} "Polynomial coefficients for curve fit for y < yl";
 parameter Real[3] cU=
    {(Modelica.Math.log(k1) - a)/(yU^2 - 2*yU + 1),
    (-b*yU^2 - 2*Modelica.Math.log(k1)*yU - (-2*b - 2*a)*yU - b)/(yU^2 - 2*yU + 1),
    (Modelica.Math.log(k1)*yU^2 + b*yU^2 + (-2*b - 2*a)*yU + b + a)/(yU^2 - 2*yU + 1)}
    "Polynomial coefficients for curve fit for y > yu";

  parameter Modelica.SIunits.Density rho=1.2 "Mass density";
  parameter Boolean linearized=false "Linearize flow vs. pressure relationship";

  Modelica.SIunits.Pressure dp1 "Pressure drop";
  Modelica.SIunits.Pressure dp2 "Pressure drop";
  Modelica.SIunits.Pressure dp3 "Pressure drop";

  Modelica.SIunits.Pressure dp1_new "Pressure drop";

  Modelica.SIunits.MassFlowRate m1_flow "Mass flow rate";
  Modelica.SIunits.MassFlowRate m2_flow "Mass flow rate";
  Modelica.SIunits.MassFlowRate m3_flow "Mass flow rate";
  Modelica.SIunits.MassFlowRate m2_flow_new "Mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m_flow_turbulent = 0.02;

  constant Real conv1(unit="Pa/s") = 1;
  constant Real conv2(unit="kg/s2") = 1;
equation
  dp1=time*conv1;
  dp1=Buildings.Fluid.Actuators.BaseClasses.exponentialDamper_m_flow(
    m_flow=m1_flow, m_flow_turbulent=m_flow_turbulent, linearized=linearized, y=0.5,
    a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU, kFixed=2, rho=rho, A=0.1);
  dp1_new=Buildings.Fluid.Actuators.BaseClasses.exponentialDamper_m_flow(
    m_flow=m1_flow, m_flow_turbulent=m_flow_turbulent, linearized=linearized, y=0.5,
    a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU, kFixed=2, rho=rho, A=0.1);

  m2_flow=time*conv2;
  m2_flow=Buildings.Fluid.Actuators.BaseClasses.exponentialDamper_dp(
    dp=dp2,m_flow_turbulent=m_flow_turbulent, linearized=linearized, y=0.5,
    a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU, kFixed=2, rho=rho, A=0.1);
  m2_flow_new=Buildings.Fluid.Actuators.BaseClasses.exponentialDamper_dp(
    dp=dp2,m_flow_turbulent=m_flow_turbulent, linearized=linearized, y=0.5,
    a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU, kFixed=2, rho=rho, A=0.1);

  dp3=Buildings.Fluid.Actuators.BaseClasses.exponentialDamper_m_flow(
    m_flow=m2_flow, m_flow_turbulent=m_flow_turbulent, linearized=linearized, y=0.5,
    a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU, kFixed=2, rho=rho, A=0.1);
  m3_flow=Buildings.Fluid.Actuators.BaseClasses.exponentialDamper_dp(
    dp=dp3,m_flow_turbulent=m_flow_turbulent, linearized=linearized, y=0.5,
    a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU, kFixed=2, rho=rho, A=0.1);

  assert(abs(m2_flow-m2_flow_new) < 1E-2, "Model has an error");
  assert(abs(m2_flow-m3_flow) < 1E-2, "Model has an error");
 annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                    graphics),
                     __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Actuators/BaseClasses/Examples/InverseExponentialDamperCheck.mos" "Simulate and plot"),
    Documentation(info="<html>
<p>
This example checks whether the inverse function
is implemented correctly. 
After the symbolic manipulation, there should be no nonlinear
equation that needs to be solved numerically.
The model checks if symbolically
inverting the function by replacing it with the implementation of
its inverse and evaluating the function with the result of the
inverse function gives identical results.
If this is not the case, the model will stop with 
an assert statement.
</p>
</html>", revisions="<html>
<ul>
<li>
April 4, 2011 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end InverseExponentialDamperCheck;
