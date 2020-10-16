within Buildings.Examples.VAVReheat.Controls;
block SupplyAirTemperatureSetpoint
  "Block computing the supply air temperature set point based on the operation mode"
  extends Modelica.Blocks.Icons.Block;
  ControlBus controlBus
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSet(
    final unit="K",
    displayUnit="degC")
    "Supply air temperature set point"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetVal[6](k={12,12,35,
        35,12,7} .+ 273.15)          "Set point values for each operating mode"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(nin=6)
    "Extract actual set point"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(controlBus.controlMode, extIndSig.index) annotation (Line(
      points={{0,-80},{0,-12}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(TSetVal.y, extIndSig.u)
    annotation (Line(points={{-38,0},{-12,0}}, color={0,0,127}));
  connect(extIndSig.y, TSet)
    annotation (Line(points={{12,0},{120,0}}, color={0,0,127}));
  connect(TSet, controlBus.TAirSupSet) annotation (Line(points={{120,0},{60,0},{
          60,-80},{0,-80}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation (defaultComponentName="TAirSupSet",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SupplyAirTemperatureSetpoint;
