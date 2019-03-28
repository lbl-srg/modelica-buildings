within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.Validation;
model Setpoints_haveWSE
  "Validate sequence of specifying equipment setpoint based on head pressure control loop output"
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.Setpoints_haveWSE
    heaPreConEqu
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-220},{140,220}})));
end Setpoints_haveWSE;
