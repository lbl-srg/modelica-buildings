within Buildings.Fluid.Chillers.Examples;
model ElectricEIR "Test model for chiller electric EIR"
  import Buildings;
  extends Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric(
      redeclare Buildings.Fluid.Chillers.ElectricEIR chi(per=per), redeclare
      Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
      per);
  annotation (Commands(file="ElectricEIR.mos" "run"));
end ElectricEIR;
