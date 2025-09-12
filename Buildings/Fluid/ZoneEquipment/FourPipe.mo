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

  parameter Modelica.Units.SI.HeatFlowRate QHeaCoi_flow_nominal(
    final min=0,
    final start=0)
    "Nominal heat flow rate of electric heating coil"
    annotation(Dialog(enable=have_heaEle, group="Heating coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mHotWat_flow_nominal(
    final min=0,
    final start=0)
    "Nominal mass flow rate of heating hot water"
    annotation(Dialog(enable=have_hotWat, group="Heating coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpHotWatCoi_nominal
    "Total pressure difference across heating coil (Hot-water side)"
    annotation(Dialog(enable=have_hotWat, group="Heating coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpAir_nominal
    "Total pressure difference across supply and return ports in airloop"
    annotation(Dialog(group="System parameters"));

  parameter Modelica.Units.SI.ThermalConductance UAHeaCoi_nominal(
    final min=0,
    final start=0)
    "Thermal conductance at nominal flow, used to compute heat capacity"
    annotation(Dialog(enable=have_hotWat, group="Heating coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal
    "Nominal mass flow rate of chilled water"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.PressureDifference dpChiWatCoi_nominal
    "Total pressure difference across cooling coil (Chilled-water side)"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.ThermalConductance UACooCoi_nominal
    "Nominal Thermal conductance, used to compute heat capacity"
    annotation(Dialog(group="Cooling coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Nominal mass flow rate of supply air"
    annotation(Dialog(group="System parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final unit="1") if have_hea
    "Heating loop control signal"
    annotation(Placement(transformation(extent={{-300,-140},{-260,-100}}),
      iconTransformation(extent={{-240,-80},{-200,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final unit="1")
    "Cooling loop control signal"
    annotation(Placement(transformation(extent={{-300,-70},{-260,-30}}),
      iconTransformation(extent={{-240,-20},{-200,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFan(
    final unit="1")
    "Fan normalized speed control signal"
    annotation(Placement(transformation(extent={{-300,60},{-260,100}}),
      iconTransformation(extent={{-240,40},{-200,80}})));

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
    annotation (Placement(transformation(extent={{260,50},{300,90}}),
      iconTransformation(extent={{200,-100},{240,-60}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_air_a(
    redeclare final package Medium = MediumA)
    "Return air port from zone"
    annotation (Placement(transformation(extent={{250,80},{270,100}}),
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

  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow heaCoiHW(
    redeclare final package Medium1 = MediumHW,
    redeclare final package Medium2 = MediumA,
    final m1_flow_nominal=mHotWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=dpHotWatCoi_nominal,
    final dp2_nominal=0,
    final UA_nominal=UAHeaCoi_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial) if have_hotWat
    "Hot water heating coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180,
      origin={-90,-10})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valHW(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal,
    final dpValve_nominal=50,
    dpFixed_nominal=0) if have_hotWat
    "Hot water flow control valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={-60,-80})));

  Buildings.Fluid.Sensors.VolumeFlowRate VHW_flow(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if have_hotWat
    "Hot water volume flowrate sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-120,-80})));

  Buildings.Fluid.Sensors.TemperatureTwoPort THWRet(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if have_hotWat
    "Hot water return temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={-60,-110})));

  Buildings.Fluid.Sensors.TemperatureTwoPort THWSup(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if have_hotWat
    "Hot water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-120,-110})));

  Buildings.Fluid.HeatExchangers.WetCoilCounterFlow cooCoi(
    redeclare final package Medium1 = MediumCHW,
    redeclare final package Medium2 = MediumA,
    final m1_flow_nominal=mChiWat_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=dpChiWatCoi_nominal,
    final dp2_nominal=0,
    final UA_nominal=UACooCoi_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Chilled-water cooling coil"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180,
      origin={30,-10})));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear valCHW(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dpValve_nominal=50,
    dpFixed_nominal=0)
    "Chilled-water flow control valve"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=90,
      origin={60,-80})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWLvg(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled-water return temperature sensor"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={60,-110})));

  Buildings.Fluid.Sensors.VolumeFlowRate VCHW_flow(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled-water volume flowrate sensor"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={0,-80})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TCHWEnt(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal)
    "Chilled-water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={0,-112})));

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

  Buildings.Fluid.Sensors.VolumeFlowRate senSupFlo(redeclare final package
      Medium = MediumA, final m_flow_nominal=mAir_flow_nominal)
    "Supply air volume flow rate"
    annotation (Placement(transformation(extent={{200,-10},{220,10}})));

  Buildings.Fluid.FixedResistances.PressureDrop totResAir(
    redeclare final package Medium = MediumA,
    final m_flow_nominal = mAir_flow_nominal,
    final dp_nominal = dpAir_nominal,
    final allowFlowReversal = true)
    "Total resistance of air path"
    annotation(Placement(transformation(extent={{80,-10},{100,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TAirRet(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-230,-10},{-210,10}})));

  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoiEle(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=0,
    final Q_flow_nominal=QHeaCoi_flow_nominal) if have_heaEle
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

  Buildings.Fluid.FixedResistances.PressureDrop pipByp(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=0,
    final allowFlowReversal=true) if not have_hea
    "Bypass when heating coil is absent"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

equation
  connect(valHW.port_a, heaCoiHW.port_b1) annotation (Line(points={{-60,-70},{
          -60,-34},{-110,-34},{-110,-16},{-100,-16}},
                           color={0,127,255}));
  connect(THWRet.port_a, valHW.port_b)
    annotation (Line(points={{-60,-100},{-60,-90}},color={0,127,255}));
  connect(THWSup.port_b, VHW_flow.port_a)
    annotation (Line(points={{-120,-100},{-120,-90}},
                                                color={0,127,255}));
  connect(heaCoiHW.port_b2, TAirHea.port_a) annotation (Line(points={{-80,-4},{
          -60,-4},{-60,0},{-30,0}},    color={0,127,255}));
  connect(uHea, valHW.y) annotation (Line(points={{-280,-120},{-140,-120},{-140,
          -60},{-80,-60},{-80,-80},{-72,-80}},
                      color={0,0,127}));
  connect(port_HW_a, THWSup.port_a)
    annotation (Line(points={{-120,-140},{-120,-120}},
                                                 color={0,127,255}));
  connect(port_HW_b, THWRet.port_b)
    annotation (Line(points={{-60,-140},{-60,-120}}, color={0,127,255}));
  connect(TCHWLvg.port_a, valCHW.port_b)
    annotation (Line(points={{60,-100},{60,-90}},  color={0,127,255}));
  connect(valCHW.port_a, cooCoi.port_b1) annotation (Line(points={{60,-70},{60,
          -40},{10,-40},{10,-16},{20,-16}},
                           color={0,127,255}));
  connect(VCHW_flow.port_b, cooCoi.port_a1) annotation (Line(points={{0,-70},{0,
          -30},{50,-30},{50,-16},{40,-16}},
                               color={0,127,255}));
  connect(TCHWEnt.port_b, VCHW_flow.port_a)
    annotation (Line(points={{0,-102},{0,-90}},    color={0,127,255}));
  connect(TAirHea.port_b, cooCoi.port_a2) annotation (Line(points={{-10,0},{0,0},
          {0,-4},{20,-4}},        color={0,127,255}));
  connect(port_CHW_b, TCHWLvg.port_b) annotation (Line(points={{60,-140},{60,
          -120}},               color={0,127,255}));
  connect(fan.port_b, TAirLvg.port_a)
    annotation (Line(points={{140,0},{160,0}},     color={0,127,255}));
  connect(uCoo, valCHW.y) annotation (Line(points={{-280,-50},{40,-50},{40,-80},
          {48,-80}}, color={0,0,127}));
  connect(TAirLvg.port_b, senSupFlo.port_a)
    annotation (Line(points={{180,0},{200,0}}, color={0,127,255}));
  connect(senSupFlo.port_b, port_Air_b) annotation (Line(points={{220,0},{260,0}},
                                color={0,127,255}));
  connect(cooCoi.port_b2, totResAir.port_a)
    annotation (Line(points={{40,-4},{60,-4},{60,0},{80,0}},
                                                 color={0,127,255}));
  connect(TAirRet.port_a, port_Air_a) annotation (Line(points={{-230,0},{-236,0},
          {-236,90},{260,90}},                   color={0,127,255}));
  connect(heaCoiEle.port_b, TAirHea.port_a) annotation (Line(points={{-80,20},{
          -60,20},{-60,0},{-30,0}},
                                  color={0,127,255}));
  connect(uHea, heaCoiEle.u) annotation (Line(points={{-280,-120},{-140,-120},{
          -140,26},{-102,26}},
                         color={0,0,127}));
  connect(TCHWEnt.port_a, port_CHW_a)
    annotation (Line(points={{0,-122},{0,-140}},    color={0,127,255}));
  connect(heaCoiHW.port_a1, VHW_flow.port_b)
    annotation (Line(points={{-80,-16},{-70,-16},{-70,-40},{-120,-40},{-120,-70}},
                                                       color={0,127,255}));
  connect(TAirLvg.T, TAirSup)
    annotation (Line(points={{170,11},{170,70},{280,70}},  color={0,0,127}));
  connect(totResAir.port_b, fan.port_a) annotation (Line(points={{100,0},{120,0}},
                                color={0,127,255}));
  connect(pipByp.port_b, TAirHea.port_a) annotation (Line(points={{-80,60},{-60,
          60},{-60,0},{-30,0}}, color={0,127,255}));
  connect(TAirRet.port_b, heaCoiHW.port_a2) annotation (Line(points={{-210,0},{
          -108,0},{-108,-4},{-100,-4}}, color={0,127,255}));
  connect(TAirRet.port_b, heaCoiEle.port_a) annotation (Line(points={{-210,0},{
          -108,0},{-108,20},{-100,20}}, color={0,127,255}));
  connect(TAirRet.port_b, pipByp.port_a) annotation (Line(points={{-210,0},{
          -108,0},{-108,60},{-100,60}}, color={0,127,255}));
  connect(uFan, fan.y) annotation (Line(points={{-280,80},{130,80},{130,12}},
                             color={0,0,127}));
  connect(fan.y_actual, yFan_actual) annotation (Line(points={{141,7},{146,7},{
          146,110},{280,110}},  color={0,0,127}));
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
          extent={{-64.25,4.25},{64.25,-4.25}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={119.75,-136.25},
          rotation=90),
                 Ellipse(
        extent={{120,-10},{180,-70}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid), Polygon(
        points={{150,-10},{150,-70},{180,-40},{150,-10}},
        lineColor={0,0,0},
        fillColor={0,0,0},
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
          extent={{-64.25,4.25},{64.25,-4.25}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-40.25,-136.25},
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
          visible=not have_hea)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-260,-140},{260,140}})),
Documentation(info="<html>
<p>
This is a four-pipe fan coil unit system model. The system consists of the
following components:
</p>
<ul>
<li>
a supply fan <code>fan</code> of class
<a href=\"modelica://Buildings.Fluid.Movers.FlowControlled_m_flow\">
Buildings.Fluid.Movers.FlowControlled_m_flow</a>.
</li>
<li>
heating coil options for no heating coil, a hot-water heating coil or an electric
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
a chilled-water cooling coil <code>cooCoi</code> of class
<a href=\"modelica://Buildings.Fluid.HeatExchangers.WetCoilCounterFlow\">
Buildings.Fluid.HeatExchangers.WetCoilCounterFlow</a>.
</ul>
<p>
For examples of how to use the model, refer to
<a href=\"modelica://Buildings.Examples.HydronicSystems.FanCoilUnit\">
Buildings.Examples.HydronicSystems.FanCoilUnit</a>
</p>
The figure below shows the schematic diagram of the four pipe system:
</p>
<p>
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/ZoneEquipment/FourPipe/FourPipe_schematic.png\" width=\"50%\"/>
</p>
<p>
</html>", revisions="<html>
<ul>
<li>
August 03, 2022 by Karthik Devaprasad, Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end FourPipe;
