within Buildings.Fluid.Chillers.Examples;
model ElectricReformulatedEIR
  "Test model for chiller electric reformulated EIR"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.Chillers.Examples.BaseClasses.PartialElectric(
      redeclare Buildings.Fluid.Chillers.ElectricReformulatedEIR chi(per=per),
      redeclare parameter
      Buildings.Fluid.Chillers.Data.ElectricReformulatedEIR.ReformEIRChiller_McQuay_WSC_471kW_5_89COP_Vanes
      per);
  annotation (
experiment(StopTime=14400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/ElectricReformulatedEIR.mos"
        "Simulate and plot"),                                                                                                    Diagram(
        graphics),
    Documentation(info="<html>
<p>
Example that simulates a chiller whose efficiency is computed based on the
condenser leaving and evaporator leaving fluid temperature.
A bicubic polynomial is used to compute the chiller part load performance.
</p>
</html>", revisions="<html>
<ul>
<li>
August 14, 2014, by Michael Wetter:<br/>
Added missing <code>redeclare</code> keyword in
performance data redeclaration.
This avoids an error in OpenModelica.
</li>
<li>
September 17, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ElectricReformulatedEIR;
