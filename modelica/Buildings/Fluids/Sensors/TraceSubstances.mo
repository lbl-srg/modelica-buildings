within Buildings.Fluids.Sensors;
model TraceSubstances "Ideal one port trace substances sensor"
  extends Modelica.Fluid.Sensors.BaseClasses.PartialAbsoluteSensor;
  extends Modelica.Icons.RotationalSensor;
  parameter String substanceName = "CO2" "Name of trace substance";

  Modelica.Blocks.Interfaces.RealOutput C "Trace substance in port medium" 
    annotation (Placement(transformation(extent={{100,-10},{120,10}},
          rotation=0)));

annotation (defaultComponentName="traceSubstance",
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
          extent={{160,-30},{60,-60}},
          lineColor={0,0,0},
          textString="C"),
        Line(points={{70,0},{100,0}}, color={0,0,127})}),
  Documentation(info="<HTML>
<p>
This component monitors the trace substances contained in the fluid passing its port. 
The sensor is ideal, i.e. it does not influence the fluid.
</p>
</HTML>
"));
protected
  parameter Integer ind(fixed=false)
    "Index of species in vector of auxiliary substances";
  Medium.ExtraProperty CVec[Medium.nC](
      quantity=Medium.extraPropertiesNames)
    "Trace substances vector, needed because indexed argument for the operator inStream is not supported";
initial algorithm
  ind:= -1;
  for i in 1:Medium.nC loop
    if ( Modelica.Utilities.Strings.isEqual(Medium.extraPropertiesNames[i], substanceName)) then
      ind := i;
    end if;
  end for;
  assert(ind > 0, "Trace substance '" + substanceName + "' is not present in medium '"
         + Medium.mediumName + "'.\n"
         + "Check sensor parameter and medium model.");
equation
  CVec = inStream(port.C_outflow);
  C = CVec[ind];
end TraceSubstances;
