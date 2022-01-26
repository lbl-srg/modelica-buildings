within Buildings.Examples.VAVReheat.BaseClasses.Controls;
block RoomTemperatureSetpoint "Set point scheduler for room temperature"
  extends Modelica.Blocks.Icons.Block;
  import Buildings.Examples.VAVReheat.BaseClasses.Controls.OperationModes;
  parameter Modelica.Units.SI.Temperature THeaOn=293.15
    "Heating setpoint during on";
  parameter Modelica.Units.SI.Temperature THeaOff=285.15
    "Heating setpoint during off";
  parameter Modelica.Units.SI.Temperature TCooOn=297.15
    "Cooling setpoint during on";
  parameter Modelica.Units.SI.Temperature TCooOff=303.15
    "Cooling setpoint during off";
  BaseClasses.Controls.ControlBus controlBus
    annotation (Placement(transformation(extent={{10,50},{30,70}})));
  Modelica.Blocks.Routing.IntegerPassThrough mode
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Modelica.Blocks.Sources.RealExpression setPoiHea(
     y(final unit="K", displayUnit="degC")=if (mode.y == Integer(OperationModes.occupied) or mode.y == Integer(OperationModes.unoccupiedWarmUp)
         or mode.y == Integer(OperationModes.safety)) then THeaOn else THeaOff)
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Modelica.Blocks.Sources.RealExpression setPoiCoo(
    y(final unit="K", displayUnit="degC")=if (mode.y == Integer(OperationModes.occupied) or
          mode.y == Integer(OperationModes.unoccupiedPreCool) or
          mode.y == Integer(OperationModes.safety)) then TCooOn else TCooOff)
    "Cooling setpoint"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
equation
  connect(controlBus.controlMode,mode. u) annotation (Line(
      points={{20,60},{58,60}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(setPoiHea.y, controlBus.TRooSetHea) annotation (Line(
      points={{-59,80},{20,80},{20,60}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(setPoiCoo.y, controlBus.TRooSetCoo) annotation (Line(
      points={{-59,40},{20,40},{20,60}},
      color={0,0,127},
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  annotation (                                Icon(graphics={
        Text(
          extent={{-92,90},{-52,70}},
          textColor={0,0,255},
          textString="TRet"),
        Text(
          extent={{-96,50},{-56,30}},
          textColor={0,0,255},
          textString="TMix"),
        Text(
          extent={{-94,22},{-26,-26}},
          textColor={0,0,255},
          textString="VOut_flow"),
        Text(
          extent={{-88,-22},{-26,-60}},
          textColor={0,0,255},
          textString="TSupHeaSet"),
        Text(
          extent={{-86,-58},{-24,-96}},
          textColor={0,0,255},
          textString="TSupCooSet"),
        Text(
          extent={{42,16},{88,-18}},
          textColor={0,0,255},
          textString="yOA")}));
end RoomTemperatureSetpoint;
