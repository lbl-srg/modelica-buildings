within Buildings.Electrical.AC.Interfaces;
connector PowerOutput
  "Connector with real power, reactive power and power factor"
  output Modelica.Units.SI.Power real "Real power";
  output Modelica.Units.SI.ReactivePower apparent "Apparent power";
  output Modelica.Units.SI.Angle phi "Phase shift";
  output Real cosPhi "Power factor";

  annotation (Icon(graphics={ Polygon(
          points={{-100,100},{100,0},{-100,-100},{-100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(graphics={
                               Polygon(
          points={{-100,50},{0,0},{-100,-50},{-100,50}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{30,110},{30,60}},
          textColor={0,0,127},
          textString="%name")}),
    Documentation(info="<html>
This connector contains multiple quantities that can be used to monitor
the power consumption of a generic AC systems.
</html>", revisions="<html>
<ul>
<li>
March 19, 2015, by Marco Bonvini:<br/>
Added documentation.
</li>
</ul>
</html>"));
end PowerOutput;
