within Districts.Electrical.DC.Interfaces;
connector TwoPin_p "DC terminal ('positive')"
  extends Districts.Electrical.Interfaces.Terminal(redeclare package
      PhaseSystem = Districts.Electrical.PhaseSystems.TwoConductor);
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
        grid={2,2}), graphics={Polygon(
          points={{-120,0},{0,-120},{120,0},{0,120},{-120,0}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-60,60},{60,-60}},
          lineColor={255,255,255},
          pattern=LinePattern.None,
          textString="")}),
  Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2}), graphics={
        Text(
          extent={{-120,120},{100,60}},
          lineColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{-20,0},{40,-60},{100,0},{40,60},{-20,0}},
          lineColor={0,0,255},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{14,16},{114,-84}},
          lineColor={255,255,255},
          pattern=LinePattern.None,
          textString="")}));
end TwoPin_p;
