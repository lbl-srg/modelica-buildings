within Buildings.Controls.OBC;
package UsersGuide "User's Guide"
  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The package <a href=\"modelica://Buildings.Controls.OBC\">Buildings.Controls.OBC</a>
contains models for building control. The control sequences, which include the HVAC
airside system control
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1\">Buildings.Controls.OBC.ASHRAE.G36_PR1</a>,
the outdoor lighting control <a href=\"modelica://Buildings.Controls.OBC.OutdoorLights\">Buildings.Controls.OBC.OutdoorLights</a>,
and the shading device control <a href=\"modelica://Buildings.Controls.OBC.Shade\">Buildings.Controls.OBC.Shade</a>,
are composed of the elementary blocks from the package
<a href=\"modelica://Buildings.Controls.OBC.CDL\">Buildings.Controls.OBC.CDL</a>.
</p>
<p>
The package also contains models for unit conversions,
<a href=\"modelica://Buildings.Controls.OBC.UnitConversions\">Buildings.Controls.OBC.UnitConversions</a>,
and utilities models, such as
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">Buildings.Controls.OBC.Utilities.OptimalStart</a>,
which output the optimal start time for an HVAC system.
</p>
</html>"),
  Icon(graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(origin={-4.167,-15},
          fillColor={255,255,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-15.833,20.0},{-15.833,30.0},{14.167,40.0},{24.167,20.0},{4.167,-30.0},{14.167,-30.0},{24.167,-30.0},{24.167,-40.0},{-5.833,-50.0},{-15.833,-30.0},{4.167,20.0},{-5.833,20.0}},
          smooth=Smooth.Bezier),
        Ellipse(origin={7.5,56.5},
          fillColor={255,255,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-12.5,-12.5},{12.5,12.5}})}));
end UsersGuide;
