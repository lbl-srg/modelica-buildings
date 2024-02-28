within Buildings.Fluid.SolarCollectors.BaseClasses;
function IAM "Function for incident angle modifier"

  input Modelica.Units.SI.Angle incAng "Incident angle";
  input Modelica.Units.SI.Angle[:] incAngDat "Incident angle data";
  input Real[size(incAngDat,1)] incAngModDat(final min=0, final max=1, final unit="1") "Incident angle modifier data";
  input Real[size(incAngDat,1)] dMonotone "Incident angle modifier spline derivatives";
  output Real incAngMod "Incident angle modifier coefficient";
protected
  Integer i "Counter to pick the interpolation interval";
  constant Real delta = 0.0001 "Width of the smoothing function";

algorithm
  i := 1;
  for j in 1:size(incAngDat, 1) - 1 loop
    if incAng > incAngDat[j] then
      i := j;
    end if;
  end for;
  // Extrapolate or interpolate the data and sets its value to 0 if
  // the incident angle modifier becomes negative.
  incAngMod := Buildings.Utilities.Math.Functions.smoothMax(
    x1 = Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
      x=incAng,
      x1=incAngDat[i],
      x2=incAngDat[i + 1],
      y1=incAngModDat[i],
      y2=incAngModDat[i + 1],
      y1d=dMonotone[i],
      y2d=dMonotone[i + 1]),
    x2 = 0,
    deltaX = delta);

  annotation (
  smoothOrder=1,
    Documentation(info="<html>
<h4>Overview</h4>
<p>
This function computes the incidence angle modifier for solar irradiation
striking the surface of the solar thermal collector.
It is calculated using cubic spline interpolation and
measurement data for the incident angle modifier provided in data sheets.
</p>

<h4>References</h4>
<p>
<a href=\"https://energyplus.net/assets/nrel_custom/pdfs/pdfs_v23.2.0/EngineeringReference.pdf\">
EnergyPlus 23.2.0 Engineering Reference</a>
</p>
</html>", revisions="<html>
<ul>
<li>
February 28, 2024, by Jelger Jansen:<br/>
Refactor model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3604\">Buildings, #3604</a>.
</li>
<li>
May 31, 2017, by Michael Wetter and Filip Jorissen:<br/>
Change limits for incident angle modifier to avoid dip in temperature
at shallow incidence angles.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/785\">issue 785</a>.
</li>
<li>
November 20, 2014, by Michael Wetter:<br/>
Added missing <code>protected</code> keyword.
</li>
<li>
May 22, 2012, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"));
end IAM;
