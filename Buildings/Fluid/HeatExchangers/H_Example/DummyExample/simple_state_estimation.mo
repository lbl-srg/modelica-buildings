within Buildings.Fluid.HeatExchangers.H_Example.DummyExample;
model simple_state_estimation
  Real x(start=0);
  Real y;
  Real tau=0.1;
  Real a;
  Real b;
equation
  y=1;
  a=-1/tau;
  b=-a;
  der(x)=a*x+b*y;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end simple_state_estimation;
