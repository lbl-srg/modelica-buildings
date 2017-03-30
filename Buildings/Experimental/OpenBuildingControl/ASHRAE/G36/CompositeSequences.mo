within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36;
package CompositeSequences
  model EconomizerDocuTemporary

    annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
          coordinateSystem(preserveAspectRatio=false)),
    defaultComponentName = "setPoiVAV",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
              {100,100}}),                                        graphics={
          Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          lineColor={0,0,255}),
      Polygon(
        points={{80,-76},{58,-70},{58,-82},{80,-76}},
        lineColor={95,95,95},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
      Line(points={{8,-76},{78,-76}},   color={95,95,95}),
      Line(points={{-54,-22},{-54,-62}},color={95,95,95}),
      Polygon(
        points={{-54,0},{-60,-22},{-48,-22},{-54,0}},
        lineColor={95,95,95},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-88,-6},{-47,-26}},
        lineColor={0,0,0},
            textString="T"),
      Text(
        extent={{64,-82},{88,-93}},
        lineColor={0,0,0},
            textString="u"),
          Line(
            points={{-44,-6},{-30,-6},{-14,-42},{26,-42},{38,-62},{60,-62}},
            color={0,0,255},
            thickness=0.5),
          Line(
            points={{-44,-6},{-30,-6},{-14,-42},{2,-42},{18,-66},{60,-66}},
            color={255,0,0},
            pattern=LinePattern.Dot,
            thickness=0.5),
      Line(points={{-4,-76},{-60,-76}}, color={95,95,95}),
      Polygon(
        points={{-64,-76},{-42,-70},{-42,-82},{-64,-76}},
        lineColor={95,95,95},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
          Text(
            extent={{-98,90},{-72,68}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="uHea"),
          Text(
            extent={{-96,50},{-70,28}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="uCoo"),
          Text(
            extent={{68,72},{94,50}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="THea"),
          Text(
            extent={{68,12},{94,-10}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="TCoo"),
          Text(
            extent={{74,-50},{100,-72}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="y"),
          Text(
            extent={{-96,-30},{-70,-52}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="TZon"),
          Text(
            extent={{-98,-68},{-72,-90}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="TOut"),
      Line(points={{-54,50},{-54,10}},  color={95,95,95}),
      Polygon(
        points={{-54,72},{-60,50},{-48,50},{-54,72}},
        lineColor={95,95,95},
        fillColor={95,95,95},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-88,68},{-47,48}},
        lineColor={0,0,0},
            textString="y"),
          Line(points={{-46,44},{-28,20},{18,20},{28,36},{38,36},{50,54}}, color={
                0,0,0}),
          Line(points={{18,20},{38,20},{50,54},{28,54},{18,20}}, color={0,0,0}),
          Text(
            extent={{-96,12},{-70,-10}},
            lineColor={0,0,127},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            textString="TSetZon")}),
          Diagram(
          coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-420},{100,220}}), graphics={
          Rectangle(
            extent={{-88,-314},{70,-400}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Rectangle(
            extent={{-88,-214},{70,-300}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{32,-304},{68,-286}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            textString="0.25 < y < 0.5"),
          Text(
            extent={{32,-404},{68,-386}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            textString="0.75 < y < 1"),
          Rectangle(
            extent={{-88,-172},{70,-210}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{30,-212},{66,-194}},
            lineColor={0,0,0},
            fillColor={215,215,215},
            fillPattern=FillPattern.Solid,
            textString="0.5 < y < 0.75")}),
      Documentation(info="<html>
<p>
Fixme
This is initial and somewhat broad documentation based on comments from BE. 
G36. The documentation should turn into a description how sequences 1, 2, and 3 
get combined in EconomizerSequence. Add block diagram that explains how the 
3 sequences interact, point to their individual documentations.
</p>
<p>
Economizer damper is used to control the outdor airflow to the building HVAC 
system. The economizer is primarily used to reduce the heating and cooling 
energy consumption, but depending on the configuration it is also be used to
satisfy the minimum outdoor air requirement, as perscribed by the applicable
building code. Thus we differentiate between a single common economizer 
damper and a separate minimum outdoor air damper. In case of a separate minimum
outdoor air damper, the first control sequence described bellow should get 
modified. However, the three sequences we utilize are the most generic version
of economizer control as described in G36.
<p>
The first control sequence resets the MinOA-P (minimum outside air damper 
position) and the MaxRA-P (maximum return air damper position). A PI 
controller determines mentioned damper postion limits based on the error between 
outdoor air setpoint and measured outdoor airflow.
</p>
<p>
Sequence 1: MinOAReset
</p>
<p>
Inputs: OA volume setpoint, OA volume measurement
</p>
<p>
Outputs: MinOA-P setpoint, MaxRA-P setpoint
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/SingleCommonEconDamperMinOA.png\"/>
</p>
<p>
The second sequence is the high limit lockout used to disable the economizer, 
in other words to set the MaxOA-P = MinOA-P.
Fixme: List variables as provided on the chart below.
</p>
<p>
Sequence 2: Enable-disable more suitable (based on Pauls comments about low temp shutdown to MinOA-P):
- Includes high limit lockout, freezestat [fixme: and MAT temperature (in case that there is a 
MAT sensor - space average accross the coil?)]
</p>


</p>
<p>
Inputs: TOut, Freezstat status, time since last disable, [fixme: MAT temperature 
(based on answer from Pau)?
</p>
<p>
Outputs: MaxOA-P setpoint (set to min if disabled)
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/EconHighLimitLockout.png\"/>
</p>
<p>
The third control sequence modulates OA and RA dampers. It takes MinOA-P and 
MaxRA-P outputs from the first sequence as inputs that set the corresponding 
damper position limits. The positions for both OA and RA dampers are set by 
a single PI loop. The damper positions are modulated between the MinOA-P 
(MinRA-P) and MaxOA-P (MaxRA-P) positions based on the control signal from a 
controller which regulates SAT to SATsp. The heating signal must be off.
</p>
<p>
Sequence 3: DamperModulation
</p>
<p>
Inputs: SAT measurement, SAT setpoint, MinOA-P, MaxOA-P (100% or set at 
comissioning, thus parameter), MaxRA-P
</p>
<p>
Outputs: OA-P, RA-P
</p>
<p align=\"center\">
<img alt=\"Image of set point reset\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/DamperModulationSequenceEcon.PNG\"/>
</p>







<p>
Fixme: Leaving VAV docs here for now, remove when harmonized.
</p>
<p>
For the temperature set points, the
parameters are the maximum supply air temperature <code>TMax</code>,
and the minimum supply air temperature for cooling <code>TMin</code>.
The deadband temperature is equal to the
average set point for the zone temperature
for heating and cooling, as obtained from the input <code>TSetZon</code>,
constraint to be within <i>21</i>&deg;C (&asymp;<i>70</i> F) and
<i>24</i>&deg;C (&asymp;<i>75</i> F).
The setpoints are computed as shown in the figure below.
Note that the setpoint for the supply air temperature for heating is
lower than <code>TMin</code>, as shown in the figure.
</p>
<p>
For the fan speed set point, the
parameters are the maximu fan speed at heating <code>yHeaMax</code>,
the minimum fan speed <code>yMin</code> and
the maximum fan speed for cooling <code>yCooMax</code>.
For a cooling control signal of <code>yCoo &gt; 0.25</code>,
the speed is faster increased the larger the difference is between
the zone temperature minus outdoor temperature <code>TZon-TOut</code>.
The figure below shows the sequence.
</p>
Note that the inputs <code>uHea</code> and <code>uCoo</code> must be computed
based on the same temperature sensors and control loops.
</p>
</html>",   revisions="<html>
<ul>
<li>
January 10, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end EconomizerDocuTemporary;

  package Validation
    annotation (Icon(graphics={
          Rectangle(
            lineColor={200,200,200},
            fillColor={248,248,248},
            fillPattern=FillPattern.HorizontalCylinder,
            extent={{-100,-100},{100,100}},
            radius=25),
          Polygon(
            origin={18,24},
            lineColor={78,138,73},
            fillColor={78,138,73},
            pattern=LinePattern.None,
            fillPattern=FillPattern.Solid,
            points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}));
  end Validation;
  annotation (Icon(graphics={
        Rectangle(
          extent={{-70,60},{-30,20}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Rectangle(
          extent={{-70,-20},{-30,-60}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Rectangle(
          extent={{30,20},{70,-20}},
          lineColor={28,108,200},
          lineThickness=0.5),
        Line(
          points={{-30,40},{0,40},{0,10},{30,10}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-30,-40},{0,-40},{0,-10},{30,-10}},
          color={28,108,200},
          thickness=0.5)}));
end CompositeSequences;
