within Buildings.Fluid.Storage.HeatPumpWaterHeater;
model HeatPumpWaterHeaterPumped "Pumped heat pump water heater model"
  extends
    Buildings.Fluid.Storage.HeatPumpWaterHeater.BaseClasses.PartialHeatPumpWaterHeater(
  redeclare final Buildings.Fluid.Storage.StratifiedEnhancedInternalHex tan);

  Buildings.Fluid.DXSystems.Cooling.WaterSource.SingleSpeed singleSpeed(datCoi=
        datCoi)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum
    annotation (Placement(transformation(extent={{-46,-34},{-26,-14}})));
  Modelica.Blocks.Math.Add3 add "Addition of power"
    annotation (Placement(transformation(extent={{66,-50},{86,-30}})));

equation
  connect(port_a1, singleSpeed.port_a)
    annotation (Line(points={{-100,60},{-60,60}}, color={0,127,255}));
  connect(singleSpeed.port_b, fan.port_a) annotation (Line(points={{-40,60},{-8,
          60},{-8,60},{24,60}}, color={0,127,255}));
  connect(on, singleSpeed.on) annotation (Line(points={{-120,0},{-80,0},{-80,68},
          {-61,68}}, color={255,0,255}));
  connect(pum.m_flow_in, yMov.y)
    annotation (Line(points={{-36,-12},{-36,20},{-39,20}}, color={0,0,127}));
  connect(pum.port_a, singleSpeed.portCon_b) annotation (Line(points={{-46,-24},
          {-72,-24},{-72,42},{-56,42},{-56,50}}, color={0,127,255}));
  connect(singleSpeed.portCon_a, tan.portHex_b) annotation (Line(points={{-44,50},
          {-44,42},{6,42},{6,-34},{26,-34}}, color={0,127,255}));
  connect(pum.port_b, tan.portHex_a) annotation (Line(points={{-26,-24},{0,-24},
          {0,-29.8},{26,-29.8}}, color={0,127,255}));
  connect(add.y, P)
    annotation (Line(points={{87,-40},{110,-40}}, color={0,0,127}));
  connect(fan.P, add.u1) annotation (Line(points={{45,69},{48,69},{48,-32},{64,
          -32}}, color={0,0,127}));
  connect(add.u2, singleSpeed.P) annotation (Line(points={{64,-40},{8,-40},{8,
          69},{-39,69}}, color={0,0,127}));
  connect(add.u3, pum.P) annotation (Line(points={{64,-48},{-18,-48},{-18,-15},
          {-25,-15}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPumpWaterHeaterPumped;
