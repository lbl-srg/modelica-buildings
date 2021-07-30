within Buildings.Controls.OBC.CDL.Interfaces;
connector RealOutput=output Real
  "'output Real' as connector"
annotation (defaultComponentName="y",
 Icon(coordinateSystem(preserveAspectRatio=true,
                       initialScale=0.2,
                       extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={Polygon(lineColor={0,0,127},
                        fillColor={255,255,255},
                        fillPattern=FillPattern.Solid,
                        points={{-100,50},{0,0},{-100,-50}})}),
 Diagram(coordinateSystem(preserveAspectRatio=true,
                          initialScale=0.2,
                          extent={{-100.0,-100.0},{100.0,100.0}}),
         graphics={Polygon(lineColor={0,0,127},
                           fillColor={255,255,255},
                           fillPattern=FillPattern.Solid,
                           points={{-100.0,50.0},{0.0,0.0},{-100.0,-50.0}}),
                   Text(lineColor={0,0,127},
                        extent={{30.0,60.0},{30.0,110.0}},
                        textString="%name")}),
Documentation(info="<html>
<p>
Connector with one output signal of type Real.
</p>
</html>",revisions="<html>
<ul>
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
January 6, 2017, by Michael Wetter:<br/>
First implementation, based on the implementation of the
Modelica Standard Library.
</li>
</ul>
</html>"));
