within Buildings.Examples.ChillerPlants.RP1711.PlantModel;
partial model ChillerPlant "Chiller plant model for closed-loop test"
  Fluid.Chillers.ElectricEIR chi1 "Chiller one"
    annotation (Placement(transformation(extent={{320,324},{340,344}})));
  Fluid.Chillers.ElectricEIR chi2 "Chiller two"
    annotation (Placement(transformation(extent={{320,264},{340,284}})));
  Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow1
    annotation (Placement(transformation(extent={{340,570},{320,590}})));
  Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow2
    annotation (Placement(transformation(extent={{340,530},{320,550}})));
  Fluid.Movers.FlowControlled_m_flow conWatPum1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,430})));
  Fluid.Movers.FlowControlled_m_flow conWatPum2 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,430})));
  Fluid.Actuators.Valves.TwoWayLinear cwIsoVal1
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{370,330},{390,350}})));
  Fluid.Actuators.Valves.TwoWayLinear cwIsoVal2
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{370,270},{390,290}})));
  Fluid.Actuators.Valves.TwoWayLinear chwIsoVal1
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{250,300},{230,320}})));
  Fluid.Actuators.Valves.TwoWayLinear chwIsoVal2
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{250,240},{230,260}})));
  Fluid.FixedResistances.Junction jun annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={260,340})));
  Fluid.FixedResistances.Junction jun1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,470})));
  Fluid.FixedResistances.Junction jun2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,390})));
  Fluid.FixedResistances.Junction jun3 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={260,540})));
  Fluid.FixedResistances.Junction jun4 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={420,340})));
  Fluid.Actuators.Valves.TwoWayLinear cwIsoVal3
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{390,530},{370,550}})));
  Fluid.Actuators.Valves.TwoWayLinear cwIsoVal4
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{390,570},{370,590}})));
  Fluid.FixedResistances.Junction jun5 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={420,540})));
  Fluid.FixedResistances.Junction jun6 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={440,250})));
  Fluid.FixedResistances.Junction jun7 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={200,250})));
  Fluid.Movers.FlowControlled_m_flow chiWatPum1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,178})));
  Fluid.Movers.FlowControlled_m_flow chiWatPum2 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,178})));
  Fluid.FixedResistances.Junction jun8 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={200,210})));
  Fluid.FixedResistances.Junction jun9 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={200,140})));
  Fluid.FixedResistances.Junction jun10 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={200,70})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage           valByp
    "Bypass valve for chiller." annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={330,70})));
  Fluid.FixedResistances.Junction jun11
                                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={440,70})));
  Fluid.HeatExchangers.DryCoilCounterFlow cooCoi
    annotation (Placement(transformation(extent={{320,-40},{340,-20}})));
  Fluid.MixingVolumes.MixingVolume           rooVol(nPorts=2)
                                                    "Volume of air in the room" annotation (Placement(
        transformation(extent={{321,-130},{341,-110}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow intHeaGai
    "Internal heat gain"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor
    annotation (Placement(transformation(extent={{140,-130},{160,-110}})));
  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor rooHeaCap
    "Heat capacitance of the room and walls"
    annotation (Placement(transformation(extent={{250,-80},{270,-60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature
    prescribedTemperature
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));
  Fluid.Sensors.TemperatureTwoPort rooAirTem "Room air temperature"
    annotation (Placement(transformation(extent={{380,-140},{400,-120}})));
  Fluid.Sensors.TemperatureTwoPort chiWatSupTem1
    "Chilled water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,110})));
  Fluid.Sensors.TemperatureTwoPort chiWatRet
    "Chilled water return temperature, after bypass" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={440,108})));
  Fluid.Sensors.TemperatureTwoPort chiWatRet1
    "Chilled water return temperature, before bypass" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={440,0})));
  Fluid.Sensors.VolumeFlowRate senVolFlo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={440,150})));
  Fluid.Sensors.TemperatureTwoPort conWatSupTem
    "Condenser water supply temperature, to the chiller condenser" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,510})));
  Fluid.Sensors.TemperatureTwoPort conWatRetTem
    "Condenser water supply temperature, from the chiller condenser"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={420,510})));
  Fluid.Sensors.RelativePressure senRelPre
    annotation (Placement(transformation(extent={{320,20},{340,40}})));
