within Buildings.Examples.ChillerPlants.RP1711.BaseClasses;
partial model PartialChillerPlant "Chiller plant model for closed-loop test"
  Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow1
    annotation (Placement(transformation(extent={{340,610},{320,630}})));
  Fluid.HeatExchangers.CoolingTowers.YorkCalc cooTow2
    annotation (Placement(transformation(extent={{340,540},{320,560}})));
  Fluid.Movers.SpeedControlled_y     conWatPum1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,440})));
  Fluid.Movers.SpeedControlled_y     conWatPum2 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,440})));
  Fluid.Actuators.Valves.TwoWayLinear cwIsoVal1
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{370,330},{390,350}})));
  Fluid.Actuators.Valves.TwoWayLinear cwIsoVal2
    "Condenser water isolation valve"
    annotation (Placement(transformation(extent={{370,240},{390,260}})));
  Fluid.Actuators.Valves.TwoWayLinear chwIsoVal1
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{250,300},{230,320}})));
  Fluid.Actuators.Valves.TwoWayLinear chwIsoVal2
    "Chilled water isolation valve"
    annotation (Placement(transformation(extent={{250,210},{230,230}})));
  Fluid.FixedResistances.Junction jun annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={260,340})));
  Fluid.FixedResistances.Junction jun1 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,480})));
  Fluid.FixedResistances.Junction jun2 annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,400})));
  Fluid.FixedResistances.Junction jun3 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={260,550})));
  Fluid.FixedResistances.Junction jun4 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={420,340})));
  Fluid.Actuators.Valves.TwoWayLinear towIsoVal2
    "Cooling tower isolation valve"
    annotation (Placement(transformation(extent={{390,540},{370,560}})));
  Fluid.Actuators.Valves.TwoWayLinear towIsoVal1
    "Cooling tower isolation valve"
    annotation (Placement(transformation(extent={{390,610},{370,630}})));
  Fluid.FixedResistances.Junction jun5 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={420,550})));
  Fluid.FixedResistances.Junction jun6 annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={440,220})));
  Fluid.FixedResistances.Junction jun7 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={200,220})));
  Fluid.Movers.SpeedControlled_y     chiWatPum1 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,128})));
  Fluid.Movers.SpeedControlled_y     chiWatPum2 annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,128})));
  Fluid.FixedResistances.Junction jun8 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={200,160})));
  Fluid.FixedResistances.Junction jun9 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={200,90})));
  Fluid.FixedResistances.Junction jun10 annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={200,20})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage           valByp
    "Bypass valve for chiller." annotation (Placement(
        transformation(extent={{-10,-10},{10,10}}, origin={330,20})));
  Fluid.FixedResistances.Junction jun11
                                       annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={440,20})));
  Fluid.Sensors.TemperatureTwoPort chiWatSupTem1
    "Chilled water supply temperature" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={200,60})));
  Fluid.Sensors.TemperatureTwoPort chiWatRet
    "Chilled water return temperature, after bypass" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={440,60})));
  Fluid.Sensors.TemperatureTwoPort chiWatRet1
    "Chilled water return temperature, before bypass" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={440,-20})));
  Fluid.Sensors.VolumeFlowRate senVolFlo annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={440,180})));
  Fluid.Sensors.TemperatureTwoPort conWatSupTem
    "Condenser water supply temperature, to the chiller condenser" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={260,520})));
  Fluid.Sensors.TemperatureTwoPort conWatRetTem
    "Condenser water supply temperature, from the chiller condenser"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={420,520})));
  Fluid.Sensors.RelativePressure senRelPre
    annotation (Placement(transformation(extent={{320,-90},{340,-70}})));
  Modelica.Fluid.Interfaces.FluidPort_a portCooCoiSup(redeclare package Medium =
        MediumW) "Cooling coil loop supply"
    annotation (Placement(transformation(extent={{190,-130},{210,-110}}),
        iconTransformation(extent={{110,-150},{130,-130}})));
  Modelica.Fluid.Interfaces.FluidPort_b portCooCoiRet(redeclare package Medium =
        MediumW)
    "Coolin coil loop return"
    annotation (Placement(transformation(extent={{430,-130},{450,-110}}),
        iconTransformation(extent={{170,-150},{190,-130}})));
  Fluid.FixedResistances.PressureDrop res annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={440,-60})));
  Fluid.Chillers.ElectricEIR chi1
    annotation (Placement(transformation(extent={{320,324},{340,344}})));
  Fluid.Chillers.ElectricEIR chi2
    annotation (Placement(transformation(extent={{320,234},{340,254}})));
  Fluid.Sensors.MassFlowRate senMasFlo "Chilled water flow rate" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={440,120})));
  Controls.OBC.CDL.Continuous.Feedback feedback
    "Chilled water supply and return temperature difference"
    annotation (Placement(transformation(extent={{470,90},{490,110}})));
  Controls.OBC.CDL.Continuous.Product curChiLoa "Current chiller cooling load"
    annotation (Placement(transformation(extent={{510,110},{530,130}})));
  Controls.OBC.CDL.Continuous.Switch chiWatSupTem[2]
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{20,270},{40,290}})));
  Controls.OBC.CDL.Routing.BooleanScalarReplicator reaChiDem(final nout=2)
    "Release chiller demand, normal true"
    annotation (Placement(transformation(extent={{-40,270},{-20,290}})));
  Controls.OBC.CDL.Continuous.Feedback demLimSupTem
    "Chilled water supply temperature setpoint, when chiller demand is limitted"
    annotation (Placement(transformation(extent={{-70,230},{-50,250}})));
  Controls.OBC.CDL.Continuous.Division div1 "Real inputs division"
    annotation (Placement(transformation(extent={{-110,210},{-90,230}})));
  Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(final nout=2)
    "Duplicate real input"
    annotation (Placement(transformation(extent={{-40,230},{-20,250}})));
  Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=1)
    "Limited total chiller load"
    annotation (Placement(transformation(extent={{-180,210},{-160,230}})));
  Controls.OBC.CDL.Continuous.Division div2[2]
    annotation (Placement(transformation(extent={{200,600},{220,620}})));
  Controls.OBC.CDL.Continuous.Sources.Constant con[2](k={cooTow1.PFan_nominal,
        cooTow2.PFan_nominal})
    annotation (Placement(transformation(extent={{140,540},{160,560}})));
  Modelica.Blocks.Sources.RealExpression towFanSpe(y={(div2[i].y)^(1/3) for i in
            1:2}) "Tower fan speed feedback"
    annotation (Placement(transformation(extent={{140,510},{160,530}})));
