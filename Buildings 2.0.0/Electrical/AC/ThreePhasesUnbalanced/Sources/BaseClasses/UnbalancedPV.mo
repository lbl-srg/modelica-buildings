within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses;
model UnbalancedPV
  "Base model for an unbalanced PV source without neutral cable"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.BaseUnbalancedPV;
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.PartialSource;
equation

  if plugPhase1 then
    connect(connection3to4.terminal4.phase[1], pv_phase1.terminal) annotation (Line(
        points={{40,4.44089e-16},{0,4.44089e-16},{0,50},{-18,50}},
        color={127,0,127},
        smooth=Smooth.None));
  end if;

  if plugPhase2 then
    connect(connection3to4.terminal4.phase[2], pv_phase2.terminal) annotation (Line(
      points={{40,0},{20,0},{20,4.44089e-16},{-20,4.44089e-16}},
      color={127,0,127},
      smooth=Smooth.None));
  end if;

  if plugPhase3 then
    connect(connection3to4.terminal4.phase[3], pv_phase3.terminal) annotation (Line(
        points={{40,0},{0,0},{0,-50},{-20,-50}},
        color={127,0,127},
        smooth=Smooth.None));
  end if;

  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
        Line(points={{58,0},{92,0}},   color={0,0,0}),
        Text(
          extent={{-140,-100},{160,-60}},
          textString="%name",
          lineColor={0,0,255}),
        Polygon(
          points={{80,-52},{32,63},{-78,63},{-29,-52},{80,-52}},
          smooth=Smooth.None,
          fillColor={205,203,203},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-32,27},{-44,53},{-67,53},{-56,27},{-32,27}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-16,-9},{-28,17},{-51,17},{-40,-9},{-16,-9}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{-1,-45},{-13,-19},{-36,-19},{-25,-45},{-1,-45}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{1,27},{-11,53},{-34,53},{-23,27},{1,27}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{17,-9},{5,17},{-18,17},{-7,-9},{17,-9}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{32,-45},{20,-19},{-3,-19},{8,-45},{32,-45}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{34,27},{22,53},{-1,53},{10,27},{34,27}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{50,-9},{38,17},{15,17},{26,-9},{50,-9}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{65,-45},{53,-19},{30,-19},{41,-45},{65,-45}},
          smooth=Smooth.None,
          fillColor={6,13,150},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None)}),
    Documentation(info="<html>
<p>
This model is a class extended by three-phase unbalanced
PV power sources without neutral cable.
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
end UnbalancedPV;
