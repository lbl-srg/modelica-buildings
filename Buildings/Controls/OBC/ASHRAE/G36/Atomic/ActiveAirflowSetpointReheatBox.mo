within Buildings.Controls.OBC.ASHRAE.G36.Atomic;
block ActiveAirflowSetpointReheatBox
  "Output the active airflow setpoint for VAV reheat terminal unit"

  parameter Boolean occSen = true
    "Set to true if the zone has an occupancy sensor"
    annotation(Dialog(group="Zone sensors"));
  parameter Boolean winSen = true
    "Set to true if the zone has window operation sensor and window is open"
    annotation(Dialog(group="Zone sensors"));
  parameter Boolean co2Sen = true
    "Set to true if the zone has a CO2 sensor"
    annotation(Dialog(group="Zone sensors"));
  parameter Modelica.SIunits.VolumeFlowRate VCooMax
    "Zone maximum cooling airflow setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate VMin
    "Zone minimum airflow setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate VMinCon
    "VAV box controllable minimum"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate VHeaMax
    "Zone maximum heating airflow setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.TemperatureDifference maxDTemDis
    "Zone maximum discharge air temperature above heating setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Area zonAre "Area of the zone"
    annotation(Dialog(group="Nominal condition"));
  parameter Real outAirPerAre(final unit = "m3/(s.m2)")=3e-4
    "Outdoor air flow rate per unit area"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer=2.5e-3
    "Outdoor air flow rate per person"
    annotation(Dialog(group="Nominal condition"));
  parameter Real co2Set = 894 "CO2 setpoint"
    annotation(Dialog(group="Nominal condition"));

  CDL.Interfaces.RealInput nOcc(final unit="1") if occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-320,-300},{-280,-260}}),
      iconTransformation(extent={{-120,10},{-100,30}})));
  CDL.Interfaces.RealInput ppmCO2(final unit="1") if co2Sen
    "Measured CO2 conventration"
    annotation (Placement(transformation(extent={{-320,-200},{-280,-160}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  CDL.Interfaces.BooleanInput uWin if winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-320,-520},{-280,-480}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-320,-130},{-280,-90}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  CDL.Interfaces.RealOutput VOccMinAir(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Occupied minimum airflow "
    annotation (Placement(transformation(extent={{280,-310},{320,-270}}),
      iconTransformation(extent={{100,-90},{120,-70}})));
  CDL.Interfaces.RealOutput VActCooMax(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Active cooling maximum"
    annotation (Placement(transformation(extent={{280,190},{320,230}}),
      iconTransformation(extent={{100,70},{120,90}})));
  CDL.Interfaces.RealOutput VActCooMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Active cooling minimum"
    annotation (Placement(transformation(extent={{280,150},{320,190}}),
      iconTransformation(extent={{100,40},{120,60}})));
  CDL.Interfaces.RealOutput VActMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Active minimum"
    annotation (Placement(transformation(extent={{280,110},{320,150}}),
      iconTransformation(extent={{100,10},{120,30}})));
  CDL.Interfaces.RealOutput VActHeaMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Active heating minimum"
    annotation (Placement(transformation(extent={{280,70},{320,110}}),
      iconTransformation(extent={{100,-20},{120,0}})));
  CDL.Interfaces.RealOutput VActHeaMax(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Active heating maximum"
    annotation (Placement(transformation(extent={{280,30},{320,70}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

  CDL.Continuous.Gain gai(k=outAirPerPer) if occSen
  "Outdoor airflow rate per person"
    annotation (Placement(transformation(extent={{-140,-330},{-120,-310}})));
  CDL.Continuous.Add breZon if occSen
  "Breathing zone airflow rate"
    annotation (Placement(transformation(extent={{-80,-350},{-60,-330}})));
  CDL.Continuous.Line co2ConLoo if co2Sen
    "Maintain CO2 concentration at setpoint, reset 0% at (setpoint-200) and 100% at setpoint"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  CDL.Continuous.Line lin1 if co2Sen
    "Reset occupied minimum airflow setpoint from 0% at VMin and 100% at VCooMax"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  CDL.Continuous.Greater gre
    "Check if zone minimum airflow setpoint Vmin is less than the allowed controllable VMinCon"
    annotation (Placement(transformation(extent={{-20,-460},{0,-440}})));
  CDL.Continuous.Hysteresis       zonOcc(uLow=0.05, uHigh=0.10) if
                                                         occSen
    "Check if the zone becomes unpopulated"
    annotation (Placement(transformation(extent={{-140,-290},{-120,-270}})));
  CDL.Continuous.GreaterThreshold greThr1
    "Check if zone minimum airflow setpoint VMin is non-zero"
    annotation (Placement(transformation(extent={{-80,-410},{-60,-390}})));
  CDL.Logical.Switch swi
    "Reset occupied minimum airflow according to occupancy"
    annotation (Placement(transformation(extent={{80,-290},{100,-270}})));
  CDL.Logical.Switch swi1
    "Reset occupied minimum airflow according to window status"
    annotation (Placement(transformation(extent={{200,-510},{220,-490}})));
  CDL.Logical.Switch swi2
    "Reset occupied minimum airflow setpoint according to minimum controllable airflow"
    annotation (Placement(transformation(extent={{140,-410},{160,-390}})));
  CDL.Logical.Switch swi3 if co2Sen
    "Switch between zero signal and CO2 control loop signal depending on the operation mode"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-120}})));
  CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{40,-410},{60,-390}})));
  CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{80,-410},{100,-390}})));
  CDL.Logical.Not not2 if winSen "Logical not"
    annotation (Placement(transformation(extent={{-240,-510},{-220,-490}})));
  CDL.Continuous.MultiSum actCooMinAir(
    final nu=5,
    final k={1, 1, 1, 1, 1})
    "Active cooling minimum airflow"
    annotation (Placement(transformation(extent={{220,170},{240,190}})));
  CDL.Continuous.MultiSum actMinAir(
    final nu=5,
    final k={1, 1, 1, 1, 1})
    "Active minimum airflow"
    annotation (Placement(transformation(extent={{220,140},{240,160}})));
  CDL.Continuous.MultiSum actHeaMinAir(
    final nu=5,
    final k={1, 1, 1, 1, 1})
  "Active heating minimum airflow"
    annotation (Placement(transformation(extent={{220,100},{240,120}})));
  CDL.Continuous.MultiSum actHeaMaxAir(
    final nu=5,
    final k={1, 1, 1, 1, 1})
  "Active heating maximum airflow"
    annotation (Placement(transformation(extent={{220,60},{240,80}})));
  CDL.Continuous.MultiSum actCooMaxAir(
    nu=5,
    final k={1, 1, 1, 1, 1})
    "Active cooling maximum airflow"
    annotation (Placement(transformation(extent={{220,200},{240,220}})));

