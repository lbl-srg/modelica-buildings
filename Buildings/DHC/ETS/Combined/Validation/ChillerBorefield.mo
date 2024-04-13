within Buildings.DHC.ETS.Combined.Validation;
model ChillerBorefield
  "Validation of the ETS model with heat recovery chiller and borefield"
  extends ChillerOnly(
    ets(
      have_borFie=true,
      datBorFie=datBorFie));
  parameter Integer nBorHol=64
    "Number of boreholes (must be a square number)";
  parameter Modelica.Units.SI.Distance dxy=6
    "Distance in x-axis (and y-axis) between borehole axes";
  final parameter Modelica.Units.SI.Distance cooBor[nBorHol,2]=
      Buildings.DHC.ETS.BaseClasses.computeCoordinates(nBorHol, dxy)
    "Coordinates of boreholes";
  parameter Fluid.Geothermal.Borefields.Data.Borefield.Example datBorFie(
    conDat=Fluid.Geothermal.Borefields.Data.Configuration.Example(
      dp_nominal=0,
      cooBor=cooBor))
    "Borefield design data"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/ETS/Combined/Validation/ChillerBorefield.mos" "Simulate and plot"),
    experiment(
      StopTime=360000,
      Tolerance=1e-06),
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.DHC.ETS.Combined.ChillerBorefield\">
Buildings.DHC.ETS.Combined.ChillerBorefield</a>
in a system configuration including a geothermal borefield.
See
<a href=\"modelica://Buildings.DHC.ETS.Combined.Validation.ChillerOnly\">
Buildings.DHC.ETS.Combined.Validation.ChillerOnly</a>
for the description of the main modeling assumptions.
</p>
</html>"));
end ChillerBorefield;
