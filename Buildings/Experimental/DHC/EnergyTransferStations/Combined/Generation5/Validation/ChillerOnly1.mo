within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Validation;
model ChillerOnly1
  "Validation of the ETS model with heat recovery chiller"
  extends ChillerOnly(
    redeclare Combined.Generation5.ChillerBorefield1 ets);

  annotation (
  __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Combined/Generation5/Validation/ChillerOnly1.mos"
"Simulate and plot"),
  experiment(
    StopTime=172800,
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
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield1\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield1</a>
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
as falseif the load is lower than 1% of the nominal load for more than 300s.
</li>
<li>
Simplified chiller performance data are used, which only represent a linear
variation of the EIR with the evaporator outlet temperature and the
condenser inlet temperature (the capacity is fixed and
no variation of the performance at part load is considered).
</li>
</ul>
</html>"));
end ChillerOnly1;
