within Buildings.Electrical.AC.OnePhase.Interfaces;
connector Terminal_n "Terminal n for AC one phase systems"
  extends Buildings.Electrical.Interfaces.Terminal(
    redeclare replaceable package PhaseSystem =
        Buildings.Electrical.PhaseSystems.OnePhase);
  annotation (defaultComponentName = "term_p",
  Documentation(info="<html>
<p>Electric connector for AC one phase systems.</p>
</html>"),
  Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={           Text(
          extent={{-60,60},{60,-60}},
          textColor={255,255,255},
          pattern=LinePattern.None,
          textString=""),                    Polygon(
          points={{0,100},{-100,0},{0,-100},{100,0},{0,100}},
          lineColor={0,120,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Text(
          extent={{-120,120},{100,60}},
          textColor={0,120,120},
          textString="%name"),
        Text(
          extent={{14,16},{114,-84}},
          textColor={255,255,255},
          pattern=LinePattern.None,
          textString=""),                    Polygon(
          points={{-50,50},{-100,0},{-50,-50},{0,0},{-50,50}},
          lineColor={0,120,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Terminal_n;
