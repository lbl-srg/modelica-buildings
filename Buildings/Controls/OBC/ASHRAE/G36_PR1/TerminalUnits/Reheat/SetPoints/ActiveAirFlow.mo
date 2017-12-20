within Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints;
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
  parameter Modelica.SIunits.VolumeFlowRate VCooMax
    "Zone maximum cooling airflow setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate VMin
    "Zone minimum airflow setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate VHeaMax
    "Zone maximum heating airflow setpoint"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate VMinCon
    "VAV box controllable minimum"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Area AFlo "Area of the zone"
    annotation(Dialog(group="Nominal condition"));
  parameter Real outAirPerAre(final unit = "m3/(s.m2)")=3e-4
    "Outdoor air rate per unit area"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer=2.5e-3
    "Outdoor air rate per person"
    annotation(Dialog(group="Nominal condition"));
  parameter Real CO2Set = 894 "CO2 setpoint in ppm"
    annotation(Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc(final unit="1") if have_occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-320,-300},{-280,-260}}),
      iconTransformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ppmCO2 if have_CO2Sen
    "Detected CO2 conventration"
    annotation (Placement(transformation(extent={{-320,-200},{-280,-160}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin if have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-320,-520},{-280,-480}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "Zone operation mode"
    annotation (Placement(transformation(extent={{-320,-130},{-280,-90}}),
      iconTransformation(extent={{-120,-40},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOccMinAir(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Occupied minimum airflow "
    annotation (Placement(transformation(extent={{280,-310},{320,-270}}),
      iconTransformation(extent={{100,-90},{120,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActCooMax(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Active cooling maximum"
    annotation (Placement(transformation(extent={{280,150},{320,190}}),
      iconTransformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActCooMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Active cooling minimum"
    annotation (Placement(transformation(extent={{280,110},{320,150}}),
      iconTransformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Active minimum"
    annotation (Placement(transformation(extent={{280,70},{320,110}}),
      iconTransformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActHeaMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Active heating minimum"
    annotation (Placement(transformation(extent={{280,30},{320,70}}),
      iconTransformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VActHeaMax(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Active heating maximum"
    annotation (Placement(transformation(extent={{280,-10},{320,30}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=outAirPerPer) if have_occSen
  "Outdoor air per person"
    annotation (Placement(transformation(extent={{-140,-330},{-120,-310}})));
  Buildings.Controls.OBC.CDL.Continuous.Add breZon if have_occSen
  "Breathing zone airflow"
    annotation (Placement(transformation(extent={{-80,-350},{-60,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.Line co2ConLoo if have_CO2Sen
    "Maintain CO2 concentration at setpoint, reset 0% at (setpoint-200) and 100% at setpoint"
    annotation (Placement(transformation(extent={{-140,-190},{-120,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin1 if have_CO2Sen
    "Reset occupied minimum airflow setpoint from 0% at VMin and 100% at VCooMax"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre
    "Check if zone minimum airflow setpoint Vmin is less than the allowed controllable VMinCon"
    annotation (Placement(transformation(extent={{-20,-460},{0,-440}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr(threshold=0) if have_occSen
    "Check if the zone becomes unpopulated"
    annotation (Placement(transformation(extent={{-140,-290},{-120,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1
    "Check if zone minimum airflow setpoint VMin is non-zero"
    annotation (Placement(transformation(extent={{-80,-410},{-60,-390}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Reset occupied minimum airflow according to occupancy"
    annotation (Placement(transformation(extent={{80,-290},{100,-270}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Reset occupied minimum airflow according to window status"
    annotation (Placement(transformation(extent={{200,-510},{220,-490}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Reset occupied minimum airflow setpoint according to minimum controllable airflow"
    annotation (Placement(transformation(extent={{140,-410},{160,-390}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3 if have_CO2Sen
    "Switch between zero signal and CO2 control loop signal depending on the operation mode"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-120}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{40,-410},{60,-390}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{80,-410},{100,-390}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2 if have_winSen "Logical not"
    annotation (Placement(transformation(extent={{-240,-510},{-220,-490}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minZonAir1(final k=VMin) if not have_CO2Sen
    "Zone minimum airflow setpoint"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxZonCooAir(final k=VCooMax) if have_CO2Sen
    "Zone maximum cooling airflow setpoint"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant breZonAre(final k=outAirPerAre*AFlo) if have_occSen
    "Area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-140,-370},{-120,-350}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conVolMin(final k=VMinCon)
    "VAV box controllable minimum"
    annotation (Placement(transformation(extent={{-80,-440},{-60,-420}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minZonAir(final k=VMin)
    "Zone minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-240,-60},{-220,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setCO1(final k=CO2Set - 200) if have_CO2Sen
    "CO2 setpoints minus 200"
    annotation (Placement(transformation(extent={{-240,-140},{-220,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant setCO2(final k=CO2Set) if have_CO2Sen
    "CO2 setpoints"
    annotation (Placement(transformation(extent={{-240,-210},{-220,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerFlo(final k=0)
    "Zero airflow when window is open"
    annotation (Placement(transformation(extent={{140,-540},{160,-520}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=true) if not have_occSen "Constant true"
    annotation (Placement(transformation(extent={{-80,-270},{-60,-250}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=true) if not have_winSen "Constant true"
    annotation (Placement(transformation(extent={{40,-490},{60,-470}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerCon(final k=0) "Output zero"
    annotation (Placement(transformation(extent={{-240,-170},{-220,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerCon1(final k=0) if have_CO2Sen
    "Output zero"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerCon2(final k=0) if have_CO2Sen
    "Output zero"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerCon3(final k=0) if not have_occSen
    "Output zero"
    annotation (Placement(transformation(extent={{0,-350},{20,-330}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneCon(final k=1) if have_CO2Sen
    "Output one"
    annotation (Placement(transformation(extent={{-240,-240},{-220,-220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant oneCon1(final k=1) if have_CO2Sen "Output one"
    annotation (Placement(transformation(extent={{-80,-160},{-60,-140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cooMaxAir(final k=VCooMax)
    "Cooling maximum airflow"
    annotation (Placement(transformation(extent={{-240,-20},{-220,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant heaMaxAir(final k=VHeaMax)
    "Heat maximum airflow"
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerCon6(final k=0)
    "Output zero"
    annotation (Placement(transformation(extent={{-240,170},{-220,190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-240,-100},{-220,-80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.coolDown)
    "Cool down mode"
    annotation (Placement(transformation(extent={{-240,290},{-220,310}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setUp)
    "Setup mode"
    annotation (Placement(transformation(extent={{-240,220},{-220,240}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.warmUp)
    "Warm up mode"
    annotation (Placement(transformation(extent={{-20,290},{0,310}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setBack)
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
  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    "Select cooling maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,290},{-80,310}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi8
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,260},{-80,280}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi9
    "Select cooling maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,220},{-80,240}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi17
    "Select heating minimum based on operation mode"
    annotation (Placement(transformation(extent={{120,290},{140,310}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi18
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{120,260},{140,280}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi22
    "Select heating minimum based on operation mode"
    annotation (Placement(transformation(extent={{120,220},{140,240}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi23
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{120,190},{140,210}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi24
    "Select cooling maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi25
    "Select cooling minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi26
    "Select minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi27
    "Select heating minimum based on operation mode"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi28
    "Select heating maximum based on operation mode"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum actCooMaxAir(nin=3)
    "Active cooling maximum airflow"
    annotation (Placement(transformation(extent={{220,160},{240,180}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum actCooMinAir(nin=1)
    "Active cooling minimum airflow"
    annotation (Placement(transformation(extent={{220,130},{240,150}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum actMinAir(nin=1)
    "Active minimum airflow"
    annotation (Placement(transformation(extent={{220,100},{240,120}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum actHeaMinAir(nin=3)
  "Active heating minimum airflow"
    annotation (Placement(transformation(extent={{220,60},{240,80}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum actHeaMaxAir(nin=4)
  "Active heating maximum airflow"
    annotation (Placement(transformation(extent={{220,20},{240,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Max maxInp "Find greater input"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

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
  connect(nOcc, greThr.u)
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
  connect(greThr.y, swi.u2)
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
    annotation (Line(points={{-119,-110},{-110,-110},{-110,160},{-102,160}},
      color={255,0,255}));
  connect(intEqu.y, swi25.u2)
    annotation (Line(points={{-119,-110},{-110,-110},{-110,130},{-102,130}},
      color={255,0,255}));
  connect(intEqu.y, swi26.u2)
    annotation (Line(points={{-119,-110},{-110,-110},{-110,100},{-102,100}},
      color={255,0,255}));
  connect(intEqu.y, swi27.u2)
    annotation (Line(points={{-119,-110},{-110,-110},{-110,70},{-102,70}},
      color={255,0,255}));
  connect(intEqu.y, swi28.u2)
    annotation (Line(points={{-119,-110},{-110,-110},{-110,40},{-102,40}},
      color={255,0,255}));
  connect(cooMaxAir.y, swi24.u1)
    annotation (Line(points={{-219,-10},{-204,-10},{-204,16},{-140,16},{-140,168},
      {-102,168}}, color={0,0,127}));
  connect(heaMaxAir.y, maxInp.u2)
    annotation (Line(points={{-159,-10},{-120,-10},{-120,-16},{-102,-16}},
      color={0,0,127}));
  connect(maxInp.y, swi28.u1)
    annotation (Line(points={{-79,-10},{-60,-10},{-60,22},{-124,22},{-124,48},
      {-102,48}}, color={0,0,127}));
  connect(zerCon6.y, swi24.u3)
    annotation (Line(points={{-219,180},{-120,180},{-120,152},{-102,152}},
      color={0,0,127}));
  connect(zerCon6.y, swi25.u3)
    annotation (Line(points={{-219,180},{-120,180},{-120,122},{-102,122}},
      color={0,0,127}));
  connect(zerCon6.y, swi26.u3)
    annotation (Line(points={{-219,180},{-120,180},{-120,92},{-102,92}},
      color={0,0,127}));
  connect(zerCon6.y, swi27.u3)
    annotation (Line(points={{-219,180},{-120,180},{-120,62},{-102,62}},
      color={0,0,127}));
  connect(zerCon6.y, swi28.u3)
    annotation (Line(points={{-219,180},{-120,180},{-120,32},{-102,32}},
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
    annotation (Line(points={{-219,300},{-182,300}}, color={255,127,0}));
  connect(conInt2.y, intEqu2.u1)
    annotation (Line(points={{-219,230},{-182,230}}, color={255,127,0}));
  connect(conInt4.y, intEqu4.u1)
    annotation (Line(points={{1,230},{38,230}}, color={255,127,0}));
  connect(conInt3.y, intEqu3.u1)
    annotation (Line(points={{1,300},{38,300}}, color={255,127,0}));
  connect(cooMaxAir.y, swi4.u1)
    annotation (Line(points={{-219,-10},{-204,-10},{-204,16},{-140,16},{-140,308},
      {-102,308}}, color={0,0,127}));
  connect(heaMaxAir.y, swi8.u1)
    annotation (Line(points={{-159,-10},{-134,-10},{-134,278},{-102,278}},
      color={0,0,127}));
  connect(intEqu1.y, swi4.u2)
    annotation (Line(points={{-159,300},{-102,300}}, color={255,0,255}));
  connect(intEqu1.y, swi8.u2)
    annotation (Line(points={{-159,300},{-112,300},{-112,270},{-102,270}},
      color={255,0,255}));
  connect(zerCon6.y, swi4.u3)
    annotation (Line(points={{-219,180},{-120,180},{-120,292},{-102,292}},
      color={0,0,127}));
  connect(zerCon6.y, swi8.u3)
    annotation (Line(points={{-219,180},{-120,180},{-120,262},{-102,262}},
      color={0,0,127}));
  connect(cooMaxAir.y, swi9.u1)
    annotation (Line(points={{-219,-10},{-204,-10},{-204,16},{-140,16},{-140,238},
      {-102,238}}, color={0,0,127}));
  connect(intEqu2.y, swi9.u2)
    annotation (Line(points={{-159,230},{-102,230}}, color={255,0,255}));
  connect(zerCon6.y, swi9.u3)
    annotation (Line(points={{-219,180},{-120,180},{-120,222},{-102,222}},
      color={0,0,127}));
  connect(intEqu3.y, swi17.u2)
    annotation (Line(points={{61,300},{118,300}},
      color={255,0,255}));
  connect(intEqu3.y, swi18.u2)
    annotation (Line(points={{61,300},{108,300},{108,270},{118,270}},
      color={255,0,255}));
  connect(intEqu4.y, swi22.u2)
    annotation (Line(points={{61,230},{118,230}},
      color={255,0,255}));
  connect(intEqu4.y, swi23.u2)
    annotation (Line(points={{61,230},{108,230},{108,200},{118,200}},
      color={255,0,255}));
  connect(heaMaxAir.y, swi17.u1)
    annotation (Line(points={{-159,-10},{-134,-10},{-134,10},{86,10},{86,308},
      {118,308}}, color={0,0,127}));
  connect(cooMaxAir.y, swi18.u1)
    annotation (Line(points={{-219,-10},{-204,-10},{-204,16},{80,16},{80,278},
      {118,278}}, color={0,0,127}));
  connect(zerCon6.y, swi17.u3)
    annotation (Line(points={{-219,180},{100,180},{100,292},{118,292}},
      color={0,0,127}));
  connect(zerCon6.y, swi18.u3)
    annotation (Line(points={{-219,180},{100,180},{100,262},{118,262}},
      color={0,0,127}));
  connect(zerCon6.y, swi22.u3)
    annotation (Line(points={{-219,180},{100,180},{100,222},{118,222}},
      color={0,0,127}));
  connect(zerCon6.y, swi23.u3)
    annotation (Line(points={{-219,180},{100,180},{100,192},{118,192}},
      color={0,0,127}));
  connect(heaMaxAir.y, swi22.u1)
    annotation (Line(points={{-159,-10},{-134,-10},{-134,10},{86,10},{86,238},
      {118,238}}, color={0,0,127}));
  connect(cooMaxAir.y, swi23.u1)
    annotation (Line(points={{-219,-10},{-204,-10},{-204,16},{80,16},{80,208},
      {118,208}}, color={0,0,127}));
  connect(swi24.y, actCooMaxAir.u[1])
    annotation (Line(points={{-79,160},{60,160},{60,174.667},{218,174.667}},
      color={0,0,127}));
  connect(swi25.y, actCooMinAir.u[1])
    annotation (Line(points={{-79,130},{60,130},{60,140},{218,140}},
      color={0,0,127}));
  connect(swi26.y, actMinAir.u[1])
    annotation (Line(points={{-79,100},{60,100},{60,110},{218,110}},
      color={0,0,127}));
  connect(swi27.y, actHeaMinAir.u[1])
    annotation (Line(points={{-79,70},{60,70},{60,74.6667},{218,74.6667}},
      color={0,0,127}));
  connect(swi28.y, actHeaMaxAir.u[1])
    annotation (Line(points={{-79,40},{60,40},{60,35.25},{218,35.25}},
      color={0,0,127}));
  connect(swi4.y, actCooMaxAir.u[2])
    annotation (Line(points={{-79,300},{-28,300},{-28,170},{218,170}},
      color={0,0,127}));
  connect(swi8.y, actHeaMaxAir.u[2])
    annotation (Line(points={{-79,270},{-44,270},{-44,31.75},{218,31.75}},
      color={0,0,127}));
  connect(swi9.y, actCooMaxAir.u[3])
    annotation (Line(points={{-79,230},{-48,230},{-48,165.333},{218,165.333}},
      color={0,0,127}));
  connect(swi17.y, actHeaMinAir.u[2])
    annotation (Line(points={{141,300},{194,300},{194,70},{218,70}},
      color={0,0,127}));
  connect(swi18.y, actHeaMaxAir.u[3])
    annotation (Line(points={{141,270},{190,270},{190,28.25},{218,28.25}},
      color={0,0,127}));
  connect(swi22.y, actHeaMinAir.u[3])
    annotation (Line(points={{141,230},{172,230},{172,65.3333},{218,65.3333}},
      color={0,0,127}));
  connect(swi23.y, actHeaMaxAir.u[4])
    annotation (Line(points={{141,200},{168,200},{168,24.75},{218,24.75}},
      color={0,0,127}));
  connect(swi1.y, swi25.u1)
    annotation (Line(points={{221,-500},{240,-500},{240,-28},{-128,-28},{-128,138},
      {-102,138}}, color={0,0,127}));
  connect(swi1.y, swi26.u1)
    annotation (Line(points={{221,-500},{240,-500},{240,-28},{-128,-28},{-128,108},
      {-102,108}}, color={0,0,127}));
  connect(swi1.y, swi27.u1)
    annotation (Line(points={{221,-500},{240,-500},{240,-28},{-128,-28},{-128,78},
      {-102,78}}, color={0,0,127}));
  connect(swi1.y, maxInp.u1)
    annotation (Line(points={{221,-500},{240,-500},{240,-28},{-128,-28},{-128,-4},
      {-102,-4}}, color={0,0,127}));
  connect(actCooMaxAir.y, VActCooMax)
    annotation (Line(points={{241.7,170},{300,170}},
      color={0,0,127}));
  connect(actCooMinAir.y, VActCooMin)
    annotation (Line(points={{241.7,140},{260,140},{260,130},{300,130}},
      color={0,0,127}));
  connect(actMinAir.y, VActMin)
    annotation (Line(points={{241.7,110},{260,110},{260,90},{300,90}},
      color={0,0,127}));
  connect(actHeaMinAir.y, VActHeaMin)
    annotation (Line(points={{241.7,70},{260,70},{260,50},{300,50}},
      color={0,0,127}));
  connect(actHeaMaxAir.y, VActHeaMax)
    annotation (Line(points={{241.7,30},{256,30},{256,10},{300,10}},
      color={0,0,127}));

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
          extent={{-258,-470},{258,-538}},
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
          extent={{92,20},{314,-24}},
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
          textString="actAirSet"),
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
This atomic sequence sets the active maximum and minimum setpoints <code>VActCooMax</code>,
<code>VActCooMin</code>, <code>VActMin</code>, <code>VActHeaMin</code>,
<code>VActHeaMax</code> for VAV reheat terminal unit according to ASHRAE
Guideline 36 (G36), PART5.E.3-5.
</p>
<h4>1. Information provided by designer</h4>
<p>According to G36 PART 3.1.B.2, following VAV box design information should be
provided:</p>
<ul>
<li>Zone maximum cooling airflow setpoint <code>VCooMax</code></li>
<li>Zone minimum airflow setpoint <code>VMin</code></li>
<li>Zone maximum heating airflow setpoint <code>VHeaMax</code></li>
</ul>

<h4>2. Occupied minimum airflow <code>VOccMinAir</code></h4>
<p>The <code>VOccMinAir</code> shall be equal to zone minimum airflow setpoint
<code>VMin</code> except as follows:</p>
<ul>
<li>
If the zone has an occupancy sensor, <code>VOccMinAir</code> shall be equal to
minimum breathing zone outdoor airflow (if ventilation is according to ASHRAE
Standard 62.1-2013) or zone minimum outdoor airflow for building area
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
<code>VOccMinAir</code>. (1) During occupied mode, a P-only loop shall maintain
CO2 concentration at setpoint, reset 0% at (CO2 setpoint <code>CO2Set</code> -
200 ppm) and 100% at <code>CO2Set</code>. If ventilation outdoor airflow is controlled
in accordance with ASHRAE Standard 62.1-2013, the loop output shall reset the
<code>VOccMinAir</code> from <code>VMin</code> at 0% loop output up to <code>VCooMax</code>
at 100% loop output; (2) Loop is diabled and output set to zero when the zone is
not in occupied mode.
</li>
</ul>

<h4>3. Active maximum and minimum setpoints</h4>
<p>The setpoints shall vary depending on the mode of the zone group.</p>
<table summary=\"summary\" border=\"1\">
<tr><th>Setpoint</th> <th>Occupied</th><th>Cool-down</th>
<th>Setup</th><th>Warmup</th><th>Setback</th><th>Unoccupied</th></tr>
<tr><td>Cooling maximum (<code>VActCooMax</code>)</td><td><code>VCooMax</code></td>
<td><code>VCooMax</code></td><td><code>VCooMax</code></td>
<td>0</td><td>0</td><td>0</td></tr>
<tr><td>Cooling minimum (<code>VActCooMin</code>)</td><td><code>VOccMinAir</code></td>
<td>0</td><td>0</td><td>0</td><td>0</td><td>0</td></tr>
<tr><td>Minimum (<code>VActMin</code>)</td><td><code>VOccMinAir</code></td><td>0</td>
<td>0</td><td>0</td><td>0</td><td>0</td></tr>
<tr><td>Heating minimum (<code>VActHeaMin</code>)</td><td><code>VOccMinAir</code></td>
<td>0</td><td>0</td><td><code>VHeaMax</code></td><td><code>VHeaMax</code></td>
<td>0</td></tr>
<tr><td>Heating maximum (<code>VActHeaMax</code>)</td><td>max(<code>VHeaMax,VOccMinAir</code>)</td>
<td><code>VHeaMax</code></td><td>0</td><td><code>VCooMax</code></td><td><code>VCooMax</code></td>
<td>0</td></tr>
</table>
<br/>
</html>", revisions="<html>
<ul>
<li>
September 7, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end ActiveAirFlow;
