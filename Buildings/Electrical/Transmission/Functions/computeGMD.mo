within Buildings.Electrical.Transmission.Functions;
function computeGMD
  input Modelica.SIunits.Length d1;
  input Modelica.SIunits.Length d2 = d1;
  input Modelica.SIunits.Length d3 = 2*d1;
  output Modelica.SIunits.Length GMD;
algorithm
  GMD := (d1*d2*d3)^(1.0/3.0);
end computeGMD;
