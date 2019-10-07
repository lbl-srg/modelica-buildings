within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.VAV.SetPoints;
block OutsideAirFlow
  "Output the minimum outdoor airflow rate setpoint for systems with multiple zones"

  parameter Integer numZon(min=2)
    "Total number of zones that the system serves";

  parameter Real VOutPerAre_flow[numZon](
    final unit = fill("m3/(s.m2)", numZon))=fill(3e-4, numZon)
    "Outdoor air rate per unit area"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.VolumeFlowRate VOutPerPer_flow[numZon]=
    fill(2.5e-3, numZon)
    "Outdoor air rate per person"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.Area AFlo[numZon]
    "Floor area of each zone"
    annotation(Dialog(group="Nominal condition"));

  parameter Boolean have_occSen=true
    "Set to true if zones have occupancy sensor";

  parameter Boolean have_winSen=true
    "Set to true if zones have window status sensor";

  parameter Real occDen[numZon](
    final unit=fill("1/m2", numZon)) = fill(0.05, numZon)
    "Default number of person in unit area";

  parameter Real zonDisEffHea[numZon](
    final unit=fill("1", numZon)) = fill(0.8, numZon)
    "Zone air distribution effectiveness during heating";

  parameter Real zonDisEffCoo[numZon](
    final unit=fill("1", numZon)) = fill(1.0, numZon)
    "Zone air distribution effectiveness during cooling";

  parameter Real desZonDisEff[numZon](
    final unit=fill("1", numZon)) = fill(1.0, numZon)
    "Design zone air distribution effectiveness"
    annotation(Dialog(group="Nominal condition"));

  parameter Real desZonPop[numZon](
    final min={occDen[i]*AFlo[i] for i in 1:numZon},
    final unit=fill("1",numZon)) = {occDen[i]*AFlo[i] for i in 1:numZon}
    "Design zone population during peak occupancy"
    annotation(Dialog(group="Nominal condition"));

  parameter Real uLow(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = -0.5
    "If zone space temperature minus supply air temperature is less than uLow,
     then it should use heating supply air distribution effectiveness"
    annotation (Dialog(tab="Advanced"));

  parameter Real uHig(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 0.5
    "If zone space temperature minus supply air temperature is more than uHig,
     then it should use cooling supply air distribution effectiveness"
    annotation (Dialog(tab="Advanced"));

  parameter Modelica.SIunits.VolumeFlowRate VPriSysMax_flow
    "Maximum expected system primary airflow at design stage"
    annotation(Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.VolumeFlowRate minZonPriFlo[numZon]
    "Minimum expected zone primary flow rate"
    annotation(Dialog(group="Nominal condition"));

  parameter Real peaSysPop(
    final unit="1") = 1.2*sum({occDen[iZon] * AFlo[iZon] for iZon in 1:numZon})
    "Peak system population"
    annotation(Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nOcc[numZon] if have_occSen
    "Number of occupants"
    annotation (Placement(transformation(extent={{-260,60},{-220,100}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow[numZon](
    final min=fill(0,numZon),
    final unit=fill("m3/s",numZon),
    final quantity=fill("VolumeFlowRate",numZon))
    "Primary airflow rate to the ventilation zone from the air handler, including outdoor air and recirculated air"
    annotation (Placement(transformation(extent={{-260,-272},{-220,-232}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon[numZon](
    each final unit="K",
    each displayUnit="degC",
    each quantity="ThermodynamicTemperature") "Measured zone air temperature"
    annotation (Placement(transformation(extent={{-260,-110},{-220,-70}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TDis[numZon](
    each final unit="K",
    each displayUnit="degC",
    each quantity="ThermodynamicTemperature") "Measured discharge air temperature"
    annotation (Placement(transformation(extent={{-260,-150},{-220,-110}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
    "AHU operation mode status signal"
    annotation (Placement(transformation(extent={{-260,-230},{-220,-190}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSupFan
    "Supply fan status, true if on, false if off"
    annotation (Placement(transformation(extent={{-260,-200},{-220,-160}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWin[numZon] if
       have_winSen
    "Window status, true if open, false if closed"
    annotation (Placement(transformation(extent={{-260,-40},{-220,0}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDesOutMin_flow_nominal(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Design minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{240,90},{280,130}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VDesUncOutMin_flow_nominal(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Design uncorrected minimum outdoor airflow rate"
    annotation (Placement(transformation(extent={{240,160},{280,200}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOutMinSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Effective minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{240,-120},{280,-80}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VOutMinSet_flow_normalized(
    final unit="1")
    "Effective minimum outdoor airflow setpoint, normalized by VDesOutMin_flow_nominal"
    annotation (Placement(transformation(extent={{240,-210},{280,-170}}),
      iconTransformation(extent={{100,-100},{140,-60}})));

protected
  Buildings.Controls.OBC.CDL.Conversions.IntegerToReal intToRea[numZon] if have_occSen
    "Type converter"
    annotation (Placement(transformation(extent={{-200,70},{-180,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Add breZon[numZon] "Breathing zone airflow"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain gai[numZon](
    final k = VOutPerPer_flow) if have_occSen
    "Outdoor air per person"
    annotation (Placement(transformation(extent={{-160,70},{-140,90}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi[numZon]
    "If there is occupancy sensor, then using the real time occupancy; otherwise, using the default occupancy"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi1[numZon]
    "Switch between cooling or heating distribution effectiveness"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Division zonOutAirRate[numZon]
    "Required zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-120,-180},{-100,-160}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi2[numZon]
    "If window is open or it is not in occupied mode, the required outdoor airflow rate should be zero"
    annotation (Placement(transformation(extent={{20,-10},{40,-30}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi3[numZon]
    "If supply fan is off, then outdoor airflow rate should be zero"
    annotation (Placement(transformation(extent={{60,-70},{80,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Max max [numZon]
    "If supply fan is off, giving a small primary airflow rate to avoid division by zero"
    annotation (Placement(transformation(extent={{-40,-220},{-20,-240}})));

  Buildings.Controls.OBC.CDL.Continuous.Division priOutAirFra[numZon]
    "Primary outdoor air fraction"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sysUncOutAir(
    final nin=numZon)
    "Uncorrected outdoor airflow"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum sysPriAirRate(
    final nin=numZon)
    "System primary airflow rate"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Division outAirFra "System outdoor air fraction"
    annotation (Placement(transformation(extent={{40,-150},{60,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=1,
    final k=1)
    "System outdoor air flow fraction plus 1"
    annotation (Placement(transformation(extent={{20,-190},{40,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Add sysVenEff(
    final k2=-1)
    "Current system ventilation efficiency"
    annotation (Placement(transformation(extent={{80,-190},{100,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Division effMinOutAirInt
    "Effective minimum outdoor air setpoint"
    annotation (Placement(transformation(extent={{140,-150},{160,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Add desBreZon[numZon] "Breathing zone design airflow"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Division desZonOutAirRate[numZon]
    "Required design zone outdoor airflow rate"
    annotation (Placement(transformation(extent={{-60,160},{-40,180}})));

  Buildings.Controls.OBC.CDL.Continuous.Division desZonPriOutAirRate[numZon]
    "Design zone primary outdoor air fraction"
    annotation (Placement(transformation(extent={{-20,160},{0,180}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumDesZonPop(
    final nin=numZon)
    "Sum of the design zone population for all zones"
    annotation (Placement(transformation(extent={{-140,220},{-120,240}})));

  Buildings.Controls.OBC.CDL.Continuous.Division occDivFra "Occupant diversity fraction"
    annotation (Placement(transformation(extent={{-98,244},{-78,264}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumDesBreZonPop(
    final nin=numZon)
    "Sum of the design breathing zone flow rate for population component"
    annotation (Placement(transformation(extent={{-60,200},{-40,220}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum sumDesBreZonAre(
    final nin=numZon)
    "Sum of the design breathing zone flow rate for area component"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Add unCorOutAirInk "Uncorrected outdoor air intake"
    annotation (Placement(transformation(extent={{20,211},{40,230}})));

  Buildings.Controls.OBC.CDL.Continuous.Product pro "Product of inputs"
    annotation (Placement(transformation(extent={{-20,240},{0,260}})));

  Buildings.Controls.OBC.CDL.Continuous.Division aveOutAirFra "Average outdoor air fraction"
    annotation (Placement(transformation(extent={{60,180},{80,200}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=1,
    final k=1)
    "Average outdoor air flow fraction plus 1"
    annotation (Placement(transformation(extent={{100,180},{120,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Add zonVenEff[numZon](
    final k2=fill(-1,numZon))
    "Zone ventilation efficiency"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2[numZon](
    final k1=fill(+1, numZon),
    final k2=fill(-1, numZon))
    "Zone space temperature minus supply air temperature"
    annotation (Placement(transformation(extent={{-160,-120},{-140,-100}})));

  Buildings.Controls.OBC.CDL.Continuous.Division desOutAirInt
    "Design system outdoor air intake"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMin desSysVenEff(
    final nin=numZon)
    "Design system ventilation efficiency"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiMax maxPriOutAirFra(
    final nin=numZon)
    "Maximum zone outdoor air fraction"
    annotation (Placement(transformation(extent={{40,-230},{60,-210}})));

  Buildings.Controls.OBC.CDL.Continuous.Min min
    "Minimum outdoor airflow rate should not be more than designed outdoor airflow rate"
    annotation (Placement(transformation(extent={{200,-110},{220,-90}})));

  Buildings.Controls.OBC.CDL.Continuous.Min min1
    "Uncorrected outdoor air rate should not be higher than its design value"
    annotation (Placement(transformation(extent={{140,-90},{160,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys[numZon](
    final uLow=fill(uLow,numZon),
    final uHigh=fill(uHig,numZon),
    final pre_y_start=fill(true,numZon))
    "Check if cooling or heating air distribution effectiveness should be applied, with 1 degC deadband"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSen[numZon](
    final k=fill(have_occSen, numZon))
    "Boolean constant to indicate if there is occupancy sensor"
    annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant occMod(
    final k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-180,-240},{-160,-220}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desDisEff[numZon](
    final k = desZonDisEff)
    "Design zone air distribution effectiveness"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minZonFlo[numZon](
    final k = minZonPriFlo)
    "Minimum expected zone primary flow rate"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant breZonAre[numZon](
    final k={VOutPerAre_flow[i]*AFlo[i] for i in 1:numZon})
    "Area component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-170,110},{-150,130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant breZonPop[numZon](
    final k={VOutPerPer_flow[i]*AFlo[i]*occDen[i] for i in 1:numZon})
    "Population component of the breathing zone outdoor airflow"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant disEffHea[numZon](
    final k = zonDisEffHea)
    "Zone distribution effectiveness for heating"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant disEffCoo[numZon](
    final k = zonDisEffCoo)
    "Zone distribution effectiveness fo cooling"
    annotation (Placement(transformation(extent={{-120,-82},{-100,-62}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desZonPopulation[numZon](
    final k=desZonPop)
    "Design zone population"
    annotation (Placement(transformation(extent={{-168,220},{-148,240}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerOutAir[numZon](
    final k=fill(0,numZon))
    "Zero required outdoor airflow rate when window is open or when zone is not in occupied mode"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desBreZonPer[numZon](
    final k={VOutPerPer_flow[i]*desZonPop[i] for i in 1:numZon})
    "Population component of the breathing zone design outdoor airflow"
    annotation (Placement(transformation(extent={{-168,180},{-148,200}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant peaSysPopulation(
    final k=peaSysPop)
    "Peak system population"
    annotation (Placement(transformation(extent={{-168,250},{-148,270}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant VPriSysMax_floww(
    final k=VPriSysMax_flow)
    "Highest expected system primary airflow"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(
    final nout=numZon)
    "Replicate Boolean input"
    annotation (Placement(transformation(extent={{-80,-180},{-60,-160}})));

  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=numZon)
    "Replicate Real input signal"
    annotation (Placement(transformation(extent={{140,180},{160,200}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if operation mode is occupied"
    annotation (Placement(transformation(extent={{-120,-220},{-100,-200}})));

  Buildings.Controls.OBC.CDL.Logical.And and1 "Logical and"
    annotation (Placement(transformation(extent={{-160,-180},{-140,-160}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain gaiDivZer(
    final k=1E-3)
    "Gain, used to avoid division by zero if the flow rate is smaller than 0.1%"
    annotation (Placement(transformation(extent={{-120,-270},{-100,-250}})));

  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRepDivZer(
    final nout=numZon)
    "Signal replicator to avoid division by zero"
    annotation (Placement(transformation(extent={{-80,-270},{-60,-250}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi4 "Ensuring the system efficiency will not be negative"
    annotation (Placement(transformation(extent={{140,-190},{160,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOne(
    final k=1)
    "Set system ventilation efficiency to 1"
    annotation (Placement(transformation(extent={{100,-230},{120,-210}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=1E-4)
    "Check if system ventilation efficiency is greater than 0 (using 1E-4 tolerance)"
    annotation (Placement(transformation(extent={{100,-150},{120,-130}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerOcc[numZon](
    k=fill(0, numZon)) if not have_occSen
    "Zero occupant when there is no occupancy sensor"
    annotation (Placement(transformation(extent={{-160,30},{-140,50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cloWin[numZon](
    final k=fill(false, numZon)) if not have_winSen
    "Closed window status when there is no window sensor"
    annotation (Placement(transformation(extent={{-160,-50},{-140,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Division norVOutMin
    "Normalization for minimum outdoor air flow rate"
    annotation (Placement(transformation(extent={{200,-200},{220,-180}})));

equation
  connect(breZonAre.y, breZon.u1)
    annotation (Line(points={{-148,120},{-140,120},{-140,110},{-60,110},
      {-60,66},{-42,66}},  color={0,0,127}));
  connect(gai.y, swi.u1)
    annotation (Line(points={{-138,80},{-128,80},{-128,68},{-102,68}},
      color={0,0,127}));
  connect(breZonPop.y, swi.u3)
    annotation (Line(points={{-78,0},{-60,0},{-60,20},{-110,20},{-110,52},
      {-102,52}}, color={0,0,127}));
 connect(swi.y, breZon.u2)
    annotation (Line(points={{-78,60},{-60,60},{-60,54},{-42,54}},
      color={0,0,127}));
  connect(disEffCoo.y, swi1.u1)
    annotation (Line(points={{-98,-72},{-92,-72},{-92,-102},{-82,-102}},
      color={0,0,127}));
  connect(disEffHea.y, swi1.u3)
    annotation (Line(points={{-98,-140},{-92,-140},{-92,-118},{-82,-118}},
      color={0,0,127}));
  connect(breZon.y, zonOutAirRate.u1)
    annotation (Line(points={{-18,60},{0,60},{0,56},{18,56}},
      color={0,0,127}));
  connect(swi1.y, zonOutAirRate.u2)
    annotation (Line(points={{-58,-110},{-50,-110},{-50,44},{18,44}},
      color={0,0,127}));
  connect(uWin, swi2.u2)
    annotation (Line(points={{-240,-20},{18,-20}},
      color={255,0,255}));
  connect(zerOutAir.y, swi2.u1)
    annotation (Line(points={{-18,-40},{0,-40},{0,-28},{18,-28}},
      color={0,0,127}));
  connect(zonOutAirRate.y, swi2.u3)
    annotation (Line(points={{42,50},{60,50},{60,0},{0,0},{0,-12},{18,-12}},
      color={0,0,127}));
  connect(swi2.y, swi3.u3)
    annotation (Line(points={{42,-20},{48,-20},{48,-72},{58,-72}},
      color={0,0,127}));
  connect(zerOutAir.y, swi3.u1)
    annotation (Line(points={{-18,-40},{0,-40},{0,-88},{58,-88}},
      color={0,0,127}));
  connect(swi3.y, priOutAirFra.u1)
    annotation (Line(points={{82,-80},{90,-80},{90,-108},{-8,-108},{-8,-214},
      {-2,-214}}, color={0,0,127}));
  connect(swi3.y,sysUncOutAir.u)
    annotation (Line(points={{82,-80},{98,-80}}, color={0,0,127}));
  connect(breZonAre.y, desBreZon.u2)
    annotation (Line(points={{-148,120},{-140,120},{-140,120},{-140,120},
      {-140,144},{-122,144}},  color={0,0,127}));
  connect(desBreZonPer.y, desBreZon.u1)
    annotation (Line(points={{-146,190},{-140,190},{-140,156},{-122,156}},
      color={0,0,127}));
  connect(desDisEff.y, desZonOutAirRate.u2)
    annotation (Line(points={{-98,190},{-88,190},{-88,164},{-62,164}},
      color={0,0,127}));
  connect(desBreZon.y, desZonOutAirRate.u1)
    annotation (Line(points={{-98,150},{-80,150},{-80,176},{-62,176}},
      color={0,0,127}));
  connect(desZonOutAirRate.y, desZonPriOutAirRate.u1)
    annotation (Line(points={{-38,170},{-30,170},{-30,176},{-22,176}},
      color={0,0,127}));
  connect(minZonFlo.y, desZonPriOutAirRate.u2)
    annotation (Line(points={{-38,130},{-30,130},{-30,164},{-22,164}},
      color={0,0,127}));
  connect(desZonPopulation.y, sumDesZonPop.u)
    annotation (Line(points={{-146,230},{-142,230}},
      color={0,0,127}));
  connect(desBreZonPer.y, sumDesBreZonPop.u)
    annotation (Line(points={{-146,190},{-140,190},{-140,210},{-62,210}},
      color={0,0,127}));
  connect(breZonAre.y, sumDesBreZonAre.u)
    annotation (Line(points={{-148,120},{-140,120},{-140,110},{-22,110}},
      color={0,0,127}));
  connect(desZonPriOutAirRate.y, zonVenEff.u2)
    annotation (Line(points={{2,170},{60,170},{60,144},{98,144}},
      color={0,0,127}));
  connect(swi.u2, occSen.y)
    annotation (Line(points={{-102,60},{-120,60},{-120,0},{-138,0}},
      color={255,0,255}));
  connect(TDis, add2.u2)
    annotation (Line(points={{-240,-130},{-180,-130},{-180,-116},{-162,-116}},
      color={0,0,127}));
  connect(TZon, add2.u1)
    annotation (Line(points={{-240,-90},{-180,-90},{-180,-104},{-162,-104}},
      color={0,0,127}));
  connect(add2.y, hys.u)
    annotation (Line(points={{-138,-110},{-122,-110}},
      color={0,0,127}));
  connect(hys.y, swi1.u2)
    annotation (Line(points={{-98,-110},{-82,-110}}, color={255,0,255}));
  connect(max.y, priOutAirFra.u2)
    annotation (Line(points={{-18,-230},{-12,-230},{-12,-226},{-2,-226}},
      color={0,0,127}));
  connect(max.y, sysPriAirRate.u)
    annotation (Line(points={{-18,-230},{-12,-230},{-12,-140},{-2,-140}},
      color={0,0,127}));
  connect(priOutAirFra.y, maxPriOutAirFra.u)
    annotation (Line(points={{22,-220},{38,-220}}, color={0,0,127}));
  connect(sysPriAirRate.y, outAirFra.u2)
    annotation (Line(points={{22,-140},{30,-140},{30,-146},{38,-146}},
      color={0,0,127}));
  connect(maxPriOutAirFra.y, sysVenEff.u2)
    annotation (Line(points={{62,-220},{80,-220},{80,-202},{60,-202},{60,-186},
      {78,-186}}, color={0,0,127}));
  connect(sumDesZonPop.y, occDivFra.u2)
    annotation (Line(points={{-118,230},{-112,230},{-112,248},{-100,248}},
      color={0,0,127}));
  connect(peaSysPopulation.y, occDivFra.u1)
    annotation (Line(points={{-146,260},{-100,260}},
      color={0,0,127}));
  connect(sumDesBreZonPop.y, pro.u2)
    annotation (Line(points={{-38,210},{-30,210},{-30,244},{-22,244}},
      color={0,0,127}));
  connect(pro.y, unCorOutAirInk.u1)
    annotation (Line(points={{2,250},{10,250},{10,226.2},{18,226.2}},
      color={0,0,127}));
  connect(sumDesBreZonAre.y, unCorOutAirInk.u2)
    annotation (Line(points={{2,110},{10,110},{10,214.8},{18,214.8}},
      color={0,0,127}));
  connect(unCorOutAirInk.y, aveOutAirFra.u1)
    annotation (Line(points={{42,220.5},{50,220.5},{50,196},{58,196}},
      color={0,0,127}));
  connect(VPriSysMax_floww.y, aveOutAirFra.u2)
    annotation (Line(points={{42,150},{50,150},{50,184},{58,184}},
      color={0,0,127}));
  connect(aveOutAirFra.y, addPar1.u)
    annotation (Line(points={{82,190},{82,190},{98,190}},  color={0,0,127}));
  connect(zonVenEff.y, desSysVenEff.u)
    annotation (Line(points={{122,150},{138,150}},color={0,0,127}));
  connect(unCorOutAirInk.y, desOutAirInt.u1)
    annotation (Line(points={{42,220.5},{180,220.5},{180,128},{120,128},
      {120,116},{138,116}}, color={0,0,127}));
  connect(desSysVenEff.y, desOutAirInt.u2)
    annotation (Line(points={{162,150},{168,150},{168,134},{114,134},{114,104},
      {138,104}}, color={0,0,127}));
  connect(min1.y, effMinOutAirInt.u1)
    annotation (Line(points={{162,-80},{168,-80},{168,-112},{132,-112},{132,-134},
      {138,-134}}, color={0,0,127}));
  connect(sysUncOutAir.y, min1.u2)
    annotation (Line(points={{122,-80},{128,-80},{128,-86},{138,-86}},
      color={0,0,127}));
  connect(min1.y, outAirFra.u1)
    annotation (Line(points={{162,-80},{168,-80},{168,-112},{26,-112},{26,-134},
      {38,-134}}, color={0,0,127}));
  connect(unCorOutAirInk.y, min1.u1)
    annotation (Line(points={{42,220.5},{180,220.5},{180,80},{128,80},{128,-74},
      {138,-74}}, color={0,0,127}));
  connect(desOutAirInt.y, min.u1)
    annotation (Line(points={{162,110},{176,110},{176,-94},{198,-94}},
      color={0,0,127}));
  connect(unCorOutAirInk.y, VDesUncOutMin_flow_nominal)
    annotation (Line(points={{42,220.5},{180,220.5},{180,180},{260,180}},
      color={0,0,127}));
  connect(desOutAirInt.y, VDesOutMin_flow_nominal)
    annotation (Line(points={{162,110},{260,110}},
      color={0,0,127}));
  connect(occDivFra.y, pro.u1)
    annotation (Line(points={{-76,254},{-52,254},{-52,256},{-22,256}},
      color={0,0,127}));
  connect(not1.y, booRep.u)
    annotation (Line(points={{-98,-170},{-82,-170}},
      color={255,0,255}));
  connect(booRep.y, swi3.u2)
    annotation (Line(points={{-58,-170},{-40,-170},{-40,-80},{58,-80}},
      color={255,0,255}));
  connect(addPar1.y, reaRep.u)
    annotation (Line(points={{122,190},{122,190},{138,190}},
      color={0,0,127}));
  connect(reaRep.y, zonVenEff.u1)
    annotation (Line(points={{162,190},{170,190},{170,170},{80,170},{80,156},
      {98,156}}, color={0,0,127}));
  connect(uOpeMod, intEqu1.u1)
    annotation (Line(points={{-240,-210},{-122,-210}}, color={255,127,0}));
  connect(occMod.y, intEqu1.u2)
    annotation (Line(points={{-158,-230},{-140,-230},{-140,-218},{-122,-218}},
      color={255,127,0}));
  connect(not1.u, and1.y)
    annotation (Line(points={{-122,-170},{-138,-170}}, color={255,0,255}));
  connect(intEqu1.y, and1.u2)
    annotation (Line(points={{-98,-210},{-80,-210},{-80,-192},{-170,-192},
      {-170,-178},{-162,-178}},   color={255,0,255}));
  connect(max.u2, VDis_flow)
    annotation (Line(points={{-42,-224},{-130,-224},{-130,-252},{-240,-252}},
      color={0,0,127}));
  connect(reaRepDivZer.y, max.u1)
    annotation (Line(points={{-58,-260},{-50,-260},{-50,-236},{-42,-236}},
      color={0,0,127}));
  connect(gaiDivZer.y, reaRepDivZer.u)
    annotation (Line(points={{-98,-260},{-82,-260}}, color={0,0,127}));
  connect(gaiDivZer.u, unCorOutAirInk.y)
    annotation (Line(points={{-122,-260},{-140,-260},{-140,-280},{180,-280},
      {180,220.5},{42,220.5}},  color={0,0,127}));
  connect(sysVenEff.y, swi4.u1)
    annotation (Line(points={{102,-180},{120,-180},{120,-172},{138,-172}},
      color={0,0,127}));
  connect(swi4.y, effMinOutAirInt.u2)
    annotation (Line(points={{162,-180},{172,-180},{172,-162},{134,-162},
      {134,-146},{138,-146}}, color={0,0,127}));
  connect(outAirFra.y, addPar.u)
    annotation (Line(points={{62,-140},{80,-140},{80,-160},{0,-160},{0,-180},
      {18,-180}}, color={0,0,127}));
  connect(addPar.y, sysVenEff.u1)
    annotation (Line(points={{42,-180},{60,-180},{60,-174},{78,-174}},
      color={0,0,127}));
  connect(greEquThr.y, swi4.u2)
    annotation (Line(points={{122,-140},{128,-140},{128,-180},{138,-180}},
      color={255,0,255}));
  connect(conOne.y, swi4.u3)
    annotation (Line(points={{122,-220},{130,-220},{130,-188},{138,-188}},
      color={0,0,127}));
  connect(sysVenEff.y, greEquThr.u)
    annotation (Line(points={{102,-180},{120,-180},{120,-160},{86,-160},{86,-140},
      {98,-140}}, color={0,0,127}));
  connect(zerOcc.y, swi.u1)
    annotation (Line(points={{-138,40},{-128,40},{-128,68},{-102,68}},
      color={0,0,127}));
  connect(cloWin.y, swi2.u2)
    annotation (Line(points={{-138,-40},{-120,-40},{-120,-20},{18,-20}},
      color={255,0,255}));
  connect(VOutMinSet_flow, min.y)
    annotation (Line(points={{260,-100},{222,-100}}, color={0,0,127}));
  connect(effMinOutAirInt.y, min.u2)
    annotation (Line(points={{162,-140},{178,-140},{178,-106},{198,-106}},
      color={0,0,127}));
  connect(norVOutMin.u1, min.y)
    annotation (Line(points={{198,-184},{188,-184},{188,-120},{230,-120},
      {230,-100},{222,-100}}, color={0,0,127}));
  connect(desOutAirInt.y, norVOutMin.u2)
    annotation (Line(points={{162,110},{176,110},{176,-178},{186,-178},
      {186,-196},{198,-196}},  color={0,0,127}));
  connect(norVOutMin.y, VOutMinSet_flow_normalized)
    annotation (Line(points={{222,-190},{260,-190}}, color={0,0,127}));
  connect(and1.y, not1.u)
    annotation (Line(points={{-138,-170},{-122,-170}}, color={255,0,255}));
  connect(uSupFan, and1.u1)
    annotation (Line(points={{-240,-180},{-180,-180},{-180,-170},{-162,-170}},
      color={255,0,255}));
  connect(intToRea.y, gai.u)
    annotation (Line(points={{-178,80},{-162,80}}, color={0,0,127}));
  connect(nOcc, intToRea.u)
    annotation (Line(points={{-240,80},{-202,80}}, color={255,127,0}));

annotation (
  defaultComponentName="outAirSetPoi",
  Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-92,82},{84,-68}},
          lineColor={0,0,0},
          textString="minOAsp"),
        Text(
          extent={{-100,158},{100,118}},
          lineColor={0,0,255},
          textString="%name")}),
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-280},{240,280}}), graphics={Rectangle(
          extent={{-218,278},{238,100}},
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
is according to ASHRAE Guidline 36 (G36), PART 5.N.3.a, PART 5.B.2.b,
PART3.1-D.2.a.
The calculation is done using the steps below.
</p>
<ol>
<li>
<p>
Compute the required breathing zone outdoor airflow <code>breZon</code>
using the following components.
</p>
<ul>
<li>The area component of the breathing zone outdoor airflow,
<code>breZonAre = AFlo*VOutPerAre_flow</code>.
</li>
<li>The population component of the breathing zone outdoor airflow,
<code>breZonPop = occCou*VOutPerPer_flow</code>.
</li>
</ul>
<p>
The number of occupant <code>occCou</code> in each zone can be retrieved
directly from occupancy sensor <code>nOcc</code> if the sensor exists
(<code>have_occSen=true</code>), or using the default occupant density
<code>occDen</code> and computing <code>AFlo*occDen</code>. The occupant
density can be found from Table 6.2.2.1 in ASHRAE Standard 62.1-2013.
For design purpose, use the design zone population <code>desZonPop</code> to determine
the minimum requirement at the ventilation-design condition.
</p>
</li>
<li>
<p>
Compute the zone air-distribution effectiveness <code>zonDisEff</code>.
Table 6.2.2.2 in ASHRAE 62.1-2013 lists some typical values for setting the
effectiveness. Depending on difference between zone space temperature
<code>TZon</code> and discharge air temperature (after the reheat coil) <code>TDis</code>, Warm-air
effectiveness <code>zonDisEffHea</code> or Cool-air effectiveness
<code>zonDisEffCoo</code> should be applied.
</p>
</li>
<li>
<p>
Compute the required zone outdoor airflow <code>zonOutAirRate</code>.
For each zone in any mode other than occupied mode and for zones that have
window switches and the window is open, set <code>zonOutAirRate = 0</code>.
Otherwise, the required zone outdoor airflow <code>zonOutAirRate</code>
shall be calculated as follows:
</p>
<ul>
<li>
If the zone is populated, or if there is no occupancy sensor:
<ul>
<li>
If the discharge air temperature at the terminal unit is less than or equal to
the zone space temperature, set <code>zonOutAirRate = (breZonAre+breZonPop)/disEffCoo</code>.
</li>
<li>
If the discharge air temperature at the terminal unit is greater than zone space
temperature, set <code>zonOutAirRate = (breZonAre+breZonPop)/disEffHea</code>.
</li>
</ul>
</li>
<li>
If the zone has an occupancy sensor and is unpopulated:
<ul>
<li>
If the discharge air temperature at the terminal unit is less than or equal to
the zone space temperature, set <code>zonOutAirRate = breZonAre/disEffCoo</code>.
</li>
<li>
If the discharge air temperature at the terminal unit is greater than zone
space temperature, set <code>zonOutAirRate = breZonAre/disEffHea</code>.
</li>
</ul>
</li>
</ul>
</li>

<li>
<p>
Compute the outdoor air fraction for each zone <code>priOutAirFra</code> as follows.
Set the zone outdoor air fraction to
</p>
<pre>
    priOutAirFra = zonOutAirRate/VDis_flow
</pre>
<p>
where, <code>VDis_flow</code> is the measured discharge air flow rate from the zone VAV box.
For design purpose, the design zone outdoor air fraction <code>desZonPriOutAirRate</code>
is
</p>
<pre>
    desZonPriOutAirRate = desZonOutAirRate/minZonFlo
</pre>
<p>
where <code>minZonFlo</code> is the minimum expected zone primary flow rate and
<code>desZonOutAirRate</code> is the required design zone outdoor airflow rate.
</p>
</li>
<li>
<p>
Compute the occupancy diversity fraction <code>occDivFra</code>.
During system operation, the system population equals the sum of the zone population,
so <code>occDivFra=1</code>. It has no impact on the calculation of the uncorrected
outdoor airflow <code>sysUncOutAir</code>.
For design purpose, compute for all zones
</p>
<pre>
    occDivFra = peaSysPopulation/sum(desZonPopulation)
</pre>
<p>
where
<code>peaSysPopulation</code> is the peak system population and
<code>desZonPopulation</code> is the sum of the design population.
</p>
</li>
<li>
<p>
Compute the uncorrected outdoor airflow rate <code>unCorOutAirInk</code>,
<code>sysUncOutAir</code> as
</p>
<pre>
    unCorOutAirInk = occDivFra*sum(breZonPop)+sum(breZonAre).
</pre>
</li>
<li>
<p>
Compute the system primary airflow <code>sysPriAirRate</code>,
which is equal to the sum of the discharge airflow rate measured
from each VAV box <code>VDis_flow</code>.
For design purpose, a highest expected system primary airflow <code>VPriSysMax_flow</code>
should be applied. It usually is estimated with a load-diversity factor of <i>0.7</i>. (Stanke, 2010)
</p>
</li>
<li>
<p>
Compute the outdoor air fraction as
</p>
<pre>
    outAirFra = sysUncOutAir/sysPriAirRate.
</pre>
<p>
For design purpose, use
</p>
<pre>
    aveOutAirFra = unCorOutAirInk/VPriSysMax_flow.
</pre>
</li>
<li>
<p>
Compute the zone ventilation efficiency <code>zonVenEff</code>, for design purpose, as
</p>
<pre>
    zonVenEff[i] = 1 + aveOutAirFra + desZonPriOutAirRate[i]
</pre>
<p>
where the <code>desZonPriOutAirRate</code> is the design zone outdoor airflow fraction.
</p>
</li>
<li>
<p>
Compute the system ventilation efficiency.
During system operation, the system ventilation efficiency <code>sysVenEff</code> is
</p>
<pre>
    sysVenEff = 1 + outAirFra + MAX(priOutAirFra[i])
</pre>
<p>
The design system ventilation efficiency <code>desSysVenEff</code> is
</p>
<pre>
    desSysVenEff = min(zonVenEff[i]).
</pre>
</li>
<li>
<p>
Compute the minimum required system outdoor air intake flow rate.
The minimum required system outdoor air intake flow should be the uncorrected
outdoor air intake <code>sysUncOutAir</code> divided by the system ventilation
efficiency <code>sysVenEff</code>, but it should not be larger than the design
outdoor air rate <code>desOutAirInt</code>. Hence,
</p>
<pre>
    effMinOutAirInt = MIN(sysUncOutAir/sysVenEff, desOutAirInt),
</pre>
<p>
where the design outdoor air rate <code>desOutAirInt</code> is
</p>
<pre>
    desOutAirInt = unCorOutAirInk/desSysVenEff.
</pre>
</li>
</ol>

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
July 23, 2019, by Michael Wetter:<br/>
Improved documentation.
</li>
<li>
January 12, 2019, by Michael Wetter:<br/>
Added missing <code>each</code>.
</li>
<li>
October 28, 2017, by Michael Wetter:<br/>
Corrected bug in guarding against division by zero.
</li>
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