equation
  connect(jun3.port_1, cooTow1.port_b)
    annotation (Line(points={{260,560},{260,620},{320,620}},
                                                          color={0,127,255}));
  connect(jun3.port_3, cooTow2.port_b)
    annotation (Line(points={{270,550},{320,550}},
                                                 color={0,127,255}));
  connect(cooTow1.port_a, towIsoVal1.port_b)
    annotation (Line(points={{340,620},{370,620}}, color={0,127,255}));
  connect(cooTow2.port_a, towIsoVal2.port_b)
    annotation (Line(points={{340,550},{370,550}}, color={0,127,255}));
  connect(cwIsoVal2.port_b, jun4.port_1) annotation (Line(points={{390,250},{
          420,250},{420,330}},
                           color={0,127,255}));
  connect(cwIsoVal1.port_b, jun4.port_3)
    annotation (Line(points={{390,340},{410,340}}, color={0,127,255}));
  connect(jun5.port_2, towIsoVal1.port_a) annotation (Line(points={{420,560},{
          420,620},{390,620}}, color={0,127,255}));
  connect(jun5.port_3, towIsoVal2.port_a)
    annotation (Line(points={{410,550},{390,550}}, color={0,127,255}));
  connect(chwIsoVal1.port_b, jun7.port_1) annotation (Line(points={{230,310},{
          200,310},{200,230}},
                           color={0,127,255}));
  connect(jun7.port_3, chwIsoVal2.port_b)
    annotation (Line(points={{210,220},{230,220}}, color={0,127,255}));
  connect(jun7.port_2, jun8.port_1)
    annotation (Line(points={{200,210},{200,170}}, color={0,127,255}));
  connect(jun8.port_3,chiWatPum2. port_a)
    annotation (Line(points={{210,160},{260,160},{260,138}},
                                                           color={0,127,255}));
  connect(jun8.port_2,chiWatPum1. port_a)
    annotation (Line(points={{200,150},{200,138}}, color={0,127,255}));
  connect(chiWatPum1.port_b, jun9.port_1)
    annotation (Line(points={{200,118},{200,100}}, color={0,127,255}));
  connect(chiWatPum2.port_b, jun9.port_3)
    annotation (Line(points={{260,118},{260,90},{210,90}}, color={0,127,255}));
  connect(jun10.port_3, valByp.port_a)
    annotation (Line(points={{210,20},{320,20}},  color={0,127,255}));
  connect(valByp.port_b, jun11.port_3)
    annotation (Line(points={{340,20},{430,20}},   color={0,127,255}));
  connect(jun.port_1, jun2.port_2)
    annotation (Line(points={{260,350},{260,390}},
                                                 color={0,127,255}));
  connect(jun2.port_1, conWatPum2.port_b)
    annotation (Line(points={{260,410},{260,430}},
                                                 color={0,127,255}));
  connect(conWatPum2.port_a, jun1.port_2)
    annotation (Line(points={{260,450},{260,470}},
                                                 color={0,127,255}));
  connect(conWatPum1.port_b, jun2.port_3) annotation (Line(points={{200,430},{
          200,400},{250,400}},
                          color={0,127,255}));
  connect(conWatPum1.port_a, jun1.port_3) annotation (Line(points={{200,450},{
          200,480},{250,480}},
                          color={0,127,255}));
  connect(jun9.port_2, chiWatSupTem1.port_a)
    annotation (Line(points={{200,80},{200,70}},   color={0,127,255}));
  connect(chiWatSupTem1.port_b, jun10.port_1)
    annotation (Line(points={{200,50},{200,30}},  color={0,127,255}));
  connect(jun11.port_2, chiWatRet.port_a)
    annotation (Line(points={{440,30},{440,50}}, color={0,127,255}));
  connect(chiWatRet1.port_b, jun11.port_1)
    annotation (Line(points={{440,-10},{440,10}},color={0,127,255}));
  connect(senVolFlo.port_b, jun6.port_1)
    annotation (Line(points={{440,190},{440,210}}, color={0,127,255}));
  connect(jun1.port_1, conWatSupTem.port_b)
    annotation (Line(points={{260,490},{260,510}}, color={0,127,255}));
  connect(conWatSupTem.port_a, jun3.port_2)
    annotation (Line(points={{260,530},{260,540}}, color={0,127,255}));
  connect(jun4.port_2, conWatRetTem.port_a)
    annotation (Line(points={{420,350},{420,510}}, color={0,127,255}));
  connect(conWatRetTem.port_b, jun5.port_1)
    annotation (Line(points={{420,530},{420,540}}, color={0,127,255}));
  connect(jun10.port_2, portCooCoiSup)
    annotation (Line(points={{200,10},{200,-120}},color={0,127,255}));
  connect(chiWatRet1.port_a, res.port_b)
    annotation (Line(points={{440,-30},{440,-50}}, color={0,127,255}));
  connect(res.port_a, portCooCoiRet)
    annotation (Line(points={{440,-70},{440,-120}}, color={0,127,255}));
  connect(senRelPre.port_a, jun10.port_2) annotation (Line(points={{320,-80},{
          200,-80},{200,10}}, color={0,127,255}));
  connect(senRelPre.port_b, res.port_a) annotation (Line(points={{340,-80},{440,
          -80},{440,-70}}, color={0,127,255}));
  connect(jun.port_3, chi1.port_a1)
    annotation (Line(points={{270,340},{320,340}}, color={0,127,255}));
  connect(chi1.port_b1, cwIsoVal1.port_a)
    annotation (Line(points={{340,340},{370,340}}, color={0,127,255}));
  connect(jun.port_2, chi2.port_a1) annotation (Line(points={{260,330},{260,250},
          {320,250}}, color={0,127,255}));
  connect(chi2.port_b1, cwIsoVal2.port_a)
    annotation (Line(points={{340,250},{370,250}}, color={0,127,255}));
  connect(chwIsoVal1.port_a, chi1.port_b2) annotation (Line(points={{250,310},{
          300,310},{300,328},{320,328}}, color={0,127,255}));
  connect(chi1.port_a2, jun6.port_2) annotation (Line(points={{340,328},{360,
          328},{360,310},{440,310},{440,230}}, color={0,127,255}));
  connect(chwIsoVal2.port_a, chi2.port_b2) annotation (Line(points={{250,220},{
          300,220},{300,238},{320,238}}, color={0,127,255}));
  connect(chi2.port_a2, jun6.port_3) annotation (Line(points={{340,238},{360,
          238},{360,220},{430,220}}, color={0,127,255}));
  connect(chiWatRet.port_b, senMasFlo.port_a)
    annotation (Line(points={{440,70},{440,110}}, color={0,127,255}));
  connect(senMasFlo.port_b, senVolFlo.port_a)
    annotation (Line(points={{440,130},{440,170}}, color={0,127,255}));
  connect(chiWatRet.T, feedback.u1) annotation (Line(points={{429,60},{400,60},
          {400,100},{468,100}}, color={0,0,127}));
  connect(chiWatSupTem1.T, feedback.u2) annotation (Line(points={{211,60},{300,
          60},{300,80},{480,80},{480,88}}, color={0,0,127}));
  connect(senMasFlo.m_flow, curChiLoa.u1) annotation (Line(points={{429,120},{
          420,120},{420,140},{500,140},{500,126},{508,126}}, color={0,0,127}));
  connect(feedback.y, curChiLoa.u2) annotation (Line(points={{492,100},{500,100},
          {500,114},{508,114}}, color={0,0,127}));
  connect(reaChiDem.y, chiWatSupTem.u2)
    annotation (Line(points={{-18,280},{18,280}}, color={255,0,255}));
  connect(div1.y, demLimSupTem.u2)
    annotation (Line(points={{-88,220},{-60,220},{-60,228}}, color={0,0,127}));
  connect(demLimSupTem.y, reaScaRep.u)
    annotation (Line(points={{-48,240},{-42,240}}, color={0,0,127}));
  connect(reaScaRep.y, chiWatSupTem.u3) annotation (Line(points={{-18,240},{0,
          240},{0,272},{18,272}}, color={0,0,127}));
  connect(mulSum.y, div1.u1) annotation (Line(points={{-158,220},{-120,220},{
          -120,226},{-112,226}}, color={0,0,127}));
  connect(con.y, div2.u2) annotation (Line(points={{162,550},{180,550},{180,604},
          {198,604}}, color={0,0,127}));
  connect(cooTow1.PFan, div2[1].u1) annotation (Line(points={{319,628},{180,628},
          {180,616},{198,616}}, color={0,0,127}));
  connect(cooTow2.PFan, div2[2].u1) annotation (Line(points={{319,558},{300,558},
          {300,628},{180,628},{180,616},{198,616}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-580,-660},
            {580,660}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-580,-660},{580,660}})));
end PartialChillerPlant;
