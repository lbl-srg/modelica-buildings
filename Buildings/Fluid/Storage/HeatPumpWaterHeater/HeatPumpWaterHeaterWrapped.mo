within Buildings.Fluid.Storage.HeatPumpWaterHeater;
model HeatPumpWaterHeaterWrapped "Wrapped heat pump water heater model"
  extends
    Buildings.Fluid.Storage.HeatPumpWaterHeater.BaseClasses.PartialHeatPumpWaterHeater;

   Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TConWat[datWT.nSegCon]
    "Water temperatures that the condenser see"
    annotation (Placement(transformation(extent={{-30,-80},{-50,-60}})));

   Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorVol[datWT.nSeg]
    "Heat port that connects to the control volumes of the tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

    Buildings.Fluid.DXSystems.Cooling.AirSource.SingleSpeed sinSpeDXCoo(
      datCoi=datCoi,
      redeclare package Medium = MediumAir,
      from_dp=true,
      dp_nominal=dpAir_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
      annotation (Placement(transformation(extent={{-58,50},{-38,70}})));

  Modelica.Blocks.Sources.RealExpression QCon[datWT.nSegCon](y={-
       sinSpeDXCoo.dxCoi.Q_flow*datWT.conHeaFraSca[i] for i in 1:datWT.nSegCon})
      "Condenser heat for each node"
      annotation (Placement(transformation(extent={{-62,-36},{-42,-16}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow hea[datWT.nSegCon]
    "Heat input to the hot water tank"
    annotation (Placement(transformation(extent={{-26,-36},{-6,-16}})));

  Modelica.Blocks.Math.MultiSum TConWatAve(k=datWT.conHeaFraSca, nu=datWT.nSegCon)
    "Weighted average condenser water temperature"
    annotation (Placement(transformation(extent={{-54,-76},{-66,-64}})));

  Modelica.Blocks.Math.Add add "Addition of power"
    annotation (Placement(transformation(extent={{66,-50},{86,-30}})));

equation
  connect(port_a1, sinSpeDXCoo.port_a)
    annotation (Line(points={{-100,60},{-58,60}}, color={0,127,255}));

  connect(sinSpeDXCoo.port_b, fan.port_a)
    annotation (Line(points={{-38,60},{24,60}}, color={0,127,255}));

  connect(on, sinSpeDXCoo.on)
    annotation (Line(points={{-120,0},{-80,0},{-80,68},{-59,68}}, color={255,0,255}));

  connect(TConWatAve.y, sinSpeDXCoo.TOut)
    annotation (Line(points={{-67.02,-70},{-78,-70},{-78,63},{-59,63}}, color={0,0,127}));

  connect(hea.port, tan.heaPorVol[datWT.segTop:datWT.segBot])
    annotation (Line(points={{-6,-26},{36,-26}}, color={191,0,0}));

  connect(QCon.y, hea.Q_flow)
    annotation (Line(points={{-41,-26},{-26,-26}}, color={0,0,127}));

  connect(TConWat.port, tan.heaPorVol[datWT.segTop:datWT.segBot])
    annotation (Line(points={{-30,-70},{24,-70},{24,-26},{36,-26}}, color={191,0,0}));

  connect(TConWatAve.u, TConWat.T)
    annotation (Line(points={{-54,-70},{-51,-70}}, color={0,0,127}));

  connect(add.y, P)
    annotation (Line(points={{87,-40},{110,-40}}, color={0,0,127}));

  connect(add.u1, fan.P)
    annotation (Line(points={{64,-34},{48,-34},{48,69},{45,69}}, color={0,0,127}));

  connect(add.u2, sinSpeDXCoo.P)
    annotation (Line(points={{64,-46},{8,-46},{8,69},{-37,69}},color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}}),                                         graphics={
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})),
      experiment(
      StopTime=10800,
      Tolerance=1e-05,
      __Dymola_Algorithm="Cvode"),
    Documentation(info="<html>
    
    <p>
    This is a model of a heat pump water heater with wrapped condenser for thermal energy storage based on the EnergyPlus model WaterHeater:HeatPump:WrappedCondenser. </p>
    <p>
    The system model is composed of the following component model: (1) A stratified water tank (2) A single speed wrapped water heating coil (3) A supply fan. </p>
    <p>
    The following assumptions are made based on the EnergyPlus source codes:</p>
    <ul>
    
    <li>
    The condenser temperature of the water heating coil is the weighted average temperatures of the water tank nodes that the wrapped condenser coil sees.</li>
    <li>
    The heat flow fraction into each tank node the condenser coil sees is assumed to be equal to the ratio of the condenser coil height in the tank node.</li>
    </ul>
    
    <p>
    Please note that the performance curve of the EIR for fluid temperatures needs to be given in this model while the EnergyPlus model requires the COP curve for fluid temperatures as the counterpart.</p>
    
    </html>"));
end HeatPumpWaterHeaterWrapped;
