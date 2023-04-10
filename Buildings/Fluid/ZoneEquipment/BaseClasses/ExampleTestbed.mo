within Buildings.Fluid.ZoneEquipment.BaseClasses;
model ExampleTestbed
  "Example testbed for a zone HVAC system and controller with a single thermal zone"

  replaceable package MediumA = Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialCondensingGases
    "Medium model for air";

  replaceable package MediumW = Buildings.Media.Water
    "Medium model for water";

  Buildings.Fluid.Sources.Boundary_pT sinCoo(
    redeclare package Medium = MediumW,
    final T=279.15,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,origin={110,-100})));

  Buildings.Fluid.Sources.Boundary_pT sinHea(
    redeclare package Medium = MediumW,
    final T=318.15,
    nPorts=1)
    "Sink for heating hot water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,origin={40,-100})));

  replaceable Buildings.Fluid.ZoneEquipment.BaseClasses.EquipmentInterfaces zonHVACSys(
    redeclare package MediumA = MediumA,
    redeclare package MediumCHW = MediumW,
    redeclare package MediumHW = MediumW)
    "Zone HVAC system model interfaces"
    annotation (Placement(transformation(extent={{70,-20},{110,20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0.2)
    "Constant real signal of 0.2 for the outdoor air economizer"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));

  replaceable Buildings.Fluid.ZoneEquipment.BaseClasses.ControllerInterfaces conZonHVACSys
    "Controller interfaces"
    annotation (Placement(transformation(extent={{-54,-12},{-18,24}})));

  Buildings.Controls.SetPoints.OccupancySchedule occSch(
    final occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-150,-20},{-130,0}})));

  Buildings.Fluid.ZoneEquipment.BaseClasses.ZoneTemperatureSetpoint TZonSet
    "Zone temperature setpoint controller"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaFan
    "Convert fan enable signal to Real value"
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulFanSig
    "Find input fan signal by multiplying fan enable signal and fan speed signal"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThrFanProOn(
    final t=0.05)
    "Check if fan is running with speed greater than 10%"
    annotation (Placement(transformation(extent={{-130,-60},{-110,-40}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    final delayTime=60)
    "Ensure fan is running for minimum time period before generating proven on signal"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    redeclare package Medium = MediumA, nPorts=2)
    "Thermal zone"
    annotation (Placement(transformation(extent={{68,100},{108,140}})));

  Modelica.Blocks.Sources.Constant qIntGai(
    final k=0)
    "Internal heat gain"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));

  inner ThermalZones.EnergyPlus_9_6_0.Building building(
    final usePrecompiledFMU=false,
    final computeWetBulbTemperature=false)
    "Building model"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));

  Buildings.Fluid.Sources.Boundary_pT souHea(
    redeclare package Medium = MediumW,
    final p=105000,
    final T=318.15,
    nPorts=1)
    "Source for heating hot water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={70,-100})));

  Buildings.Fluid.Sources.Boundary_pT souCoo(
    redeclare package Medium = MediumW,
    final p=105000,
    final T=279.15,
    nPorts=1)
    "Source for chilled water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=90,
      origin={140,-100})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Check if fan is not operating"
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));

  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1(
    final delayTime=60)
    "Ensure fan is running for minimum time period before generating proven on signal"
    annotation (Placement(transformation(extent={{-70,-100},{-50,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Hold fan proven on signal until fan speed falls below 15% for 60 seconds"
    annotation (Placement(transformation(extent={{-30,-100},{-10,-80}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaOcc
    "Convert occupancy signal to Real value"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mulQIntGai
    "Find internal heat gain for zone only when it is occupied"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=3)
    "Convert internal heat gain value to vector"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));

equation
  connect(occSch.occupied, TZonSet.uOcc) annotation (Line(points={{-129,-16},{-120,
          -16},{-120,20},{-112,20}}, color={255,0,255}));
  connect(booToReaFan.y, mulFanSig.u2) annotation (Line(points={{22,-40},{30,
          -40},{30,-36},{38,-36}},
                              color={0,0,127}));
  connect(greThrFanProOn.y, truDel.u)
    annotation (Line(points={{-108,-50},{-102,-50}},
                                                   color={255,0,255}));
  connect(not1.y, truDel1.u)
    annotation (Line(points={{-78,-90},{-72,-90}}, color={255,0,255}));
  connect(greThrFanProOn.y, not1.u) annotation (Line(points={{-108,-50},{-104,
          -50},{-104,-90},{-102,-90}}, color={255,0,255}));
  connect(truDel1.y, lat.clr) annotation (Line(points={{-48,-90},{-40,-90},{-40,
          -96},{-32,-96}}, color={255,0,255}));
  connect(truDel.y, lat.u) annotation (Line(points={{-78,-50},{-36,-50},{-36,
          -90},{-32,-90}}, color={255,0,255}));
  connect(occSch.occupied, booToReaOcc.u) annotation (Line(points={{-129,-16},{
          -120,-16},{-120,90},{-102,90}}, color={255,0,255}));
  connect(qIntGai.y, mulQIntGai.u1) annotation (Line(points={{-79,130},{-68,130},
          {-68,116},{-62,116}}, color={0,0,127}));
  connect(booToReaOcc.y, mulQIntGai.u2) annotation (Line(points={{-78,90},{-68,
          90},{-68,104},{-62,104}}, color={0,0,127}));
  connect(mulQIntGai.y, reaScaRep.u)
    annotation (Line(points={{-38,110},{-22,110}}, color={0,0,127}));
  connect(reaScaRep.y, zon.qGai_flow) annotation (Line(points={{2,110},{20,110},
          {20,130},{66,130}}, color={0,0,127}));
  connect(zonHVACSys.port_Air_a2, zon.ports[1]) annotation (Line(points={{110,4},
          {130,4},{130,80},{86,80},{86,100.9}}, color={0,127,255}));
  connect(zonHVACSys.port_Air_b2, zon.ports[2]) annotation (Line(points={{110,-4},
          {140,-4},{140,90},{90,90},{90,100.9}}, color={0,127,255}));
  connect(sinHea.ports[1], zonHVACSys.port_HW_b) annotation (Line(points={{40,-90},
          {40,-50},{78,-50},{78,-19.8}},
                                       color={0,127,255}));
  connect(zonHVACSys.port_HW_a, souHea.ports[1]) annotation (Line(points={{84,
          -19.8},{84,-60},{70,-60},{70,-90}},
                                       color={0,127,255}));
  connect(zonHVACSys.port_CHW_b, sinCoo.ports[1]) annotation (Line(points={{96,
          -19.8},{96,-60},{110,-60},{110,-90}},
                                         color={0,127,255}));
  connect(zonHVACSys.port_CHW_a, souCoo.ports[1]) annotation (Line(points={{102,
          -19.8},{102,-50},{140,-50},{140,-90}},
                                               color={0,127,255}));
  connect(zonHVACSys.yFan_actual, greThrFanProOn.u) annotation (Line(points={{111,16},
          {120,16},{120,-70},{-140,-70},{-140,-50},{-132,-50}},     color={0,0,127}));
  connect(lat.y, conZonHVACSys.uFan) annotation (Line(points={{-8,-90},{0,-90},
          {0,-120},{-150,-120},{-150,-30},{-66,-30},{-66,22},{-56,22}},
                                                                   color={255,0,
          255}));
  connect(mulFanSig.y, zonHVACSys.uFan) annotation (Line(points={{62,-30},{64,
          -30},{64,10},{68,10}},
                          color={0,0,127}));
  connect(conZonHVACSys.yFanSpe, mulFanSig.u1) annotation (Line(points={{-16,2},
          {30,2},{30,-24},{38,-24}},     color={0,0,127}));
  connect(conZonHVACSys.yFan, booToReaFan.u) annotation (Line(points={{-16,-6},
          {-8,-6},{-8,-40},{-2,-40}},     color={255,0,255}));
  connect(occSch.occupied,conZonHVACSys.uAva)  annotation (Line(points={{-129,
          -16},{-120,-16},{-120,-4},{-56,-4}},
                                            color={255,0,255}));
  connect(TZonSet.TZonSetHea, conZonHVACSys.THeaSet) annotation (Line(points={{-88,24},
          {-80,24},{-80,2},{-56,2}},         color={0,0,127}));
  connect(TZonSet.TZonSetCoo, conZonHVACSys.TCooSet) annotation (Line(points={{-88,16},
          {-84,16},{-84,10},{-56,10}},       color={0,0,127}));
  connect(zon.TAir, conZonHVACSys.TZon) annotation (Line(points={{109,138},{120,
          138},{120,152},{-74,152},{-74,16},{-56,16}}, color={0,0,127}));
  connect(building.weaBus, zonHVACSys.weaBus) annotation (Line(
      points={{-30,80},{74,80},{74,18},{74.2,18}},
      color={255,204,51},
      thickness=0.5));
  connect(occSch.occupied, conZonHVACSys.fanOpeMod) annotation (Line(points={{
          -129,-16},{-120,-16},{-120,-10},{-56,-10}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-160,-160},{160,160}})),
    experiment(
      StopTime=86400,
      Interval=60,
      Tolerance=1e-06),
    __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/ZoneEquipment/FanCoilUnit/Example/SingleZoneVariableFanConstantWaterFlowrate.mos"
      "Simulate and plot"),
    Documentation(info="<html>
      <p>
      This is an example model for the fan coil unit system model 
      demonstrating use-case with a variable fan, constant pump flowrate controller. 
      It consists of:
      <ul>
      <li>
      an instance of the fan coil unit system model <code>fanCoiUni</code>.
      </li>
      <li>
      thermal zone model <code>zon</code> of class <a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone\">
      Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone</a>.
      </li>
      <li>
      ideal media sources <code>souCoo</code> and <code>souHea</code> for simulating 
      the supply of chilled water and heating hot-water respectively.
      </li>
      <li>
      fan coil unit controller <code>conVarFanConWat</code> of class <a href=\"modelica://Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.VariableFanConstantWaterFlowrate\">
      Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls.VariableFanConstantWaterFlowrate</a>.
      </li>
      <li>
      occupancy schedule controller <code>occSch</code>.
      </li>
      <li>
      zone temperature setpoint controller <code>TZonSet</code>.
      </li>
      </ul>
      </p>
      <p>
      The simulation model provides a closed-loop example of <code>fanCoiUni</code> that
      is operated by <code>conVarFanConWat</code> and regulates the zone temperature 
      in <code>zon</code> at the setpoint generated by <code>TZonSet</code>.
      <br>
      The plots shopw the zone temperature regulation, controller outputs and the 
      fan coil unit response.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      August 03, 2022 by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end ExampleTestbed;
