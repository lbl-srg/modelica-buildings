within Buildings.Controls.OBC.CDL.Interfaces;
connector IntegerOutput=output Integer
  "Integer output connector"
annotation (defaultComponentName="y",
 Icon(coordinateSystem(preserveAspectRatio=true,
                       initialScale=0.2,
                       extent={{-100,-100},{100,100}}),
      graphics={Polygon(lineColor={255,127,0},
                        fillColor={255,255,255},
                        fillPattern=FillPattern.Solid,
                        points={{-100,50},{0,0},{-100,-50}})}),
 Diagram(coordinateSystem(preserveAspectRatio=true,
                          initialScale=0.2,
                          extent={{-100,-100},{100,100}}),
         graphics={Polygon(points={{-100,50},{0,0},{-100,-50},{-100,50}},
                           lineColor={255,127,0},
                           fillColor={255,255,255},
                           fillPattern=FillPattern.Solid),
                   Text(extent={{30,110},{30,60}},
                        textColor={255,127,0},
                        textString="%name")}),
Documentation(info="<html>
<p>
Connector with one output signal of type Integer.
</p>
</html>",revisions="<html>
<ul>
<li>
July 19, 2019, by Jianjun Hu:<br/>
On both icon and diagram layer, added the initialScale.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1375\">Buildings, issue 1375</a>.
</li>
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
