within Buildings.Controls.OBC.ASHRAE.FanCoilUnit;
package Validation "Package of validation models for fan coil unit controls"

  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Polygon(
          origin={8,14},
          lineColor={78,138,73},
          fillColor={78,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}})}),
  Documentation(info="<html>
  <p>
  This package contains the validation model for the fan coil unit controller.
  </p>
  </html>", revisions="<html>
  <ul>
  <li>
  March 22, 2022, by Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end Validation;
