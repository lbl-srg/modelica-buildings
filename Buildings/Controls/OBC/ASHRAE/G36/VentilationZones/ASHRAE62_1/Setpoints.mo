within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1;
block Setpoints
    "Specify zone minimum outdoor air and minimum airflow set points for compliance with ASHRAE standard 62.1"

  parameter Boolean have_winSen=false
    "True: the zone has window sensor";
  parameter Boolean have_occSen=false
    "True: the zone has occupancy sensor";
  parameter Boolean have_CO2Sen=false
    "True: the zone has CO2 sensor";
  parameter Boolean have_typTerUni=false
    "True: the zone has typical terminal units and CO2 sensor"
    annotation(Dialog(enable=have_CO2Sen and not have_SZVAV and not have_parFanPowUni));
  parameter Boolean have_parFanPowUni=false
    "True: the zone has parallel fan-powered terminal unit and CO2 sensor"
    annotation(Dialog(enable=have_CO2Sen and not have_SZVAV and not have_typTerUni));
  parameter Boolean have_SZVAV=false
    "True: it is single zone VAV AHU system with CO2 sensor"
    annotation(Dialog(enable=have_CO2Sen and not have_parFanPowUni and not have_typTerUni));

  parameter Boolean permit_occStandby=true
    "True: occupied-standby mode is permitted"
    annotation(Dialog(enable=have_occSen));
  parameter Real VAreBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design area component of the breathing zone outdoor airflow"
    annotation(Dialog(group="Design conditions"));
  parameter Real VPopBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design population component of the breathing zone outdoor airflow"
    annotation(Dialog(group="Design conditions"));
  parameter Real VMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone minimum airflow setpoint"
    annotation(Dialog(enable=not have_SZVAV, group="Design conditions"));
  parameter Real VCooMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")=0.025
    "Design zone cooling maximum airflow rate"
    annotation(Dialog(enable=have_CO2Sen and not have_SZVAV, group="Design conditions"));
  parameter Real zonDisEff_cool=1.0
    "Zone cooling air distribution effectiveness"
    annotation(Dialog(tab="Advanced", group="Distribution effectiveness"));
  parameter Real zonDisEff_heat=0.8
    "Zone heating air distribution effectiveness"
    annotation(Dialog(tab="Advanced", group="Distribution effectiveness"));
  parameter Real dTHys(
    final unit="K",
    final quantity="TemperatureDifference")=0.25
    "Temperature difference hysteresis below which the temperature difference will be seen as zero"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win if have_winSen
    "Window status, normally closed (true), when windows open, it becomes false"
    annotation (Placement(transformation(extent={{-340,210},{-300,250}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ if have_occSen
    "True: the zone is populated"
    annotation (Placement(transformation(extent={{-340,150},{-300,190}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-340,10},{-300,50}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2Set if have_CO2Sen
    "CO2 concentration setpoint, in PPM"
    annotation (Placement(transformation(extent={{-340,-40},{-300,0}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 concentration"
    annotation (Placement(transformation(extent={{-340,-80},{-300,-40}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta
    if have_CO2Sen and have_parFanPowUni
    "Zone state"
    annotation (Placement(transformation(extent={{-340,-240},{-300,-200}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VParFan_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    if have_CO2Sen and have_parFanPowUni
    "Parallel fan airflow rate"
    annotation (Placement(transformation(extent={{-340,-300},{-300,-260}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-340,-330},{-300,-290}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC") "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-340,-360},{-300,-320}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjPopBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Adjusted population component breathing zone flow rate"
    annotation (Placement(transformation(extent={{300,270},{340,310}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOccZonMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if not have_SZVAV
    "Occupied minimum airflow setpoint"
    annotation (Placement(transformation(extent={{300,210},{340,250}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VAdjAreBreZon_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Adjusted area component breathing zone flow rate"
    annotation (Placement(transformation(extent={{300,120},{340,160}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VMinOA_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{300,-10},{340,30}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal airDisEff(
    final realTrue=zonDisEff_cool,
    final realFalse=zonDisEff_heat)
    "Air distribution effectiveness"
    annotation (Placement(transformation(extent={{-180,-320},{-160,-300}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin if have_CO2Sen
    "CO2 control loop"
    annotation (Placement(transformation(extent={{-160,-70},{-140,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0) if have_CO2Sen "Constant zero"
    annotation (Placement(transformation(extent={{-280,-100},{-260,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(
    final k=1) if have_CO2Sen
    "Constant one"
    annotation (Placement(transformation(extent={{-220,-100},{-200,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=-200) if have_CO2Sen
    "Lower threshold of CO2 setpoint"
    annotation (Placement(transformation(extent={{-220,-50},{-200,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Equal inOccMod
    "Check if it is in occupied mode"
    annotation (Placement(transformation(extent={{-220,20},{-200,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea if have_CO2Sen
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply co2Con if have_CO2Sen
    "Corrected CO2 control loop output"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Line occMinAirSet if have_CO2Sen and not have_SZVAV
    "Modified occupied minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-20,-130},{0,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonMinFlo(
    final k=VMin_flow) if not have_SZVAV
    "Zone minimum airflow setpoint Vmin"
    annotation (Placement(transformation(extent={{-280,60},{-260,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonCooMaxFlo(
    final k=VCooMax_flow) if have_CO2Sen and not have_SZVAV
    "Maximum cooling airflow setpoint"
    annotation (Placement(transformation(extent={{-280,-160},{-260,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Line popBreOutAir if have_CO2Sen
    "Modified population componenet of the required breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-20,-190},{0,-170}})));
  Buildings.Controls.OBC.CDL.Integers.Equal inCooSta if have_CO2Sen and have_parFanPowUni
    "Check if it is in cooling state"
    annotation (Placement(transformation(extent={{-220,-230},{-200,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch maxFloCO2 if have_CO2Sen and have_parFanPowUni
    "Maximum airflow set point for CO2"
    annotation (Placement(transformation(extent={{-160,-230},{-140,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract difCooMax if have_CO2Sen and have_parFanPowUni
    "Maximum cooling airflw set point minus parallel fan airflow"
    annotation (Placement(transformation(extent={{-220,-270},{-200,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if it is not in occupied mode or the window is open"
    annotation (Placement(transformation(extent={{-20,220},{0,240}})));
  Buildings.Controls.OBC.CDL.Logical.Not notOccMod "Not in occupied mode"
    annotation (Placement(transformation(extent={{-80,200},{-60,220}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) if not have_winSen
    "Constant false"
    annotation (Placement(transformation(extent={{-80,240},{-60,260}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant perOccSta(
    final k=permit_occStandby) if have_occSen
    "Permit occupied-standby mode"
    annotation (Placement(transformation(extent={{-260,120},{-240,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-20,270},{0,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch modPopBreAir
    "Modified popuplation component of the breathing zone airflow"
    annotation (Placement(transformation(extent={{180,280},{200,300}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch modAreBreAir
    "Modified area component of the breathing zone airflow"
    annotation (Placement(transformation(extent={{140,250},{160,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch occMinAir if not
    have_SZVAV
    "Occupied minimum airflow setpoint"
    annotation (Placement(transformation(extent={{80,220},{100,240}})));
  Buildings.Controls.OBC.CDL.Logical.Not notOcc if have_occSen "Not occupied"
    annotation (Placement(transformation(extent={{-280,160},{-260,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch unpPopBreAir
    "Population component of the required breathing zone outdoor airflow when it is unpopulated"
    annotation (Placement(transformation(extent={{140,160},{160,180}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(
    final realTrue=0,
    final realFalse=1) if have_occSen
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-220,120},{-200,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply unPopAreBreAir if have_occSen
    "Area component of the required breathing zone outdoor airflow when it is unpopulated"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply unpMinZonFlo if have_occSen and not have_SZVAV
    "Minimum zone airflow when it is unpopulated"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch unpAreBreAir
    "Area component of the required breathing zone outdoor airflow when it is unpopulated"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch unpMinZonAir if not have_SZVAV
    "Minimum zone airflow when it is unpopulated"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false) if not have_occSen
    "Constant false"
    annotation (Placement(transformation(extent={{-40,180},{-20,200}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=1) if not have_CO2Sen and not have_SZVAV
    "Dummy gain for conditional input"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=1) if not have_CO2Sen
    "Dummy gain for conditional input"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add reqBreAir
    "Required breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{220,260},{240,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide minOA "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{260,0},{280,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-280,-10},{-260,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.cooling)
    if have_CO2Sen and have_parFanPowUni
    "Cooling state"
    annotation (Placement(transformation(extent={{-280,-250},{-260,-230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer2(
    final k=0) if not have_occSen
    "Constant zero"
    annotation (Placement(transformation(extent={{-80,140},{-60,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer3(
    final k=0) if not have_occSen or have_SZVAV
    "Constant zero"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater cooSup(
    final h=dTHys)
    "Check if it is supplying cooling"
    annotation (Placement(transformation(extent={{-220,-320},{-200,-300}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter  gai2(
    final k=1)
    if have_CO2Sen and not have_SZVAV and not have_parFanPowUni
    "Dummy gain for conditional input"
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desAreAir(
    final k=VAreBreZon_flow)
    "Design area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-180,250},{-160,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desPopAir(
    final k=VPopBreZon_flow)
    "Design population component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-180,290},{-160,310}})));
  CDL.Logical.Not winOpe if have_winSen "Window is open"
    annotation (Placement(transformation(extent={{-240,220},{-220,240}})));
equation
  connect(addPar.y, lin.x1) annotation (Line(points={{-198,-40},{-180,-40},{-180,
          -52},{-162,-52}}, color={0,0,127}));
  connect(zer.y, lin.f1) annotation (Line(points={{-258,-90},{-230,-90},{-230,-56},
          {-162,-56}},      color={0,0,127}));
  connect(ppmCO2, lin.u)
    annotation (Line(points={{-320,-60},{-162,-60}},color={0,0,127}));
  connect(one.y, lin.f2) annotation (Line(points={{-198,-90},{-180,-90},{-180,-68},
          {-162,-68}},     color={0,0,127}));
  connect(uOpeMod, inOccMod.u1)
    annotation (Line(points={{-320,30},{-222,30}}, color={255,127,0}));
  connect(occMod.y, inOccMod.u2) annotation (Line(points={{-258,0},{-240,0},{-240,
          22},{-222,22}},      color={255,127,0}));
  connect(inOccMod.y, booToRea.u)
    annotation (Line(points={{-198,30},{-162,30}},color={255,0,255}));
  connect(zer.y, occMinAirSet.x1) annotation (Line(points={{-258,-90},{-230,-90},
          {-230,-112},{-22,-112}}, color={0,0,127}));
  connect(zonMinFlo.y, occMinAirSet.f1) annotation (Line(points={{-258,70},{-250,
          70},{-250,-116},{-22,-116}}, color={0,0,127}));
  connect(one.y, occMinAirSet.x2) annotation (Line(points={{-198,-90},{-180,-90},
          {-180,-124},{-22,-124}}, color={0,0,127}));
  connect(co2Con.y, occMinAirSet.u) annotation (Line(points={{-58,-40},{-40,-40},
          {-40,-120},{-22,-120}}, color={0,0,127}));
  connect(zer.y, popBreOutAir.x1) annotation (Line(points={{-258,-90},{-230,-90},
          {-230,-172},{-22,-172}}, color={0,0,127}));
  connect(zer.y, popBreOutAir.f1) annotation (Line(points={{-258,-90},{-230,-90},
          {-230,-176},{-22,-176}}, color={0,0,127}));
  connect(one.y, popBreOutAir.x2) annotation (Line(points={{-198,-90},{-180,-90},
          {-180,-184},{-22,-184}}, color={0,0,127}));
  connect(co2Con.y, popBreOutAir.u) annotation (Line(points={{-58,-40},{-40,-40},
          {-40,-180},{-22,-180}}, color={0,0,127}));
  connect(uZonSta, inCooSta.u1) annotation (Line(points={{-320,-220},{-222,-220}},
                                    color={255,127,0}));
  connect(cooSta.y, inCooSta.u2) annotation (Line(points={{-258,-240},{-230,-240},
          {-230,-228},{-222,-228}}, color={255,127,0}));
  connect(inCooSta.y, maxFloCO2.u2)
    annotation (Line(points={{-198,-220},{-162,-220}},color={255,0,255}));
  connect(zonCooMaxFlo.y, maxFloCO2.u1) annotation (Line(points={{-258,-150},{-190,
          -150},{-190,-212},{-162,-212}}, color={0,0,127}));
  connect(zonCooMaxFlo.y, difCooMax.u1) annotation (Line(points={{-258,-150},{-240,
          -150},{-240,-254},{-222,-254}}, color={0,0,127}));
  connect(difCooMax.y, maxFloCO2.u3) annotation (Line(points={{-198,-260},{-190,
          -260},{-190,-228},{-162,-228}},color={0,0,127}));
  connect(maxFloCO2.y, occMinAirSet.f2) annotation (Line(points={{-138,-220},{-60,
          -220},{-60,-128},{-22,-128}},  color={0,0,127}));
  connect(lin.y, co2Con.u2) annotation (Line(points={{-138,-60},{-120,-60},{-120,
          -46},{-82,-46}}, color={0,0,127}));
  connect(booToRea.y, co2Con.u1) annotation (Line(points={{-138,30},{-120,30},{-120,
          -34},{-82,-34}}, color={0,0,127}));
  connect(inOccMod.y, notOccMod.u) annotation (Line(points={{-198,30},{-180,30},
          {-180,210},{-82,210}}, color={255,0,255}));
  connect(notOccMod.y, or2.u2) annotation (Line(points={{-58,210},{-40,210},{-40,
          222},{-22,222}}, color={255,0,255}));
  connect(con.y, or2.u1) annotation (Line(points={{-58,250},{-40,250},{-40,230},
          {-22,230}}, color={255,0,255}));
  connect(zer1.y, modPopBreAir.u1) annotation (Line(points={{2,280},{30,280},{30,
          298},{178,298}}, color={0,0,127}));
  connect(or2.y, modPopBreAir.u2) annotation (Line(points={{2,230},{40,230},{40,
          290},{178,290}}, color={255,0,255}));
  connect(or2.y, modAreBreAir.u2) annotation (Line(points={{2,230},{40,230},{40,
          260},{138,260}}, color={255,0,255}));
  connect(zer1.y, modAreBreAir.u1) annotation (Line(points={{2,280},{30,280},{30,
          268},{138,268}}, color={0,0,127}));
  connect(or2.y, occMinAir.u2)
    annotation (Line(points={{2,230},{78,230}}, color={255,0,255}));
  connect(zer1.y, occMinAir.u1) annotation (Line(points={{2,280},{30,280},{30,238},
          {78,238}}, color={0,0,127}));
  connect(u1Occ, notOcc.u)
    annotation (Line(points={{-320,170},{-282,170}}, color={255,0,255}));
  connect(perOccSta.y, booToRea1.u)
    annotation (Line(points={{-238,130},{-222,130}}, color={255,0,255}));
  connect(booToRea1.y, unPopAreBreAir.u2) annotation (Line(points={{-198,130},{-160,
          130},{-160,104},{-82,104}}, color={0,0,127}));
  connect(booToRea1.y, unpMinZonFlo.u1) annotation (Line(points={{-198,130},{-160,
          130},{-160,76},{-82,76}}, color={0,0,127}));
  connect(zonMinFlo.y, unpMinZonFlo.u2) annotation (Line(points={{-258,70},{-250,
          70},{-250,64},{-82,64}}, color={0,0,127}));
  connect(notOcc.y, unpPopBreAir.u2)
    annotation (Line(points={{-258,170},{138,170}}, color={255,0,255}));
  connect(zer1.y, unpPopBreAir.u1) annotation (Line(points={{2,280},{30,280},{30,
          178},{138,178}}, color={0,0,127}));
  connect(notOcc.y, unpAreBreAir.u2) annotation (Line(points={{-258,170},{0,170},
          {0,140},{78,140}}, color={255,0,255}));
  connect(unPopAreBreAir.y, unpAreBreAir.u1) annotation (Line(points={{-58,110},
          {-40,110},{-40,148},{78,148}}, color={0,0,127}));
  connect(notOcc.y, unpMinZonAir.u2) annotation (Line(points={{-258,170},{0,170},
          {0,110},{18,110}}, color={255,0,255}));
  connect(unpMinZonFlo.y, unpMinZonAir.u1) annotation (Line(points={{-58,70},{-20,
          70},{-20,118},{18,118}}, color={0,0,127}));
  connect(unpPopBreAir.y, modPopBreAir.u3) annotation (Line(points={{162,170},{170,
          170},{170,282},{178,282}}, color={0,0,127}));
  connect(unpAreBreAir.y, modAreBreAir.u3) annotation (Line(points={{102,140},{120,
          140},{120,252},{138,252}}, color={0,0,127}));
  connect(unpMinZonAir.y, occMinAir.u3) annotation (Line(points={{42,110},{48,110},
          {48,222},{78,222}}, color={0,0,127}));
  connect(occMinAirSet.y, unpMinZonAir.u3) annotation (Line(points={{2,-120},{10,
          -120},{10,102},{18,102}}, color={0,0,127}));
  connect(popBreOutAir.y, unpPopBreAir.u3) annotation (Line(points={{2,-180},{130,
          -180},{130,162},{138,162}}, color={0,0,127}));
  connect(con1.y, unpPopBreAir.u2) annotation (Line(points={{-18,190},{0,190},{0,
          170},{138,170}}, color={255,0,255}));
  connect(con1.y, unpAreBreAir.u2) annotation (Line(points={{-18,190},{0,190},{0,
          140},{78,140}}, color={255,0,255}));
  connect(con1.y, unpMinZonAir.u2) annotation (Line(points={{-18,190},{0,190},{0,
          110},{18,110}}, color={255,0,255}));
  connect(zonMinFlo.y, gai.u) annotation (Line(points={{-258,70},{-250,70},{-250,
          -10},{-42,-10}}, color={0,0,127}));
  connect(gai.y, unpMinZonAir.u3) annotation (Line(points={{-18,-10},{10,-10},{10,
          102},{18,102}}, color={0,0,127}));
  connect(gai1.y, unpPopBreAir.u3) annotation (Line(points={{102,90},{130,90},{130,
          162},{138,162}}, color={0,0,127}));
  connect(modAreBreAir.y, reqBreAir.u2) annotation (Line(points={{162,260},{212,
          260},{212,264},{218,264}}, color={0,0,127}));
  connect(modPopBreAir.y, reqBreAir.u1) annotation (Line(points={{202,290},{210,
          290},{210,276},{218,276}}, color={0,0,127}));
  connect(reqBreAir.y, minOA.u1) annotation (Line(points={{242,270},{250,270},{250,
          16},{258,16}}, color={0,0,127}));
  connect(airDisEff.y, minOA.u2) annotation (Line(points={{-158,-310},{250,-310},
          {250,4},{258,4}},   color={0,0,127}));
  connect(occMinAir.y, VOccZonMin_flow)
    annotation (Line(points={{102,230},{320,230}}, color={0,0,127}));
  connect(minOA.y, VMinOA_flow)
    annotation (Line(points={{282,10},{320,10}}, color={0,0,127}));
  connect(zer2.y, unpAreBreAir.u1) annotation (Line(points={{-58,150},{-40,150},
          {-40,148},{78,148}}, color={0,0,127}));
  connect(zer3.y, unpMinZonAir.u1) annotation (Line(points={{-58,30},{-20,30},{-20,
          118},{18,118}}, color={0,0,127}));
  connect(TZon, cooSup.u1)
    annotation (Line(points={{-320,-310},{-222,-310}}, color={0,0,127}));
  connect(TDis, cooSup.u2) annotation (Line(points={{-320,-340},{-240,-340},{-240,
          -318},{-222,-318}}, color={0,0,127}));
  connect(cooSup.y, airDisEff.u)
    annotation (Line(points={{-198,-310},{-182,-310}}, color={255,0,255}));
  connect(VParFan_flow, difCooMax.u2) annotation (Line(points={{-320,-280},{-240,
          -280},{-240,-266},{-222,-266}}, color={0,0,127}));
  connect(zonCooMaxFlo.y, gai2.u)
    annotation (Line(points={{-258,-150},{-162,-150}}, color={0,0,127}));
  connect(gai2.y, occMinAirSet.f2) annotation (Line(points={{-138,-150},{-60,-150},
          {-60,-128},{-22,-128}}, color={0,0,127}));
  connect(ppmCO2Set, addPar.u) annotation (Line(points={{-320,-20},{-240,-20},{-240,
          -40},{-222,-40}}, color={0,0,127}));
  connect(ppmCO2Set, lin.x2) annotation (Line(points={{-320,-20},{-240,-20},{-240,
          -64},{-162,-64}}, color={0,0,127}));
  connect(modAreBreAir.y, VAdjAreBreZon_flow) annotation (Line(points={{162,260},
          {212,260},{212,140},{320,140}}, color={0,0,127}));
  connect(modPopBreAir.y, VAdjPopBreZon_flow)
    annotation (Line(points={{202,290},{320,290}}, color={0,0,127}));
  connect(desAreAir.y, unpAreBreAir.u3) annotation (Line(points={{-158,260},{-140,
          260},{-140,132},{78,132}}, color={0,0,127}));
  connect(desAreAir.y, unPopAreBreAir.u1) annotation (Line(points={{-158,260},{-140,
          260},{-140,116},{-82,116}}, color={0,0,127}));
  connect(desPopAir.y, gai1.u) annotation (Line(points={{-158,300},{-100,300},{-100,
          90},{78,90}}, color={0,0,127}));
  connect(desPopAir.y, popBreOutAir.f2) annotation (Line(points={{-158,300},{-100,
          300},{-100,-188},{-22,-188}}, color={0,0,127}));
  connect(u1Win, winOpe.u)
    annotation (Line(points={{-320,230},{-242,230}}, color={255,0,255}));
  connect(winOpe.y, or2.u1)
    annotation (Line(points={{-218,230},{-22,230}}, color={255,0,255}));
annotation (defaultComponentName="minFlo",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textColor={0,0,255},
          textString="%name"),
        Line(points={{-60,62},{-60,-50},{60,-50}}, color={95,95,95}),
    Line(points={{-36,-62},{26,-62}}, color={95,95,95}),
    Polygon(
      points={{28,-62},{6,-56},{6,-68},{28,-62}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
        Line(points={{60,-50},{60,62}}, color={95,95,95}),
        Line(
          points={{-60,-50},{60,40}},
          color={28,108,200},
          pattern=LinePattern.Dash),
        Line(
          points={{-60,-30},{60,60}},
          color={28,108,200},
          thickness=0.5),
        Text(
          visible=have_winSen,
          extent={{-98,96},{-78,84}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWin"),
        Text(
          visible=have_occSen,
          extent={{-100,76},{-74,66}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{-98,56},{-62,44}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          visible=have_CO2Sen,
          extent={{-100,16},{-62,6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2"),
        Text(
          visible=have_CO2Sen and have_parFanPowUni,
          extent={{-98,-4},{-64,-16}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uZonSta"),
        Text(
          visible=have_CO2Sen and have_parFanPowUni,
          extent={{-98,-32},{-48,-48}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VParFan_flow"),
        Text(
          extent={{-100,-64},{-76,-74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-100,-82},{-80,-92}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          visible=not have_SZVAV,
          extent={{48,48},{98,32}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOccZonMin_flow"),
        Text(
          extent={{54,-32},{98,-46}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinOA_flow"),
        Text(
          extent={{-98,16},{-70,6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2",
          visible=have_CO2Sen),
        Text(
          extent={{-98,38},{-62,24}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2Set",
          visible=have_CO2Sen),
        Text(
          extent={{52,90},{96,76}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjPopBreZon_flow"),
        Text(
          extent={{54,8},{98,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VAdjAreBreZon_flow")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,-360},{300,360}})),
  Documentation(info="<html>
<p>
This sequence sets the zone minimum outdoor air and minimum airflow setpoints, for
compliance with the ventilation rate procedure of ASHRAE Standard 62.1. The
implementation is according to ASHRAE Guideline36, Section 5.2.1.3. The calculation
is done following the steps below.
</p>
<p>
1. For every zone that requires mechanical ventilation, the zone minimum outdoor airflows
and set points shall be calculated depending on the governing standard or code for
outdoor air requirements.
</p>
<p>
2. According to section 3.1.2 of Guideline 36, the zone minimum airflow setpoint
<code>VMin_flow</code> should be provided by designer.
</p>
<h4>Zone ventilation set points</h4>
<p>
According to Section 3.1.1.2 of Guideline 36, 
</p>
<ul>
<li>
The area component of the breathing zone outdoor airflow
<code>VAreBreZon_flow</code>..
</li>
<li>
The population component of the breathing zone outdoor airflow
<code>VPopBreZon_flow</code>.
</li>
</ul>
<h4>Zone air distribution effectiveness</h4>
<ul>
<li>
If the discharge air temperature <code>TDis</code> at the terminal unit is less than
or equal to zone space temperature <code>TZon</code>, the effectiveness should be
the zone cooling air distribution effectiveness <code>zonDisEff_cool</code> and defaults
it to 1.0 if no value is scheduled.
</li>
<li>
If the discharge air temperature <code>TDis</code> at the terminal unit is greater than
zone space temperature <code>TZon</code>, the effectiveness should be
the zone heating air distribution effectiveness <code>zonDisEff_heat</code> and defaults
it to 0.8 if no value is scheduled.
</li>
</ul>
<h4>Population component of the breathing zone outdoor airflow</h4>
<p>
The population component of the breathing zone outdoor airflow should normally equal
to the value calculated above. However, it would be modified as noted in below.
</p>
<h4>Occupied minimum airflow</h4>
<p>
The occupied minimum airflow shall be equal to <code>VMin_flow</code> except as
noted in below.
</p>
<h4>Set points modification</h4>
<p>
The required zone outdoor airflow shall be calculated as the sum of area and population
components of breathing zone outdoor airflow divided by air distribution effectiveness.
The normal value of the area and population components are modified if any of the
following conditions are met, in order from higher to lower priority:
</p>
<ol>
<li>
If the zone is any mode other than occupied mode, and for zones that have window
switches and the window is open: the area and population components of breathing
zone outdoor airflow, and the occupied minimum airflow rate should be zero.
</li>
<li>
If the zone has an occupancy sensor, is unpopulated, and occupied-standby mode is
permitted: the area and population components of breathing zone outdoor airflow,
and the occupied minimum airflow rate should be zero.
</li>
<li>
Else, if the zone has an occupancy sensor, is unpopulated, but occupied-standby mode
is not permitted: the population components of breathing zone outdoor airflow
should be zero and the occupied minimum airflow rate should be <code>VMin_flow</code>.
</li>
<li>
If the zone has a CO2 sensor:
<ol type=\"i\">
<li>
Specify CO2 setpoint <code>ppmCO2Set</code> according to Section 3.1.1.3 of Guideline 36.
</li>
<li>
During occupied mode, a P-only loop shall maintain CO2 concentration at setpoint;
reset from 0% at set point minus 200 PPM and to 100% at setpoint.
</li>
<li>
Loop is disabled and output set to zero when the zone is not in occupied mode.
</li>
<li>
For cooling-only VAV terminal units, reheat VAV terminal units, constant-volume series
fan-powered terminal units, dual-duct VAV terminal units with mixing control and inlet
airflow sensors, dual-duct VAV terminal units with mixing control and a discharge
airflow sensor, or dual-duct VAV terminal units with cold-duct minimum control:
<ul>
<li>
The CO2 control loop output shall reset both the occupied minimum airflow setpoint
and the population component of the required breathing zone outdoor airflow in parallel.
The occupied minimum airflow setpoint shall be reset from the zone minimum airflow
setpoint <code>VMin_flow</code> at 0% loop output up to maximum cooling airflow
setpoint <code>VCooMax_flow</code> at 100% loop output. The population component
of breathing zone outdoor airflow shall be reset from 0 L/s at 0% loop output up to
the designed population component airflow setpoint at 100% loop output.
</li>
</ul>
<p align=\"center\">
<img alt=\"Image of airflow setpoint for VAV reheat terminal unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/VentilationZones/ASHRAE61_1/setpoints_reheat.png\"/>
</p>
</li>
<li>
For parallel fan-powered terminal units:
<ul>
<li>
Determin the maximum flow rate for control CO2 level: when the zone state is cooling,
the maximum flow rate is equal to the maximum cooling airflow setpoint
<code>VCooMax_flow</code>; when the zone state is heating or deadband, the maximum
flow rate is equal to <code>VCooMax_flow</code> minus the parallel fan airflow
<code>VParFan_flow</code>.
</li>
<li>
The occupied minimum airflow setpoint shall be reset from the zone minimum airflow
setpoint <code>VMin_flow</code> at 0% loop output up to maximum cooling airflow
setpoint determined by CO2 control level at 100% loop output. The population component
of breathing zone outdoor airflow shall be reset from 0 L/s at 0% loop output up to
the designed population component airflow setpoint at 100% loop output.
</li>
</ul>
<p align=\"center\">
<img alt=\"Image of airflow setpoint for VAV parallel-fan terminal unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/VentilationZones/ASHRAE61_1/setpoints_parallelFan.png\"/>
</p>
</li>
</ol>
</li>
<li>
For single zoneVAV air handler unit: the minimum outdoor air setpoint is equal to
the breathing zone outdoor airflow setpoint.
<ul>
<li>
If the zone has CO2 sensor, the CO2 control loop output shall reset
the population component of the required breathing zone outdoor airflow from 0 L/s
at 0% loop output up to the designed population component airflow setpoint at
100% loop output.
<p align=\"center\">
<img alt=\"Image of airflow setpoint for single zone VAV AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/VentilationZones/ASHRAE61_1/setpoints_SZVAV.png\"/>
</p>
</li>
<li>
If the zone dose not have CO2 sensor, the minimum outdoor air setpoint is equal to
the design breathing zone outdoor airflow setpoint.
</li>
</ul>

</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 12, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Setpoints;
