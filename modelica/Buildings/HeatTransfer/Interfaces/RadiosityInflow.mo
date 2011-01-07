within Buildings.HeatTransfer.Interfaces;
connector RadiosityInflow = flow input Real(min=0, unit="W", nominal=419)
  "Connector for inflowing radiosity"
  annotation(defaultComponentName = "JIn", Icon(graphics={Polygon(
        points={{-100,100},{100,0},{-100,-100},{-100,100}},
        pattern=LinePattern.None,
        smooth=Smooth.None,
        fillColor={0,127,0},
        fillPattern=FillPattern.Solid)}),
  Diagram(graphics={                    Text(
        extent={{-38,120},{38,100}},
        lineColor={0,127,0},
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
</html>"));
