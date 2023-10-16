within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers;
block Controller "Cooling tower controller"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Integer totSta=5
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable";
  parameter Integer nTowCel=2 "Total number of cooling tower cells";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Boolean closeCoupledPlant=false
    "Flag to indicate if the plant is close coupled";
  parameter Boolean have_WSE=true
    "Flag to indicate if the plant has waterside economizer";
  parameter Real desCap(unit="W")=1e6  "Plant design capacity"
    annotation (Dialog(group="Nominal"));
  parameter Real fanSpeMin=0.1 "Minimum tower fan speed"
    annotation (Dialog(group="Nominal"));
  parameter Real fanSpeMax=1 "Maximum tower fan speed"
    annotation (Dialog(group="Nominal"));

  // Fan speed control: when WSE is enabled
  parameter Real chiMinCap[nChi](
    final unit=fill("W",nChi))={1e4,1e4}
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
  parameter Real LIFT_min[nChi](
    final unit=fill("K",nChi))={12,12}
    "Minimum LIFT of each chiller"
     annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Real TConWatSup_nominal[nChi](
    final unit=fill("K",nChi),
    displayUnit=fill("degC",nChi))={293.15,293.15}
    "Condenser water supply temperature (condenser entering) of each chiller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Real TConWatRet_nominal[nChi](
    final unit=fill("K",nChi),
    displayUnit=fill("degC",nChi))={303.15,303.15}
    "Condenser water return temperature (condenser leaving) of each chiller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Real TChiWatSupMin[nChi](
    final unit=fill("K",nChi),
    displayUnit=fill("degC",nChi))={278.15,278.15}
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
    "Chiller stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(tab="Tower staging", group="Nominal"));
  parameter Real towCelOnSet[totSta]={0,1,1,2,2}
    "Design number of tower fan cells that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(tab="Tower staging"));
  parameter Real chaTowCelIsoTim(unit="s")=300
    "Time to slowly change isolation valve"
    annotation (Dialog(tab="Tower staging", group="Enable isolation valve"));

  // Water level control
  parameter Real watLevMin(
    final min=0)=0.7
    "Minimum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Makeup water"));
  parameter Real watLevMax=1
    "Maximum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Makeup water"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput chiLoa[nChi](
    final unit=fill("W", nChi),
    final quantity=fill("HeatFlowRate", nChi)) if have_WSE
    "Current cooling load of each chiller"
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanSpe(
     final min=0,
     final max=1,
     final unit="1") "Measured fan speed of each tower cell"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}),
      iconTransformation(extent={{-140,110},{-100,150}})));
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
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
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature (condenser leaving)"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum),
    final unit=fill("1", nConWatPum)) "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not closeCoupledPlant
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput watLev
    "Measured water level"
    annotation (Placement(transformation(extent={{-140,-260},{-100,-220}}),
      iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaCel
    "Lead tower cell status setpoint"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
      iconTransformation(extent={{100,90},{140,130}})));
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
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySpeSet[nTowCel](
    final min=fill(0, nTowCel),
    final max=fill(1, nTowCel),
    final unit=fill("1", nTowCel))
    "Fan speed setpoint of each cooling tower cell"
    annotation (Placement(transformation(extent={{100,-170},{140,-130}}),
      iconTransformation(extent={{100,-130},{140,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMakUp
    "Makeup water valve On-Off status"
    annotation (Placement(transformation(extent={{100,-260},{140,-220}}),
      iconTransformation(extent={{100,-190},{140,-150}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.Controller towFanSpe(
    final nChi=nChi,
    final nTowCel=nTowCel,
    final nConWatPum=nConWatPum,
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
    final LIFT_min=LIFT_min,
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
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Controller towSta(
    final have_WSE=have_WSE,
    final nTowCel=nTowCel,
    final nConWatPum=nConWatPum,
    final totSta=totSta,
    final staVec=staVec,
    final towCelOnSet=towCelOnSet,
    final chaTowCelIsoTim=chaTowCelIsoTim,
    final speChe=speChe) "Cooling tower staging"
    annotation (Placement(transformation(extent={{-20,-52},{0,-32}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.WaterLevel makUpWat(
    final watLevMin=watLevMin,
    final watLevMax=watLevMax)
    "Make up water control"
    annotation (Placement(transformation(extent={{-20,-250},{0,-230}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{60,-160},{80,-140}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer[nTowCel](
    final k=fill(0, nTowCel)) "Zero constant"
    annotation (Placement(transformation(extent={{0,-190},{20,-170}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nTowCel) "Replicate real input"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));

equation
  connect(towSta.yTowSta, yTowSta)
    annotation (Line(points={{2,-46},{20,-46},{20,-110},{120,-110}}, color={255,0,255}));
  connect(towSta.yIsoVal, yIsoVal)
    annotation (Line(points={{2,-42},{40,-42},{40,-70},{120,-70}}, color={0,0,127}));
  connect(towSta.yTowSta, swi.u2)
    annotation (Line(points={{2,-46},{20,-46},{20,-150},{58,-150}}, color={255,0,255}));
  connect(towFanSpe.ySpeSet, reaRep.u)
    annotation (Line(points={{2,40},{18,40}}, color={0,0,127}));
  connect(reaRep.y, swi.u1)
    annotation (Line(points={{42,40},{50,40},{50,-142},{58,-142}}, color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{22,-180},{40,-180},{40,-158},{58,-158}},
      color={0,0,127}));
  connect(towFanSpe.chiLoa, chiLoa)
    annotation (Line(points={{-22,59},{-40,59},{-40,240},{-120,240}}, color={0,0,127}));
  connect(towFanSpe.uChi, uChi)
    annotation (Line(points={{-22,56},{-44,56},{-44,210},{-120,210}}, color={255,0,255}));
  connect(towFanSpe.uWse, uWse) annotation (Line(points={{-22,53},{-48,53},{-48,
          180},{-120,180}}, color={255,0,255}));
  connect(towFanSpe.uFanSpe,uFanSpe)
    annotation (Line(points={{-22,50},{-52,50},{-52,160},{-120,160}}, color={0,0,127}));
  connect(towFanSpe.TChiWatSup, TChiWatSup)
    annotation (Line(points={{-22,47},{-56,47},{-56,140},{-120,140}}, color={0,0,127}));
  connect(towFanSpe.TChiWatSupSet, TChiWatSupSet)
    annotation (Line(points={{-22,44},{-60,44},{-60,120},{-120,120}}, color={0,0,127}));
  connect(towFanSpe.reqPlaCap, reqPlaCap)
    annotation (Line(points={{-22,41},{-64,41},{-64,100},{-120,100}}, color={0,0,127}));
  connect(towFanSpe.uMaxTowSpeSet, uMaxTowSpeSet)
    annotation (Line(points={{-22,38},{-68,38},{-68,70},{-120,70}}, color={0,0,127}));
  connect(towFanSpe.uTow, uTowSta) annotation (Line(points={{-22,35},{-76,35},{-76,
          40},{-120,40}},     color={255,0,255}));
  connect(towFanSpe.uPla, uPla)
    annotation (Line(points={{-22,29},{-84,29},{-84,20},{-120,20}}, color={255,0,255}));
  connect(towFanSpe.TConWatRet, TConWatRet)
    annotation (Line(points={{-22,26},{-80,26},{-80,0},{-120,0}},     color={0,0,127}));
  connect(towFanSpe.uConWatPumSpe, uConWatPumSpe)
    annotation (Line(points={{-22,23},{-72,23},{-72,-20},{-120,-20}}, color={0,0,127}));
  connect(towFanSpe.TConWatSup, TConWatSup)
    annotation (Line(points={{-22,21},{-68,21},{-68,-40},{-120,-40}}, color={0,0,127}));
  connect(towSta.uChiSta, uChiSta)
    annotation (Line(points={{-22,-33},{-64,-33},{-64,-100},{-120,-100}}, color={255,127,0}));
  connect(towSta.uIsoVal, uIsoVal)
    annotation (Line(points={{-22,-49},{-40,-49},{-40,-220},{-120,-220}}, color={0,0,127}));
  connect(makUpWat.watLev, watLev)
    annotation (Line(points={{-22,-240},{-120,-240}}, color={0,0,127}));
  connect(makUpWat.yMakUp, yMakUp)
    annotation (Line(points={{2,-240},{120,-240}}, color={255,0,255}));
  connect(uTowSta, towSta.uTowSta)
    annotation (Line(points={{-120,40},{-76,40},{-76,-51},{-22,-51}}, color={255,0,255}));
  connect(towSta.uChiStaSet, uChiStaSet) annotation (Line(points={{-22,-35},{-60,
          -35},{-60,-120},{-120,-120}}, color={255,127,0}));
  connect(towSta.uTowStaCha, uTowStaCha) annotation (Line(points={{-22,-37},{-56,
          -37},{-56,-150},{-120,-150}}, color={255,0,255}));
  connect(uWse, towSta.uWse) annotation (Line(points={{-120,180},{-48,180},{-48,
          -39},{-22,-39}}, color={255,0,255}));
  connect(uConWatPumSpe, towSta.uConWatPumSpe) annotation (Line(points={{-120,-20},
          {-72,-20},{-72,-45},{-22,-45}}, color={0,0,127}));
  connect(towSta.yLeaCel, yLeaCel) annotation (Line(points={{2,-38},{40,-38},{40,
          -30},{120,-30}}, color={255,0,255}));
  connect(uEnaPla, towSta.uEnaPla) annotation (Line(points={{-120,-70},{-34,-70},
          {-34,-41},{-22,-41}}, color={255,0,255}));
  connect(swi.y, ySpeSet)
    annotation (Line(points={{82,-150},{120,-150}}, color={0,0,127}));
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
          textString="chiLoa",
          visible=have_WSE),
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
          extent={{-100,138},{-50,124}},
          textColor={0,0,127},
          textString="uFanSpe"),
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
          extent={{-98,60},{-14,42}},
          textColor={0,0,127},
          textString="uMaxTowSpeSet"),
        Text(
          extent={{-96,-22},{-12,-40}},
          textColor={0,0,127},
          textString="uConWatPumSpe"),
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
          extent={{48,120},{100,104}},
          textColor={255,0,255},
          textString="yLeaCel"),
        Text(
          extent={{-96,-64},{-58,-78}},
          textColor={255,0,255},
          textString="uEnaPla")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-260},{100,260}})),
Documentation(info="<html>
<p>
Block that controls cooling tower cells enabling status <code>yTowSta</code>,
the supply isolation valve positions <code>yIsoVal</code> of each cell and the
cell fan operating speed <code>ySpeSet</code>.
This is implemented according to ASHRAE RP-1711 Advanced Sequences of Operation for
HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft on March 23, 2020), section 5.2.12.
The section specifies sequences to control cooling tower.
It includes three subsequences:
</p>
<ul>
<li>
Sequence of controlling tower fan speed, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.Controller</a>
for a description.
</li>
<li>
Sequence of cooling tower staging, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.Staging.Controller</a>
for a description.
Note that the sequence assumes that the cells are enabled in order as it is labelled, meaning
that it enabled the cells as cell 1, 2, 3, etc.
</li>
<li>
Sequence of tower make-up water valve control, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.WaterLevel\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.WaterLevel</a>
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
