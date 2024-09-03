within Buildings.Electrical.AC.ThreePhasesBalanced.Loads;
model Capacitive "Model of a capacitive and resistive load"
  extends Buildings.Electrical.AC.OnePhase.Loads.Capacitive(
    redeclare Interfaces.Terminal_n terminal,
    V_nominal(start=480));
  annotation (
  defaultComponentName="loa",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),      graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(points={{-2,-2.44921e-16},{10,0}},
                                         color={0,0,0},
          origin={-82,0},
          rotation=180),
        Text(
          extent={{-120,120},{120,80}},
          textColor={0,0,0},
          textString="%name"),
        Rectangle(
          extent={{-11,22},{11,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-44,1},
          rotation=90),
          Line(
          points={{0,0},{32,3.91873e-15}},
          color={0,0,0},
          origin={10,50},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{44,5.38825e-15}},
                                         color={0,0,0},
          origin={60,50},
          rotation=180),
        Rectangle(
          extent={{-11,22},{11,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-44,51},
          rotation=90),
        Rectangle(
          extent={{-11,22},{11,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-44,-51},
          rotation=90),
        Line(
          points={{60,50},{76,0},{60,-52}},
          color={0,0,0},
          smooth=Smooth.None),
          Line(points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
                                         color={0,0,0},
          origin={-66,50},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
                                         color={0,0,0},
          origin={-66,0},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
                                         color={0,0,0},
          origin={-66,-52},
          rotation=180),
        Line(
          points={{10,68},{10,32}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{16,68},{16,32}},
          color={0,0,0},
          smooth=Smooth.None),
          Line(points={{-6.85214e-44,-8.39117e-60},{60,7.34764e-15}},
                                         color={0,0,0},
          origin={76,0},
          rotation=180),
        Line(
          points={{16,18},{16,-18}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{10,18},{10,-18}},
          color={0,0,0},
          smooth=Smooth.None),
          Line(
          points={{0,0},{32,3.91873e-15}},
          color={0,0,0},
          origin={10,0},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{44,5.38825e-15}},
                                         color={0,0,0},
          origin={60,-52},
          rotation=180),
        Line(
          points={{16,-34},{16,-70}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{10,-34},{10,-70}},
          color={0,0,0},
          smooth=Smooth.None),
          Line(
          points={{0,0},{32,3.91873e-15}},
          color={0,0,0},
          origin={10,-52},
          rotation=180)}),       Documentation(info="<html>
<p>
Model of a capacitive load. See
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Loads.Capacitive\">
Buildings.Electrical.AC.OnePhase.Loads.Capacitive</a> for more information.
</p>
</html>",
      revisions="<html>
<ul>
<li>
August 24, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
January 2, 2012, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Capacitive;
