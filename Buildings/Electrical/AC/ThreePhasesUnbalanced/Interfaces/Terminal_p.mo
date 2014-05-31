within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
connector Terminal_p
  Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_p phase[3];
  annotation (Icon(graphics={                Polygon(
              points={{-100,100},{-100,60},{100,60},{100,100},{-100,100}},
              lineColor={0,120,120},
              fillColor={0,120,120},
              fillPattern=FillPattern.Solid),Polygon(
              points={{-100,-100},{100,-100},{100,-60},{-100,-60},{-100,-100}},
              lineColor={0,120,120},
              fillColor={0,120,120},
              fillPattern=FillPattern.Solid),Polygon(
              points={{-100,-20},{100,-20},{100,20},{-100,20},{-100,-20}},
              lineColor={0,120,120},
              fillColor={0,120,120},
              fillPattern=FillPattern.Solid)}));
end Terminal_p;
