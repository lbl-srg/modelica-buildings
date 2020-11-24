within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging;
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
          lineColor={0,0,0},
          textString="S")}),
    Documentation(info="<html>
    <p>
    This package contains boiler stage setpoint control sequences. The implementation
    is based on section 5.3.3 in ASHRAE RP-1711, Draft on March 23, 2020. </p>
</html>"));
end SetPoints;
