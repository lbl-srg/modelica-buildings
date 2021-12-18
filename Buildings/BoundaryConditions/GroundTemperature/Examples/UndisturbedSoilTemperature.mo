within Buildings.BoundaryConditions.GroundTemperature.Examples;
model UndisturbedSoilTemperature "Example model for undisturbed soil temperature"
  extends Modelica.Icons.Example;

  parameter Integer nSoi = 4 "Number of probed depths";
  parameter Modelica.Units.SI.Length dep[nSoi]={0,2,5,9} "Probed depths";

  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    TSoi[nSoi](dep=dep, each cliCon=cliCon, each soiDat=soiDat)
    "Undisturbed soil temperatures"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));

protected
  replaceable parameter ClimaticConstants.Boston cliCon
    "Surface temperature climatic conditions";
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soiDat(
    k=1.58,c=1150,d=1600) "Soil thermal properties";
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=31536000, Tolerance=1e-6),
    Documentation(info="<html>
<p>
This example model illustrates how the undisturbed soil temperature model 
decreases seasonal temperature oscillations and increases delay as depth is 
increasing.
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
