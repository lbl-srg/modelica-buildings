within Districts.Electrical.AC.AC1ph.Interfaces;
connector Terminal_p "AC1ph terminal ('positive')"
  extends Districts.Electrical.Interfaces.Terminal(redeclare package
      PhaseSystem = Districts.Electrical.PhaseSystems.OnePhase);
  annotation (defaultComponentName = "term_p",
  Documentation(info="<html>
<p>Electric connector with a vector of 'pin's, positive.</p>
</html>
"),
  Window(
    x=0.45,
    y=0.01,
    width=0.44,
    height=0.65),
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
            fillColor={0,120,120},
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
          points={{50,50},{0,0},{50,-50},{100,0},{50,50}},
          lineColor={0,120,120},
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid)}));
end Terminal_p;
