within Buildings.Fluid.Movers.BaseClasses;
package Characteristics "Functions for fan or pump characteristics"

  annotation (Documentation(info="<html>
<p>This package is similar to <a href=\"Modelica:Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics\">
Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics</a>, 
but instead of head in meters H20, total pressure in Pascal is used. 
This makes the models applicable for fans as well since the flow models from Modelica.Fluid use the 
density of the medium model, such as the density of air instead of water, 
to convert head to pressure.</p>
<p>This package also contains higher order functions for power consumption and efficiency.</p>
</html>",
revisions="<html>
<ul>
<li>
October 28, 2009, by Michael Wetter:<br>
Added Wrapper function <a href=\"Modelica:Buildings.Fluid.Movers.BaseClasses.Characteristics.solve\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.solve</a> for 
<a href=\"Modelica:Modelica.Math.Matrices.solve\">
Modelica.Math.Matrices.solve</a>. This is currently needed since 
<a href=\"Modelica:Modelica.Math.Matrices.solve\">
Modelica.Math.Matrices.solve</a> does not specify a 
derivative.
</li>
<li>
October 15, 2009, by Michael Wetter:<br>
Added derivative function for <code>linearFlow</code>.
</li>
<li>
October 1, 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
  partial function baseFlow "Base class for fan or pump flow characteristics"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
    output Modelica.SIunits.Pressure dp(displayUnit="Pa")
      "Fan or pump total pressure";
  end baseFlow;

  partial function basePower
    "Base class for fan or pump power consumption characteristics"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
    output Modelica.SIunits.Power consumption "Power consumption";
  end basePower;

  partial function baseEfficiency "Base class for efficiency characteristics"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
    output Real eta "Efficiency";
  end baseEfficiency;

  function linearFlow "Linear flow characteristic"
    extends baseFlow;
    annotation(smoothOrder=100);

    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[2]
      "Volume flow rate for two operating points (single fan or pump)" annotation(Dialog);
    input Modelica.SIunits.Pressure dp_nominal[2](displayUnit="Pa")
      "Fan or pump total pressure for two operating points"                               annotation(Dialog);
    /* Linear system to determine the coefficients:
  dp_nominal[1] = c[1] + V_flow_nominal[1]*c[2];
  dp_nominal[2] = c[1] + V_flow_nominal[2]*c[2];
  */
  protected
    Real c[2] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( [ones(2),V_flow_nominal],dp_nominal)
      "Coefficients of linear total pressure curve";
  algorithm
    // Flow equation: dp = q*c[1] + c[2];
    dp := c[1] + V_flow*c[2];
  end linearFlow;

  function quadraticFlow "Quadratic flow characteristic"
    extends baseFlow;
    annotation(smoothOrder=100);
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[3]
      "Volume flow rate for three operating points (single fan or pump)" annotation(Dialog);
    input Modelica.SIunits.Pressure dp_nominal[3](displayUnit="Pa")
      "Fan or pump total pressure for three operating points"                               annotation(Dialog);
  protected
    Real V_flow_nominal2[3] = {V_flow_nominal[1]^2,V_flow_nominal[2]^2, V_flow_nominal[3]^2}
      "Squared nominal flow rates";
    /* Linear system to determine the coefficients:
  dp_nominal[1] = c[1] + V_flow_nominal[1]*c[2] + V_flow_nominal[1]^2*c[3];
  dp_nominal[2] = c[1] + V_flow_nominal[2]*c[2] + V_flow_nominal[2]^2*c[3];
  dp_nominal[3] = c[1] + V_flow_nominal[3]*c[2] + V_flow_nominal[3]^2*c[3];
  */
    Real c[3] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( [ones(3), V_flow_nominal, V_flow_nominal2],dp_nominal)
      "Coefficients of quadratic total pressure curve";
  algorithm
    // Flow equation: dp  = c[1] + V_flow*c[2] + V_flow^2*c[3];
    dp := c[1] + V_flow*c[2] + V_flow^2*c[3];
  end quadraticFlow;

  function polynomialFlow "Polynomial flow characteristic"
    extends baseFlow;
    annotation(smoothOrder=100);
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[:]
      "Volume flow rate for N operating points (single fan or pump)" annotation(Dialog);
    input Modelica.SIunits.Pressure dp_nominal[:](displayUnit="Pa")
      "Fan or pump total pressure for N operating points"                               annotation(Dialog);
  protected
    Integer N = size(V_flow_nominal,1) "Number of nominal operating points";
    Real V_flow_nominal_pow[N,N] = {{V_flow_nominal[i]^(j-1) for j in 1:N} for i in 1:N}
      "Rows: different operating points; columns: increasing powers";
    /* Linear system to determine the coefficients (example N=3):
  dp_nominal[1] = c[1] + V_flow_nominal[1]*c[2] + V_flow_nominal[1]^2*c[3];
  dp_nominal[2] = c[1] + V_flow_nominal[2]*c[2] + V_flow_nominal[2]^2*c[3];
  dp_nominal[3] = c[1] + V_flow_nominal[3]*c[2] + V_flow_nominal[3]^2*c[3];
  */
    Real c[N] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( V_flow_nominal_pow,dp_nominal)
      "Coefficients of polynomial total pressure curve";
  algorithm
    // Flow equation (example N=3): dp  = c[1] + V_flow*c[2] + V_flow^2*c[3];
    // Note: the implementation is numerically efficient only for low values of N
    dp := sum(V_flow^(i-1)*c[i] for i in 1:N);
  end polynomialFlow;

  function linearPower "Linear power consumption characteristic"
    extends basePower;
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[2]
      "Volume flow rate for two operating points (single fan or pump)"   annotation(Dialog);
    input Modelica.SIunits.Power W_nominal[2]
      "Power consumption for two operating points"                             annotation(Dialog);
    /* Linear system to determine the coefficients:
  W_nominal[1] = c[1] + V_flow_nominal[1]*c[2];
  W_nominal[2] = c[1] + V_flow_nominal[2]*c[2];
  */
  protected
    Real c[2] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( [ones(3),V_flow_nominal],W_nominal)
      "Coefficients of linear power consumption curve";
  algorithm
    consumption := c[1] + V_flow*c[2];
  end linearPower;

  function quadraticPower "Quadratic power consumption characteristic"
    extends basePower;
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[3]
      "Volume flow rate for three operating points (single fan or pump)" annotation(Dialog);
    input Modelica.SIunits.Power W_nominal[3]
      "Power consumption for three operating points"                           annotation(Dialog);
  protected
    Real V_flow_nominal2[3] = {V_flow_nominal[1]^2,V_flow_nominal[2]^2, V_flow_nominal[3]^2}
      "Squared nominal flow rates";
    /* Linear system to determine the coefficients:
  W_nominal[1] = c[1] + V_flow_nominal[1]*c[2] + V_flow_nominal[1]^2*c[3];
  W_nominal[2] = c[1] + V_flow_nominal[2]*c[2] + V_flow_nominal[2]^2*c[3];
  W_nominal[3] = c[1] + V_flow_nominal[3]*c[2] + V_flow_nominal[3]^2*c[3];
  */
    Real c[3] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( [ones(3),V_flow_nominal,V_flow_nominal2],W_nominal)
      "Coefficients of quadratic power consumption curve";
  algorithm
    consumption := c[1] + V_flow*c[2] + V_flow^2*c[3];
  end quadraticPower;

  function polynomialPower "Polynomial power consumption characteristic"
    extends basePower;
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[:]
      "Volume flow rate for N operating points (single fan or pump)" annotation(Dialog);
    input Modelica.SIunits.Power W_nominal[:]
      "Power consumption for N operating points"                                       annotation(Dialog);
  protected
    Integer N = size(V_flow_nominal,1) "Number of nominal operating points";
    Real V_flow_nominal_pow[N,N] = {{V_flow_nominal[i]^(j-1) for j in 1:N} for i in 1:N}
      "Rows: different operating points; columns: increasing powers";
    /* Linear system to determine the coefficients (example N=3):
  W_nominal[1] = c[1] + V_flow_nominal[1]*c[2] + V_flow_nominal[1]^2*c[3];
  W_nominal[2] = c[1] + V_flow_nominal[2]*c[2] + V_flow_nominal[2]^2*c[3];
  W_nominal[3] = c[1] + V_flow_nominal[3]*c[2] + V_flow_nominal[3]^2*c[3];
  */
    Real c[N] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( V_flow_nominal_pow,W_nominal)
      "Coefficients of polynomial power consumption curve";
  algorithm
    // Efficiency equation (example N=3): W  = c[1] + V_flow*c[2] + V_flow^2*c[3];
    // Note: the implementation is numerically efficient only for low values of N
    consumption := sum(V_flow^(i-1)*c[i] for i in 1:N);
  end polynomialPower;

  function constantEfficiency "Constant efficiency characteristic"
     extends baseEfficiency;
     input Real eta_nominal(min=0, max=1) "Nominal efficiency" annotation(Dialog);
  algorithm
    eta := eta_nominal;
  end constantEfficiency;

  function linearEfficiency "Linear efficiency characteristic"
    extends baseEfficiency;
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[2]
      "Volume flow rate for two operating points (single fan or pump)" annotation(Dialog);
    input Real eta_nominal[2](min=0, max=1) "Nominal efficiency" annotation(Dialog);
    /* Linear system to determine the coefficients:
  eta_nominal[1] = c[1] + V_flow_nominal[1]*c[2];
  eta_nominal[2] = c[1] + V_flow_nominal[2]*c[2];
  */
  protected
    Real c[2] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( [ones(2),V_flow_nominal],eta_nominal)
      "Coefficients of linear total efficiency curve";
  algorithm
    // Efficiency equation: eta = q*c[1] + c[2];
    eta := c[1] + V_flow*c[2];
  end linearEfficiency;

  function quadraticEfficiency "Quadratic efficiency characteristic"
    extends baseEfficiency;
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[3]
      "Volume flow rate for three operating points (single fan or pump)" annotation(Dialog);
    input Real eta_nominal[3](min=0, max=1)
      "Nominal efficiency for three operating points"                                       annotation(Dialog);
  protected
    Real V_flow_nominal2[3] = {V_flow_nominal[1]^2,V_flow_nominal[2]^2, V_flow_nominal[3]^2}
      "Squared nominal flow rates";
    /* Linear system to determine the coefficients:
  eta_nominal[1] = c[1] + V_flow_nominal[1]*c[2] + V_flow_nominal[1]^2*c[3];
  eta_nominal[2] = c[1] + V_flow_nominal[2]*c[2] + V_flow_nominal[2]^2*c[3];
  eta_nominal[3] = c[1] + V_flow_nominal[3]*c[2] + V_flow_nominal[3]^2*c[3];
  */
    Real c[3] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( [ones(3), V_flow_nominal, V_flow_nominal2],eta_nominal)
      "Coefficients of quadratic efficiency curve";
  algorithm
    // Efficiency equation: eta  = c[1] + V_flow*c[2] + V_flow^2*c[3];
    eta := c[1] + V_flow*c[2] + V_flow^2*c[3];
  end quadraticEfficiency;

  function polynomialEfficiency "Polynomial efficiency characteristic"
    extends baseEfficiency;
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[:]
      "Volume flow rate for N operating points (single fan or pump)" annotation(Dialog);
    input Real eta_nominal[:](min=0, max=1)
      "Nominal efficiency for N operating points"                                       annotation(Dialog);
  protected
    Integer N = size(V_flow_nominal,1) "Number of nominal operating points";
    Real V_flow_nominal_pow[N,N] = {{V_flow_nominal[i]^(j-1) for j in 1:N} for i in 1:N}
      "Rows: different operating points; columns: increasing powers";
    /* Linear system to determine the coefficients (example N=3):
  eta_nominal[1] = c[1] + V_flow_nominal[1]*c[2] + V_flow_nominal[1]^2*c[3];
  eta_nominal[2] = c[1] + V_flow_nominal[2]*c[2] + V_flow_nominal[2]^2*c[3];
  eta_nominal[3] = c[1] + V_flow_nominal[3]*c[2] + V_flow_nominal[3]^2*c[3];
  */
    Real c[N] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( V_flow_nominal_pow,eta_nominal)
      "Coefficients of polynomial total pressure curve";
  algorithm
    // Efficiency equation (example N=3): eta  = c[1] + V_flow*c[2] + V_flow^2*c[3];
    // Note: the implementation is numerically efficient only for low values of N
    eta := sum(V_flow^(i-1)*c[i] for i in 1:N);
  end polynomialEfficiency;

  function solve "Wrapper for Modelica.Math.Matrices.solve"
   input Real A[:,size(A,1)];
   input Real x[size(A,1)];
  output Real b[size(A,1)];
  algorithm
   b:=Modelica.Math.Matrices.solve(A,x);

   annotation(derivative=Buildings.Fluid.Movers.BaseClasses.Characteristics.der_solve,
        Documentation(info="<html>
Wrapper function for 
<a href=\"Modelica:Modelica.Math.Matrices.solve\">
Modelica.Math.Matrices.solve</a>. This is currently needed since 
<a href=\"Modelica:Modelica.Math.Matrices.solve\">
Modelica.Math.Matrices.solve</a> does not specify a 
derivative. 
The implementation is based on the code from Hans Olsson, Dynasim support
request 10872.
</html>",   revisions="<html>
<ul>
<li><i>October 28, 2009</i>
    by Michael Wetter</a>:<br>
First implementation.
</li>
</ul>
</html>"));
  end solve;

  function der_solve "Derivative for function solve"
    input Real A[:,size(A,1)];
    input Real x[size(A,1)];
    input Real Ader[:,size(A,1)];
    input Real xder[size(A,1)];
    output Real b[size(A,1)];
  algorithm
    b:=Modelica.Math.Matrices.solve(A,xder-Ader*Modelica.Math.Matrices.solve(A,x));
  end der_solve;

  package Examples "Examples to test implemenation of derivative function"
    import Buildings;
    extends Buildings.BaseClasses.BaseIconExamples;
    model LinearFlowDerivativeCheck
      "Model to check implementation of derivative function"

     annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                        graphics),
                         Commands(file="LinearFlowDerivativeCheck.mos" "run"));
      annotation (
        Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>",     revisions="<html>
<ul>
<li>
October 29, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      Real x;
      Real y;
    initial equation
       y=x;
    equation
      x=Buildings.Fluid.Movers.BaseClasses.Characteristics.linearFlow(
         V_flow=time-2,
         V_flow_nominal={1, 0},
         dp_nominal=  {0, 3000});
      der(y)=der(x);
      assert(abs(x-y) < 1E-2, "Model has an error");
    end LinearFlowDerivativeCheck;

    model QuadraticFlowDerivativeCheck
      "Model to check implementation of derivative function"

     annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                        graphics),
                         Commands(file="QuadraticFlowDerivativeCheck.mos" "run"));
      annotation (
        Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>",     revisions="<html>
<ul>
<li>
October 29, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
      Real x;
      Real y;
    initial equation
       y=x;
    equation
      x=Buildings.Fluid.Movers.BaseClasses.Characteristics.quadraticFlow(
         V_flow=time,
         V_flow_nominal={0, 1.8, 3},
         dp_nominal=  {1000, 600, 0});
      der(y)=der(x);
      assert(abs(x-y) < 1E-2, "Model has an error");
    end QuadraticFlowDerivativeCheck;
  end Examples;
end Characteristics;
