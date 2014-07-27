within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Scripts;
function saveAggregationMatrix
  extends Aggregation.Interface.partialAggFunction;

  input Data.Records.Soil soi "Thermal properties of the ground";
  input Data.Records.General gen "General charachteristic of the borefield";
  input Data.Records.Filling fil "Thermal properties of the filling material";

  input Integer lenSim "Simulation length ([s]). By default = 100 days";

  output Real[q_max,p_max] kappaMat "transient resistance for each cell";
  output Integer[q_max] rArr=
      Borefield.BaseClasses.Aggregation.BaseClasses.cellWidth(q_max=q_max,
      p_max=p_max) "width of aggregation cell for each level";
  output Integer[q_max,p_max] nuMat=
      Borefield.BaseClasses.Aggregation.BaseClasses.nbPulseAtEndEachLevel(
      q_max=q_max,
      p_max=p_max,
      rArr=rArr) "nb of aggregated pulse at end of each aggregation cells";
  output Modelica.SIunits.Temperature TWallSteSta
    "Quasi steady state temperature";

  output Real[1,gen.tBre_d + 1] TResSho;
  output String sha;

  output Boolean existShoTerRes;

  output Boolean existAgg;
  output Boolean writeTWallSteSta;
  output Boolean writeAgg;
  output Real q_max_out;

protected
  String pathSave;
  String dir;
  Real[1,1] mat;
algorithm
  q_max_out := q_max;
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

  if Modelica.Utilities.Files.exist("C:") then
    dir := "C://.BfData";
  elseif Modelica.Utilities.Files.exist("/tmp") then
    dir := "/tmp/.BfData";
  else
    dir := "";
    assert(false, "\n
************************************************************************************************************************ \n 
You do not have the writing permission on the C: or home/ folder. Change the variable dir in
Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Scripts.saveAggregationMatrix to 
write the temperory file at a different location. \n
************************************************************************************************************************ \n ");
  end if;

  Modelica.Utilities.Files.createDirectory(dir);

  pathSave := dir + "/" + sha;

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

    TWallSteSta := GroundHX.CorrectedBoreFieldWallTemperature(
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
