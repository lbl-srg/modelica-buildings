within Districts.Electrical.DC.Interfaces;
connector TwoPin_n "DC terminal ('negative')"
extends Districts.Electrical.Interfaces.Terminal(redeclare package PhaseSystem
      =           Districts.Electrical.PhaseSystems.TwoConductor);
annotation (defaultComponentName = "term_n",
Documentation(info="<html>
<p>Electric connector with a vector of 'pin's, negative.</p>
</html>"),
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
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
        extent={{-60,60},{60,-60}},
        lineColor={0,0,255},
        pattern=LinePattern.None,
        lineThickness=0.5,
        textString="")}),
Diagram(coordinateSystem(
      preserveAspectRatio=false,
      extent={{-100,-100},{100,100}},
      grid={2,2}), graphics={
      Text(
        extent={{-100,120},{120,60}},
        lineColor={0,0,255},
        textString="%name"),
      Polygon(
        points={{-100,0},{-40,-60},{20,0},{-40,60},{-100,0}},
        lineColor={0,0,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-90,50},{10,-50}},
        lineColor={0,0,255},
        pattern=LinePattern.None,
        lineThickness=0.5,
        textString="")}));
end TwoPin_n;
