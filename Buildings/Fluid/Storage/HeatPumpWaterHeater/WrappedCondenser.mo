within Buildings.Fluid.Storage.HeatPumpWaterHeater;
model WrappedCondenser "Wrapped heat pump water heater model"
  extends Buildings.Fluid.Storage.HeatPumpWaterHeater.BaseClasses.PartialHeater;

   Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TConWat[datHPWH.datTanWat.nSegCon]
    "Water temperatures that the condenser see"
    annotation (Placement(transformation(extent={{-20,0},{-40,20}})));

  Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed sinSpeDXCoo(
    datCoi=datHPWH.datCoi,
    redeclare package Medium = MediumAir,
    from_dp=true,
    dp_nominal=dpAir_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Single speed DX cooling coil"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Modelica.Blocks.Sources.RealExpression QCon[datHPWH.datTanWat.nSegCon](
    final y={-sinSpeDXCoo.dxCoi.Q_flow*datHPWH.datTanWat.conHeaFraSca[i] for i in 1:datHPWH.datTanWat.nSegCon})
    "Condenser heat for each node"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow hea[datHPWH.datTanWat.nSegCon]
    "Heat input to the hot water tank"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));

  Modelica.Blocks.Math.MultiSum TConWatAve(
    final k=datHPWH.datTanWat.conHeaFraSca,
    final nu=datHPWH.datTanWat.nSegCon)
    "Weighted average condenser water temperature"
    annotation (Placement(transformation(extent={{-50,0},{-70,20}})));

  Modelica.Blocks.Math.Add add
    "Addition of power"
    annotation (Placement(transformation(extent={{60,10},{80,30}})));

equation
  connect(port_a1, sinSpeDXCoo.port_a)
    annotation (Line(points={{-100,60},{-40,60}}, color={0,127,255}));

  connect(sinSpeDXCoo.port_b, fan.port_a)
    annotation (Line(points={{-20,60},{30,60}}, color={0,127,255}));

  connect(on, sinSpeDXCoo.on)
    annotation (Line(points={{-120,80},{-90,80},{-90,68},{-41,68}},
                                                                  color={255,0,255}));

  connect(TConWatAve.y, sinSpeDXCoo.TOut)
    annotation (Line(points={{-71.7,10},{-80,10},{-80,63},{-41,63}},    color={0,0,127}));

  connect(hea.port, tan.heaPorVol[datHPWH.datTanWat.segTop:datHPWH.datTanWat.segBot])
    annotation (Line(points={{0,-40},{20,-40},{20,-30},{40,-30}},
                                                 color={191,0,0}));

  connect(QCon.y, hea.Q_flow)
    annotation (Line(points={{-39,-40},{-20,-40}}, color={0,0,127}));

  connect(TConWat.port, tan.heaPorVol[datHPWH.datTanWat.segTop:datHPWH.datTanWat.segBot])
    annotation (Line(points={{-20,10},{20,10},{20,-30},{40,-30}},   color={191,0,0}));

  connect(TConWatAve.u, TConWat.T)
    annotation (Line(points={{-50,10},{-41,10}},   color={0,0,127}));

  connect(add.y, P)
    annotation (Line(points={{81,20},{110,20}},   color={0,0,127}));

  connect(add.u1, fan.P)
    annotation (Line(points={{58,26},{54,26},{54,69},{51,69}},   color={0,0,127}));

  connect(add.u2, sinSpeDXCoo.P)
    annotation (Line(points={{58,14},{-2,14},{-2,69},{-19,69}},color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),                                                                                                              graphics={
        Rectangle(extent={{-40,60},{40,20}},lineColor={255,0,0},fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-40,-20},{40,-60}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-40,20},{40,-20}},lineColor={255,0,0},pattern=LinePattern.None,fillColor={0,0,127},
          fillPattern=FillPattern.CrossDiag),
        Rectangle(extent={{-10,10},{10,-10}},lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,fillColor={255,255,255}),
        Rectangle(extent={{50,68},{40,-66}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-40,66},{-50,-68}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-48,68},{50,60}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-48,-60},{50,-68}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-40,20},{40,-20}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{-10,10},{10,-10}},lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,fillColor={255,255,255}),
        Rectangle(extent={{-40,68},{-50,-66}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={255,255,0},
          fillPattern=FillPattern.Solid),
        Rectangle(extent={{50,68},{40,-66}},lineColor={0,0,255},pattern=LinePattern.None,fillColor={255,255,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
    <p>
    This is a model of a heat pump water heater with wrapped condenser for thermal
    energy storage based on the EnergyPlus model
    <code>WaterHeater:HeatPump:WrappedCondenser</code>.</p>
    <p>
    The system model consists of the following components:
    <ul>
    <li>A stratified water tank of class
    <a href=\"modelica://Buildings.Fluid.Storage.StratifiedEnhanced\">
    Buildings.Fluid.Storage.StratifiedEnhanced</a>.
    </li>
    <li>
    A single speed water heating coil whose condenser is wrapped around the water
    tank. The effective heat transfer is calculated using the class
    <a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed\">
    Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed</a>
    </li>
    <li>
    An evaporator coil fan of class
    <a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
    Buildings.Fluid.Movers.FlowControlled_m_flow</a>
    </li>
    </ul>
    </p>
    <p>
    The following assumptions are made based on the EnergyPlus source code:</p>
    <ul>
    <li>
    The condenser temperature of the water heating coil is the weighted average
    temperatures of the water tank nodes that the wrapped condenser coil is
    thermally coupled with.
    </li>
    <li>
    The heat flow fraction into each tank node the condenser coil sees is assumed
    to be equal to the ratio of the condenser coil height in the tank node.</li>
    </ul>
    <p>
    Please note that the performance curve of the EIR as a function of fluid
    temperatures needs to be provided to this model while the EnergyPlus model
    requires the COP curve as a function of fluid temperatures.</p>
    </html>", revisions="<html>
    <ul>
    <li>
    September 24, 2024 by Xing Lu, Karthik Devaprasad and Cerrina Mouchref:</br>
    First implementation.
    </li>
    </ul>
</html>"));
end WrappedCondenser;
