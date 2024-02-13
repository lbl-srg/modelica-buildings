within Buildings.Fluid.Storage.HeatPumpWaterHeater;
model HeatPumpWaterHeaterPumped "Pumped heat pump water heater model"
  extends
    Buildings.Fluid.Storage.HeatPumpWaterHeater.BaseClasses.PartialHeatPumpWaterHeater(
  redeclare final Buildings.Fluid.Storage.StratifiedEnhancedInternalHex tan);

  Buildings.Fluid.DXSystems.Cooling.WaterSource.SingleSpeed singleSpeed(datCoi=
        datCoi)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan1
    annotation (Placement(transformation(extent={{-46,-34},{-26,-14}})));
equation
  connect(port_a1, singleSpeed.port_a)
    annotation (Line(points={{-100,60},{-60,60}}, color={0,127,255}));
  connect(singleSpeed.port_b, fan.port_a) annotation (Line(points={{-40,60},{-8,
          60},{-8,60},{24,60}}, color={0,127,255}));
  connect(on, singleSpeed.on) annotation (Line(points={{-120,0},{-80,0},{-80,68},
          {-61,68}}, color={255,0,255}));
  connect(singleSpeed.P, add.u2) annotation (Line(points={{-39,69},{10,69},{10,-46},
          {68,-46}}, color={0,0,127}));
  connect(fan1.m_flow_in, yMov.y)
    annotation (Line(points={{-36,-12},{-36,20},{-39,20}}, color={0,0,127}));
  connect(fan1.port_a, singleSpeed.portCon_b) annotation (Line(points={{-46,-24},
          {-72,-24},{-72,42},{-56,42},{-56,50}}, color={0,127,255}));
  connect(singleSpeed.portCon_a, tan.portHex_b) annotation (Line(points={{-44,50},
          {-44,42},{6,42},{6,-34},{26,-34}}, color={0,127,255}));
  connect(fan1.port_b, tan.portHex_a) annotation (Line(points={{-26,-24},{0,-24},
          {0,-29.8},{26,-29.8}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPumpWaterHeaterPumped;
