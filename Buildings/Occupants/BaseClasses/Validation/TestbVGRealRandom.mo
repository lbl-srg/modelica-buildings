within Buildings.Occupants.BaseClasses.Validation;
model TestbVGRealRandom
  extends Modelica.Icons.Example;

  Real p "Time-varying real number as input";
  output Real y "Output";

equation
  p = time;
  if Buildings.Occupants.BaseClasses.bVGRealRandom(p) then
    y = 1;
  else
    y = 0;
  end if;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TestbVGRealRandom;
