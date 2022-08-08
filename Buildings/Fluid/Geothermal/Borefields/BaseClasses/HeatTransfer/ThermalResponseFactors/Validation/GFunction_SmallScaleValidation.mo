within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.Validation;
model GFunction_SmallScaleValidation
  "g-Function calculation for the small scale validation case"
  extends Modelica.Icons.Example;

  parameter Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.Validation.BaseClasses.SmallScale_Borefield borFieDat
    "Record of borehole configuration data";
  parameter Integer nBor = borFieDat.conDat.nBor "Number of boreholes";
  parameter Modelica.Units.SI.Position cooBor[nBor,2]=borFieDat.conDat.cooBor
    "Coordinates of boreholes";
  parameter Modelica.Units.SI.Height hBor=borFieDat.conDat.hBor
    "Borehole length";
  parameter Modelica.Units.SI.Height dBor=borFieDat.conDat.dBor
    "Borehole buried depth";
  parameter Modelica.Units.SI.Radius rBor=borFieDat.conDat.rBor
    "Borehole radius";
  parameter Modelica.Units.SI.ThermalDiffusivity aSoi=borFieDat.soiDat.kSoi/(
      borFieDat.soiDat.dSoi*borFieDat.soiDat.cSoi)
    "Ground thermal diffusivity used in g-function evaluation";
  parameter Integer nSeg = 12 "Number of line source segments per borehole";
  parameter Integer nTimSho = 26 "Number of time steps in short time region";
  parameter Integer nTimLon = 50 "Number of time steps in long time region";
  parameter Real ttsMax = exp(5) "Maximum non-dimensional time for g-function calculation";

  final parameter Integer nTimTot=nTimSho+nTimLon;
  final parameter Real[nTimTot] gFun(each fixed=false);
  final parameter Real[nTimTot] lntts(each fixed=false);
  final parameter Modelica.Units.SI.Time[nTimTot] tGFun(each fixed=false);
  final parameter Real[nTimTot] dspline(each fixed=false);

  Real gFun_int "Interpolated value of g-function";
  Real lntts_int "Non-dimensional logarithmic time for interpolation";

  discrete Integer k "Current interpolation interval";
  discrete Modelica.Units.SI.Time t1 "Previous value of time for interpolation";
  discrete Modelica.Units.SI.Time t2 "Next value of time for interpolation";
  discrete Real gFun1 "Previous g-function value for interpolation";
  discrete Real gFun2 "Next g-function value for interpolation";
  parameter Modelica.Units.SI.Time ts=hBor^2/(9*aSoi)
    "Bore field characteristic time";

initial equation
  // Evaluate g-function for the specified bore field configuration
  (tGFun,gFun) =
    Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction(
      nBor = nBor,
      cooBor = cooBor,
      hBor = hBor,
      dBor = dBor,
      rBor = rBor,
      aSoi = aSoi,
      nSeg = nSeg,
      nTimSho = nTimSho,
      nTimLon = nTimLon,
      ttsMax = ttsMax);
  lntts = log(tGFun/ts .+ Modelica.Constants.small);
  // Initialize parameters for interpolation
  dspline = Buildings.Utilities.Math.Functions.splineDerivatives(
    x = tGFun,
    y = gFun);
  k = 1;
  t1 = tGFun[1];
  t2 = tGFun[2];
  gFun1 = gFun[1];
  gFun2 = gFun[2];

equation
  // Dimensionless logarithmic time
  lntts_int = log(Buildings.Utilities.Math.Functions.smoothMax(time, 1e-6, 2e-6)/ts);
  // Interpolate g-function
  gFun_int = Buildings.Utilities.Math.Functions.cubicHermiteLinearExtrapolation(
    x = time,
    x1 = t1,
    x2 = t2,
    y1 = gFun1,
    y2 = gFun2,
    y1d = dspline[pre(k)],
    y2d = dspline[pre(k)+1]);
  // Update interpolation parameters, when needed
  when time >= pre(t2) then
    k = min(pre(k) + 1, nTimTot);
    t1 = tGFun[k];
    t2 = tGFun[k+1];
    gFun1 = gFun[k];
    gFun2 = gFun[k+1];
  end when;

   annotation(experiment(Tolerance=1e-6, StopTime=1.8e+12),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/HeatTransfer/ThermalResponseFactors/Validation/GFunction_SmallScaleValidation.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This example checks the implementation of functions that evaluate the
g-function of the borehole used in the small-scale experiment of Cimmino and
Bernier (2015).
</p>
<h4>References</h4>
<p>
Cimmino, M. and Bernier, M. 2015. <i>Experimental determination of the
g-functions of a small-scale geothermal borehole</i>. Geothermics 56: 60-71.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 18, 2018, by Massimo Cimmino:<br/>
First implementation.
</li>
</ul>
</html>"));
end GFunction_SmallScaleValidation;
