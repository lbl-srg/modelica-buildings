within Buildings.Electrical.Transmission.Functions;
function computeGMD
  "This function computes the geometric mean distance of a 3-phase transmission line"
  input Modelica.SIunits.Length d1 "Distance between conductors";
  input Modelica.SIunits.Length d2 = d1 "Distance between conductors";
  input Modelica.SIunits.Length d3 = 2*d1 "Distance between conductors";
  output Modelica.SIunits.Length GMD "Geometric Mean Distance";
algorithm
  GMD := (d1*d2*d3)^(1.0/3.0);
annotation(Inline = true);
end computeGMD;
