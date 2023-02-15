within Buildings.Fluid.Storage.Plant.BaseClasses;
model StateOfCharge
  "Returns the state of charge from tank temperature sensors"

  parameter Modelica.Units.SI.Temperature TLow
    "Lower threshold to consider the tank full";
  parameter Modelica.Units.SI.Temperature THig
    "Higher threshold to consider the tank depleted";
  parameter Modelica.Units.SI.TemperatureDifference dTUnc = 0.1
    "Temperature sensor uncertainty";
  parameter Modelica.Units.SI.TemperatureDifference dTHys = 1
    "Deadband for hysteresis";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b tanTop
    "Heat port for temperature at tank top" annotation (Placement(
        transformation(extent={{-110,50},{-90,70}}), iconTransformation(extent={
            {-110,52},{-90,72}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b tanBot
    "Heat port for temperature at tank bottom" annotation (Placement(
        transformation(extent={{-110,-70},{-90,-50}}), iconTransformation(
          extent={{-110,-72},{-90,-52}})));
  Modelica.Blocks.Interfaces.BooleanOutput isFul "Tank is full" annotation (
      Placement(transformation(extent={{100,50},{120,70}}), iconTransformation(
          extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.BooleanOutput isDep "Tank is depleted" annotation (
     Placement(transformation(extent={{100,-70},{120,-50}}), iconTransformation(
          extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysFul(
    final uLow = TLow + dTUnc,
    final uHigh = hysFul.uLow + dTHys)
    "Hysteresis" annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysDep(
    final uHigh = THig - dTUnc,
    final uLow=hysDep.uHigh - dTHys) "Hysteresis"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Not block"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
protected
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemTop
    "Temperature sensor for tank top"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemBot
    "Temperature sensor for tank bottom"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
equation
  connect(tanTop, senTemTop.port)
    annotation (Line(points={{-100,60},{-60,60}}, color={191,0,0}));
  connect(tanBot, senTemBot.port)
    annotation (Line(points={{-100,-60},{-60,-60}}, color={191,0,0}));
  connect(senTemTop.T, hysFul.u)
    annotation (Line(points={{-39,60},{-2,60}}, color={0,0,127}));
  connect(senTemBot.T, hysDep.u)
    annotation (Line(points={{-39,-60},{-2,-60}}, color={0,0,127}));
  connect(hysFul.y, not1.u)
    annotation (Line(points={{22,60},{38,60}}, color={255,0,255}));
  connect(not1.y, isFul)
    annotation (Line(points={{62,60},{110,60}}, color={255,0,255}));
  connect(hysDep.y, isDep)
    annotation (Line(points={{22,-60},{110,-60}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Text(
          extent={{-72,38},{80,-40}},
          textColor={28,108,200},
          textString="SOC")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
end StateOfCharge;
