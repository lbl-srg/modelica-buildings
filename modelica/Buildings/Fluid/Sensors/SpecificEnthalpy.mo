within Buildings.Fluid.Sensors;
model SpecificEnthalpy "Ideal one port specific enthalpy sensor"
  extends Modelica.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  extends Modelica.Icons.RotationalSensor;
  Modelica.Blocks.Interfaces.RealOutput h_out(final quantity="SpecificEnergy",
                                              final unit="J/kg")
    "Specific enthalpy in port medium"
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0)));

equation
  h_out = inStream(port.h_outflow);
annotation (defaultComponentName="specificEnthalpy",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Line(points={{0,-70},{0,-100}}, color={0,0,127}),
        Text(
          extent={{-150,80},{150,120}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{168,-30},{52,-60}},
          lineColor={0,0,0},
          textString="h"),
        Line(points={{70,0},{100,0}}, color={0,0,127})}),
  Documentation(info="<HTML>
<p>
This component monitors the specific enthalpy of the fluid passing its port. 
The sensor is ideal, i.e. it does not influence the fluid.
</p>
</HTML>
"));
end SpecificEnthalpy;
