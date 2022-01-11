within Buildings.Controls.OBC.CDL.Interfaces;
connector BooleanInput=input Boolean
  "Boolean input connector"
annotation (defaultComponentName="u",
 Icon(graphics={Polygon(lineColor={255,0,255},
                        fillColor={255,0,255},
                        fillPattern = FillPattern.Solid,
                        points={{0,50},{100,0},{0,-50}})},
      coordinateSystem(extent={{-100,-100},{100,100}},
                       preserveAspectRatio=true,
                       initialScale=0.2)),
 Diagram(coordinateSystem(preserveAspectRatio=true,
                          initialScale=0.2,
                          extent={{-100,-100},{100,100}}),
         graphics={Polygon(points={{0,50},{100,0},{0,-50},{0,50}},
                           lineColor={255,0,255},
                           fillColor={255,0,255},fillPattern = FillPattern.Solid),
                   Text(extent={{-10,85},{-10,60}},
                        textColor={255,0,255},
                        textString="%name")}),
Documentation(info="<html>
<p>
Connector with one input signal of type Boolean.
</p>
</html>",revisions="<html>
<ul>
<li>
March 1, 2019, by Michael Wetter:<br/>
On the icon layer, changed connector size and added the connector name.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1375\">issue 1375</a>.
</li>
<li>
January 6, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
