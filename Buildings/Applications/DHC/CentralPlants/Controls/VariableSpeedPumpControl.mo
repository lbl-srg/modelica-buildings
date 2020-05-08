within Buildings.Applications.DHC.CentralPlants.Controls;
model VariableSpeedPumpControl
  "Controller for variable speed chilled water pumps"
  parameter Modelica.SIunits.Pressure dPSetPoi "Pressure difference setpoint";
  parameter Real tWai = 300 "Waiting time";
  WaterSide.BaseClasses.Control.TwoStage pumStage(tWai=tWai)
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  WaterSide.BaseClasses.Control.dPControl dPCon(dPSetPoi=dPSetPoi)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Interfaces.BooleanInput On "On signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput Status[2] "Speeds of pumps"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput yVal "yValve"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput dP "Measured pressure drop"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Math.Product product
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Modelica.Blocks.Interfaces.RealOutput y[2] "Connector of Real output signal"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

equation
  connect(pumStage.On, On) annotation (Line(
      points={{-52,8},{-66,8},{-80,8},{-80,80},{-120,80}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(pumStage.Status, Status) annotation (Line(
      points={{-52,-8},{-80,-8},{-80,-80},{-120,-80}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(dPCon.yVal, yVal) annotation (Line(
      points={{18,6},{-2,6},{-20,6},{-20,40},{-120,40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(dPCon.dP, dP) annotation (Line(
      points={{18,-6},{-2,-6},{-20,-6},{-20,-40},{-120,-40}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pumStage.y[2], product.u1) annotation (Line(
      points={{-29,0.5},{0,0.5},{0,56},{18,56}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(dPCon.Spe, product.u2) annotation (Line(
      points={{41,0},{52,0},{60,0},{60,32},{10,32},{10,44},{18,44}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(product1.u2, pumStage.y[1]) annotation (Line(
      points={{18,-56},{10,-56},{0,-56},{0,-0.5},{-29,-0.5}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(product1.u1, dPCon.Spe) annotation (Line(
      points={{18,-44},{8,-44},{8,-20},{60,-20},{60,0},{41,0}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(product1.y, y[1]) annotation (Line(
      points={{41,-50},{60,-50},{80,-50},{80,-5},{110,-5}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(product.y, y[2]) annotation (Line(
      points={{41,50},{80,50},{80,5},{110,5}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)));
end VariableSpeedPumpControl;
