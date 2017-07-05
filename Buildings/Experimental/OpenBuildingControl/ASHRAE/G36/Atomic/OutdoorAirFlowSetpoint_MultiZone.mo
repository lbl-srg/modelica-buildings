within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic;
block OutdoorAirFlowSetpoint_MultiZone
  "Find out the minimum outdoor airflow rate setpoint for systems with 
  multiple zones"

  parameter Integer numOfZon(min=2) = 5
    "Total number of zones that the system serves";
  parameter Modelica.SIunits.VolumeFlowRate outAirPerAre[numOfZon]=
      fill(3e-4, numOfZon)
    "Area outdoor air rate Ra, m3/s per unit area"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer[numOfZon]=
      fill(2.5e-3, numOfZon)
    "People outdoor air rate Rp, m3/s per person"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Modelica.SIunits.Area zonAre[numOfZon]=fill(40, numOfZon)
    "Area of each zone"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Boolean occSen[numOfZon] = fill(true, numOfZon)
    "Indicate if the zones have occupancy sensor";
  parameter Real occDen[numOfZon](each unit="1") = fill(0.05, numOfZon)
    "Default number of person in unit area";
  parameter Real zonDisEffHea[numOfZon](each unit="1") = fill(0.8, numOfZon)
    "Zone air distribution effectiveness (heating supply), if no value scheduled";
  parameter Real zonDisEffCoo[numOfZon](each unit="1") = fill(1.0, numOfZon)
    "Zone air distribution effectiveness (cooling supply), if no value scheduled";
  parameter Real desZonPop[numOfZon](
    min={occDen[i]*zonAre[i] for i in 1:numOfZon},
    each unit="1") = fill(3, numOfZon)
    "Design zone population: expected peak population"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Real desZonDisEff[numOfZon](each unit="1") = fill(1.0, numOfZon)
    "Design zone air distribution effectiveness"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Modelica.SIunits.VolumeFlowRate maxSysPriFlo = 1
    "Maximum expected system primary airflow at design stage"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numOfZon](
    each displayUnit="m3/s") = fill(0.08, numOfZon)
    "Minimum expected zone primary flow rate"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Real peaSysPou(unit="1") = 20 "Peak system population"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));

  CDL.Interfaces.RealInput occCou[numOfZon](each final unit="1")
    "Number of human counts"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-120,60},{-100,80}})));
  CDL.Interfaces.RealInput cooCtrSig(
    min=0,
    max=1,
    final unit="1") "Cooling control signal." annotation (Placement(transformation(
          extent={{-220,-80},{-180,-40}}), iconTransformation(extent={{-120,24},
            {-100,44}})));
  CDL.Interfaces.RealInput priAirflow[numOfZon](
    each min=minZonPriFlo,
    each final unit="m3/s",
    each quantity="VolumeFlowRate")
    "Primary airflow rate to the ventilation zone from the air handler, 
    including outdoor air and recirculated air."
    annotation (Placement(transformation(extent={{-220,-206},{-180,-166}}),
        iconTransformation(extent={{-120,-82},{-100,-62}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-220,-169},{-180,-130}}),
        iconTransformation(extent={{-120,-48},{-100,-28}})));
  CDL.Interfaces.BooleanInput uWindow[numOfZon] "Window status, On or Off"
    annotation (Placement(transformation(extent={{-220,-140},{-180,-100}}),
        iconTransformation(extent={{-120,-12},{-100,8}})));
  CDL.Interfaces.RealOutput desOutMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Design minimum outdoor airflow rate" annotation (Placement(transformation(
          extent={{240,90},{280,130}}), iconTransformation(extent={{100,38},{
            120,58}})));
  CDL.Interfaces.RealOutput desUncOutMin(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Design uncorrected minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{240,160},{280,200}}),
      iconTransformation(extent={{100,68},{120,88}})));
  CDL.Interfaces.RealOutput outMinSet(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Effective minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,-90},{280,-50}}),
      iconTransformation(extent={{100,-10},{120,10}})));

  CDL.Continuous.Add breZon[numOfZon] "Breathing zone airflow"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  CDL.Continuous.Gain gai[numOfZon](
    k = {outAirPerPer[i] for i in 1:numOfZon}) "Outdoor air per person"
    annotation (Placement(transformation(extent={{-160,50}, {-140,70}})));
  CDL.Logical.Switch swi[numOfZon]
    "If there is occupancy sensor, then using the real time occupant; 
    otherwise, using the default occupant "
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  CDL.Logical.Switch swi1[numOfZon]
    "Switch between cooling or heating distribution effectiveness"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  CDL.Continuous.Division zonOutAirRate[numOfZon]
    "Required zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  CDL.Logical.GreaterThreshold greThr
    "Whether or not the cooling signal is on (greater than 0)"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));
  CDL.Logical.Switch swi2[numOfZon]
    "If window is open or it is not in occupied mode, the required outdoor 
    airflow rate should be zero"
    annotation (Placement(transformation(extent={{20,0},{40,-20}})));
  CDL.Logical.Switch swi3[numOfZon]
    "If supply fan is off, then outdoor airflow rate should be zero."
    annotation (Placement(transformation(extent={{60,-40},{80,-60}})));
  CDL.Continuous.Division priOutAirFra[numOfZon]
    "Primary outdoor air fraction"
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  CDL.Continuous.Sum sysUncOutAir(nin=numOfZon)
    "Uncorrected outdoor airflow. "
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  CDL.Continuous.Sum sysPriAirRate(nin=numOfZon)
    "System primary airflow rate."
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  CDL.Continuous.Division outAirFra "Average outdoor air fraction"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  CDL.Continuous.AddParameter addPar(p=1, k=1)
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  CDL.Continuous.Add sysVenEff(k2=-1)
    "Current system ventilation efficiency"
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
  CDL.Continuous.Division effMinOutAirInt
    "Effective minimum outdoor air setpoint"
    annotation (Placement(transformation(extent={{160,-120},{180,-100}})));
  CDL.Continuous.Add desBreZon[numOfZon] "Breathing zone design airflow"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  CDL.Continuous.Division desZonOutAirRate[numOfZon]
    "Required design zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));
  CDL.Continuous.Division desZonPriOutAirRate[numOfZon]
    "Design zone primary outdoor air fraction"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  CDL.Continuous.Sum  sumDesZonPop(nin=numOfZon)
    "Sum of the design zone population for all zones"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));
  CDL.Continuous.Division occDivFra "Occupant diversity fraction"
    annotation (Placement(transformation(extent={{-100,240},{-80,260}})));
  CDL.Continuous.Sum  sumDesBreZonPop(nin=numOfZon)
    "Sum of the design breathing zone flow rate: population component"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  CDL.Continuous.Sum  sumDesBreZonAre(nin=numOfZon)
    "Sum of the design breathing zone flow rate: area component"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  CDL.Continuous.Add unCorOutAirInk "Uncorrected outdoor air intake"
    annotation (Placement(transformation(extent={{20,211},{40,230}})));
  CDL.Continuous.Product pro "Product of inputs"
    annotation (Placement(transformation(extent={{-20,240},{0,260}})));
  CDL.Continuous.Division aveOutAirFra "Average outdoor air fraction"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  CDL.Continuous.AddParameter addPar1(p=1, k=1)
    annotation (Placement(transformation(extent={{100,180},{120,200}})));
  CDL.Continuous.Add zonVenEff[numOfZon](each k2=-1)
    "Zone ventilation efficiency"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));
  CDL.Continuous.Division desOutAirInt "Design system outdoor air intake"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  CDL.Continuous.MinMax  desSysVenEff(nin=numOfZon)
    "Design system ventilation efficiency"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));
  CDL.Continuous.MinMax  maxPriOutAirFra(nin=numOfZon)
    "Maximum zone outdoor air fraction."
    annotation (Placement(transformation(extent={{60,-190},{80,-170}})));
  CDL.Continuous.Min min
    "Minimum outdoor airflow rate should not be more than designed outdoor 
    airflow rate"
    annotation (Placement(transformation(extent={{200,-120},{220,-100}})));
  CDL.Continuous.Min min1
    "Uncorrected outdoor air rate should not be higher than its design value."
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));

protected
  CDL.Logical.Constant occSenor[numOfZon](
    k={occSen[i] for i in 1:numOfZon})
    "Whether or not there is occupancy sensor"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  CDL.Continuous.Constant desDisEff[numOfZon](
    k = {desZonDisEff[i] for i in 1:numOfZon})
    "Design zone air distribution effectiveness"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  CDL.Continuous.Constant minZonFlo[numOfZon](
    k = {minZonPriFlo[i] for i in 1:numOfZon})
    "Minimum expected zone primary flow rate"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  CDL.Continuous.Constant breZonAre[numOfZon](
    k={outAirPerAre[i]*zonAre[i] for i in 1:numOfZon})
    "Area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  CDL.Continuous.Constant breZonPop[numOfZon](
    k={outAirPerPer[i]*zonAre[i]*occDen[i] for i in 1:numOfZon})
    "Population component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));
  CDL.Continuous.Constant disEffHea[numOfZon](
    k = {zonDisEffHea[i] for i in 1:numOfZon})
    "Zone distribution effectiveness: Heating"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  CDL.Continuous.Constant disEffCoo[numOfZon](
    k = {zonDisEffCoo[i] for i in 1:numOfZon})
    "Zone distribution effectiveness: Cooling"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
  CDL.Continuous.Constant desZonPopulation[numOfZon](
    k={desZonPop[i] for i in 1:numOfZon})
    "Design zone population"
    annotation (Placement(transformation(extent={{-180,220},{-160,240}})));
  CDL.Continuous.Constant zerOutAir[numOfZon](k=fill(0,numOfZon))
    "Zero required outdoor airflow rate when window is open or is not in 
    occupied mode."
    annotation (Placement(transformation(extent={{-40,-28},{-20,-8}})));
  CDL.Continuous.Constant desBreZonPer[numOfZon](
    k={outAirPerPer[i]*desZonPop[i] for i in 1:numOfZon})
    "Population component of the breathing zone design outdoor airflow"
    annotation (Placement(transformation(extent={{-180,180},{-160,200}})));
  CDL.Continuous.Constant peaSysPopulation(k=peaSysPou)
    "Peak system population"
    annotation (Placement(transformation(extent={{-180,260},{-160,280}})));
  CDL.Continuous.Constant maxSysPriFlow(k=maxSysPriFlo)
    "Highest expected system primary airflow"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

