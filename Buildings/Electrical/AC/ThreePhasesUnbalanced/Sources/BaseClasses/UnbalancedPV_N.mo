within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses;
model UnbalancedPV_N
  "Base model for an unbalanced PV source with neutral cable"
  extends
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.BaseClasses.BaseUnbalancedPV;
  Interfaces.Terminal4_p terminal
    "Connector for three-phase unbalanced systems with neutral cable"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));
  Interfaces.Connection3to4_p conn3to4 "Connection between 3 to 4 wire"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={40,0})));
protected
  Interfaces.Adapter3to3 ada "Adapter"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation

  if plugPhase1 then
    connect(pv_phase1.terminal, ada.terminals[1]) annotation (Line(points={{-18,50},
            {-8,50},{-8,-0.533333},{0,-0.533333}},
                                                 color={0,120,120}));
  end if;

  if plugPhase2 then
    connect(pv_phase2.terminal, ada.terminals[2])
    annotation (Line(points={{-20,0},{-10,0},{0,0}}, color={0,120,120}));
  end if;

  if plugPhase3 then
    connect(pv_phase3.terminal, ada.terminals[3]) annotation (Line(points={{-20,-50},
            {-8,-50},{-8,0.533333},{0,0.533333}},
                                                color={0,120,120}));
  end if;

  connect(conn3to4.terminal4, terminal) annotation (Line(
      points={{50,0},{100,0}},
      color={127,0,127},
      smooth=Smooth.None));

  connect(ada.terminal, conn3to4.terminal3)
    annotation (Line(points={{20,0},{25,0},{30,0}}, color={0,120,120}));
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
PV power sources with neutral cable connection.
</p>
<p>
The neutral cable is connected to the ground reference.
</p>
</html>",
        revisions="<html>
<ul>
<li>
February 26, 2016, by Michael Wetter:<br/>
Added adapter for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">issue 426</a>.
</li>
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
end UnbalancedPV_N;