protected
  CDL.Continuous.Sources.Constant minZonAir1(k=VMin) if not co2Sen
    "Zone minimum airflow setpoint"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  CDL.Continuous.Sources.Constant maxZonCooAir(k=VCooMax) if co2Sen
    "Zone maximum cooling airflow setpoint"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  CDL.Continuous.Sources.Constant breZonAre(k=outAirPerAre*zonAre) if occSen
    "Area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-140,-370},{-120,-350}})));
  CDL.Continuous.Sources.Constant conVolMin(k=VMinCon)
    "VAV box controllable minimum"
    annotation (Placement(transformation(extent={{-80,-440},{-60,-420}})));
  CDL.Continuous.Sources.Constant minZonAir(k=VMin)
    "Zone minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-240,-60},{-220,-40}})));
  CDL.Continuous.Sources.Constant setCO1(k=co2Set - 200) if co2Sen
    "CO2 setpoints minus 200"
    annotation (Placement(transformation(extent={{-240,-140},{-220,-120}})));
  CDL.Continuous.Sources.Constant setCO2(k=co2Set) if co2Sen
    "CO2 setpoints"
    annotation (Placement(transformation(extent={{-240,-210},{-220,-190}})));
  CDL.Continuous.Sources.Constant zerFlo(k=0)
    "Zero airflow when window is open"
    annotation (Placement(transformation(extent={{140,-540},{160,-520}})));
  CDL.Logical.Sources.Constant con(k=true) if not occSen "Constant true"
    annotation (Placement(transformation(extent={{-80,-270},{-60,-250}})));
  CDL.Logical.Sources.Constant con1(k=true) if not winSen "Constant true"
    annotation (Placement(transformation(extent={{40,-490},{60,-470}})));
  CDL.Continuous.Sources.Constant zerCon(k=0) "Output zero"
    annotation (Placement(transformation(extent={{-240,-170},{-220,-150}})));
  CDL.Continuous.Sources.Constant zerCon1(k=0) if co2Sen
    "Output zero"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  CDL.Continuous.Sources.Constant zerCon2(k=0) if co2Sen
    "Output zero"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  CDL.Continuous.Sources.Constant zerCon3(k=0) if not occSen
    "Output zero"
    annotation (Placement(transformation(extent={{0,-350},{20,-330}})));
  CDL.Continuous.Sources.Constant oneCon(k=1) if co2Sen
    "Output one"
    annotation (Placement(transformation(extent={{-240,-240},{-220,-220}})));
  CDL.Continuous.Sources.Constant oneCon1(k=1) if co2Sen "Output one"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  CDL.Continuous.Sources.Constant cooMaxAir(k=VCooMax)
    "Cooling maximum airflow"
    annotation (Placement(transformation(extent={{-240,20},{-220,40}})));
  CDL.Continuous.Sources.Constant heaMaxAir(k=VHeaMax)
    "Heat maximum airflow"
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));
  CDL.Continuous.Sources.Constant zerCon6(k=0)
    "Output zero"
    annotation (Placement(transformation(extent={{-240,210},{-220,230}})));
  CDL.Integers.Sources.Constant conInt(
    k=Constants.OperationModes.occModInd)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-240,-100},{-220,-80}})));
  CDL.Integers.Sources.Constant conInt1(
    k=Constants.OperationModes.cooDowInd) "Cool down mode index"
    annotation (Placement(transformation(extent={{-240,510},{-220,530}})));
  CDL.Integers.Sources.Constant conInt2(
    k=Constants.OperationModes.setUpInd) "Setup mode index"
    annotation (Placement(transformation(extent={{-240,350},{-220,370}})));
  CDL.Integers.Sources.Constant conInt3(
    k=Constants.OperationModes.warUpInd) "Warm up mode index"
    annotation (Placement(transformation(extent={{-20,510},{0,530}})));
  CDL.Integers.Sources.Constant conInt4(
    k=Constants.OperationModes.setBacInd) "Setback mode index"
    annotation (Placement(transformation(extent={{-20,350},{0,370}})));
  CDL.Integers.Equal intEqu
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  CDL.Integers.Equal intEqu1
    "Check if current operation mode is cool-down mode"
    annotation (Placement(transformation(extent={{-180,510},{-160,530}})));
  CDL.Integers.Equal intEqu2
    "Check if current operation mode is setup mode"
    annotation (Placement(transformation(extent={{-180,350},{-160,370}})));
  CDL.Integers.Equal intEqu3
    "Check if current operation mode is warmup mode"
    annotation (Placement(transformation(extent={{40,510},{60,530}})));
  CDL.Integers.Equal intEqu4
    "Check if current operation mode is setback mode"
    annotation (Placement(transformation(extent={{40,350},{60,370}})));
  CDL.Logical.Switch swi4
    "Select cooling maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,510},{-80,530}})));
  CDL.Logical.Switch swi5
    "Select cooling minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,480},{-80,500}})));
  CDL.Logical.Switch swi6
   "Select minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,450},{-80,470}})));
  CDL.Logical.Switch swi7
    "Select heating minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,420},{-80,440}})));
  CDL.Logical.Switch swi8
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,390},{-80,410}})));
  CDL.Logical.Switch swi9
    "Select cooling maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,350},{-80,370}})));
  CDL.Logical.Switch swi10
    "Select cooling minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,320},{-80,340}})));
  CDL.Logical.Switch swi11
    "Select minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,290},{-80,310}})));
  CDL.Logical.Switch swi12
    "Select heating minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,260},{-80,280}})));
  CDL.Logical.Switch swi13
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,230},{-80,250}})));
  CDL.Logical.Switch swi14
    "Select cooling maximum based on operation mode"
    annotation (Placement(transformation(extent={{120,510},{140,530}})));
  CDL.Logical.Switch swi15
    "Select cooling minimum based on operation mode"
    annotation (Placement(transformation(extent={{120,480},{140,500}})));
  CDL.Logical.Switch swi16
    "Select minimum based on operation mode"
    annotation (Placement(transformation(extent={{120,450},{140,470}})));
  CDL.Logical.Switch swi17
    "Select heating minimum based on operation mode"
    annotation (Placement(transformation(extent={{120,420},{140,440}})));
  CDL.Logical.Switch swi18
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{120,390},{140,410}})));
  CDL.Logical.Switch swi19
    "Select cooling maximum based on operation mode"
    annotation (Placement(transformation(extent={{120,350},{140,370}})));
  CDL.Logical.Switch swi20
    "Select cooling minimum based on operation mode"
    annotation (Placement(transformation(extent={{120,320},{140,340}})));
  CDL.Logical.Switch swi21
    "Select minimum based on operation mode"
    annotation (Placement(transformation(extent={{120,290},{140,310}})));
  CDL.Logical.Switch swi22
    "Select heating minimum based on operation mode"
    annotation (Placement(transformation(extent={{120,260},{140,280}})));
  CDL.Logical.Switch swi23
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{120,230},{140,250}})));
  CDL.Logical.Switch swi24
    "Select cooling maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  CDL.Logical.Switch swi25
    "Select cooling minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,160},{-80,180}})));
  CDL.Logical.Switch swi26
    "Select minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  CDL.Logical.Switch swi27
    "Select heating minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  CDL.Logical.Switch swi28
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  CDL.Continuous.Max maxInp "Find greater input"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

