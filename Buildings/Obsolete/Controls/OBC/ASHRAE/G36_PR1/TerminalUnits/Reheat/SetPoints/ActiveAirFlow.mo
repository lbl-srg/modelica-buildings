within Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints;
block ActiveAirFlow
  "Output the active airflow setpoint for VAV reheat terminal unit"

  parameter Boolean have_occSen
    "Set to true if the zone has occupancy sensor"
    annotation(Dialog(group="Zone sensors"));
  parameter Boolean have_winSen
    "Set to true if the zone has window status sensor"
    annotation(Dialog(group="Zone sensors"));
  parameter Boolean have_CO2Sen
    "Set to true if the zone has CO2 sensor"
    annotation(Dialog(group="Zone sensors"));
  parameter Real VDisCooSetMax_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Zone maximum cooling airflow setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Real VDisSetMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Zone minimum airflow setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Real VDisHeaSetMax_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Zone maximum heating airflow setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Real VDisConMin_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "VAV box controllable minimum"
    annotation(Dialog(group="Nominal condition"));
  parameter Real AFlo(
    final unit="m2",
    final quantity="Area") "Area of the zone"
    annotation(Dialog(group="Nominal condition"));
  parameter Real VOutPerAre_flow(
    final unit = "m3/(s.m2)")=3e-4
    "Outdoor air rate per unit area"
    annotation(Dialog(group="Nominal condition"));
  parameter Real VOutPerPer_flow(
    final unit="m3/s",
    final quantity="VolumeFlowRate")=2.5e-3
    "Outdoor air rate per person"
    annotation(Dialog(group="Nominal condition"));
  parameter Real CO2Set = 894 "CO2 setpoint in ppm"
    annotation(Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc(final unit="1") if have_occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-320,-300},{-280,-260}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 conventration"
    annotation (Placement(transformation(extent={{-320,-200},{-280,-160}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-320,-520},{-280,-480}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-320,-130},{-280,-90}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOccDisMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Occupied minimum airflow "
    annotation (Placement(transformation(extent={{280,-310},{320,-270}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active cooling maximum"
    annotation (Placement(transformation(extent={{280,150},{320,190}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActCooMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active cooling minimum"
    annotation (Placement(transformation(extent={{280,120},{320,160}}),
        iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active minimum"
    annotation (Placement(transformation(extent={{280,90},{320,130}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActHeaMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active heating minimum"
    annotation (Placement(transformation(extent={{280,50},{320,90}}),
        iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActHeaMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active heating maximum"
    annotation (Placement(transformation(extent={{280,10},{320,50}}),
        iconTransformation(extent={{100,-60},{140,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=VOutPerPer_flow) if have_occSen "Outdoor air per person"
    annotation (Placement(transformation(extent={{-140,-330},{-120,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.Add breZon if have_occSen
    "Breathing zone airflow"
    annotation (Placement(transformation(extent={{-80,-350},{-60,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.Line co2ConLoo if have_CO2Sen
    "Maintain CO2 concentration at setpoint, reset 0% at (setpoint-200) and 100% at setpoint"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin1 if have_CO2Sen
    "Reset occupied minimum airflow setpoint from 0% at VDisSetMin_flow and 100% at VDisCooSetMax_flow"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre
    "Check if zone minimum airflow setpoint Vmin is less than the allowed controllable VDisConMin_flow"
    annotation (Placement(transformation(extent={{-20,-460},{0,-440}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1
    "Check if zone minimum airflow setpoint VDisSetMin_flow is non-zero"
    annotation (Placement(transformation(extent={{-80,-410},{-60,-390}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Reset occupied minimum airflow according to occupancy"
    annotation (Placement(transformation(extent={{80,-290},{100,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Reset occupied minimum airflow according to window status"
    annotation (Placement(transformation(extent={{200,-510},{220,-490}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Reset occupied minimum airflow setpoint according to minimum controllable airflow"
    annotation (Placement(transformation(extent={{140,-410},{160,-390}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi3 if have_CO2Sen
    "Switch between zero signal and CO2 control loop signal depending on the operation mode"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{40,-410},{60,-390}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{80,-410},{100,-390}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 if have_winSen "Logical not"
    annotation (Placement(transformation(extent={{-240,-510},{-220,-490}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(
    final t=0.75,
    final h=0.5) if have_occSen
    "Check if the zone becomes unpopulated"
    annotation (Placement(transformation(extent={{-140,-290},{-120,-270}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minZonAir1(
    final k=VDisSetMin_flow) if not have_CO2Sen
    "Zone minimum airflow setpoint"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxZonCooAir(
    final k=VDisCooSetMax_flow) if have_CO2Sen
    "Zone maximum cooling airflow setpoint"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant breZonAre(
    final k=VOutPerAre_flow*AFlo) if have_occSen
    "Area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-140,-370},{-120,-350}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conVolMin(
    final k=VDisConMin_flow)
    "VAV box controllable minimum"
    annotation (Placement(transformation(extent={{-80,-440},{-60,-420}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minZonAir(
    final k=VDisSetMin_flow)
    "Zone minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-240,-60},{-220,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setCO1(
    final k=CO2Set - 200) if have_CO2Sen
    "CO2 setpoints minus 200"
    annotation (Placement(transformation(extent={{-240,-140},{-220,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setCO2(
    final k=CO2Set) if have_CO2Sen
    "CO2 setpoints"
    annotation (Placement(transformation(extent={{-240,-210},{-220,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerFlo(final k=0)
    "Zero airflow when window is open"
    annotation (Placement(transformation(extent={{140,-540},{160,-520}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=true) if not have_occSen "Constant true"
    annotation (Placement(transformation(extent={{-80,-270},{-60,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=true) if not have_winSen "Constant true"
    annotation (Placement(transformation(extent={{40,-490},{60,-470}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerCon(
    final k=0) "Output zero"
    annotation (Placement(transformation(extent={{-240,-170},{-220,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerCon1(
    final k=0) if have_CO2Sen
    "Output zero"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerCon2(
    final k=0) if have_CO2Sen
    "Output zero"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerCon3(
    final k=0) if not have_occSen
    "Output zero"
    annotation (Placement(transformation(extent={{0,-350},{20,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneCon(
    final k=1) if have_CO2Sen
    "Output one"
    annotation (Placement(transformation(extent={{-240,-240},{-220,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneCon1(
    final k=1) if have_CO2Sen "Output one"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooMaxAir(
    final k=VDisCooSetMax_flow)
    "Cooling maximum airflow"
    annotation (Placement(transformation(extent={{-240,-20},{-220,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaMaxAir(
    final k=VDisHeaSetMax_flow)
    "Heat maximum airflow"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerCon6(
    final k=0)
    "Output zero"
    annotation (Placement(transformation(extent={{-240,170},{-220,190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-240,-100},{-220,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.coolDown)
    "Cool down mode"
    annotation (Placement(transformation(extent={{-240,290},{-220,310}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setUp)
    "Setup mode"
    annotation (Placement(transformation(extent={{-240,220},{-220,240}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.warmUp)
    "Warm up mode"
    annotation (Placement(transformation(extent={{-20,290},{0,310}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setBack)
    "Setback mode"
    annotation (Placement(transformation(extent={{-20,220},{0,240}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if current operation mode is cool-down mode"
    annotation (Placement(transformation(extent={{-180,290},{-160,310}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    "Check if current operation mode is setup mode"
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Check if current operation mode is warmup mode"
    annotation (Placement(transformation(extent={{40,290},{60,310}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4
    "Check if current operation mode is setback mode"
    annotation (Placement(transformation(extent={{40,220},{60,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi4
    "Select cooling maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,290},{-80,310}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi8
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,260},{-80,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi9
    "Select cooling maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,220},{-80,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi17
    "Select heating minimum based on operation mode"
    annotation (Placement(transformation(extent={{120,290},{140,310}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi18
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{120,260},{140,280}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi22
    "Select heating minimum based on operation mode"
    annotation (Placement(transformation(extent={{120,220},{140,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi23
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{120,190},{140,210}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi24
    "Select cooling maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi25
    "Select cooling minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi26
    "Select minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi27
    "Select heating minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi28
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Max maxInp "Find greater input"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2 "Add real input"
    annotation (Placement(transformation(extent={{200,170},{220,190}})));
  Buildings.Controls.OBC.CDL.Continuous.Add actCooMaxAir
    "Active cooling maximum airflow"
    annotation (Placement(transformation(extent={{240,160},{260,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1 "Add real input"
    annotation (Placement(transformation(extent={{200,80},{220,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Add actHeaMinAir
    "Active heating minimum airflow"
    annotation (Placement(transformation(extent={{240,60},{260,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3 "Add real input"
    annotation (Placement(transformation(extent={{180,40},{200,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Add actHeaMaxAir1
    "Active heating maximum airflow"
    annotation (Placement(transformation(extent={{240,20},{260,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add4 "Add real input"
    annotation (Placement(transformation(extent={{180,0},{200,20}})));

equation
  connect(conVolMin.y, gre.u1)
    annotation (Line(points={{-58,-430},{-40,-430},{-40,-450},{-22,-450}},
      color={0,0,127}));
  connect(setCO1.y, co2ConLoo.x1)
    annotation (Line(points={{-218,-130},{-160,-130},{-160,-172},{-142,-172}},
      color={0,0,127}));
  connect(zerCon.y, co2ConLoo.f1)
    annotation (Line(points={{-218,-160},{-180,-160},{-180,-176},{-142,-176}},
      color={0,0,127}));
  connect(ppmCO2, co2ConLoo.u)
    annotation (Line(points={{-300,-180},{-142,-180}},
      color={0,0,127}));
  connect(setCO2.y, co2ConLoo.x2)
    annotation (Line(points={{-218,-200},{-180,-200},{-180,-184},{-142,-184}},
      color={0,0,127}));
  connect(oneCon.y, co2ConLoo.f2)
    annotation (Line(points={{-218,-230},{-160,-230},{-160,-188},{-142,-188}},
      color={0,0,127}));
  connect(zerCon1.y, lin1.x1)
    annotation (Line(points={{-58,-80},{0,-80},{0,-112},{18,-112}},
      color={0,0,127}));
  connect(oneCon1.y, lin1.x2)
    annotation (Line(points={{-58,-150},{-20,-150},{-20,-124},{18,-124}},
      color={0,0,127}));
  connect(maxZonCooAir.y, lin1.f2)
    annotation (Line(points={{-58,-180},{0,-180},{0,-128},{18,-128}},
      color={0,0,127}));
  connect(minZonAir.y, lin1.f1)
    annotation (Line(points={{-218,-50},{-20,-50},{-20,-116},{18,-116}},
      color={0,0,127}));
  connect(intEqu.y, swi3.u2)
    annotation (Line(points={{-118,-110},{-82,-110}},
      color={255,0,255}));
  connect(co2ConLoo.y, swi3.u1)
    annotation (Line(points={{-118,-180},{-100,-180},{-100,-118},{-82,-118}},
      color={0,0,127}));
  connect(swi3.y, lin1.u)
    annotation (Line(points={{-58,-110},{-40,-110},{-40,-120},{18,-120}},
      color={0,0,127}));
  connect(zerCon2.y, swi3.u3)
    annotation (Line(points={{-118,-80},{-100,-80},{-100,-102},{-82,-102}},
      color={0,0,127}));
  connect(uOpeMod, intEqu.u2)
    annotation (Line(points={{-300,-110},{-180,-110},{-180,-118},{-142,-118}},
      color={255,127,0}));
  connect(conInt.y, intEqu.u1)
    annotation (Line(points={{-218,-90},{-160,-90},{-160,-110},{-142,-110}},
      color={255,127,0}));
  connect(nOcc, gai.u)
    annotation (Line(points={{-300,-280},{-160,-280},{-160,-320},{-142,-320}},
      color={0,0,127}));
  connect(breZonAre.y, breZon.u2)
    annotation (Line(points={{-118,-360},{-100,-360},{-100,-346},{-82,-346}},
      color={0,0,127}));
  connect(gai.y, breZon.u1)
    annotation (Line(points={{-118,-320},{-100,-320},{-100,-334},{-82,-334}},
      color={0,0,127}));
  connect(breZon.y, swi.u3)
    annotation (Line(points={{-58,-340},{-20,-340},{-20,-288},{78,-288}},
      color={0,0,127}));
  connect(lin1.y, swi.u1)
    annotation (Line(points={{42,-120},{60,-120},{60,-272},{78,-272}},
      color={0,0,127}));
  connect(minZonAir.y, greThr1.u)
    annotation (Line(points={{-218,-50},{-200,-50},{-200,-400},{-82,-400}},
      color={0,0,127}));
  connect(minZonAir.y, gre.u2)
    annotation (Line(points={{-218,-50},{-200,-50},{-200,-458},{-22,-458}},
      color={0,0,127}));
  connect(gre.y,and1. u2)
    annotation (Line(points={{2,-450},{20,-450},{20,-408},{38,-408}},
      color={255,0,255}));
  connect(greThr1.y,and1. u1)
    annotation (Line(points={{-58,-400},{38,-400}}, color={255,0,255}));
  connect(and1.y, not1.u)
    annotation (Line(points={{62,-400},{78,-400}}, color={255,0,255}));
  connect(not1.y, swi2.u2)
    annotation (Line(points={{102,-400},{138,-400}}, color={255,0,255}));
  connect(conVolMin.y, swi2.u3)
    annotation (Line(points={{-58,-430},{120,-430},{120,-408},{138,-408}},
      color={0,0,127}));
  connect(swi.y, swi2.u1)
    annotation (Line(points={{102,-280},{120,-280},{120,-392},{138,-392}},
      color={0,0,127}));
  connect(uWin, not2.u)
    annotation (Line(points={{-300,-500},{-242,-500}}, color={255,0,255}));
  connect(not2.y, swi1.u2)
    annotation (Line(points={{-218,-500},{198,-500}}, color={255,0,255}));
  connect(zerFlo.y, swi1.u3)
    annotation (Line(points={{162,-530},{180,-530},{180,-508},{198,-508}},
      color={0,0,127}));
  connect(swi2.y, swi1.u1)
    annotation (Line(points={{162,-400},{180,-400},{180,-492},{198,-492}},
      color={0,0,127}));
  connect(swi1.y, VOccDisMin_flow)
    annotation (Line(points={{222,-500},{240,-500},{240,-290},{300,-290}},
      color={0,0,127}));
  connect(con.y, swi.u2)
    annotation (Line(points={{-58,-260},{-40,-260},{-40,-280},{78,-280}},
      color={255,0,255}));
  connect(minZonAir1.y, swi.u1)
    annotation (Line(points={{42,-50},{60,-50},{60,-272},{78,-272}},
      color={0,0,127}));
  connect(con1.y, swi1.u2)
    annotation (Line(points={{62,-480},{80,-480},{80,-500},{198,-500}},
      color={255,0,255}));
  connect(zerCon3.y, swi.u3)
    annotation (Line(points={{22,-340},{40,-340},{40,-288},{78,-288}},
      color={0,0,127}));
  connect(intEqu.y, swi24.u2)
    annotation (Line(points={{-118,-110},{-110,-110},{-110,160},{-102,160}},
      color={255,0,255}));
  connect(intEqu.y, swi25.u2)
    annotation (Line(points={{-118,-110},{-110,-110},{-110,130},{-102,130}},
      color={255,0,255}));
  connect(intEqu.y, swi26.u2)
    annotation (Line(points={{-118,-110},{-110,-110},{-110,100},{-102,100}},
      color={255,0,255}));
  connect(intEqu.y, swi27.u2)
    annotation (Line(points={{-118,-110},{-110,-110},{-110,70},{-102,70}},
      color={255,0,255}));
  connect(intEqu.y, swi28.u2)
    annotation (Line(points={{-118,-110},{-110,-110},{-110,40},{-102,40}},
      color={255,0,255}));
  connect(cooMaxAir.y, swi24.u1)
    annotation (Line(points={{-218,-10},{-204,-10},{-204,16},{-140,16},{-140,168},
      {-102,168}}, color={0,0,127}));
  connect(heaMaxAir.y, maxInp.u2)
    annotation (Line(points={{-158,-10},{-120,-10},{-120,-16},{-102,-16}},
      color={0,0,127}));
  connect(maxInp.y, swi28.u1)
    annotation (Line(points={{-78,-10},{-60,-10},{-60,22},{-124,22},{-124,48},
      {-102,48}},   color={0,0,127}));
  connect(zerCon6.y, swi24.u3)
    annotation (Line(points={{-218,180},{-120,180},{-120,152},{-102,152}},
      color={0,0,127}));
  connect(zerCon6.y, swi25.u3)
    annotation (Line(points={{-218,180},{-120,180},{-120,122},{-102,122}},
      color={0,0,127}));
  connect(zerCon6.y, swi26.u3)
    annotation (Line(points={{-218,180},{-120,180},{-120,92},{-102,92}},
      color={0,0,127}));
  connect(zerCon6.y, swi27.u3)
    annotation (Line(points={{-218,180},{-120,180},{-120,62},{-102,62}},
      color={0,0,127}));
  connect(zerCon6.y, swi28.u3)
    annotation (Line(points={{-218,180},{-120,180},{-120,32},{-102,32}},
      color={0,0,127}));
  connect(uOpeMod, intEqu1.u2)
    annotation (Line(points={{-300,-110},{-180,-110},{-180,-32},{-200,-32},
      {-200,292},{-182,292}}, color={255,127,0}));
  connect(uOpeMod, intEqu2.u2)
    annotation (Line(points={{-300,-110},{-180,-110},{-180,-32},{-200,-32},
      {-200,222},{-182,222}}, color={255,127,0}));
  connect(uOpeMod, intEqu4.u2)
    annotation (Line(points={{-300,-110},{-180,-110},{-180,-32},{20,-32},
      {20,222},{38,222}}, color={255,127,0}));
  connect(uOpeMod, intEqu3.u2)
    annotation (Line(points={{-300,-110},{-180,-110},{-180,-32},{20,-32},
      {20,292},{38,292}}, color={255,127,0}));
  connect(conInt1.y, intEqu1.u1)
    annotation (Line(points={{-218,300},{-182,300}}, color={255,127,0}));
  connect(conInt2.y, intEqu2.u1)
    annotation (Line(points={{-218,230},{-182,230}}, color={255,127,0}));
  connect(conInt4.y, intEqu4.u1)
    annotation (Line(points={{2,230},{38,230}}, color={255,127,0}));
  connect(conInt3.y, intEqu3.u1)
    annotation (Line(points={{2,300},{38,300}}, color={255,127,0}));
  connect(cooMaxAir.y, swi4.u1)
    annotation (Line(points={{-218,-10},{-204,-10},{-204,16},{-140,16},{-140,308},
          {-102,308}}, color={0,0,127}));
  connect(heaMaxAir.y, swi8.u1)
    annotation (Line(points={{-158,-10},{-134,-10},{-134,278},{-102,278}},
      color={0,0,127}));
  connect(intEqu1.y, swi4.u2)
    annotation (Line(points={{-158,300},{-102,300}}, color={255,0,255}));
  connect(intEqu1.y, swi8.u2)
    annotation (Line(points={{-158,300},{-112,300},{-112,270},{-102,270}},
      color={255,0,255}));
  connect(zerCon6.y, swi4.u3)
    annotation (Line(points={{-218,180},{-120,180},{-120,292},{-102,292}},
      color={0,0,127}));
  connect(zerCon6.y, swi8.u3)
    annotation (Line(points={{-218,180},{-120,180},{-120,262},{-102,262}},
      color={0,0,127}));
  connect(cooMaxAir.y, swi9.u1)
    annotation (Line(points={{-218,-10},{-204,-10},{-204,16},{-140,16},{-140,238},
          {-102,238}}, color={0,0,127}));
  connect(intEqu2.y, swi9.u2)
    annotation (Line(points={{-158,230},{-102,230}}, color={255,0,255}));
  connect(zerCon6.y, swi9.u3)
    annotation (Line(points={{-218,180},{-120,180},{-120,222},{-102,222}},
      color={0,0,127}));
  connect(intEqu3.y, swi17.u2)
    annotation (Line(points={{62,300},{118,300}},
      color={255,0,255}));
  connect(intEqu3.y, swi18.u2)
    annotation (Line(points={{62,300},{108,300},{108,270},{118,270}},
      color={255,0,255}));
  connect(intEqu4.y, swi22.u2)
    annotation (Line(points={{62,230},{118,230}},
      color={255,0,255}));
  connect(intEqu4.y, swi23.u2)
    annotation (Line(points={{62,230},{108,230},{108,200},{118,200}},
      color={255,0,255}));
  connect(heaMaxAir.y, swi17.u1)
    annotation (Line(points={{-158,-10},{-134,-10},{-134,10},{86,10},{86,308},{118,
          308}},  color={0,0,127}));
  connect(cooMaxAir.y, swi18.u1)
    annotation (Line(points={{-218,-10},{-204,-10},{-204,16},{80,16},{80,278},{118,
          278}},  color={0,0,127}));
  connect(zerCon6.y, swi17.u3)
    annotation (Line(points={{-218,180},{100,180},{100,292},{118,292}},
      color={0,0,127}));
  connect(zerCon6.y, swi18.u3)
    annotation (Line(points={{-218,180},{100,180},{100,262},{118,262}},
      color={0,0,127}));
  connect(zerCon6.y, swi22.u3)
    annotation (Line(points={{-218,180},{100,180},{100,222},{118,222}},
      color={0,0,127}));
  connect(zerCon6.y, swi23.u3)
    annotation (Line(points={{-218,180},{100,180},{100,192},{118,192}},
      color={0,0,127}));
  connect(heaMaxAir.y, swi22.u1)
    annotation (Line(points={{-158,-10},{-134,-10},{-134,10},{86,10},{86,238},{118,
          238}},  color={0,0,127}));
  connect(cooMaxAir.y, swi23.u1)
    annotation (Line(points={{-218,-10},{-204,-10},{-204,16},{80,16},{80,208},{118,
          208}},  color={0,0,127}));
  connect(swi1.y, swi25.u1)
    annotation (Line(points={{222,-500},{240,-500},{240,-28},{-128,-28},{-128,138},
          {-102,138}}, color={0,0,127}));
  connect(swi1.y, swi26.u1)
    annotation (Line(points={{222,-500},{240,-500},{240,-28},{-128,-28},{-128,108},
          {-102,108}}, color={0,0,127}));
  connect(swi1.y, swi27.u1)
    annotation (Line(points={{222,-500},{240,-500},{240,-28},{-128,-28},{-128,78},
          {-102,78}}, color={0,0,127}));
  connect(swi1.y, maxInp.u1)
    annotation (Line(points={{222,-500},{240,-500},{240,-28},{-128,-28},{-128,-4},
          {-102,-4}}, color={0,0,127}));
  connect(nOcc, greThr.u)
    annotation (Line(points={{-300,-280},{-142,-280}}, color={0,0,127}));
  connect(greThr.y, swi.u2)
    annotation (Line(points={{-118,-280},{78,-280}}, color={255,0,255}));
  connect(add2.y, actCooMaxAir.u1) annotation (Line(points={{222,180},{230,180},
          {230,176},{238,176}}, color={0,0,127}));
  connect(swi4.y, add2.u1) annotation (Line(points={{-78,300},{-40,300},{-40,186},
          {198,186}}, color={0,0,127}));
  connect(swi9.y, add2.u2) annotation (Line(points={{-78,230},{-60,230},{-60,174},
          {198,174}}, color={0,0,127}));
  connect(swi24.y, actCooMaxAir.u2) annotation (Line(points={{-78,160},{100,160},
          {100,164},{238,164}}, color={0,0,127}));
  connect(actCooMaxAir.y, VActCooMax_flow)
    annotation (Line(points={{262,170},{300,170}}, color={0,0,127}));
  connect(swi25.y, VActCooMin_flow) annotation (Line(points={{-78,130},{100,130},
          {100,140},{300,140}}, color={0,0,127}));
  connect(swi26.y, VActMin_flow) annotation (Line(points={{-78,100},{100,100},{100,
          110},{300,110}}, color={0,0,127}));
  connect(swi17.y, add1.u1) annotation (Line(points={{142,300},{178,300},{178,96},
          {198,96}}, color={0,0,127}));
  connect(swi22.y, add1.u2) annotation (Line(points={{142,230},{166,230},{166,84},
          {198,84}}, color={0,0,127}));
  connect(swi27.y, actHeaMinAir.u2) annotation (Line(points={{-78,70},{220,70},{
          220,64},{238,64}}, color={0,0,127}));
  connect(add1.y, actHeaMinAir.u1) annotation (Line(points={{222,90},{230,90},{230,
          76},{238,76}}, color={0,0,127}));
  connect(actHeaMinAir.y, VActHeaMin_flow)
    annotation (Line(points={{262,70},{300,70}}, color={0,0,127}));
  connect(swi8.y, add3.u1) annotation (Line(points={{-78,270},{-50,270},{-50,56},
          {178,56}}, color={0,0,127}));
  connect(swi28.y, add3.u2) annotation (Line(points={{-78,40},{-50,40},{-50,44},
          {178,44}}, color={0,0,127}));
  connect(swi18.y, add4.u1) annotation (Line(points={{142,270},{172,270},{172,16},
          {178,16}}, color={0,0,127}));
  connect(swi23.y, add4.u2) annotation (Line(points={{142,200},{160,200},{160,4},
          {178,4}}, color={0,0,127}));
  connect(actHeaMaxAir1.y, VActHeaMax_flow)
    annotation (Line(points={{262,30},{300,30}}, color={0,0,127}));
  connect(add3.y, actHeaMaxAir1.u1) annotation (Line(points={{202,50},{220,50},{
          220,36},{238,36}}, color={0,0,127}));
  connect(add4.y, actHeaMaxAir1.u2) annotation (Line(points={{202,10},{220,10},{
          220,24},{238,24}}, color={0,0,127}));

annotation (
  defaultComponentName="actAirSet_RehBox",
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-280,-560},{280,340}}),
        graphics={                   Rectangle(
          extent={{-258,-62},{258,-238}},
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
          extent={{92,-58},{290,-94}},
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
        Text(extent={{-252,-422},{28,-454}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,255},
          horizontalAlignment=TextAlignment.Left,
          textString="Occupied min airflow:
define based on controllable minimum"),
                                     Rectangle(
          extent={{-256,-484},{260,-552}},
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
          extent={{-258,318},{258,-18}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{32,18},{254,-26}},
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
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-62,66},{58,-56}},
          textColor={0,0,0},
          textString="actAirSet"),
        Text(
          visible=have_CO2Sen,
          extent={{-98,48},{-70,36}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="CO2"),
        Text(
          visible=have_occSen,
          extent={{-98,-32},{-70,-44}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="nOcc"),
        Text(
          extent={{-94,90},{-48,72}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uOpeMod"),
        Text(
          visible=have_winSen,
          extent={{-98,-74},{-72,-84}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="uWin"),
        Text(
          extent={{62,88},{98,74}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{62,58},{98,44}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMin_flow"),
        Text(
          extent={{72,24},{98,14}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{62,-2},{98,-16}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMin_flow"),
        Text(
          extent={{62,-32},{98,-46}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActHeaMax_flow"),
        Text(
          extent={{62,-72},{98,-86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VOccDisMin_flow")}),
Documentation(info="<html>
<p>
This atomic sequence sets the active maximum and minimum setpoints <code>VActCooMax_flow</code>,
<code>VActCooMin_flow</code>, <code>VActMin_flow</code>, <code>VActHeaMin_flow</code>,
<code>VActHeaMax_flow</code> for VAV reheat terminal unit according to ASHRAE
Guideline 36 (G36), PART 5.E.3-5.
</p>
<h4>1. Information provided by designer</h4>
<p>According to G36 PART 3.1.B.2, following VAV box design information should be
provided:</p>
<ul>
<li>Zone maximum cooling airflow setpoint <code>VDisCooSetMax_flow</code></li>
<li>Zone minimum airflow setpoint <code>VDisSetMin_flow</code></li>
<li>Zone maximum heating airflow setpoint <code>VDisHeaSetMax_flow</code></li>
</ul>

<h4>2. Occupied minimum airflow <code>VOccDisMin_flow</code></h4>
<p>The <code>VOccDisMin_flow</code> shall be equal to zone minimum airflow setpoint
<code>VDisSetMin_flow</code> except as follows:</p>
<ul>
<li>
If the zone has an occupancy sensor, <code>VOccDisMin_flow</code> shall be equal to
minimum breathing zone outdoor airflow (if ventilation is according to ASHRAE
Standard 62.1-2013) or zone minimum outdoor airflow for building area
(if ventilation is according to California Title 24) when the room is unpopulated.
</li>
<li>
If the zone has a window switch, <code>VOccDisMin_flow</code> shall be zero when the
window is open.
</li>
<li>
If <code>VDisSetMin_flow</code> is non-zero and less than the lowest possible airflow setpoint
allowed by the controls <code>VDisConMin_flow</code>, <code>VOccDisMin_flow</code> shall be set
equal to <code>VDisConMin_flow</code>.
</li>
<li>
If the zone has a CO2 sensor, then following steps are applied for calculating
<code>VOccDisMin_flow</code>. (1) During occupied mode, a P-only loop shall maintain
CO2 concentration at setpoint, reset 0% at (CO2 setpoint <code>CO2Set</code> -
200 ppm) and 100% at <code>CO2Set</code>. If ventilation outdoor airflow is controlled
in accordance with ASHRAE Standard 62.1-2013, the loop output shall reset the
<code>VOccDisMin_flow</code> from <code>VDisSetMin_flow</code> at 0% loop output up to <code>VDisCooSetMax_flow</code>
at 100% loop output; (2) Loop is diabled and output set to zero when the zone is
not in occupied mode.
</li>
</ul>

<h4>3. Active maximum and minimum setpoints</h4>
<p>The setpoints shall vary depending on the mode of the zone group.</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Setpoint</th> <th>Occupied</th><th>Cool-down</th>
<th>Setup</th><th>Warmup</th><th>Setback</th><th>Unoccupied</th></tr>
<tr><td>Cooling maximum (<code>VActCooMax_flow</code>)</td><td><code>VDisCooSetMax_flow</code></td>
<td><code>VDisCooSetMax_flow</code></td><td><code>VDisCooSetMax_flow</code></td>
<td>0</td><td>0</td><td>0</td></tr>
<tr><td>Cooling minimum (<code>VActCooMin_flow</code>)</td><td><code>VOccDisMin_flow</code></td>
<td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
<tr><td>Minimum (<code>VActMin_flow</code>)</td><td><code>VOccDisMin_flow</code></td><td>0</td>
<td>0</td><td>0</td><td>0</td><td>0</td></tr>
<tr><td>Heating minimum (<code>VActHeaMin_flow</code>)</td><td><code>VOccDisMin_flow</code></td>
<td>0</td><td>0</td><td><code>VDisHeaSetMax_flow</code></td><td><code>VDisHeaSetMax_flow</code></td>
<td>0</td></tr>
<tr><td>Heating maximum (<code>VActHeaMax_flow</code>)</td><td>max(<code>VDisHeaSetMax_flow,VOccDisMin_flow</code>)</td>
<td><code>VDisHeaSetMax_flow</code></td><td>0</td><td><code>VDisCooSetMax_flow</code></td><td><code>VDisCooSetMax_flow</code></td>
<td>0</td></tr>
</table>
<br/>
</html>", revisions="<html>
<ul>
<li>
March 11, 2020, by Jianjun Hu:<br/>
Replaced multisum block with add blocks.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1830\">#1830</a>.
</li>
<li>
February 27, 2020, by Jianjun Hu:<br/>
Used hysteresis to check occupancy.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1788\">#1788</a>.
</li>
<li>
September 7, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActiveAirFlow;
