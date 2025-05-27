within Buildings.Controls.OBC.CDL.Reals;
block IntegratorWithReset
  "Output the integral of the input signal"
  parameter Real k=1
    "Integrator gain";
  parameter Real y_start=0
    "Initial or guess value of output (= state)"
    annotation (Dialog(group="Initialization"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Input to be integrated"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y_reset_in
    "Input signal for state to which integrator is reset"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput trigger
    "Input that resets the integrator output when it becomes true"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={0,-120}),iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Value of the integrator"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));

initial equation
  y=y_start;

equation
  der(y)=k*u;
  when trigger then
    reinit(y, y_reset_in);
  end when;
  annotation (
    defaultComponentName="intWitRes",
    Icon(
      coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100.0,-100.0},{100.0,100.0}}),
      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-88,-94},{212,-54}},
          textColor={0,0,0},
          textString="y_reset_in",
          horizontalAlignment=TextAlignment.Left),
        Bitmap(
          extent={{-54,-50},{60,50}},
          fileName="modelica://Buildings/Resources/Images/Controls/OBC/CDL/Reals/int.png"),
        Text(
          extent={{-88,56},{206,92}},
          textColor={0,0,0},
          textString="k=%k",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-92,-12},{208,28}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="u"),
        Text(
          extent={{70,-14},{370,26}},
          textColor={0,0,0},
          horizontalAlignment=TextAlignment.Left,
          textString="y"),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{226,60},{106,10}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=3)))}),
    Documentation(
      info="<html>
<p>
Block that outputs
</p>
<p align=\"center\" style=\"font-style:italic;\">
y(t) = y<sub>start</sub> + &int;<sub>t<sub>0</sub></sub><sup>t</sup> u(s) ds.
</p>
<p>
Whenever the input signal <code>trigger</code> changes from <code>false</code>
to <code>true</code>,
the integrator is reset by setting <i>y<sub>start</sub></i>
to the value of the input signal <code>y_reset_in</code>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 8, 2023, by Michael Wetter:<br/>
Updated documentation.
</li>
<li>
February 2, 2022, by Michael Wetter:<br/>
Removed <code>unit=\"1\"</code> declaration for gain <code>k</code>.
This is to avoid the warning observed in
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/2872\">Buildings, issue 2872</a>.
</li>
<li>
October 21, 2021, by Michael Wetter:<br/>
Removed errorneous <code>visible</code> attribute in icon.
</li>
<li>
August 3, 2020, by Jianjun:<br/>
Fixed the input <code>y_reset_in</code>.
<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2056\">Buildings, issue 2056</a>.
</li>
<li>
April 21, 2020, by Michael Wetter:<br/>
Removed parameter <code>initType</code>.
<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1887\">Buildings, issue 1887</a>.
</li>
<li>
March 2, 2020, by Michael Wetter:<br/>
Changed icon to display dynamically the output value.
</li>
<li>
November 6, 2017, by Michael Wetter:<br/>
Explicitly declared types from CDL.
</li>
<li>
March 23, 2017, by Jianjun Hu:<br/>
First implementation, based on the implementation of
<a href=\"modelica://Buildings.Utilities.Math.IntegratorWithReset\">
Buildings.Utilities.Math.IntegratorWithReset</a>.
</li>
</ul>
</html>"));
end IntegratorWithReset;
