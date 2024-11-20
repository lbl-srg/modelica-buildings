within Buildings.Fluid.Geothermal.ZonedBorefields.Validation;
package FEFLOW "Package with models for comparative model validation with FEFLOW"
  extends Modelica.Icons.ExamplesPackage;
annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains validation models that compare the results of
the Modelica model with the ones from a finite element model that
was simulated with the FEFLOW software.
</p>
<p>
In all models of this package, the temperatures <code>TOut</code>
are the leaving water temperatures from FEFLOW,
computed with FEFLOW's analytical solution for the borehole heat transfer.
Comparing <code>TOut</code> with the temperatures <code>TBorFieOut</code>
shows good agreement except at the initial transient at the start of the
simulation when the mass flow rate changes from zero to the design flow rate.
The leaving water temperatures at this initial transient
show similar discrepancies as the comparison of FEFLOW's analytical and
numerical solutions that is presented in the FEFLOW white paper (DHI-WASY 2010).
In the FEFLOW white paper, it is explained that the reason for this difference is
due to the FEFLOW's analytical solution not being valid for such short-time dynamics.
Therefore, the validation of the Modelica implementation is satisfactory.
</p>
<h5>References</h5>
<p>
DHI-WASY Software FEFLOW. Finite Element Subsurface Flow &amp; Transport Simulation System.
White Paper Vol. V.
DHI-WASY GmbH. Berlin 2010.
</p>
</html>"));
end FEFLOW;
