within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging.Subsequences;
package Validation "Collection of validation models"
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
          This package contains validation models for the classes in
          <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging\">
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Staging</a>.
          </p>
          <p>
          Note that most validation models contain simple input data
          which may not be realistic, but for which the correct
          output can be obtained through an analytic solution.
          The examples plot various outputs, which have been verified against these
          solutions. These model outputs are stored as reference data and
          used for continuous validation whenever models in the library change.
          </p>
          </html>"));
end Validation;
