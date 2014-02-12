within Buildings.Fluid.Chillers.Examples;
model ElectricReformulatedEIR
  "Test model for chiller electric reformulated EIR"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric(
      redeclare Buildings.Fluid.Chillers.ElectricReformulatedEIR chi(per=per),
      redeclare
      Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
      per);
  annotation (
experiment(StopTime=14400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/ElectricReformulatedEIR.mos"
        "Simulate and plot"),                                                                                                    Diagram(
        graphics));
end ElectricReformulatedEIR;
