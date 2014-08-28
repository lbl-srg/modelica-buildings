within Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads;
model Capacitive_N "Model of a capacitive load with neutral cable"
  extends BaseClasses.PartialLoad_N(
    redeclare Buildings.Electrical.AC.OnePhase.Loads.Capacitive load1(pf=pf),
    redeclare Buildings.Electrical.AC.OnePhase.Loads.Capacitive load2(pf=pf),
    redeclare Buildings.Electrical.AC.OnePhase.Loads.Capacitive load3(pf=pf));
  parameter Real pf(min=0, max=1) = 0.8 "Power factor"  annotation(Dialog(group="Nominal conditions"));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Line(points={{-42,-5.14335e-15},{10,0}},
                                         color={0,0,0},
          origin={-2,0},
          rotation=180),
          Line(points={{-26,-3.18398e-15},{6.85214e-44,8.39117e-60}},
                                         color={0,0,0},
          origin={48,0},
          rotation=180),
          Line(points={{-10,-1.22461e-15},{10,0}},
                                         color={0,0,0},
          origin={-82,0},
          rotation=180),
          Line(points={{-2,-2.44921e-16},{16,1.95937e-15}},
                                         color={0,0,0},
          origin={-82,0},
          rotation=180),
        Text(
          extent={{-120,120},{120,80}},
          lineColor={0,120,120},
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
          rotation=180)}), Documentation(revisions="<html>
<ul>
<li>
August 27, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a three phases unbalanced capacitive load.
The model extends from 
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses.PartialLoad_N\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses.PartialLoad_N</a>
and uses the load model from the package
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Loads\">
Buildings.Electrical.AC.OnePhase.Loads</a>. The model is able to provide detailed
information about the actual voltages, currents and powers on each phase.
</p>
<p>
This model has a connector with four cable and it does represent the neutral cable.
The current in the neutral cable is computed as the algebraic sum of the currents
of the loads.
</p>
<p>
For more information see <a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses.PartialLoad_N\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Loads.BaseClasses.PartialLoad_N</a> and 
<a href=\"modelica://Buildings.Electrical.AC.OnePhase.Loads.Capacitive\">
Buildings.Electrical.AC.OnePhase.Loads.Capacitive</a>.
</p>
</html>"));
end Capacitive_N;
