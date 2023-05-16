within Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Validation;
model SingleSpeed_TimedResistiveDefrost
  "Validation model for single speed heating DX coil with defrost operation"
  extends Modelica.Icons.Example;
  extends Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Validation.BaseClasses.SingleSpeedHeating(
    datRea(
      final fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Fluid/HeatExchangers/DXCoils/AirSource/Validation/SingleSpeedHeating_TimedResistiveDefrost/DXCoilSystemAuto.dat")),
    datCoi(
      final defOpe=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostOperation.resistive,
      final defTri=Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Types.DefrostTimeMethods.timed));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,-160},
            {180,160}})),
             __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/Heating/AirSource/Validation/SingleSpeed_TimedResistiveDefrost.mos"
        "Simulate and Plot"),
    experiment(Tolerance=1e-6, StopTime=172800),
            Documentation(info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.SingleSpeed\">
Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.SingleSpeed</a> with the 
defrost time fraction calculation <code>datDef.defTri</code> set to 
<code>DefrostTimeMethods.timed</code> and the defrost operation type 
<code>datDef.defOpe</code> set to <code>DefrostOperation.resistive</code>.
</p>
<p>
The difference in results of
<i>T<sub>Out</sub></i> and
<i>X<sub>Out</sub></i>
at the beginning and end of the simulation is because the mass flow rate is zero.
For zero mass flow rate, EnergyPlus assumes steady state condition,
whereas the Modelica model is a dynamic model and hence the properties at the outlet
are equal to the state variables of the model.
</p>
<p>
The EnergyPlus results were generated using the example file <code>DXCoilSystemAuto.idf</code>
from EnergyPlus 22.2. The results were then used to set-up the boundary conditions 
for the model as well as the input signals. To compare the results, 
the Modelica outputs are averaged over <i>3600</i> seconds, and the EnergyPlus 
outputs are used with a zero order delay to avoid the time shift in results.
</p>
<p>
Note that EnergyPlus mass fractions (<code>X</code>) are in mass of water vapor 
per mass of dry air, whereas Modelica uses the total mass as a reference. Also, 
the temperatures in Modelica are in Kelvin whereas they are in Celsius in EnergyPlus.
Hence, the EnergyPlus values are corrected by using the appropriate conversion blocks.
</p>
<p>
The plots compare the outlet temperature and humidity ratio between Modelica and 
EnergyPlus. They also compare the power consumption by the coil compressor as well
as the heat transfer from the airloop.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 2, 2023, by Karthik Devaprasad and Xing Lu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end SingleSpeed_TimedResistiveDefrost;
