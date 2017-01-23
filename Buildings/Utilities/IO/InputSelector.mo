within Buildings.Utilities.IO;
block InputSelector
  "Block which filters the input depending on the threShold"
  extends Modelica.Blocks.Icons.Block;
  Modelica.Blocks.Interfaces.RealInput u1 "Input"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput u2 "Input"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
   parameter Real threShold = 0.5*Modelica.Constants.pi "threShold";
equation
  y = noEvent(if abs(u1) < threShold then 0.0 else u2);
  annotation (
    defaultComponentName="sel",
    Documentation(info="<html>
<p>
Block that outputs <i>0</i> if 
<i>|u1| &lt; threShold</i>,
or else it outputs <i>u2</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 20, 2017, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          lineColor={0,0,255}),
        Text(
          extent={{-100,46},{-48,30}},
          lineColor={0,0,127},
          textString="u1"),
        Text(
          extent={{-114,-30},{-38,-48}},
          lineColor={0,0,127},
          textString="u2"),
        Text(
          extent={{60,10},{112,-6}},
          lineColor={0,0,127},
          textString="y"),
        Text(
          extent={{-58,12},{58,-18}},
          lineColor={0,0,255},
          textString="threShold = %threShold")}));
end InputSelector;
