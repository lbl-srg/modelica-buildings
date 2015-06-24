within Buildings.Utilities.IO;
package BCVTB "Package with functions to communicate with the Building Controls Virtual Test Bed"
  extends Modelica.Icons.VariantsPackage;


package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;
annotation (Documentation(info="<html>
This package contains an interface to the
<a href=\"http://simulationresearch.lbl.gov/bcvtb\">Building Controls Virtual Test Bed</a>
(BCVTB).
The BCVTB is a middleware that is based on
<a href=\"http://ptolemy.berkeley.edu/ptolemyII/\">Ptolemy II</a>.
Ptolemy II is a software framework to study modeling, simulation, and design of concurrent, real-time, embedded systems, with focus on the assembly of concurrent components and the use of heterogeneous mixtures of models of computation that govern the interactions between components. The BCVTB adds functionalities to Ptolemy II that allows coupling Modelica,
<a href=\"http://www.energyplus.gov\">EnergyPlus</a> and
<a href=\"http://www.mathworks.com\">MATLAB/Simulink</a>
for data exchange during the time step integration.
<br/>
To run the examples in
<a href=\"modelica://Buildings.Utilities.IO.BCVTB.Examples\">
Buildings.Utilities.IO.BCVTB.Examples</a>
the BCVTB needs to be installed. The BCVTB installation
contains these examples and the C libraries that are required
by this package.
</html>"));
end UsersGuide;

end BCVTB;
