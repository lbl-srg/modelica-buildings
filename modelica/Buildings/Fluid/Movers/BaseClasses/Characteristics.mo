within Buildings.Fluid.Movers.BaseClasses;
package Characteristics "Functions for fan or pump characteristics"

  partial function baseFlow "Base class for fan or pump flow characteristics"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
    input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
    output Modelica.SIunits.Pressure dp(min=0, displayUnit="Pa")
      "Fan or pump total pressure";
  end baseFlow;

  partial function basePower
    "Base class for fan or pump power consumption characteristics"
    extends Modelica.Icons.Function;
    input Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
    input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
    output Modelica.SIunits.Power consumption "Power consumption";
  end basePower;

  partial function baseEfficiency "Base class for efficiency characteristics"
    extends Modelica.Icons.Function;
    input Real r_V(unit="1")
      "Volumetric flow rate divided by nominal flow rate";
    output Real eta(min=0, unit="1") "Efficiency";
  end baseEfficiency;

  function linearFlow "Linear flow characteristic"
    extends baseFlow;

    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[2]
      "Volume flow rate for two operating points (single fan or pump)"
      annotation(Dialog);
    input Modelica.SIunits.Pressure dp_nominal[2](each min=0, each displayUnit="Pa")
      "Fan or pump total pressure for two operating points"
      annotation(Dialog);
    /* Linear system to determine the coefficients:
  dp_nominal[1] = c[1] + V_flow_nominal[1]*c[2];
  dp_nominal[2] = c[1] + V_flow_nominal[2]*c[2];
  */
  protected
    Real c[2] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( [ones(2),V_flow_nominal],dp_nominal)
      "Coefficients of linear total pressure curve";
  algorithm
    dp := r_N^2 * c[1] + r_N*V_flow*c[2];
    annotation(smoothOrder=100);
  end linearFlow;

  function quadraticFlow "Quadratic flow characteristic"
    extends baseFlow;
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[3](each min=0)
      "Volume flow rate for three operating points (single fan or pump)"
      annotation(Dialog);
    input Modelica.SIunits.Pressure dp_nominal[3](each min=0, each displayUnit="Pa")
      "Fan or pump total pressure for three operating points"
      annotation(Dialog);
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
    dp := r_N^2*c[1] + r_N*V_flow*c[2] + V_flow^2*c[3];
    annotation(smoothOrder=100);
  end quadraticFlow;

  function polynomialFlow "Polynomial flow characteristic"
    extends baseFlow;
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[:](each min=0)
      "Volume flow rate for N operating points (single fan or pump)"
      annotation(Dialog);
    input Modelica.SIunits.Pressure dp_nominal[:](each min=0, each displayUnit="Pa")
      "Fan or pump total pressure for N operating points"
      annotation(Dialog);
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
    dp := r_N^(N-1)*c[1] + sum(r_N^(N-i)*V_flow^(i-1)*c[i] for i in 2:N-1) + V_flow^(N-1)*c[N];
    annotation(smoothOrder=100);
  end polynomialFlow;

  function linearPower "Linear power consumption characteristic"
    extends basePower;
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[2]
      "Volume flow rate for two operating points (single fan or pump)"
      annotation(Dialog);
    input Modelica.SIunits.Power P_nominal[2]
      "Power consumption for two operating points"
      annotation(Dialog);
    /* Linear system to determine the coefficients:
  P_nominal[1] = c[1] + V_flow_nominal[1]*c[2];
  P_nominal[2] = c[1] + V_flow_nominal[2]*c[2];
  */
  protected
    Real c[2] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( [ones(3),V_flow_nominal],P_nominal)
      "Coefficients of linear power consumption curve";
  algorithm
    consumption := r_N^3*c[1] + r_N^2*V_flow*c[2];
  end linearPower;

  function quadraticPower "Quadratic power consumption characteristic"
    extends basePower;
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[3]
      "Volume flow rate for three operating points (single fan or pump)"
      annotation(Dialog);
    input Modelica.SIunits.Power P_nominal[3]
      "Power consumption for three operating points"
      annotation(Dialog);
  protected
    Real V_flow_nominal2[3] = {V_flow_nominal[1]^2,V_flow_nominal[2]^2, V_flow_nominal[3]^2}
      "Squared nominal flow rates";
    /* Linear system to determine the coefficients:
  P_nominal[1] = c[1] + V_flow_nominal[1]*c[2] + V_flow_nominal[1]^2*c[3];
  P_nominal[2] = c[1] + V_flow_nominal[2]*c[2] + V_flow_nominal[2]^2*c[3];
  P_nominal[3] = c[1] + V_flow_nominal[3]*c[2] + V_flow_nominal[3]^2*c[3];
  */
    Real c[3] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( [ones(3),V_flow_nominal,V_flow_nominal2],P_nominal)
      "Coefficients of quadratic power consumption curve";
  algorithm
    consumption := r_N^3*c[1] + r_N^2*V_flow*c[2] + r_N*V_flow^2*c[3];
  end quadraticPower;

  function polynomialPower "Polynomial power consumption characteristic"
    extends basePower;
    input Modelica.SIunits.VolumeFlowRate V_flow_nominal[:]
      "Volume flow rate for N operating points (single fan or pump)"
      annotation(Dialog);
    input Modelica.SIunits.Power P_nominal[:]
      "Power consumption for N operating points"
      annotation(Dialog);
  protected
    Integer N = size(V_flow_nominal,1) "Number of nominal operating points";
    Real V_flow_nominal_pow[N,N] = {{V_flow_nominal[i]^(j-1) for j in 1:N} for i in 1:N}
      "Rows: different operating points; columns: increasing powers";
    /* Linear system to determine the coefficients (example N=3):
  P_nominal[1] = c[1] + V_flow_nominal[1]*c[2] + V_flow_nominal[1]^2*c[3];
  P_nominal[2] = c[1] + V_flow_nominal[2]*c[2] + V_flow_nominal[2]^2*c[3];
  P_nominal[3] = c[1] + V_flow_nominal[3]*c[2] + V_flow_nominal[3]^2*c[3];
  */
    Real c[N] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( V_flow_nominal_pow,P_nominal)
      "Coefficients of polynomial power consumption curve";
  algorithm
    // Efficiency equation (example N=3): W  = c[1] + V_flow*c[2] + V_flow^2*c[3];
    // Note: the implementation is numerically efficient only for low values of N
    consumption := r_N^N*c[1] + sum(r_N^(N-i+1)*V_flow^(i-1)*c[i] for i in 2:N);
  end polynomialPower;

  function constantEfficiency "Constant efficiency characteristic"
     extends baseEfficiency;
     input Real eta_nominal(min=0, unit="1") "Nominal efficiency"
     annotation(Dialog);
  algorithm
    eta := eta_nominal;
  end constantEfficiency;

  function linearEfficiency "Linear efficiency characteristic"
    extends baseEfficiency;
    input Real r_V_nominal[2](each unit="1")
      "Volumetric flow rate divided by nominal flow rate for two operating points (single fan or pump)"
      annotation(Dialog);
    input Real eta_nominal[2](each min=0, each unit="1") "Nominal efficiency"
      annotation(Dialog);
    /* Linear system to determine the coefficients:
  eta_nominal[1] = c[1] + V_flow_nominal[1]*c[2];
  eta_nominal[2] = c[1] + V_flow_nominal[2]*c[2];
  */
  protected
    Real c[2] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( [ones(2),r_V_nominal],eta_nominal)
      "Coefficients of linear total efficiency curve";
  algorithm
    // Efficiency equation: eta = q*c[1] + c[2];
    eta := c[1] + r_V*c[2];
  end linearEfficiency;

  function quadraticEfficiency "Quadratic efficiency characteristic"
    extends baseEfficiency;
    input Real r_V_nominal[3](each unit="1")
      "Volumetric flow rate divided by nominal flow rate for three operating points (single fan or pump)"
      annotation(Dialog);
    input Real eta_nominal[3](each min=0, each unit="1")
      "Nominal efficiency for three operating points"
      annotation(Dialog);
  protected
    Real r_V_nominal2[3] = {r_V_nominal[1]^2,r_V_nominal[2]^2, r_V_nominal[3]^2}
      "Squared nominal flow rates";
    /* Linear system to determine the coefficients:
  eta_nominal[1] = c[1] + r_V_nominal[1]*c[2] + r_V_nominal[1]^2*c[3];
  eta_nominal[2] = c[1] + r_V_nominal[2]*c[2] + r_V_nominal[2]^2*c[3];
  eta_nominal[3] = c[1] + r_V_nominal[3]*c[2] + r_V_nominal[3]^2*c[3];
  */
    Real c[3] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( [ones(3), r_V_nominal, r_V_nominal2],eta_nominal)
      "Coefficients of quadratic efficiency curve";
  algorithm
    // Efficiency equation: eta  = c[1] + V_flow*c[2] + V_flow^2*c[3];
    eta := c[1] + r_V*c[2] + r_V^2*c[3];
  end quadraticEfficiency;

  function polynomialEfficiency "Polynomial efficiency characteristic"
    extends baseEfficiency;
    input Real r_V_nominal[:](each unit="1")
      "Volumetric flow rate divided by nominal flow rate for N operating points (single fan or pump)"
      annotation(Dialog);
    input Real eta_nominal[:](each min=0, each unit="1")
      "Nominal efficiency for N operating points"
      annotation(Dialog);
  protected
    Integer N = size(r_V_nominal,1) "Number of nominal operating points";
    Real r_V_nominal_pow[N,N] = {{r_V_nominal[i]^(j-1) for j in 1:N} for i in 1:N}
      "Rows: different operating points; columns: increasing powers";
    /* Linear system to determine the coefficients (example N=3):
  eta_nominal[1] = c[1] + r_V_nominal[1]*c[2] + r_V_nominal[1]^2*c[3];
  eta_nominal[2] = c[1] + r_V_nominal[2]*c[2] + r_V_nominal[2]^2*c[3];
  eta_nominal[3] = c[1] + r_V_nominal[3]*c[2] + r_V_nominal[3]^2*c[3];
  */
    Real c[N] = Buildings.Fluid.Movers.BaseClasses.Characteristics.solve( r_V_nominal_pow,eta_nominal)
      "Coefficients of polynomial total pressure curve";
  algorithm
    // Efficiency equation (example N=3): eta  = c[1] + r_V*c[2] + r_V^2*c[3];
    // Note: the implementation is numerically efficient only for low values of N
    eta := c[1] + sum(r_V^(i-1)*c[i] for i in 2:N);
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

  package Examples "Examples to test implementation of derivative function"
    import Buildings;
    extends Modelica.Icons.ExamplesPackage;
    model LinearFlowDerivativeCheck
      "Model to check implementation of derivative function"
      extends Modelica.Icons.Example;
      Real x;
      Real y;
      constant Real timeToFlow(unit="m3/s2")=1
        "Conversion factor to satisfy unit check";
    initial equation
       y=x;
    equation
      x=Buildings.Fluid.Movers.BaseClasses.Characteristics.linearFlow(
         V_flow=time*timeToFlow-2,
         V_flow_nominal={1, 0},
         dp_nominal=  {0, 3000},
         r_N=  0.5);
      der(y)=der(x);
      assert(abs(x-y) < 1E-2, "Model has an error");
     annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                        graphics),
                         __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/LinearFlowDerivativeCheck.mos" "run"),
        Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>",     revisions="<html>
