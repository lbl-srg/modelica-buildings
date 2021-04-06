within Buildings.BoundaryConditions.GroundTemperature.Examples;
model UndisturbedSoilTemperature "Example model for undisturbed soil temperature"
  extends Modelica.Icons.Example;

  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    Tsoi0(cliCon=cliCon, soiDat=soiDat, dep=0) "Surface temperature"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    Tsoi2(cliCon=cliCon, soiDat=soiDat, dep=2) "Soil temperature at 2m depth"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    Tsoi5(cliCon=cliCon, soiDat=soiDat, dep=5) "Soil temperature at 5m depth"
    annotation (Placement(transformation(extent={{-10,-32},{10,-12}})));
  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    Tsoi9(cliCon=cliCon, soiDat=soiDat, dep=9) "Soil temperature at 9m depth"
    annotation (Placement(transformation(extent={{-10,-72},{10,-52}})));

protected
  replaceable parameter ClimaticConstants.Boston cliCon "Surface temperature climatic conditions";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soiDat(
    k=1.58,c=1150,d=1600) "Soil thermal properties";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=31536000, __Dymola_Algorithm="Cvode", Tolerance=1e-6),
    Documentation(info="<html>
<p>
This example model illustrates how the undisturbed soil temperature model decreases
seasonal temperature oscillations and increases delay as depth is increasing.
</p>
</html>", revisions="<html>
<ul>
<li>
March 17, 2021, by Baptiste Ravache:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/BoundaryConditions/GroundTemperature/Examples/UndisturbedSoilTemperature.mos"
        "Simulate and plot"));
end UndisturbedSoilTemperature;
