within Buildings.Electrical.Transmission.Functions;
function computeGMR
  input Modelica.SIunits.Length d;
  input Integer N = 1;
  output Modelica.SIunits.Length GMR;
algorithm
  GMR :=0.5*d*0.7788;
annotation(Inline = true);
end computeGMR;
