within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Stage;
block ConditionsForPositiveDisplacement
  "Stage change conditions for positive displacement chillers"
  CDL.Interfaces.RealInput uCapReq(final unit="K", final quantity=
        "ThermodynamicTemperature")
    "Chilled water cooling capacity requirement" annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}), iconTransformation(
          extent={{-120,-10},{-100,10}})));
  CDL.Interfaces.RealInput                        uCapNomSta(final unit="K",
      final quantity="ThermodynamicTemperature")
    "Nominal capacity of the current stage"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-120,20},{-100,40}})));
  CDL.Interfaces.RealInput uCapNomLowSta(final quantity="VolumeFlowRate",
      final unit="m3/s") "Nominal capacity of the first lower stage"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-120,24},{-100,44}})));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ConditionsForPositiveDisplacement;
