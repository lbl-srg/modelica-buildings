within Buildings.Templates.HeatingPlants.HotWater.Components.Validation;
model BoilerGroupTable "Validation model for boiler group"
  extends Buildings.Templates.HeatingPlants.HotWater.Components.Validation.BoilerGroupPolynomial(
    boi(typMod=Buildings.Templates.Components.Types.ModelBoilerHotWater.Table));
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
FIXME: Bug in Dymola #SR01004314-01. 
The parameters inside pumHeaWatPri.dat are left unassigned and the start value 
is used instead without any warning being issued.
OCT properly propagates the parameter values from the composite component binding.
</p>
<p>
This model validates the boiler group model
<a href=\"modelica://Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroups.BoilerGroupTable\">
Buildings.Templates.HeatingPlants.HotWater.Components.BoilerGroups.BoilerGroupTable</a>.
</p>
</html>"));

end BoilerGroupTable;
