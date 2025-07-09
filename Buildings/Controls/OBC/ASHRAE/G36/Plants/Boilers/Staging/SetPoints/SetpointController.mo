within Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints;
block SetpointController
  "Calculates the boiler stage status setpoint signal"

  parameter Boolean have_priOnl
    "Is the boiler plant primary-only?
    True: The boiler plant is primary-only;
    False: The boiler plant is primary-secondary"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Boolean have_secFloSen=false
    "True: Flowrate sensors in secondary loops;
    False: Flowrate sensor in decoupler"
    annotation(Dialog(tab="Non-configurable", enable=false));

  parameter Integer nBoi
    "Number of boilers"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer boiTyp[nBoi]
    "Boiler type"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Integer staMat[:, nBoi]
    "Staging matrix with stage as row index and boiler as column index"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real boiDesCap[nBoi](
    final unit=fill("W",nBoi),
    displayUnit=fill("W",nBoi),
    final quantity=fill("Power",nBoi))
    "Design boiler capacities vector"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real boiFirMin[nBoi](
    final unit=fill("1",nBoi),
    displayUnit=fill("1",nBoi))
    "Boiler minimum firing rate before cycling"
    annotation(Dialog(tab="General", group="Boiler plant configuration parameters"));

  parameter Real boiMinPriPumSpeSta[nSta](
    final unit=fill("1",nSta),
    displayUnit=fill("1",nSta),
    final max=fill(1,nSta),
    final min=fill(0,nSta))
    "Minimum primary pump speed for the boiler plant stage"
    annotation(Evaluate=true,
      Dialog(enable=not
                       (have_priOnl),
        tab="General",
        group="Boiler plant configuration parameters"));

  parameter Real delStaCha(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Hold period for each stage change"
    annotation(Dialog(tab="Staging parameters", group="General parameters"));

  parameter Real avePer(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Time period for the capacity requirement rolling average"
    annotation(Dialog(tab="Staging parameters", group="Capacity requirement calculation parameters"));

  parameter Real fraNonConBoi(
    final unit="1",
    displayUnit="1") = 0.9
    "Fraction of current stage design capacity at which efficiency condition is 
    satisfied for non-condensing boilers"
    annotation(Dialog(tab="Staging parameters", group="Efficiency condition parameters"));

  parameter Real fraConBoi(
    final unit="1",
    displayUnit="1") = 1.5
    "Fraction of higher stage design capacity at which efficiency condition is 
    satisfied for condensing boilers"
    annotation(Dialog(tab="Staging parameters", group="Efficiency condition parameters"));

  parameter Real delEffCon(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for heating capacity requirement condition"
    annotation(Dialog(tab="Staging parameters", group="Efficiency condition parameters"));

  parameter Real TDif(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 10
    "Required temperature difference between setpoint and measured temperature"
    annotation(Dialog(tab="Staging parameters", group="Failsafe condition parameters"));

  parameter Real delFaiCon(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 900
    "Enable delay for temperature condition"
    annotation(Dialog(tab="Staging parameters", group="Failsafe condition parameters"));

  parameter Real sigDif(
    final unit="1",
    displayUnit="1") = 0.1
    "Signal hysteresis deadband"
    annotation (Dialog(tab="Advanced", group="Efficiency condition parameters"));

  parameter Real TDifHys(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 1
    "Temperature deadband for hysteresis loop"
    annotation(Dialog(tab="Advanced", group="Failsafe condition parameters"));

  parameter Real fraMinFir(
    final unit="1",
    displayUnit="1") = 1.1
    "Fraction of boiler minimum firing rate that required capacity needs to be
    to initiate stage-down process"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real delMinFir(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Delay for staging based on minimum firing rate of current stage"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real fraDesCap(
    final unit="1",
    displayUnit="1") = 0.8
    "Fraction of design capacity of next lower stage that heating capacity needs
    to be for staging down"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real delDesCapNonConBoi(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 600
    "Enable delay for capacity requirement condition for non-condensing boilers"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real delDesCapConBoi(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for capacity requirement condition for condensing boilers"
    annotation(Dialog(tab="Staging parameters", group="Staging down parameters"));

  parameter Real delBypVal(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for bypass valve condition for primary-only plants"
    annotation (
      Evaluate=true,
      Dialog(
        enable=have_priOnl,
        tab="Staging parameters",
        group="Staging down parameters"));

  parameter Real TCirDif(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 3
    "Required return water temperature difference between primary and secondary
    circuits for staging down"
    annotation (
      Evaluate=true,
      Dialog(
        enable=not
                  (have_priOnl),
        tab="Staging parameters",
        group="Staging down parameters"));

  parameter Real delTRetDif(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 300
    "Enable delay for measured hot water return temperature difference condition"
    annotation (
      Evaluate=true,
      Dialog(
        enable=not
                  (have_priOnl),
        tab="Staging parameters",
        group="Staging down parameters"));

  parameter Real bypValClo(
    final unit="1",
    displayUnit="1") = 0
    "Adjustment for signal received when bypass valve is closed"
    annotation (
      Evaluate=true,
      Dialog(
        enable=have_priOnl,
        tab="Advanced",
        group="Staging down parameters"));

  parameter Real dTemp(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.1
    "Hysteresis deadband for measured temperatures"
    annotation (Dialog(tab="Advanced", group="Failsafe condition parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaChaProEnd
    "Signal indicating end of stage change process"
    annotation (Placement(transformation(extent={{-440,-300},{-400,-260}}),
      iconTransformation(extent={{-140,-260},{-100,-220}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiAva[nBoi]
    "Boiler availability status vector"
    annotation (Placement(transformation(extent={{-440,-210},{-400,-170}}),
      iconTransformation(extent={{-140,-220},{-100,-180}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-440,-120},{-400,-80}}),
      iconTransformation(extent={{-140,-140},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta)
    "Boiler stage"
    annotation (Placement(transformation(extent={{-440,-150},{-400,-110}}),
      iconTransformation(extent={{-140,-180},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatRetPri(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured temperature of return hot water in primary circuit"
    annotation (Placement(transformation(extent={{-440,10},{-400,50}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatRetSec(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if not have_priOnl
    "Measured temperature of return hot water in secondary circuit"
    annotation (Placement(transformation(extent={{-440,-30},{-400,10}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSupSet(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-440,270},{-400,310}}),
      iconTransformation(extent={{-140,220},{-100,260}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSup(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water supply temperature"
    annotation (Placement(transformation(extent={{-440,130},{-400,170}}),
      iconTransformation(extent={{-140,100},{-100,140}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatPri_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    displayUnit="m3/s")
    "Measured primary loop hot water flow rate"
    annotation (Placement(transformation(extent={{-440,190},{-400,230}}),
      iconTransformation(extent={{-140,180},{-100,220}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VMinSet_flow[nSta](
    final unit=fill("m3/s",nSta),
    displayUnit=fill("m3/s",nSta),
    final quantity=fill("VolumeFlowRate",nSta)) if not have_allNonCon
    "Vector with primary circuit minimum flow setpoint for all stages"
    annotation (Placement(transformation(extent={{-440,90},{-400,130}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uBypValPos(
    final unit="1",
    displayUnit="1") if have_priOnl
    "Bypass valve position"
    annotation (Placement(transformation(extent={{-440,50},{-400,90}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uPumSpe(
    final unit="1",
    displayUnit="1") if not have_priOnl and not have_allNonCon
    "Pump speed signal"
    annotation (Placement(transformation(extent={{-440,-70},{-400,-30}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VHotWatSec_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s",
    displayUnit="m3/s") if have_secFloSen
    "Measured secondary loop hot water flow rate"
    annotation (Placement(transformation(extent={{-440,160},{-400,200}}),
      iconTransformation(extent={{-140,140},{-100,180}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaUpEdg
    "Boiler stage change higher edge signal"
    annotation (Placement(transformation(extent={{120,80},{160,120}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaDowEdg
    "Boiler stage change lower edge signal"
    annotation (Placement(transformation(extent={{120,-40},{160,0}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yBoi[nBoi]
    "Boiler status setpoint vector for the current boiler stage setpoint"
    annotation (Placement(transformation(extent={{120,-80},{160,-40}}),
      iconTransformation(extent={{100,-120},{140,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChaEdg
    "Boiler stage change edge signal"
    annotation (Placement(transformation(extent={{120,20},{160,60}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput ySta(
    final min=0,
    final max=nSta) "Boiler stage integer setpoint"
    annotation (Placement(transformation(extent={{120,120},{160,160}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yStaTyp[nSta]
    "Boiler stage type vector"
    annotation (Placement(transformation(extent={{120,180},{160,220}}),
      iconTransformation(extent={{100,80},{140,120}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.CapacityRequirement capReq1(
    final avePer=avePer)
    "Capacity requirement calculator"
    annotation (Placement(transformation(extent={{-360,240},{-340,260}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Capacities cap(
    final nSta=nSta)
    "Stage capacity calculator to to find design and minimum capacities for staging calculations"
    annotation (Placement(transformation(extent={{-270,-180},{-250,-160}})));

protected
  parameter Boolean have_allCon = sum(boiTyp)==1*nBoi
    "Check if all the boilers in a plant are condensing boilers";

  parameter Boolean have_allNonCon = sum(boiTyp)==2*nBoi
    "Check if all the boilers in a plant are non-condensing boilers";

  final parameter Integer nSta=size(staMat,1)
    "Number of boiler plant stages";

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Change cha(
    final nSta=nSta,
    final delStaCha=delStaCha)
    "Stage change assignment"
    annotation (Placement(transformation(extent={{-20,-180},{0,-160}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.BoilerIndices boiInd(
    final nSta=nSta,
    final nBoi=nBoi,
    final staMat=staMat)
    "Boiler index generator"
    annotation (Placement(transformation(extent={{40,-210},{60,-190}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Configurator conf(
    final nSta=nSta,
    final nBoi=nBoi,
    final boiTyp=boiTyp,
    final staMat=staMat,
    final boiDesCap=boiDesCap,
    final boiFirMin=boiFirMin)
    "Configurator to decide stage availability based on boiler availability"
    annotation (Placement(transformation(extent={{-380,-180},{-360,-160}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Status sta(
    final nSta=nSta,
    final nBoi=nBoi,
    final staMat=staMat)
    "Status calculator to find next higher and lower available stages"
    annotation (Placement(transformation(extent={{-310,-220},{-290,-200}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Up staUp(
    have_allNonCon=have_allNonCon,
    final nSta=nSta,
    final fraNonConBoi=fraNonConBoi,
    final fraConBoi=fraConBoi,
    final sigDif=sigDif,
    final delEffCon=delEffCon,
    final TDif=TDif,
    final TDifHys=TDifHys,
    final delFaiCon=delFaiCon)
    "Staging up calculator"
    annotation (Placement(transformation(extent={{-140,-116},{-120,-84}})));

  Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Down staDow(
    final have_priOnl=have_priOnl,
    final have_allNonCon=have_allNonCon,
    final nSta=nSta,
    final fraMinFir=fraMinFir,
    final delMinFir=delMinFir,
    final fraDesCap=fraDesCap,
    final delDesCapNonConBoi=delDesCapNonConBoi,
    final delDesCapConBoi=delDesCapConBoi,
    final sigDif=sigDif,
    final delBypVal=delBypVal,
    final bypValClo=bypValClo,
    final TCirDif=TCirDif,
    final delTRetDif=delTRetDif,
    final dTemp=dTemp,
    final TDif=TDif,
    final delFaiCon=delFaiCon,
    final boiMinPriPumSpeSta=boiMinPriPumSpeSta)
    "Staging down calculator"
    annotation (Placement(transformation(extent={{-140,-256},{-120,-221}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=nSta) if not have_allNonCon
    "Identify minimum flow rate for the next higher available stage"
    annotation (Placement(transformation(extent={{-240,-120},{-220,-100}})));

equation
  connect(uPla, cha.uPla) annotation (Line(points={{-420,-100},{-280,-100},{-280,
          -140},{-60,-140},{-60,-165},{-22,-165}},
                                             color={255,0,255}));
  connect(cha.ySta, ySta) annotation (Line(points={{2,-164},{20,-164},{20,140},{
          140,140}}, color={255,127,0}));
  connect(boiInd.yBoi,yBoi)
    annotation (Line(points={{62,-200},{102,-200},{102,-60},{140,-60}},
                                                     color={255,0,255}));
  connect(cha.ySta,boiInd. u) annotation (Line(points={{2,-164},{20,-164},{20,
          -200},{38,-200}},  color={255,127,0}));
  connect(capReq1.TSupSet, THotWatSupSet) annotation (Line(points={{-362,257},{
          -380,257},{-380,290},{-420,290}},
                                       color={0,0,127}));
  if not have_secFloSen then
  connect(capReq1.VHotWat_flow, VHotWatPri_flow) annotation (Line(points={{-362,
          243},{-380,243},{-380,210},{-420,210}}, color={0,0,127}));
  connect(THotWatRetPri, capReq1.TRet) annotation (Line(points={{-420,30},{-386,
          30},{-386,250},{-362,250}}, color={0,0,127}));
  else
    connect(THotWatRetSec, capReq1.TRet) annotation (Line(points={{-420,-10},{-372,
          -10},{-372,250},{-362,250}}, color={0,0,127}));
  connect(VHotWatSec_flow, capReq1.VHotWat_flow) annotation (Line(points={{-420,
          180},{-392,180},{-392,242},{-380,242},{-380,243},{-362,243}}, color={0,
          0,127}));
  end if;
  connect(conf.uBoiAva,uBoiAva)  annotation (Line(points={{-382,-170},{-402,-170},
          {-402,-190},{-420,-190}}, color={255,0,255}));
  connect(sta.uAva, conf.yAva) annotation (Line(points={{-312,-216},{-332,-216},
          {-332,-176},{-358,-176}}, color={255,0,255}));
  connect(sta.u, u) annotation (Line(points={{-312,-204},{-328,-204},{-328,-130},
          {-420,-130}},color={255,127,0}));
  connect(conf.yCapDes, cap.uDesCap) annotation (Line(points={{-358,-164},{-350,
          -164},{-350,-161},{-272,-161}}, color={0,0,127}));
  connect(conf.yCapMin, cap.uMinCap) annotation (Line(points={{-358,-168},{-340,
          -168},{-340,-164},{-272,-164}}, color={0,0,127}));
  connect(cap.u, u) annotation (Line(points={{-272,-167},{-308,-167},{-308,-168},
          {-328,-168},{-328,-130},{-420,-130}},
                                              color={255,127,0}));
  connect(sta.yAvaUp, cap.uUp) annotation (Line(points={{-288,-203},{-280,-203},
          {-280,-170},{-272,-170}}, color={255,127,0}));
  connect(sta.yAvaDow, cap.uDown) annotation (Line(points={{-288,-206},{-278,-206},
          {-278,-173},{-272,-173}}, color={255,127,0}));
  connect(sta.yHig, cap.uHig) annotation (Line(points={{-288,-211},{-276,-211},{
          -276,-176},{-272,-176}}, color={255,0,255}));
  connect(sta.yLow, cap.uLow) annotation (Line(points={{-288,-214},{-274,-214},{
          -274,-179},{-272,-179}}, color={255,0,255}));
  connect(cap.yDes, staUp.uCapDes) annotation (Line(points={{-248,-162},{-210,
          -162},{-210,-88},{-142,-88}},
                                    color={0,0,127}));
  connect(cap.yUpMin, staUp.uCapUpMin) annotation (Line(points={{-248,-178},{
          -208,-178},{-208,-91},{-142,-91}},
                                          color={0,0,127}));
  connect(conf.yTyp, staUp.uTyp) annotation (Line(points={{-358,-172},{-336,
          -172},{-336,-226},{-206,-226},{-206,-100},{-142,-100}},
                                                            color={255,127,0}));
  connect(sta.yAvaCur, staUp.uAvaCur) annotation (Line(points={{-288,-217},{
          -154,-217},{-154,-112},{-142,-112}},
                                          color={255,0,255}));
  connect(THotWatSup, staUp.THotWatSup) annotation (Line(points={{-420,150},{-188,
          150},{-188,-109},{-142,-109}}, color={0,0,127}));
  connect(THotWatSupSet, staUp.THotWatSupSet) annotation (Line(points={{-420,
          290},{-184,290},{-184,-106},{-142,-106}},
                                               color={0,0,127}));
  connect(VHotWatPri_flow, staUp.VHotWat_flow) annotation (Line(points={{-420,210},
          {-194,210},{-194,-94},{-142,-94}}, color={0,0,127}));
  connect(staDow.THotWatSupSet, THotWatSupSet) annotation (Line(points={{-142,-231},
          {-184,-231},{-184,290},{-420,290}}, color={0,0,127}));
  connect(staDow.THotWatSup, THotWatSup) annotation (Line(points={{-142,-234},{-188,
          -234},{-188,150},{-420,150}}, color={0,0,127}));
  connect(staDow.uCapReq, capReq1.y) annotation (Line(points={{-142,-237},{-180,
          -237},{-180,250},{-338,250}}, color={0,0,127}));
  connect(extIndSig.y, staUp.VUpMinSet_flow) annotation (Line(points={{-218,
          -110},{-216,-110},{-216,-97},{-142,-97}},
                                                color={0,0,127}));
  connect(extIndSig.u, VMinSet_flow) annotation (Line(points={{-242,-110},{-250,
          -110},{-250,110},{-420,110}}, color={0,0,127}));
  connect(extIndSig.index, sta.yAvaUp) annotation (Line(points={{-230,-122},{-230,
          -154},{-280,-154},{-280,-203},{-288,-203}}, color={255,127,0}));
  connect(cap.yMin, staDow.uCapMin) annotation (Line(points={{-248,-174},{-190,-174},
          {-190,-240},{-142,-240}},       color={0,0,127}));
  connect(cap.yDowDes, staDow.uCapDowDes) annotation (Line(points={{-248,-170},{
          -192,-170},{-192,-243},{-142,-243}},  color={0,0,127}));
  connect(staDow.uBypValPos, uBypValPos) annotation (Line(points={{-142,-246},{-172,
          -246},{-172,70},{-420,70}},   color={0,0,127}));
  connect(THotWatRetPri, staDow.TPriHotWatRet) annotation (Line(points={{-420,30},
          {-170,30},{-170,-252},{-142,-252}},  color={0,0,127}));
  connect(THotWatRetSec, staDow.TSecHotWatRet) annotation (Line(points={{-420,-10},
          {-168,-10},{-168,-255},{-142,-255}}, color={0,0,127}));
  connect(capReq1.y, staUp.uCapReq) annotation (Line(points={{-338,250},{-180,
          250},{-180,-85},{-142,-85}},   color={0,0,127}));
  connect(sta.yAvaUp, staUp.uAvaUp) annotation (Line(points={{-288,-203},{-280,
          -203},{-280,-154},{-202,-154},{-202,-103},{-142,-103}},
                                                            color={255,127,0}));
  connect(u, staDow.uCur) annotation (Line(points={{-420,-130},{-328,-130},{-328,
          -228},{-142,-228}},       color={255,127,0}));
  connect(cha.uAvaUp, sta.yAvaUp) annotation (Line(points={{-22,-168},{-60,-168},
          {-60,-203},{-288,-203}}, color={255,127,0}));
  connect(cha.uAvaDow, sta.yAvaDow) annotation (Line(points={{-22,-172},{-56,-172},
          {-56,-206},{-288,-206}},       color={255,127,0}));
  connect(staUp.yStaUp, cha.uUp) annotation (Line(points={{-118,-100},{-64,-100},
          {-64,-175},{-22,-175}}, color={255,0,255}));
  connect(staDow.yStaDow, cha.uDow) annotation (Line(points={{-118,-240},{-64,-240},
          {-64,-178},{-22,-178}}, color={255,0,255}));
  connect(uPumSpe, staDow.uPumSpe) annotation (Line(points={{-420,-50},{-198,-50},
          {-198,-249},{-142,-249}}, color={0,0,127}));
  connect(conf.yTyp, staDow.uTyp) annotation (Line(points={{-358,-172},{-336,
          -172},{-336,-226},{-142,-226},{-142,-225}},     color={255,127,0}));
  connect(uStaChaProEnd, staDow.uStaChaProEnd) annotation (Line(points={{-420,-280},
          {-150,-280},{-150,-222},{-142,-222}},               color={255,0,255}));
  connect(uStaChaProEnd, cha.uStaChaProEnd) annotation (Line(points={{-420,-280},
          {-19,-280},{-19,-182}}, color={255,0,255}));
  connect(cha.yChaEdg, yChaEdg) annotation (Line(points={{2,-172},{110,-172},{110,
          40},{140,40}},         color={255,0,255}));
  connect(cha.yChaUpEdg, yChaUpEdg) annotation (Line(points={{2,-168},{100,-168},
          {100,100},{140,100}}, color={255,0,255}));
  connect(cha.yChaDowEdg, yChaDowEdg) annotation (Line(points={{2,-176},{72,-176},
          {72,-20},{140,-20}},          color={255,0,255}));
  connect(uStaChaProEnd, staUp.uStaChaProEnd) annotation (Line(points={{-420,-280},
          {-150,-280},{-150,-115},{-142,-115}},         color={255,0,255}));
  connect(conf.yAva, cha.uStaAva) annotation (Line(points={{-358,-176},{-332,
          -176},{-332,-280},{-30,-280},{-30,-162},{-22,-162}}, color={255,0,255}));
  connect(conf.yTyp, yStaTyp) annotation (Line(points={{-358,-172},{-336,-172},
          {-336,200},{140,200}},
                               color={255,127,0}));
  annotation (defaultComponentName = "staSetCon",
        Icon(coordinateSystem(extent={{-100,-240},{100,240}}),
             graphics={
        Rectangle(
        extent={{-100,-240},{100,240}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-110,300},{110,260}},
          textColor={0,0,255},
          textString="%name")}), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-400,-300},{120,300}})),
Documentation(info="<html>
<p>
The sequence is a boiler stage status setpoint controller that outputs the 
boiler stage integer index <code>ySta</code>, boiler stage change trigger signals
<code>yChaEdg</code>, <code>yChaUpEdg</code>, <code>yChaDowEdg</code>, and a boiler
status vector for the current stage <code>yBoi</code>.
</p>
<p>
Implemented according to ASHRAE Guideline 36, 2021, section 5.21.3.9.
</p>
<p>
The controller contains the following subsequences:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.CapacityRequirement\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.CapacityRequirement</a> to calculate
the capacity requirement.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Configurator\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Configurator</a> to allow the user 
to provide the boiler plant configuration parameters such as boiler design and minimal capacities and types. It 
calculates the design and minimal stage capacities, stage type and stage availability.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Status\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Status</a> to calculate
the next higher and lower available stages.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Capacities\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Capacities</a> to calculate
design and minimal stage capacities for current and next available higher and lower stage.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Up\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Up</a> to generate
a stage up signal.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Down\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Down</a> to generate
a stage down signal.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Change\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.Change</a> to set the stage
based on the initial stage signal and stage up and down signals.
</li>
<li>
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.BoilerIndices\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Boilers.Staging.SetPoints.Subsequences.BoilerIndices</a> to generate
the boiler index vector for a given stage.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
June 22, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end SetpointController;
