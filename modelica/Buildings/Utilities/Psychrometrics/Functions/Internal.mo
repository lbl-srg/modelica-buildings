within Buildings.Utilities.Psychrometrics.Functions;
package Internal "Solve f(x, data) for x with given f"
  extends Buildings.Utilities.Math.BaseClasses.OneNonLinearEquation;

  redeclare function extends f_nonlinear
  algorithm
     y := pW_Tdp(x);
  end f_nonlinear;

  // Dummy definition has to be added for current Dymola
  redeclare function extends solve
  end solve;
end Internal;
