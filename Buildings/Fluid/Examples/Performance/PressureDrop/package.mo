within Buildings.Fluid.Examples.Performance;
package PressureDrop "Package with various configurations of pressure drop models to analyze symbolic processing"
  extends Modelica.Icons.ExamplesPackage;

annotation (Documentation(info="<html>
<p>
This package contains examples that demonstrate how parameter
settings and boundary conditions can affect the number and
size of algebraic loops.
</p>
<p>
Either a pressure difference or a mass flow rate is prescribed.
The parameter <code>from_dp</code> is set to either <code>true</code> or <code>false</code>.
These combinations are applied to a flow network
consisting of parallel, series or parallel-series components.
By looking at the size of the nonlinear equations between the example
and its counter-part that ends in <code>Optimised</code>,
one can see whether the
symbolic processing optimally converts the system of equations.
</p>
</html>"));
end PressureDrop;
