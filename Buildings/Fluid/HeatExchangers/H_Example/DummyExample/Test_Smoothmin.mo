within Buildings.Fluid.HeatExchangers.H_Example.DummyExample;
model Test_Smoothmin
  extends Modelica.Icons.Example;
  Real x= 2*Modelica.Math.cos(2*Modelica.Constants.pi*time);
  Real y1,y2,y;
  parameter Real deltax=0.5;
  parameter Real deltay=0.1;
equation
  y1=1;
  y2=(x/deltax)^2;
  y=Buildings.Utilities.Math.Functions.smoothMin(y1,y2,deltay);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(__Dymola_NumberOfIntervals=50000, __Dymola_Algorithm="Dassl"));
end Test_Smoothmin;
