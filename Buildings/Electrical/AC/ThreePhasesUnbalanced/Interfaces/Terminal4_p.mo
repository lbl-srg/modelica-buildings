within Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces;
connector Terminal4_p
  "Terminal P for AC three-phase unbalanced systems (neutral cable)"
  Buildings.Electrical.AC.OnePhase.Interfaces.Terminal_p phase[4];
  annotation (Icon(graphics={                Polygon(
          points={{-100,110},{-100,70},{100,70},{100,110},{-100,110}},
          lineColor={127,0,127},
          fillColor={127,0,127},
          fillPattern=FillPattern.Solid),    Polygon(
          points={{-100,50},{-100,10},{100,10},{100,50},{-100,50}},
          lineColor={127,0,127},
          fillColor={127,0,127},
          fillPattern=FillPattern.Solid),    Polygon(
          points={{-100,-10},{-100,-50},{100,-50},{100,-10},{-100,-10}},
          lineColor={127,0,127},
          fillColor={127,0,127},
          fillPattern=FillPattern.Solid),    Polygon(
          points={{-100,-70},{-100,-110},{100,-110},{100,-70},{-100,-70}},
          lineColor={127,0,127},
          fillColor={127,0,127},
          fillPattern=FillPattern.Solid)}), Documentation(revisions="<html>
<ul>
<li>
October 9, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>Electric connector type p for AC three-phase unbalanced systems
with neutral cable connection.</p>
</html>"));
end Terminal4_p;
