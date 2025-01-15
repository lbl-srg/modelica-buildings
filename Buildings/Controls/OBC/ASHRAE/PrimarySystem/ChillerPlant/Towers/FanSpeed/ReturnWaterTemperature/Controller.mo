within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature;
block Controller
  "Cooling tower speed control to maintain condenser water return temperature at setpoint"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Boolean have_WSE=true "Flag to indicate if the plant has waterside economizer";
  parameter Boolean closeCoupledPlant=true "Flag to indicate if the plant is close coupled";
  parameter Real desCap(
     final unit="W",
     final quantity="HeatFlowRate")= 1e6 "Plant design capacity";
  parameter Real fanSpeMin=0.1 "Minimum tower fan speed";
  parameter Real LIFT_min[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("TemperatureDifference",nChi))={12,12} "Minimum LIFT of each chiller"
      annotation (Dialog(tab="Setpoint"));
  parameter Real TConWatSup_nominal[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("ThermodynamicTemperature",nChi),
    displayUnit=fill("degC",nChi))={293.15,293.15}
    "Design condenser water supply temperature (condenser entering) of each chiller"
    annotation (Dialog(tab="Setpoint"));
  parameter Real TConWatRet_nominal[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("ThermodynamicTemperature",nChi),
    displayUnit=fill("degC",nChi))={303.15, 303.15}
    "Design condenser water return temperature (condenser leaving) of each chiller"
    annotation (Dialog(tab="Setpoint"));
  parameter Real TChiWatSupMin[nChi](
    final unit=fill("K",nChi),
    final quantity=fill("ThermodynamicTemperature",nChi),
    displayUnit=fill("degC",nChi)) = {278.15, 278.15}
    "Lowest chilled water supply temperature of each chiller"
    annotation (Dialog(tab="Setpoint"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController couPlaCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Coupled plant", group="Controller", enable=closeCoupledPlant));
  parameter Real kCouPla=1 "Gain of controller"
    annotation (Dialog(tab="Coupled plant", group="Controller", enable=closeCoupledPlant));
  parameter Real TiCouPla(
    final quantity="Time",
    final unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Coupled plant",
                       group="Controller",
                       enable=closeCoupledPlant and (couPlaCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                     couPlaCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdCouPla(
    final quantity="Time",
    final unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Coupled plant", group="Controller",
                       enable=closeCoupledPlant and (couPlaCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                     couPlaCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real yCouPlaMax=1 "Upper limit of output"
    annotation (Dialog(tab="Coupled plant", group="Controller", enable=closeCoupledPlant));
  parameter Real yCouPlaMin=0 "Lower limit of output"
    annotation (Dialog(tab="Coupled plant", group="Controller", enable=closeCoupledPlant));

  parameter Real samplePeriod=30
    "Period of sampling condenser water supply and return temperature difference"
    annotation (Dialog(tab="Less coupled plant",
                       group="Return water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController supWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Less coupled plant",
                       group="Supply water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Real kSupCon=1 "Gain of controller"
    annotation (Dialog(tab="Less coupled plant",
                       group="Supply water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Real TiSupCon(
    final quantity="Time",
    final unit="s")=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Less coupled plant",
                       group="Supply water temperature controller",
                       enable=not closeCoupledPlant and (supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
                                                         supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdSupCon(
    final quantity="Time",
    final unit="s")=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Less coupled plant",
                       group="Supply water temperature controller",
                       enable=not closeCoupledPlant and (supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
                                                         supWatCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real ySupConMax=1 "Upper limit of output"
    annotation (Dialog(tab="Less coupled plant",
                       group="Supply water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Real ySupConMin=0 "Lower limit of output"
    annotation (Dialog(tab="Less coupled plant",
                       group="Supply water temperature controller",
                       enable=not closeCoupledPlant));

  parameter Real speChe=0.01 "Lower threshold value to check fan or pump speed"
    annotation (Dialog(tab="Advanced"));
  parameter Real cheMinFanSpe(
    final quantity="Time",
    final unit="s")=300
    "Threshold time for checking duration when tower fan equals to the minimum tower fan speed"
    annotation (Dialog(tab="Advanced", group="Enable tower"));
  parameter Real cheMaxTowSpe(
    final quantity="Time",
    final unit="s")=300
    "Threshold time for checking duration when any enabled chiller maximum cooling speed equals to the minimum tower fan speed"
    annotation (Dialog(tab="Advanced", group="Enable tower"));
  parameter Real cheTowOff(
    final quantity="Time",
    final unit="s")=60
    "Threshold time for checking duration when there is no enabled tower fan"
    annotation (Dialog(tab="Advanced", group="Enable tower"));
  parameter Real iniPlaTim(
    final quantity="Time",
    final unit="s")=600
    "Time to hold return temperature to initial setpoint after plant being enabled"
    annotation (Dialog(tab="Advanced",
                       group="Setpoint: Plant startup"));
  parameter Real ramTim(
    final quantity="Time",
    final unit="s")=180
    "Time to ramp return water temperature from initial value to setpoint"
    annotation (Dialog(tab="Advanced",
                       group="Setpoint: Plant startup"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowSpeWSE(
     final min=0,
     final max=1,
     final unit="1") if have_WSE
    "Cooling tower speed when the waterside economizer is enabled"
    annotation (Placement(transformation(extent={{-200,220},{-160,260}}),
      iconTransformation(extent={{-240,160},{-200,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-200,190},{-160,230}}),
      iconTransformation(extent={{-240,130},{-200,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWse if have_WSE
    "Waterside economizer status: true=ON"
    annotation (Placement(transformation(extent={{-200,150},{-160,190}}),
      iconTransformation(extent={{-240,100},{-200,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput reqPlaCap(
    final unit="W",
    final quantity="HeatFlowRate") "Current required plant capacity"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
      iconTransformation(extent={{-240,70},{-200,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    final min=fill(0, nChi),
    final max=fill(1, nChi),
    final unit=fill("1", nChi))
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
      iconTransformation(extent={{-240,40},{-200,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanSpe(
    final min=0,
    final max=1,
    final unit="1") "Measured speed of current enabled tower fans"
    annotation (Placement(transformation(extent={{-200,-10},{-160,30}}),
      iconTransformation(extent={{-240,10},{-200,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTow[nTowCel]
    "Cooling tower operating status: true=running tower cell"
    annotation (Placement(transformation(extent={{-200,-50},{-160,-10}}),
      iconTransformation(extent={{-240,-20},{-200,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") "Chilled water supply setpoint temperature"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-240,-80},{-200,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
      iconTransformation(extent={{-240,-110},{-200,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") "Condenser water return temperature (condenser leaving)"
    annotation (Placement(transformation(extent={{-200,-180},{-160,-140}}),
      iconTransformation(extent={{-240,-140},{-200,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    final min=fill(0, nConWatPum),
    final max=fill(1, nConWatPum),
    final unit=fill("1", nConWatPum)) "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-200,-220},{-160,-180}}),
      iconTransformation(extent={{-240,-170},{-200,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") if not closeCoupledPlant
    "Condenser water supply temperature (condenser entering)"
    annotation (Placement(transformation(extent={{-200,-300},{-160,-260}}),
      iconTransformation(extent={{-240,-200},{-200,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySpeSet(
    final min=0,
    final max=1,
    final unit="1") "Fan speed setpoint of each cooling tower cell"
    annotation (Placement(transformation(extent={{160,190},{200,230}}),
      iconTransformation(extent={{200,-20},{240,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConWatSupSet(
    final quantity="ThermodynamicTemperature",
    displayUnit="degC",
    final unit="K") if not closeCoupledPlant
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{160,-232},{200,-192}}),
      iconTransformation(extent={{200,-210},{240,-170}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Setpoint conWatRetSet(
    final nChi=nChi,
    final LIFT_min=LIFT_min,
    final iniPlaTim=iniPlaTim,
    final ramTim=ramTim,
    final TConWatRet_nominal=TConWatRet_nominal,
    final TChiWatSupMin=TChiWatSupMin) "Return temperature setpoint"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Enable enaTow(
    final nChi=nChi,
    final nTowCel=nTowCel,
    final fanSpeChe=speChe,
    final fanSpeMin=fanSpeMin,
    final cheMinFanSpe=cheMinFanSpe,
    final cheMaxTowSpe=cheMaxTowSpe,
    final cheTowOff=cheTowOff) "Enable and disable cooling tower fans"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Coupled
    couTowSpe(
    final nChi=nChi,
    final nConWatPum=nConWatPum,
    final fanSpeMin=fanSpeMin,
    final pumSpeChe=speChe,
    final controllerType=couPlaCon,
    final k=kCouPla,
    final Ti=TiCouPla,
    final Td=TdCouPla,
    final yMax=yCouPlaMax,
    final yMin=yCouPlaMin) if closeCoupledPlant
    "Tower fan speed control when the plant is close coupled"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.LessCoupled
    lesCouTowSpe(
    final nChi=nChi,
    final nConWatPum=nConWatPum,
    final pumSpeChe=speChe,
    final fanSpeMin=fanSpeMin,
    final samplePeriod=samplePeriod,
    final iniPlaTim=iniPlaTim,
    final TConWatSup_nominal=TConWatSup_nominal,
    final TConWatRet_nominal=TConWatRet_nominal,
    final supWatCon=supWatCon,
    final kSupCon=kSupCon,
    final TiSupCon=TiSupCon,
    final TdSupCon=TdSupCon,
    final ySupConMax=ySupConMax,
    final ySupConMin=ySupConMin) if not closeCoupledPlant
    "Tower fan speed control when the plant is not close coupled"
    annotation (Placement(transformation(extent={{40,-230},{60,-210}})));

protected
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChi) "Check if any chiller is enabled"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 if have_WSE
    "Waterside economizer is not enabled"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Any chiller is enabled and waterside economizer is not enabled"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter parLoaRat(
    final k=1/desCap) "Plant partial load ratio"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Reals.Line plrTowMaxSpe
    "Tower maximum speed resetted by partial load ratio"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch the speed when the fan is enabled or disabled "
    annotation (Placement(transformation(extent={{120,10},{140,30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch between when waterside economizer is enabled and disabled"
    annotation (Placement(transformation(extent={{100,200},{120,220}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant lowPlrTowMaxSpe(
    final k=0.7)
    "Lower bound of tower maximum speed"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant hal(
    final k=0.5) "Constant 0.5"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant uppPlrTowMaxSpe(
    final k=1)
    "Upper bound of tower maximum speed"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(
    final k=true) if not have_WSE "True constant"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer2(
    final k=0) if not have_WSE
    "Zero constant"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Buildings.Controls.OBC.CDL.Reals.Hysteresis proOn[nConWatPum](
    final uLow=fill(speChe, nConWatPum),
    final uHigh=fill(2*speChe, nConWatPum))
    "Check if the condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-140,-270},{-120,-250}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nConWatPum]
    "Convert boolean input to integer output"
    annotation (Placement(transformation(extent={{-100,-270},{-80,-250}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nConWatPum) "Sum up integer inputs"
    annotation (Placement(transformation(extent={{-40,-270},{-20,-250}})));

equation
  connect(uWse, not1.u)
    annotation (Line(points={{-180,170},{-122,170}}, color={255,0,255}));
  connect(mulOr.y, and2.u1)
    annotation (Line(points={{-98,210},{-22,210}}, color={255,0,255}));
  connect(not1.y, and2.u2)
    annotation (Line(points={{-98,170},{-90,170},{-90,202},{-22,202}},
      color={255,0,255}));
  connect(reqPlaCap, parLoaRat.u)
    annotation (Line(points={{-180,100},{-122,100}}, color={0,0,127}));
  connect(zer.y, plrTowMaxSpe.x1)
    annotation (Line(points={{-38,140},{-30,140},{-30,108},{-22,108}},
      color={0,0,127}));
  connect(lowPlrTowMaxSpe.y, plrTowMaxSpe.f1)
    annotation (Line(points={{-98,140},{-70,140},{-70,104},{-22,104}},
      color={0,0,127}));
  connect(parLoaRat.y, plrTowMaxSpe.u)
    annotation (Line(points={{-98,100},{-22,100}}, color={0,0,127}));
  connect(hal.y, plrTowMaxSpe.x2)
    annotation (Line(points={{-98,60},{-70,60},{-70,96},{-22,96}},
      color={0,0,127}));
  connect(uppPlrTowMaxSpe.y, plrTowMaxSpe.f2)
    annotation (Line(points={{-38,60},{-30,60},{-30,92},{-22,92}},
      color={0,0,127}));
  connect(uChi, conWatRetSet.uChi)
    annotation (Line(points={{-180,210},{-140,210},{-140,-62},{-42,-62}},
      color={255,0,255}));
  connect(parLoaRat.y, conWatRetSet.uOpeParLoaRat)
    annotation (Line(points={{-98,100},{-80,100},{-80,-67},{-42,-67}},
      color={0,0,127}));
  connect(conWatRetSet.TChiWatSupSet, TChiWatSupSet)
    annotation (Line(points={{-42,-73},{-80,-73},{-80,-80},{-180,-80}},
      color={0,0,127}));
  connect(conWatRetSet.uPla, uPla)
    annotation (Line(points={{-42,-78},{-60,-78},{-60,-120},{-180,-120}},
      color={255,0,255}));
  connect(enaTow.uMaxTowSpeSet, uMaxTowSpeSet)
    annotation (Line(points={{38,29},{-120,29},{-120,40},{-180,40}},
      color={0,0,127}));
  connect(enaTow.uFanSpe,uFanSpe)
    annotation (Line(points={{38,26},{-130,26},{-130,10},{-180,10}},
      color={0,0,127}));
  connect(enaTow.uTow, uTow)
    annotation (Line(points={{38,14},{-110,14},{-110,-30},{-180,-30}},
      color={255,0,255}));
  connect(conWatRetSet.TConWatRetSet, couTowSpe.TConWatRetSet)
    annotation (Line(points={{-18,-70},{0,-70},{0,-120},{38,-120}},
      color={0,0,127}));
  connect(couTowSpe.TConWatRet, TConWatRet)
    annotation (Line(points={{38,-124},{-100,-124},{-100,-160},{-180,-160}},
      color={0,0,127}));
  connect(couTowSpe.uConWatPumSpe, uConWatPumSpe)
    annotation (Line(points={{38,-128},{-80,-128},{-80,-200},{-180,-200}},
      color={0,0,127}));
  connect(uMaxTowSpeSet, couTowSpe.uMaxTowSpeSet)
    annotation (Line(points={{-180,40},{-120,40},{-120,-132},{38,-132}},
      color={0,0,127}));
  connect(plrTowMaxSpe.y, couTowSpe.plrTowMaxSpe)
    annotation (Line(points={{2,100},{20,100},{20,-140},{38,-140}},
      color={0,0,127}));
  connect(conWatRetSet.TConWatRetSet, lesCouTowSpe.TConWatRetSet)
    annotation (Line(points={{-18,-70},{0,-70},{0,-210},{38,-210}},
      color={0,0,127}));
  connect(TConWatRet, lesCouTowSpe.TConWatRet)
    annotation (Line(points={{-180,-160},{-100,-160},{-100,-212},{38,-212}},
      color={0,0,127}));
  connect(uConWatPumSpe, lesCouTowSpe.uConWatPumSpe)
    annotation (Line(points={{-180,-200},{-80,-200},{-80,-218},{38,-218}},
      color={0,0,127}));
  connect(lesCouTowSpe.TConWatSup, TConWatSup)
    annotation (Line(points={{38,-222},{0,-222},{0,-280},{-180,-280}},
      color={0,0,127}));
  connect(uMaxTowSpeSet, lesCouTowSpe.uMaxTowSpeSet)
    annotation (Line(points={{-180,40},{-120,40},{-120,-225},{38,-225}},
      color={0,0,127}));
  connect(plrTowMaxSpe.y, lesCouTowSpe.plrTowMaxSpe)
    annotation (Line(points={{2,100},{20,100},{20,-230},{38,-230}},
      color={0,0,127}));
  connect(enaTow.yTow, swi.u2)
    annotation (Line(points={{62,20},{118,20}}, color={255,0,255}));
  connect(couTowSpe.ySpeSet, swi.u1)
    annotation (Line(points={{62,-130},{100,-130},{100,28},{118,28}},
      color={0,0,127}));
  connect(lesCouTowSpe.ySpeSet, swi.u1)
    annotation (Line(points={{62,-220},{100,-220},{100,28},{118,28}},
      color={0,0,127}));
  connect(zer1.y, swi.u3)
    annotation (Line(points={{62,-20},{80,-20},{80,12},{118,12}},
      color={0,0,127}));
  connect(tru.y, and2.u2)
    annotation (Line(points={{-58,170},{-40,170},{-40,202},{-22,202}},
      color={255,0,255}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{2,210},{98,210}}, color={255,0,255}));
  connect(swi.y, swi1.u1)
    annotation (Line(points={{142,20},{150,20},{150,190},{60,190},{60,218},
      {98,218}}, color={0,0,127}));
  connect(uTowSpeWSE, swi1.u3)
    annotation (Line(points={{-180,240},{80,240},{80,202},{98,202}},
      color={0,0,127}));
  connect(zer2.y, swi1.u3)
    annotation (Line(points={{62,170},{80,170},{80,202},{98,202}},
      color={0,0,127}));
  connect(swi1.y,ySpeSet)
    annotation (Line(points={{122,210},{180,210}}, color={0,0,127}));
  connect(uChi, mulOr.u)
    annotation (Line(points={{-180,210},{-122,210}}, color={255,0,255}));
  connect(uConWatPumSpe, proOn.u)
    annotation (Line(points={{-180,-200},{-150,-200},{-150,-260},{-142,-260}},
      color={0,0,127}));
  connect(proOn.y, booToInt.u)
    annotation (Line(points={{-118,-260},{-102,-260}}, color={255,0,255}));
  connect(mulSumInt.y, enaTow.uConWatPumNum)
    annotation (Line(points={{-18,-260},{10,-260},{10,11},{38,11}},
      color={255,127,0}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-78,-260},{-42,-260}},
      color={255,127,0}));
  connect(conWatRetSet.TConWatRetSet, enaTow.TTowSet)
    annotation (Line(points={{-18,-70},{0,-70},{0,22},{38,22}}, color={0,0,127}));
  connect(TConWatRet, enaTow.TTow) annotation (Line(points={{-180,-160},{-100,
          -160},{-100,18},{38,18}}, color={0,0,127}));
  connect(uChi, couTowSpe.uChi)
    annotation (Line(points={{-180,210},{-140,210},{-140,-136},{38,-136}},
      color={255,0,255}));
  connect(uChi, lesCouTowSpe.uChi)
    annotation (Line(points={{-180,210},{-140,210},{-140,-227},{38,-227}},
      color={255,0,255}));
  connect(uPla, lesCouTowSpe.uPla)
    annotation (Line(points={{-180,-120},{-60,-120},{-60,-215},{38,-215}},
      color={255,0,255}));
  connect(lesCouTowSpe.TConWatSupSet, TConWatSupSet)
    annotation (Line(points={{62,-212},{180,-212}}, color={0,0,127}));

annotation (
  defaultComponentName="towFanSpe",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},
            {200,200}}), graphics={
        Rectangle(
        extent={{-200,-200},{200,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-200,280},{200,200}},
          textColor={0,0,255},
          textString="%name"),
        Polygon(
          points={{-40,160},{40,160},{0,20},{-40,160}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,20},{80,-20}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,-20},{-40,-160},{60,-160},{0,-20}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{120,-104},{140,-104},{150,-120},{140,-136},{120,-136},{110,-120},
              {120,-104}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{128,-136},{132,-160}},
          lineColor={200,200,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid),
        Line(points={{100,-160}}, color={28,108,200}),
        Rectangle(
          extent={{92,-160},{170,-170}},
          lineColor={28,108,200},
          fillColor={240,240,240},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{114,-110},{144,-128}},
          textColor={28,108,200},
          textString="CWRT"),
        Text(
          extent={{-200,160},{-158,142}},
          textColor={255,0,255},
          textString="uChi"),
        Text(
          extent={{-196,188},{-118,172}},
          textColor={0,0,127},
          textString="uTowSpeWSE",
          visible=have_WSE),
        Text(
          extent={{-200,130},{-154,114}},
          textColor={255,0,255},
          textString="uWse",
          visible=have_WSE),
        Text(
          extent={{-198,12},{-160,-6}},
          textColor={255,0,255},
          textString="uTow"),
        Text(
          extent={{-200,-80},{-160,-98}},
          textColor={255,0,255},
          textString="uPla"),
        Text(
          extent={{-200,100},{-126,82}},
          textColor={0,0,127},
          textString="reqPlaCap"),
        Text(
          extent={{-196,72},{-104,54}},
          textColor={0,0,127},
          textString="uMaxTowSpeSet"),
        Text(
          extent={{-200,40},{-134,22}},
          textColor={0,0,127},
          textString="uFanSpe"),
        Text(
          extent={{-198,-50},{-118,-68}},
          textColor={0,0,127},
          textString="TChiWatSupSet"),
        Text(
          extent={{-200,-112},{-114,-128}},
          textColor={0,0,127},
          textString="TConWatRet"),
        Text(
          extent={{-196,-142},{-94,-158}},
          textColor={0,0,127},
          textString="uConWatPumSpe"),
        Text(
          extent={{-198,-170},{-118,-188}},
          textColor={0,0,127},
          textString="TConWatSup",
          visible=not closeCoupledPlant),
        Text(
          extent={{122,12},{200,-6}},
          textColor={0,0,127},
          textString="ySpeSet"),
        Text(
          extent={{114,-178},{194,-196}},
          textColor={0,0,127},
          textString="TConWatSupSet",
          visible=not closeCoupledPlant)}),
    Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-300},{160,280}}), graphics={
          Text(
          extent={{-148,280},{-78,262}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="When there is no WSE:"),
          Text(
          extent={{-148,264},{-24,258}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="- if no chiller is enabled, then tower fan speed should be zero;"),
          Text(
          extent={{-148,258},{-14,248}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="- if any chiller is enabled, then control fan speed with sequence here;"),
          Text(
          extent={{6,278},{70,266}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="When there is WSE:"),
          Text(
          extent={{6,264},{150,256}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="- if WSE is not enabled, then control fan speed with sequence here;"),
          Text(
          extent={{6,256},{150,248}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          textColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="- if WSE is enabled, then fan speed will be controlled by uTowSpeWSE;")}),
Documentation(info="<html>
<p>
Block that outputs cooling tower fan speed <code>ySpeSet</code> for maintaining
condenser water return temperature at setpoint. This is implemented
according to ASHRAE Guideline36-2021, section 5.20.12.2,
item a. It includes four subsequences:
</p>
<ul>
<li>
Reset the tower maximum speed that reset based on plant partial load ratio
linearly from 100% at 50% operative part load ratio down to 70% at 0%
load ratio.
</li>
<li>
Sequence of enabling and disabling tower fans, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Enable\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Enable</a>
for a description.
</li>
<li>
Sequence of specifying condenser water return temperature setpoint, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Setpoint\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Setpoint</a>
for a description.
</li>
<li>
Sequence of controlling tower fan for close coupled plants, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Coupled\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.Coupled</a>
for a description.
</li>
<li>
Sequence of controlling tower fan for less coupled plants, see
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.LessCoupled\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.ReturnWaterTemperature.Subsequences.LessCoupled</a>
for a description.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
August 9, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