equation
  connect(conVolMin.y, gre.u1)
    annotation (Line(points={{-59,-430},{-40,-430},{-40,-450},{-22,-450}},
      color={0,0,127}));
  connect(setCO1.y, co2ConLoo.x1)
    annotation (Line(points={{-219,-130},{-160,-130},{-160,-172},{-142,-172}},
      color={0,0,127}));
  connect(zerCon.y, co2ConLoo.f1)
    annotation (Line(points={{-219,-160},{-180,-160},{-180,-176},{-142,-176}},
      color={0,0,127}));
  connect(ppmCO2, co2ConLoo.u)
    annotation (Line(points={{-300,-180},{-142,-180}},
      color={0,0,127}));
  connect(setCO2.y, co2ConLoo.x2)
    annotation (Line(points={{-219,-200},{-180,-200},{-180,-184},{-142,-184}},
      color={0,0,127}));
  connect(oneCon.y, co2ConLoo.f2)
    annotation (Line(points={{-219,-230},{-160,-230},{-160,-188},{-142,-188}},
      color={0,0,127}));
  connect(zerCon1.y, lin1.x1)
    annotation (Line(points={{-59,-80},{0,-80},{0,-112},{18,-112}},
      color={0,0,127}));
  connect(oneCon1.y, lin1.x2)
    annotation (Line(points={{-59,-150},{-20,-150},{-20,-124},{18,-124}},
      color={0,0,127}));
  connect(maxZonCooAir.y, lin1.f2)
    annotation (Line(points={{-59,-180},{0,-180},{0,-128},{18,-128}},
      color={0,0,127}));
  connect(minZonAir.y, lin1.f1)
    annotation (Line(points={{-219,-50},{-20,-50},{-20,-116},{18,-116}},
      color={0,0,127}));
  connect(intEqu.y, swi3.u2)
    annotation (Line(points={{-119,-110},{-82,-110}},
      color={255,0,255}));
  connect(co2ConLoo.y, swi3.u1)
    annotation (Line(points={{-119,-180},{-100,-180},{-100,-118},{-82,-118}},
      color={0,0,127}));
  connect(swi3.y, lin1.u)
    annotation (Line(points={{-59,-110},{-40,-110},{-40,-120},{18,-120}},
      color={0,0,127}));
  connect(zerCon2.y, swi3.u3)
    annotation (Line(points={{-119,-80},{-100,-80},{-100,-102},{-82,-102}},
      color={0,0,127}));
  connect(uOpeMod, intEqu.u2)
    annotation (Line(points={{-300,-110},{-180,-110},{-180,-118},{-142,-118}},
      color={255,127,0}));
  connect(conInt.y, intEqu.u1)
    annotation (Line(points={{-219,-90},{-160,-90},{-160,-110},{-142,-110}},
      color={255,127,0}));
  connect(nOcc,zonOcc. u)
    annotation (Line(points={{-300,-280},{-142,-280}},
      color={0,0,127}));
  connect(nOcc, gai.u)
    annotation (Line(points={{-300,-280},{-160,-280},{-160,-320},{-142,-320}},
      color={0,0,127}));
  connect(breZonAre.y, breZon.u2)
    annotation (Line(points={{-119,-360},{-100,-360},{-100,-346},{-82,-346}},
      color={0,0,127}));
  connect(gai.y, breZon.u1)
    annotation (Line(points={{-119,-320},{-100,-320},{-100,-334},{-82,-334}},
      color={0,0,127}));
  connect(breZon.y, swi.u3)
    annotation (Line(points={{-59,-340},{-20,-340},{-20,-288},{78,-288}},
      color={0,0,127}));
  connect(zonOcc.y, swi.u2)
    annotation (Line(points={{-119,-280},{78,-280}},
      color={255,0,255}));
  connect(lin1.y, swi.u1)
    annotation (Line(points={{41,-120},{60,-120},{60,-272},{78,-272}},
      color={0,0,127}));
  connect(minZonAir.y, greThr1.u)
    annotation (Line(points={{-219,-50},{-200,-50},{-200,-400},{-82,-400}},
      color={0,0,127}));
  connect(minZonAir.y, gre.u2)
    annotation (Line(points={{-219,-50},{-200,-50},{-200,-458},{-22,-458}},
      color={0,0,127}));
  connect(gre.y,and1. u2)
    annotation (Line(points={{1,-450},{20,-450},{20,-408},{38,-408}},
      color={255,0,255}));
  connect(greThr1.y,and1. u1)
    annotation (Line(points={{-59,-400},{38,-400}}, color={255,0,255}));
  connect(and1.y, not1.u)
    annotation (Line(points={{61,-400},{78,-400}}, color={255,0,255}));
  connect(not1.y, swi2.u2)
    annotation (Line(points={{101,-400},{138,-400}}, color={255,0,255}));
  connect(conVolMin.y, swi2.u3)
    annotation (Line(points={{-59,-430},{120,-430},{120,-408},{138,-408}},
      color={0,0,127}));
  connect(swi.y, swi2.u1)
    annotation (Line(points={{101,-280},{120,-280},{120,-392},{138,-392}},
      color={0,0,127}));
  connect(uWin, not2.u)
    annotation (Line(points={{-300,-500},{-242,-500}}, color={255,0,255}));
  connect(not2.y, swi1.u2)
    annotation (Line(points={{-219,-500},{198,-500}}, color={255,0,255}));
  connect(zerFlo.y, swi1.u3)
    annotation (Line(points={{161,-530},{180,-530},{180,-508},{198,-508}},
      color={0,0,127}));
  connect(swi2.y, swi1.u1)
    annotation (Line(points={{161,-400},{180,-400},{180,-492},{198,-492}},
      color={0,0,127}));
  connect(swi1.y, VOccMinAir)
    annotation (Line(points={{221,-500},{240,-500},{240,-290},{300,-290}},
      color={0,0,127}));
  connect(con.y, swi.u2)
    annotation (Line(points={{-59,-260},{-40,-260},{-40,-280},{78,-280}},
      color={255,0,255}));
  connect(minZonAir1.y, swi.u1)
    annotation (Line(points={{41,-50},{60,-50},{60,-272},{78,-272}},
      color={0,0,127}));
  connect(con1.y, swi1.u2)
    annotation (Line(points={{61,-480},{80,-480},{80,-500},{198,-500}},
      color={255,0,255}));
  connect(zerCon3.y, swi.u3)
    annotation (Line(points={{21,-340},{40,-340},{40,-288},{78,-288}},
      color={0,0,127}));
  connect(intEqu.y, swi24.u2)
    annotation (Line(points={{-119,-110},{-110,-110},{-110,200},{-102,200}},
      color={255,0,255}));
  connect(intEqu.y, swi25.u2)
    annotation (Line(points={{-119,-110},{-110,-110},{-110,170},{-102,170}},
      color={255,0,255}));
  connect(intEqu.y, swi26.u2)
    annotation (Line(points={{-119,-110},{-110,-110},{-110,140},{-102,140}},
      color={255,0,255}));
  connect(intEqu.y, swi27.u2)
    annotation (Line(points={{-119,-110},{-110,-110},{-110,110},{-102,110}},
      color={255,0,255}));
  connect(intEqu.y, swi28.u2)
    annotation (Line(points={{-119,-110},{-110,-110},{-110,80},{-102,80}},
      color={255,0,255}));
  connect(cooMaxAir.y, swi24.u1)
    annotation (Line(points={{-219,30},{-204,30},{-204,56},{-140,56},{-140,208},
      {-102,208}}, color={0,0,127}));
  connect(heaMaxAir.y, maxInp.u2)
    annotation (Line(points={{-159,30},{-120,30},{-120,24},{-102,24}},
      color={0,0,127}));
  connect(maxInp.y, swi28.u1)
    annotation (Line(points={{-79,30},{-60,30},{-60,62},{-124,62},{-124,88},{-102,88}},
      color={0,0,127}));
  connect(zerCon6.y, swi24.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,192},{-102,192}},
      color={0,0,127}));
  connect(zerCon6.y, swi25.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,162},{-102,162}},
      color={0,0,127}));
  connect(zerCon6.y, swi26.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,132},{-102,132}},
      color={0,0,127}));
  connect(zerCon6.y, swi27.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,102},{-102,102}},
      color={0,0,127}));
  connect(zerCon6.y, swi28.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,72},{-102,72}},
      color={0,0,127}));
  connect(uOpeMod, intEqu1.u2)
    annotation (Line(points={{-300,-110},{-180,-110},{-180,-10},{-200,-10},{-200,512},
      {-182,512}}, color={255,127,0}));
  connect(uOpeMod, intEqu2.u2)
    annotation (Line(points={{-300,-110},{-180,-110},{-180,-10},{-200,-10},{-200,352},
      {-182,352}}, color={255,127,0}));
  connect(uOpeMod, intEqu4.u2)
    annotation (Line(points={{-300,-110},{-180,-110},{-180,-10},{20,-10},{20,352},
      {38,352}}, color={255,127,0}));
  connect(uOpeMod, intEqu3.u2)
    annotation (Line(points={{-300,-110},{-180,-110},{-180,-10},{20,-10},{20,512},
      {38,512}}, color={255,127,0}));
  connect(conInt1.y, intEqu1.u1)
    annotation (Line(points={{-219,520},{-182,520}}, color={255,127,0}));
  connect(conInt2.y, intEqu2.u1)
    annotation (Line(points={{-219,360},{-182,360}}, color={255,127,0}));
  connect(conInt4.y, intEqu4.u1)
    annotation (Line(points={{1,360},{38,360}}, color={255,127,0}));
  connect(conInt3.y, intEqu3.u1)
    annotation (Line(points={{1,520},{38,520}}, color={255,127,0}));
  connect(cooMaxAir.y, swi4.u1)
    annotation (Line(points={{-219,30},{-204,30},{-204,56},{-140,56},{-140,528},
      {-102,528}}, color={0,0,127}));
  connect(heaMaxAir.y, swi8.u1)
    annotation (Line(points={{-159,30},{-134,30},{-134,408},{-102,408}},
      color={0,0,127}));
  connect(intEqu1.y, swi4.u2)
    annotation (Line(points={{-159,520},{-102,520}}, color={255,0,255}));
  connect(intEqu1.y, swi5.u2)
    annotation (Line(points={{-159,520},{-112,520},{-112,490},{-102,490}},
      color={255,0,255}));
  connect(intEqu1.y, swi6.u2)
    annotation (Line(points={{-159,520},{-112,520},{-112,460},{-102,460}},
      color={255,0,255}));
  connect(intEqu1.y, swi7.u2)
    annotation (Line(points={{-159,520},{-112,520},{-112,430},{-102,430}},
      color={255,0,255}));
  connect(intEqu1.y, swi8.u2)
    annotation (Line(points={{-159,520},{-112,520},{-112,400},{-102,400}},
      color={255,0,255}));
  connect(zerCon6.y, swi4.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,512},{-102,512}},
      color={0,0,127}));
  connect(zerCon6.y, swi5.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,482},{-102,482}},
      color={0,0,127}));
  connect(zerCon6.y, swi6.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,452},{-102,452}},
      color={0,0,127}));
  connect(zerCon6.y, swi7.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,422},{-102,422}},
      color={0,0,127}));
  connect(zerCon6.y, swi8.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,392},{-102,392}},
      color={0,0,127}));
  connect(zerCon6.y, swi5.u1)
    annotation (Line(points={{-219,220},{-120,220},{-120,498},{-102,498}},
      color={0,0,127}));
  connect(zerCon6.y, swi6.u1)
    annotation (Line(points={{-219,220},{-120,220},{-120,468},{-102,468}},
      color={0,0,127}));
  connect(zerCon6.y, swi7.u1)
    annotation (Line(points={{-219,220},{-120,220},{-120,438},{-102,438}},
      color={0,0,127}));
  connect(cooMaxAir.y, swi9.u1)
    annotation (Line(points={{-219,30},{-204,30},{-204,56},{-140,56},{-140,368},{-102,368}},
      color={0,0,127}));
  connect(intEqu2.y, swi9.u2)
    annotation (Line(points={{-159,360},{-102,360}}, color={255,0,255}));
  connect(intEqu2.y, swi10.u2)
    annotation (Line(points={{-159,360},{-112,360},{-112,330},{-102,330}},
      color={255,0,255}));
  connect(intEqu2.y, swi11.u2)
    annotation (Line(points={{-159,360},{-112,360},{-112,300},{-102,300}},
      color={255,0,255}));
  connect(intEqu2.y, swi12.u2)
    annotation (Line(points={{-159,360},{-112,360},{-112,270},{-102,270}},
      color={255,0,255}));
  connect(intEqu2.y, swi13.u2)
    annotation (Line(points={{-159,360},{-112,360},{-112,240},{-102,240}},
      color={255,0,255}));
  connect(zerCon6.y, swi9.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,352},{-102,352}},
      color={0,0,127}));
  connect(zerCon6.y, swi10.u1)
    annotation (Line(points={{-219,220},{-120,220},{-120,338},{-102,338}},
      color={0,0,127}));
  connect(zerCon6.y, swi10.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,322},{-102,322}},
      color={0,0,127}));
  connect(zerCon6.y, swi11.u1)
    annotation (Line(points={{-219,220},{-120,220},{-120,308},{-102,308}},
      color={0,0,127}));
  connect(zerCon6.y, swi11.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,292},{-102,292}},
      color={0,0,127}));
  connect(zerCon6.y, swi12.u1)
    annotation (Line(points={{-219,220},{-120,220},{-120,278},{-102,278}},
      color={0,0,127}));
  connect(zerCon6.y, swi12.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,262},{-102,262}},
      color={0,0,127}));
  connect(zerCon6.y, swi13.u1)
    annotation (Line(points={{-219,220},{-120,220},{-120,248},{-102,248}},
      color={0,0,127}));
  connect(zerCon6.y, swi13.u3)
    annotation (Line(points={{-219,220},{-120,220},{-120,232},{-102,232}},
      color={0,0,127}));
  connect(intEqu3.y, swi14.u2)
    annotation (Line(points={{61,520},{118,520}}, color={255,0,255}));
  connect(intEqu3.y, swi15.u2)
    annotation (Line(points={{61,520},{108,520},{108,490},{118,490}},
      color={255,0,255}));
  connect(intEqu3.y, swi16.u2)
    annotation (Line(points={{61,520},{108,520},{108,460},{118,460}},
      color={255,0,255}));
  connect(intEqu3.y, swi17.u2)
    annotation (Line(points={{61,520},{108,520},{108,430},{118,430}},
      color={255,0,255}));
  connect(intEqu3.y, swi18.u2)
    annotation (Line(points={{61,520},{108,520},{108,400},{118,400}},
      color={255,0,255}));
  connect(intEqu4.y, swi19.u2)
    annotation (Line(points={{61,360},{118,360}}, color={255,0,255}));
  connect(intEqu4.y, swi20.u2)
    annotation (Line(points={{61,360},{108,360},{108,330},{118,330}},
      color={255,0,255}));
  connect(intEqu4.y, swi21.u2)
    annotation (Line(points={{61,360},{108,360},{108,300},{118,300}},
      color={255,0,255}));
  connect(intEqu4.y, swi22.u2)
    annotation (Line(points={{61,360},{108,360},{108,270},{118,270}},
      color={255,0,255}));
  connect(intEqu4.y, swi23.u2)
    annotation (Line(points={{61,360},{108,360},{108,240},{118,240}},
      color={255,0,255}));
  connect(zerCon6.y, swi14.u1)
    annotation (Line(points={{-219,220},{100,220},{100,528},{118,528}},
      color={0,0,127}));
  connect(zerCon6.y, swi14.u3)
    annotation (Line(points={{-219,220},{100,220},{100,512},{118,512}},
      color={0,0,127}));
  connect(zerCon6.y, swi15.u1)
    annotation (Line(points={{-219,220},{100,220},{100,498},{118,498}},
      color={0,0,127}));
  connect(zerCon6.y, swi15.u3)
    annotation (Line(points={{-219,220},{100,220},{100,482},{118,482}},
      color={0,0,127}));
  connect(zerCon6.y, swi16.u1)
    annotation (Line(points={{-219,220},{100,220},{100,468},{118,468}},
      color={0,0,127}));
  connect(zerCon6.y, swi16.u3)
    annotation (Line(points={{-219,220},{100,220},{100,452},{118,452}},
      color={0,0,127}));
  connect(heaMaxAir.y, swi17.u1)
    annotation (Line(points={{-159,30},{-134,30},{-134,50},{86,50},{86,438},{118,438}},
      color={0,0,127}));
  connect(cooMaxAir.y, swi18.u1)
    annotation (Line(points={{-219,30},{-204,30},{-204,56},{80,56},{80,408},{118,408}},
      color={0,0,127}));
  connect(zerCon6.y, swi17.u3)
    annotation (Line(points={{-219,220},{100,220},{100,422},{118,422}},
      color={0,0,127}));
  connect(zerCon6.y, swi18.u3)
    annotation (Line(points={{-219,220},{100,220},{100,392},{118,392}},
      color={0,0,127}));
  connect(zerCon6.y, swi19.u1)
    annotation (Line(points={{-219,220},{100,220},{100,368},{118,368}},
      color={0,0,127}));
  connect(zerCon6.y, swi19.u3)
    annotation (Line(points={{-219,220},{100,220},{100,352},{118,352}},
      color={0,0,127}));
  connect(zerCon6.y, swi20.u1)
    annotation (Line(points={{-219,220},{100,220},{100,338},{118,338}},
      color={0,0,127}));
  connect(zerCon6.y, swi20.u3)
    annotation (Line(points={{-219,220},{100,220},{100,322},{118,322}},
      color={0,0,127}));
  connect(zerCon6.y, swi21.u1)
    annotation (Line(points={{-219,220},{100,220},{100,308},{118,308}},
      color={0,0,127}));
  connect(zerCon6.y, swi21.u3)
    annotation (Line(points={{-219,220},{100,220},{100,292},{118,292}},
      color={0,0,127}));
  connect(zerCon6.y, swi22.u3)
    annotation (Line(points={{-219,220},{100,220},{100,262},{118,262}},
      color={0,0,127}));
  connect(zerCon6.y, swi23.u3)
    annotation (Line(points={{-219,220},{100,220},{100,232},{118,232}},
      color={0,0,127}));
  connect(heaMaxAir.y, swi22.u1)
    annotation (Line(points={{-159,30},{-134,30},{-134,50},{86,50},{86,278},{118,278}},
      color={0,0,127}));
  connect(cooMaxAir.y, swi23.u1)
    annotation (Line(points={{-219,30},{-204,30},{-204,56},{80,56},{80,248},{118,248}},
      color={0,0,127}));
  connect(swi24.y, actCooMaxAir.u[1])
    annotation (Line(points={{-79,200},{60,200},{60,215.6},{218,215.6}},
      color={0,0,127}));
  connect(swi25.y, actCooMinAir.u[1])
    annotation (Line(points={{-79,170},{60,170},{60,185.6},{218,185.6}},
      color={0,0,127}));
  connect(swi26.y, actMinAir.u[1])
    annotation (Line(points={{-79,140},{60,140},{60,155.6},{218,155.6}},
      color={0,0,127}));
  connect(swi27.y, actHeaMinAir.u[1])
    annotation (Line(points={{-79,110},{60,110},{60,115.6},{218,115.6}},
      color={0,0,127}));
  connect(swi28.y, actHeaMaxAir.u[1])
    annotation (Line(points={{-79,80},{60,80},{60,75.6},{218,75.6}},
      color={0,0,127}));
  connect(swi4.y, actCooMaxAir.u[2])
    annotation (Line(points={{-79,520},{-28,520},{-28,212.8},{218,212.8}},
      color={0,0,127}));
  connect(swi5.y, actCooMinAir.u[2])
    annotation (Line(points={{-79,490},{-32,490},{-32,182.8},{218,182.8}},
      color={0,0,127}));
  connect(swi6.y, actMinAir.u[2])
    annotation (Line(points={{-79,460},{-36,460},{-36,152.8},{218,152.8}},
      color={0,0,127}));
  connect(swi7.y, actHeaMinAir.u[2])
    annotation (Line(points={{-79,430},{-40,430},{-40,112.8},{218,112.8}},
      color={0,0,127}));
  connect(swi8.y, actHeaMaxAir.u[2])
    annotation (Line(points={{-79,400},{-44,400},{-44,72.8},{218,72.8}},
      color={0,0,127}));
  connect(swi9.y, actCooMaxAir.u[3])
    annotation (Line(points={{-79,360},{-48,360},{-48,210},{218,210}},
      color={0,0,127}));
  connect(swi10.y, actCooMinAir.u[3])
    annotation (Line(points={{-79,330},{-52,330},{-52,180},{218,180}},
      color={0,0,127}));
  connect(swi11.y, actMinAir.u[3])
    annotation (Line(points={{-79,300},{-56,300},{-56,150},{218,150}},
      color={0,0,127}));
  connect(swi12.y, actHeaMinAir.u[3])
    annotation (Line(points={{-79,270},{-60,270},{-60,110},{218,110}},
      color={0,0,127}));
  connect(swi13.y, actHeaMaxAir.u[3])
    annotation (Line(points={{-79,240},{-64,240},{-64,70},{218,70}},
      color={0,0,127}));
  connect(swi14.y, actCooMaxAir.u[4])
    annotation (Line(points={{141,520},{206,520},{206,207.2},{218,207.2}},
      color={0,0,127}));
  connect(swi15.y, actCooMinAir.u[4])
    annotation (Line(points={{141,490},{202,490},{202,177.2},{218,177.2}},
      color={0,0,127}));
  connect(swi16.y, actMinAir.u[4])
    annotation (Line(points={{141,460},{198,460},{198,147.2},{218,147.2}},
      color={0,0,127}));
  connect(swi17.y, actHeaMinAir.u[4])
    annotation (Line(points={{141,430},{194,430},{194,107.2},{218,107.2}},
      color={0,0,127}));
  connect(swi18.y, actHeaMaxAir.u[4])
    annotation (Line(points={{141,400},{190,400},{190,67.2},{218,67.2}},
      color={0,0,127}));
  connect(swi19.y, actCooMaxAir.u[5])
    annotation (Line(points={{141,360},{184,360},{184,204.4},{218,204.4}},
      color={0,0,127}));
  connect(swi20.y, actCooMinAir.u[5])
    annotation (Line(points={{141,330},{180,330},{180,174.4},{218,174.4}},
      color={0,0,127}));
  connect(swi21.y, actMinAir.u[5])
    annotation (Line(points={{141,300},{176,300},{176,144.4},{218,144.4}},
      color={0,0,127}));
  connect(swi22.y, actHeaMinAir.u[5])
    annotation (Line(points={{141,270},{172,270},{172,104.4},{218,104.4}},
      color={0,0,127}));
  connect(swi23.y, actHeaMaxAir.u[5])
    annotation (Line(points={{141,240},{168,240},{168,64.4},{218,64.4}},
      color={0,0,127}));
  connect(swi1.y, swi25.u1)
    annotation (Line(points={{221,-500},{240,-500},{240,-16},{-128,-16},{-128,178},
      {-102,178}}, color={0,0,127}));
  connect(swi1.y, swi26.u1)
    annotation (Line(points={{221,-500},{240,-500},{240,-16},{-128,-16},{-128,148},
      {-102,148}}, color={0,0,127}));
  connect(swi1.y, swi27.u1)
    annotation (Line(points={{221,-500},{240,-500},{240,-16},{-128,-16},{-128,118},
      {-102,118}}, color={0,0,127}));
  connect(swi1.y, maxInp.u1)
    annotation (Line(points={{221,-500},{240,-500},{240,-16},{-128,-16},{-128,36},
      {-102,36}}, color={0,0,127}));
  connect(actCooMaxAir.y, VActCooMax)
    annotation (Line(points={{241.7,210},{300,210}},
      color={0,0,127}));
  connect(actCooMinAir.y, VActCooMin)
    annotation (Line(points={{241.7,180},{260,180},{260,170},{300,170}},
      color={0,0,127}));
  connect(actMinAir.y, VActMin)
    annotation (Line(points={{241.7,150},{260,150},{260,130},{300,130}},
      color={0,0,127}));
  connect(actHeaMinAir.y, VActHeaMin)
    annotation (Line(points={{241.7,110},{260,110},{260,90},{300,90}},
      color={0,0,127}));
  connect(actHeaMaxAir.y, VActHeaMax)
    annotation (Line(points={{241.7,70},{256,70},{256,50},{300,50}},
      color={0,0,127}));

