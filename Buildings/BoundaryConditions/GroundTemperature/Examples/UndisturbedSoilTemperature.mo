within Buildings.BoundaryConditions.GroundTemperature.Examples;
model UndisturbedSoilTemperature
  extends Modelica.Icons.Example;

  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    Tsoi0(
    z=0,
    TMeaSur=TMeaSur,
    TSurAmp=TSurAmp,
    soiDif=soiDif,
    timLag=timLag)
    annotation (Placement(transformation(extent={{-10,80},{10,100}})));
  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    Tsoi2(
    z=2,
    TMeaSur=TMeaSur,
    TSurAmp=TSurAmp,
    soiDif=soiDif,
    timLag=timLag)
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    Tsoi5(
    z=5,
    TMeaSur=TMeaSur,
    TSurAmp=TSurAmp,
    soiDif=soiDif,
    timLag=timLag)
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  Buildings.BoundaryConditions.GroundTemperature.UndisturbedSoilTemperature
    Tsoi9(
    z=9,
    TMeaSur=TMeaSur,
    TSurAmp=TSurAmp,
    soiDif=soiDif,
    timLag=timLag)
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));

protected
  final parameter Modelica.SIunits.Temperature TMeaSur = 282.65 "Mean annual surface temperature";
  final parameter Modelica.SIunits.TemperatureDifference TSurAmp = 11.4 "Surface temperature amplitude";
  final parameter Modelica.SIunits.ThermalDiffusivity soiDif = 1.58/1600/1150 "Soil thermal diffusivity";
  final parameter Modelica.SIunits.Duration timLag = 115.9*24*60*60  "Phase lag of soil surface temperature";

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=31536000, __Dymola_Algorithm="Cvode"));
end UndisturbedSoilTemperature;
