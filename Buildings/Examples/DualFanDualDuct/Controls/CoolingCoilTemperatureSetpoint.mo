within Buildings.Examples.DualFanDualDuct.Controls;
block CoolingCoilTemperatureSetpoint "Set point scheduler for cooling coil"
  extends Modelica.Blocks.Icons.Block;
  import Buildings.Examples.VAVReheat.Controls.OperationModes;
  parameter Modelica.SIunits.Temperature TOn "Setpoint during on";
  parameter Modelica.SIunits.Temperature TOff "Setpoint during off";
  Modelica.Blocks.Sources.RealExpression TSetPoi(
     y=if (mode.y == Integer(OperationModes.occupied) or
           mode.y == Integer(OperationModes.unoccupiedPreCool) or
           mode.y == Integer(OperationModes.safety)) then TOn else TOff)
    "Air temperature setpoint"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  VAVReheat.Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{-28,-90},{-8,-70}})));
  Modelica.Blocks.Routing.IntegerPassThrough mode
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Modelica.Blocks.Interfaces.RealOutput TSet "Temperature set point"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(controlBus.controlMode, mode.u) annotation (Line(
      points={{-18,-80},{38,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TSetPoi.y, TSet) annotation (Line(
      points={{1,6.10623e-16},{54.5,6.10623e-16},{54.5,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation ( Icon(graphics={
        Text(
          extent={{44,16},{90,-18}},
          lineColor={0,0,255},
          textString="TSetCoo"),
        Text(
          extent={{-88,22},{-20,-26}},
          lineColor={0,0,255},
          textString="TSetHea")}));
end CoolingCoilTemperatureSetpoint;
