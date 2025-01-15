within Buildings.Fluid.Movers.BaseClasses.Characteristics;
function efficiency_yMot
  "Efficiency vs. motor PLR characteristics for fan or pump"
  extends Modelica.Icons.Function;
  input
    Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiencyParameters_yMot
    per "Efficiency performance data";
  input Real y "Motor part load ratio, y = PEle/PEle_nominal";
  input Real d[:] "Derivatives at support points for spline interpolation";
  output Real eta(unit="1", final quantity="Efficiency") "Efficiency";

protected
  Integer n = size(per.y, 1) "Number of data points";
  Integer i "Integer to select data interval";
algorithm
  if n == 1 then
    eta := per.eta[1];
  else
    i :=1;
    for j in 1:n-1 loop
       if y > per.y[j] then
         i := j;
       end if;
    end for;
    // Extrapolate or interpolate the data
    eta:=Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
                x=y,
                x1=per.y[i],
                x2=per.y[i + 1],
                y1=per.eta[i],
                y2=per.eta[i + 1],
                y1d=d[i],
                y2d=d[i+1]);
  end if;

  annotation(smoothOrder=1,
              Documentation(info="<html>
<p>
This function is similar to
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiency\">
Buildings.Fluid.Movers.BaseClasses.Characteristics.efficiency</a>,
but takes the motor part load ratio
<i>y=P<sub>ele</sub> &frasl; P<sub>ele,nominal</sub></i>
instead of volumetric flow rate <i>V&#775;</i> as input
and does not consider the speed of the mover.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 2, 2022, by Hongxiang Fu:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2668\">#2668</a>.
</li>
</ul>
</html>"));
end efficiency_yMot;
