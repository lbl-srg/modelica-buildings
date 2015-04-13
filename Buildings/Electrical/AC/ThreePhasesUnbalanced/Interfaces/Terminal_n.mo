within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
connector Terminal_n
  "Terminal N for AC three-phase unbalanced systems (no neutral cable)"
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
          fillPattern=FillPattern.Solid)}), Documentation(revisions="<html>
<ul>
<li>
October 9, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>Electric connector type n for AC three-phase unbalanced systems.</p>
</html>"));
end Terminal_n;
