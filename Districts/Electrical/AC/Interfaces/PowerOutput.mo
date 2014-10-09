within Districts.Electrical.AC.Interfaces;
connector PowerOutput
  "Connector with real power, reactive power and power factor"
  output Modelica.SIunits.Power real "Real power";
  output Modelica.SIunits.ReactivePower apparent "Apparent power";
  output Modelica.SIunits.Angle phi "Phase shift";
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
          lineColor={0,0,127},
          textString="%name")}));
end PowerOutput;
