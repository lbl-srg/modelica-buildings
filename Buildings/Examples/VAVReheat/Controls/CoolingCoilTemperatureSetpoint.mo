within Buildings.Examples.VAVReheat.Controls;
block CoolingCoilTemperatureSetpoint "Set point scheduler for cooling coil"
  extends Modelica.Blocks.Icons.Block;
  import Buildings.Examples.VAVReheat.Controls.OperationModes;
  parameter Modelica.SIunits.Temperature TCooOn=273.15+12
    "Cooling setpoint during on";
  parameter Modelica.SIunits.Temperature TCooOff=273.15+30
    "Cooling setpoint during off";
  Modelica.Blocks.Sources.RealExpression TSupSetCoo(
   y=if (mode.y == Integer(OperationModes.occupied) or
         mode.y == Integer(OperationModes.unoccupiedPreCool) or
         mode.y == Integer(OperationModes.safety)) then
          TCooOn else TCooOff) "Supply air temperature setpoint for cooling"
    annotation (Placement(transformation(extent={{-22,-50},{-2,-30}})));
  Modelica.Blocks.Interfaces.RealInput TSetHea(
    unit="K",
    displayUnit="degC") "Set point for heating coil"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Math.Add add
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.Constant dTMin(k=1)
    "Minimum offset for cooling coil setpoint"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Modelica.Blocks.Math.Max max1
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  ControlBus controlBus
    annotation (Placement(transformation(extent={{-28,-90},{-8,-70}})));
  Modelica.Blocks.Routing.IntegerPassThrough mode
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Modelica.Blocks.Interfaces.RealOutput TSet(
    unit="K",
    displayUnit="degC") "Temperature set point"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  connect(dTMin.y, add.u1) annotation (Line(
      points={{1,20},{10,20},{10,6},{18,6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, max1.u1) annotation (Line(
      points={{41,6.10623e-16},{52,6.10623e-16},{52,-14},{58,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSupSetCoo.y, max1.u2) annotation (Line(
      points={{-1,-40},{20,-40},{20,-26},{58,-26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(controlBus.controlMode, mode.u) annotation (Line(
      points={{-18,-80},{38,-80}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(max1.y, TSet) annotation (Line(
      points={{81,-20},{86,-20},{86,0},{110,0},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetHea, add.u2) annotation (Line(
      points={{-120,1.11022e-15},{-52,1.11022e-15},{-52,-6},{18,-6}},
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
