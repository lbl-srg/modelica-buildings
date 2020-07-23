within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Validation;
model ChillerBorefield
  "Validation of the ETS model with heat recovery chiller and borefield"
  extends ChillerOnly(
    ets(have_borFie=true, datBorFie=datBorFie));

  parameter Integer nBorHol = 64
    "Number of boreholes (must be a square number)";
  parameter Modelica.SIunits.Distance dxy = 6
    "Distance in x-axis (and y-axis) between borehole axes";
  final parameter Modelica.SIunits.Distance cooBor[nBorHol,2]=
    EnergyTransferStations.BaseClasses.computeCoordinates(nBorHol, dxy)
    "Coordinates of boreholes";
  parameter Fluid.Geothermal.Borefields.Data.Borefield.Example datBorFie(conDat=
        Fluid.Geothermal.Borefields.Data.Configuration.Example(dp_nominal=0,
        cooBor=cooBor))
    "Borefield design data"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  annotation (
  __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Combined/Generation5/Validation/ChillerBorefield.mos"
"Simulate and plot"),
  Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This model validates 
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield</a>
in a system configuration including a geothermal borefield. 
</p>
<ul>
<li>
A fictitious load profile is used. 
</li>
<li>
The district water supply temperature is constant.
</li>
<li>
The building distribution pumps are variable speed and the flow rate
is considered to vary linearly with the load (with no inferior limit).
</li>
<li>
The Boolean enable signals for heating and cooling typically provided 
by the building automation system are here computed
as false if the load if lower than 1% of the nominal load for more than 300s.
</li>
<li>
Simplified chiller performance data are used, which only represent a linear 
variation of the EIR with the evaporator outlet temperature and the
condenser inlet temperature (the capacity is fixed and
no variation of the performance at part load is considered).
</li>
</ul>
</html>"));
end ChillerBorefield;
