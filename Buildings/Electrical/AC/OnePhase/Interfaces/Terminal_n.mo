within Buildings.Electrical.AC.OnePhase.Interfaces;
connector Terminal_n "Terminal n for AC one phase systems"
  extends Buildings.Electrical.Interfaces.Terminal(
    redeclare replaceable package PhaseSystem =
        Buildings.Electrical.PhaseSystems.OnePhase);
  // fixme: Shouldn't Termminal_p and Terminal_n declare the PhaseSystem
  // as final rathern than replaceable. Otherwise, someone may replace
  // the phase system, but still has the same icon for the connector.
  annotation (defaultComponentName = "term_p",
  Documentation(info="<html>
<p>Electric connector for AC one phase systems.</p>
</html>
"),
  Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={           Text(
          extent={{-60,60},{60,-60}},
          lineColor={255,255,255},
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
          lineColor={0,120,120},
          textString="%name"),
        Text(
          extent={{14,16},{114,-84}},
          lineColor={255,255,255},
          pattern=LinePattern.None,
          textString=""),                    Polygon(
          points={{-50,50},{-100,0},{-50,-50},{0,0},{-50,50}},
          lineColor={0,120,120},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}));
end Terminal_n;
