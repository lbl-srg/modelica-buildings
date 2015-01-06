within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Scripts;
function saveAggregationMatrix
  extends Aggregation.Interface.partialAggFunction;

  input Data.Records.Soil soi "Thermal properties of the ground";
  input Data.Records.General gen "General charachteristic of the borefield";
  input Data.Records.Filling fil "Thermal properties of the filling material";

  input Integer lenSim "Simulation length ([s]). By default = 100 days";

  output Real[q_max,p_max] kappaMat "Transient resistance for each cell";
  output Integer[q_max] rArr=
      Borefield.BaseClasses.Aggregation.BaseClasses.cellWidth(q_max=q_max,
      p_max=p_max) "Width of aggregation cells for each level";
  output Integer[q_max,p_max] nuMat=
      Borefield.BaseClasses.Aggregation.BaseClasses.nbPulseAtEndEachLevel(
      q_max=q_max,
      p_max=p_max,
      rArr=rArr) "Number of aggregated pulses at end of each aggregation cell";
  output Modelica.SIunits.Temperature TWallSteSta
    "Quasi steady state temperature";

  output Real[1,gen.tBre_d + 1] TResSho
    "Short term response temperature vector of the borefield obtained calling the model IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Examples.SingleBoreHoleSerStepLoadScript";
  output String sha "Pseudo SHA code (unique code) of the record soi and gen";

  output Boolean existShoTerRes
    "True if the short term response has already been calculated and stored in the simulation folder";

  output Boolean existAgg
    "True if the aggregation matrix has already been calculated and stored in the simulation folder";
  output Boolean writeTWallSteSta
    "True if the variable TWallSteSta is written in the simulation folder";
  output Boolean writeAgg
    "True if the aggregation matrix is written in the simulation folder";

protected
  String pathSave "Path of the saving folder";
  Real[1,1] mat;
algorithm
  // --------------- Generate SHA-code and path
  sha := shaBorefieldRecords(
    soiPath=Modelica.Utilities.Strings.replace(
      soi.pathCom,
      "\\",
      "/"), filPath=Modelica.Utilities.Strings.replace(
      fil.pathCom,
      "\\",
      "/"),genPath=Modelica.Utilities.Strings.replace(
      gen.pathCom,
      "\\",
      "/"));

 //creation of a folder .BfData in the simulation folder
  Modelica.Utilities.Files.createDirectory(".BfData");

  pathSave := ".BfData/" + sha;

  // --------------- Check if the short term response (TResSho) needs to be calculated or loaded
  if not Modelica.Utilities.Files.exist(pathSave + "ShoTermData.mat") then
    existShoTerRes := false;
  else
    existShoTerRes := true;
  end if;

  assert(existShoTerRes, " \n
************************************************************************************************************************ \n 
The borefield model with this BfData record has not yet been initialized. Please firstly run the following command in the command log: \n"
     + "Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Scripts.initializeModel("
     + "soi=" + soi.pathMod + "(), " + "fil="
     + fil.pathMod + "()," + "gen=" + gen.pathMod + "())" + "\n
************************************************************************************************************************ \n ");

  TResSho := readMatrix(
    fileName=pathSave + "ShoTermData.mat",
    matrixName="TResSho",
    rows=1,
    columns=gen.tBre_d + 1);

  // --------------- Check if the aggregation matrix kappaMat and the steady state temperature (TWallSteSta) need to be calculated or loaded
  if not existShoTerRes or not Modelica.Utilities.Files.exist(pathSave + "Agg" +
      String(lenSim) + ".mat") then
    existAgg := false;

    TWallSteSta := GroundHX.correctedBoreFieldWallTemperature(
      gen=gen,
      soi=soi,
      TResSho=TResSho[1, :],
      t_d=gen.tSteSta_d);

    kappaMat := Borefield.BaseClasses.Aggregation.transientFrac(
      q_max=q_max,
      p_max=p_max,
      gen=gen,
      soi=soi,
      TResSho=TResSho[1, :],
      nuMat=nuMat,
      TWallSteSta=TWallSteSta);

    writeTWallSteSta := writeMatrix(
      fileName=pathSave + "TWallSteSta.mat",
      matrixName="TWallSteSta",
      matrix={{TWallSteSta}},
      append=false);
    writeAgg := writeMatrix(
      fileName=pathSave + "Agg" + String(lenSim) + ".mat",
      matrixName="kappaMat",
      matrix=kappaMat,
      append=false);
    mat := {{1}};
  else
    existAgg := true;
    writeAgg := false;

    mat := readMatrix(
      fileName=pathSave + "TWallSteSta.mat",
      matrixName="TWallSteSta",
      rows=1,
      columns=1);
    TWallSteSta := mat[1, 1];

    kappaMat := readMatrix(
      fileName=pathSave + "Agg" + String(lenSim) + ".mat",
      matrixName="kappaMat",
      rows=q_max,
      columns=p_max);
  end if;

    annotation (Documentation(info="<html>
    <p>  This function calculates aggregation matrix and the steady state temperature of a simulation with given simulation length (lenSim) with given borefield parameters 
    and saves it in a hidden folder C:\.BfData\ for windows and C:\.tmp\ for Linux.</p>
    <p> Firstly, a SHA-code of the records soi, fil and gen are computed and summed by the function shaBorefieldRecords. The algorithm checks then if aggregation matrix already
    exists for these parameters and this simulation length in the temperory file. If not, the aggregation matrix and the steady state temperature are calculated using the function
    Borefield.BaseClasses.Aggregation.transientFrac and GroundHX.CorrectedBoreFieldWallTemperature and saved under the name SHA+Agg or TWallSteSta+lenSim+.mat.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end saveAggregationMatrix;
