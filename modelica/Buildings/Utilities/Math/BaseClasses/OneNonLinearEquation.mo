within Buildings.Utilities.Math.BaseClasses;
package OneNonLinearEquation
  "Determine solution of a non-linear algebraic equation in one unknown without derivatives in a reliable and efficient way"
  extends Modelica.Icons.Library;
   annotation (Documentation(info="<html>
<p>
This function should only be used in exceptional cases
since it might be replaced in the future by another strategy,
where the tool is responsible for the solution of the non-linear
equation.
</p>

<p>
This library determines the solution of one non-linear algebraic equation \"y=f(x)\"
in one unknown \"x\" in a reliable way. As input, the desired value y of the
non-linear function has to be given, as well as an interval x_min, x_max that
contains the solution, i.e., \"f(x_min) - y\" and \"f(x_max) - y\" must
have a different sign. If possible, a smaller interval is computed by
inverse quadratic interpolation (interpolating with a quadratic polynomial
through the last 3 points and computing the zero). If this fails,
bisection is used, which always reduces the interval by a factor of 2.
The inverse quadratic interpolation method has superlinear convergence.
This is roughly the same convergence rate as a globally convergent Newton
method, but without the need to compute derivatives of the non-linear
function. The solver function is a direct mapping of the Algol 60 procedure
\"zero\" to Modelica, from:
</p>

<dl>
<dt> Brent R.P.:</dt>
<dd> <b>Algorithms for Minimization without derivatives</b>.
     Prentice Hall, 1973, pp. 58-59.</dd>
</dl>

<p>
Due to current limitations of the
Modelica language (not possible to pass a function reference to a function),
the construction to use this solver on a user-defined function is a bit
complicated (this method is from Hans Olsson, Dynasim AB). A user has to
provide a package in the following way:
</p>

<pre>
  <b>package</b> MyNonLinearSolver
    <b>extends</b> OneNonLinearEquation;

    <b>redeclare record extends</b> Data
      // Define data to be passed to user function
      ...
    <b>end</b> Data;

    <b>redeclare function extends</b> f_nonlinear
    <b>algorithm</b>
       // Compute the non-linear equation: y = f(x, Data)
    <b>end</b> f_nonlinear;

    // Dummy definition that has to be present for current Dymola
    <b>redeclare function extends</b> solve
    <b>end</b> solve;
  <b>end</b> MyNonLinearSolver;

  x_zero = MyNonLinearSolver.solve(y_zero, x_min, x_max, data=data);
</pre>
</html>", revisions="<html>
<ul>
<li>
February 12, 2010, by Michael Wetter:<br>
First implementation, based on 
<a href=\"Modelica:Modelica.Media.Common.OneNonLinearEquation\">
Modelica.Media.Common.OneNonLinearEquation</a>.
This package is implemented to change the interface for the function
<code>f_nonlinear</code>.
</li>
</html>"));

   replaceable partial function f_nonlinear
    "Nonlinear algebraic equation in one unknown: y = f_nonlinear(x,p,X)"
     extends Modelica.Icons.Function;
     input Real x "Independent variable of function";
     input Real[:] f_nonlinear_data "Additional data for the function";
     output Real y "= f_nonlinear(x)";
     // annotation(derivative(zeroDerivative=y)); // this must hold for all replaced functions
   end f_nonlinear;

   replaceable function solve
    "Solve f_nonlinear(x_zero)=y_zero; f_nonlinear(x_min) - y_zero and f_nonlinear(x_max)-y_zero must have different sign"
    import Modelica.Utilities.Streams.error;
     extends Modelica.Icons.Function;
     input Real y_zero
      "Determine x_zero, such that f_nonlinear(x_zero) = y_zero";
     input Real x_min "Minimum value of x";
     input Real x_max "Maximum value of x";
      input Real[:] f_nonlinear_data "Additional data for function f_nonlinear";
      input Real x_tol =  100*Modelica.Constants.eps
      "Relative tolerance of the result";
      output Real x_zero "f_nonlinear(x_zero) = y_zero";
  protected
      constant Real eps = Modelica.Constants.eps "machine epsilon";
      Real a = x_min "Current best minimum interval value";
      Real b = x_max "Current best maximum interval value";
      Real c "Intermediate point a <= c <= b";
      Real d;
      Real e "b - a";
      Real m;
      Real s;
      Real p;
      Real q;
      Real r;
      Real tol;
      Real fa "= f_nonlinear(a) - y_zero";
      Real fb "= f_nonlinear(b) - y_zero";
      Real fc;
      Boolean found = false;
   algorithm
      // Check that f(x_min) and f(x_max) have different sign
      fa :=f_nonlinear(x_min, f_nonlinear_data) - y_zero;
      fb :=f_nonlinear(x_max, f_nonlinear_data) - y_zero;
      fc := fb;
      if fa > 0.0 and fb > 0.0 or 
         fa < 0.0 and fb < 0.0 then
         error("The arguments x_min and x_max to OneNonLinearEquation.solve(..)\n" +
               "do not bracket the root of the single non-linear equation:\n" +
               "  x_min  = " + String(x_min) + "\n" +
               "  x_max  = " + String(x_max) + "\n" +
               "  y_zero = " + String(y_zero) + "\n" +
               "  fa = f(x_min) - y_zero = " + String(fa) + "\n" +
               "  fb = f(x_max) - y_zero = " + String(fb) + "\n" +
               "fa and fb must have opposite sign which is not the case");
      end if;

      // Initialize variables
      c :=a;
      fc :=fa;
      e :=b - a;
      d :=e;

      // Search loop
      while not found loop
         if abs(fc) < abs(fb) then
            a :=b;
            b :=c;
            c :=a;
            fa :=fb;
            fb :=fc;
            fc :=fa;
         end if;

         tol :=2*eps*abs(b) + x_tol;
         m :=(c - b)/2;

         if abs(m) <= tol or fb == 0.0 then
            // root found (interval is small enough)
            found :=true;
            x_zero :=b;
         else
            // Determine if a bisection is needed
            if abs(e) < tol or abs(fa) <= abs(fb) then
               e :=m;
               d :=e;
            else
               s :=fb/fa;
               if a == c then
                  // linear interpolation
                  p :=2*m*s;
                  q :=1 - s;
               else
                  // inverse quadratic interpolation
                  q :=fa/fc;
                  r :=fb/fc;
                  p :=s*(2*m*q*(q - r) - (b - a)*(r - 1));
                  q :=(q - 1)*(r - 1)*(s - 1);
               end if;

               if p > 0 then
                  q :=-q;
               else
                  p :=-p;
               end if;

               s :=e;
               e :=d;
               if 2*p < 3*m*q-abs(tol*q) and p < abs(0.5*s*q) then
                  // interpolation successful
                  d :=p/q;
               else
                  // use bi-section
                  e :=m;
                  d :=e;
               end if;
            end if;

            // Best guess value is defined as "a"
            a :=b;
            fa :=fb;
            b :=b + (if abs(d) > tol then d else if m > 0 then tol else -tol);
            fb :=f_nonlinear(b, f_nonlinear_data) - y_zero;

            if fb > 0 and fc > 0 or 
               fb < 0 and fc < 0 then
               // initialize variables
               c :=a;
               fc :=fa;
               e :=b - a;
               d :=e;
            end if;
         end if;
      end while;
   end solve;

end OneNonLinearEquation;
