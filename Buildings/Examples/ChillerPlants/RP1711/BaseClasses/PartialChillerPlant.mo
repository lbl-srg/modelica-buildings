within Buildings.Examples.ChillerPlants.RP1711.BaseClasses;
partial model PartialChillerPlant "Chiller plant model for closed-loop test"
  Buildings.Examples.ChillerPlants.RP1711.BaseClasses.YorkCalc cooTow1
    annotation (Placement(transformation(extent={{340,370},{320,390}})));
  Buildings.Examples.ChillerPlants.RP1711.BaseClasses.YorkCalc cooTow2
    annotation (Placement(transformation(extent={{340,300},{320,320}})));
  Buildings.Fluid.Movers.SpeedControlled_y     conWatPum1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,200})));
  Buildings.Fluid.Movers.SpeedControlled_y     conWatPum2 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,200})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear cwIsoVal1
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{370,90},{390,110}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear cwIsoVal2
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{370,0},{390,20}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear chwIsoVal1
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{250,60},{230,80}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear chwIsoVal2
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{250,-30},{230,-10}})));
  Buildings.Fluid.FixedResistances.Junction jun annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={260,100})));
  Buildings.Fluid.FixedResistances.Junction jun1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,240})));
  Buildings.Fluid.FixedResistances.Junction jun2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,160})));
  Buildings.Fluid.FixedResistances.Junction jun3 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={260,310})));
  Buildings.Fluid.FixedResistances.Junction jun4 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={420,100})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear towIsoVal2
    "Cooling tower isolation valve"
    annotation (Placement(transformation(extent={{390,300},{370,320}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear towIsoVal1
    "Cooling tower isolation valve"
    annotation (Placement(transformation(extent={{390,370},{370,390}})));
  Buildings.Fluid.FixedResistances.Junction jun5 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={420,310})));
  Buildings.Fluid.FixedResistances.Junction jun6 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={440,-20})));
  Buildings.Fluid.FixedResistances.Junction jun7 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={200,-20})));
  Buildings.Fluid.Movers.SpeedControlled_y     chiWatPum1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,-112})));
  Buildings.Fluid.Movers.SpeedControlled_y     chiWatPum2 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,-112})));
  Buildings.Fluid.FixedResistances.Junction jun8 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={200,-80})));
  Buildings.Fluid.FixedResistances.Junction jun9 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={200,-150})));
  Buildings.Fluid.FixedResistances.Junction jun10 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={200,-220})));
  Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage valByp
    "Bypass valve for chiller." annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={330,-220})));
  Buildings.Fluid.FixedResistances.Junction jun11
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90, origin={440,-220})));
  Buildings.Fluid.Sensors.TemperatureTwoPort chiWatSupTem1
    "Chilled water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,-180})));
  Buildings.Fluid.Sensors.TemperatureTwoPort chiWatRet
    "Chilled water return temperature, after bypass" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={440,-180})));
  Buildings.Fluid.Sensors.TemperatureTwoPort chiWatRet1
    "Chilled water return temperature, before bypass" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={440,-260})));
  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={440,-60})));
  Buildings.Fluid.Sensors.TemperatureTwoPort conWatSupTem
    "Condenser water supply temperature, to the chiller condenser" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,280})));
  Buildings.Fluid.Sensors.TemperatureTwoPort conWatRetTem
    "Condenser water supply temperature, from the chiller condenser"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={420,280})));
  Buildings.Fluid.Sensors.RelativePressure senRelPre
    annotation (Placement(transformation(extent={{320,-330},{340,-310}})));
  Buildings.Fluid.FixedResistances.PressureDrop res annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={440,-300})));
  Buildings.Fluid.Chillers.ElectricEIR chi1
    annotation (Placement(transformation(extent={{320,84},{340,104}})));
  Buildings.Fluid.Chillers.ElectricEIR chi2
    annotation (Placement(transformation(extent={{320,-6},{340,14}})));