annotation (
  defaultComponentName="airSetReh",
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-560},{280,560}}),
        graphics={                   Rectangle(
          extent={{-258,-62},{258,-240}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-258,-250},{258,-374}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Rectangle(
          extent={{-258,-380},{258,-462}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{76,-56},{274,-92}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Occupied min airflow:
reset based on CO2 control"),
       Text(extent={{116,-234},{332,-294}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          textString="Occupied min airflow:
reset based on occupancy",
          horizontalAlignment=TextAlignment.Left),
       Text(extent={{-194,-512},{-58,-544}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          textString="Reset based on window status"),
        Text(extent={{-256,-360},{26,-482}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Occupied min airflow:
define based on controllable minimum"),
                                     Rectangle(
          extent={{-258,-470},{258,-552}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(extent={{-190,-492},{32,-564}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Occupied min airflow:
reset based on window status"),      Rectangle(
          extent={{-258,538},{258,2}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{76,48},{298,4}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Define active setpoints
according to operation modes")}),
     Icon(
        graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-62,66},{58,-56}},
          lineColor={0,0,0},
          textString="occMinAir"),
        Text(
          extent={{-98,66},{-70,54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="CO2"),
        Text(
          extent={{-96,26},{-68,14}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="nOcc"),
        Text(
          extent={{-96,-22},{-50,-40}},
          lineColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          extent={{-98,-64},{-72,-74}},
          lineColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWin"),
        Text(
          extent={{62,88},{98,74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax"),
        Text(
          extent={{62,58},{98,44}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMin"),
        Text(
          extent={{72,24},{98,14}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin"),
        Text(
          extent={{62,-2},{98,-16}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMin"),
        Text(
          extent={{62,-32},{98,-46}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax"),
        Text(
          extent={{62,-72},{98,-86}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOccMinAir")}),
Documentation(info="<html>
<p>
This sequence sets the active minimum and maximum setpoints <code>VActCooMin</code>,
<code>VActCooMax</code>, <code>VActHeaMin</code>,
<code>VActHeaMax</code> and <code>VActMin</code> for a VAV reheat terminal unit
according to ASHRAE Guideline 36 (G36), PART5.E.3-5.
</p>
<h4>1. Information to be provided by designer</h4>
According to G36 PART 3.1.B.2, following VAV box design information should be
provided:
<ul>
<li>Zone maximum cooling airflow setpoint <code>VCooMax</code></li>
<li>Zone minimum airflow setpoint <code>VMin</code></li>
<li>Zone maximum heating airflow setpoint <code>VHeaMax</code></li>
<li>Zone maximum discharge air temperature above heating setpoint <code>maxDTemDis</code></li>
</ul>

<h4>2. Occupied minimum airflow <code>VOccMinAir</code></h4>
The occupied minimum airflow <code>VOccMinAir</code> shall be
equal to zone minimum airflow setpoint
<code>VMin</code> except as follows:
<ul>
<li>
If the zone has an occupancy sensor, <code>VOccMinAir</code> shall be equal to
the minimum breathing zone outdoor airflow (if ventilation is according to ASHRAE
Standard 62.1-2013) or the zone minimum outdoor airflow for building area
(if ventilation is according to California Title 24) when the room is unpopulated.
</li>
<li>
If the zone has a window switch, <code>VOccMinAir</code> shall be zero when the
window is open.
</li>
<li>
If <code>VMin</code> is non-zero and less than the lowest possible airflow setpoint
allowed by the controls <code>VMinCon</code>, <code>VOccMinAir</code> shall be set
equal to <code>VMinCon</code>.
</li>
<li>
If the zone has a CO2 sensor, then following steps are applied for calculating
<code>VOccMinAir</code>.
<ul>
<li>During occupied mode, a P-only loop shall maintain
the CO2 concentration at setpoint, reset 0% at (CO2 setpoint <code>co2Set</code> -
200 ppm) and 100% at <code>co2Set</code>. If ventilation outdoor airflow is controlled
in accordance with ASHRAE Standard 62.1-2013, the loop output shall reset the
<code>VOccMinAir</code> from <code>VMin</code> at 0% loop output up to <code>VCooMax</code>
at 100% loop output;
</li>
<li>
The loop is diabled and its output set to zero when the zone is
not in occupied mode.
</li>
</ul>
</li>
</ul>
<p align=\"center\">
<img alt=\"Image of occupied minimum airflow reset with CO2 control\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/Atomic/OccMinAirRehBox.png\"/>
</p>

<h4>3. Active maximum and minimum setpoints</h4>
The setpoints shall vary depending on the mode of the zone group.
<table summary=\"summary\" border=\"1\">
<tr><th>Setpoint</th> <th>Occupied</th><th>Cool-down</th>
<th>Setup</th><th>Warmup</th><th>Setback</th><th>Unoccupied</th></tr>
<tr><td>Cooling maximum (VActCooMax)</td><td>VCooMax</td><td>VCooMax</td>
<td>VCooMax</td><td>0</td><td>0</td><td>0</td></tr>
<tr><td>Cooling minimum (VActCooMin)</td><td>VOccMinAir</td><td>0</td>
<td>0</td><td>0</td><td>0</td><td>0</td></tr>
<tr><td>Minimum (VActMin)</td><td>VOccMinAir</td><td>0</td>
<td>0</td><td>0</td><td>0</td><td>0</td></tr>
<tr><td>Heating minimum (VActHeaMin)</td><td>VOccMinAir</td><td>0</td>
<td>0</td><td>VHeaMax</td><td>VHeaMax</td><td>0</td></tr>
<tr><td>Heating maximum (VActHeaMax)</td><td>max(VHeaMax,VOccMinAir)</td>
<td>VHeaMax</td><td>0</td><td>VCooMax</td><td>VCooMax</td><td>0</td></tr>
</table>
<br/>

<h4>References</h4>
<p>
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR (ANSI Board of
Standards Review)/ASHRAE Guideline 36P,
<i>High Performance Sequences of Operation for HVAC systems</i>.
First Public Review Draft (June 2016)</a>
</p>

</html>", revisions="<html>
<ul>
<li>
September 7, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActiveAirflowSetpointReheatBox;
