within Buildings.Applications.DataCenters.ChillerCooled.Equipment;
model CoolingCoilHumidifyingHeating
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialCoolingCoilHumidifyingHeating(
    redeclare Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage watVal(
      final R=R,
      final delta0=delta0),
    redeclare final Buildings.Fluid.Movers.SpeedControlled_y fan(y_start=yFan_start));

  // Parameters for water-side valve
  parameter Real R=50 "Rangeability, R=50...100 typically"
  annotation(Dialog(group="Valve"));
  parameter Real delta0=0.01
    "Range of significant deviation from equal percentage law"
    annotation(Dialog(group="Valve"));

  // Parameters for electric heater
  parameter Modelica.Units.SI.Time tauEleHea=10
    "Time constant at nominal flow for electric heater (if energyDynamics <> SteadyState)"
    annotation (Dialog(
      tab="Dynamics",
      group="Electric heater",
      enable=not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Modelica.Units.SI.Efficiency etaHea=1.0
    "Efficiency of electrical heater"
    annotation (Dialog(group="Electric heater"));
  parameter Modelica.Units.SI.HeatFlowRate QHeaMax_flow(min=0)
    "Nominal heating capacity of eletric heater,positive"
    annotation (Dialog(group="Electric heater"));
  // Parameters for humidifier
  parameter Modelica.Units.SI.MassFlowRate mWatMax_flow(min=0)
    "Nominal humidification capacity for humidifier, positive for humidification"
    annotation (Dialog(tab="General", group="Humidifier"));
  parameter Modelica.Units.SI.Temperature THum=293.15
    "Temperature of water that is added to the fluid stream by the humidifier"
    annotation (Dialog(group="Humidifier"));
  parameter Modelica.Units.SI.Time tauHum=10
    "Time constant at nominal flow for humidifier(if energyDynamics <> SteadyState)"
    annotation (Dialog(
      tab="Dynamics",
      group="Humidifier",
      enable=not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));

  // parameters for heater controller
  parameter Real yValSwi(min=0, max=1, unit="1")
    "Switch point for valve signal";
  parameter Real yValDeaBan(min=0, max=1, unit="1")=0.1
    "Deadband for valve signal";
  parameter Modelica.Units.SI.TemperatureDifference dTSwi=0
    "Switch point for temperature difference";
  parameter Modelica.Units.SI.TemperatureDifference dTDeaBan=0.5
    "Deadband for temperature difference";
  parameter Modelica.Units.SI.Time tWai=60 "Waiting time";

  Modelica.Blocks.Interfaces.RealOutput PHea(
    final unit = "W",
    final quantity = "Power")
    "Power consumed by electric heater"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={18,-110})));
  Modelica.Blocks.Interfaces.RealInput TSet(
    final unit = "K",
    final quantity = "ThermodynamicTemperature")
    "Set point temperature of the fluid that leaves port_b"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-120,-20},{-100,0}})));
  Modelica.Blocks.Interfaces.RealInput XSet_w(
    final unit = "1",
    final quantity = "MassFraction",
    min = 0,
    max = 0.03)
    "Set point for water vapor mass fraction in kg/kg total air of the fluid that leaves port_b"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-120,0},{-100,20}})));
  Modelica.Blocks.Sources.RealExpression dT(y(final unit="K")=T_inflow_hea - TSet)
    "Difference between inlet temperature and temperature setpoint of the reheater"
    annotation (Placement(transformation(extent={{-60,-4},{-40,16}})));

  Buildings.Fluid.Humidifiers.SprayAirWasher_X hum(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final m_flow_small=m2_flow_small,
    final show_T=show_T,
    final energyDynamics=energyDynamics,
    final tau=tauHum,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=0,
    final m_flow_nominal=m2_flow_nominal,
    final mWatMax_flow=mWatMax_flow,
    final X_start=X_start,
    final from_dp=from_dp2,
    final linearizeFlowResistance=linearizeFlowResistance2,
    final deltaM=deltaM2)
    "Humidifier"
    annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=180,
        origin={20,-60})));
  Buildings.Applications.DataCenters.ChillerCooled.Equipment.ElectricHeater eleHea(
    redeclare final package Medium = Medium2,
    final allowFlowReversal=allowFlowReversal2,
    final show_T=show_T,
    final m_flow_small=m2_flow_small,
    final energyDynamics=energyDynamics,
    final tau=tauEleHea,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=0,
    final QMax_flow=QHeaMax_flow,
    final eta=etaHea,
    final m_flow_nominal=m2_flow_nominal,
    final T_start=T_start,
    final from_dp=from_dp2,
    final linearizeFlowResistance=linearizeFlowResistance2,
    final deltaM=deltaM2)
    "Electric heater"
     annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        origin={-22,-60})));

  Buildings.Applications.DataCenters.ChillerCooled.Controls.Reheat heaCon(
    final yValSwi=yValSwi,
    final yValDeaBan=yValDeaBan,
    final dTSwi=dTSwi,
    final dTDeaBan=dTDeaBan,
    final tWai=tWai)
    "Reheater on/off controller"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-10,10})));

