within Buildings.BoundaryConditions.GroundTemperature.Examples;
model UndisturbedSoilTemperature
  extends Modelica.Icons.Example;

  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    Tsoi0(depth=0, climate = climate, soil=soil)
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    Tsoi2(depth=2, climate = climate, soil=soil)
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    Tsoi5(depth=5, climate = climate, soil=soil)
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    Tsoi9(depth=9, climate = climate, soil=soil)
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));

protected
  replaceable parameter ClimaticConstants.Boston climate;
  replaceable parameter Buildings.HeatTransfer.Data.Soil.Generic soil(
    k=1.58,c=1150,d=1600);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=31536000, __Dymola_Algorithm="Cvode"));
end UndisturbedSoilTemperature;
