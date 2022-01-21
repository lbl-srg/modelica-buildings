within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1;
block Setpoints "Specify zone minimum outdoor air and minimum airflow set points"

  parameter Boolean have_winSen=false
    "True: the zone has window sensor";
  parameter Boolean have_occSen=false
    "True: the zone has occupancy sensor";
  parameter Boolean have_CO2Sen=false
    "True: the zone has CO2 sensor";
  parameter Boolean have_typTerUniWitCO2=false
    "True: the zone has typical terminal units and CO2 sensor"
    annotation(Dialog(enable=have_CO2Sen and (not have_SZVAVWitCO2 and not have_parFanPowUniWitCO2)));
  parameter Boolean have_parFanPowUniWitCO2=false
    "True: the zone has parallel fan-powered terminal unit and CO2 sensor"
    annotation(Dialog(enable=have_CO2Sen and (not have_SZVAVWitCO2 and not have_typTerUniWitCO2)));
  parameter Boolean have_SZVAVWitCO2=false
    "True: it is single zone VAV AHU system with CO2 sensor"
    annotation(Dialog(enable=have_CO2Sen and (not have_parFanPowUniWitCO2 and not have_typTerUniWitCO2)));

  parameter Boolean permit_occStandby=true
    "True: occupied-standby mode is permitted";
  parameter Real AFlo(
    final quantity="Area",
    final unit="m2")
    "Zone floor area"
    annotation(Dialog(group="Design conditions"));
  parameter Real desZonPop
    "Design zone population"
    annotation(Dialog(group="Design conditions"));
  parameter Real outAirRat_area=0.0003
    "Outdoor airflow rate per unit area, m3/s/m2"
    annotation(Dialog(group="Design conditions"));
  parameter Real outAirRat_occupant=0.0025
    "Outdoor airflow rate per occupant, m3/s/p"
    annotation(Dialog(group="Design conditions"));
  parameter Real VZonMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone minimum airflow setpoint"
    annotation(Dialog(enable=not have_SZVAVWitCO2, group="Design conditions"));
  parameter Real VCooZonMax_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Design zone cooling maximum airflow rate"
    annotation(Dialog(enable=have_CO2Sen and not have_SZVAVWitCO2, group="Design conditions"));
  parameter Real CO2Set=894
    "CO2 concentration setpoint, ppm"
    annotation(Dialog(enable=have_CO2Sen, group="Design conditions"));
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

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-340,200},{-300,240}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uOcc if have_occSen
    "Occupancy status, true if it is occupied, false if it is not occupied"
    annotation (Placement(transformation(extent={{-340,140},{-300,180}}),
        iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-340,0},{-300,40}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 concentration"
    annotation (Placement(transformation(extent={{-340,-90},{-300,-50}}),
        iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta if
       have_CO2Sen and have_parFanPowUniWitCO2
    "Zone state"
    annotation (Placement(transformation(extent={{-340,-220},{-300,-180}}),
        iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VParFan_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if
       have_CO2Sen and have_parFanPowUniWitCO2
    "Parallel fan airflow rate"
    annotation (Placement(transformation(extent={{-340,-270},{-300,-230}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Measured room temperature"
    annotation (Placement(transformation(extent={{-340,-310},{-300,-270}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC") "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-340,-340},{-300,-300}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOccZonMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if not have_SZVAVWitCO2
    "Occupied minimum airflow setpoint"
    annotation (Placement(transformation(extent={{300,200},{340,240}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VMinOA_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{300,-20},{340,20}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal airDisEff(
    final realTrue=zonDisEff_cool,
    final realFalse=zonDisEff_heat)
    "Air distribution effectiveness"
    annotation (Placement(transformation(extent={{-180,-300},{-160,-280}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin if have_CO2Sen
    "CO2 control loop"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0) if have_CO2Sen
    "Constant zero"
    annotation (Placement(transformation(extent={{-280,-110},{-260,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(
    final k=1) if have_CO2Sen
    "Constant one"
    annotation (Placement(transformation(extent={{-220,-110},{-200,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant co2Set(
    final k=CO2Set) if have_CO2Sen
    "CO2 setpoint"
    annotation (Placement(transformation(extent={{-280,-60},{-260,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=-200,
    final k=1) if have_CO2Sen
    "Lower threshold of CO2 setpoint"
    annotation (Placement(transformation(extent={{-220,-60},{-200,-40}})));
  Buildings.Controls.OBC.CDL.Integers.Equal inOccMod
    "Check if it is in occupied mode"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea if have_CO2Sen
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Product co2Con if have_CO2Sen
    "Corrected CO2 control loop output"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Line occMinAirSet if have_CO2Sen and not have_SZVAVWitCO2
    "Modified occupied minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-20,-140},{0,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonMinFlo(
    final k=VZonMin_flow) if not have_SZVAVWitCO2
    "Zone minimum airflow setpoint Vmin"
    annotation (Placement(transformation(extent={{-280,50},{-260,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonCooMaxFlo(
    final k=VCooZonMax_flow) if have_CO2Sen and not have_SZVAVWitCO2
    "Maximum cooling airflow setpoint"
    annotation (Placement(transformation(extent={{-280,-160},{-260,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Line popBreOutAir if have_CO2Sen
    "Modified population componenet of the required breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));
  Buildings.Controls.OBC.CDL.Integers.Equal inCooSta if have_CO2Sen and have_parFanPowUniWitCO2
    "Check if it is in cooling state"
    annotation (Placement(transformation(extent={{-220,-210},{-200,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch maxFloCO2 if have_CO2Sen and have_parFanPowUniWitCO2
    "Maximum airflow set point for CO2"
    annotation (Placement(transformation(extent={{-160,-210},{-140,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback difCooMax if have_CO2Sen and have_parFanPowUniWitCO2
    "Maximum cooling airflw set point minus parallel fan airflow"
    annotation (Placement(transformation(extent={{-220,-240},{-200,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonAre(
    final k=AFlo) "Zone area"
    annotation (Placement(transformation(extent={{-280,310},{-260,330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant areAirRat(
    final k=outAirRat_area)
    "Outdoor airflow rate per unit area"
    annotation (Placement(transformation(extent={{-240,290},{-220,310}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonPop(
    final k=desZonPop)
    "Design zone population"
    annotation (Placement(transformation(extent={{-280,260},{-260,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant occAirRat(
    final k=outAirRat_occupant)
    "Outdoor airflow rate per occupant"
    annotation (Placement(transformation(extent={{-240,240},{-220,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Product desPopAir
    "Design population component outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-180,250},{-160,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Product desAreAir
    "Area component outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{-180,300},{-160,320}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if it is not in occupied mode or the window is open"
    annotation (Placement(transformation(extent={{-20,210},{0,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not notOccMod "Not in occupied mode"
    annotation (Placement(transformation(extent={{-80,190},{-60,210}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) if not have_winSen
    "Constant false"
    annotation (Placement(transformation(extent={{-80,230},{-60,250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant perOccSta(
    final k=permit_occStandby) if have_occSen
    "Permit occupied-standby mode"
    annotation (Placement(transformation(extent={{-260,110},{-240,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-20,260},{0,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch modPopBreAir
    "Modified popuplation component of the breathing zone airflow"
    annotation (Placement(transformation(extent={{180,270},{200,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch modAreBreAir
    "Modified area component of the breathing zone airflow"
    annotation (Placement(transformation(extent={{140,240},{160,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch occMinAir if not have_SZVAVWitCO2
    "Occupied minimum airflow setpoint"
    annotation (Placement(transformation(extent={{80,210},{100,230}})));
  Buildings.Controls.OBC.CDL.Logical.Not notOcc if have_occSen
    "Not occupied"
    annotation (Placement(transformation(extent={{-280,150},{-260,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch unpPopBreAir
    "Population component of the required breathing zone outdoor airflow when it is unpopulated"
    annotation (Placement(transformation(extent={{140,150},{160,170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(
    final realTrue=0,
    final realFalse=1) if have_occSen
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-220,110},{-200,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Product unPopAreBreAir if have_occSen
    "Area component of the required breathing zone outdoor airflow when it is unpopulated"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Product unpMinZonFlo if have_occSen and not have_SZVAVWitCO2
    "Minimum zone airflow when it is unpopulated"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch unpAreBreAir
    "Area component of the required breathing zone outdoor airflow when it is unpopulated"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch unpMinZonAir if not have_SZVAVWitCO2
    "Minimum zone airflow when it is unpopulated"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false) if not have_occSen
    "Constant false"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(
    final k=1) if not have_CO2Sen and not have_SZVAVWitCO2
    "Dummy gain for conditional input"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(
    final k=1) if not have_CO2Sen
    "Dummy gain for conditional input"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Add reqBreAir "Required breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{220,250},{240,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Division minOA "Minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{260,-10},{280,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-280,-20},{-260,0}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.cooling) if
    have_CO2Sen and have_parFanPowUniWitCO2
    "Cooling state"
    annotation (Placement(transformation(extent={{-280,-230},{-260,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer2(
    final k=0) if not have_occSen
    "Constant zero"
    annotation (Placement(transformation(extent={{-80,130},{-60,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer3(
    final k=0) if not have_occSen or have_SZVAVWitCO2
    "Constant zero"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater cooSup(
    final h=dTHys)
    "Check if it is supplying cooling"
    annotation (Placement(transformation(extent={{-220,-300},{-200,-280}})));

equation
  connect(co2Set.y, addPar.u)
    annotation (Line(points={{-258,-50},{-222,-50}}, color={0,0,127}));
  connect(addPar.y, lin.x1) annotation (Line(points={{-198,-50},{-180,-50},{-180,
          -62},{-162,-62}}, color={0,0,127}));
  connect(zer.y, lin.f1) annotation (Line(points={{-258,-100},{-230,-100},{-230,
          -66},{-162,-66}}, color={0,0,127}));
  connect(ppmCO2, lin.u)
    annotation (Line(points={{-320,-70},{-162,-70}},color={0,0,127}));
  connect(co2Set.y, lin.x2) annotation (Line(points={{-258,-50},{-240,-50},{-240,
          -74},{-162,-74}}, color={0,0,127}));
  connect(one.y, lin.f2) annotation (Line(points={{-198,-100},{-180,-100},{-180,
          -78},{-162,-78}},color={0,0,127}));
  connect(uOpeMod, inOccMod.u1)
    annotation (Line(points={{-320,20},{-222,20}}, color={255,127,0}));
  connect(occMod.y, inOccMod.u2) annotation (Line(points={{-258,-10},{-240,-10},
          {-240,12},{-222,12}},color={255,127,0}));
  connect(inOccMod.y, booToRea.u)
    annotation (Line(points={{-198,20},{-162,20}},color={255,0,255}));
  connect(zer.y, occMinAirSet.x1) annotation (Line(points={{-258,-100},{-230,-100},
          {-230,-122},{-22,-122}}, color={0,0,127}));
  connect(zonMinFlo.y, occMinAirSet.f1) annotation (Line(points={{-258,60},{-250,
          60},{-250,-126},{-22,-126}}, color={0,0,127}));
  connect(one.y, occMinAirSet.x2) annotation (Line(points={{-198,-100},{-180,-100},
          {-180,-134},{-22,-134}}, color={0,0,127}));
  connect(zonCooMaxFlo.y, occMinAirSet.f2) annotation (Line(points={{-258,-150},
          {-120,-150},{-120,-138},{-22,-138}}, color={0,0,127}));
  connect(co2Con.y, occMinAirSet.u) annotation (Line(points={{-58,-50},{-40,-50},
          {-40,-130},{-22,-130}}, color={0,0,127}));
  connect(zer.y, popBreOutAir.x1) annotation (Line(points={{-258,-100},{-230,-100},
          {-230,-162},{-22,-162}}, color={0,0,127}));
  connect(zer.y, popBreOutAir.f1) annotation (Line(points={{-258,-100},{-230,-100},
          {-230,-166},{-22,-166}}, color={0,0,127}));
  connect(one.y, popBreOutAir.x2) annotation (Line(points={{-198,-100},{-180,-100},
          {-180,-174},{-22,-174}}, color={0,0,127}));
  connect(co2Con.y, popBreOutAir.u) annotation (Line(points={{-58,-50},{-40,-50},
          {-40,-170},{-22,-170}}, color={0,0,127}));
  connect(uZonSta, inCooSta.u1) annotation (Line(points={{-320,-200},{-222,-200}},
                                    color={255,127,0}));
  connect(cooSta.y, inCooSta.u2) annotation (Line(points={{-258,-220},{-230,-220},
          {-230,-208},{-222,-208}}, color={255,127,0}));
  connect(inCooSta.y, maxFloCO2.u2)
    annotation (Line(points={{-198,-200},{-162,-200}},color={255,0,255}));
  connect(zonCooMaxFlo.y, maxFloCO2.u1) annotation (Line(points={{-258,-150},{-190,
          -150},{-190,-192},{-162,-192}}, color={0,0,127}));
  connect(zonCooMaxFlo.y, difCooMax.u1) annotation (Line(points={{-258,-150},{-240,
          -150},{-240,-230},{-222,-230}}, color={0,0,127}));
  connect(VParFan_flow, difCooMax.u2) annotation (Line(points={{-320,-250},{-210,
          -250},{-210,-242}},      color={0,0,127}));
  connect(difCooMax.y, maxFloCO2.u3) annotation (Line(points={{-198,-230},{-190,
          -230},{-190,-208},{-162,-208}},color={0,0,127}));
  connect(maxFloCO2.y, occMinAirSet.f2) annotation (Line(points={{-138,-200},{-120,
          -200},{-120,-138},{-22,-138}}, color={0,0,127}));
  connect(areAirRat.y, desAreAir.u2) annotation (Line(points={{-218,300},{-200,300},
          {-200,304},{-182,304}}, color={0,0,127}));
  connect(zonAre.y, desAreAir.u1) annotation (Line(points={{-258,320},{-200,320},
          {-200,316},{-182,316}}, color={0,0,127}));
  connect(zonPop.y, desPopAir.u1) annotation (Line(points={{-258,270},{-200,270},
          {-200,266},{-182,266}}, color={0,0,127}));
  connect(occAirRat.y, desPopAir.u2) annotation (Line(points={{-218,250},{-200,250},
          {-200,254},{-182,254}}, color={0,0,127}));
  connect(desPopAir.y, popBreOutAir.f2) annotation (Line(points={{-158,260},{-100,
          260},{-100,-178},{-22,-178}}, color={0,0,127}));
  connect(lin.y, co2Con.u2) annotation (Line(points={{-138,-70},{-120,-70},{-120,
          -56},{-82,-56}}, color={0,0,127}));
  connect(booToRea.y, co2Con.u1) annotation (Line(points={{-138,20},{-120,20},{-120,
          -44},{-82,-44}}, color={0,0,127}));
  connect(uWin, or2.u1)
    annotation (Line(points={{-320,220},{-22,220}}, color={255,0,255}));
  connect(inOccMod.y, notOccMod.u) annotation (Line(points={{-198,20},{-180,20},
          {-180,200},{-82,200}}, color={255,0,255}));
  connect(notOccMod.y, or2.u2) annotation (Line(points={{-58,200},{-40,200},{-40,
          212},{-22,212}}, color={255,0,255}));
  connect(con.y, or2.u1) annotation (Line(points={{-58,240},{-40,240},{-40,220},
          {-22,220}}, color={255,0,255}));
  connect(zer1.y, modPopBreAir.u1) annotation (Line(points={{2,270},{30,270},{30,
          288},{178,288}}, color={0,0,127}));
  connect(or2.y, modPopBreAir.u2) annotation (Line(points={{2,220},{40,220},{40,
          280},{178,280}}, color={255,0,255}));
  connect(or2.y, modAreBreAir.u2) annotation (Line(points={{2,220},{40,220},{40,
          250},{138,250}}, color={255,0,255}));
  connect(zer1.y, modAreBreAir.u1) annotation (Line(points={{2,270},{30,270},{30,
          258},{138,258}}, color={0,0,127}));
  connect(or2.y, occMinAir.u2)
    annotation (Line(points={{2,220},{78,220}}, color={255,0,255}));
  connect(zer1.y, occMinAir.u1) annotation (Line(points={{2,270},{30,270},{30,228},
          {78,228}}, color={0,0,127}));
  connect(uOcc, notOcc.u)
    annotation (Line(points={{-320,160},{-282,160}}, color={255,0,255}));
  connect(perOccSta.y, booToRea1.u)
    annotation (Line(points={{-238,120},{-222,120}}, color={255,0,255}));
  connect(booToRea1.y, unPopAreBreAir.u2) annotation (Line(points={{-198,120},{-160,
          120},{-160,94},{-82,94}}, color={0,0,127}));
  connect(booToRea1.y, unpMinZonFlo.u1) annotation (Line(points={{-198,120},{-160,
          120},{-160,66},{-82,66}}, color={0,0,127}));
  connect(zonMinFlo.y, unpMinZonFlo.u2) annotation (Line(points={{-258,60},{-250,
          60},{-250,54},{-82,54}}, color={0,0,127}));
  connect(desAreAir.y, unPopAreBreAir.u1) annotation (Line(points={{-158,310},{-140,
          310},{-140,106},{-82,106}}, color={0,0,127}));
  connect(notOcc.y, unpPopBreAir.u2)
    annotation (Line(points={{-258,160},{138,160}}, color={255,0,255}));
  connect(zer1.y, unpPopBreAir.u1) annotation (Line(points={{2,270},{30,270},{30,
          168},{138,168}}, color={0,0,127}));
  connect(notOcc.y, unpAreBreAir.u2) annotation (Line(points={{-258,160},{0,160},
          {0,130},{78,130}}, color={255,0,255}));
  connect(unPopAreBreAir.y, unpAreBreAir.u1) annotation (Line(points={{-58,100},
          {-40,100},{-40,138},{78,138}}, color={0,0,127}));
  connect(notOcc.y, unpMinZonAir.u2) annotation (Line(points={{-258,160},{0,160},
          {0,100},{18,100}}, color={255,0,255}));
  connect(unpMinZonFlo.y, unpMinZonAir.u1) annotation (Line(points={{-58,60},{-20,
          60},{-20,108},{18,108}}, color={0,0,127}));
  connect(unpPopBreAir.y, modPopBreAir.u3) annotation (Line(points={{162,160},{170,
          160},{170,272},{178,272}}, color={0,0,127}));
  connect(unpAreBreAir.y, modAreBreAir.u3) annotation (Line(points={{102,130},{120,
          130},{120,242},{138,242}}, color={0,0,127}));
  connect(unpMinZonAir.y, occMinAir.u3) annotation (Line(points={{42,100},{48,100},
          {48,212},{78,212}}, color={0,0,127}));
  connect(occMinAirSet.y, unpMinZonAir.u3) annotation (Line(points={{2,-130},{10,
          -130},{10,92},{18,92}}, color={0,0,127}));
  connect(popBreOutAir.y, unpPopBreAir.u3) annotation (Line(points={{2,-170},{130,
          -170},{130,152},{138,152}}, color={0,0,127}));
  connect(con1.y, unpPopBreAir.u2) annotation (Line(points={{-18,180},{0,180},{0,
          160},{138,160}}, color={255,0,255}));
  connect(con1.y, unpAreBreAir.u2) annotation (Line(points={{-18,180},{0,180},{0,
          130},{78,130}}, color={255,0,255}));
  connect(con1.y, unpMinZonAir.u2) annotation (Line(points={{-18,180},{0,180},{0,
          100},{18,100}}, color={255,0,255}));
  connect(desAreAir.y, unpAreBreAir.u3) annotation (Line(points={{-158,310},{-140,
          310},{-140,122},{78,122}}, color={0,0,127}));
  connect(zonMinFlo.y, gai.u) annotation (Line(points={{-258,60},{-250,60},{-250,
          -20},{-42,-20}}, color={0,0,127}));
  connect(gai.y, unpMinZonAir.u3) annotation (Line(points={{-18,-20},{10,-20},{10,
          92},{18,92}}, color={0,0,127}));
  connect(desPopAir.y, gai1.u) annotation (Line(points={{-158,260},{-100,260},{-100,
          80},{78,80}}, color={0,0,127}));
  connect(gai1.y, unpPopBreAir.u3) annotation (Line(points={{102,80},{130,80},{130,
          152},{138,152}}, color={0,0,127}));
  connect(modAreBreAir.y, reqBreAir.u2) annotation (Line(points={{162,250},{212,
          250},{212,254},{218,254}}, color={0,0,127}));
  connect(modPopBreAir.y, reqBreAir.u1) annotation (Line(points={{202,280},{210,
          280},{210,266},{218,266}}, color={0,0,127}));
  connect(reqBreAir.y, minOA.u1) annotation (Line(points={{242,260},{250,260},{250,
          6},{258,6}}, color={0,0,127}));
  connect(airDisEff.y, minOA.u2) annotation (Line(points={{-158,-290},{250,-290},
          {250,-6},{258,-6}}, color={0,0,127}));
  connect(occMinAir.y, VOccZonMin_flow)
    annotation (Line(points={{102,220},{320,220}}, color={0,0,127}));
  connect(minOA.y, VMinOA_flow)
    annotation (Line(points={{282,0},{320,0}}, color={0,0,127}));
  connect(zer2.y, unpAreBreAir.u1) annotation (Line(points={{-58,140},{-40,140},
          {-40,138},{78,138}}, color={0,0,127}));
  connect(zer3.y, unpMinZonAir.u1) annotation (Line(points={{-58,20},{-20,20},{-20,
          108},{18,108}}, color={0,0,127}));
  connect(TZon, cooSup.u1)
    annotation (Line(points={{-320,-290},{-222,-290}}, color={0,0,127}));
  connect(TDis, cooSup.u2) annotation (Line(points={{-320,-320},{-240,-320},{-240,
          -298},{-222,-298}}, color={0,0,127}));
  connect(cooSup.y, airDisEff.u)
    annotation (Line(points={{-198,-290},{-182,-290}}, color={255,0,255}));

annotation (
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
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
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWin"),
        Text(
          visible=have_occSen,
          extent={{-100,76},{-74,66}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{-98,46},{-62,34}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          visible=have_CO2Sen,
          extent={{-100,16},{-62,6}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2"),
        Text(
          visible=have_CO2Sen and have_parFanPowUniWitCO2,
          extent={{-98,-4},{-64,-16}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uZonSta"),
        Text(
          visible=have_CO2Sen and have_parFanPowUniWitCO2,
          extent={{-98,-32},{-48,-48}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VParFan_flow"),
        Text(
          extent={{-100,-64},{-76,-74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{-100,-82},{-80,-92}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TDis"),
        Text(
          visible=not have_SZVAVWitCO2,
          extent={{48,48},{98,32}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOccZonMin_flow"),
        Text(
          extent={{54,-32},{98,-46}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinOA_flow")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,-340},{300,340}})),
  Documentation(info="<html>
<p>
This sequence sets the zone minimum outdoor air and minimum airflow setpoints, for
compliance with the ventilation rate procedure of ASHRAE Standard 62.1-2016. The
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
<code>VZonMin_flow</code> should be provided by designer.
</p>
<h4>Zone ventilation set points</h4>
<p>
According to Section 3.1.1.2 of Guideline 36, 
</p>
<ul>
<li>
The area component of the breathing zone outdoor airflow is the zone flow area
<code>AFlo</code> times the outdoor airflow rate per unit area
<code>outAirRat_area</code>, as given in ASHRAE Standard 62.1-2016, Table 6.2.2.1.
The default is set to be 0.3 L/s/m2.
</li>
<li>
The population component of the breathing zone outdoor airflow is the zone design
popuation <code>desZonPop</code> times the outdoor airflow rate per occupant
<code>outAirRat_occupant</code>, as given in ASHRAE Standard 62.1-2016, Table 6.2.2.1.
The default is set to be 2.5 L/s/person.
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
The occupied minimum airflow shall be equal to <code>VZonMin_flow</code> except as
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
should be zero and the occupied minimum airflow rate should be <code>VZonMin_flow</code>.
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
setpoint <code>VZonMin_flow</code> at 0% loop output up to maximum cooling airflow
setpoint <code>VZonCooMax_flow</code> at 100% loop output. The population component
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
<code>VZonCooMax_flow</code>; when the zone state is heating or deadband, the maximum
flow rate is equal to <code>VZonCooMax_flow</code> minus the parallel fan airflow
<code>VParFan_flow</code>.
</li>
<li>
The occupied minimum airflow setpoint shall be reset from the zone minimum airflow
setpoint <code>VZonMin_flow</code> at 0% loop output up to maximum cooling airflow
setpoint <code>VZonCooMax_flow</code> at 100% loop output. The population component
of breathing zone outdoor airflow shall be reset from 0 L/s at 0% loop output up to
the designed population component airflow setpoint at 100% loop output.
</li>
</ul>
<p align=\"center\">
<img alt=\"Image of airflow setpoint for VAV parallel-fan terminal unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/VentilationZones/ASHRAE61_1/setpoints_parallelFan.png\"/>
</p>
</li>
<li>
For single zoneVAV air handler unit: The minimum outdoor air setpoint is equal to
the breathing zone outdoor airflow setpoint. The CO2 control loop output shall reset
the population component of the required breathing zone outdoor airflow from 0 L/s
at 0% loop output up to the designed population component airflow setpoint at
100% loop output.
<p align=\"center\">
<img alt=\"Image of airflow setpoint for single zone VAV AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/VentilationZones/ASHRAE61_1/setpoints_SZVAV.png\"/>
</p>
</li>
</ol>
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
