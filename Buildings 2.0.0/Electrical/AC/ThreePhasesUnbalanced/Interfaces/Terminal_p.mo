within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
connector Terminal_p
  "Terminal P for AC three-phase unbalanced systems (no neutral cable)"
  Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_p phase[3];
  annotation (Icon(graphics={                Polygon(
          points={{-100,100},{-100,60},{100,60},{100,100},{-100,100}},
          lineColor={0,120,120},
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid),    Polygon(
              points={{-100,-100},{100,-100},{100,-60},{-100,-60},{-100,-100}},
              lineColor={0,120,120},
              fillColor={0,120,120},
              fillPattern=FillPattern.Solid),Polygon(
              points={{-100,-20},{100,-20},{100,20},{-100,20},{-100,-20}},
              lineColor={0,120,120},
              fillColor={0,120,120},
              fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>Electric connector type p for AC three-phase unbalanced systems.</p>
</html>", revisions="<html>
<ul>
<li>
October 9, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end Terminal_p;
