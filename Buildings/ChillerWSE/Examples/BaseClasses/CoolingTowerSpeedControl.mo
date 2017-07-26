within Buildings.ChillerWSE.Examples.BaseClasses;
model CoolingTowerSpeedControl
  "Controller for the fan speed in cooling towers"

  Modelica.Blocks.Interfaces.RealInput cooMod
    "Cooling mode - 0: free cooling mode; 1: partially mechanical cooling; 2: fully mechanical cooling"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Controls.Continuous.LimPID conPID
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealInput CHWST_set(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput CWST_set(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput CHWST(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Chilled water supply temperature " annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={-50,-120})));
  Modelica.Blocks.Interfaces.RealInput CWST(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Condenser water supply temperature " annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={50,-120})));
  Modelica.Blocks.Math.RealToBoolean realToBoolean
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
equation
  connect(cooMod, realToBoolean.u) annotation (Line(points={{-120,80},{-80,80},
          {-80,70},{-62,70}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end CoolingTowerSpeedControl;
