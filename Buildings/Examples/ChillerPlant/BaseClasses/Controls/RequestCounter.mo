within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
block RequestCounter "Count the number of actuators that have request"
  extends Modelica.Blocks.Icons.Block annotation (Icon(Text(
        extent={{-48,48},{54,-32}},
        style(color=3, rgbcolor={0,0,255}),
        textString="max")));
  parameter Integer nAct "Number of actuators";
  parameter Real uTri "Value to trigger a request from actuator";
  Modelica.Blocks.Interfaces.IntegerOutput nInc
    "Number of actuators requesting control signal increase"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput uAct[nAct] "Input signal from actuators"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
algorithm
  nInc := 0;
  for i in 1:nAct loop
    if uAct[i] > uTri then
      nInc := nInc + 1;
    end if;
  end for;
  annotation (
    defaultComponentName="reqCou",
    Documentation(info="<html>
   This model counts the number of requests sent by actuators. A request is triggerred when an input singal <code>uAct[i]</code> is larger than <code>uTri</code>.
   </html>", revisions="<html>
<ul>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Add comments and merge to library.
</li>
<li>
January 6, 2011, by Michael Wetter and Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-52,22},{48,-22}},
          lineColor={135,135,135},
          pattern=LinePattern.Dash,
          fillColor={135,135,135},
          fillPattern=FillPattern.HorizontalCylinder),
        Line(
          points={{-20,22},{-20,-22}},
          color={255,255,255},
          smooth=Smooth.None,
          thickness=1),
        Line(
          points={{16,22},{16,-22}},
          color={255,255,255},
          smooth=Smooth.None,
          thickness=1),
        Text(
          extent={{-49,13},{-23,-15}},
          textColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.HorizontalCylinder,
          textString="1",
          fillColor={0,0,0}),
        Text(
          extent={{-15,13},{11,-15}},
          textColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,0},
          textString="2"),
        Text(
          extent={{21,13},{47,-15}},
          textColor={0,0,0},
          lineThickness=1,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,0,0},
          textString="3")}));
end RequestCounter;
