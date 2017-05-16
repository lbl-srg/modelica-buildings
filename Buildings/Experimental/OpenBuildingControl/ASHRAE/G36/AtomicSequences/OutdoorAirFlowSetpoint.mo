within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
block OutdoorAirFlowSetpoint
  "Find out the minimum outdoor airflow rate setpoint"

  parameter Integer numOfZon = 5 "Total number of zones that the system serves";
  parameter Modelica.SIunits.VolumeFlowRate outAirPerAre[numOfZon](each displayUnit="m3/s)")= fill(3e-4, numOfZon) "Area outdoor air rate Ra, m3/s per unit area"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer[numOfZon](each displayUnit="m3/s") = fill(2.5e-3, numOfZon) "People outdoor air rate Rp, m3/s per person"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Modelica.SIunits.Area zonAre[numOfZon](each displayUnit="m2") = fill(40, numOfZon) "Area of each zone"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Boolean occSen[numOfZon] = fill(true, numOfZon) "Indicate if the zones have occupancy sensor, true or false";

  parameter Real occDen[numOfZon](each unit="1") = fill(0.05, numOfZon) "Default number of person in unit area";

  parameter Real zonDisEffHea[numOfZon](each unit="1") = fill(0.8, numOfZon) "Zone air distribution effectiveness (heating supply), if no value scheduled";
  parameter Real zonDisEffCoo[numOfZon](each unit="1") = fill(1.0, numOfZon) "Zone air distribution effectiveness (cooling supply), if no value scheduled";

  parameter Real desZonPop[numOfZon](min={occDen[i]*zonAre[i] for i in 1:numOfZon}, unit="1") = fill(3, numOfZon) "Design zone population: expected peak population"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Real desZonDisEff[numOfZon](each unit="1") = fill(1.0, numOfZon) "Design zone air distribution effectiveness"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Modelica.SIunits.VolumeFlowRate maxSysPriFlo(displayUnit="m3/s") = 1 "Maximum expected system primary airflow at design stage"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numOfZon](each displayUnit="m3/s") = fill(0.08, numOfZon) "Minimum expected zone primary flow rate"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));
  parameter Real peaSysPou(unit="1") = 20 "Peak system population"
    annotation(Evaluate=true, Dialog(group="Design Parameters"));

  CDL.Continuous.Constant desDisEff[numOfZon](k = {desZonDisEff[i] for i in 1:numOfZon})
    "Design zone air distribution effectiveness"
    annotation (Placement(transformation(extent={{-60,136},{-50,146}})));
  CDL.Continuous.Constant minZonFlo[numOfZon](k = {minZonPriFlo[i] for i in 1:numOfZon})
    "Design zone air distribution effectiveness"
    annotation (Placement(transformation(extent={{-34,118},{-24,128}})));

  CDL.Continuous.Constant breZonAre[numOfZon](k={outAirPerAre[i]*zonAre[i] for i in 1:numOfZon})
    "Area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-80,86},{-70,96}})));
  CDL.Continuous.Constant breZonPop[numOfZon](k={outAirPerPer[i]*zonAre[i]*occDen[i] for i in 1:numOfZon})
    "Population component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-98,42},{-88,52}})));

  CDL.Interfaces.RealInput occCou[numOfZon](each unit="1") "Number of human counts"
    annotation (Placement(transformation(extent={{-120,74},{-100,94}}),
        iconTransformation(extent={{-118,62},{-100,80}})));

  CDL.Continuous.Add breZon[numOfZon] "Breathing zone airflow"
    annotation (Placement(transformation(extent={{-62,76},{-52,86}})));

  CDL.Continuous.Gain gai[numOfZon](k = {outAirPerPer[i] for i in 1:numOfZon})    annotation (Placement(transformation(extent={{-96,80},
            {-88,88}})));
  CDL.Logical.Switch swi[numOfZon]    annotation (Placement(transformation(extent={{-78,68},
            {-68,78}})));
  CDL.Logical.Switch swi1[numOfZon]    annotation (Placement(transformation(extent={{-62,18},
            {-52,28}})));
  CDL.Continuous.Constant disEffHea[numOfZon](k = {zonDisEffHea[i] for i in 1:numOfZon})
    "Zone distribution effectiveness: Heating"
    annotation (Placement(transformation(extent={{-80,2},{-70,12}})));
  CDL.Continuous.Constant disEffCoo[numOfZon](k = {zonDisEffCoo[i] for i in 1:numOfZon})
    "Zone distribution effectiveness: Cooling"
    annotation (Placement(transformation(extent={{-80,34},{-70,44}})));

  CDL.Interfaces.RealInput uCoo(min=0, max=1, unit="1")
    "Cooling control signal."
    annotation (Placement(transformation(extent={{-120,13},{-100,33}}),
        iconTransformation(extent={{-118,26},{-100,44}})));
  CDL.Continuous.Division zonOutAirRate[numOfZon]
    "Required zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{-42,60},{-32,70}})));
  CDL.Logical.GreaterThreshold greThr
    annotation (Placement(transformation(extent={{-80,18},{-70,28}})));
  CDL.Continuous.Constant zerOutAir[numOfZon](k=fill(0,numOfZon))
    "Zero required outdoor airflow rate when window open or is not in occupied mode."
    annotation (Placement(transformation(extent={{-42,32},{-32,42}})));
  CDL.Interfaces.BooleanInput uSupFan "Supply Fan Status, on or off"
    annotation (Placement(transformation(extent={{-120,-25},{-100,-5}}),
        iconTransformation(extent={{-118,-46},{-100,-28}})));
  CDL.Interfaces.BooleanInput uWindow[numOfZon] "Window status, On or Off"
    annotation (Placement(transformation(extent={{-120,-12},{-100,8}}),
        iconTransformation(extent={{-118,-10},{-100,8}})));
  CDL.Logical.Not not1    annotation (Placement(transformation(extent={{-96,-20},
            {-86,-10}})));
  CDL.Logical.Switch swi2[numOfZon]    annotation (Placement(transformation(extent={{-24,56},
            {-14,46}})));
  CDL.Logical.Switch swi3[numOfZon]
    annotation (Placement(transformation(extent={{-6,46},{4,36}})));
  CDL.Interfaces.RealInput priAirflow[numOfZon](each min=minZonPriFlo, each unit="m3/s")
    "Primary airflow rate to the ventilation zone from the air handler, including outdoor air and recirculated air."
    annotation (Placement(transformation(extent={{-120,-44},{-100,-24}}),
        iconTransformation(extent={{-118,-80},{-100,-62}})));
  CDL.Continuous.Division priOutAirFra[numOfZon] "Primary outdoor air fraction"
    annotation (Placement(transformation(extent={{0,-36},{10,-26}})));
  CDL.Continuous.Sum       sysUncOutAir(nin=numOfZon)
    "Uncorrected outdoor airflow. "
    annotation (Placement(transformation(extent={{14,36},{24,46}})));
  CDL.Continuous.MinMax       maxPriOutAirFra(nin=numOfZon)
    "Maximum zone outdoor air fraction."
    annotation (Placement(transformation(extent={{52,-36},{62,-26}})));
  CDL.Continuous.Sum       sysPriAirRate(
                                        nin=numOfZon)
    "System primary airflow rate."
    annotation (Placement(transformation(extent={{14,4},{24,14}})));
  CDL.Continuous.Division outAirFra "Average outdoor air fraction"
    annotation (Placement(transformation(extent={{52,19},{62,29}})));
  CDL.Continuous.AddParameter addPar(p=1, k=1)
    annotation (Placement(transformation(extent={{68,18},{80,30}})));
  CDL.Continuous.Add sysVenEff(k2=-1) "Current system ventilation efficiency"
    annotation (Placement(transformation(extent={{88,0},{102,14}})));
  CDL.Continuous.Division effMinOutAirInt
    "Effective minimum outdoor air setpoint"
    annotation (Placement(transformation(extent={{108,5},{118,15}})));
  CDL.Interfaces.RealOutput yVOutMinSet(min=0, unit="m3/s")
    "Effective minimum outdoor airflow setpoint"                                     annotation (
      Placement(transformation(extent={{180,20},{200,40}}), iconTransformation(
          extent={{100,-10},{120,10}})));
  CDL.Continuous.Add desBreZon[numOfZon] "Breathing zone design airflow"
    annotation (Placement(transformation(extent={{-60,108},{-50,118}})));
  CDL.Continuous.Constant desBreZonPer[numOfZon](k={outAirPerPer[i]*desZonPop[i] for i in 1:numOfZon})
    "Population component of the breathing zone design outdoor airflow"
    annotation (Placement(transformation(extent={{-88,122},{-78,132}})));
  CDL.Continuous.Division desZonOutAirRate[numOfZon]
    "Required design zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{-34,138},{-24,148}})));
  CDL.Continuous.Division desZonPriOutAirRate[numOfZon]
    "Design zone primary outdoor air fraction"
    annotation (Placement(transformation(extent={{-14,128},{-4,138}})));
  CDL.Continuous.Constant desZonPopulation[numOfZon](k={desZonPop[i] for i in 1:numOfZon})
    "Design zone population"
    annotation (Placement(transformation(extent={{-90,166},{-80,176}})));
  CDL.Continuous.Sum       sumDesZonPop(nin=numOfZon)
    "Sum of the design zone population for all zones"
    annotation (Placement(transformation(extent={{-70,166},{-60,176}})));
  CDL.Continuous.Constant peaSysPopulation(k=peaSysPou)
    "Peak system population"
    annotation (Placement(transformation(extent={{-90,188},{-80,198}})));
  CDL.Continuous.Division occDivFra "Occupant diversity fraction"
    annotation (Placement(transformation(extent={{-46,168},{-36,178}})));
  CDL.Continuous.Sum       sumDesBreZonPop(nin=numOfZon)
    "Sum of the design breathing zone flow rate: population component"
    annotation (Placement(transformation(extent={{-14,156},{-4,166}})));
  CDL.Continuous.Sum       sumDesBreZonAre(nin=numOfZon)
    "Sum of the design breathing zone flow rate: area component"
    annotation (Placement(transformation(extent={{10,108},{20,118}})));
  CDL.Continuous.Add unCorOutAirInk "Uncorrected outdoor air intake"
    annotation (Placement(transformation(extent={{30,167},{40,177}})));
  CDL.Continuous.Product pro    annotation (Placement(transformation(extent={{10,168},
            {20,178}})));

  CDL.Continuous.Constant maxSysPriFlow(k=maxSysPriFlo)
    "Highest expected system primary airflow"
    annotation (Placement(transformation(extent={{30,142},{40,152}})));
  CDL.Continuous.Division aveOutAirFra "Average outdoor air fraction"
    annotation (Placement(transformation(extent={{50,156},{60,166}})));
  CDL.Continuous.AddParameter addPar1(p=1, k=1)
    annotation (Placement(transformation(extent={{68,156},{78,166}})));
  CDL.Continuous.Add zonVenEff[numOfZon] "Zone ventilation efficiency"
    annotation (Placement(transformation(extent={{90,142},{100,152}})));
  CDL.Continuous.MinMax       desSysVenEff(nin=numOfZon)
    "Design system ventilation efficiency"
    annotation (Placement(transformation(extent={{108,142},{118,152}})));
  CDL.Continuous.Division desOutAirInt "Design system outdoor air intake"
    annotation (Placement(transformation(extent={{106,118},{116,128}})));
  CDL.Continuous.Min min
    annotation (Placement(transformation(extent={{126,25},{136,35}})));
  CDL.Continuous.Min min1
    "Uncorrected outdoor air rate should not be higher than its design value."
    annotation (Placement(transformation(extent={{32,62},{42,72}})));
  CDL.Interfaces.RealOutput yDesOutMin(min=0, unit="m3/s") "Design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{180,118},{200,138}}),
        iconTransformation(extent={{100,38},{120,58}})));
  CDL.Interfaces.RealOutput yDesUncOutMin(min=0, unit="m3/s")
    "Design uncorrected minimum outdoor airflow rate" annotation (Placement(
        transformation(extent={{180,162},{200,182}}), iconTransformation(extent=
           {{100,68},{120,88}})));
  CDL.Logical.Switch swi4 "Single zone or multiple zone"
    annotation (Placement(transformation(extent={{160,-18},{170,-28}})));
  CDL.Continuous.Constant numZon(k=numOfZon) "Total numbe of zone"
    annotation (Placement(transformation(extent={{100,-28},{110,-18}})));
  CDL.Logical.LessEqualThreshold lesEquThr(threshold=1)
    annotation (Placement(transformation(extent={{120,-29},{132,-17}})));
  CDL.Logical.Switch swi5 "Single zone or multiple zone"
    annotation (Placement(transformation(extent={{158,122},{168,132}})));

  CDL.Logical.Switch swi6 "Single zone or multiple zone"
    annotation (Placement(transformation(extent={{-14,176},{-4,186}})));
  CDL.Continuous.Constant constant1(k=1)
    "When it is single zone, peak system population should equal to the sum of zone design population"
    annotation (Placement(transformation(extent={{-46,188},{-36,198}})));
  CDL.Logical.Constant occSenor[numOfZon](k={occSen[i] for i in 1:numOfZon}) "If there is occupancy sensor"
    annotation (Placement(transformation(extent={{-98,62},{-88,72}})));