equation
  connect(chi1.port_b1, cwIsoVal1.port_a) annotation (Line(points={{340,340},{370,
          340}},                     color={0,127,255}));
  connect(chi2.port_b1, cwIsoVal2.port_a) annotation (Line(points={{340,280},{370,
          280}},                     color={0,127,255}));
  connect(jun.port_3, chi1.port_a1) annotation (Line(points={{270,340},{320,340}},
                             color={0,127,255}));
  connect(jun3.port_1, cooTow1.port_b)
    annotation (Line(points={{260,550},{260,580},{320,580}},
                                                          color={0,127,255}));
  connect(jun3.port_3, cooTow2.port_b)
    annotation (Line(points={{270,540},{320,540}},
                                                 color={0,127,255}));
  connect(cooTow1.port_a, cwIsoVal4.port_b)
    annotation (Line(points={{340,580},{370,580}}, color={0,127,255}));
  connect(cooTow2.port_a, cwIsoVal3.port_b)
    annotation (Line(points={{340,540},{370,540}}, color={0,127,255}));
  connect(cwIsoVal2.port_b, jun4.port_1) annotation (Line(points={{390,280},{420,
          280},{420,330}}, color={0,127,255}));
  connect(cwIsoVal1.port_b, jun4.port_3)
    annotation (Line(points={{390,340},{410,340}}, color={0,127,255}));
  connect(jun5.port_2, cwIsoVal4.port_a) annotation (Line(points={{420,550},{420,
          580},{390,580}}, color={0,127,255}));
  connect(jun5.port_3, cwIsoVal3.port_a)
    annotation (Line(points={{410,540},{390,540}}, color={0,127,255}));
  connect(chi2.port_a2, jun6.port_3)
    annotation (Line(points={{340,268},{360,268},{360,250},{430,250}},
                                                   color={0,127,255}));
  connect(chwIsoVal1.port_a, chi1.port_b2)
    annotation (Line(points={{250,310},{300,310},{300,328},{320,328}},
                                                 color={0,127,255}));
  connect(chwIsoVal2.port_a, chi2.port_b2)
    annotation (Line(points={{250,250},{300,250},{300,268},{320,268}},
                                                 color={0,127,255}));
  connect(chwIsoVal1.port_b, jun7.port_1) annotation (Line(points={{230,310},{200,
          310},{200,260}}, color={0,127,255}));
  connect(jun7.port_3, chwIsoVal2.port_b)
    annotation (Line(points={{210,250},{230,250}}, color={0,127,255}));
  connect(jun7.port_2, jun8.port_1)
    annotation (Line(points={{200,240},{200,220}}, color={0,127,255}));
  connect(jun8.port_3,chiWatPum2. port_a)
    annotation (Line(points={{210,210},{260,210},{260,188}},
                                                           color={0,127,255}));
  connect(jun8.port_2,chiWatPum1. port_a)
    annotation (Line(points={{200,200},{200,188}}, color={0,127,255}));
  connect(chiWatPum1.port_b, jun9.port_1)
    annotation (Line(points={{200,168},{200,150}}, color={0,127,255}));
  connect(chiWatPum2.port_b, jun9.port_3)
    annotation (Line(points={{260,168},{260,140},{210,140}},
                                                           color={0,127,255}));
  connect(jun10.port_3, valByp.port_a)
    annotation (Line(points={{210,70},{320,70}},  color={0,127,255}));
  connect(valByp.port_b, jun11.port_3)
    annotation (Line(points={{340,70},{430,70}},   color={0,127,255}));
  connect(jun.port_2, chi2.port_a1)
    annotation (Line(points={{260,330},{260,280},{320,280}},
                                                          color={0,127,255}));
  connect(jun.port_1, jun2.port_2)
    annotation (Line(points={{260,350},{260,380}},
                                                 color={0,127,255}));
  connect(jun2.port_1, conWatPum2.port_b)
    annotation (Line(points={{260,400},{260,420}},
                                                 color={0,127,255}));
  connect(conWatPum2.port_a, jun1.port_2)
    annotation (Line(points={{260,440},{260,460}},
                                                 color={0,127,255}));
  connect(conWatPum1.port_b, jun2.port_3) annotation (Line(points={{200,420},{200,
          390},{250,390}},color={0,127,255}));
  connect(conWatPum1.port_a, jun1.port_3) annotation (Line(points={{200,440},{200,
          470},{250,470}},color={0,127,255}));
  connect(chi1.port_a2, jun6.port_2) annotation (Line(points={{340,328},{360,328},
          {360,310},{440,310},{440,260}}, color={0,127,255}));
  connect(jun10.port_2,cooCoi. port_a1)
    annotation (Line(points={{200,60},{200,-24},{320,-24}},
                                                         color={0,127,255}));
  connect(thermalConductor.port_b, rooVol.heatPort)
    annotation (Line(points={{160,-120},{321,-120}},
                                                  color={191,0,0}));
  connect(prescribedTemperature.port, thermalConductor.port_a)
    annotation (Line(points={{120,-120},{140,-120}}, color={191,0,0}));
  connect(intHeaGai.port, rooVol.heatPort) annotation (Line(points={{160,-90},{260,
          -90},{260,-120},{321,-120}}, color={191,0,0}));
  connect(rooHeaCap.port, rooVol.heatPort) annotation (Line(points={{260,-80},{260,
          -120},{321,-120}}, color={191,0,0}));
  connect(cooCoi.port_b2, rooVol.ports[1]) annotation (Line(points={{320,-36},{200,
          -36},{200,-130},{329,-130}}, color={0,127,255}));
  connect(cooCoi.port_a2, rooAirTem.port_b) annotation (Line(points={{340,-36},{
          440,-36},{440,-130},{400,-130}}, color={0,127,255}));
  connect(rooAirTem.port_a, rooVol.ports[2])
    annotation (Line(points={{380,-130},{333,-130}}, color={0,127,255}));
  connect(jun9.port_2, chiWatSupTem1.port_a)
    annotation (Line(points={{200,130},{200,120}}, color={0,127,255}));
  connect(chiWatSupTem1.port_b, jun10.port_1)
    annotation (Line(points={{200,100},{200,80}}, color={0,127,255}));
  connect(jun11.port_2, chiWatRet.port_a)
    annotation (Line(points={{440,80},{440,98}}, color={0,127,255}));
  connect(cooCoi.port_b1, chiWatRet1.port_a) annotation (Line(points={{340,-24},
          {440,-24},{440,-10}}, color={0,127,255}));
  connect(chiWatRet1.port_b, jun11.port_1)
    annotation (Line(points={{440,10},{440,60}}, color={0,127,255}));
  connect(chiWatRet.port_b, senVolFlo.port_a)
    annotation (Line(points={{440,118},{440,140}}, color={0,127,255}));
  connect(senVolFlo.port_b, jun6.port_1)
    annotation (Line(points={{440,160},{440,240}}, color={0,127,255}));
  connect(jun1.port_1, conWatSupTem.port_b)
    annotation (Line(points={{260,480},{260,500}}, color={0,127,255}));
  connect(conWatSupTem.port_a, jun3.port_2)
    annotation (Line(points={{260,520},{260,530}}, color={0,127,255}));
  connect(jun4.port_2, conWatRetTem.port_a)
    annotation (Line(points={{420,350},{420,500}}, color={0,127,255}));
  connect(conWatRetTem.port_b, jun5.port_1)
    annotation (Line(points={{420,520},{420,530}}, color={0,127,255}));
  connect(jun10.port_2, senRelPre.port_a)
    annotation (Line(points={{200,60},{200,30},{320,30}}, color={0,127,255}));
  connect(senRelPre.port_b, jun11.port_1)
    annotation (Line(points={{340,30},{440,30},{440,60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-580,-660},
            {580,660}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-580,-660},{580,660}})));
end ChillerPlant;
