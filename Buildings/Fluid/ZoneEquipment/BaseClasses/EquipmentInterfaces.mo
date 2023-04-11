within Buildings.Fluid.ZoneEquipment.BaseClasses;
partial model EquipmentInterfaces
  "Baseclass for zone HVAC equipment interfaces"

  replaceable package MediumA = Modelica.Media.Interfaces.PartialMedium
    "Medium model for air";

  replaceable package MediumHW = Modelica.Media.Interfaces.PartialMedium
    "Medium model for hot water";

  replaceable package MediumCHW = Modelica.Media.Interfaces.PartialMedium
    "Medium model for chilled water";

  parameter Modelica.Units.SI.MassFlowRate mHotWat_flow_nominal = 0.1
    "Nominal mass flow rate of heating hot water"
    annotation(Dialog(enable=heaCoiTyp == Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.hotWat, group="Heating coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mChiWat_flow_nominal = 0.1
    "Nominal mass flow rate of chilled water"
    annotation(Dialog(enable=cooCoiTyp == Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.chiWat,group="Cooling coil parameters"));

  parameter Modelica.Units.SI.MassFlowRate mAirOut_flow_nominal
    "Nominal mass flow rate of outdoor air"
    annotation(Dialog(enable=((oaPorTyp == Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaMix)
           or (oaPorTyp == Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaPorts)),
                                                                                   group="System parameters"));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Nominal mass flow rate of supply air"
    annotation(Dialog(group="System parameters"));

  parameter Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou heaCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.hotWat
    "Type of heating coil used" annotation (Dialog(group="System parameters"));

  parameter Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou cooCoiTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.chiWat
    "Type of cooling coil used" annotation (Dialog(group="System parameters"));

  parameter Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts oaPorTyp=Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaPorts
    "Type of OA port" annotation (Dialog(group="System parameters"));

  Modelica.Blocks.Interfaces.RealInput uHea(
    final unit="1") if has_varHea and has_hea "Heating loop signal"
    annotation(Placement(transformation(extent={{-400,-100},{-360,-60}}),
      iconTransformation(extent={{-240,-198},{-200,-158}})));

  Modelica.Blocks.Interfaces.BooleanInput uCooEna if not has_varCoo and has_coo
    "Cooling coil enable signal"
    annotation (Placement(transformation(extent={{-400,-140},{-360,-100}}),
      iconTransformation(extent={{-240,-118},{-200,-78}})));

  Modelica.Blocks.Interfaces.BooleanInput uHeaEna if not has_varHea and has_hea
    "Heating coil enable signal"
    annotation (Placement(transformation(extent={{-400,-180},{-360,-140}}),
      iconTransformation(extent={{-240,-198},{-200,-158}})));

  Modelica.Blocks.Interfaces.RealInput uCoo(
    final unit="1") if has_varCoo and has_coo
    "Cooling loop signal"
    annotation(Placement(transformation(extent={{-400,-60},{-360,-20}}),
      iconTransformation(extent={{-240,-118},{-200,-78}})));

  Modelica.Blocks.Interfaces.RealInput uFan(
    final unit="1")
    "Fan signal"
    annotation(Placement(transformation(extent={{-400,100},{-360,140}}),
      iconTransformation(extent={{-240,80},{-200,120}})));

  Modelica.Blocks.Interfaces.RealInput uEco(
    final unit="1")
    "Control signal for economizer"
    annotation (Placement(transformation(extent={{-400,140},{-360,180}}),
      iconTransformation(extent={{-240,160},{-200,200}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_Air_a2(
    redeclare final package Medium = MediumA)
    "Return air port from zone"
    annotation (Placement(transformation(extent={{350,30},{370,50}}),
      iconTransformation(extent={{190,30},{210,50}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_Air_b2(
    redeclare final package Medium = MediumA)
    "Supply air port to the zone"
    annotation (Placement(transformation(extent={{350,-50},{370,-30}}),
      iconTransformation(extent={{190,-50},{210,-30}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_CHW_b(
    redeclare final package Medium = MediumCHW) if has_CHW
    "Chilled water return port"
    annotation (Placement(transformation(extent={{94,-190},{114,-170}}),
      iconTransformation(extent={{50,-208},{70,-188}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_CHW_a(
    redeclare package Medium = MediumCHW) if has_CHW
    "Chilled water supply port"
    annotation (Placement(transformation(extent={{134,-190},{154,-170}}),
      iconTransformation(extent={{110,-208},{130,-188}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_HW_b(
    redeclare final package Medium = MediumHW) if has_HW
    "Hot water return port"
    annotation (Placement(transformation(extent={{-46,-190},{-26,-170}}),
      iconTransformation(extent={{-130,-208},{-110,-188}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_HW_a(
    redeclare final package Medium = MediumHW) if has_HW
    "Hot water supply port"
    annotation (Placement(transformation(extent={{-6,-190},{14,-170}}),
      iconTransformation(extent={{-70,-208},{-50,-188}})));

  Modelica.Blocks.Interfaces.RealOutput yFan_actual(
    final unit="1",
    displayUnit="1")
    "Normalized measured fan speed signal"
    annotation (Placement(transformation(extent={{360,100},{380,120}}),
      iconTransformation(extent={{200,150},{220,170}})));

  Modelica.Blocks.Interfaces.RealOutput TAirSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{360,70},{380,90}}),
      iconTransformation(extent={{200,90},{220,110}})));

  Actuators.Valves.TwoWayLinear valHW(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal,
    final dpValve_nominal=50) if has_HW
    "Hot water flow control valve"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={-36,-80})));

  Sensors.VolumeFlowRate VHW_flow(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if has_HW
    "Hot water volume flowrate sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={4,-90})));

  Sensors.TemperatureTwoPort THWRet(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if has_HW
    "Hot water return temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={-36,-110})));

  Sensors.TemperatureTwoPort THWSup(
    redeclare final package Medium = MediumHW,
    final m_flow_nominal=mHotWat_flow_nominal) if has_HW
    "Hot water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={4,-120})));

  Actuators.Valves.TwoWayLinear valCHW(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal,
    final dpValve_nominal=50) if has_CHW
    "Chilled-water flow control valve"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={104,-80})));
  Sensors.TemperatureTwoPort TCHWLvg(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal) if has_CHW
    "Chilled-water return temperature sensor"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=-90,
      origin={104,-110})));

  Sensors.VolumeFlowRate VCHW_flow(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal) if has_CHW
    "Chilled-water volume flowrate sensor"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={144,-90})));

  Sensors.TemperatureTwoPort TCHWEnt(
    redeclare final package Medium = MediumCHW,
    final m_flow_nominal=mChiWat_flow_nominal) if has_CHW
    "Chilled-water supply temperature sensor"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={144,-120})));

  Modelica.Fluid.Interfaces.FluidPort_a port_Air_a1(
    redeclare final package Medium = MediumA) if has_extOAPor
    "Ventilation inlet air port from the outdoor air"
    annotation (Placement(transformation(extent={{-370,-10},{-350,10}}),
      iconTransformation(extent={{-210,-50},{-190,-30}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_Air_b1(
    redeclare final package Medium = MediumA) if has_extOAPor
    "Exhaust air port to the outdoor air"
    annotation (Placement(transformation(extent={{-370,70},{-350,90}}),
      iconTransformation(extent={{-210,30},{-190,50}})));

  BoundaryConditions.WeatherData.Bus weaBus "if not has_extOAPor and has_ven"
    annotation (Placement(transformation(extent={{-350,10},{-310,50}}),
      iconTransformation(extent={{-168,170},{-148,190}})));

  Sources.Outside out(
    redeclare final package Medium = MediumA,
    nPorts=2) if not has_extOAPor and has_ven
    "Boundary conditions for outside air"
    annotation (Placement(transformation(extent={{-300,40},{-280,20}})));

  Sensors.VolumeFlowRate vAirOut(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal) if not has_extOAPor and has_ven
    "Outdoor air volume flowrate"
    annotation (Placement(transformation(extent={{-260,-2},{-240,18}})));

  Sensors.VolumeFlowRate VAirExh_flow(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal) if not has_extOAPor and has_ven
    "Exhaust air volume flowrate"
    annotation (Placement(transformation(extent={{-240,40},{-260,60}})));

  Sensors.TemperatureTwoPort TAirOut(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal) if not has_extOAPor and has_ven
    "Outdoor air temperature sensor"
    annotation (Placement(transformation(extent={{-230,-2},{-210,18}})));

  Sensors.TemperatureTwoPort TAirExh(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAirOut_flow_nominal) if not has_extOAPor and has_ven
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-210,40},{-230,60}})));

  Actuators.Dampers.MixingBox eco(
    redeclare final package Medium = MediumA,
    final mOut_flow_nominal=mAirOut_flow_nominal,
     dpDamOut_nominal=50,
    final mRec_flow_nominal=mAir_flow_nominal,
     dpDamRec_nominal=50,
    final mExh_flow_nominal=mAirOut_flow_nominal,
     dpDamExh_nominal=50) if not has_extOAPor and has_ven
    "Outdoor air economizer"
    annotation (Placement(transformation(extent={{-200,40},{-180,20}})));

  Sensors.TemperatureTwoPort TAirRet(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal) if has_ven
    "Return air temperature sensor"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));

  Sensors.VolumeFlowRate vAirRet(
    redeclare final package Medium = MediumA,
    m_flow_nominal=mAir_flow_nominal) if has_ven
    "Return air volume flowrate"
    annotation (Placement(transformation(extent={{-110,40},{-90,60}})));

  Sensors.VolumeFlowRate vAirMix(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Mixed air volume flowrate"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Sensors.TemperatureTwoPort TAirMix(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Mixed air temperature sensor"
    annotation (Placement(transformation(extent={{-130,-10},{-110,10}})));

  Sensors.TemperatureTwoPort TAirLvg(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal) "Supply air temperature sensor"
    annotation (Placement(transformation(extent={{240,-10},{260,10}})));

  Sensors.VolumeFlowRate vAirSup(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=mAir_flow_nominal)
    "Supply air volume flow rate"
    annotation (Placement(transformation(extent={{280,-10},{300,10}})));

protected
  final parameter Boolean has_HW=(heaCoiTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.hotWat)
    "Does the zone equipment have a hot water heating coil?";

  final parameter Boolean has_CHW=(cooCoiTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.chiWat)
    "Does the zone equipment have a chilled water cooling coil?";

  final parameter Boolean has_extOAPor=(oaPorTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaPorts)
    "Does the zone equipment have ports for receiving outdoor air?";

  final parameter Boolean has_ven=((oaPorTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaMix) or
    (oaPorTyp ==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.OAPorts.oaPorts))
    "Does the zone equipment provide outdoor air for ventilation?";

  final parameter Boolean has_coo=not
                                     (cooCoiTyp==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.noCoo)
    "Does the zone equipment have a cooling element?";

  final parameter Boolean has_hea=not
                                     (heaCoiTyp==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.noHea)
    "Does the zone equipment have a heating element?";

  final parameter Boolean has_varCoo=not
                                        (cooCoiTyp==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.CooSou.eleDX)
    "Does the zone equipment have variable PLR cooling equipment?";

  final parameter Boolean has_varHea=not
                                        (heaCoiTyp==Buildings.Fluid.ZoneEquipment.BaseClasses.Types.HeaSou.heaPum)
    "Does the zone equipment have variable PLR heating equipment?";

equation
  connect(THWRet.port_a,valHW. port_a)
    annotation (Line(points={{-36,-100},{-36,-90}},color={0,127,255}));
  connect(THWSup.port_b,VHW_flow. port_a)
    annotation (Line(points={{4,-110},{4,-100}},color={0,127,255}));
  connect(THWRet.port_b, port_HW_b)
    annotation (Line(points={{-36,-120},{-36,-180}}, color={0,127,255}));
  connect(THWSup.port_a, port_HW_a)
    annotation (Line(points={{4,-130},{4,-180}}, color={0,127,255}));
  connect(TCHWLvg.port_a,valCHW. port_a)
    annotation (Line(points={{104,-100},{104,-90}},color={0,127,255}));
  connect(TCHWEnt.port_b,VCHW_flow. port_a)
    annotation (Line(points={{144,-110},{144,-100}},
                                                   color={0,127,255}));
  connect(TCHWLvg.port_b, port_CHW_b)
    annotation (Line(points={{104,-120},{104,-180}}, color={0,127,255}));
  connect(TCHWEnt.port_a, port_CHW_a)
    annotation (Line(points={{144,-130},{144,-180}}, color={0,127,255}));
  connect(weaBus, out.weaBus) annotation (Line(
      points={{-330,30},{-316,30},{-316,29.8},{-300,29.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(out.ports[1], vAirOut.port_a) annotation (Line(points={{-280,28},{-270,
          28},{-270,8},{-260,8}},   color={0,127,255}));
  connect(out.ports[2], VAirExh_flow.port_b) annotation (Line(points={{-280,32},
          {-270,32},{-270,50},{-260,50}},    color={0,127,255}));
  connect(vAirOut.port_b, TAirOut.port_a)
    annotation (Line(points={{-240,8},{-230,8}},   color={0,127,255}));
  connect(TAirOut.port_b, eco.port_Out) annotation (Line(points={{-210,8},{-206,
          8},{-206,24},{-200,24}},color={0,127,255}));
  connect(TAirExh.port_a, eco.port_Exh) annotation (Line(points={{-210,50},{-206,
          50},{-206,36},{-200,36}},  color={0,127,255}));
  connect(VAirExh_flow.port_a, TAirExh.port_b)
    annotation (Line(points={{-240,50},{-230,50}},   color={0,127,255}));
  connect(uEco, eco.y) annotation (Line(points={{-380,160},{-314,160},{-314,-8},
          {-190,-8},{-190,18}},
        color={0,0,127}));
  connect(eco.port_Sup, TAirMix.port_a)
    annotation (Line(points={{-180,24},{-170,24},{-170,0},{-130,0}},
                                                   color={0,127,255}));
  connect(TAirRet.port_b, vAirRet.port_a)
    annotation (Line(points={{-120,50},{-110,50}}, color={0,127,255}));
  connect(vAirRet.port_b, eco.port_Ret) annotation (Line(points={{-90,50},{-80,
          50},{-80,98},{-180,98},{-180,36}},
                                        color={0,127,255}));
  connect(TAirMix.port_b, vAirMix.port_a) annotation (Line(points={{-110,0},{-100,
          0}},                      color={0,127,255}));
  connect(port_Air_a1, TAirMix.port_a) annotation (Line(points={{-360,0},{-330,
          0},{-330,-26},{-160,-26},{-160,0},{-130,0}},
                                                 color={0,127,255}));
  connect(port_Air_b1, vAirRet.port_b) annotation (Line(points={{-360,80},{-312,
          80},{-312,108},{-66,108},{-66,50},{-90,50}},
                                                     color={0,127,255}));
  connect(TAirRet.port_a, port_Air_a2) annotation (Line(points={{-140,50},{-140,
          78},{-2,78},{-2,40},{360,40}},   color={0,127,255}));
  if not has_ven then
    connect(port_Air_a2, TAirMix.port_a)
    annotation (Line(points={{360,40},{-34,40},{-34,26},{-142,26},{-142,0},{
            -130,0}},                           color={0,127,255}));
  end if;
  connect(TAirLvg.port_b,vAirSup. port_a)
    annotation (Line(points={{260,0},{280,0}},     color={0,127,255}));
  connect(vAirSup.port_b, port_Air_b2) annotation (Line(points={{300,0},{340,0},
          {340,-40},{360,-40}}, color={0,127,255}));
  connect(TAirLvg.T, TAirSup)
    annotation (Line(points={{250,11},{250,80},{370,80}},color={0,0,127}));
  annotation (defaultComponentName = "zonHVACSys",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}}),
                               graphics={Rectangle(
          extent={{-200,200},{200,-200}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,200},{100,240}},
          textString="%name",
          textColor={0,0,255})}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-360,-180},{360,180}})),
    Documentation(revisions="<html>
    <ul>
    <li>
    August 03, 2022 by Karthik Devaprasad, Sen Huang:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end EquipmentInterfaces;
