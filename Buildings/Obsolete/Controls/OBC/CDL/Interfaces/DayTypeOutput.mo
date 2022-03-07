within Buildings.Obsolete.Controls.OBC.CDL.Interfaces;
connector DayTypeOutput=output Types.Day
  "Output connector for day types"
annotation (defaultComponentName="y",
 Icon(coordinateSystem(preserveAspectRatio=true,
                       initialScale=0.2,
                       extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={Polygon(lineColor={0,127,0},
                        fillColor={255,255,255},
                        fillPattern=FillPattern.Solid,
                        points={{-100,50},{0,0},{-100,-50}})}),
 Diagram(coordinateSystem(preserveAspectRatio=true,
                          initialScale=0.2,
                          extent={{-100.0,-100.0},{100.0,100.0}}),
         graphics={Polygon(lineColor={0,127,0},
                           fillColor={255,255,255},
                           fillPattern=FillPattern.Solid,
                           points={{-100.0,50.0},{0.0,0.0},{-100.0,-50.0}}),
                   Text(textColor={0,127,0},
                        extent={{30.0,60.0},{30.0,110.0}},
                        textString="%name")}),
Documentation(info="<html>
<p>
Connector with one output signal of type
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Types.Day\">
Buildings.Obsolete.Controls.OBC.CDL.Types.Day</a>.
</p>
</html>",revisions="<html>
<ul>
<li>
January 13, 2022, by Michael Wetter:<br/>
Moved to <code>Obsolete</code> package.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2839\">issue 2839</a>.
</li>
<li>
July 19, 2019, by Jianjun Hu:<br/>
On both icon and diagram layer, added the initialScale.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1375\">issue 1375</a>.
</li>
<li>
March 1, 2019, by Michael Wetter:<br/>
On the icon layer, changed connector size and added the connector name.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1375\">issue 1375</a>.
</li>
<li>
January 11, 2016, by Milica Grahovac:<br/>
First CDL implementation.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
