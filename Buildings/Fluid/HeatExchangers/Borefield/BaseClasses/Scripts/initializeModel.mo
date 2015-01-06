within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Scripts;
function initializeModel
  extends Modelica.Icons.Function;

  input Data.Records.Soil soi "Thermal properties of the ground";
  input Data.Records.Filling fil "Thermal properties of the filling material";
  input Data.Records.General gen "General data of the borefield";

  output String sha "Pseudo SHA code (unique code) of the record soi and gen";
  output Real[1,gen.tBre_d + 1] TResSho
    "Short term response temperature vector of the borefield obtained calling the model IDEAS.Fluid.HeatExchangers.GroundHeatExchangers.Borefield.BaseClasses.BoreHoles.Examples.SingleBoreHoleSerStepLoadScript";
  output Boolean existShoTerRes
    "True if the aggregation matrix has already been calculated and stored in the simulation folder";

protected
  String pathSave "Path of the saving folder";
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

 //Creation of a folder .BfData in the simulation folder
  Modelica.Utilities.Files.createDirectory(".BfData");

  pathSave := ".BfData/" + sha;
  // --------------- Check if the short term response (TResSho) needs to be calculated or loaded
  if not Modelica.Utilities.Files.exist(pathSave + "ShoTermData.mat") then

    Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.Scripts.shortTimeResponseHX(
      soi=soi,
      fil=fil,
      gen=gen,
      pathSave=pathSave) annotation(__Dymola_interactive=true);

    existShoTerRes := false;
  else
    existShoTerRes := true;
  end if;

  TResSho := readMatrix(
    fileName=pathSave + "ShoTermData.mat",
    matrixName="TResSho",
    rows=1,
    columns=gen.tBre_d + 1);

    annotation (Documentation(info="<html>
    <p>  This function calculates the short-term wall temperature response of a borefield for given parameters and save it in a hidden folder C:\.BfData\ for windows and C:\.tmp\ for Linux.</p>
    <p> Firstly, a SHA-code of the records soi, fil and gen are computed and summed by the function shaBorefieldRecords. The algorithm checks then if the step response for these parameters already 
    exists in the temperory file. If not, a response vector is computed by the function ShortTimeResponseHX and saved under the name SHA+ShoTermData.mat.</p>
    <p> Remark: by calling the function, three 'true' should appear in the command window for:</p>
    <ul>
    <li> translation of model </li>
    <li> simulation of model</li>
    <li> writing the data </li>
    </ul>
    <p> If not, an error has occured!
    </p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end initializeModel;
