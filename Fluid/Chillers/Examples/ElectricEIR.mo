within Buildings.Fluid.Chillers.Examples;
model ElectricEIR "Test model for chiller electric EIR"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric(
      redeclare Buildings.Fluid.Chillers.ElectricEIR chi(per=per),
      redeclare parameter
      Buildings.Fluid.Chillers.Data.ElectricEIR.ElectricEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
      per);
  annotation (
experiment(StopTime=14400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/ElectricEIR.mos"
        "Simulate and plot"));
end ElectricEIR;
