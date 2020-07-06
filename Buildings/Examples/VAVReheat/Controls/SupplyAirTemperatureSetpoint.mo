within Buildings.Examples.VAVReheat.Controls;
block SupplyAirTemperatureSetpoint
  "Set point scheduler for supply air temperature"
  extends Modelica.Blocks.Icons.Block;
  import Buildings.Examples.VAVReheat.Controls.OperationModes;
  parameter Modelica.SIunits.Temperature TSupSetOn=273.15+12
    "Set point during on";
  parameter Modelica.SIunits.Temperature TSupSetOff=273.15+30
    "Set point during off";
  Modelica.Blocks.Sources.RealExpression TSupSet(y=if (mode.y == Integer(
        OperationModes.occupied) or mode.y == Integer(OperationModes.unoccupiedPreCool)
         or mode.y == Integer(OperationModes.safety)) then TSupSetOn else
        TSupSetOff) "Supply air temperature set point"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  ControlBus controlBus
    annotation (Placement(transformation(extent={{-28,-90},{-8,-70}})));
  Modelica.Blocks.Routing.IntegerPassThrough mode
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Modelica.Blocks.Interfaces.RealOutput TSet(
    unit="K",
    displayUnit="degC") "Temperature set point"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
equation
  connect(controlBus.controlMode, mode.u) annotation (Line(
      points={{-18,-80},{38,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(TSupSet.y, TSet)
    annotation (Line(points={{1,0},{56,0},{56,0},{110,0}},
                                             color={0,0,127}));
end SupplyAirTemperatureSetpoint;