equation
  connect(jun3.port_1, cooTow1.port_b)
    annotation (Line(points={{260,320},{260,380},{320,380}},
                                                          color={238,46,47},
      thickness=1));
  connect(jun3.port_3, cooTow2.port_b)
    annotation (Line(points={{270,310},{320,310}},
                                                 color={238,46,47},
      thickness=1));
  connect(cooTow1.port_a, towIsoVal1.port_b)
    annotation (Line(points={{340,380},{370,380}}, color={238,46,47},
      thickness=1));
  connect(cooTow2.port_a, towIsoVal2.port_b)
    annotation (Line(points={{340,310},{370,310}}, color={238,46,47},
      thickness=1));
  connect(cwIsoVal2.port_b, jun4.port_1) annotation (Line(points={{390,10},{420,
          10},{420,90}},   color={238,46,47},
      thickness=1));
  connect(cwIsoVal1.port_b, jun4.port_3)
    annotation (Line(points={{390,100},{410,100}}, color={238,46,47},
      thickness=1));
  connect(jun5.port_2, towIsoVal1.port_a) annotation (Line(points={{420,320},{
          420,380},{390,380}}, color={238,46,47},
      thickness=1));
  connect(jun5.port_3, towIsoVal2.port_a)
    annotation (Line(points={{410,310},{390,310}}, color={238,46,47},
      thickness=1));
  connect(chwIsoVal1.port_b, jun7.port_1) annotation (Line(points={{230,70},{
          200,70},{200,-10}},
                           color={0,127,255},
      thickness=1));
  connect(jun7.port_3, chwIsoVal2.port_b)
    annotation (Line(points={{210,-20},{230,-20}}, color={0,127,255},
      thickness=1));
  connect(jun7.port_2, jun8.port_1)
    annotation (Line(points={{200,-30},{200,-70}}, color={0,127,255},
      thickness=1));
  connect(jun8.port_3,chiWatPum2. port_a)
    annotation (Line(points={{210,-80},{260,-80},{260,-102}},
                                                           color={0,127,255},
      thickness=1));
  connect(jun8.port_2,chiWatPum1. port_a)
    annotation (Line(points={{200,-90},{200,-102}},color={0,127,255},
      thickness=1));
  connect(chiWatPum1.port_b, jun9.port_1)
    annotation (Line(points={{200,-122},{200,-140}},
                                                   color={0,127,255},
      thickness=1));
  connect(chiWatPum2.port_b, jun9.port_3)
    annotation (Line(points={{260,-122},{260,-150},{210,-150}},
                                                           color={0,127,255},
      thickness=1));
  connect(jun10.port_3, valByp.port_a)
    annotation (Line(points={{210,-220},{320,-220}},
                                                  color={0,127,255},
      thickness=1));
  connect(valByp.port_b, jun11.port_3)
    annotation (Line(points={{340,-220},{430,-220}},
                                                   color={0,127,255},
      thickness=1));
  connect(jun.port_1, jun2.port_2)
    annotation (Line(points={{260,110},{260,150}},
                                                 color={238,46,47},
      thickness=1));
  connect(jun2.port_1, conWatPum2.port_b)
    annotation (Line(points={{260,170},{260,190}},
                                                 color={238,46,47},
      thickness=1));
  connect(conWatPum2.port_a, jun1.port_2)
    annotation (Line(points={{260,210},{260,230}},
                                                 color={238,46,47},
      thickness=1));
  connect(conWatPum1.port_b, jun2.port_3) annotation (Line(points={{200,190},{
          200,160},{250,160}},
                          color={238,46,47},
      thickness=1));
  connect(conWatPum1.port_a, jun1.port_3) annotation (Line(points={{200,210},{
          200,240},{250,240}},
                          color={238,46,47},
      thickness=1));
  connect(jun9.port_2, chiWatSupTem1.port_a)
    annotation (Line(points={{200,-160},{200,-170}},
                                                   color={0,127,255},
      thickness=1));
  connect(chiWatSupTem1.port_b, jun10.port_1)
    annotation (Line(points={{200,-190},{200,-210}},
                                                  color={0,127,255},
      thickness=1));
  connect(jun11.port_2, chiWatRet.port_a)
    annotation (Line(points={{440,-210},{440,-190}},
                                                 color={0,127,255},
      thickness=1));
  connect(chiWatRet1.port_b, jun11.port_1)
    annotation (Line(points={{440,-250},{440,-230}},
                                                 color={0,127,255},
      thickness=1));
  connect(senVolFlo.port_b, jun6.port_1)
    annotation (Line(points={{440,-50},{440,-30}}, color={0,127,255},
      thickness=1));
  connect(jun1.port_1, conWatSupTem.port_b)
    annotation (Line(points={{260,250},{260,270}}, color={238,46,47},
      thickness=1));
  connect(conWatSupTem.port_a, jun3.port_2)
    annotation (Line(points={{260,290},{260,300}}, color={238,46,47},
      thickness=1));
  connect(jun4.port_2, conWatRetTem.port_a)
    annotation (Line(points={{420,110},{420,270}}, color={238,46,47},
      thickness=1));
  connect(conWatRetTem.port_b, jun5.port_1)
    annotation (Line(points={{420,290},{420,300}}, color={238,46,47},
      thickness=1));
  connect(chiWatRet1.port_a, res.port_b)
    annotation (Line(points={{440,-270},{440,-290}},
                                                   color={0,127,255},
      thickness=1));
  connect(jun.port_3, chi1.port_a1)
    annotation (Line(points={{270,100},{320,100}}, color={238,46,47},
      thickness=1));
  connect(chi1.port_b1, cwIsoVal1.port_a)
    annotation (Line(points={{340,100},{370,100}}, color={238,46,47},
      thickness=1));
  connect(jun.port_2, chi2.port_a1) annotation (Line(points={{260,90},{260,10},
          {320,10}},  color={238,46,47},
      thickness=1));
  connect(chi2.port_b1, cwIsoVal2.port_a)
    annotation (Line(points={{340,10},{370,10}},   color={238,46,47},
      thickness=1));
  connect(chwIsoVal1.port_a, chi1.port_b2) annotation (Line(points={{250,70},{
          300,70},{300,88},{320,88}},    color={0,127,255},
      thickness=1));
  connect(chi1.port_a2, jun6.port_2) annotation (Line(points={{340,88},{360,88},
          {360,70},{440,70},{440,-10}},        color={0,127,255},
      thickness=1));
  connect(chwIsoVal2.port_a, chi2.port_b2) annotation (Line(points={{250,-20},{
          300,-20},{300,-2},{320,-2}},   color={0,127,255},
      thickness=1));
  connect(chi2.port_a2, jun6.port_3) annotation (Line(points={{340,-2},{360,-2},
          {360,-20},{430,-20}},      color={0,127,255},
      thickness=1));
  connect(chiWatRet.port_b, senVolFlo.port_a) annotation (Line(
      points={{440,-170},{440,-70}},
      color={0,127,255},
      thickness=1));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-580,
            -440},{580,440}})),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-580,-440},{580,440}}), graphics={Line(points={{290,46}},
            color={28,108,200})}));
end PartialChillerPlant;
