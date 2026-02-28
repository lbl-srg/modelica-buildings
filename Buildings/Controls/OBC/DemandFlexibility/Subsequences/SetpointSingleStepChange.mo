within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block SetpointSingleStepChange
  CDL.Interfaces.RealInput TSetMax(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") annotation (Placement(
        transformation(extent={{-140,24},{-100,64}}), iconTransformation(extent
          ={{-240,-214},{-200,-174}})));
  CDL.Interfaces.RealInput TSetMin(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(
          extent={{-238,-250},{-198,-210}})));
  CDL.Interfaces.RealOutput TSetCom(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") annotation (Placement(
        transformation(extent={{100,-20},{140,20}}), iconTransformation(extent=
            {{-238,-250},{-198,-210}})));
  CDL.Discrete.Sampler                        sam(samplePeriod=
        samplePeriodRatchet)
    annotation (Placement(transformation(extent={{4,-18},{24,2}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SetpointSingleStepChange;
