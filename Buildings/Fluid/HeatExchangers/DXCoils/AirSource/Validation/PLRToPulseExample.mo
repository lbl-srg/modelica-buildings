within Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Validation;
model PLRToPulseExample
  PLRToPulse pLRToPulse
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.TimeTable plr_onOff(table=[0,0; 3600,0; 3600,0; 7200,
        0.3; 7200,0.3; 10800,0.3; 10800,0.3; 14400,0.3; 14400,0.3; 18000,0;
        18000,0; 21600,0; 21600,0; 25200,0; 25200,0.5; 28800,0.5; 28800,0.5;
        32400,0.5; 32400,0.5; 36000,0.8; 36000,0.8; 39600,0.8; 39600,0.8; 43200,
        0.8; 43200,0.8; 46800,0.8; 46800,0.8; 50400,1; 50400,1; 54000,1; 54000,
        1; 57600,1; 57600,1; 61200,1; 61200,1; 64800,0; 64800,0; 68400,0.38;
        68400,0.38; 72000,0.38; 72000,0.38; 75600,0.38; 75600,0.38; 79200,0.38;
        79200,0.38; 82800,0; 82800,0; 86400,0])
    "EnergyPlus PLR converted into on-off signal for this model"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
equation
  connect(plr_onOff.y, pLRToPulse.uPLR)
    annotation (Line(points={{-29,0},{-12,0}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PLRToPulseExample;
