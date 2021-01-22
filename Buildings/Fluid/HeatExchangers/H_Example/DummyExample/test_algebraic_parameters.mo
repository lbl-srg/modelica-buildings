within Buildings.Fluid.HeatExchangers.H_Example.DummyExample;
model test_algebraic_parameters

  parameter Real a=1;
  parameter Real b(fixed=false);

  input Real x(start=1);
  output Real y;
initial equation
  a+b=0; //g(a,b)=0
equation
  y=a*b*x;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end test_algebraic_parameters;
