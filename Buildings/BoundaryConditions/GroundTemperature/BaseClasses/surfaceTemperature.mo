within Buildings.BoundaryConditions.GroundTemperature.BaseClasses;
function surfaceTemperature
  "Function to correct the climatic constants using <i>n</i>-factors"
  extends Modelica.Icons.Function;

  input ClimaticConstants.Generic cliCon
    "Surface temperature climatic conditions";
  input Real nFacTha "Thawing n-factor (TAir > 0degC)";
  input Real nFacFre "Freezing n-factor (TAir <= 0degC)";
  output ClimaticConstants.Generic corCliCon
    "Corrected surface temperature climatic conditions";

protected
  constant Integer Year=365 "Year period in days";
  constant Integer secInDay = 24 * 60 * 60 "Seconds in a day";
  constant Modelica.SIunits.Angle pi = Modelica.Constants.pi;
  constant Modelica.SIunits.Temperature TFre = 273.15 "Freezing temperature of water";
  Real freq = 2 * pi / Year "Year frequency in rad/days";
  Modelica.SIunits.Temperature TAirDayMea[Year] "Daily mean air temperature (surface = 0 from uncorrected climatic constants)";
  Modelica.SIunits.Temperature TSurDayMea[Year] "Daily mean corrected surface temperature";
  Real C1;
  Real C2;

algorithm
  // Analytical mean by integrating undisturbed soil temperature formula
  TAirDayMea := {cliCon.TSurMea + cliCon.TSurAmp / freq * (
    cos(freq * (cliCon.sinPha / secInDay - day)) -
    cos(freq * (cliCon.sinPha / secInDay - (day + 1))))
    for day in 1:Year};

  TSurDayMea := {
    if TAirDayMea[day] > TFre
    then (TFre + (TAirDayMea[day] - TFre) * nFacTha)
    else (TFre + (TAirDayMea[day] - TFre) * nFacFre)
    for day in 1:Year};
  C1 := sum({TSurDayMea[day] * cos(freq * day) for day in 1:Year});
  C2 := sum({TSurDayMea[day] * sin(freq * day) for day in 1:Year});

  corCliCon := ClimaticConstants.Generic(
    TSurMea = sum(TSurDayMea)/Year,
    TSurAmp = 2 / Year .* (C1^2 + C2^2)^0.5,
    sinPha = (Modelica.Math.atan(C2 / C1) + pi/2) * secInDay / freq);

  annotation (Documentation(revisions="<html>
<ul>
<li>
May 19, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This function corrects the surface temperature climatic constants
by applying <i>n</i>-factors with the methodology prescribed in the
<i>District Cooling Guide</i> (ASHRAE, 2013).
</p>
<p>
<i>n</i>-factors corresponds to the ratio of freezing (/thawing) degree
days or index between the air and the ground surface and can
be used to couple the air and ground surface temperatures.<br>
For example, a freezing <i>n</i>-factor of 1.35 means that during the
freezing season, the daily average ground surface temperature is
on average 1.35 times colder than the air (using the freezing
temperature of water as a reference).<br>
In its guide, ASHRAE suggests to first apply the <i>n</i>-factors to the
uncorrected ground temperature at zero burial depth, and to fit a
new sinusoidal curve to the result.
<br>
In this function, the freezing <i>n</i>-factor is applied to days where
the daily mean air temperature is below the freezing temperature (0degC),
whereas the thawing <i>n</i>-factor is applied to the remaining days.
</p>
<p align=\"center\" style=\"font-style:italic;\">
  T<sub>ground</sub> - T<sub>freezing</sub> = &eta;<sub>freezing</sub> * (T<sub>air</sub> - T<sub>freezing</sub>) &nbsp; if T<sub>air</sub> &lt;= T<sub>freezing</sub><br>
  T<sub>ground</sub> - T<sub>freezing</sub> = &eta;<sub>thawing</sub> * (T<sub>air</sub> - T<sub>freezing</sub>) &nbsp;  if T<sub>air</sub> &gt; T<sub>freezing</sub>
</p>
<p>
The sinusoidal curve is then fitted using the analytical solution
proposed in Appendix B of the District Heating Guide.
</p>
<p>
<i>n</i>-factors are specific to a climate and surface cover, and should be
extrapolated from other sites with caution. As a first approximation,
tabulated values of <i>n</i>-factors are available in Lunardini (1981) and
Freitag and McFadden (1997).
</p>


<h4>References</h4>
<p>
ASHRAE (2013). <i>District Cooling Guide</i>. ASHRAE, Atlanta, GA.<br>
ASHRAE (2013). <i>District Heating Guide</i>. ASHRAE, Atlanta, GA.<br>
D.W. Riseborough (2003). <i>Thawing and freezing indices in the active layer</i>. Proceedings of the 8th International Conference on Permafrost, Swets &amp; Zeitlinger.<br>
V.J. Lunardini (1981). <i>Heat Transfer in Cold Climates</i>. Van Nostrand Reinhold Company.<br>
D.R. Freitag and T. McFadden (1997). <i>Introduction to Cold Regions Engineering</i>. American Society of Civil Engineers.

</p>

</html>"));
end surfaceTemperature;
