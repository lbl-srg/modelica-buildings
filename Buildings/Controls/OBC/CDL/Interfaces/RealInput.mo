within Buildings.Controls.OBC.CDL.Interfaces;
connector RealInput=input Real
  "Real input connector"
annotation (defaultComponentName="u",
 Icon(graphics={Polygon(lineColor={0,0,127},
                        fillColor={0,0,127},
                        fillPattern=FillPattern.Solid,
                        points={{0,50},{100,0},{0,-50}})},
      coordinateSystem(extent={{-100.0,-100.0},{100.0,100.0}},
                       preserveAspectRatio=true,
                       initialScale=0.2)),
 Diagram(coordinateSystem(preserveAspectRatio=true,
                          initialScale=0.2,
                          extent={{-100.0,-100.0},{100.0,100.0}}),
         graphics={Polygon(lineColor={0,0,127},
                           fillColor={0,0,127},
                           fillPattern=FillPattern.Solid,
                           points={{0.0,50.0},{100.0,0.0},{0.0,-50.0},{0.0,50.0}}),
                   Text(textColor={0,0,127},
                        extent={{-10.0,60.0},{-10.0,85.0}},
                        textString="%name")}),
Documentation(info="<html>
<p>
Connector with one input signal of type Real.
</p>
</html>",revisions="<html>
<ul>
<li>
March 1, 2019, by Michael Wetter:<br/>
On the icon layer, changed connector size and added the connector name.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1375\">Buildings, issue 1375</a>.
</li>
<li>
January 6, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
