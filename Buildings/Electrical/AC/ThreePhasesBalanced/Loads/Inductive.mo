within Buildings.Electrical.AC.ThreePhasesBalanced.Loads;
model Inductive "Model of an inductive and resistive load"
  extends Buildings.Electrical.AC.OnePhase.Loads.Inductive(
    redeclare Interfaces.Terminal_n terminal,
    V_nominal(start=480));
  annotation (
  defaultComponentName="loa",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
                                   Rectangle(extent={{-100,100},{100,-100}},
            lineColor={255,255,255}),
        Ellipse(extent={{-10,-10},{10,10}},
          rotation=360),
        Ellipse(extent={{30,-10},{50,10}}),
        Ellipse(extent={{10,-10},{30,10}}),
        Rectangle(
          extent={{-10,0},{50,-12}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Line(points={{0,0},{12,1.46953e-15}},
                                         color={0,0,0},
          origin={-10,0},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{26,3.18398e-15}},
                                         color={0,0,0},
          origin={76,0},
          rotation=180),
        Rectangle(
          extent={{-11,22},{11,-22}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-44,1},
          rotation=90),
          Line(points={{-2,-2.44921e-16},{10,0}},
                                         color={0,0,0},
          origin={-82,0},
          rotation=180),
        Text(
          extent={{-120,120},{120,80}},
          textColor={0,0,0},
          textString="%name"),
        Ellipse(extent={{-10,-10},{10,10}},
          origin={0,50},
          rotation=360),
        Ellipse(extent={{30,40},{50,60}}),
        Ellipse(extent={{10,40},{30,60}}),
        Rectangle(
          extent={{-10,50},{50,38}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Line(points={{0,0},{12,1.46953e-15}},
                                         color={0,0,0},
          origin={-10,50},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
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
        Ellipse(extent={{-10,-10},{10,10}},
          origin={0,-52},
          rotation=360),
        Ellipse(extent={{30,-62},{50,-42}}),
        Ellipse(extent={{10,-62},{30,-42}}),
        Rectangle(
          extent={{-10,-52},{50,-64}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
          Line(points={{0,0},{12,1.46953e-15}},
                                         color={0,0,0},
          origin={-10,-52},
          rotation=180),
          Line(points={{-6.85214e-44,-8.39117e-60},{10,1.22461e-15}},
                                         color={0,0,0},
          origin={60,-52},
          rotation=180),
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
          rotation=180)}),    Documentation(info="<html>
<p>
Model of an inductive load. See
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Loads.Inductive\">
Buildings.Electrical.AC.OnePhase.Loads.Inductive</a> for more information.
</p>
</html>", revisions="<html>
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
end Inductive;