equation
  for i in 1:numOfZon loop
    connect(breZonAre[i].y, breZon[i].u1) annotation (Line(points={{-69.5,91},{-66,
            91},{-66,84},{-63,84}}, color={0,0,127}));
    connect(gai[i].y, swi[i].u1) annotation (Line(points={{-87.6,84},{-84,84},{-84,
            77},{-79,77}},
                         color={0,0,127}));
    connect(breZonPop[i].y, swi[i].u3) annotation (Line(points={{-87.5,47},{-82,
            47},{-82,69},{-79,69}}, color={0,0,127}));
    connect(gai[i].u, occCou[i]) annotation (Line(points={{-96.8,84},{-100,84},{
            -104,84},{-110,84}},
                       color={0,0,127}));
    connect(swi[i].y, breZon[i].u2) annotation (Line(points={{-67.5,73},{-66,73},
            {-66,78},{-63,78}}, color={0,0,127}));
    connect(disEffCoo[i].y, swi1[i].u1) annotation (Line(points={{-69.5,39},{-68,
            39},{-68,27},{-63,27}},
                              color={0,0,127}));
    connect(disEffHea[i].y, swi1[i].u3) annotation (Line(points={{-69.5,7},{-68,
            7},{-68,19},{-63,19}},
                              color={0,0,127}));
    connect(breZon[i].y, zonOutAirRate[i].u1) annotation (Line(points={{-51.5,81},{
            -48,81},{-48,68},{-43,68}}, color={0,0,127}));
    connect(swi1[i].y, zonOutAirRate[i].u2) annotation (Line(points={{-51.5,23},{-48,
            23},{-48,62},{-43,62}}, color={0,0,127}));
    connect(greThr.y, swi1[i].u2) annotation (Line(points={{-69.5,23},{-66.75,23},
            {-63,23}},           color={255,0,255}));
    connect(uWindow[i], swi2[i].u2) annotation (Line(points={{-110,-2},{-46,-2},
            {-46,51},{-25,51}},
                              color={255,0,255}));
    connect(zerOutAir[i].y, swi2[i].u1) annotation (Line(points={{-31.5,37},{-28,
            37},{-28,47},{-25,47}},
                              color={0,0,127}));
    connect(zonOutAirRate[i].y, swi2[i].u3) annotation (Line(points={{-31.5,65},
            {-28,65},{-28,55},{-25,55}}, color={0,0,127}));
    connect(swi2[i].y, swi3[i].u3) annotation (Line(points={{-13.5,51},{-7,51},{
            -7,45}},            color={0,0,127}));
    connect(zerOutAir[i].y, swi3[i].u1) annotation (Line(points={{-31.5,37},{-28,
            37},{-7,37}},    color={0,0,127}));
    connect(not1.y, swi3[i].u2) annotation (Line(points={{-85.5,-15},{-38,-15},{
            -38,18},{-18,18},{-18,41},{-7,41}},
                        color={255,0,255}));
    connect(swi3[i].y, priOutAirFra[i].u1) annotation (Line(points={{4.5,41},{6,
            41},{6,-14},{-8,-14},{-8,-28},{-1,-28}},
                                             color={0,0,127}));
    connect(swi3[i].y,sysUncOutAir. u[i])
    annotation (Line(points={{4.5,41},{8,41},{13,41}},
                                                color={0,0,127}));
    connect(priAirflow[i], priOutAirFra[i].u2)   annotation (Line(points={{-110,
            -34},{-110,-34},{-1,-34}},                                                                    color={0,0,127}));
    connect(priAirflow[i],sysPriAirRate. u[i]) annotation (Line(points={{-110,-34},
            {-72,-34},{-32,-34},{-32,8},{13,8},{13,9}},  color={0,0,127}));
    connect(breZonAre[i].y, desBreZon[i].u2) annotation (Line(points={{-69.5,91},
            {-66,91},{-66,110},{-61,110}}, color={0,0,127}));
    connect(desBreZonPer[i].y, desBreZon[i].u1) annotation (Line(points={{-77.5,
            127},{-66,127},{-66,116},{-61,116}}, color={0,0,127}));
    connect(desDisEff[i].y, desZonOutAirRate[i].u2) annotation (Line(points={{-49.5,
            141},{-46,141},{-46,140},{-35,140}},
                                               color={0,0,127}));
    connect(desBreZon[i].y, desZonOutAirRate[i].u1) annotation (Line(points={{-49.5,
            113},{-44,113},{-44,146},{-35,146}},
                                               color={0,0,127}));
    connect(desZonOutAirRate[i].y, desZonPriOutAirRate[i].u1) annotation (Line(
        points={{-23.5,143},{-20,143},{-20,136},{-15,136}}, color={0,0,127}));
    connect(minZonFlo[i].y, desZonPriOutAirRate[i].u2) annotation (Line(points={{-23.5,
            123},{-20,123},{-20,130},{-15,130}},
                                               color={0,0,127}));
    connect(desZonPopulation[i].y, sumDesZonPop.u[i]) annotation (Line(points={{-79.5,
            171},{-71,171}},                         color={0,0,127}));
    connect(desBreZonPer[i].y, sumDesBreZonPop.u[i]) annotation (Line(points={{-77.5,
            127},{-66,127},{-66,161},{-15,161}},
                                               color={0,0,127}));
    connect(breZonAre[i].y, sumDesBreZonAre.u[i]) annotation (Line(points={{-69.5,
            91},{-10,91},{-10,113},{9,113}}, color={0,0,127}));
    connect(desZonPriOutAirRate[i].y, zonVenEff[i].u2) annotation (Line(points={
            {-3.5,133},{84,133},{84,144},{89,144}}, color={0,0,127}));
    connect(addPar1.y, zonVenEff[i].u1) annotation (Line(points={{78.5,161},{84,
            161},{84,150},{89,150}}, color={0,0,127}));
    connect(swi[i].u2, occSenor[i].y) annotation (Line(points={{-79,73},{-84,73},
            {-84,67},{-87.5,67}},
                               color={255,0,255}));
  end for;

  connect(uCoo, greThr.u) annotation (Line(points={{-110,23},{-96,23},{-81,23}},
                    color={0,0,127}));
  connect(uSupFan, not1.u) annotation (Line(points={{-110,-15},{-103.5,-15},{-97,
          -15}}, color={255,0,255}));

  connect(priOutAirFra.y, maxPriOutAirFra.u[1:5]) annotation (Line(points={{10.5,
          -31},{15.25,-31},{51,-31}},                 color={0,0,127}));

  connect(sysPriAirRate.y, outAirFra.u2) annotation (Line(points={{24.5,9},{38,9},
          {38,21},{51,21}},     color={0,0,127}));
  connect(outAirFra.y, addPar.u)  annotation (Line(points={{62.5,24},{62.5,24},{66.8,24}},
                                                   color={0,0,127}));
  connect(addPar.y, sysVenEff.u1) annotation (Line(points={{80.6,24},{84,24},{84,
          11.2},{86.6,11.2}}, color={0,0,127}));
  connect(maxPriOutAirFra.yMax, sysVenEff.u2) annotation (Line(points={{62.5,-28},
          {68,-28},{68,2.8},{86.6,2.8}},  color={0,0,127}));
  connect(sysVenEff.y, effMinOutAirInt.u2)    annotation (Line(points={{102.7,7},{102.7,7},{107,7}}, color={0,0,127}));

  connect(sumDesZonPop.y, occDivFra.u2) annotation (Line(points={{-59.5,171},{
          -50,171},{-50,170},{-47,170}},
                                     color={0,0,127}));
  connect(peaSysPopulation.y, occDivFra.u1) annotation (Line(points={{-79.5,193},
          {-54,193},{-54,176},{-47,176}}, color={0,0,127}));

  connect(sumDesBreZonPop.y, pro.u2) annotation (Line(points={{-3.5,161},{2,161},
          {2,170},{9,170}}, color={0,0,127}));
  connect(pro.y, unCorOutAirInk.u1) annotation (Line(points={{20.5,173},{24,173},
          {24,175},{29,175}}, color={0,0,127}));
  connect(sumDesBreZonAre.y, unCorOutAirInk.u2) annotation (Line(points={{20.5,113},
          {24,113},{24,169},{29,169}}, color={0,0,127}));
  connect(unCorOutAirInk.y, aveOutAirFra.u1) annotation (Line(points={{40.5,172},
          {44,172},{44,164},{49,164}}, color={0,0,127}));
  connect(maxSysPriFlow.y, aveOutAirFra.u2) annotation (Line(points={{40.5,147},
          {44,147},{44,158},{49,158}}, color={0,0,127}));
  connect(aveOutAirFra.y, addPar1.u)    annotation (Line(points={{60.5,161},{67,161}}, color={0,0,127}));

  connect(zonVenEff.y, desSysVenEff.u[1:5]) annotation (Line(points={{100.5,147},
          {104.25,147},{104.25,147},{107,147}},     color={0,0,127}));
  connect(unCorOutAirInk.y, desOutAirInt.u1) annotation (Line(points={{40.5,172},
          {130,172},{130,134},{100,134},{100,126},{105,126}}, color={0,0,127}));
  connect(desSysVenEff.yMin, desOutAirInt.u2) annotation (Line(points={{118.5,144},
          {124,144},{124,138},{96,138},{96,120},{105,120}}, color={0,0,127}));
  connect(min1.y, effMinOutAirInt.u1) annotation (Line(points={{42.5,67},{104,67},
          {104,13},{107,13}}, color={0,0,127}));
  connect(sysUncOutAir.y, min1.u2) annotation (Line(points={{24.5,41},{28,41},{28,
          64},{31,64}}, color={0,0,127}));
  connect(min1.y, outAirFra.u1) annotation (Line(points={{42.5,67},{46,67},{46,27},
          {51,27}}, color={0,0,127}));
  connect(unCorOutAirInk.y, min1.u1) annotation (Line(points={{40.5,172},{130,172},
          {130,90},{28,90},{28,70},{31,70}}, color={0,0,127}));
  connect(effMinOutAirInt.y, min.u2) annotation (Line(points={{118.5,10},{120,10},
          {120,27},{125,27}}, color={0,0,127}));
  connect(desOutAirInt.y, min.u1) annotation (Line(points={{116.5,123},{120,123},
          {120,66},{120,33},{125,33}},          color={0,0,127}));
  connect(unCorOutAirInk.y, yDesUncOutMin) annotation (Line(points={{40.5,172},{
          190,172}},             color={0,0,127}));
  connect(numZon.y, lesEquThr.u) annotation (Line(points={{110.5,-23},{110.5,-23},
          {118.8,-23}}, color={0,0,127}));
  connect(lesEquThr.y, swi4.u2)    annotation (Line(points={{132.6,-23},{159,-23}}, color={255,0,255},
      pattern=LinePattern.Dash));
  connect(sysUncOutAir.y, swi4.u1) annotation (Line(
      points={{24.5,41},{28,41},{28,-40},{150,-40},{150,-27},{159,-27}},
      color={0,0,127}));
  connect(min.y, swi4.u3) annotation (Line(points={{136.5,30},{150,30},{150,-19},
          {159,-19}}, color={0,0,127}));
  connect(swi4.y, yVOutMinSet) annotation (Line(points={{170.5,-23},{174,-23},{174,
          30},{190,30}}, color={0,0,127}));
  connect(desOutAirInt.y, swi5.u3) annotation (Line(points={{116.5,123},{130.25,
          123},{157,123}}, color={0,0,127}));
  connect(lesEquThr.y, swi5.u2) annotation (Line(points={{132.6,-23},{142,-23},
          {142,127},{157,127}},color={255,0,255},
      pattern=LinePattern.Dash));
  connect(swi5.y, yDesOutMin) annotation (Line(points={{168.5,127},{175.25,127},
          {175.25,128},{190,128}}, color={0,0,127}));
  connect(unCorOutAirInk.y, swi5.u1) annotation (Line(points={{40.5,172},{40.5,
          172},{150,172},{150,131},{157,131}},
                                          color={0,0,127}));
  connect(lesEquThr.y, swi6.u2) annotation (Line(
      points={{132.6,-23},{142,-23},{142,200},{-22,200},{-22,181},{-15,181}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(swi6.y, pro.u1) annotation (Line(points={{-3.5,181},{2,181},{2,176},{
          9,176}}, color={0,0,127}));
  connect(constant1.y, swi6.u1) annotation (Line(points={{-35.5,193},{-28,193},
          {-28,185},{-15,185}}, color={0,0,127}));
  connect(occDivFra.y, swi6.u3) annotation (Line(points={{-35.5,173},{-28,173},
          {-28,177},{-15,177}}, color={0,0,127}));
  connect(swi[1].u2, occSenor[1].y) annotation (Line(points={{-79,73},{-84,73},{
          -84,67},{-87.5,67}}, color={255,0,255}));
 annotation (Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid), Text(
          extent={{-92,82},{84,-68}},
          lineColor={0,0,0},
          textString="minOATsp")}),                             Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{180,200}},
        initialScale=0.1), graphics={Rectangle(
          extent={{-100,104},{180,200}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}), Text(
          extent={{76,200},{118,180}},
          lineColor={0,0,255},
          pattern=LinePattern.Dash,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          fontSize=14,
          textStyle={TextStyle.Bold},
          horizontalAlignment=TextAlignment.Left,
          textString="Design condition")}),
 Documentation(info="<html>      
<p>
This atomic sequence sets the minimum outdoor airflow setpoint. The implementation is according
to ASHRAE Guidline 36 (G36), PART5.N.3.a, PART5.B.2.b, PART3.1-D.2.a.
</p>   
<h4>Multizone AHU: minimum outdoor airflow setpoint (PART5.N.3.a)</h4>
<p>
<i>A. Zone outdoor airflow requirement <code>zonOutAirRate</code>, for compliance with the ventilation rate procedure of ASHRAE 62.1-2013</i>
</p>
<ol>
<li>
Zone ventilation setpoints (G36, PART3.1A.2.a)
<ul>
<li>The area component of the breathing zone outdoor airflow <code>breZonAre = zonAre*outAirPerAre</code></li>
<li>The population component of the breathing zone outdoor airflow <code>breZonPop = occCou*outAirPerPer</code></li>
<li>Zone air distribution effectiveness <code>disEffHea</code> in Heating (default to 0.8 if no value scheduled)</li>
<li>Zone air distribution effectiveness <code>disEffCoo</code> in Cooling (default to 1.0 if no value scheduled)</li>
</ul>
</li>
<li>
For each zone in any mode other than Occupied Mode and for zones that have window switches and the window is open, <code>zonOutAirRate</code> shall be zero.
</li>
<li>
Otherwise, the required zone outdoor airflow <code>zonOutAirRate</code> shall be calculated as follows:
<ul>
<li>
If the zone is populated, or if there is no occupancy sensor:
<ul>
<li>If discharge air temperature at the terminal unit is less than or equal to zone space temperature: <code>zonOutAirRate = (breZonAre+breZonPop)/disEffCoo</code></li>
<li>If discharge air temperature at the terminal unit is greater than zone space temperature: <code>zonOutAirRate = (breZonAre+breZonPop)/disEffHea</code></li>
</ul>
</li>
<li>
If the zone has an occupancy sensor and is unpopulated:
<ul>
<li>If discharge air temperature at the terminal unit is less than or equal to zone space temperature: <code>zonOutAirRate = breZonAre/disEffCoo</code> </li>
<li>If discharge air temperature at the terminal unit is greater than zone space temperature: <code>zonOutAirRate = breZonAre/disEffHea</code></li>
</ul>
</li>
</ul>
</li>
</ol>
</p>

<p>
<i>B. Setpoints <code>unCorOutAirInk</code> (Uncorrected design outdoor air rate) and <code>desOutAirInt</code> (Design total outdoor air rate). 
<code>unCorOutAirInk</code> and <code>desOutAirInt</code> can be determined using the 62MZCal spreadsheet provided with the ASHRAE 62.1 user manual.</i>
<li> 
<ul>
<li><code>unCorOutAirInk</code>: the uncorrected design outdoor air rate, including diversity where applicable.</li>
<li><code>desOutAirInt</code>: design tool outdoor air rate.</li>
</ul>
</li>
</p>

<p>
<i>C. Outdoor air absolute minimum and design minimum setpoints are recalculated continuously based on the Mode of the zones being served.</i>
<ol>
<li>The <code>sysUncOutAir</code> is sum of <code>zonOutAirRate</code> for all zones in all Zone Groups that are in Occupied Mode, 
but shall be no larger than the design uncorrected outdoor air rate, <code>unCorOutAirInk</code>.</li>
<li>The <code>sysPriAirRate</code> is sum of the zone primary airflow rates, <code>priAirflow</code>, as measured by VAV boxes for all zones in all Zone Groups that are in Occupied Mode.</li>
<li>For each zone in Occupied Mode, calculate the zone primary outdoor air fraction <code>priOutAirFra</code>:</li>
<code>priOutAirFra = zonOutAirRate/priAirflow</code>
<li>Calculate the maximum zone outdoor air fraction, <code>maxPriOutAirFra</code>: </li>
<code>maxPriOutAirFra = MAX(priOutAirFra)</code>
<li>Calculate the current system ventilation efficiency <code>sysVenEff</code>: </li>
<code>sysVenEff =1+(sysUncOutAir/sysPriAirRate)-maxPriOutAirFra</code>
<li>Calculate the effective minimum outdoor air setpoint <code>yVOutMinSet</code> as the uncorrected outdoor air intake <code>sysUncOutAir</code> divided by 
the system ventilation efficiency <code>sysVenEff</code>, but no larger than the design total outdoor air rate, <code>desOutAirInt</code>: </li>
<code>yVOutMinSet = MIN(sysUncOutAir/sysVenEff, desOutAirInt)</code>
</ol>
</p>

<h4>Single zone AHU: minimum outdoor airflow setpoint (PART5.P.4.b)</h4>
<ol> 
<li>
Calculate the required zone outdoor airflow <code>zonOutAirRate</code> as follows:
<ul>
<li>If discharge air temperature at the terminal unit is less than zone space temperature:  <code>zonOutAirRate = (breZonAre+breZonPop)/disEffCoo</code></li>
<li>If discharge air temperature at the terminal unit is greater than zone space temperature:  <code>zonOutAirRate = (breZonAre+breZonPop)/disEffCoo</code></li>
</ul>
</li>
<li>
Calculate the area component <code>zonOutAirRateAre</code> of the required zone outdoor airflow as follows:
<ul>
<li>If discharge air temperature at the terminal unit is less than zone space temperature: <code>zonOutAirRateAre = breZonAre/disEffCoo</code></li>
<li>If discharge air temperature at the terminal unit is greater than zone space temperature: <code>zonOutAirRateAre = breZonAre/disEffHea</code></li>
</ul>
</li>
<li>
While the zone is in Occupied Mode, the minimum outdoor air setpoint <code>yVOutMinSet</code> shall be reset based on the zone CO2 control loop signal from <code>zonOutAirRateAre</code> at <code>0%</code> signal 
to <code>zonOutAirRate</code> at <code>100%</code> signal.
</li>
<li>
If the zone has an occupancy sensor, <code>yVOutMinSet</code> shall equal <code>zonOutAirRateAre</code> when the zone is unpopulated.
</li>
<li>
If the zone has a window switch, <code>yVOutMinSet</code> shall be zero when the window is open.
</li>
<li>
When the zone is in other than Occupied Mode, <code>yVOutMinSet</code> shall be zero.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutdoorAirFlowSetpoint;
