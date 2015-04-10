within Buildings.HeatTransfer;
package Conduction "Package with models for heat conduction"
  extends Modelica.Icons.VariantsPackage;

  constant Integer nSupPCM = 6
    "Number of support points to approximate u(T) releation, used only for phase change material";

annotation (Documentation(info="<html>
<p>
This package provides component models to compute heat conduction.
</p>
<h4>Implementation</h4>
<p>
The package declares the constant <code>nSupPCM</code>,
which is equal to the number of support points that are used
to approximate the specific internal energy versus temperature relation.
This approximation is used by
<code>Buildings.HeatTransfer.Conduction.SingleLayer</code>
to replace the piece-wise linear function by a cubic hermite spline, with
linear extrapolation, in order to avoid state events during the simulation.
</p>
</html>", revisions="<html>
<ul>
<li>
March 10, 2013, by Michael Wetter:<br/>
Added constant <code>nSupPCM</code>.
</li>
<li>
February 5, 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Conduction;
