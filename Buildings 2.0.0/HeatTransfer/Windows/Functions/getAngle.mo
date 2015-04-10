within Buildings.HeatTransfer.Windows.Functions;
function getAngle "Generate incident angles"
  input Integer NDIR "Number of incident angles";
  output Modelica.SIunits.Angle psi[NDIR] "Array of incident angles";

protected
  constant Real deltaX=0.5*Modelica.Constants.pi/(NDIR - 1);

algorithm
  for i in 1:NDIR loop
    psi[i] := (i - 1)*deltaX;
  end for;

  annotation (Documentation(info="<html>
<p>
This function computes discrete incident angles for the window radiation calculation. The range is from 0 to 90 degree.
</p>
</html>", revisions="<html>
<ul>
<li>
August 29, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end getAngle;