equation
  for i in 1:numOfZon loop
    connect(breZonAre[i].y, breZon[i].u1)
      annotation (Line(points={{-99,70},{-90,70},{-90,36},{-82,36}},
        color={0,0,127}));
    connect(gai[i].y, swi[i].u1)
      annotation (Line(points={{-139,60},{-128,60},{-128,28},{-122,28}},
        color={0,0,127}));
    connect(breZonPop[i].y, swi[i].u3)
      annotation (Line(points={{-139,-10},{-134,-10},{-134,12},{-122,12}},
        color={0,0,127}));
    connect(gai[i].u, occCou[i])
      annotation (Line(points={{-162,60},{-200,60}},color={0,0,127}));
    connect(swi[i].y, breZon[i].u2)
      annotation (Line(points={{-99,20},{-99,20},{-90,20},{-90,24},{-82,24}},
        color={0,0,127}));
    connect(disEffCoo[i].y, swi1[i].u1)
      annotation (Line(points={{-99,-30},{-92,-30},{-92,-52},{-82,-52}},
        color={0,0,127}));
    connect(disEffHea[i].y, swi1[i].u3)
      annotation (Line(points={{-99,-90},{-92,-90},{-92,-68},{-82,-68}},
        color={0,0,127}));
    connect(breZon[i].y, zonOutAirRate[i].u1)
      annotation (Line(points={{-59,30},{-50,30},{-50,36},{-42,36}},
        color={0,0,127}));
    connect(swi1[i].y, zonOutAirRate[i].u2)
      annotation (Line(points={{-59,-60},{-50,-60},{-50,24},{-42,24}},
        color={0,0,127}));
    connect(greThr.y, swi1[i].u2)
      annotation (Line(points={{-99,-60},{-99,-60},{-82,-60}},
        color={255,0,255}));
    connect(uWindow[i], swi2[i].u2)
      annotation (Line(points={{-200,-120},{-40,-120},
        {-40,-54},{-8,-54},{-8,-10},{18,-10}}, color={255,0,255}));
    connect(zerOutAir[i].y, swi2[i].u1)
      annotation (Line(points={{-19,-18},{0,-18},{18,-18}},
        color={0,0,127}));
    connect(zonOutAirRate[i].y, swi2[i].u3)
      annotation (Line(points={{-19,30},{0,30},{0,-2},{18,-2}},
        color={0,0,127}));
    connect(swi2[i].y, swi3[i].u3)
      annotation (Line(points={{41,-10},{48,-10},{48,-42},{58,-42}},
        color={0,0,127}));
    connect(zerOutAir[i].y, swi3[i].u1)
      annotation (Line(points={{-19,-18},{-19,-18},{0,-18},{0,-58},{58,-58}},
        color={0,0,127}));
    connect(not1.y, swi3[i].u2)
      annotation (Line(points={{-99,-150},{-38,-150},{-38,-56},{-6,-56},
        {-6,-50},{58,-50}},color={255,0,255}));
    connect(swi3[i].y, priOutAirFra[i].u1)
      annotation (Line(points={{81,-50},{90,-50},{90,-76},{-20,-76},
        {-20,-174},{-2,-174}}, color={0,0,127}));
    connect(swi3[i].y,sysUncOutAir. u[i])
      annotation (Line(points={{81,-50},{81,-50},{98,-50}},color={0,0,127}));
    connect(priAirflow[i], priOutAirFra[i].u2)
      annotation (Line(points={{-200,-186},{-200,-186},{-2,-186}},
        color={0,0,127}));
    connect(priAirflow[i],sysPriAirRate. u[i])
      annotation (Line(points={{-200,-186},{-200,-185},{-26,-185},{-26,-110},
        {-2,-110}},color={0,0,127}));
    connect(breZonAre[i].y, desBreZon[i].u2)
      annotation (Line(points={{-99,70},{-90,70},{-90,100},{-140,100},
        {-140,144},{-122,144}}, color={0,0,127}));
    connect(desBreZonPer[i].y, desBreZon[i].u1)
      annotation (Line(points={{-159,190},{-140,190},{-140,156},{-122,156}},
        color={0,0,127}));
    connect(desDisEff[i].y, desZonOutAirRate[i].u2)
      annotation (Line(points={{-99,190},{-88,190},{-88,164},{-62,164}},
        color={0,0,127}));
    connect(desBreZon[i].y, desZonOutAirRate[i].u1)
      annotation (Line(points={{-99,150},{-80,150},{-80,176},{-62,176}},
        color={0,0,127}));
    connect(desZonOutAirRate[i].y, desZonPriOutAirRate[i].u1)
      annotation (Line(points={{-39,170},{-30,170},{-30,176},{-22,176}},
        color={0,0,127}));
    connect(minZonFlo[i].y, desZonPriOutAirRate[i].u2)
      annotation (Line(points={{-39,130}, {-30,130},{-30,164},{-22,164}},
        color={0,0,127}));
    connect(desZonPopulation[i].y, sumDesZonPop.u[i])
      annotation (Line(points={{-159,230},{-148,230},{-142,230}},
        color={0,0,127}));
    connect(desBreZonPer[i].y, sumDesBreZonPop.u[i])
      annotation (Line(points={{-159,190},{-140,190},{-140,210},{-62,210}},
        color={0,0,127}));
    connect(breZonAre[i].y, sumDesBreZonAre.u[i])
      annotation (Line(points={{-99,70}, {-40,70},{-40,110},{-22,110}},
        color={0,0,127}));
    connect(desZonPriOutAirRate[i].y, zonVenEff[i].u2)
      annotation (Line(points={{1,170}, {60,170},{60,144},{98,144}},
        color={0,0,127}));
    connect(addPar1.y, zonVenEff[i].u1)
      annotation (Line(points={{121,190},{128,190},{128,170},{90,170},
        {90,156},{98,156}}, color={0,0,127}));
    connect(swi[i].u2, occSenor[i].y)
      annotation (Line(points={{-122,20},{-134,20},{-134,30},{-139,30}},
        color={255,0,255}));
  end for;

  connect(cooCtrSig, greThr.u) annotation (Line(points={{-200,-60},{-200,-60},{
          -122,-60}}, color={0,0,127}));
  connect(uSupFan, not1.u)
    annotation (Line(points={{-200,-149.5},{-178,-149.5},{-178,-150},
      {-122,-150}}, color={255,0,255}));
  connect(priOutAirFra.y, maxPriOutAirFra.u[1:5])
    annotation (Line(points={{21,-180},{21,-180},{58,-180}}, color={0,0,127}));
  connect(sysPriAirRate.y, outAirFra.u2)
    annotation (Line(points={{21,-110},{30,-110},{30,-116},{38,-116}},
      color={0,0,127}));
  connect(outAirFra.y, addPar.u)
    annotation (Line(points={{61,-110},{61,-110},{78,-110}},
      color={0,0,127}));
  connect(addPar.y, sysVenEff.u1)
    annotation (Line(points={{101,-110},{101,-110},{100,-110},{102,-110},
      {110,-110},{110,-104},{118,-104}}, color={0,0,127}));
  connect(maxPriOutAirFra.yMax, sysVenEff.u2)
    annotation (Line(points={{81,-174}, {110,-174},{110,-116},{118,-116}},
      color={0,0,127}));
  connect(sysVenEff.y, effMinOutAirInt.u2)
    annotation (Line(points={{141,-110},{141,-110},{142,-110},{148,-110},
      {148,-116},{158,-116}}, color={0,0,127}));
  connect(sumDesZonPop.y, occDivFra.u2)
    annotation (Line(points={{-119,230},{-102,230},{-102,244}},
      color={0,0,127}));
  connect(peaSysPopulation.y, occDivFra.u1)
    annotation (Line(points={{-159,270},{-110,270},{-110,256},{-102,256}},
      color={0,0,127}));
  connect(sumDesBreZonPop.y, pro.u2)
    annotation (Line(points={{-39,210},{-30,210},{-30,244},{-22,244}},
      color={0,0,127}));
  connect(pro.y, unCorOutAirInk.u1)
    annotation (Line(points={{1,250},{10,250},{10,226.2},{18,226.2}},
      color={0,0,127}));
  connect(sumDesBreZonAre.y, unCorOutAirInk.u2)
    annotation (Line(points={{1,110},{10,110},{10,214.8},{18,214.8}},
      color={0,0,127}));
  connect(unCorOutAirInk.y, aveOutAirFra.u1)
    annotation (Line(points={{41,220.5},{50,220.5},{50,196},{58,196}},
      color={0,0,127}));
  connect(maxSysPriFlow.y, aveOutAirFra.u2)
    annotation (Line(points={{41,150},{50,150},{50,184},{58,184}},
      color={0,0,127}));
  connect(aveOutAirFra.y, addPar1.u)
    annotation (Line(points={{81,190},{88,190},{98,190}},  color={0,0,127}));
  connect(zonVenEff.y, desSysVenEff.u[1:5])
    annotation (Line(points={{121,150},{138,150}},color={0,0,127}));
  connect(unCorOutAirInk.y, desOutAirInt.u1)
    annotation (Line(points={{41,220.5},{180,220.5},{180,128},{120,128},
      {120,116},{138,116}},color={0,0,127}));
  connect(desSysVenEff.yMin, desOutAirInt.u2)
    annotation (Line(points={{161,144},{168,144},{168,134},{114,134},
      {114,104},{138,104}}, color={0,0,127}));
  connect(min1.y, effMinOutAirInt.u1)
    annotation (Line(points={{161,-50},{180,-50},{180,-80},{146,-80},
      {146,-104},{158,-104}}, color={0,0,127}));
  connect(sysUncOutAir.y, min1.u2)
    annotation (Line(points={{121,-50},{121,-50},{128,-50},{128,-56},{138,-56}},
      color={0,0,127}));
  connect(min1.y, outAirFra.u1)
    annotation (Line(points={{161,-50},{180,-50},{180,-80},{128,-80},
      {26,-80},{26,-104},{38,-104}}, color={0,0,127}));
  connect(unCorOutAirInk.y, min1.u1)
    annotation (Line(points={{41,220.5},{180,220.5},{180,60},{128,60},
      {128,-44},{138,-44}}, color={0,0,127}));
  connect(effMinOutAirInt.y, min.u2)
    annotation (Line(points={{181,-110},{181,-110},{188,-110},{188,-116},
      {198,-116}}, color={0,0,127}));
  connect(desOutAirInt.y, min.u1)
    annotation (Line(points={{161,110},{188,110},{188,56},{188,-104},
      {198,-104}}, color={0,0,127}));
  connect(unCorOutAirInk.y, desUncOutMin) annotation (Line(points={{41,220.5},{
          104,220.5},{104,220},{180,220},{180,180},{260,180}}, color={0,0,127}));
  connect(min.y, outMinSet) annotation (Line(points={{221,-110},{221,-110},{232,
          -110},{232,-70},{260,-70}}, color={0,0,127}));
  connect(desOutAirInt.y, desOutMin) annotation (Line(points={{161,110},{161,
          110},{188,110},{260,110}}, color={0,0,127}));
  connect(occDivFra.y, pro.u1)
    annotation (Line(points={{-79,250},{-68,250},{-68,256},{-22,256}},
      color={0,0,127}));
 annotation (
defaultComponentName="outAirMultiZone",
Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid), Text(
          extent={{-92,82},{84,-68}},
          lineColor={0,0,0},
          textString="minOATsp"),
        Text(
          extent={{-100,124},{98,102}},
          lineColor={0,0,255},
          textString="%name")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-200},{240,280}},
        initialScale=0.1), graphics={Rectangle(
          extent={{-180,280},{240,100}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None), Text(
          extent={{108,274},{204,240}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textString="Design condition",
          lineColor={0,0,255})}),
 Documentation(info="<html>      
<p>
This atomic sequence sets the minimum outdoor airflow setpoint for compliance 
with the ventilation rate procedure of ASHRAE 62.1-2013. The implementation 
is according to ASHRAE Guidline 36 (G36), PART5.N.3.a, PART5.B.2.b, 
PART3.1-D.2.a.
</p>   
<p>
<i>A. Zone outdoor airflow requirement <code>zonOutAirRate</code></i>
</p>

<ol>
<li>
Zone ventilation setpoints (G36, PART3.1A.2.a)
<ul>
<li>The area component of the breathing zone outdoor airflow: 
<code>breZonAre = zonAre*outAirPerAre</code></li>
<li>The population component of the breathing zone outdoor airflow: 
<code>breZonPop = occCou*outAirPerPer</code></li>
<li>Zone air distribution effectiveness <code>disEffHea</code> in Heating 
(default to 0.8 if no value scheduled)</li>
<li>Zone air distribution effectiveness <code>disEffCoo</code> in Cooling 
(default to 1.0 if no value scheduled)</li>
</ul>
</li>
<li>For each zone in any mode other than Occupied Mode and for zones that have 
window switches and the window is open, <code>zonOutAirRate</code> shall be 
zero.</li>
<li>Otherwise, the required zone outdoor airflow <code>zonOutAirRate</code> 
shall be calculated as follows:
<ul>
<li>
If the zone is populated, or if there is no occupancy sensor:
<ul>
<li>If discharge air temperature at the terminal unit is less than or equal to 
zone space temperature: <code>zonOutAirRate = (breZonAre+breZonPop)
/disEffCoo</code></li>
<li>If discharge air temperature at the terminal unit is greater than zone space 
temperature: <code>zonOutAirRate = (breZonAre+breZonPop)/disEffHea</code></li>
</ul>
</li>
<li>If the zone has an occupancy sensor and is unpopulated:
<ul>
<li>If discharge air temperature at the terminal unit is less than or equal to 
zone space temperature: <code>zonOutAirRate = breZonAre/disEffCoo</code></li>
<li>If discharge air temperature at the terminal unit is greater than zone 
space temperature: <code>zonOutAirRate = breZonAre/disEffHea</code></li>
</ul>
</li>
</ul>
</li>
</ol>

<p>
<i>B. <code>unCorOutAirInk</code> (Uncorrected design outdoor air 
rate) and <code>desOutAirInt</code> (Design total outdoor air rate):</i> 
determined using the 62MZCal spreadsheet provided with the ASHRAE 62.1 user manual. 
</p>

<ul>
<li><code>unCorOutAirInk</code>: the uncorrected design outdoor air rate, 
including diversity where applicable. </li>
<li><code>desOutAirInt</code>: design tool outdoor air rate.</li>
</ul>

<p>
<i>C. Outdoor air absolute minimum and design minimum setpoints are 
recalculated continuously based on the Mode of the zones being served.</i>
</p>
<ol>
<li>The <code>sysUncOutAir</code> is sum of <code>zonOutAirRate</code> for all 
zones in all Zone Groups that are in Occupied Mode, but shall be no larger than 
the design uncorrected outdoor air rate, <code>unCorOutAirInk</code>.</li>
<li>The <code>sysPriAirRate</code> is sum of the zone primary airflow rates, 
<code>priAirflow</code>, as measured by VAV boxes for all zones in all Zone 
Groups that are in Occupied Mode.</li>
<li>For each zone in Occupied Mode, calculate the zone primary outdoor air 
fraction <code>priOutAirFra</code>:
<code>priOutAirFra = zonOutAirRate/priAirflow</code></li>
<li>Calculate the maximum zone outdoor air fraction, <code>maxPriOutAirFra</code>: 
<code>maxPriOutAirFra = MAX(priOutAirFra)</code></li>
<li>Calculate the current system ventilation efficiency <code>sysVenEff</code>: 
<code>sysVenEff =1+(sysUncOutAir/sysPriAirRate)-maxPriOutAirFra</code></li>
<li>Calculate the effective minimum outdoor air setpoint <code>yVOutMinSet</code> 
as the uncorrected outdoor air intake <code>sysUncOutAir</code> divided by 
the system ventilation efficiency <code>sysVenEff</code>, but no larger than 
the design total outdoor air rate, <code>desOutAirInt</code>: 
<code>yVOutMinSet = MIN(sysUncOutAir/sysVenEff, desOutAirInt)</code></li>
</ol>

<h4>References</h4>
<p>
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR.
<i>ASHRAE Guideline 36P, High Performance Sequences of Operation for HVAC 
systems</i>. First Public Review Draft (June 2016)</a>
</p>

</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutdoorAirFlowSetpoint_MultiZone;
