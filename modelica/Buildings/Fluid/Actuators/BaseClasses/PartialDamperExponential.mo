within Buildings.Fluid.Actuators.BaseClasses;
partial model PartialDamperExponential
  "Partial model for air dampers with exponential opening characteristics"
  extends PartialActuator;

  parameter Boolean use_deltaM = true
    "Set to true to use deltaM for turbulent transition, else ReC is used";
  parameter Real deltaM = 0.3
    "Fraction of nominal mass flow rate where transition to turbulent occurs"
    annotation(Dialog(enable=use_deltaM));
  parameter Boolean use_v_nominal = true
    "Set to true to use face velocity to compute area";
  parameter Modelica.SIunits.Velocity v_nominal=1 "Nominal face velocity"
    annotation(Dialog(enable=use_v_nominal));
  parameter Modelica.SIunits.Area A=m_flow_nominal/rho_nominal/v_nominal
    "Face area"
    annotation(Dialog(enable=not use_v_nominal));

  parameter Boolean roundDuct = false
    "Set to true for round duct, false for square cross section"
    annotation(Dialog(enable=not use_deltaM));
  parameter Real ReC=4000
    "Reynolds number where transition to turbulent starts"
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
  Real kDam(start=1) "Flow coefficient for damper, kDam=m_flow/sqrt(dp)";

  parameter Boolean use_constant_density=true
    "Set to true to use constant density for flow friction"
    annotation (Dialog(tab="Advanced"));
  Medium.Density rho "Medium density";
protected
  parameter Medium.Density rho_nominal=Medium.density(sta0)
    "Density, used to compute fluid volume";

  Real kThetaSqRt(min=0)
    "Flow coefficient, kThetaSqRt = sqrt(pressure drop/dynamic pressure)";
  parameter Real[3] cL(fixed=false)
    "Polynomial coefficients for curve fit for y < yl";
  parameter Real[3] cU(fixed=false)
    "Polynomial coefficients for curve fit for y > yu";

protected
  parameter Real facRouDuc= if roundDuct then sqrt(Modelica.Constants.pi)/2 else 1;
  parameter Modelica.SIunits.Area area=
     if use_v_nominal then m_flow_nominal/rho_nominal/v_nominal else A
    "Face velocity used in the computation";
initial equation
 cL[1] = (Modelica.Math.log(k0) - b - a)/yL^2;
 cL[2] = (-b*yL - 2*Modelica.Math.log(k0) + 2*b + 2*a)/yL;
 cL[3] = Modelica.Math.log(k0);

 cU[1] = (Modelica.Math.log(k1) - a)/(yU^2 - 2*yU + 1);
 cU[2] = (-b*yU^2 - 2*Modelica.Math.log(k1)*yU - (-2*b - 2*a)*yU - b)/(yU^2 - 2*yU + 1);
 cU[3] = (Modelica.Math.log(k1)*yU^2 + b*yU^2 + (-2*b - 2*a)*yU + b + a)/(yU^2 - 2*yU + 1);
 assert(k0 > k1, "k0 must be bigger than k1.");
equation
   rho = if use_constant_density then
          rho_nominal else
          Medium.density(Medium.setState_phX(port_a.p, inStream(port_a.h_outflow), inStream(port_a.Xi_outflow)));
   m_flow_turbulent=if use_deltaM then deltaM * m_flow_nominal else
       eta_nominal*ReC*sqrt(area)*facRouDuc;
   kThetaSqRt = exponentialDamper(y=y, a=a, b=b, cL=cL, cU=cU, yL=yL, yU=yU)
    "y=0 is closed";
   kDam*kThetaSqRt = sqrt(2*rho) * area
    "flow coefficient for resistance base model, k=m_flow/sqrt(dp)";

 annotation(Documentation(info="<html>
<p>
Partial model for air dampers with exponential opening characteristics. 
This is the base model for air dampers.
The model defines the flow rate where the linearization near the origin occurs. 
The model also defines parameters that are used by different air damper
models.
</p><p>
This model does not assign <tt>k=kDam</tt> because the model
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.VAVBoxExponential\">
VAVBoxExponential</a> consists of a fixed resistance and a resistance due to the
air damper. If <tt>k</tt> would be assigned here, then this partial model could not
be used as a base class for 
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.VAVBoxExponential\">
VAVBoxExponential</a>.
</p>
<p>
For a description of the opening characteristics and typical parameter values, see the damper model
<a href=\"modelica://Buildings.Fluid.Actuators.Dampers.Exponential\">
Exponential</a>.
 
</p>
</html>", revisions="<html>
<ul>
Reformulated implementation of
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.exponentialDamper\">
Buildings.Fluid.Actuators.BaseClasses.exponentialDamper</a>.
The new implementation computes
<code>sqrt(kTheta)</code>. This avoid having <code>kTheta</code> in
the iteration variables, which caused warnings when the solver attempted
<code>kTheta &lt; 0</code>.
<li>
February 11, 2010 by Michael Wetter:<br>
Added default value for parameter <code>A</code> to avoid compilation error
if the parameter is disabled but not specified.
</li>
<li>
March 23, 2009 by Michael Wetter:<br>
Added option to specify <tt>deltaM</tt> for smoothing.
This is the default setting, as it most reliably leads to a 
derivative <tt>dm/dp</tt> that is not too steep for the solver
near the origin.
</li>
<li>
July 20, 2007 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
revisions="<html>
<ul>
<li>
June 22, 2008 by Michael Wetter:<br>
Extended range of control signal from 0 to 1 by implementing the function 
<a href=\"modelica://Buildings.Fluid.Actuators.BaseClasses.exponentialDamper\">
exponentialDamper</a>.
</li>
<li>
June 10, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>",
    Icon(graphics={Line(
          points={{0,100},{0,-24}},
          color={0,0,0},
          smooth=Smooth.None)}),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Polygon(
          points={{-20,4},{4,50},{16,50},{-8,4},{-20,4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid), Polygon(
          points={{-22,-46},{2,0},{14,0},{-10,-46},{-22,-46}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end PartialDamperExponential;
