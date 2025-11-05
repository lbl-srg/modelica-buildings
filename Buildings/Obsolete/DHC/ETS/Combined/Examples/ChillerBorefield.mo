within Buildings.Obsolete.DHC.ETS.Combined.Examples;
model ChillerBorefield
  "Example of the ETS model with heat recovery chiller and borefield"
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
  parameter Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Example datBorFie(
    conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
      cooBor=cooBor,
      dp_nominal=0))
    "Borefield design data"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  annotation (
    obsolete = "Obsolete model - use models from Buildings.DHC.ETC.Combined instead",
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/DHC/ETS/Combined/Examples/ChillerBorefield.mos" "Simulate and plot"),
    experiment(
      StartTime=6.5E6,
      StopTime=7E6,
      Tolerance=1e-06),
    Documentation(
      revisions="<html>
<ul>
<li>
November 3, 2025, by Michael Wetter:<br/>
Moved to <code>Buildings.Obsolete</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4354\">#4354</a>.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Obsolete.DHC.ETS.Combined.ChillerBorefield\">
Buildings.Obsolete.DHC.ETS.Combined.ChillerBorefield</a>
in a system configuration including a geothermal borefield.
See
<a href=\"modelica://Buildings.Obsolete.DHC.ETS.Combined.Examples.ChillerOnly\">
Buildings.Obsolete.DHC.ETS.Combined.Examples.ChillerOnly</a>
for the description of the main modeling assumptions.
</p>
</html>"));
end ChillerBorefield;
