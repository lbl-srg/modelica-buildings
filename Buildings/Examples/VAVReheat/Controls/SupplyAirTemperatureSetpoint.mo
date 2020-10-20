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
  Modelica.Blocks.Routing.IntegerPassThrough mode
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Modelica.Blocks.Sources.RealExpression ext(y=TSetVal[mode.y].y)
    "Extract set point value corresponding to actual mode"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(TSet, controlBus.TAirSupSet) annotation (Line(points={{120,0},{80,0},
          {80,-80},{0,-80}},color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(controlBus.controlMode, mode.u) annotation (Line(
      points={{0,-80},{0,-60},{18,-60}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(ext.y, TSet)
    annotation (Line(points={{21,0},{64,0},{64,0},{120,0}}, color={0,0,127}));
  annotation (defaultComponentName="TAirSupSet",
    Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SupplyAirTemperatureSetpoint;