<ul>
<li>
March 23, 2010, by Michael Wetter:<br>
Fixed arguments to make function call compatible with new implementation
of the <code>Characteristics</code> package.
</li>
<li>
October 29, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
    end LinearFlowDerivativeCheck;

    model QuadraticFlowDerivativeCheck
      "Model to check implementation of derivative function"
      extends Modelica.Icons.Example;
      Real x;
      Real y;
      constant Real timeToFlow(unit="m3/s2")=1
        "Conversion factor to satisfy unit check";
    initial equation
       y=x;
    equation
      x=Buildings.Fluid.Movers.BaseClasses.Characteristics.quadraticFlow(
         V_flow=time*timeToFlow,
         V_flow_nominal={0, 1.8, 3},
         dp_nominal=  {1000, 600, 0},
         r_N=  0.5);
      der(y)=der(x);
      assert(abs(x-y) < 1E-2, "Model has an error");
     annotation(Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
                -100},{100,100}}),
                        graphics),
                         __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/BaseClasses/QuadraticFlowDerivativeCheck.mos" "run"),
        Documentation(info="<html>
<p>
This example checks whether the function derivative
is implemented correctly. If the derivative implementation
is not correct, the model will stop with an assert statement.
</p>
</html>",     revisions="<html>
<ul>
<li>
March 23, 2010, by Michael Wetter:<br>
Fixed arguments to make function call compatible with new implementation
of the <code>Characteristics</code> package.
</li>
<li>
October 29, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
    end QuadraticFlowDerivativeCheck;
  end Examples;
  annotation (Documentation(info="<html>
<p>
This package implements performance curves for fans and pumps.
</p>
<p>
The following performance curves are implemented:
<pre>
 dp =f(V_flow, r_N, {V_flow_nominal, dp_nominal})
 P  =f(V_flow, r_N, {V_flow_nominal, dp_nominal})
 eta=f(r_V,         {r_V_nominal, eta_nominal})
</pre>
where
<code>dp</code> is the pressure raise, 
<code>P</code> is the power consumption,
<code>eta</code> is the efficiency,
<code>V_flow</code> is the volume flow rate,
<code>r_N=N/N_nominal</code> is the normalized revolution
and the quantities in curly brackets are points used to parameterize the curves.
Each curve can be a constant, a linear function, a quadratic function or a polynomial
of arbitrary order.
</p>
<p>The package is similar to 
<a href=\"Modelica:Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics\">
Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics</a>, with the following exceptions:
<ul>
<li>
Instead of head in meters H20, total pressure in Pascal is used. 
This makes the models applicable for fans as well since the flow models from Modelica.Fluid use the 
density of the medium model, such as the density of air instead of water, 
to convert head to pressure.
</li>
<li>
In <a href=\"Modelica:Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics\">
Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics</a>, 
input to the functions is <code>V_flow/r_N</code>,
where <code>r_N=N/N_nominal</code>,
and the mover model computes, for example 
for a quadratic performance curve,
<pre>
  dp = r_N^2 * f(V_flow/r_N) 
     = r_N^2 * ( c1 + c2 * V_flow/r_N + c3 * (V_flow/r_N)^2) 
     = r_N^2 * c1 + r_N * c2 * V_flow + c3 * V_flow^2.
</pre>
Since <code>f(V_flow/r_N) = c1 + c2 * V_flow/r_N + c3 * (V_flow/r_N)^2</code> is
singular for <code>r_N=0</code>, we redefined this function as
<code>
  dp = f(V_flow, r_N) 
     = r_N^2 * c1 + r_N * c2 * V_flow + c3 * V_flow^2
</code>
which allows computing <code>dp</code> for <code>r_N=0</code>.
Note, however, that the model of the Buildings library, as well as the 
model of Modelica.Fluid, is still singular for <code>r_N=0</code>
for performance curves that have a higher order than 2.
</li>
<li>
This package also contains higher order functions for power consumption and efficiency.
</li>
</p>
</html>",
revisions="<html>
<ul>
<li>
February 25, 2011, by Michael Wetter:<br>
Fixed wrong variable names and dimensions in efficiency functions.
In the previous version, some function could not be used due to a syntax
error.
Updated the package documentation.
</li>
<li>
October 28, 2009, by Michael Wetter:<br>
Added Wrapper function <a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.solve\">
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
end Characteristics;