protected
  Medium2.Temperature T_inflow_hea= Medium2.temperature(state=Medium2.setState_phX(port_b2.p,
                           noEvent(actualStream(port_b2.h_outflow)),
                           noEvent(actualStream(port_b2.Xi_outflow))))
      "Temperature of inflowing fluid at port_a of reheater";

equation
  connect(TSet, eleHea.TSet)
    annotation (Line(points={{-120,-20},{-88,-20},{-88,-28},{-4,-28},
                {-4,-52},{-10,-52}},color={0,0,127}));
  connect(XSet_w, hum.X_w)
    annotation (Line(points={{-120,0},{-80,0},{-80,-20},{36,-20},
                {36,-54},{32,-54}},color={0,0,127}));
  connect(fan.port_a, eleHea.port_b)
    annotation (Line(points={{-50,-60},{-41,-60},{-32,-60}},
                color={0,127,255}));
  connect(eleHea.port_a, hum.port_b)
    annotation (Line(points={{-12,-60},{10,-60}},
                color={0,127,255}));
  connect(hum.port_a, cooCoi.port_b2) annotation (Line(points={{30,-60},{30,
          -60},{48,-60},{42,-60},{60,-60}}, color={0,127,255}));
  connect(eleHea.P, PHea)
    annotation (Line(points={{-33,-66},{-40,-66},{-40,-76},
                {18,-76},{18,-110}}, color={0,0,127}));
  connect(uFan,fan.y)
    annotation (Line(points={{-120,-50},{-120,-50},{-90,-50},{-90,-50},{-90,-50},
          {-90,-40},{-60,-40},{-60,-48},{-60,-48}}, color={0,0,127}));
  connect(heaCon.y, eleHea.on)
    annotation (Line(points={{1,10},{4,10},{4,-57},{-10,-57}},
                     color={255,0,255}));
  connect(dT.y, heaCon.dT)
    annotation (Line(points={{-39,6},{-22,6},{-22,5}}, color={0,0,127}));
  connect(heaCon.yVal, watVal.y_actual) annotation (Line(points={{-22,15},{-32,15},
          {-32,16},{-32,40},{73,40},{73,-5}},     color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-92,62},{92,-64}},
          lineColor={0,0,255},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,62},{107,59}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-98,-61},{102,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,80},{4,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{18,80},{22,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,80},{42,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{60,70},{60,50},{72,60},{60,70}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Polygon(
          points={{80,70},{80,50},{68,60},{80,70}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
                   Text(
          extent={{-42,-20},{2,-66}},
          textColor={255,255,255},
          textString="+"),
                   Text(
          extent={{-66,-20},{-22,-66}},
          textColor={255,255,255},
          textString="+"),
        Ellipse(
          extent={{-60,-52},{-80,-72}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{-64,-54},{-64,-70},{-80,-62},{-64,-54}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255})}),
    Documentation(info="<html>
    <p>This model can represent a typical air handler with a cooling coil, a variable-speed fan,
    a humidifier and an electric reheater. The heating coil is not included in this model.
    </p>
    <p>
    The water-side valve can be manipulated to control the outlet temperature on air side,
    as shown in <a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.CoolingCoilHumidifyingHeating_ClosedLoop\">
    Buildings.Applications.DataCenters.AHUs.Example.AirHandlingUnitControl.</a>
    </p>
    <p>It's usually undesired to control the outlet air temperature by simultenanously
    manipulating the water-valve and reheater, because energy waste could happen in this case. For example,
    under the part-load condition, the water valve might be in its maximum position with
    the reheater turning on to maintain the outlet air temperature.
    To avoid that water-valve and reheater control the outlet
    temperature at the same time, a buit-in reheater on/off controller is implemented.
    The detailed control logic about the reheater on/off control is shown in
    <a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Controls.Reheat\">
    Buildings.Applications.DataCenters.ChillerCooled.Controls.Reheat.</a></p>
    <p>The humidfier is an adiabatic spray air washer with a prescribed outlet water vapor mass fraction
    in kg/kg total air. During the humidification, the enthalpy remains constant.
    Details can be found in <a href=\"modelica://Buildings.Fluid.Humidifiers.SprayAirWasher_X\">
    Buildings.Fluid.Humidifiers.SprayAirWasher_X</a>. The humidifer can be turned off
    when the prescribed mass fraction
    is smaller than the current state at the outlet, for example, <code>XSet=0</code>.
    </p>
</html>", revisions="<html>
<ul>
<li>
May 14, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingCoilHumidifyingHeating;
