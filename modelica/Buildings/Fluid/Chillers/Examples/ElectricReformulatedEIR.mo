within Buildings.Fluid.Chillers.Examples;
model ElectricReformulatedEIR
  "Test model for chiller electric reformulated EIR"
  import Buildings;
  extends Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric(
      redeclare Buildings.Fluid.Chillers.ElectricReformulatedEIR chi(per=
          Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_McQuay_WSC_471kW_589COP_Vanes()),
           redeclare
      Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_McQuay_WSC_471kW_589COP_Vanes
      per);
  annotation (Commands(file="ElectricReformulatedEIR.mos" "run"), Diagram(
        graphics));
end ElectricReformulatedEIR;
