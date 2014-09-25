within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
connector Terminal_n
  "Terminal N for AC three phases unbalanced systems (no neutral cable)"
  Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_n phase[3];
  annotation (Icon(graphics={                Polygon(
          points={{-100,100},{-100,60},{100,60},{100,100},{-100,100}},
          lineColor={0,120,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),    Polygon(
          points={{-100,-60},{-100,-100},{100,-100},{100,-60},{-100,-60}},
          lineColor={0,120,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),    Polygon(
          points={{-100,20},{-100,-20},{100,-20},{100,20},{-100,20}},
          lineColor={0,120,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Terminal_n;
