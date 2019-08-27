within Buildings.Fluid.CHPs.BaseClasses;
model StandBy "Stand-by operating mode"
  extends Modelica.StateGraph.PartialCompositeStep;
  Modelica.StateGraph.Step standByState
    annotation (Placement(transformation(extent={{-16,-14},{12,14}})));
equation
  connect(inPort, standByState.inPort[1])
    annotation (Line(points={{-160,0},{-17.4,0}}, color={0,0,0}));
  connect(standByState.outPort[1], outPort) annotation (Line(points={{12.7,1.77636e-15},
          {81.35,1.77636e-15},{81.35,0},{155,0}}, color={0,0,0}));
  annotation (defaultComponentName="staBy", Documentation(info="<html>
<p>
The model defines the stand-by operating mode.
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end StandBy;
