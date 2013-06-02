within Buildings.HeatTransfer.Interfaces;
connector RadiosityOutflow = flow output Real(max=0, unit="W", nominal=419)
  "Connector for outflowing radiosity"
  annotation(defaultComponentName = "JOut", Icon(graphics={Polygon(
        points={{-100,100},{100,0},{-100,-100},{-100,100}},
        smooth=Smooth.None,
        lineColor={0,127,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}),
  Diagram(graphics={                                       Polygon(
        points={{-100,100},{100,0},{-100,-100},{-100,100}},
        smooth=Smooth.None,
        lineColor={0,127,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-42,122},{34,102}},
        lineColor={0,127,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid,
        textString="%name")}),
  Documentation(info="<html>
The nominal value is set to <i>&sigma; T<sup>4</sup> = &sigma; 293.15<sup>4</sup> = 419</i>.
</html>",
revisions="<html>
<ul>
<li>
September 3, 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
