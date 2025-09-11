within Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers;
block Controller "Cooling tower controller"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Integer totSta=5
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable";
  parameter Integer nTowCel=2 "Total number of cooling tower cells";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.TowerSpeedControl fanSpeCon=
    Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.TowerSpeedControl.CondenserWaterReturnTemperaure
    "Tower fan speed control type";
  final parameter Boolean have_conWatRetCon = fanSpeCon==Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Types.TowerSpeedControl.CondenserWaterReturnTemperaure
    "True: the fan speed is controlled to maintain the condenser water return temperature setpoint";
  parameter Boolean closeCoupledPlant=true
    "True: the plant is close coupled, i.e. the pipe length from the chillers to cooling towers does not exceed approximately 100 feet"
    annotation (Dialog(enable=have_conWatRetCon));
  parameter Boolean have_WSE=true
    "Flag to indicate if the plant has waterside economizer";
  parameter Real desCap(unit="W")=1e6  "Plant design capacity"
    annotation (Dialog(group="Nominal"));
  parameter Real fanSpeMin=0.1 "Minimum tower fan speed"
    annotation (Dialog(group="Nominal"));
  parameter Real fanSpeMax=1 "Maximum tower fan speed"
    annotation (Dialog(group="Nominal"));

  // Fan speed control: when WSE is enabled
  parameter Real chiMinCap[nChi](unit=fill("W", nChi))={1e4,1e4}
    "Minimum cyclining load below which chiller will begin cycling"
    annotation (Dialog(tab="Fan speed", group="WSE enabled",
                       enable=have_WSE));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController intOpeCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Controller in the mode when WSE and chillers are enabled"
    annotation (Dialog(tab="Fan speed", group="WSE enabled",
                       enable=have_WSE));
  parameter Real kIntOpe=1 "Gain of controller"
    annotation (Dialog(tab="Fan speed", group="WSE enabled",
                       enable=have_WSE));
  parameter Real TiIntOpe(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Fan speed", group="WSE enabled",
                       enable=have_WSE and (intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                          intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdIntOpe(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Fan speed", group="WSE enabled",
                       enable=have_WSE and (intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                          intOpeCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController chiWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Controller in the mode when only WSE is enabled"
    annotation (Dialog(tab="Fan speed", group="WSE enabled",
                       enable=have_WSE));
  parameter Real kWSE=1 "Gain of controller"
    annotation (Dialog(tab="Fan speed", group="WSE enabled",
                       enable=have_WSE));
  parameter Real TiWSE(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Fan speed", group="WSE enabled",
                       enable=have_WSE and (chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                          chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdWSE(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Fan speed", group="WSE enabled",
                       enable=have_WSE and (chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                          chiWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  // Fan speed control: controlling condenser return water temperature when WSE is not enabled
  parameter Real minChiLif[nChi](unit=fill("K", nChi))={12,12}
    "Minimum LIFT of each chiller"
     annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Real TConWatSup_nominal[nChi](
    unit=fill("K", nChi),
    displayUnit=fill("degC", nChi))={293.15,293.15}
    "Condenser water supply temperature (condenser entering) of each chiller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Real TConWatRet_nominal[nChi](
    unit=fill("K", nChi),
    displayUnit=fill("degC", nChi))={303.15,303.15}
    "Condenser water return temperature (condenser leaving) of each chiller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Real TChiWatSupMin[nChi](
    unit=fill("K", nChi),
    displayUnit=fill("degC", nChi))={278.15,278.15}
    "Lowest chilled water supply temperature oc each chiller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController couPlaCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of coupled plant controller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=closeCoupledPlant));
  parameter Real kCouPla=1 "Gain of controller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=closeCoupledPlant));
  parameter Real TiCouPla(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=closeCoupledPlant and (couPlaCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                     couPlaCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdCouPla(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=closeCoupledPlant and (couPlaCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                     couPlaCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real yCouPlaMax=1 "Upper limit of output"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=closeCoupledPlant));
  parameter Real yCouPlaMin=0 "Lower limit of output"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=closeCoupledPlant));

  parameter Real samplePeriod(unit="s")=30
    "Period of sampling condenser water supply and return temperature difference"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=not closeCoupledPlant));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController supWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Condenser supply water temperature controller for less coupled plant"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=not closeCoupledPlant));
  parameter Real kSupCon=1 "Gain of controller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=not closeCoupledPlant));
  parameter Real TiSupCon(unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=not closeCoupledPlant and (supWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                         supWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdSupCon(unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=not closeCoupledPlant and (supWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                         supWatCon==Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real ySupConMax=1 "Upper limit of output"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=not closeCoupledPlant));
  parameter Real ySupConMin=0 "Lower limit of output"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=not closeCoupledPlant));
  parameter Real speChe=0.005
    "Lower threshold value to check fan or pump speed"
    annotation (Dialog(tab="Fan speed", group="Advanced"));
  parameter Real iniPlaTim(unit="s")=600
    "Time to hold return temperature at initial setpoint after plant being enabled"
    annotation (Dialog(tab="Fan speed", group="Advanced"));
  parameter Real ramTim(unit="s")=180
    "Time to ramp return water temperature from initial value to setpoint"
    annotation (Dialog(tab="Fan speed", group="Advanced"));
  parameter Real cheMinFanSpe(unit="s")=300
    "Threshold time for checking duration when tower fan equals to the minimum tower fan speed"
    annotation (Dialog(tab="Fan speed", group="Advanced"));
  parameter Real cheMaxTowSpe(unit="s")=300
    "Threshold time for checking duration when any enabled chiller maximum cooling speed equals to the minimum tower fan speed"
    annotation (Dialog(tab="Fan speed", group="Advanced"));
  parameter Real cheTowOff(unit="s")=60
    "Threshold time for checking duration when there is no enabled tower fan"
    annotation (Dialog(tab="Fan speed", group="Advanced"));

  // Tower staging
  parameter Real staVec[totSta]={0,0.5,1,1.5,2}
    "Plant stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(tab="Tower staging", group="Nominal"));
  parameter Integer towCelOnSet[totSta]={0,1,1,2,2}
    "Design number of tower fan cells that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(tab="Tower staging"));
  parameter Real chaTowCelIsoTim(unit="s")=300
    "Time to slowly change isolation valve"
    annotation (Dialog(tab="Tower staging", group="Enable isolation valve"));

  // Water level control
  parameter Real watLevMin(
    min=0,
    unit="m")=0.7
    "Minimum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Makeup water"));
  parameter Real watLevMax(unit="m")=1
    "Maximum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Makeup water"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uChiLoa(
    final unit="W",
    final quantity="HeatFlowRate") if have_WSE "Current cooling load"
    annotation (Placement(transformation(extent={{-140,220},{-100,260}}),
        iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Vector of chiller proven on status: true=ON"
    annotation (Placement(transformation(extent={{-140,190},{-100,230}}),
      iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWse if have_WSE
    "Waterside economizer proven on status: true=ON"
    annotation (Placement(transformation(extent={{-140,160},{-100,200}}),
      iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_WSE
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}}),
      iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput reqPlaCap(
    final unit="W",
    final quantity="HeatFlowRate") "Current required plant capacity"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxSpeSet[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Vector of tower cell proven on status: true=running tower cell"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_conWatRetCon
    "Condenser water return temperature (condenser leaving)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[nConWatPum]
    "Current condenser water pump status"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Condenser water supply temperature (condenser entering)"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaPla
    "True: plant is just enabled"
    annotation(Placement(transformation(extent={{-140,-90},{-100,-50}}),
        iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiStaSet
    "Chiller stage setpoint"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowStaCha
    "Cooling tower stage change command from plant staging process"
    annotation (Placement(transformation(extent={{-140,-170},{-100,-130}}),
      iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoVal[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel))
    "Vector of tower cells isolation valve position"
    annotation (Placement(transformation(extent={{-140,-240},{-100,-200}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput watLev(
    final unit="m")
    "Measured water level"
    annotation (Placement(transformation(extent={{-140,-260},{-100,-220}}),
      iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yLifMax(
    final unit="K") if have_conWatRetCon
    "Maximum LIFT among enabled chillers"
    annotation (Placement(transformation(extent={{100,128},{140,168}}),
        iconTransformation(extent={{100,170},{140,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yLifMin(
    final unit="K") if have_conWatRetCon
    "Minimum LIFT among enabled chillers"
    annotation (Placement(transformation(extent={{100,100},{140,140}}),
        iconTransformation(extent={{100,150},{140,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConWatRetSet(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") if have_conWatRetCon
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
        iconTransformation(extent={{100,120},{140,160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConWatSupSet(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") if have_conWatRetCon and not closeCoupledPlant
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{100,42},{140,82}}),
        iconTransformation(extent={{100,100},{140,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaCel
    "Lead tower cell status setpoint"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel))
    "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{100,-90},{140,-50}}),
      iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Vector of tower cells status setpoint"
    annotation (Placement(transformation(extent={{100,-130},{140,-90}}),
      iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySpeSet(
    final min=0,
    final max=1,
    final unit="1") if have_conWatRetCon "Fan speed setpoint for enabled cell"
    annotation (Placement(transformation(extent={{100,-170},{140,-130}}),
        iconTransformation(extent={{100,-130},{140,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMakUp
    "Makeup water valve On-Off status"
    annotation (Placement(transformation(extent={{100,-260},{140,-220}}),
      iconTransformation(extent={{100,-190},{140,-150}})));

protected
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.FanSpeed.Controller towFanSpe(
    final nChi=nChi,
    final nTowCel=nTowCel,
    final nConWatPum=nConWatPum,
    final fanSpeCon=fanSpeCon,
    final closeCoupledPlant=closeCoupledPlant,
    final have_WSE=have_WSE,
    final desCap=desCap,
    final fanSpeMin=fanSpeMin,
    final fanSpeMax=fanSpeMax,
    final chiMinCap=chiMinCap,
    final intOpeCon=intOpeCon,
    final kIntOpe=kIntOpe,
    final TiIntOpe=TiIntOpe,
    final TdIntOpe=TdIntOpe,
    final chiWatCon=chiWatCon,
    final kWSE=kWSE,
    final TiWSE=TiWSE,
    final TdWSE=TdWSE,
    final minChiLif=minChiLif,
    final TConWatSup_nominal=TConWatSup_nominal,
    final samplePeriod=samplePeriod,
    final cheMinFanSpe=cheMinFanSpe,
    final cheMaxTowSpe=cheMaxTowSpe,
    final cheTowOff=cheTowOff,
    final iniPlaTim=iniPlaTim,
    final ramTim=ramTim,
    final TConWatRet_nominal=TConWatRet_nominal,
    final TChiWatSupMin=TChiWatSupMin,
    final couPlaCon=couPlaCon,
    final kCouPla=kCouPla,
    final TiCouPla=TiCouPla,
    final TdCouPla=TdCouPla,
    final yCouPlaMax=yCouPlaMax,
    final yCouPlaMin=yCouPlaMin,
    final supWatCon=supWatCon,
    final kSupCon=kSupCon,
    final TiSupCon=TiSupCon,
    final TdSupCon=TdSupCon,
    final ySupConMax=ySupConMax,
    final ySupConMin=ySupConMin,
    final speChe=speChe) "Tower fan speed"
    annotation (Placement(transformation(extent={{-20,20},{0,60}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Controller towSta(
    final have_WSE=have_WSE,
    final nTowCel=nTowCel,
    final nConWatPum=nConWatPum,
    final totSta=totSta,
    final staVec=staVec,
    final towCelOnSet=towCelOnSet,
    final chaTowCelIsoTim=chaTowCelIsoTim)
                         "Cooling tower staging"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.WaterLevel makUpWat(
    final watLevMin=watLevMin,
    final watLevMax=watLevMax)
    "Make up water control"
    annotation (Placement(transformation(extent={{-20,-250},{0,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi if have_conWatRetCon
    "Logical switch"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nTowCel)
    "Check if there is any enabled cell"
    annotation (Placement(transformation(extent={{20,-160},{40,-140}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(final nin=nConWatPum)
    "Check if there is any pump on"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

equation
  connect(towSta.yTowSta, yTowSta)
    annotation (Line(points={{22,-54},{30,-54},{30,-110},{120,-110}},color={255,0,255}));
  connect(towSta.yIsoVal, yIsoVal)
    annotation (Line(points={{22,-50},{40,-50},{40,-70},{120,-70}},color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{22,-180},{50,-180},{50,-158},{58,-158}},
      color={0,0,127}));
  connect(towFanSpe.uChiLoa, uChiLoa) annotation (Line(points={{-22,59},{-40,59},
          {-40,240},{-120,240}}, color={0,0,127}));
  connect(towFanSpe.uChi, uChi)
    annotation (Line(points={{-22,56},{-44,56},{-44,210},{-120,210}}, color={255,0,255}));
  connect(towFanSpe.uWse, uWse) annotation (Line(points={{-22,53},{-48,53},{-48,
          180},{-120,180}}, color={255,0,255}));
  connect(towFanSpe.TChiWatSup, TChiWatSup)
    annotation (Line(points={{-22,47},{-56,47},{-56,140},{-120,140}}, color={0,0,127}));
  connect(towFanSpe.TChiWatSupSet, TChiWatSupSet)
    annotation (Line(points={{-22,44},{-60,44},{-60,120},{-120,120}}, color={0,0,127}));
  connect(towFanSpe.reqPlaCap, reqPlaCap)
    annotation (Line(points={{-22,41},{-64,41},{-64,100},{-120,100}}, color={0,0,127}));
  connect(towFanSpe.uMaxSpeSet, uMaxSpeSet) annotation (Line(points={{-22,38},{
          -68,38},{-68,70},{-120,70}}, color={0,0,127}));
  connect(towFanSpe.uTow, uTowSta) annotation (Line(points={{-22,35},{-76,35},{-76,
          40},{-120,40}},     color={255,0,255}));
  connect(towFanSpe.uPla, uPla)
    annotation (Line(points={{-22,29},{-84,29},{-84,20},{-120,20}}, color={255,0,255}));
  connect(towFanSpe.TConWatRet, TConWatRet)
    annotation (Line(points={{-22,26},{-80,26},{-80,0},{-120,0}},     color={0,0,127}));
  connect(towFanSpe.TConWatSup, TConWatSup)
    annotation (Line(points={{-22,21},{-68,21},{-68,-40},{-120,-40}}, color={0,0,127}));
  connect(towSta.uChiSta, uChiSta)
    annotation (Line(points={{-2,-41},{-64,-41},{-64,-100},{-120,-100}},  color={255,127,0}));
  connect(towSta.uIsoVal, uIsoVal)
    annotation (Line(points={{-2,-57},{-40,-57},{-40,-220},{-120,-220}},  color={0,0,127}));
  connect(makUpWat.watLev, watLev)
    annotation (Line(points={{-22,-240},{-120,-240}}, color={0,0,127}));
  connect(makUpWat.yMakUp, yMakUp)
    annotation (Line(points={{2,-240},{120,-240}}, color={255,0,255}));
  connect(uTowSta, towSta.uTowSta)
    annotation (Line(points={{-120,40},{-76,40},{-76,-59},{-2,-59}},  color={255,0,255}));
  connect(towSta.uChiStaSet, uChiStaSet) annotation (Line(points={{-2,-43},{-60,
          -43},{-60,-120},{-120,-120}}, color={255,127,0}));
  connect(towSta.uTowStaCha, uTowStaCha) annotation (Line(points={{-2,-45},{-56,
          -45},{-56,-150},{-120,-150}}, color={255,0,255}));
  connect(uWse, towSta.uWse) annotation (Line(points={{-120,180},{-48,180},{-48,
          -47},{-2,-47}},  color={255,0,255}));
  connect(towSta.yLeaCel, yLeaCel) annotation (Line(points={{22,-46},{40,-46},{40,
          -30},{120,-30}}, color={255,0,255}));
  connect(uEnaPla, towSta.uEnaPla) annotation (Line(points={{-120,-70},{-48,-70},
          {-48,-49},{-2,-49}},  color={255,0,255}));
  connect(swi.y, ySpeSet)
    annotation (Line(points={{82,-150},{120,-150}}, color={0,0,127}));
  connect(uPla, towSta.uPla) annotation (Line(points={{-120,20},{-84,20},{-84,-51},
          {-2,-51}},  color={255,0,255}));
  connect(towFanSpe.yLifMax, yLifMax) annotation (Line(points={{2,30},{20,30},{20,
          148},{120,148}},                         color={0,0,127}));
  connect(towFanSpe.yLifMin, yLifMin) annotation (Line(points={{2,27},{30,27},{30,
          120},{120,120}},         color={0,0,127}));
  connect(towFanSpe.ySpeSet, swi.u1) annotation (Line(points={{2,40},{50,40},{50,
          -142},{58,-142}}, color={0,0,127}));
  connect(mulOr.y, swi.u2)
    annotation (Line(points={{42,-150},{58,-150}}, color={255,0,255}));
  connect(towSta.yTowSta, mulOr.u) annotation (Line(points={{22,-54},{30,-54},{30,
          -128},{0,-128},{0,-150},{18,-150}}, color={255,0,255}));
  connect(towFanSpe.TConWatRetSet, TConWatRetSet) annotation (Line(points={{2,23.8},
          {40,23.8},{40,90},{120,90}}, color={0,0,127}));
  connect(towFanSpe.TConWatSupSet, TConWatSupSet) annotation (Line(points={{2,21},
          {60,21},{60,62},{120,62}}, color={0,0,127}));
  connect(uConWatPum, towFanSpe.uConWatPum) annotation (Line(points={{-120,-20},
          {-72,-20},{-72,23},{-22,23}}, color={255,0,255}));
  connect(uConWatPum, mulOr1.u)
    annotation (Line(points={{-120,-20},{-42,-20}}, color={255,0,255}));
  connect(mulOr1.y, towSta.uAnyConWatPum) annotation (Line(points={{-18,-20},{-10,
          -20},{-10,-53},{-2,-53}}, color={255,0,255}));
annotation (
  defaultComponentName="towCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,200}}), graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,248},{100,210}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,-120},{-26,-136}},
          textColor={255,0,255},
          textString="uTowStaCha"),
        Text(
          extent={{-100,196},{-62,184}},
          textColor={0,0,127},
          visible=have_WSE,
          textString="uChiLoa"),
        Text(
          extent={{-98,-82},{-50,-98}},
          textColor={255,127,0},
          textString="uChiSta"),
        Text(
          extent={{-98,-100},{-32,-118}},
          textColor={255,127,0},
          textString="uChiStaSet"),
        Text(
          extent={{48,-160},{100,-176}},
          textColor={255,0,255},
          textString="yMakUp"),
        Text(
          extent={{-98,38},{-54,24}},
          textColor={255,0,255},
          textString="uTowSta"),
        Text(
          extent={{-98,18},{-68,4}},
          textColor={255,0,255},
          textString="uPla"),
        Text(
          extent={{-100,178},{-70,164}},
          textColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{-96,158},{-66,144}},
          textColor={255,0,255},
          textString="uWse",
          visible=have_WSE),
        Text(
          extent={{-98,118},{-34,102}},
          textColor={0,0,127},
          textString="TChiWatSup",
          visible=have_WSE),
        Text(
          extent={{-98,80},{-34,64}},
          textColor={0,0,127},
          textString="reqPlaCap"),
        Text(
          extent={{-96,98},{-16,82}},
          textColor={0,0,127},
          textString="TChiWatSupSet"),
        Text(
          extent={{-98,60},{-28,44}},
          textColor={0,0,127},
          textString="uMaxSpeSet"),
        Text(
          extent={{-100,-22},{-16,-40}},
          textColor={255,0,255},
          textString="uConWatPum"),
        Text(
          extent={{-100,-2},{-36,-18}},
          textColor={0,0,127},
          textString="TConWatRet"),
        Text(
          extent={{-98,-42},{-34,-58}},
          textColor={0,0,127},
          textString="TConWatSup",
          visible=not closeCoupledPlant),
        Text(
          extent={{-100,-178},{-56,-192}},
          textColor={0,0,127},
          textString="watLev"),
        Text(
          extent={{-98,-160},{-54,-176}},
          textColor={0,0,127},
          textString="uIsoVal"),
        Text(
          extent={{54,-100},{98,-116}},
          textColor={0,0,127},
          textString="ySpeSet"),
        Text(
          extent={{46,-40},{98,-56}},
          textColor={255,0,255},
          textString="yTowSta"),
        Text(
          extent={{54,58},{98,42}},
          textColor={0,0,127},
          textString="yIsoVal"),
        Text(
          extent={{48,90},{100,74}},
          textColor={255,0,255},
          textString="yLeaCel"),
        Text(
          extent={{-96,-64},{-58,-78}},
          textColor={255,0,255},
          textString="uEnaPla"),
        Text(
          extent={{46,200},{96,182}},
          textColor={0,0,127},
          textString="yLifMax"),
        Text(
          extent={{46,180},{96,162}},
          textColor={0,0,127},
          textString="yLifMin"),
        Text(
          extent={{30,152},{98,134}},
          textColor={0,0,127},
          textString="TConWatRetSet",
          visible=have_conWatRetCon),
        Text(
          extent={{30,130},{98,112}},
          textColor={0,0,127},
          visible=have_conWatRetCon and not closeCoupledPlant,
          textString="TConWatSupSet")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-260},{100,260}})),
Documentation(info="<html>
<p>
Block that controls the cooling tower cells enabling status <code>yTowSta</code>,
the supply isolation valve positions <code>yIsoVal</code> of each cell and the
cell fan operating speed <code>ySpeSet</code>.
This is implemented according to ASHRAE Guideline 36-2021, section 5.20.12.
The section specifies sequences to control the cooling tower.
It includes three subsequences:
</p>
<ul>
<li>
Sequence of controlling tower fan speed, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.FanSpeed.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.FanSpeed.Controller</a>
for a description.
</li>
<li>
Sequence of cooling tower staging, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Controller\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.Staging.Controller</a>
for a description.
Note that the sequence assumes that the cells are enabled in order as it is labelled, meaning
that it enables the cells as cell 1, 2, 3, etc.
</li>
<li>
Sequence of tower make-up water valve control, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.WaterLevel\">
Buildings.Controls.OBC.ASHRAE.G36.Plants.Chillers.Towers.WaterLevel</a>
for a description.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
September 14, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
