within Buildings.Controls.OBC.ChilledBeams;
package SetPoints "Package with sequences for controlling system setpoints"
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
        Text(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          textString="S")}),
  Documentation(info="<html>
    <p>
    This package contains sequences for setpoint calculations for the system.
    </p>
    </html>"));
end SetPoints;
