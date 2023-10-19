within Buildings.Templates.HeatingPlants.HotWater.Components.Validation;
model BoilerGroupTable "Validation model for boiler group"
  extends Buildings.Templates.HeatingPlants.HotWater.Components.Validation.BoilerGroupPolynomial(
    boi(typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Table));
  annotation (
  Diagram(coordinateSystem(extent={{-220,-220},{220,220}})),
  experiment(
    StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Templates/HeatingPlants/HotWater/Components/Validation/BoilerGroupTable.mos"
  "Simulate and plot"),
  Documentation(info="<html>
<p>
This model validates the boiler group model
<a href=\"modelica://Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroup\">
Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroup</a>
in the case where a lookup table is used to represent the boiler efficiency.
The HW supply temperature setpoint, the HW return temperature and the 
primary HW pump speed are fixed at their design value when the boilers are
enabled.
</p>
<p>
The model illustrates a bug in Dymola (#SR01004314-01).
The parameter bindings for <code>pumHeaWatPri.dat</code> are not properly interpreted
and the start value is used for all those parameters without any warning being issued.
Hence, the total HW flow rate differs from its design value.
OCT properly propagates the parameter values from the composite component binding.
</p>
</html>"));

end BoilerGroupTable;
