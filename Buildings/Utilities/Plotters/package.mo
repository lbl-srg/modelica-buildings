within Buildings.Utilities;
package Plotters "Package with blocks to create plots"
  extends Modelica.Icons.Package;

  annotation (Documentation(info="<html>
<p>
Package with blocks that allow generating
time series and scatter plots, and writing these plots to
one or several html files.
The plots can be deactivated based on an input signal and a time
delay, for example, to plot data only while the HVAC system
operates for at least <i>30</i> minutes.
</p>
<p>
See
<a href=\"modelica://Buildings.Utilities.Plotters.UsersGuide\">
Buildings.Utilities.Plotters.UsersGuide</a>
for instructions.
</p>
</html>"), Icon(graphics={
          Polygon(
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            points={{82,-68},{60,-60},{60,-76},{82,-68}}),
          Polygon(
            lineColor={0,0,0},
            fillColor={0,0,0},
            fillPattern=FillPattern.Solid,
            points={{-74,80},{-82,58},{-66,58},{-74,80}}),
          Line(
            points={{-74,68},{-74,-78}},
            color={0,0,0}),
    Line(origin={4.061,-33.816},
        points={{81.939,36.056},{65.362,36.056},{21.939,17.816},{-8.061,75.816},
              {-36.061,5.816},{-78.061,23.816}},
        color={0,0,0},
        smooth=Smooth.Bezier),
          Line(
            points={{-84,-68},{76,-68}},
            color={0,0,0})}));
end Plotters;
