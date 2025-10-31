within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging;
package SetPoints "Package for boiler plant staging setpoint control sequences"

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
          textColor={0,0,0},
          textString="S")}),
    Documentation(info="<html>
    <p>
    This package contains boiler stage setpoint control sequences. The implementation
    is based on section 5.21.3 in ASHRAE Guideline 36, 2021. </p>
</html>"));
end SetPoints;
