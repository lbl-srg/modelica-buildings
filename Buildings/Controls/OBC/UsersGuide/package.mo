within Buildings.Controls.OBC;
package UsersGuide "User's Guide"
  extends Modelica.Icons.Information;

  annotation (preferredView="info",
  Documentation(info="<html>
<p>
The package <a href=\"modelica://Buildings.Controls.OBC\">Buildings.Controls.OBC</a>
contains models for building control. The control sequences, which includes the HVAC
airside system control 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1\">Buildings.Controls.OBC.ASHRAE.G36_PR1</a>,
the outdoor lighting control <a href=\"modelica://Buildings.Controls.OBC.OutdoorLights\">Buildings.Controls.OBC.OutdoorLights</a>,
and the shading device control <a href=\"modelica://Buildings.Controls.OBC.Shade\">Buildings.Controls.OBC.Shade</a>,
are composed by the elementary blocks from the package
<a href=\"modelica://Buildings.Controls.OBC.CDL\">Buildings.Controls.OBC.CDL</a>.
</p>
<p>
The package also contains the models for unit conversions
<a href=\"modelica://Buildings.Controls.OBC.UnitConversions\">Buildings.Controls.OBC.UnitConversions</a>
and the utilities models like
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">Buildings.Controls.OBC.Utilities.OptimalStart</a>,
which outputs the optimal start time for an HVAC system before occupancy.
</p>
</html>"));
end UsersGuide;
