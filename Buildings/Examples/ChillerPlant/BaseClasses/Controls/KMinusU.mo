within Buildings.Examples.ChillerPlant.BaseClasses.Controls;
block KMinusU "Output y=k-u"
  extends Modelica.Blocks.Icons.Block;
public
  parameter Real k "Sum of u and y";
  Modelica.Blocks.Interfaces.RealInput u "Input" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-138,-20},{-98,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "Output" annotation (Placement(
        transformation(extent={{100,-10},{120,10}}), iconTransformation(extent=
            {{100,-10},{120,10}})));
equation
  y = k - u;
  annotation (
    defaultComponentName="kMinu",
    Documentation(info="<HTML>
This component computes the value of
<p align=\"left\" style=\"font-style:italic;\"> y = k - u. </p>
</html>", revisions="<html>
<ul>
<li>
July 20, 2011, by Wangda Zuo:<br/>
Add comments and merge to library.
</li>
<li>
May 19, 2010, by Wangda Zuo:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}}), graphics={Text(
          extent={{-150,110},{150,150}},
          textString="%name",
          textColor={0,0,255}), Text(
          extent={{-50,24},{40,-12}},
          textColor={0,0,255},
          textString="y=k-u")}));
end KMinusU;
