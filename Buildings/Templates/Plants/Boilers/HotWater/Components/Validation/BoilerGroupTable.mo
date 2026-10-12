within Buildings.Templates.Plants.Boilers.HotWater.Components.Validation;
model BoilerGroupTable
  "Validation model for boiler group"
  extends Buildings.Templates.Plants.Boilers.HotWater.Components.Validation.BoilerGroupPolynomial(
    boi(typMod=Buildings.Templates.Components.Types.BoilerHotWaterModel.Table));
annotation(Diagram(coordinateSystem(extent={{-220,-220},{220,220}})),
  experiment(StopTime=2000,
    Tolerance=1e-06),
  __Dymola_Commands(
    file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Boilers/HotWater/Components/Validation/BoilerGroupTable.mos"
      "Simulate and plot"),
  Documentation(
    info="<html>
<p>
  This model validates the boiler group model
  <a href=\"modelica://Buildings.Templates.Plants.Boilers.HotWater.Components.BoilerGroup\">
    Buildings.Templates.Plants.Boilers.HotWater.Components.BoilerGroup</a>
  in the case where a lookup table is used to represent the boiler efficiency.
  The HW supply temperature setpoint, the HW return temperature and the
  primary HW pump speed are fixed at their design value when the boilers are
  enabled.
</p>
</html>"));
end BoilerGroupTable;
