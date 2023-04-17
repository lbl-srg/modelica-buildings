within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.Title24;
block Setpoints
  "Specify zone minimum outdoor air and minimum airflow set points for compliance with California Title 24"

  parameter Boolean have_winSen=false
    "True: the zone has window sensor"
    annotation (__cdl(ValueInReference=False));
  parameter Boolean have_occSen=false
    "True: the zone has occupancy sensor"
    annotation (__cdl(ValueInReference=False));
  parameter Boolean have_CO2Sen=false
    "True: the zone has CO2 sensor"
    annotation (__cdl(ValueInReference=False));
  parameter Boolean have_typTerUni=false
    "True: the zone has typical terminal units and CO2 sensor"
    annotation (__cdl(ValueInReference=False),
                Dialog(enable=have_CO2Sen and not (have_SZVAV or have_parFanPowUni)));
  parameter Boolean have_parFanPowUni=false
    "True: the zone has parallel fan-powered terminal unit and CO2 sensor"
    annotation (__cdl(ValueInReference=False),
                Dialog(enable=have_CO2Sen and not (have_SZVAV or have_typTerUni)));
  parameter Boolean have_SZVAV=false
    "True: it is single zone VAV AHU system with CO2 sensor"
    annotation (__cdl(ValueInReference=False),
                Dialog(enable=have_CO2Sen and not (have_parFanPowUni or have_typTerUni)));
  parameter Real VOccMin_flow(unit="m3/s")
    "Zone minimum outdoor airflow for occupants"
    annotation(Dialog(group="Design conditions"));
  parameter Real VAreMin_flow(unit="m3/s")
    "Zone minimum outdoor airflow for building area"
    annotation(Dialog(group="Design conditions"));
  parameter Real VMin_flow(unit="m3/s")
    "Design zone minimum airflow setpoint"
    annotation(Dialog(enable=not (have_CO2Sen and have_SZVAV), group="Design conditions"));
  parameter Real VCooMax_flow(unit="m3/s")=0.025
    "Design zone cooling maximum airflow rate"
    annotation (__cdl(ValueInReference=False),
                Dialog(enable=have_CO2Sen and (have_parFanPowUni or have_typTerUni), group="Design conditions"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Win if have_winSen
    "Window status, normally closed (true), when windows open, it becomes false"
    annotation (Placement(transformation(extent={{-340,230},{-300,270}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Occ if have_occSen
    "True: the zone is populated"
    annotation (Placement(transformation(extent={{-340,190},{-300,230}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod if have_CO2Sen
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-340,0},{-300,40}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2Set if have_CO2Sen
    "CO2 concentration setpoint, in PPM"
    annotation (Placement(transformation(extent={{-340,-50},{-300,-10}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 concentration"
    annotation (Placement(transformation(extent={{-340,-90},{-300,-50}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta
    if have_CO2Sen and have_parFanPowUni
    "Zone state"
    annotation (Placement(transformation(extent={{-340,-230},{-300,-190}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VParFan_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if have_CO2Sen and have_parFanPowUni
    "Parallel fan airflow rate"
    annotation (Placement(transformation(extent={{-340,-290},{-300,-250}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonAbsMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")
    "Zone absolute minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{300,230},{340,270}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VZonDesMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") "Zone design minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{300,110},{340,150}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOccZonMin_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if not have_SZVAV
    "Occupied zone minimum airflow setpoint"
    annotation (Placement(transformation(extent={{300,40},{340,80}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCO2(
     final unit="1")
    "CO2 control loop signal"
    annotation (Placement(transformation(extent={{300,-70},{340,-30}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VMinOA_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") if have_SZVAV
    "Zone minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{300,-320},{340,-280}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=0.25) "Gain factor"
    annotation (Placement(transformation(extent={{-100,220},{-80,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    "Find the larger input value"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonOccOAMin(
    final k=VOccMin_flow)
    "Zone minimum outdoor airflow for occupants"
    annotation (Placement(transformation(extent={{-280,320},{-260,340}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonAreOAMin(
    final k=VAreMin_flow)
    "Zone minimum outdoor airflow for building area"
    annotation (Placement(transformation(extent={{-280,270},{-260,290}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch zonAbsMin
    "Zone absolute outdoor air minimum flow"
    annotation (Placement(transformation(extent={{40,240},{60,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-100,270},{-80,290}})));
  Buildings.Controls.OBC.CDL.Logical.Not notOcc
    "Not occupied"
    annotation (Placement(transformation(extent={{-180,200},{-160,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch zonAbsMin1
    "Zone absolute outdoor air minimum flow"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant havCO2Sen(
    final k=have_CO2Sen)
    "Check if the zone has CO2 sensor"
    annotation (Placement(transformation(extent={{-260,160},{-240,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch zonAbsMin2
    "Zone absolute outdoor air minimum flow"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch zonDesMin
    "Zone design outdoor air minimum flow"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch zonDesMin1
    "Zone design outdoor air minimum flow"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch zonOccMin if not have_SZVAV
    "Zone occupied minimum flow"
    annotation (Placement(transformation(extent={{240,50},{260,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch zonOccMin1 if not have_SZVAV
    "Zone occupied minimum flow"
    annotation (Placement(transformation(extent={{180,30},{200,50}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    if have_CO2Sen
    "Occupied mode"
    annotation (Placement(transformation(extent={{-280,-20},{-260,0}})));
  Buildings.Controls.OBC.CDL.Integers.Equal inOccMod if have_CO2Sen
    "Check if it is in occupied mode"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(final p=-200)
    if have_CO2Sen
    "Lower threshold of CO2 setpoint"
    annotation (Placement(transformation(extent={{-220,-60},{-200,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin if have_CO2Sen
    "CO2 control loop"
    annotation (Placement(transformation(extent={{-160,-80},{-140,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-280,-110},{-260,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{-220,-110},{-200,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply co2Con if have_CO2Sen
    "Corrected CO2 control loop output"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea if have_CO2Sen
    "Convert boolean to real"
    annotation (Placement(transformation(extent={{-160,10},{-140,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Line zonOccMin2
    if have_CO2Sen and have_typTerUni
    "Zone occupied minimum flow when the system has typical terminal units"
    annotation (Placement(transformation(extent={{120,-150},{140,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonMinFlo(
    final k=VMin_flow)
    "Zone minimum airflow"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonCooMaxFlo(
    final k=VCooMax_flow)
    if have_CO2Sen and (have_typTerUni or have_parFanPowUni)
    "Zone cooling maximum airflow"
    annotation (Placement(transformation(extent={{-280,-158},{-260,-138}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hal(
    final k=0.5)
    if have_CO2Sen and (have_typTerUni or have_parFanPowUni) "Constant value"
    annotation (Placement(transformation(extent={{-160,-110},{-140,-90}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant cooSta(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.cooling)
    if have_CO2Sen and have_parFanPowUni
    "Cooling state"
    annotation (Placement(transformation(extent={{-280,-240},{-260,-220}})));
  Buildings.Controls.OBC.CDL.Integers.Equal inCooSta
    if have_CO2Sen and have_parFanPowUni
    "Check if it is in cooling state"
    annotation (Placement(transformation(extent={{-220,-220},{-200,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract difCooMax
    if have_CO2Sen and have_parFanPowUni
    "Maximum cooling airflw set point minus parallel fan airflow"
    annotation (Placement(transformation(extent={{-220,-260},{-200,-240}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch maxFloCO2
    if have_CO2Sen and have_parFanPowUni
    "Maximum airflow set point for CO2"
    annotation (Placement(transformation(extent={{-160,-220},{-140,-200}})));
  Buildings.Controls.OBC.CDL.Continuous.Line zonOccMin3
    if have_CO2Sen and have_parFanPowUni
    "Zone occupied minimum flow when the system has parallel fan-powered terminal unit"
    annotation (Placement(transformation(extent={{120,-200},{140,-180}})));
  Buildings.Controls.OBC.CDL.Continuous.Line zonOccMin4 if have_SZVAV
    "Zone minimum outdoor flow when it is the single zone VAV system"
    annotation (Placement(transformation(extent={{120,-310},{140,-290}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    if not have_winSen
    "Constant false"
    annotation (Placement(transformation(extent={{-180,280},{-160,300}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=true)
    if not have_occSen "Constant true"
    annotation (Placement(transformation(extent={{-280,220},{-260,240}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=1)
    if not have_CO2Sen
    "Dummy gain for conditional input"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one2(final k=1)
    if not have_CO2Sen "Constant one"
    annotation (Placement(transformation(extent={{-80,-270},{-60,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer3(final k=0)
    if not have_CO2Sen
    "Constant zero"
    annotation (Placement(transformation(extent={{200,-90},{220,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not winOpe if have_winSen "Window is open"
    annotation (Placement(transformation(extent={{-180,240},{-160,260}})));
equation
  connect(zer1.y, zonAbsMin.u1) annotation (Line(points={{-78,280},{20,280},{20,
          258},{38,258}}, color={0,0,127}));
  connect(u1Occ, notOcc.u)
    annotation (Line(points={{-320,210},{-182,210}}, color={255,0,255}));
  connect(notOcc.y, zonAbsMin1.u2)
    annotation (Line(points={{-158,210},{-22,210}}, color={255,0,255}));
  connect(zonAreOAMin.y, gai.u) annotation (Line(points={{-258,280},{-220,280},{
          -220,230},{-102,230}}, color={0,0,127}));
  connect(gai.y, zonAbsMin1.u1) annotation (Line(points={{-78,230},{-40,230},{-40,
          218},{-22,218}}, color={0,0,127}));
  connect(zonAbsMin1.y, zonAbsMin.u3) annotation (Line(points={{2,210},{30,210},
          {30,242},{38,242}}, color={0,0,127}));
  connect(havCO2Sen.y, zonAbsMin2.u2)
    annotation (Line(points={{-238,170},{-82,170}}, color={255,0,255}));
  connect(zonAbsMin2.y, zonAbsMin1.u3) annotation (Line(points={{-58,170},{-30,170},
          {-30,202},{-22,202}}, color={0,0,127}));
  connect(zer1.y, zonDesMin.u1) annotation (Line(points={{-78,280},{20,280},{20,
          138},{38,138}}, color={0,0,127}));
  connect(zonDesMin1.y, zonDesMin.u3) annotation (Line(points={{2,110},{30,110},
          {30,122},{38,122}}, color={0,0,127}));
  connect(notOcc.y, zonDesMin1.u2) annotation (Line(points={{-158,210},{-120,210},
          {-120,110},{-22,110}}, color={255,0,255}));
  connect(gai.y, zonDesMin1.u1) annotation (Line(points={{-78,230},{-40,230},{-40,
          118},{-22,118}}, color={0,0,127}));
  connect(zonAreOAMin.y, max1.u2) annotation (Line(points={{-258,280},{-220,280},
          {-220,84},{-182,84}}, color={0,0,127}));
  connect(zonOccOAMin.y, max1.u1) annotation (Line(points={{-258,330},{-200,330},
          {-200,96},{-182,96}}, color={0,0,127}));
  connect(max1.y, zonDesMin1.u3) annotation (Line(points={{-158,90},{-30,90},{-30,
          102},{-22,102}}, color={0,0,127}));
  connect(zonDesMin.y, zonAbsMin2.u3) annotation (Line(points={{62,130},{80,130},
          {80,150},{-100,150},{-100,162},{-82,162}}, color={0,0,127}));
  connect(zonDesMin.y, VZonDesMin_flow)
    annotation (Line(points={{62,130},{320,130}}, color={0,0,127}));
  connect(zonAbsMin.y, VZonAbsMin_flow)
    annotation (Line(points={{62,250},{320,250}}, color={0,0,127}));
  connect(notOcc.y, zonOccMin.u2) annotation (Line(points={{-158,210},{-120,210},
          {-120,60},{238,60}}, color={255,0,255}));
  connect(gai.y, zonOccMin.u1) annotation (Line(points={{-78,230},{-40,230},{-40,
          68},{238,68}}, color={0,0,127}));
  connect(zer1.y, zonOccMin1.u1) annotation (Line(points={{-78,280},{20,280},{20,
          48},{178,48}}, color={0,0,127}));
  connect(zonOccMin1.y, zonOccMin.u3) annotation (Line(points={{202,40},{220,40},
          {220,52},{238,52}}, color={0,0,127}));
  connect(uOpeMod, inOccMod.u1)
    annotation (Line(points={{-320,20},{-222,20}}, color={255,127,0}));
  connect(occMod.y, inOccMod.u2) annotation (Line(points={{-258,-10},{-240,-10},
          {-240,12},{-222,12}}, color={255,127,0}));
  connect(inOccMod.y, booToRea.u)
    annotation (Line(points={{-198,20},{-162,20}}, color={255,0,255}));
  connect(booToRea.y, co2Con.u1) annotation (Line(points={{-138,20},{-100,20},{-100,
          -44},{-82,-44}}, color={0,0,127}));
  connect(ppmCO2Set, addPar.u) annotation (Line(points={{-320,-30},{-240,-30},{-240,
          -50},{-222,-50}}, color={0,0,127}));
  connect(addPar.y, lin.x1) annotation (Line(points={{-198,-50},{-180,-50},{-180,
          -62},{-162,-62}}, color={0,0,127}));
  connect(zer.y, lin.f1) annotation (Line(points={{-258,-100},{-230,-100},{-230,
          -66},{-162,-66}}, color={0,0,127}));
  connect(ppmCO2, lin.u)
    annotation (Line(points={{-320,-70},{-162,-70}}, color={0,0,127}));
  connect(ppmCO2Set, lin.x2) annotation (Line(points={{-320,-30},{-240,-30},{-240,
          -74},{-162,-74}}, color={0,0,127}));
  connect(one.y, lin.f2) annotation (Line(points={{-198,-100},{-180,-100},{-180,
          -78},{-162,-78}}, color={0,0,127}));
  connect(lin.y, co2Con.u2) annotation (Line(points={{-138,-70},{-100,-70},{-100,
          -56},{-82,-56}}, color={0,0,127}));
  connect(co2Con.y, zonOccMin2.u) annotation (Line(points={{-58,-50},{-20,-50},{
          -20,-140},{118,-140}}, color={0,0,127}));
  connect(zer.y, zonOccMin2.x1) annotation (Line(points={{-258,-100},{-230,-100},
          {-230,-132},{118,-132}}, color={0,0,127}));
  connect(zonMinFlo.y, zonOccMin2.f1) annotation (Line(points={{-58,0},{0,0},{0,
          -136},{118,-136}}, color={0,0,127}));
  connect(hal.y, zonOccMin2.x2) annotation (Line(points={{-138,-100},{-100,-100},
          {-100,-144},{118,-144}}, color={0,0,127}));
  connect(uZonSta, inCooSta.u1)
    annotation (Line(points={{-320,-210},{-222,-210}}, color={255,127,0}));
  connect(cooSta.y, inCooSta.u2) annotation (Line(points={{-258,-230},{-240,-230},
          {-240,-218},{-222,-218}}, color={255,127,0}));
  connect(inCooSta.y, maxFloCO2.u2)
    annotation (Line(points={{-198,-210},{-162,-210}}, color={255,0,255}));
  connect(zonCooMaxFlo.y, zonOccMin2.f2)
    annotation (Line(points={{-258,-148},{118,-148}}, color={0,0,127}));
  connect(zonCooMaxFlo.y, maxFloCO2.u1) annotation (Line(points={{-258,-148},{-190,
          -148},{-190,-202},{-162,-202}}, color={0,0,127}));
  connect(difCooMax.y, maxFloCO2.u3) annotation (Line(points={{-198,-250},{-190,
          -250},{-190,-218},{-162,-218}}, color={0,0,127}));
  connect(zonCooMaxFlo.y, difCooMax.u1) annotation (Line(points={{-258,-148},{-250,
          -148},{-250,-244},{-222,-244}}, color={0,0,127}));
  connect(VParFan_flow, difCooMax.u2) annotation (Line(points={{-320,-270},{-240,
          -270},{-240,-256},{-222,-256}}, color={0,0,127}));
  connect(co2Con.y, zonOccMin3.u) annotation (Line(points={{-58,-50},{-20,-50},{
          -20,-190},{118,-190}}, color={0,0,127}));
  connect(zer.y, zonOccMin3.x1) annotation (Line(points={{-258,-100},{-230,-100},
          {-230,-182},{118,-182}}, color={0,0,127}));
  connect(zonMinFlo.y, zonOccMin3.f1) annotation (Line(points={{-58,0},{0,0},{0,
          -186},{118,-186}}, color={0,0,127}));
  connect(hal.y, zonOccMin3.x2) annotation (Line(points={{-138,-100},{-100,-100},
          {-100,-194},{118,-194}}, color={0,0,127}));
  connect(maxFloCO2.y, zonOccMin3.f2) annotation (Line(points={{-138,-210},{-60,
          -210},{-60,-198},{118,-198}}, color={0,0,127}));
  connect(co2Con.y, zonOccMin4.u) annotation (Line(points={{-58,-50},{-20,-50},{
          -20,-300},{118,-300}}, color={0,0,127}));
  connect(zer.y, zonOccMin4.x1) annotation (Line(points={{-258,-100},{-230,-100},
          {-230,-292},{118,-292}}, color={0,0,127}));
  connect(one.y, zonOccMin4.x2) annotation (Line(points={{-198,-100},{-180,-100},
          {-180,-304},{118,-304}}, color={0,0,127}));
  connect(zonAbsMin.y, zonOccMin4.f1) annotation (Line(points={{62,250},{100,250},
          {100,-296},{118,-296}}, color={0,0,127}));
  connect(zonDesMin.y, zonOccMin4.f2) annotation (Line(points={{62,130},{80,130},
          {80,-308},{118,-308}}, color={0,0,127}));
  connect(zonAreOAMin.y, zonAbsMin2.u1) annotation (Line(points={{-258,280},{-220,
          280},{-220,178},{-82,178}}, color={0,0,127}));
  connect(zonOccMin2.y, zonOccMin1.u3) annotation (Line(points={{142,-140},{160,
          -140},{160,32},{178,32}}, color={0,0,127}));
  connect(zonOccMin3.y, zonOccMin1.u3) annotation (Line(points={{142,-190},{160,
          -190},{160,32},{178,32}}, color={0,0,127}));
  connect(zonOccMin.y, VOccZonMin_flow)
    annotation (Line(points={{262,60},{320,60}}, color={0,0,127}));
  connect(con.y, zonAbsMin.u2) annotation (Line(points={{-158,290},{-140,290},{-140,
          250},{38,250}}, color={255,0,255}));
  connect(con.y, zonDesMin.u2) annotation (Line(points={{-158,290},{-140,290},{-140,
          130},{38,130}}, color={255,0,255}));
  connect(con.y, zonOccMin1.u2) annotation (Line(points={{-158,290},{-140,290},{
          -140,40},{178,40}}, color={255,0,255}));
  connect(con1.y, notOcc.u) annotation (Line(points={{-258,230},{-240,230},{-240,
          210},{-182,210}}, color={255,0,255}));
  connect(zonMinFlo.y, gai1.u)
    annotation (Line(points={{-58,0},{38,0}}, color={0,0,127}));
  connect(gai1.y, zonOccMin1.u3) annotation (Line(points={{62,0},{160,0},{160,32},
          {178,32}}, color={0,0,127}));
  connect(one2.y, zonOccMin4.u) annotation (Line(points={{-58,-260},{-20,-260},{
          -20,-300},{118,-300}}, color={0,0,127}));
  connect(zonOccMin4.y, VMinOA_flow)
    annotation (Line(points={{142,-300},{320,-300}}, color={0,0,127}));
  connect(co2Con.y, yCO2)
    annotation (Line(points={{-58,-50},{320,-50}}, color={0,0,127}));
  connect(zer3.y, yCO2) annotation (Line(points={{222,-80},{240,-80},{240,-50},{
          320,-50}}, color={0,0,127}));
  connect(u1Win, winOpe.u)
    annotation (Line(points={{-320,250},{-182,250}}, color={255,0,255}));
  connect(winOpe.y, zonAbsMin.u2)
    annotation (Line(points={{-158,250},{38,250}}, color={255,0,255}));
  connect(winOpe.y, zonDesMin.u2) annotation (Line(points={{-158,250},{-140,250},
          {-140,130},{38,130}}, color={255,0,255}));
  connect(winOpe.y, zonOccMin1.u2) annotation (Line(points={{-158,250},{-140,250},
          {-140,40},{178,40}}, color={255,0,255}));
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
          points={{4,-12},{60,60}},
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
          extent={{-100,64},{-74,54}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uOcc"),
        Text(
          extent={{-98,36},{-62,24}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod",
          visible=have_CO2Sen),
        Text(
          visible=have_CO2Sen and have_parFanPowUni,
          extent={{-98,-54},{-64,-66}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uZonSta"),
        Text(
          visible=have_CO2Sen and have_parFanPowUni,
          extent={{-98,-82},{-48,-98}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VParFan_flow"),
        Text(
          visible=not have_SZVAV,
          extent={{48,98},{98,82}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonAbsMin_flow"),
        Text(
          extent={{-98,-24},{-70,-34}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2",
          visible=have_CO2Sen),
        Text(
          extent={{-98,8},{-62,-6}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="ppmCO2Set",
          visible=have_CO2Sen),
        Text(
          visible=not have_SZVAV,
          extent={{48,-22},{98,-38}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOccZonMin_flow"),
        Text(
          visible=not have_SZVAV,
          extent={{48,68},{98,52}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VZonDesMin_flow"),
        Line(
          points={{4,-12},{-60,-12}},
          color={28,108,200},
          thickness=0.5),
        Text(
          visible=have_SZVAV,
          extent={{60,-82},{98,-98}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VMinOA_flow"),
        Text(
          extent={{80,-54},{98,-66}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yCO2")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,-360},{300,360}})),
  Documentation(info="<html>
<p>
This sequence sets the zone minimum outdoor air and minimum airflow setpoints, for
compliance with the ventilation rate procedure of California Title 24. The
implementation is according to Section 5.2.1.4 of ASHRAE Guideline36, May 2020. The calculation
is done following the steps below.
</p>
<p>
1. For every zone that requires mechanical ventilation, the zone minimum outdoor airflows
and set points shall be calculated depending on the governing standard or code for
outdoor air requirements.
</p>
<p>
2. According to section 3.1.2 of Guideline 36, the zone minimum airflow setpoint
<code>VMin_flow</code> and the zone cooling maximum setpoint <code>VCooMax_flow</code>
should be provided by designer.
</p>
<h4>Zone ventilation set points</h4>
<p>
According to Section 3.1.1.2.b of Guideline 36, 
</p>
<ul>
<li>
The zone minimum outdoor airflow for occupants <code>VOccMin_flow</code>, per California
Title 24 prescribed airflow-per-occupant requirements.
</li>
<li>
The zone minimum outdoor airflow for building area <code>VAreMin_flow</code>, per California
Title 24 prescribed airflow-per-area requirements.
</li>
</ul>
<h4>Zone minimum outdoor air setpoints</h4>
<p>
The zone absolute minimum outdoor airflow setpoint <code>VZonAbsMin_flow</code> is
used in terminal-unit sequences and air-handler sequences.
The zone design minimum outdoor airflow setpoint <code>VZonDesMin_flow</code> is
used in air-handler sequences only.
</p>
<ul>
<li>
<code>VZonAbsMin_flow</code> shall be reset based on the following conditions in order
from highest to lowest priority:
<ol>
<li>
Zero if the zone has a window switch and the window is open.
</li>
<li>
Twenty-five percent of the <code>VAreMin_flow</code> if the zone has an occupancy
sensor and is unpopulated.
</li>
<li>
If the zone has a CO2 sensor, <code>VAreMin_flow</code>.
</li>
<li>
Otherwise, <code>VZonDesMin_flow</code>.
</li>
</ol>
</li>
<li>
<code>VZonDesMin_flow</code> is equal to the following:
<ol>
<li>
Zero if the zone has a window switch and the window is open.
</li>
<li>
Twenty-five percent of the <code>VAreMin_flow</code> if the zone has an occupancy
sensor and is unpopulated.
</li>
<li>
The larger of <code>VAreMin_flow</code> and <code>VOccMin_flow</code> otherwise.
</li>
</ol>
</li>
</ul>
<h4>Occupied minimum airflow</h4>
<p>
The occupied minimum airflow shall be equal to <code>VMin_flow</code> except as
noted in below section.
</p>
<h4>Occupied minimum airflow modification</h4>
<ol>
<li>
If the zone has an occupancy sensor, the minimum airflow <code>VOccZonMin_flow</code>
shall be equal to 25% of the <code>VAreMin_flow</code> when the room is unpopulated.
</li>
<li>
If the zone has a window switch, the minimum airflow <code>VOccZonMin_flow</code>
shall be zero when the window is open.
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
The CO2 control loop output shall reset the occupied minimum airflow setpoint
<code>VOccZonMin_flow</code> from the zone minimum airflow setpoint <code>VMin_flow</code>
at 0% loop output up to maximum cooling airflow setpoint <code>VCooMax_flow</code>
at 50% loop output. The loop output from 50% to 100% will be used at the system level
to reset outdoor air minimum.
</li>
</ul>
<p align=\"center\">
<img alt=\"Image of airflow setpoint for VAV reheat terminal unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/VentilationZones/Title24/setpoints_reheat.png\"/>
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
The CO2 control loop ouput shall reset the occupied minimum airflow setpoint from the
zone minimum airflow setpoint <code>VMin_flow</code> at 0% loop output up to maximum
cooling airflow setpoint for CO2 control at 50% loop output. The loop output from 50%
to 100% will be used at the system level to reset outdoor air minimum.
</li>
</ul>
<p align=\"center\">
<img alt=\"Image of airflow setpoint for VAV parallel-fan terminal unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/VentilationZones/Title24/setpoints_parallelFan.png\"/>
</p>
</li>
</ol>
</li>
</ol>
<h4>Minimum outdoor airflow for single zone VAV air handler unit</h4>
<p>
The minimum outdoor air setpoint shall be reset
based on the zone CO2 control-llop signal from <code>VZonAbsMin_flow</code> at 0% signal
to <code>VZonDesMin_flow</code> at 100% signal.
</p>
<p align=\"center\">
<img alt=\"Image of airflow setpoint for single zone VAV AHU\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/VentilationZones/Title24/setpoints_SZVAV.png\"/>
</p>
<p>
If there is no CO2 sensor, the minimum outdoor air setpoint should be <code>VZonDesMin_flow</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 22, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Setpoints;
