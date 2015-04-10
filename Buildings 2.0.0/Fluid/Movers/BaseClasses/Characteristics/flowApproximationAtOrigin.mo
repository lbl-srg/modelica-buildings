within Buildings.Fluid.Movers.BaseClasses.Characteristics;
function flowApproximationAtOrigin
  "Approximation for fan or pump pressure raise at origin"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.VolumeFlowRate V_flow "Volumetric flow rate";
  input Real r_N(unit="1") "Relative revolution, r_N=N/N_nominal";
  input Modelica.SIunits.VolumeFlowRate VDelta_flow "Small volume flow rate";
  input Modelica.SIunits.Pressure dpDelta "Small pressure";
  input Real delta "Small value used to transition to other fan curve";
  input Real cBar[2]
    "Coefficients for linear approximation of pressure vs. flow rate";
  output Modelica.SIunits.Pressure dp "Pressure raise";
algorithm

  // see equation 20 in  Buildings/Resources/Images/Fluid/Movers/UsersGuide/2013-IBPSA-Wetter.pdf
  // this equation satisfies the constraints detailed in the paper
  // the first term is added for having a faster convergence
  // the last term in the paper is absent here because it can be found in
  // Buildings.Fluid.Movers.BaseClasses.Characteristics.pressure
  dp := r_N * dpDelta + r_N^2 * (cBar[1] + cBar[2]*V_flow);
  annotation (Documentation(info="<html>
<p>
This function computes the fan static
pressure raise as a function of volume flow rate and revolution near the origin.
It is used to avoid a singularity in the pump or fan curve if the revolution
approaches zero.
</p>
</html>",
        revisions="<html>
<ul>
<li>
August 25, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),   smoothOrder=100);
end flowApproximationAtOrigin;
