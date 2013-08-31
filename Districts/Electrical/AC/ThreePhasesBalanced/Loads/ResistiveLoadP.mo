within Districts.Electrical.AC.ThreePhasesBalanced.Loads;
model ResistiveLoadP "Model of a resistive load"
  extends Districts.Electrical.AC.OnePhase.Loads.ResistiveLoadP(
    redeclare Interfaces.Terminal_n terminal, V_nominal = 380);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
          Rectangle(
            extent={{-80,80},{80,-80}},
            lineColor={0,0,0},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
          origin={7.10543e-15,7.10543e-15},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{12,1.46953e-15}},
                                       color={0,0,0},
          origin={-80,0},
          rotation=180),
        Text(
          extent={{-120,120},{120,80}},
          lineColor={0,120,120},
          textString="%name"),
        Line(
          points={{-66,50},{-26,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-11,30},{11,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={4,49},
          rotation=90),
        Line(
          points={{34,50},{54,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{54,50},{70,0},{54,-50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{34,0},{70,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-11,30},{11,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={4,1},
          rotation=90),
        Line(
          points={{-66,0},{-26,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-66,-50},{-26,-50}},
          color={0,0,0},
          smooth=Smooth.None),
        Rectangle(
          extent={{-11,30},{11,-30}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={4,-49},
          rotation=90),
        Line(
          points={{34,-50},{54,-50}},
          color={0,0,0},
          smooth=Smooth.None)}),
          Documentation(info="<html>
<p>
Model of a resistive load. It may be used to model a load that has
a power factor of one.
</p>
<p>
The model computes the power as
<i>P = real(v &sdot; i<sup>*</sup>)</i>,
where <i>i<sup>*</sup></i> is the complex conjugate of the current.
Complex voltage and complex current are related as <i>v = R &nbsp; i</i>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 2, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end ResistiveLoadP;
