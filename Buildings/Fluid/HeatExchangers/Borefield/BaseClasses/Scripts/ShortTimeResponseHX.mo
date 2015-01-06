within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Scripts;
function shortTimeResponseHX
  /* Remark: by calling the function, 3 "true" should appear for: \
      1) translation of model \
      2) simulation of model \
      3) writing the data \
      If you get a false, look for the error!
    */
  extends Modelica.Icons.Function;

  input Data.Records.Soil soi=Data.SoilData.SandStone()
    "Thermal properties of the ground";

  input Data.Records.Filling fil=Data.FillingData.Bentonite()
    "Thermal properties of the filling material";

  input Data.Records.General gen=Data.GeneralData.c8x1_h110_b5_d3600_T283()
    "General charachteristic of the borefield";

  input String pathSave "Save path for the result file";

  output Real[1,gen.tBre_d + 1] TResSho "Short-term temperature vector";
  output Real[2,gen.tBre_d + 1] readData
    "Matrix with the time and the Short-term temperature vectors";

protected
  final parameter String modelToSimulate="Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.Examples.SingleBoreHoleSerStepLoadScript"
    "model to simulate";

  String[1] varToStore={"borHolSer.TWallAve"}
    "variables to store in result file";
  Modelica.SIunits.Time[1,gen.tBre_d + 1] timVec={0:gen.tStep:gen.tBre_d*gen.tStep}
    "time vector for which the data are saved";
  String[2] saveName={"Time",varToStore[1]};

algorithm
  //To ensure that the same number of data points is written in all result files
  //equidistant time grid is enabled and store variables at events is disabled.
  experimentSetupOutput(equdistant=true, events=false) annotation(__Dymola_interactive=true);

  simulateModel(
    modelToSimulate+"( soi=" + soi.pathMod + "(), " +
    "fil=" + fil.pathMod + "()," +
    "gen=" + gen.pathMod + "())",
    stopTime=gen.tBre_d*gen.tStep,
    numberOfIntervals=gen.tBre_d + 1,
    method="dassl",
   resultFile=pathSave + "_sim") annotation(__Dymola_interactive=true);

  // First columns are shorttime, last column is steady state
    readData := cat(
      1,
      timVec,
      interpolateTrajectory(
        pathSave + "_sim.mat",
        varToStore,
        timVec[1, :])) annotation(__Dymola_interactive=true);

    TResSho[1,:] :=readData[2, 1:end] annotation(__Dymola_interactive=true);

    writeMatrix(
        fileName=pathSave + "ShoTermData.mat", matrixName="TResSho", matrix=TResSho, append=false) annotation(__Dymola_interactive=true);

    annotation (Documentation(info="<html>
    <p>  This function simulates the model <code>Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.BoreHoles.Examples.SingleBoreHoleSerStepLoadScript</code> in order to calculate the short 
    term response of the borefield. The borefield wall temperature are saved in the mat file <i> ShoTermData</i>. </p>
</html>", revisions="<html>
<ul>
<li>
January 2015, by Damien Picard:<br>
Add documentation.
</li>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end shortTimeResponseHX;
