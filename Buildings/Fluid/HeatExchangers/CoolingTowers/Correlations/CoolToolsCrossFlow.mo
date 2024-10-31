within Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations;
function CoolToolsCrossFlow
  "Cooling tower performance correlation for CoolTools model"

  input Modelica.Units.SI.TemperatureDifference TRan
    "Range temperature (water in - water out)"
    annotation (Dialog(group="Nominal condition"));
  input Modelica.Units.SI.Temperature TWetBul "Air wet-bulb inlet temperature";
  input Modelica.Units.SI.MassFraction FRWat
    "Ratio actual over design water mass flow ratio";
  input Modelica.Units.SI.MassFraction FRAir
    "Ratio actual over design air mass flow ratio";

  output Modelica.Units.SI.TemperatureDifference TApp "Approach temperature";

protected
  Modelica.Units.NonSI.Temperature_degC TWetBul_degC
    "Air wet-bulb inlet temperature";
  Modelica.Units.SI.MassFraction liqGasRat "Liquid to gas mass flow ratio";
  constant Real c[:] = {0.52049709836241, -10.617046395344, 10.7292974722538,
                -2.74988377158227, 4.73629943913743, -8.25759700874711,
                1.57640938114136, 6.51119643791324, 1.50433525206692,
                -3.2888529287801, 0.0257786145353773, 0.182464289315254,
                -0.0818947291400898, -0.215010003996285, 0.0186741309635284,
                0.0536824177590012, -0.00270968955115031, 0.00112277498589279,
                -0.00127758497497718, 0.0000760420796601607, 1.43600088336017,
                -0.5198695909109, 0.117339576910507, 1.50492810819924,
                -0.135898905926974, -0.152577581866506, -0.0533843828114562,
                0.00493294869565511, -0.00796260394174197, 0.000222619828621544,
                -0.0543952001568055, 0.00474266879161693, -0.0185854671815598,
                0.00115667701293848, 0.000807370664460284}
    "Polynomial coefficients";

algorithm
  TWetBul_degC :=Modelica.Units.Conversions.to_degC(TWetBul);
  // smoothMax is added to the numerator and denominator so that
  // liqGasRat -> 1, as both FRWat -> 0 and FRAir -> 0
  liqGasRat := Buildings.Utilities.Math.Functions.smoothMax(x1=1E-4, x2=FRWat, deltaX=1E-5)/
               Buildings.Utilities.Math.Functions.smoothMax(x1=1E-4, x2=FRAir, deltaX=1E-5);

TApp := c[1] +
      c[2] * FRAir +
      c[3] * FRAir * FRAir +
      c[4] * FRAir * FRAir * FRAir +
      c[5] * FRWat +
      c[6] * FRAir * FRWat +
      c[7] * FRAir * FRAir * FRWat +
      c[8] * FRWat * FRWat +
      c[9] * FRAir * FRWat * FRWat +
      c[10] * FRWat * FRWat * FRWat +
      c[11] * TWetBul_degC +
      c[12] * FRAir * TWetBul_degC +
      c[13] * FRAir * FRAir * TWetBul_degC +
      c[14] * FRWat * TWetBul_degC +
      c[15] * FRAir * FRWat * TWetBul_degC +
      c[16] * FRWat * FRWat * TWetBul_degC +
      c[17] * TWetBul_degC * TWetBul_degC +
      c[18] * FRAir * TWetBul_degC * TWetBul_degC +
      c[19] * FRWat * TWetBul_degC * TWetBul_degC +
      c[20] * TWetBul_degC * TWetBul_degC * TWetBul_degC +
      c[21] * TRan +
      c[22] * FRAir * TRan +
      c[23] * FRAir * FRAir * TRan +
      c[24] * FRWat * TRan +
      c[25] * FRAir * FRWat * TRan +
      c[26] * FRWat * FRWat * TRan +
      c[27] * TWetBul_degC * TRan +
      c[28] * FRAir * TWetBul_degC * TRan +
      c[29] * FRWat * TWetBul_degC * TRan +
      c[30] * TWetBul_degC * TWetBul_degC * TRan +
      c[31] * TRan * TRan +
      c[32] * FRAir * TRan * TRan +
      c[33] * FRWat * TRan * TRan +
      c[34] * TWetBul_degC * TRan * TRan +
      c[35] * TRan * TRan * TRan;
  annotation (
    Documentation(info="<html>
<p>
Correlation for approach temperature for YorkCalc cooling tower model.
See <a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.Examples.YorkCalc\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations.Examples.YorkCalc</a> for the graph.
</p>
</html>", revisions="<html>
<ul>
<li>
July 12, 2011, by Michael Wetter:<br/>
Added <code>smoothMax</code> function to prevent division by zero.
</li>
<li>
May 14, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
smoothOrder=5);
end CoolToolsCrossFlow;
