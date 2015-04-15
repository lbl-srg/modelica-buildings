within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses;
model UnbalancedWindTurbine
  "Base model for an unbalanced wind power source without neutral cable"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.BaseUnbalancedWindTurbine;
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.PartialSource;

equation
  if plugPhase1 then
    connect(connection3to4.terminal4.phase[1],wt_phase1.terminal) annotation (Line(
        points={{40,4.44089e-16},{0,4.44089e-16},{0,50},{-18,50}},
        color={127,0,127},
        smooth=Smooth.None));
  end if;

  if plugPhase2 then
    connect(connection3to4.terminal4.phase[2],wt_phase2.terminal) annotation (Line(
      points={{40,0},{20,0},{20,4.44089e-16},{-20,4.44089e-16}},
      color={127,0,127},
      smooth=Smooth.None));
  end if;

  if plugPhase3 then
    connect(connection3to4.terminal4.phase[3],wt_phase3.terminal) annotation (Line(
        points={{40,0},{0,0},{0,-50},{-20,-50}},
        color={127,0,127},
        smooth=Smooth.None));
  end if;

  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          pattern=LinePattern.None,
          fillColor={202,230,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{42,44},{46,-54}},
          fillColor={233,233,233},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Rectangle(
          extent={{-42,12},{-38,-86}},
          fillColor={233,233,233},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-44,10},{-26,-42},{-38,14},{-44,10}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-38,10},{8,44},{-42,16},{-38,10}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-42,10},{-90,38},{-38,16},{-42,10}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{40,42},{100,38},{42,48},{40,42}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,0}),
        Polygon(
          points={{-21,-17},{27,17},{-25,-11},{-21,-17}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          origin={29,67},
          rotation=90,
          lineColor={0,0,0}),
        Polygon(
          points={{24,-14},{-20,22},{26,-8},{24,-14}},
          smooth=Smooth.None,
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid,
          origin={32,18},
          rotation=90,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-46,18},{-34,6}},
          lineColor={0,0,0},
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{38,50},{50,38}},
          lineColor={0,0,0},
          fillColor={222,222,222},
          fillPattern=FillPattern.Solid)}),
    Documentation(info="<html>
<p>
This model is a class extended by three-phase unbalanced
wind turbine power sources without neutral cable.
</p>
</html>",
        revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Revised model and documentation.
</li>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end UnbalancedWindTurbine;
