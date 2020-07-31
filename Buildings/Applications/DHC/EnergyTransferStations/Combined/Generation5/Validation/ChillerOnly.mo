within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Validation;
model ChillerOnly
  "Validation of the ETS model with heat recovery chiller"
  extends BaseClasses.PartialChillerBorefield;

  Modelica.Blocks.Sources.TimeTable loaHeaRat(
    table=[0,0.1; 1, 0.1; 4,1; 7,0.2; 9, 0.5; 10,0; 11,0], timeScale=1000)
    "Heating load (ratio to nominal)"
    annotation (Placement(transformation(extent={{-290,110},{-270,130}})));
  Modelica.Blocks.Sources.TimeTable loaCooRat(
    table=[0,0; 3,0; 4,0.1; 6,0.1; 8, 1; 15,0.5; 16,0.5], timeScale=1000)
    "Cooling load (ratio to nominal)"
    annotation (Placement(transformation(extent={{310,110},{290,130}})));
equation
  connect(loaHeaRat.y, heaLoaNor.u) annotation (Line(points={{-269,120},{-260,120},
          {-260,60},{-252,60}}, color={0,0,127}));
  connect(loaCooRat.y, loaCooNor.u) annotation (Line(points={{289,120},{280,120},
          {280,60},{272,60}}, color={0,0,127}));
  annotation (
  __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Combined/Generation5/Validation/ChillerOnly.mos"
"Simulate and plot"),
  experiment(
    StopTime=20000,
    Tolerance=1e-06),
  Documentation(
revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield</a>
in a system configuration with no geothermal borefield.
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
end ChillerOnly;
