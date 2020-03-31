within Buildings.Fluid.HeatExchangers.CoolingTowers.Correlations;
function yorkCalc "Cooling tower performance correlation for YorkCalc model"

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
  constant Real c[:] = {-0.359741205, -0.055053608,  0.0023850432,
                      0.173926877, -0.0248473764,  0.00048430224,
                      -0.005589849456,  0.0005770079712, -0.00001342427256,
                      2.84765801111111, -0.121765149,  0.0014599242,
                      1.680428651, -0.0166920786, -0.0007190532,
                     -0.025485194448,  0.0000487491696,  0.00002719234152,
                     -0.0653766255555556, -0.002278167,  0.0002500254,
                     -0.0910565458,  0.00318176316,  0.000038621772,
                     -0.0034285382352,  0.00000856589904, -0.000001516821552}
    "Polynomial coefficients";

algorithm
  TWetBul_degC :=Modelica.Units.Conversions.to_degC(TWetBul);
  // smoothMax is added to the numerator and denominator so that
  // liqGasRat -> 1, as both FRWat -> 0 and FRAir -> 0
  liqGasRat := Buildings.Utilities.Math.Functions.smoothMax(x1=1E-4, x2=FRWat, deltaX=1E-5)/
               Buildings.Utilities.Math.Functions.smoothMax(x1=1E-4, x2=FRAir, deltaX=1E-5);
  TApp := c[1] +
       c[2] * TWetBul_degC +
       c[3] * TWetBul_degC * TWetBul_degC +
       c[4] * TRan +
       c[5] * TWetBul_degC * TRan +
       c[6] * TWetBul_degC * TWetBul_degC * TRan +
       c[7] * TRan * TRan +
       c[8] * TWetBul_degC * TRan * TRan +
       c[9] * TWetBul_degC * TWetBul_degC * TRan * TRan +
       c[10] * liqGasRat +
       c[11] * TWetBul_degC * liqGasRat +
       c[12] * TWetBul_degC * TWetBul_degC * liqGasRat +
       c[13] * TRan * liqGasRat +
       c[14] * TWetBul_degC * TRan * liqGasRat +
       c[15] * TWetBul_degC * TWetBul_degC * TRan * liqGasRat +
       c[16] * TRan * TRan * liqGasRat +
       c[17] * TWetBul_degC * TRan * TRan * liqGasRat +
       c[18] * TWetBul_degC * TWetBul_degC * TRan * TRan * liqGasRat +
       c[19] * liqGasRat * liqGasRat +
       c[20] * TWetBul_degC * liqGasRat * liqGasRat +
       c[21] * TWetBul_degC * TWetBul_degC * liqGasRat * liqGasRat +
       c[22] * TRan * liqGasRat * liqGasRat +
       c[23] * TWetBul_degC * TRan * liqGasRat * liqGasRat +
       c[24] * TWetBul_degC * TWetBul_degC * TRan * liqGasRat * liqGasRat +
       c[25] * TRan * TRan * liqGasRat * liqGasRat +
       c[26] * TWetBul_degC * TRan * TRan * liqGasRat * liqGasRat +
       c[27] * TWetBul_degC * TWetBul_degC * TRan * TRan * liqGasRat * liqGasRat;
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
end yorkCalc;
