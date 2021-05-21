within Buildings.BoundaryConditions.GroundTemperature.BaseClasses;
function surfaceTemperature
  "Calculate surface temperature based on climatic constants and n-factors"
  extends Modelica.Icons.Function;

  input ClimaticConstants.Generic cliCon;
  input Real nFacTha;
  input Real nFacFre;
  output ClimaticConstants.Generic corCliCon;

protected
  constant Integer Year=365 "Year period in days";
  constant Modelica.SIunits.Angle pi = Modelica.Constants.pi;
  constant Modelica.SIunits.Temperature TFre = 273.15 "Freezing temperature of water";
  Real freq = 2 * pi / Year "Year frequency in rad/days";
  Modelica.SIunits.Temperature TAirDayMea[Year] "Daily mean air temperature (surface = 0 from uncorrected climatic constants)";
  Modelica.SIunits.Temperature TSurDayMea[Year] "Daily mean corrected surface temperature";
  Real C1;
  Real C2;
  Modelica.SIunits.Temperature TSurMea;

algorithm
  // Analytical mean by integrating undisturbed soil temperature formula
  TAirDayMea := {cliCon.TSurMea + cliCon.TSurAmp / freq * (
    cos(freq * (cliCon.sinPhaDay - day)) -
    cos(freq * (cliCon.sinPhaDay - (day + 1))))
    for day in 1:Year};

  TSurDayMea := {
    if T > TFre
    then (TFre + (T - TFre) * nFacTha)
    else (TFre + (T - TFre) * nFacFre)
    for T in TAirDayMea};
  TSurMea := sum(TSurDayMea)/Year;
  C1 := sum({TSurDayMea[day] * cos(freq * day) for day in 1:Year});
  C2 := sum({TSurDayMea[day] * sin(freq * day) for day in 1:Year});

  corCliCon := ClimaticConstants.Generic(
    TSurMea = TSurMea,
    TSurAmp = 2 / Year .* (C1^2 + C2^2)^0.5,
    sinPhaDay = (Modelica.Math.atan(C2 / C1) + pi/2) / freq);

end surfaceTemperature;
