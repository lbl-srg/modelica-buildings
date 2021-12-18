within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.LoadAggregation;
impure function temperatureResponseMatrix
  "Reads and possibly writes a matrix with a time series of the borefield's temperature response"
  extends Modelica.Icons.Function;

  input Integer nBor "Number of boreholes";
  input Real cooBor[nBor, 2] "Borehole coordinates";
  input Modelica.Units.SI.Height hBor "Borehole length";
  input Modelica.Units.SI.Height dBor "Borehole buried depth";
  input Modelica.Units.SI.Radius rBor "Borehole radius";
  input Modelica.Units.SI.ThermalDiffusivity aSoi "Thermal diffusivity of soil";
  input Modelica.Units.SI.ThermalConductivity kSoi
    "Thermal conductivity of soil";
  input Integer nSeg "Number of line source segments per borehole";
  input Integer nTimSho "Number of time steps in short time region";
  input Integer nTimLon "Number of time steps in long time region";
  input Integer nTimTot "Number of g-function points";
  input Real ttsMax "Maximum non-dimensional time for g-function calculation";
  input String sha "SHA-1 encryption of the g-function arguments";
  input Boolean forceGFunCalc
    "Set to true to force the thermal response to be calculated at the start";

  output Modelica.Units.SI.ThermalResistance TStep[nTimTot,2]
    "Temperature step-response time series";

protected
  String pathSave "Path of the folder used to save the g-function";
  Modelica.Units.SI.Time[nTimTot] tGFun "g-function evaluation times";
  Real[nTimTot] gFun "g-function vector";
  Boolean writegFun = false "True if g-function was succesfully written to file";

algorithm
  pathSave := "tmp/temperatureResponseMatrix/" + sha + "TStep.mat";

  if forceGFunCalc or not Modelica.Utilities.Files.exist(pathSave) then
    (tGFun,gFun) :=
      Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer.ThermalResponseFactors.gFunction(
      nBor=nBor,
      cooBor=cooBor,
      hBor=hBor,
      dBor=dBor,
      rBor=rBor,
      aSoi=aSoi,
      nSeg=nSeg,
      nTimSho=nTimSho,
      nTimLon=nTimLon,
      ttsMax=ttsMax);

    for i in 1:nTimTot loop
      TStep[i,1] := tGFun[i];
      TStep[i,2] := gFun[i]/(2*Modelica.Constants.pi*hBor*nBor*kSoi);
    end for;

    //creation of a temporary folder in the simulation folder
    Modelica.Utilities.Files.createDirectory("tmp");
    Modelica.Utilities.Files.createDirectory("tmp/temperatureResponseMatrix");

    writegFun := Modelica.Utilities.Streams.writeRealMatrix(
      fileName=pathSave,
      matrixName="TStep",
      matrix=TStep,
      append=false);
  end if;

  TStep := Modelica.Utilities.Streams.readRealMatrix(
    fileName=pathSave,
    matrixName="TStep",
    nrow=nTimTot,
    ncol=2);

  annotation (Documentation(info="<html>
<p>
This function uses the parameters required to calculate the borefield's thermal
response to build a SHA1-encrypted string unique to the borefield in question.
Then, if the <code>forceGFunCalc</code> input is <code>true</code> or if
there is no <code>.mat</code> file with the SHA1 hash as its filename in the
<code>tmp/temperatureResponseMatrix</code> folder,
the thermal response will be calculated and written as a
<code>.mat</code> file. Otherwise, the
thermal response will simply be read from the
<code>.mat</code> file. In the <code>.mat</code> file, the data
is saved in a matrix with the name <code>TStep</code>, where the first column is
the time (in seconds) and the second column is the temperature step response,
which is the g-function divided by <i>2 &pi; H k<sub>soi</sub></i>, with
<code>H</code> being the borehole length and <i>k<sub>soi</sub></i> being the thermal
conductivity of the soil.
</p>
</html>", revisions="<html>
<ul>
<li>
December 11, 2021, by Michael Wetter:<br/>
Added <code>impure</code> declaration for MSL 4.0.0.
</li>
<li>
August 27, 2018, by Michael Wetter:<br/>
Changed name of temporary directory so that it is clear for users
that this is a temporary directory.
</li>
<li>
July 15, 2018, by Michael Wetter:<br/>
Changed implementation to use matrix read and write from
the Modelica Standard Library.
</li>
<li>
March 5, 2018, by Alex Laferri&egrave;re:<br/>
First implementation.
</li>
</ul>
</html>"));
end temperatureResponseMatrix;
