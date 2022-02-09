within Buildings.HeatTransfer.Interfaces;
connector RadiosityInflow = input Real(min=0, final unit="W", nominal=419)
  "Connector for inflowing radiosity"
  annotation(defaultComponentName = "JIn", Icon(graphics={Polygon(
        points={{-100,100},{100,0},{-100,-100},{-100,100}},
        pattern=LinePattern.None,
        smooth=Smooth.None,
        fillColor={0,127,0},
        fillPattern=FillPattern.Solid)}),
  Diagram(graphics={                    Text(
        extent={{-38,120},{38,100}},
        textColor={0,127,0},
        fillColor={0,127,0},
        fillPattern=FillPattern.Solid,
        textString="%name"),                              Polygon(
        points={{-100,100},{100,0},{-100,-100},{-100,100}},
        pattern=LinePattern.None,
        smooth=Smooth.None,
        fillColor={0,127,0},
        fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
The nominal value is set to <i>&sigma; T<sup>4</sup> = &sigma; 293.15<sup>4</sup> = 419</i>.
</html>",
revisions="<html>
<ul>
<li>
June 27, 2013, by Michael Wetter:<br/>
Removed <code>flow</code> attribute as this violates the Modelica Language Standard.
See track issue <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/158\">#158</a>.
</li>
<li>
September 3, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
