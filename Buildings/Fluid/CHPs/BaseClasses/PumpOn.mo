within Buildings.Fluid.CHPs.BaseClasses;
model PumpOn "Operating mode in which the water pump starts to run"
  extends Modelica.StateGraph.PartialCompositeStep;
  Modelica.StateGraph.Step pumpOnState
    annotation (Placement(transformation(extent={{-16,-14},{12,14}})));
equation
  connect(inPort, pumpOnState.inPort[1])
    annotation (Line(points={{-160,0},{-17.4,0}}, color={0,0,0}));
  connect(pumpOnState.outPort[1], outPort) annotation (Line(points={{12.7,
          1.77636e-15},{81.35,1.77636e-15},{81.35,0},{155,0}}, color={0,0,0}));
   annotation (
    defaultComponentName="pumOn",
    Documentation(info="<html>
<p>
The model defines the operating mode in which the water pump starts to run. 
CHP will transition from the pump-on mode to the warm-up mode after the time delay and if the water flow rate is higher than the minimum defined by the manufacturer.
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end PumpOn;
