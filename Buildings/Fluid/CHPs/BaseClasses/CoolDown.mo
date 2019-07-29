within Buildings.Fluid.CHPs.BaseClasses;
model CoolDown "Cool-down operating mode"
  extends Modelica.StateGraph.PartialCompositeStep;
  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-148,-148},{-128,-128}})));

  Modelica.StateGraph.Interfaces.Step_in inPort1
    annotation (Placement(transformation(extent={{-170,70},{-150,50}})));
  Modelica.Blocks.Interfaces.BooleanOutput y
    "Transition signal"
    annotation (Placement(transformation(extent={{152,-60},{172,-40}}),
        iconTransformation(extent={{150,-60},{170,-40}})));
  Modelica.StateGraph.StepWithSignal coolDownState(nIn=2)
    annotation (Placement(transformation(extent={{-16,-16},{16,16}})));

protected
  Modelica.Blocks.Logical.Timer timer
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold timeDel(threshold=per.timeDelayCool)
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

equation
  connect(coolDownState.active, timer.u)
    annotation (Line(points={{0,-17.6},{0,-50},{18,-50}}, color={255,0,255}));
  connect(timer.y, timeDel.u)
    annotation (Line(points={{41,-50},{58,-50}}, color={0,0,255}));
  connect(inPort, coolDownState.inPort[1]) annotation (Line(points={{-160,0},{-88,
          0},{-88,0.8},{-17.6,0.8}}, color={0,0,0}));
  connect(coolDownState.outPort[1], outPort)
    annotation (Line(points={{16.8,0},{155,0}}, color={0,0,0}));
  connect(timeDel.y, y)
    annotation (Line(points={{81,-50},{162,-50}}, color={255,0,255}));
  connect(inPort1, coolDownState.inPort[2]) annotation (Line(points={{-160,60},{
          -89,60},{-89,-0.8},{-17.6,-0.8}}, color={0,0,0}));
  annotation (defaultComponentName="cooDow", Documentation(info="<html>
<p>
The model defines the cool-down operating mode. 
CHP will transition from the cool-down mode to the off mode after the specified time delay. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolDown;
