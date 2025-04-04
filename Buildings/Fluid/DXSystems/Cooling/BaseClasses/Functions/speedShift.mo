within Buildings.Fluid.DXSystems.Cooling.BaseClasses.Functions;
function speedShift "Interpolates value between two speeds"
  //x in cubic Hermite function
  input Real spe "Speed of compressor";
  //x1, x2  in cubic Hermite function
  input Real speSet[:] "Array of standard compressor speeds";
  //y1, y2 in cubic Hermite function
  input Real u[:] "Array to be interpolated";
  output Real y "Interpolated value";
protected
  Integer n= size(u,1)+1 "Number of elements in modified array";
  Real derv[n] "deriative";
  Integer i=1 "Integer to select data interval";
  Real modSpeSet[n] "Speed set with origin";
  Real modU[n];
algorithm
    //y1d, y2d in cubic Hermite function
    modSpeSet:= cat(1, {0.00}, speSet);
    modU     := cat(1, {0.00}, u);
    //Derivatives at standard speeds
    derv     := Buildings.Utilities.Math.Functions.splineDerivatives(
                   x=modSpeSet,
                   y=modU,
                   ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(x=modU,
                                                                                     strict=false));
    //locate the range between which compressor operates
    for j in 1:size(modSpeSet, 1) - 1 loop
      if spe > modSpeSet[j] then
        i :=j;
      end if;
    end for;
    y :=Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
      x=spe,
      x1=modSpeSet[i],
      x2=modSpeSet[i + 1],
      y1=modU[i],
      y2=modU[i + 1],
      y1d=derv[i],
      y2d=derv[i + 1]);
  annotation (smoothOrder=1,
Documentation(info="<html>
<p>
This function interpolates data for intermediate compressor speeds
using cubic hermite splines with linear extrapolation.
To avoid linear extrapolation below minimum standard speed,
the origin is added to the modified arrays.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 24, 2012, by Michael Wetter:<br/>
Moved function from
<code>Buildings.Fluid.DXSystems.BaseClasses</code>
to
<code>Buildings.Fluid.DXSystems.Cooling.BaseClasses.Functions</code>
because the package
<code>Buildings.Fluid.DXSystems.BaseClasses</code>
already contains a block called
<code>SpeedShift</code> which gives a clash in file names on file systems
that do not distinguish between upper and lower case letters.
</li>
<li>
August 9, 2012, by Kaustubh Phalak:<br/>
Origin added in support points to avoid linear extrapolation below standard rotational speed.
</li>
<li>
August 1, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"));
end speedShift;
