within Buildings.Fluid.CHPs.BaseClasses;
model CoolDown "Cool-down operating mode"
  extends Modelica.StateGraph.PartialCompositeStep;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

  Modelica.StateGraph.Interfaces.Step_in inPort1
    annotation (Placement(transformation(extent={{-170,70},{-150,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y
    "Transition signal"
    annotation (Placement(transformation(extent={{150,-70},{170,-50}}),
      iconTransformation(extent={{150,-60},{170,-40}})));
  Modelica.StateGraph.StepWithSignal coolDownState(final nIn=2)
    annotation (Placement(transformation(extent={{-16,-16},{16,16}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Timer timer
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold timeDel(
    final threshold=per.timeDelayCool)
    "Check if the time of  plant in cool-down mode has been longer than the specified delay time"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));

equation
  connect(coolDownState.active, timer.u) annotation (Line(points={{0,-17.6},{0,
          -60},{18,-60}}, color={255,0,255}));
  connect(timer.y, timeDel.u) annotation (Line(points={{42,-60},{58,-60}},
          color={0,0,255}));
  connect(inPort, coolDownState.inPort[1]) annotation (Line(points={{-160,0},{-88,
          0},{-88,0.8},{-17.6,0.8}}, color={0,0,0}));
  connect(coolDownState.outPort[1], outPort) annotation (Line(points={{16.8,0},
          {155,0}}, color={0,0,0}));
  connect(timeDel.y, y) annotation (Line(points={{82,-60},{160,-60}},
          color={255,0,255}));
  connect(inPort1, coolDownState.inPort[2]) annotation (Line(points={{-160,60},{
          -89,60},{-89,-0.8},{-17.6,-0.8}}, color={0,0,0}));

annotation (defaultComponentName="cooDow", Documentation(info="<html>
<p>
The model defines the cool-down operating mode. 
CHP will change from the cool-down mode to the off mode after the specified time delay
<code>per.timeDelayCool</code>. 
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
