within Buildings.Electrical.Transmission.Functions;
function computeGMR
  "This function computes the geometric mean radius of a cable with 1 to 4 conductors"
  input Modelica.SIunits.Length d "Diameter of the conductor";
  input Integer N = 1 "Number of conductors";
  output Modelica.SIunits.Length GMR "Geometric Mean Radius";
algorithm

  if N==1 then
    GMR := 0.5*d*0.7788;
  elseif N==2 then
    GMR := sqrt(d);
  elseif N==3 then
    GMR := (d^2)^(1/3);
  elseif N==4 then
    GMR := 1.09*(d^3)^(1/4);
  else
    Modelica.Utilities.Streams.print("Error: the number of conductors N must be between 1 and 4 and it is" +
        String(N) + ". Selected default N=1.");
    GMR := 0.5*d*0.7788;
  end if;
annotation(Inline = true);
end computeGMR;
