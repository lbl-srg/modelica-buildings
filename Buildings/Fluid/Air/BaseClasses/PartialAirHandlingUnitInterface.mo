within Buildings.Fluid.Air.BaseClasses;
partial model PartialAirHandlingUnitInterface "Partial model for AHU interface"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
      final m1_flow_nominal=dat.nomVal.m1_flow_nominal,
      final m2_flow_nominal=dat.nomVal.m2_flow_nominal);
  extends Buildings.Fluid.Air.BaseClasses.EssentialParameter;


  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255})}),
      Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={Text(extent={{54,70},{80,64}},lineColor={0,0,255},
                     textString="Waterside",textStyle={TextStyle.Bold}),
                 Text(extent={{58,-64},{84,-70}},lineColor={0,0,255},
                     textString="Airside",textStyle={TextStyle.Bold})}),
    Documentation(info="<html>
<p>
This model can represent a typical air handler with a cooling coil, a fan, a humidifier and an electric reheater. 
The heating coil and temperature/humidity controller are not included in this model. 
</p>
<p>
The controller developed by users can be connected to this model by specifying the control signals such as 
the valve position on the water-side, the heat flow for reheater, and the fan speed etc. An example for the temperature 
controller can be found in 
<a href=\"modelica://Buildings.Fluid.Air.Example.BaseClasses.TemperatureControl\">Buildings.Fluid.Air.Example.BaseClasses.TemperatureControl</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialAirHandlingUnitInterface;
