within Buildings.Fluid.Chillers.Examples;
model ElectricEIR "Test model for chiller electric EIR"
  import Buildings;
  extends Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric(
      redeclare Buildings.Fluid.Chillers.ElectricEIR chi);
  annotation (Commands(file="ElectricEIR.mos" "run"));
end ElectricEIR;
