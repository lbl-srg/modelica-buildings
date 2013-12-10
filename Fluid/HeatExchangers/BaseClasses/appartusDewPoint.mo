within Buildings.Fluid.HeatExchangers.BaseClasses;
function appartusDewPoint "Computes the apparatus dewpoint temperature"
  import psy = Buildings.Utilities.Psychrometrics.Functions;

  input Modelica.SIunits.Temperature TAir_in
    "Air inlet temperature at design condition";
  input Modelica.SIunits.Temperature TAir_out
    "Air inlet temperature at design condition";

  input Modelica.SIunits.MassFraction XW_in
    "Water vapor concentration at coil inlet at design condition";
  input Modelica.SIunits.MassFraction XW_out
    "Water vapor concentration at coil outlet at design condition";
  output Modelica.SIunits.Temperature T_dp "Apparatus dew point temperature";
  output Modelica.SIunits.MassFraction XW_dp
    "Water vapor concentration at apparatus dew point";
  output Real m(unit="1/K")
    "Slope, used to compute apparatus dewpoint temperature";

protected
  Modelica.SIunits.Temperature T "Iteration variable for temperature";
  Modelica.SIunits.Temperature dT
    "Temperature increment used in initial search";
  constant Modelica.SIunits.Temperature dTMin = 1E-10
    "Minimum temperature increment used during search";

  Integer i "Number of iterations";
  constant Integer iMax = 1000 "Maximum number of iterations";

  Real m_nominal(unit="1/K")
    "Slope based on nominal conditions, used to compute apparatus dewpoint temperature";
  Boolean converged "Flag to control iteration";

algorithm
  // Slope at design condition
  m_nominal :=(XW_in - XW_out)/(TAir_in - TAir_out);
  // Start value for iteration
  T_dp :=TAir_in;
  dT :=1;
  converged :=false;
  i :=0;
  while not converged loop
    i :=i + 1;
    assert(i < iMax, "Maximum number of iterations exceeded in computing\n"
      + "apparatus dew point for coil at nominal conditions"
      + "\n  Best known approximation is T_dp = " + String(T_dp)
      + "\n  Search step is dT = " + String(dT));

    T :=T_dp - dT;
    // New trial value
    XW_dp :=psy.X_pW(psy.pW_TDewPoi(T));
    m :=(XW_in - XW_dp)/(TAir_in - T);
    if (m < m_nominal) then // T is above dew point
       T_dp :=T; // Accept T as new approximation to solution
    else // T is below dew point.
       if (dT < dTMin) then // achieved required accuracy
         T_dp :=T;
         converged :=true;
       else  // need to shorten step. Reject last iterate T
         dT:=dT/10;
         T :=T_dp; // Resets T to last known value above dew point
       end if;
    end if;
  end while;
  annotation(preferredView="info",
           Documentation(info="<html>
<p>
This function computes iteratively the apparatus dew point temperature for a cooling coil.
The apparatus dew point temperature is defined as in the HVAC2 Toolkit (Brandemuehl <i>et al.</i>
1993), namely as the intersection of the line between coil air inlet state <i>(T,X)</i> and
outlet state, and the saturation line.
</p>
<p>
This function does its own iterations to find a solution because a solution may not exist or
not be unique because the saturation line is convex.
Therefore, this function searches for the solution starting at the air inlet temperature
and progressively reduces the guess value for the apparatus dew point temperature.
When a temperature below the apparatus dew point temperature has been found, it is rejected, and the
search continues with a smaller step until the step size is smaller than a prescribed value. This
ensures that the solution corresponding to the higher temperature is found.
If no solution can be found, the function stops the simulation.
</p>
<h4>References</h4>
<p>
Brandemuehl, Michael, Shauna Gabel and Inger Andresen. <i>HVAC2 Toolkit, A toolkit for secondary HVAC system
energy calculations</i>. ASHRAE, Atlanta. 1993.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 22, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end appartusDewPoint;
