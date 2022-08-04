within Buildings.Electrical.Transmission.Functions;
function computeGMR
  "This function computes the geometric mean radius of a cable with 1 to 4 conductors"
  input Modelica.Units.SI.Length d "Diameter of the conductor";
  input Integer N = 1 "Number of conductors";
  output Modelica.Units.SI.Length GMR "Geometric Mean Radius";
algorithm
  assert(N > 0 and N < 5,
    "The number of conductors N must be between 1 and 4, received N=" + String(N) + ".");
  if N==1 then
    GMR := 0.5*d*0.7788;
  elseif N==2 then
    GMR := sqrt(d);
  elseif N==3 then
    GMR := (d^2)^(1/3);
  else // N == 4
    GMR := 1.09*(d^3)^(1/4);
  end if;
annotation(Inline = true, Documentation(revisions="<html>
<ul>
<li>
June 3, 2014, by Marco Bonvini:<br/>
Added User's guide.
</li>
</ul>
</html>", info="<html>
<p>
This function computes the Geometric Mean Radius (GMR) of a cable.
</p>
<p>
The GMR is computed as follow, depending on the number of conductors <i>N</i>
that are part of the cable, and the diamater of the conductor <i>d</i>.
</p>

<table summary=\"equations\" border = \"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collape;\">
<tr><th>Equation</th><th>Condition</th></tr>
<tr>
<td>0.7788 (d/2) </td>
<td>N = 1</td>
</tr>
<!-- ************ -->
<tr>
<td>d<sup>1/2</sup></td>
<td>N = 2</td>
</tr>
<!-- ************ -->
<tr>
<td>d<sup>2/3</sup></td>
<td>N = 3</td>
</tr>
<!-- ************ -->
<tr>
<td>d<sup>2/3</sup></td>
<td>N = 4</td>
</tr>
<!-- ************ -->
</table>

</html>"));
end computeGMR;
