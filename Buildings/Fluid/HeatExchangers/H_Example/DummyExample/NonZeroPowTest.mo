within Buildings.Fluid.HeatExchangers.H_Example.DummyExample;
model NonZeroPowTest
  extends Modelica.Icons.Example;
  Real x;
  Real y;
equation
  x=Modelica.Math.cos(2*Modelica.Constants.pi/1*time);
  y=Buildings.Utilities.Math.Functions.regNonZeroPower(x=x,n=1,delta=0.1);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end NonZeroPowTest;
