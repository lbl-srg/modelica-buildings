within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints;
block OutsideAirFlow
  "Output the minimum outdoor airflow rate setpoint for systems with multiple zones"

  parameter Integer numZon(min=2)
    "Total number of zones that the system serves";
  parameter Real outAirPerAre[numZon](each final unit = "m3/(s.m2)")=
      fill(3e-4, numZon)
    "Outdoor air rate per unit area"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate outAirPerPer[numZon]=
      fill(2.5e-3, numZon)
    "Outdoor air rate per person"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Area zonAre[numZon]
    "Area of each zone"
    annotation(Dialog(group="Nominal condition"));
  parameter Boolean have_occSen[numZon]=fill(true, numZon)
    "Set to true if zones have occupancy sensor";
  parameter Real occDen[numZon](each final unit="1/m2") = fill(0.05, numZon)
    "Default number of person in unit area";
  parameter Real zonDisEffHea[numZon](each final unit="1") = fill(0.8, numZon)
    "Zone air distribution effectiveness during heating";
  parameter Real zonDisEffCoo[numZon](each final unit="1") = fill(1.0, numZon)
    "Zone air distribution effectiveness during cooling";
  parameter Real desZonDisEff[numZon](each unit="1") = fill(1.0, numZon)
    "Design zone air distribution effectiveness"
    annotation(Dialog(group="Nominal condition"));
  parameter Real desZonPop[numZon](
    min={occDen[i]*zonAre[i] for i in 1:numZon},
    each unit="1") = {occDen[i]*zonAre[i] for i in 1:numZon}
    "Design zone population during peak occupancy"
    annotation(Dialog(group="Nominal condition"));
  parameter Real uLow(final unit="K",
    quantity="ThermodynamicTemperature") = -0.5
    "If zone space temperature minus supply air temperature is less than uLow,
     then it should use heating supply air distribution effectiveness"
    annotation (Dialog(tab="Advanced"));
  parameter Real uHig(final unit="K",
    quantity="ThermodynamicTemperature") = 0.5
    "If zone space temperature minus supply air temperature is more than uHig,
     then it should use cooling supply air distribution effectiveness"
    annotation (Dialog(tab="Advanced"));
  parameter Modelica.SIunits.VolumeFlowRate maxSysPriFlo
    "Maximum expected system primary airflow at design stage"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numZon]
    "Minimum expected zone primary flow rate"
    annotation(Dialog(group="Nominal condition"));
  parameter Real peaSysPop(unit="1") = 1.2*sum({occDen[iZon] * zonAre[iZon] for iZon in 1:numZon})
    "Peak system population"
    annotation(Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput nOcc[numZon](each final unit="1")
    "Number of occupants"
    annotation (Placement(transformation(extent={{-220,60},{-180,100}}),
      iconTransformation(extent={{-120,70},{-100,90}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBox_flow[numZon](
    min=0,
    each final unit="m3/s",
    each quantity="VolumeFlowRate")
    "Primary airflow rate to the ventilation zone from the air handler, including outdoor air and recirculated air"
    annotation (Placement(transformation(extent={{-220,-220},{-180,-180}}),
      iconTransformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon](
    each final unit="K",
    each quantity="ThermodynamicTemperature") "Measured zone air temperature"
    annotation (Placement(transformation(extent={{-220,-40},{-180,0}}),
      iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis[numZon](
    each final unit="K",
    each quantity="ThermodynamicTemperature") "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
      iconTransformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-220,-180},{-180,-140}}),
    iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status, true if on, false if off"
    annotation (Placement(transformation(extent={{-220,-150},{-180,-110}}),
    iconTransformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin[numZon]
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-220,-120},{-180,-80}}),
      iconTransformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDesOutMin_flow_nominal(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{240,90},{280,130}}),
      iconTransformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDesUncOutMin_flow_nominal(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate")
    "Design uncorrected minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{240,160},{280,200}}),
      iconTransformation(extent={{100,70},{120,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOutMinSet_flow(
    min=0,
    final unit="m3/s",
    quantity="VolumeFlowRate") "Effective minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,-70},{280,-30}}),
      iconTransformation(extent={{100,-10},{120,10}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Add breZon[numZon] "Breathing zone airflow"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai[numZon](
    final k = outAirPerPer) "Outdoor air per person"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[numZon]
    "If there is occupancy sensor, then using the real time occupancy; otherwise, using the default occupancy"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1[numZon]
    "Switch between cooling or heating distribution effectiveness"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Division zonOutAirRate[numZon]
    "Required zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2[numZon]
    "If window is open or it is not in occupied mode, the required outdoor airflow rate should be zero"
    annotation (Placement(transformation(extent={{20,20},{40,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi3[numZon]
    "If supply fan is off, then outdoor airflow rate should be zero"
    annotation (Placement(transformation(extent={{60,-20},{80,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max [numZon]
    "If supply fan is off, giving a small primary airflow rate to avoid division by zero"
    annotation (Placement(transformation(extent={{-40,-170},{-20,-190}})));
  Buildings.Controls.OBC.CDL.Continuous.Division priOutAirFra[numZon]
    "Primary outdoor air fraction"
    annotation (Placement(transformation(extent={{40,-184},{60,-164}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sysUncOutAir(final nin=numZon)
    "Uncorrected outdoor airflow"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sysPriAirRate(final nin=numZon)
    "System primary airflow rate"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Division outAirFra "System outdoor air fraction"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(final p=1, final k=1)
    "System outdoor air flow fraction plus 1"
    annotation (Placement(transformation(extent={{80,-100},{100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add sysVenEff(final k2=-1)
    "Current system ventilation efficiency"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Division effMinOutAirInt
    "Effective minimum outdoor air setpoint"
    annotation (Placement(transformation(extent={{154,-100},{174,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Add desBreZon[numZon] "Breathing zone design airflow"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Division desZonOutAirRate[numZon]
    "Required design zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Division desZonPriOutAirRate[numZon]
    "Design zone primary outdoor air fraction"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumDesZonPop(final nin=numZon)
    "Sum of the design zone population for all zones"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Division occDivFra "Occupant diversity fraction"
    annotation (Placement(transformation(extent={{-98,244},{-78,264}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumDesBreZonPop(final nin=numZon)
    "Sum of the design breathing zone flow rate for population component"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumDesBreZonAre(final nin=numZon)
    "Sum of the design breathing zone flow rate for area component"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Add unCorOutAirInk "Uncorrected outdoor air intake"
    annotation (Placement(transformation(extent={{20,211},{40,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product of inputs"
    annotation (Placement(transformation(extent={{-20,240},{0,260}})));
  Buildings.Controls.OBC.CDL.Continuous.Division aveOutAirFra "Average outdoor air fraction"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(final p=1, final k=1)
    "Average outdoor air flow fraction plus 1"
    annotation (Placement(transformation(extent={{100,180},{120,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Add zonVenEff[numZon](each final k2=-1)
    "Zone ventilation efficiency"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2[numZon](each final k1=+1, each final k2=-1)
    "Zone space temperature minus supply air temperature"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Division desOutAirInt "Design system outdoor air intake"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin desSysVenEff(nin=numZon)
    "Design system ventilation efficiency"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax maxPriOutAirFra(nin=numZon)
    "Maximum zone outdoor air fraction"
    annotation (Placement(transformation(extent={{80,-184},{100,-164}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min
    "Minimum outdoor airflow rate should not be more than designed outdoor airflow rate"
    annotation (Placement(transformation(extent={{200,-100},{220,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min1
    "Uncorrected outdoor air rate should not be higher than its design value"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[numZon](
    each uLow=uLow,
    each uHigh=uHig,
    each pre_y_start=true)
    "Check if cooling or heating air distribution effectiveness should be applied, with 1 degC deadband"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSen[numZon](k=
        have_occSen) "Boolean constant to indicate if there is occupancy sensor"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(k=Constants.OperationModes.occupied)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-170,-190},{-150,-170}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desDisEff[numZon](
    k = desZonDisEff)
    "Design zone air distribution effectiveness"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minZonFlo[numZon](
    k = minZonPriFlo)
    "Minimum expected zone primary flow rate"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant breZonAre[numZon](
    k={outAirPerAre[i]*zonAre[i] for i in 1:numZon})
    "Area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-170,110},{-150,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant breZonPop[numZon](
    k={outAirPerPer[i]*zonAre[i]*occDen[i] for i in 1:numZon})
    "Population component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant disEffHea[numZon](
    k = zonDisEffHea)
    "Zone distribution effectiveness for heating"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant disEffCoo[numZon](
    k = zonDisEffCoo)
    "Zone distribution effectiveness fo cooling"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desZonPopulation[numZon](
    k=desZonPop)
    "Design zone population"
    annotation (Placement(transformation(extent={{-168,220},{-148,240}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerOutAir[numZon](k=fill(0,numZon))
    "Zero required outdoor airflow rate when window is open or when zone is not in occupied mode"
    annotation (Placement(transformation(extent={{-40,-8},{-20,12}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desBreZonPer[numZon](
    k={outAirPerPer[i]*desZonPop[i] for i in 1:numZon})
    "Population component of the breathing zone design outdoor airflow"
    annotation (Placement(transformation(extent={{-168,180},{-148,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant peaSysPopulation(k=peaSysPop)
    "Peak system population"
    annotation (Placement(transformation(extent={{-168,250},{-148,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxSysPriFlow(k=maxSysPriFlo)
    "Highest expected system primary airflow"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(nout=numZon)
    "Replicate Boolean input"
    annotation (Placement(transformation(extent={{-80,-140},{-60,-120}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(nout=numZon)
    "Replicate Real input signal"
    annotation (Placement(transformation(extent={{140,180},{160,200}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-130,-170},{-110,-150}})));
  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-160,-140},{-140,-120}})));

  CDL.Continuous.Gain gaiDivZer(final k=1E-3)
    "Gain, used to avoid division by zero if the flow rate is smaller than 0.1%"
    annotation (Placement(transformation(extent={{-120,-220},{-100,-200}})));

  CDL.Routing.RealReplicator reaRepDivZer(final nout=numZon)
    "Signal replicator to avoid division by zero"
    annotation (Placement(transformation(extent={{-80,-220},{-60,-200}})));
equation
  connect(breZonAre.y, breZon.u1)
    annotation (Line(points={{-149,120},{-140,120},{-140,110},{-90,110},
      {-90,56}, {-82,56}}, color={0,0,127}));
  connect(gai.y, swi.u1)
    annotation (Line(points={{-139,80},{-128,80},{-128,48},{-122,48}},
      color={0,0,127}));
  connect(breZonPop.y, swi.u3)
    annotation (Line(points={{-139,10},{-134,10},{-134,32},{-122,32}},
      color={0,0,127}));
  connect(gai.u, nOcc)
    annotation (Line(points={{-162,80},{-200,80}}, color={0,0,127}));
 connect(swi.y, breZon.u2)
    annotation (Line(points={{-99,40},{-99,40},{-90,40},{-90,44},{-82,44}},
      color={0,0,127}));
  connect(disEffCoo.y, swi1.u1)
    annotation (Line(points={{-99,-10},{-92,-10},{-92,-32},{-82,-32}},
      color={0,0,127}));
  connect(disEffHea.y, swi1.u3)
    annotation (Line(points={{-99,-70},{-92,-70},{-92,-48},{-82,-48}},
      color={0,0,127}));
  connect(breZon.y, zonOutAirRate.u1)
    annotation (Line(points={{-59,50},{-50,50},{-50,56},{-42,56}},
      color={0,0,127}));
  connect(swi1.y, zonOutAirRate.u2)
    annotation (Line(points={{-59,-40},{-50,-40},{-50,44},{-42,44}}, color={0,0,127}));
  connect(uWin, swi2.u2)
    annotation (Line(points={{-200,-100},{-44,-100},{-44,-34},{-8,-34},{-8,10},{18,10}},
      color={255,0,255}));
  connect(zerOutAir.y, swi2.u1)
    annotation (Line(points={{-19,2},{0,2},{18,2}},
      color={0,0,127}));
  connect(zonOutAirRate.y, swi2.u3)
    annotation (Line(points={{-19,50},{0,50},{0,18},{18,18}},
      color={0,0,127}));
  connect(swi2.y, swi3.u3)
    annotation (Line(points={{41,10},{48,10},{48,-22},{58,-22}},
      color={0,0,127}));
  connect(zerOutAir.y, swi3.u1)
    annotation (Line(points={{-19,2},{-19,2},{0,2},{0,-38},{58,-38}},
      color={0,0,127}));
  connect(swi3.y, priOutAirFra.u1)
    annotation (Line(points={{81,-30},{90,-30},{90,-56},{-8,-56},{-8,-168},{38,-168}},
                  color={0,0,127}));
  connect(swi3.y,sysUncOutAir.u)
    annotation (Line(points={{81,-30},{81,-30},{98,-30}},color={0,0,127}));
  connect(breZonAre.y, desBreZon.u2)
    annotation (Line(points={{-149,120},{-140,120},{-140,120},{-140,120},
      {-140,144},{-122,144}},   color={0,0,127}));
  connect(desBreZonPer.y, desBreZon.u1)
    annotation (Line(points={{-147,190},{-140,190},{-140,156},{-122,156}},
      color={0,0,127}));
  connect(desDisEff.y, desZonOutAirRate.u2)
    annotation (Line(points={{-99,190},{-88,190},{-88,164},{-62,164}},
      color={0,0,127}));
  connect(desBreZon.y, desZonOutAirRate.u1)
    annotation (Line(points={{-99,150},{-80,150},{-80,176},{-62,176}},
      color={0,0,127}));
  connect(desZonOutAirRate.y, desZonPriOutAirRate.u1)
    annotation (Line(points={{-39,170},{-30,170},{-30,176},{-22,176}},
      color={0,0,127}));
  connect(minZonFlo.y, desZonPriOutAirRate.u2)
    annotation (Line(points={{-39,130}, {-30,130},{-30,164},{-22,164}},
      color={0,0,127}));
  connect(desZonPopulation.y, sumDesZonPop.u)
    annotation (Line(points={{-147,230},{-142,230}},
      color={0,0,127}));
  connect(desBreZonPer.y, sumDesBreZonPop.u)
    annotation (Line(points={{-147,190},{-140,190},{-140,210},{-62,210}},
      color={0,0,127}));
  connect(breZonAre.y, sumDesBreZonAre.u)
    annotation (Line(points={{-149,120},{-140,120},{-140,110},{-22,110}},
      color={0,0,127}));
  connect(desZonPriOutAirRate.y, zonVenEff.u2)
    annotation (Line(points={{1,170}, {60,170},{60,144},{98,144}},
      color={0,0,127}));
  connect(swi.u2, occSen.y)
    annotation (Line(points={{-122,40},{-134,40},{-134,50},{-139,50}},
      color={255,0,255}));
  connect(TDis, add2.u2)
    annotation (Line(points={{-200,-60},{-172,-60},{-172,-46},{-162,-46}},
      color={0,0,127}));
  connect(TZon, add2.u1)
    annotation (Line(points={{-200,-20},{-180,-20},{-180,-20},{-172,-20},
      {-172,-34},{-162,-34}},    color={0,0,127}));
  connect(add2.y, hys.u)
    annotation (Line(points={{-139,-40},{-130.5,-40},{-122,-40}},
      color={0,0,127}));
  connect(hys.y, swi1.u2)
    annotation (Line(points={{-99,-40},{-90,-40},{-82,-40}},
      color={255,0,255}));
  connect(max.y, priOutAirFra.u2) annotation (Line(points={{-19,-180},{38,-180}},
                                 color={0,0,127}));
  connect(max.y, sysPriAirRate.u) annotation (Line(points={{-19,-180},{-12,-180},
          {-12,-90},{-2,-90}}, color={0,0,127}));
  connect(priOutAirFra.y, maxPriOutAirFra.u)
    annotation (Line(points={{61,-174},{78,-174}},           color={0,0,127}));
  connect(sysPriAirRate.y, outAirFra.u2)
    annotation (Line(points={{21.7,-90},{30,-90},{30,-96},{38,-96}},
      color={0,0,127}));
  connect(outAirFra.y, addPar.u)
    annotation (Line(points={{61,-90},{61,-90},{78,-90}},
      color={0,0,127}));
  connect(addPar.y, sysVenEff.u1)
    annotation (Line(points={{101,-90},{101,-90},{100,-90},{102,-90},{110,-90},
      {110,-84},{118,-84}}, color={0,0,127}));
  connect(maxPriOutAirFra.yMax, sysVenEff.u2)
    annotation (Line(points={{101,-174},{110,-174},{110,-96},{118,-96}},
      color={0,0,127}));
  connect(sysVenEff.y, effMinOutAirInt.u2)
    annotation (Line(points={{141,-90},{148,-90},{148,-96},{152,-96}},
                  color={0,0,127}));
  connect(sumDesZonPop.y, occDivFra.u2)
    annotation (Line(points={{-118.3,230},{-112,230},{-112,248},{-106,248},
      {-106,248},{-100,248},{-100,248}}, color={0,0,127}));
  connect(peaSysPopulation.y, occDivFra.u1)
    annotation (Line(points={{-147,260},{-100,260}},
      color={0,0,127}));
  connect(sumDesBreZonPop.y, pro.u2)
    annotation (Line(points={{-38.3,210},{-30,210},{-30,244},{-22,244}},
      color={0,0,127}));
  connect(pro.y, unCorOutAirInk.u1)
    annotation (Line(points={{1,250},{10,250},{10,226.2},{18,226.2}},
      color={0,0,127}));
  connect(sumDesBreZonAre.y, unCorOutAirInk.u2)
    annotation (Line(points={{1.7,110},{10,110},{10,214.8},{18,214.8}},
      color={0,0,127}));
  connect(unCorOutAirInk.y, aveOutAirFra.u1)
    annotation (Line(points={{41,220.5},{50,220.5},{50,196},{58,196}},
      color={0,0,127}));
  connect(maxSysPriFlow.y, aveOutAirFra.u2)
    annotation (Line(points={{41,150},{50,150},{50,184},{58,184}},
      color={0,0,127}));
  connect(aveOutAirFra.y, addPar1.u)
    annotation (Line(points={{81,190},{88,190},{98,190}},  color={0,0,127}));
  connect(zonVenEff.y, desSysVenEff.u)
    annotation (Line(points={{121,150},{138,150}},color={0,0,127}));
  connect(unCorOutAirInk.y, desOutAirInt.u1)
    annotation (Line(points={{41,220.5},{180,220.5},{180,128},{120,128},
      {120,116},{138,116}},color={0,0,127}));
  connect(desSysVenEff.yMin, desOutAirInt.u2)
    annotation (Line(points={{161,150},{168,150},{168,134},{114,134},{114,104},
      {138,104}}, color={0,0,127}));
  connect(min1.y, effMinOutAirInt.u1)
    annotation (Line(points={{161,-30},{174,-30},{174,-60},{146,-60},{146,-84},{
          152,-84}},
                  color={0,0,127}));
  connect(sysUncOutAir.y, min1.u2)
    annotation (Line(points={{121.7,-30},{121.7,-30},{128,-30},{128,-36},{138,-36}},
      color={0,0,127}));
  connect(min1.y, outAirFra.u1)
    annotation (Line(points={{161,-30},{174,-30},{174,-60},{174,-60},{26,-60},{26,
          -84},{38,-84}}, color={0,0,127}));
  connect(unCorOutAirInk.y, min1.u1)
    annotation (Line(points={{41,220.5},{180,220.5},{180,80},{128,80},{128,-24},
      {138,-24}}, color={0,0,127}));
  connect(effMinOutAirInt.y, min.u2)
    annotation (Line(points={{175,-90},{188,-90},{188,-96},{198,-96}},
      color={0,0,127}));
  connect(desOutAirInt.y, min.u1)
    annotation (Line(points={{161,110},{188,110},{188,76},{188,-84},{198,-84}},
      color={0,0,127}));
  connect(unCorOutAirInk.y, VDesUncOutMin_flow_nominal)
    annotation (Line(points={{41,220.5},{104,220.5},{104,220},{180,220},
      {180,180},{260,180}},  color={0,0,127}));
  connect(min.y, VOutMinSet_flow)
    annotation (Line(points={{221,-90},{221,-90},{232,-90},{232,-50},{260,-50}},
      color={0,0,127}));
  connect(desOutAirInt.y, VDesOutMin_flow_nominal)
    annotation (Line(points={{161,110},{161,110},{188,110},{260,110}},
      color={0,0,127}));
  connect(occDivFra.y, pro.u1)
    annotation (Line(points={{-77,254},{-52,254},{-52,256},{-22,256}},
      color={0,0,127}));
  connect(not1.y, booRep.u)
    annotation (Line(points={{-99,-130},{-82,-130}},
      color={255,0,255}));
  connect(booRep.y, swi3.u2)
    annotation (Line(points={{-59,-130},{-40,-130},{-40,-130},{-40,-30},{58,-30}},
      color={255,0,255}));
  connect(addPar1.y, reaRep.u)
    annotation (Line(points={{121,190},{130,190},{138,190}},
      color={0,0,127}));
  connect(reaRep.y, zonVenEff.u1)
    annotation (Line(points={{161,190},{170,190},{170,170},{80,170},{80,156},{98,156}},
      color={0,0,127}));
  connect(uOpeMod, intEqu1.u1)
    annotation (Line(points={{-200,-160},{-132,-160}}, color={255,127,0}));
  connect(occMod.y, intEqu1.u2)
    annotation (Line(points={{-149,-180},{-140,-180},{-140,-168},{-132,-168}}, color={255,127,0}));
  connect(not1.u, and1.y)
    annotation (Line(points={{-122,-130},{-130,-130},{-139,-130}}, color={255,0,255}));
  connect(uSupFan, and1.u1)
    annotation (Line(points={{-200,-130},{-181,-130},{-162,-130}}, color={255,0,255}));
  connect(intEqu1.y, and1.u2)
    annotation (Line(points={{-109,-160},{-100,-160},{-100,-144},{-170,-144},{-170,-138},
    {-162,-138}}, color={255,0,255}));
  connect(max.u2, VBox_flow) annotation (Line(points={{-42,-174},{-130,-174},{-130,
          -200},{-200,-200}}, color={0,0,127}));
  connect(reaRepDivZer.y, max.u1) annotation (Line(points={{-59,-210},{-50,-210},
          {-50,-186},{-42,-186}}, color={0,0,127}));
  connect(gaiDivZer.y, reaRepDivZer.u)
    annotation (Line(points={{-99,-210},{-82,-210}}, color={0,0,127}));
  connect(gaiDivZer.u, unCorOutAirInk.y) annotation (Line(points={{-122,-210},{-140,
          -210},{-140,-228},{180,-228},{180,222},{110,222},{110,220.5},{41,220.5}},
        color={0,0,127}));
annotation (
defaultComponentName="outAirSetPoi",
Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid), Text(
          extent={{-92,82},{84,-68}},
          lineColor={0,0,0},
          textString="minOAsp"),
        Text(
          extent={{-100,140},{100,100}},
          lineColor={0,0,255},
          textString="%name")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-180,-240},{240,280}}), graphics={Rectangle(
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
The calculation is done using the steps below.
</p>

<h4>Step 1: Minimum breathing zone outdoor airflow required <code>breZon</code></h4>
<ul>
<li>The area component of the breathing zone outdoor airflow:
<code>breZonAre = zonAre*outAirPerAre</code>.
</li>
<li>The population component of the breathing zone outdoor airflow:
<code>breZonPop = occCou*outAirPerPer</code>.
</li>
</ul>
<p>
The number of occupant <code>occCou</code> in each zone can be retrieved
directly from occupancy sensor <code>nOcc</code> if the sensor exists
(<code>occSen=true</code>), or using the default occupant density
<code>occDen</code> to find it <code>zonAre*occDen</code>. The occupant
density can be found from Table 6.2.2.1 in ASHRAE Standard 62.1-2013.
For design purpose, use design zone population <code>desZonPop</code> to find
out the minimum requirement at the ventilation-design condition.
</p>

<h4>Step 2: Zone air-distribution effectiveness <code>zonDisEff</code></h4>
<p>
Table 6.2.2.2 in ASHRAE 62.1-2013 lists some typical values for setting the
effectiveness. Depending on difference between zone space temperature
<code>TZon</code> and discharge air temperature (after the reheat coil) <code>TDis</code>, Warm-air
effectiveness <code>zonDisEffHea</code> or Cool-air effectiveness
<code>zonDisEffCoo</code> should be applied.
</p>

<h4>Step 3: Minimum required zone outdoor airflow <code>zonOutAirRate</code></h4>
<p>For each zone in any mode other than occupied mode and for zones that have
window switches and the window is open, <code>zonOutAirRate</code> shall be
zero.
Otherwise, the required zone outdoor airflow <code>zonOutAirRate</code>
shall be calculated as follows:
</p>
<i>If the zone is populated, or if there is no occupancy sensor:</i>
<ul>
<li>
If discharge air temperature at the terminal unit is less than or equal to
zone space temperature: <code>zonOutAirRate = (breZonAre+breZonPop)/disEffCoo</code>.
</li>
<li>
If discharge air temperature at the terminal unit is greater than zone space
temperature: <code>zonOutAirRate = (breZonAre+breZonPop)/disEffHea</code>
</li>
</ul>
<i>If the zone has an occupancy sensor and is unpopulated:</i>
<ul>
<li>
If discharge air temperature at the terminal unit is less than or equal to
zone space temperature: <code>zonOutAirRate = breZonAre/disEffCoo</code>
</li>
<li>
If discharge air temperature at the terminal unit is greater than zone
space temperature: <code>zonOutAirRate = breZonAre/disEffHea</code>
</li>
</ul>

<h4>Step 4: Outdoor air fraction for each zone <code>priOutAirFra</code> </h4>
The zone outdoor air fraction:
<pre>
    priOutAirFra = zonOutAirRate/VBox_flow
</pre>
where, <code>VBox_flow</code> is measured from zone VAV box.
For design purpose, the design zone outdoor air fraction <code>desZonPriOutAirRate</code>
is found by
<pre>
    desZonPriOutAirRate = desZonOutAirRate/minZonFlo
</pre>
where <code>minZonFlo</code> is the minimum expected zone primary flow rate and
<code>desZonOutAirRate</code> is required design zone outdoor airflow rate.

<h4>Step 5: Occupancy diversity fraction<code>occDivFra</code></h4>
For actual system operation, the system population equals the sum of zone population,
so <code>occDivFra=1</code>. It has no impact on the calculation of uncorrected
outdoor airflow <code>sysUncOutAir</code>.
For design purpose, find <code>occDivFra</code> based on the peak system population
<code>peaSysPopulation</code> and the sum of design population <code>desZonPopulation</code>
for all zones:
<pre>
    occDivFra = peaSysPopulation/sum(desZonPopulation)
</pre>

<h4>Step 6: Uncorrected outdoor airflow <code>unCorOutAirInk</code>,
<code>sysUncOutAir</code></h4>
<pre>
    unCorOutAirInk = occDivFra*sum(breZonPop)+sum(breZonAre)
</pre>

<h4>Step 7: System primary airflow <code>sysPriAirRate</code></h4>
The system primary airflow equals to the sum of discharge airflow rate measured
from each VAV box <code>VBox_flow</code>.
For design purpose, a highest expected system primary airflow <code>maxSysPriFlow</code>
should be applied. It usually is usually estimated with load-diversity factor,
e.g. 0.7. (Stanke, 2010)

<h4>Step 8: Outdoor air fraction</h4>
The average outdoor air fraction should be found as following:
<pre>
    outAirFra = sysUncOutAir/sysPriAirRate
</pre>
For design purpose, it should be found as:
<pre>
    aveOutAirFra = unCorOutAirInk/maxSysPriFlow
</pre>

<h4>Step 9: Zone ventilation efficiency <code>zonVenEff</code> (for design purpose)</h4>
<pre>
    zonVenEff[i] = 1 + aveOutAirFra + desZonPriOutAirRate[i]
</pre>
where the <code>desZonPriOutAirRate</code> is design zone outdoor airflow fraction.

<h4>Step 10: System ventilation efficiency</h4>
In actual system operation, the system ventilation efficiency <code>sysVenEff</code>:
<pre>
    sysVenEff = 1 + outAirFra + MAX(priOutAirFra[i])
</pre>
Design system ventilation efficiency <code>desSysVenEff</code>:
<pre>
    desSysVenEff = MIN(zonVenEff[i])
</pre>

<h4>Step 11: Minimum required system outdoor air intake flow </h4>
The minimum required system outdoor air intake flow should be the uncorrected
outdoor air intake <code>sysUncOutAir</code> divided by the system ventilation
efficiency <code>sysVenEff</code>, but should not be larger than the design
outdoor air rate <code>desOutAirInt</code>.
<pre>
    effMinOutAirInt = MIN(sysUncOutAir/sysVenEff, desOutAirInt)
</pre>
where the design outdoor air rate <code>desOutAirInt</code> should be:
<pre>
    desOutAirInt = unCorOutAirInk/desSysVenEff
</pre>

<h4>References</h4>
<p>
ANSI/ASHRAE Standard 62.1-2013,
<i>Ventilation for Acceptable Indoor Air Quality.</i>
</p>
<p>
Stanke, D., 2010. <i>Dynamic Reset for Multiple-Zone Systems.</i> ASHRAE Journal, March
2010.
</p>

</html>", revisions="<html>
<ul>
<li>
September 27, 2017, by Michael Wetter:<br/>
Changed handling of guard against zero division, as the flow rate
can be zero at the instant when the fan switches on.
</li>
<li>
July 6, 2017, by Jianjun Hu:<br/>
Replaced <code>cooCtrlSig</code> input with <code>TZon</code> and <code>TDis</code>
inputs to check if cool or warm air distribution effectiveness should be applied.
Applied hysteresis to avoid rapid change.
</li>
<li>
July 5, 2017, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutsideAirFlow;
