within Buildings.Fluid.ZoneEquipment;
model FourPipe "System model for a four-pipe fan coil unit"
  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium for air";

  replaceable package MediumHW = Modelica.Media.Interfaces.PartialMedium
    "Medium for hot water";

  replaceable package MediumCHW = Modelica.Media.Interfaces.PartialMedium
    "Medium for chilled water";

  parameter Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil
    heaCoiTyp=Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased
    "Heating coil type"
    annotation (Dialog(group="System parameters"));

  parameter Modelica.Units.SI.HeatFlowRate QCoiHea_flow_nominal(
    final min=0,
    final start=0)
    "Nominal heat flow rate of heating coil"
    annotation(Dialog(enable=have_hea, group="Heating coil parameters"));

  parameter Modelica.Units.SI.Temperature THotWatSup_nominal=333.15
    "Design water temperature entering heating coil"
    annotation(Dialog(enable=have_hotWat, group="Heating coil parameters"));
  parameter Modelica.Units.SI.Temperature THeaAirEnt_nominal=296.15
    "Design air temperature entering heating coil"
    annotation(Dialog(enable=have_hotWat, group="Heating coil parameters"));

  parameter Modelica.Units.SI.HeatFlowRate QCoiCoo_flow_nominal(
    final max=1e-9,
    final start=0)
    "Nominal heat flow rate of cooling coil"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.Temperature TChiWatEnt_nominal=279.83
    "Design water inlet temperature of cooling coil"
    annotation(Dialog(group="Cooling coil parameters"));
  parameter Modelica.Units.SI.Temperature TCooAirEnt_nominal=296.15
    "Design air inlet temperature of cooling coil"
    annotation(Dialog(group="Cooling coil parameters"));
  parameter Modelica.Units.SI.MassFraction wCooAirEnt_nominal=0.012
    "Design humidity ratio of inlet air of cooling coil (in kg/kg dry air)"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mHotWat_flow_nominal(
    final min=0,
    final start=0)
    "Nominal mass flow rate of heating hot water"
    annotation(Dialog(enable=have_hotWat, group="Heating coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpHotWatCoi_nominal(
    displayUnit="Pa",
    final start=0)
    "Total pressure difference across heating coil (Hot-water side)"
    annotation(Dialog(enable=have_hotWat, group="Heating coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpHotWatVal_nominal(
    displayUnit="Pa") = dpHotWatCoi_nominal
    "Design pressure drop of hot water valve (Hot-water side)"
    annotation(Dialog(enable=have_hotWat, group="Heating coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal(displayUnit="Pa")
    "Total pressure difference across supply and return ports in air loop"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal
    "Nominal mass flow rate of chilled water"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpChiWatCoi_nominal(
    displayUnit="Pa")
    "Total pressure difference across cooling coil (Chilled-water side)"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpChiWatVal_nominal(
    displayUnit="Pa") = dpChiWatCoi_nominal
    "Design pressure drop of chilled water valve (Chilled-water side)"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Nominal mass flow rate of supply air"
    annotation(Dialog(group="System parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final min=0, final max=1, final unit="1") if have_hea
    "Heating loop control signal"
    annotation(Placement(transformation(extent={{-300,-140},{-260,-100}}),
      iconTransformation(extent={{-240,-140},{-200,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0, final max=1, final unit="1")
    "Cooling loop control signal"
    annotation(Placement(transformation(extent={{-300,-70},{-260,-30}}),
      iconTransformation(extent={{-240,-20},{-200,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFan(
    final min=0, final max=1, final unit="1")
    "Fan normalized speed control signal"
    annotation(Placement(transformation(extent={{-300,60},{-260,100}}),
      iconTransformation(extent={{-240,100},{-200,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFan_actual(
    final unit="1",
    displayUnit="1")
    "Normalized actual fan speed signal"
    annotation (Placement(transformation(extent={{260,90},{300,130}}),
      iconTransformation(extent={{200,60},{240,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TAirSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{260,-100},{300,-60}}),
      iconTransformation(extent={{200,-100},{240,-60}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_air_a(
    redeclare final package Medium = MediumA)
    "Return air port from zone"
    annotation (Placement(transformation(extent={{250,50},{270,70}}),
      iconTransformation(extent={{190,30},{210,50}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_air_b(
    redeclare final package Medium = MediumA)
    "Supply air port to the zone"
    annotation (Placement(transformation(extent={{250,-10},{270,10}}),
      iconTransformation(extent={{190,-50},{210,-30}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_CHW_a(
    redeclare package Medium = Buildings.Media.Water)
    "Chilled water supply port"
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}}),
      iconTransformation(extent={{110,-210},{130,-190}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_CHW_b(
    redeclare final package Medium = Buildings.Media.Water)
    "Chilled water return port"
    annotation (Placement(transformation(extent={{50,-150},{70,-130}}),
      iconTransformation(extent={{10,-210},{30,-190}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_HW_a(
    redeclare final package Medium = Buildings.Media.Water) if have_hotWat
    "Hot water supply port"
    annotation (Placement(transformation(extent={{-130,-150},{-110,-130}}),
      iconTransformation(extent={{-50,-210},{-30,-190}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_HW_b(
    redeclare final package Medium = Buildings.Media.Water) if have_hotWat
    "Hot water return port"
    annotation (Placement(transformation(extent={{-70,-150},{-50,-130}}),
      iconTransformation(extent={{-150,-210},{-130,-190}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirHea(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Heating coil discharge air temperature sensor"
    annotation (Placement(transformation(extent={{-30,-10},{-10,10}})));

  Buildings.Fluid.HeatExchangers.DryCoilEffectivenessNTU hex(
    redeclare final package Medium1 = MediumHW,
    redeclare final package Medium2 = MediumA,
    final m1_flow_nominal=mHotWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    show_T=true,
    final dp1_nominal=0,
    final dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    use_Q_flow_nominal=true,
    final Q_flow_nominal=QCoiHea_flow_nominal,
    final T_a1_nominal=THotWatSup_nominal,
    final T_a2_nominal=THeaAirEnt_nominal)
    if have_hotWat
    "Hot water heating coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180,
      origin={-90,-6})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHW(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal,
    final dpValve_nominal=dpHotWatVal_nominal,
    dpFixed_nominal=dpHotWatCoi_nominal) if have_hotWat
    "Hot water flow control valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={-60,-80})));

  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU hexWetNtu(
    redeclare final package Medium1 = MediumCHW,
    redeclare final package Medium2 = MediumA,
    final m1_flow_nominal=mChiWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    show_T=true,
    final dp1_nominal=0,
    final dp2_nominal=0,
    use_Q_flow_nominal=true,
    final Q_flow_nominal=QCoiCoo_flow_nominal,
    final T_a1_nominal=TChiWatEnt_nominal,
    final T_a2_nominal=TCooAirEnt_nominal,
    final w_a2_nominal=wCooAirEnt_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Chilled-water cooling coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180,
      origin={30,-6})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valCHW(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dpValve_nominal=dpChiWatVal_nominal,
    dpFixed_nominal=dpChiWatCoi_nominal)
    "Chilled-water flow control valve"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={60,-80})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirLvg(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));

  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y fan(
    redeclare final package Medium = MediumA,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    addPowerToMedium=true,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dpAir_nominal)
    "Supply fan"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop totResAir(
    redeclare final package Medium = MediumA,
    final m_flow_nominal = mAir_flow_nominal,
    final dp_nominal = dpAir_nominal,
    final allowFlowReversal = true)
    "Total resistance of air path"
    annotation(Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoiEle(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    show_T=true,
    final dp_nominal=0,
    final Q_flow_nominal=QCoiHea_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    if have_heaEle
    "Electric heating coil"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

protected
  final parameter Boolean have_hotWat=(heaCoiTyp ==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased)
    "True if a hot water heating coil exists"
    annotation(Dialog(enable=false, tab="Non-configurable"));

  final parameter Boolean have_heaEle=(heaCoiTyp ==Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric)
    "True if an electric heating coil exists"
    annotation(Dialog(enable=false, tab="Non-configurable"));

  final parameter Boolean have_hea=have_hotWat or have_heaEle
    "True if a heating coil exists"
    annotation(Dialog(enable=false, tab="Non-configurable"));

  Buildings.Fluid.FixedResistances.LosslessPipe pipByp(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final allowFlowReversal=true) if not have_hea
    "Bypass when heating coil is absent"
    annotation (Placement(transformation(extent={{-102,38},{-82,58}})));

equation
  connect(valHW.port_a, hex.port_b1) annotation (Line(points={{-60,-70},{-60,-30},
          {-120,-30},{-120,-12},{-100,-12}}, color={0,127,255}));
  connect(hex.port_b2, TAirHea.port_a)
    annotation (Line(points={{-80,0},{-30,0}}, color={0,127,255}));
  connect(uHea, valHW.y) annotation (Line(points={{-280,-120},{-140,-120},{-140,
          -60},{-80,-60},{-80,-80},{-72,-80}},
                      color={0,0,127}));
  connect(valCHW.port_a, hexWetNtu.port_b1) annotation (Line(points={{60,-70},{60,
          -40},{10,-40},{10,-12},{20,-12}}, color={0,127,255}));
  connect(TAirHea.port_b, hexWetNtu.port_a2)
    annotation (Line(points={{-10,0},{20,0}}, color={0,127,255}));
  connect(fan.port_b, TAirLvg.port_a)
    annotation (Line(points={{140,0},{160,0}},     color={0,127,255}));
  connect(uCoo, valCHW.y) annotation (Line(points={{-280,-50},{40,-50},{40,-80},
          {48,-80}}, color={0,0,127}));
  connect(hexWetNtu.port_b2, totResAir.port_a)
    annotation (Line(points={{40,0},{60,0},{60,0},{80,0}}, color={0,127,255}));
  connect(heaCoiEle.port_b, TAirHea.port_a) annotation (Line(points={{-80,20},{
          -60,20},{-60,0},{-30,0}},
                                  color={0,127,255}));
  connect(uHea, heaCoiEle.u) annotation (Line(points={{-280,-120},{-140,-120},{
          -140,26},{-102,26}},
                         color={0,0,127}));
  connect(TAirLvg.T, TAirSup)
    annotation (Line(points={{170,11},{170,20},{190,20},{190,-80},{280,-80}},
                                                           color={0,0,127}));
  connect(totResAir.port_b, fan.port_a) annotation (Line(points={{100,0},{120,0}},
                                color={0,127,255}));
  connect(pipByp.port_b, TAirHea.port_a) annotation (Line(points={{-82,48},{-60,
          48},{-60,0},{-30,0}}, color={0,127,255}));
  connect(uFan, fan.y) annotation (Line(points={{-280,80},{130,80},{130,12}},
                             color={0,0,127}));
  connect(fan.y_actual, yFan_actual) annotation (Line(points={{141,7},{146,7},{
          146,110},{280,110}},  color={0,0,127}));
  connect(hex.port_a1, port_HW_a) annotation (Line(points={{-80,-12},{-70,-12},{
          -70,-40},{-120,-40},{-120,-140}}, color={0,127,255}));
  connect(valHW.port_b, port_HW_b)
    annotation (Line(points={{-60,-90},{-60,-140}}, color={0,127,255}));
  connect(hexWetNtu.port_a1, port_CHW_a) annotation (Line(points={{40,-12},{50,-12},
          {50,-30},{0,-30},{0,-140}}, color={0,127,255}));
  connect(valCHW.port_b, port_CHW_b)
    annotation (Line(points={{60,-90},{60,-140}}, color={0,127,255}));
  connect(port_air_a, pipByp.port_a) annotation (Line(points={{260,60},{-180,60},
          {-180,48},{-102,48}}, color={0,127,255}));
  connect(port_air_a, heaCoiEle.port_a) annotation (Line(points={{260,60},{-180,
          60},{-180,20},{-100,20}}, color={0,127,255}));
  connect(port_air_a, hex.port_a2) annotation (Line(points={{260,60},{-180,60},{
          -180,0},{-100,0}}, color={0,127,255}));
  connect(TAirLvg.port_b, port_air_b)
    annotation (Line(points={{180,0},{260,0}}, color={0,127,255}));
  annotation (defaultComponentName = "fanCoiUni",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}}),
                               graphics={Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,200},{100,240}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-148,-35},{200,-46}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{16,-72},{124,-82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{48,-28},{90,-88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64.25,4.25},{64.25,-4.25}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={19.75,-136.25},
          rotation=90),
        Rectangle(
          extent={{-34.25,4.25},{34.25,-4.25}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={119.75,-166.25},
          rotation=90),
                 Ellipse(
        extent={{106,-10},{166,-70}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Polygon(
        points={{124,-12},{124,-66},{166,-40},{124,-12}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-148,45},{200,34}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-45,6},{45,-6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-142,-1},
          rotation=90),
        Rectangle(
          extent={{-64.25,4.25},{64.25,-4.25}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-140.25,-136.25},
          rotation=90,
          visible=have_hotWat),
        Rectangle(
          extent={{-34.25,4.25},{34.25,-4.25}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-40.25,-166.25},
          rotation=90,
          visible=have_hotWat),
        Rectangle(
          extent={{-54.25,5},{54.25,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-90.25,-77},
          rotation=180,
          visible=have_hotWat),
        Rectangle(
          extent={{-112,-28},{-70,-88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          visible=have_hea),
        Rectangle(
          extent={{-136,-35},{-46,-46}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          visible=not have_hea),
        Text(
          extent={{-194,158},{-152,110}},
          textColor={0,0,127},
          textString="uFan"),
        Text(
          extent={{-198,-84},{-156,-132}},
          textColor={0,0,127},
          textString="uHea"),
        Text(
          extent={{-198,38},{-156,-10}},
          textColor={0,0,127},
          textString="uCoo"),
        Text(
          extent={{146,122},{188,74}},
          textColor={0,0,127},
          textString="uFan"),
        Line(points={{136,-10},{136,80},{200,80}}, color={0,0,0}),
        Line(points={{180,-46},{180,-80},{200,-80}}, color={0,0,0}),
        Ellipse(
          extent={{174,-54},{186,-66}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-200,120},{124,120},{124,-12}}, color={0,0,0}),
        Line(points={{-200,-120},{-40,-120}},     color={0,0,0},
             visible=have_hotWat),
        Line(points={{-200,0},{-154,0},{-154,-100},{70,-100},{70,-120},{120,
              -120}},                                 color={0,0,0}),
        Polygon(
          points={{110,-108},{130,-108},{120,-120},{110,-108}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-10,6},{10,6},{0,-6},{-10,6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={120,-126},
          rotation=180),
        Rectangle(
          extent={{-13,5},{13,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={119,-95},
          rotation=90),
        Polygon(
          points={{-10,6},{10,6},{0,-6},{-10,6}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-40,-126},
          rotation=180,
          visible=have_hotWat),
        Polygon(
          points={{-50,-108},{-30,-108},{-40,-120},{-50,-108}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=have_hotWat),
        Rectangle(
          extent={{-18,4},{18,-4}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-40,-90},
          rotation=90,
          visible=have_hotWat),
        Line(points={{-200,-120},{-90,-120},{-90,-88}},
                                                  color={0,0,0},
          visible=have_heaEle)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-260,-140},{260,140}})),
Documentation(info="<html>
<p>
This is a four-pipe fan coil unit system model. The system consists of the
following components:
</p>
<ul>
<li>
A supply fan <code>fan</code> of class
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>.
</li>
<li>
Heating coil options for no heating coil, a hot-water heating coil or an electric
heating coil determined by the user selection for parameter <code>heaCoiTyp</code>
as follows:
<ol>
<li>
No heating coil with bypass connector <code>pipByp</code> of class
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a> if <code>heaCoiTyp</code>
is set to <code>Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.None</code>.
</li>
<li>
A hot-water heating coil <code>heaCoiHW</code> of class
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DryCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.DryCoilCounterFlow</a> if <code>heaCoiTyp</code>
is set to <code>Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.WaterBased</code>.
</li>
<li>
An electric heating coil <code>heaCoiEle</code> of class
<a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a> if <code>heaCoiTyp</code>
is set to <code>Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil.Electric</code>.
</li>
</ol>
</li>
<li>
A chilled-water cooling coil <code>cooCoi</code> of class
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a>.
</li>
</ul>
<p>
For examples of how to use the model, refer to
<a href=\"modelica://Buildings.Examples.HydronicSystems.FanCoilUnit\">
Buildings.Examples.HydronicSystems.FanCoilUnit</a>. The following points are salient
when using the model:
</p>
<ul>
<li>
The connected air-loop does not need an additional fan, since the fan in this model
generates flow.
</li>
<li>
The fluid loop connections for hot-water and chilled-water require an external pressure
difference between the inlet and the outlet sufficient to overcome the pressure
drop across the two respective coils.
</li>
</ul>
<p>
The figure below shows the schematic diagram of the four pipe system when
<code>heaCoiTyp</code> is set to water based using the enumeration
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil\">
Buildings.Controls.OBC.ASHRAE.G36.Types.HeatingCoil</a>.
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/ZoneEquipment/FourPipe/FourPipe_schematic.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
September 22, 2025, by Michael Wetter:<br/>
Exposed parameters, reviewed model for first release.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2885\">issue 2885</a>.
</li>
<li>
August 03, 2022 by Karthik Devaprasad, Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end FourPipe;
