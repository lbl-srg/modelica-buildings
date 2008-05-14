function yorkCalc "Cooling tower performance correlation for YorkCalc model" 
  
  input Modelica.SIunits.Temperature TRan 
    "Range temperature (water in - water out)" 
      annotation (Dialog(group="Nominal condition"));
  input Modelica.SIunits.Temperature TWB "Air wet-bulb inlet temperature";
  input Modelica.SIunits.MassFraction FRWat 
    "Ratio actual over design water mass flow ratio";
  input Modelica.SIunits.MassFraction FRAir 
    "Ratio actual over design air mass flow ratio";
  
  output Modelica.SIunits.Temperature TApp "Approach temperature";
  
protected 
  Modelica.SIunits.CelsiusTemperature TWB_degC "Air wet-bulb inlet temperature";
  Modelica.SIunits.MassFraction liqGasRat "Liquid to gas mass flow ratio";
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
  TWB_degC :=Modelica.SIunits.Conversions.to_degC(TWB);
  liqGasRat := FRWat/FRAir;
  TApp := c[1] +
       c[2] * TWB_degC +
       c[3] * TWB_degC * TWB_degC +
       c[4] * TRan +
       c[5] * TWB_degC * TRan +
       c[6] * TWB_degC * TWB_degC * TRan +
       c[7] * TRan * TRan +
       c[8] * TWB_degC * TRan * TRan +
       c[9] * TWB_degC * TWB_degC * TRan * TRan +
       c[10] * liqGasRat +
       c[11] * TWB_degC * liqGasRat +
       c[12] * TWB_degC * TWB_degC * liqGasRat +
       c[13] * TRan * liqGasRat +
       c[14] * TWB_degC * TRan * liqGasRat +
       c[15] * TWB_degC * TWB_degC * TRan * liqGasRat +
       c[16] * TRan * TRan * liqGasRat +
       c[17] * TWB_degC * TRan * TRan * liqGasRat +
       c[18] * TWB_degC * TWB_degC * TRan * TRan * liqGasRat +
       c[19] * liqGasRat * liqGasRat +
       c[20] * TWB_degC * liqGasRat * liqGasRat +
       c[21] * TWB_degC * TWB_degC * liqGasRat * liqGasRat +
       c[22] * TRan * liqGasRat * liqGasRat +
       c[23] * TWB_degC * TRan * liqGasRat * liqGasRat +
       c[24] * TWB_degC * TWB_degC * TRan * liqGasRat * liqGasRat +
       c[25] * TRan * TRan * liqGasRat * liqGasRat +
       c[26] * TWB_degC * TRan * TRan * liqGasRat * liqGasRat +
       c[27] * TWB_degC * TWB_degC * TRan * TRan * liqGasRat * liqGasRat;
end yorkCalc;
