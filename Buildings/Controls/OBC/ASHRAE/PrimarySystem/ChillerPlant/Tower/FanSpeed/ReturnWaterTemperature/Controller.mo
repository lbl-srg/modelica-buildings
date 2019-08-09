within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature;
block Controller
  "Cooling tower speed control based on condenser water return temperature control"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Boolean haveWSE=true "Flag to indicate if the plant has waterside economizer";
  parameter Boolean closeCoupledPlant=true "Flag to indicate if the plant is close coupled";
  parameter Modelica.SIunits.HeatFlowRate desCap = 1e6 "Plant design capacity";
  parameter Real minTowSpe=0.1 "Minimum tower fan speed";
  parameter Real LIFT_min[nChi]={12,12} "Minimum LIFT of each chiller"
    annotation (Dialog(tab="Return temperature control"));
  parameter Modelica.SIunits.Temperature TConWatRet_nominal[nChi]={303.15, 303.15}
    "Condenser water return temperature (condenser leaving) of each chiller"
    annotation (Dialog(tab="Return temperature control"));
  parameter Modelica.SIunits.Temperature TChiWatSupMin[nChi] = {278.15, 278.15}
    "Lowest chilled water supply temperature oc each chiller"
    annotation (Dialog(tab="Return temperature control"));

  parameter Modelica.SIunits.Time iniPlaTim=600
    "Time to hold return temperature to initial setpoint after plant being enabled"
    annotation (Dialog(tab="Return temperature control",
                       group="Plant startup"));
  parameter Modelica.SIunits.Time ramTim=180
    "Time to ramp return water temperature from initial value to setpoint"
    annotation (Dialog(tab="Return temperature control",
                       group="Plant startup"));
  parameter Modelica.SIunits.Temperature TPlaConWatRet_nominal=303.15
    "Design plant condenser water return temperature"
    annotation (Dialog(tab="Return temperature control",
                       group="Plant startup"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController couPlaCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Coupled plant", group="Controller", enable=closeCoupledPlant));
  parameter Real kCouPla=1 "Gain of controller"
    annotation (Dialog(tab="Coupled plant", group="Controller", enable=closeCoupledPlant));
  parameter Modelica.SIunits.Time TiCouPla=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Coupled plant", group="Controller", enable=closeCoupledPlant));
  parameter Real yCouPlaMax=1 "Upper limit of output"
    annotation (Dialog(tab="Coupled plant", group="Controller", enable=closeCoupledPlant));
  parameter Real yCouPlaMin=0 "Lower limit of output"
    annotation (Dialog(tab="Coupled plant", group="Controller", enable=closeCoupledPlant));
  parameter Modelica.SIunits.Time TdCouPla=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Coupled plant", group="Controller", enable=closeCoupledPlant));
  parameter Modelica.SIunits.TemperatureDifference desTemDif=8
    "Design condenser water temperature difference"
    annotation (Dialog(tab="Less coupled plant", enable=not closeCoupledPlant));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController retWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Less coupled plant",
                       group="Return water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Real kRetCon=1 "Gain of controller"
    annotation (Dialog(tab="Less coupled plant",
                       group="Return water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Modelica.SIunits.Time TiRetCon=0.5
    "Time constant of integrator block"
    annotation (Dialog(tab="Less coupled plant",
                       group="Return water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Modelica.SIunits.Time TdRetCon=0.1
    "Time constant of derivative block"
    annotation (Dialog(tab="Less coupled plant",
                       group="Return water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Real yRetConMax=1 "Upper limit of output"
    annotation (Dialog(tab="Less coupled plant",
                       group="Return water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Real yRetConMin=0 "Lower limit of output"
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
  parameter Modelica.SIunits.Time TiSupCon=0.5 "Time constant of integrator block"
    annotation (Dialog(tab="Less coupled plant",
                       group="Supply water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Modelica.SIunits.Time TdSupCon=0.1 "Time constant of derivative block"
    annotation (Dialog(tab="Less coupled plant",
                       group="Supply water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Real ySupConMax=1 "Upper limit of output"
    annotation (Dialog(tab="Less coupled plant",
                       group="Supply water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Real ySupConMin=0 "Lower limit of output"
    annotation (Dialog(tab="Less coupled plant",
                       group="Supply water temperature controller",
                       enable=not closeCoupledPlant));
  parameter Real speChe=0.005 "Lower threshold value to check fan or pump speed"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowSpeWSE(
     final min=0,
     final max=1,
     final unit="1") if haveWSE
    "Cooling tower speed when the waterside economizer is enabled"
    annotation (Placement(transformation(extent={{-200,220},{-160,260}}),
      iconTransformation(extent={{-240,160},{-200,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-200,190},{-160,230}}),
      iconTransformation(extent={{-240,130},{-200,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if haveWSE
    "Waterside economizer status: true=ON"
    annotation (Placement(transformation(extent={{-200,150},{-160,190}}),
      iconTransformation(extent={{-240,100},{-200,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput reqPlaCap(
    final unit="W",
    final quantity="Power") "Current required plant capacity"
    annotation (Placement(transformation(extent={{-200,90},{-160,130}}),
      iconTransformation(extent={{-240,70},{-200,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-200,20},{-160,60}}),
      iconTransformation(extent={{-240,40},{-200,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowSpe(
    final min=0,
    final max=1,
    final unit="1") "Measured speed of current enabled tower fans"
    annotation (Placement(transformation(extent={{-200,-10},{-160,30}}),
      iconTransformation(extent={{-240,10},{-200,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Cooling tower operating status: true=running tower cell"
    annotation (Placement(transformation(extent={{-200,-70},{-160,-30}}),
      iconTransformation(extent={{-240,-20},{-200,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uConWatPumNum(
    final min=0,
    final max=nConWatPum) "Number of enabling condenser water pumps"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-240,-50},{-200,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final quantity="ThermodynamicTemperature",
    final unit="K") "Chilled water supply setpoint temperature"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
      iconTransformation(extent={{-240,-80},{-200,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-200,-180},{-160,-140}}),
      iconTransformation(extent={{-240,-110},{-200,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final quantity="ThermodynamicTemperature",
    final unit="K") "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-200,-220},{-160,-180}}),
      iconTransformation(extent={{-240,-140},{-200,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    each final min=0,
    each final max=1,
    each final unit="1") "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-200,-260},{-160,-220}}),
      iconTransformation(extent={{-240,-170},{-200,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup(
    final quantity="ThermodynamicTemperature",
    final unit="K") if not closeCoupledPlant
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-200,-300},{-160,-260}}),
      iconTransformation(extent={{-240,-200},{-200,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowSpe(
    final min=0,
    final max=1,
    final unit="1") "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{160,190},{200,230}}),
      iconTransformation(extent={{200,60},{240,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTow
    "Tower fan status: true=enable fans; false=disable all fans"
    annotation (Placement(transformation(extent={{160,0},{200,40}}),
      iconTransformation(extent={{200,-100},{240,-60}})));

protected
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nu=nChi) "Multiple logical or"
    annotation (Placement(transformation(extent={{-120,200},{-100,220}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 if haveWSE "Logical not"
    annotation (Placement(transformation(extent={{-120,160},{-100,180}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{-20,200},{0,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain parLoaRat(
    final k=1/desCap) "Plant partial load ratio"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Line plrTowMaxSpe "Tower maximum speed"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences.Setpoint conWatRetSet(
    final nChi=nChi,
    final LIFT_min=LIFT_min,
    final iniPlaTim=iniPlaTim,
    final ramTim=ramTim,
    final TConWatRet_nominal=TConWatRet_nominal,
    final TChiWatSupMin=TChiWatSupMin,
    final TPlaConWatRet_nominal=TPlaConWatRet_nominal)    "Return temperature control"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences.Enable enaTow(
    final nChi=nChi,
    final nTowCel=nTowCel,
    final fanSpeChe=speChe,
    final minTowSpe=minTowSpe) "Enable cooling tower"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences.CoupledSpeed couTowSpe(
    final nChi=nChi,
    final nConWatPum=nConWatPum,
    final minTowSpe=minTowSpe,
    final pumSpeChe=speChe,
    final controllerType=couPlaCon,
    final k=kCouPla,
    final Ti=TiCouPla,
    final Td=TdCouPla,
    final yMax=yCouPlaMax,
    final yMin=yCouPlaMin) if closeCoupledPlant
    "Tower fan speed control when the plant is closed coupled"
    annotation (Placement(transformation(extent={{40,-140},{60,-120}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences.LessCoupledSpeed lesCouTowSpe(
    final nChi=nChi,
    final nConWatPum=nConWatPum,
    final desTemDif=desTemDif,
    final pumSpeChe=speChe,
    final minTowSpe=minTowSpe,
    final retWatCon=retWatCon,
    final kRetCon=kRetCon,
    final TiRetCon=TiRetCon,
    final TdRetCon=TdRetCon,
    final yRetConMax=yRetConMax,
    final yRetConMin=yRetConMin,
    final supWatCon=supWatCon,
    final kSupCon=kSupCon,
    final TiSupCon=TiSupCon,
    final TdSupCon=TdSupCon,
    final ySupConMax=ySupConMax,
    final ySupConMin=ySupConMin) if not closeCoupledPlant
    annotation (Placement(transformation(extent={{40,-220},{60,-200}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    annotation (Placement(transformation(extent={{100,200},{120,220}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowPlrTowMaxSpe(
    final k=0.7)
    "Lower bound of tower maximum speed"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant hal(
    final k=0.5) "Constant 0.5"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant uppPlrTowMaxSpe(
    final k=1)
    "Upper bound of tower maximum speed"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(
    final k=true) if not haveWSE "True constant"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer2(
    final k=0) if not haveWSE
    "Zero constant"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=closeCoupledPlant)
    "If the plant is close coupled"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Logical.Switch TTow "Tower temperature"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Buildings.Controls.OBC.CDL.Logical.Switch TTowSet "Tower temperature setpoint"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dumTem(
    final k=293.15) if closeCoupledPlant
    "Dummy temperature for giving input to switch when the plant is closed coupled"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

equation
  connect(uWSE, not1.u)
    annotation (Line(points={{-180,170},{-122,170}}, color={255,0,255}));
  connect(mulOr.y, and2.u1)
    annotation (Line(points={{-98,210},{-22,210}},    color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{-98,170},{-90,170},{-90,
          202},{-22,202}}, color={255,0,255}));
  connect(reqPlaCap, parLoaRat.u)
    annotation (Line(points={{-180,110},{-122,110}}, color={0,0,127}));
  connect(zer.y, plrTowMaxSpe.x1) annotation (Line(points={{-38,140},{-30,140},
          {-30,118},{-22,118}},color={0,0,127}));
  connect(lowPlrTowMaxSpe.y, plrTowMaxSpe.f1) annotation (Line(points={{-98,140},
          {-70,140},{-70,114},{-22,114}}, color={0,0,127}));
  connect(parLoaRat.y, plrTowMaxSpe.u)
    annotation (Line(points={{-98,110},{-22,110}}, color={0,0,127}));
  connect(hal.y, plrTowMaxSpe.x2) annotation (Line(points={{-98,80},{-70,80},{
          -70,106},{-22,106}},
                           color={0,0,127}));
  connect(uppPlrTowMaxSpe.y, plrTowMaxSpe.f2) annotation (Line(points={{-38,80},
          {-30,80},{-30,102},{-22,102}}, color={0,0,127}));
  connect(uChi, conWatRetSet.uChi) annotation (Line(points={{-180,210},{-140,210},
          {-140,-62},{38,-62}}, color={255,0,255}));
  connect(parLoaRat.y, conWatRetSet.plaParLoaRat) annotation (Line(points={{-98,110},
          {-92,110},{-92,-68},{38,-68}},      color={0,0,127}));
  connect(conWatRetSet.TChiWatSupSet, TChiWatSupSet) annotation (Line(points={{38,-72},
          {-108,-72},{-108,-120},{-180,-120}},    color={0,0,127}));
  connect(conWatRetSet.uPla, uPla) annotation (Line(points={{38,-78},{-100,-78},
          {-100,-160},{-180,-160}}, color={255,0,255}));
  connect(enaTow.uMaxTowSpeSet, uMaxTowSpeSet) annotation (Line(points={{38,30},
          {-136,30},{-136,40},{-180,40}}, color={0,0,127}));
  connect(enaTow.uTowSpe, uTowSpe) annotation (Line(points={{38,26},{-132,26},{-132,
          10},{-180,10}}, color={0,0,127}));
  connect(enaTow.uTowSta, uTowSta) annotation (Line(points={{38,14},{-126,14},{-126,
          -50},{-180,-50}}, color={255,0,255}));
  connect(enaTow.uConWatPumNum, uConWatPumNum) annotation (Line(points={{38,10},
          {-120,10},{-120,-80},{-180,-80}}, color={255,127,0}));
  connect(conWatRetSet.TConWatRetSet, couTowSpe.TConWatRetSet) annotation (Line(
        points={{62,-70},{80,-70},{80,-100},{26,-100},{26,-122},{38,-122}},
        color={0,0,127}));
  connect(couTowSpe.TConWatRet, TConWatRet) annotation (Line(points={{38,-126},{
          -114,-126},{-114,-200},{-180,-200}}, color={0,0,127}));
  connect(couTowSpe.uConWatPumSpe, uConWatPumSpe) annotation (Line(points={{38,-130},
          {-80,-130},{-80,-240},{-180,-240}}, color={0,0,127}));
  connect(uMaxTowSpeSet, couTowSpe.uMaxTowSpeSet) annotation (Line(points={{-180,40},
          {-136,40},{-136,-134},{38,-134}},     color={0,0,127}));
  connect(plrTowMaxSpe.y, couTowSpe.plrTowMaxSpe) annotation (Line(points={{2,110},
          {20,110},{20,-138},{38,-138}}, color={0,0,127}));
  connect(conWatRetSet.TConWatRetSet, lesCouTowSpe.TConWatRetSet) annotation (
      Line(points={{62,-70},{80,-70},{80,-100},{26,-100},{26,-200},{38,-200}},
        color={0,0,127}));
  connect(TConWatRet, lesCouTowSpe.TConWatRet) annotation (Line(points={{-180,-200},
          {-114,-200},{-114,-204},{38,-204}}, color={0,0,127}));
  connect(uConWatPumSpe, lesCouTowSpe.uConWatPumSpe) annotation (Line(points={{-180,
          -240},{-80,-240},{-80,-208},{38,-208}}, color={0,0,127}));
  connect(lesCouTowSpe.TConWatSup, TConWatSup) annotation (Line(points={{38,-212},
          {-40,-212},{-40,-280},{-180,-280}}, color={0,0,127}));
  connect(uMaxTowSpeSet, lesCouTowSpe.uMaxTowSpeSet) annotation (Line(points={{-180,40},
          {-136,40},{-136,-216},{38,-216}},     color={0,0,127}));
  connect(plrTowMaxSpe.y, lesCouTowSpe.plrTowMaxSpe) annotation (Line(points={{2,110},
          {20,110},{20,-220},{38,-220}},      color={0,0,127}));
  connect(enaTow.yTow, swi.u2) annotation (Line(points={{62,20},{80,20},{80,0},
          {118,0}},color={255,0,255}));
  connect(couTowSpe.yTowSpe, swi.u1) annotation (Line(points={{62,-130},{100,
          -130},{100,8},{118,8}},
                            color={0,0,127}));
  connect(lesCouTowSpe.yTowSpe, swi.u1) annotation (Line(points={{62,-210},{100,
          -210},{100,8},{118,8}}, color={0,0,127}));
  connect(zer1.y, swi.u3) annotation (Line(points={{62,-20},{80,-20},{80,-8},{
          118,-8}},
                color={0,0,127}));
  connect(enaTow.yTow, yTow)
    annotation (Line(points={{62,20},{180,20}}, color={255,0,255}));
  connect(tru.y, and2.u2) annotation (Line(points={{-58,170},{-40,170},{-40,202},
          {-22,202}}, color={255,0,255}));
  connect(and2.y, swi1.u2)
    annotation (Line(points={{2,210},{98,210}}, color={255,0,255}));
  connect(swi.y, swi1.u1) annotation (Line(points={{142,0},{150,0},{150,190},{
          60,190},{60,218},{98,218}},
                                   color={0,0,127}));
  connect(uTowSpeWSE, swi1.u3) annotation (Line(points={{-180,240},{80,240},{80,
          202},{98,202}}, color={0,0,127}));
  connect(zer2.y, swi1.u3) annotation (Line(points={{62,170},{80,170},{80,202},
          {98,202}},color={0,0,127}));
  connect(swi1.y, yTowSpe)
    annotation (Line(points={{122,210},{180,210}}, color={0,0,127}));
  connect(uChi, mulOr.u)
    annotation (Line(points={{-180,210},{-122,210}}, color={255,0,255}));
  connect(con.y, TTowSet.u2) annotation (Line(points={{-58,50},{-22,50}},
                     color={255,0,255}));
  connect(con.y, TTow.u2) annotation (Line(points={{-58,50},{-40,50},{-40,-10},
          {-22,-10}}, color={255,0,255}));
  connect(TConWatRet, TTow.u1) annotation (Line(points={{-180,-200},{-114,-200},
          {-114,-2},{-22,-2}}, color={0,0,127}));
  connect(conWatRetSet.TConWatRetSet, TTowSet.u1) annotation (Line(points={{62,-70},
          {80,-70},{80,-40},{-34,-40},{-34,58},{-22,58}}, color={0,0,127}));
  connect(TConWatSup, TTow.u3) annotation (Line(points={{-180,-280},{-40,-280},{
          -40,-18},{-22,-18}}, color={0,0,127}));
  connect(lesCouTowSpe.TConWatSupSet, TTowSet.u3) annotation (Line(points={{62,-202},
          {80,-202},{80,-160},{-46,-160},{-46,42},{-22,42}}, color={0,0,127}));
  connect(TTowSet.y, enaTow.TTowSet) annotation (Line(points={{2,50},{10,50},{
          10,22},{38,22}},
                        color={0,0,127}));
  connect(TTow.y, enaTow.TTow) annotation (Line(points={{2,-10},{10,-10},{10,18},
          {38,18}}, color={0,0,127}));
  connect(dumTem.y, TTowSet.u3) annotation (Line(points={{-58,-40},{-46,-40},{
          -46,42},{-22,42}},
                         color={0,0,127}));
  connect(dumTem.y, TTow.u3) annotation (Line(points={{-58,-40},{-40,-40},{-40,
          -18},{-22,-18}},
                      color={0,0,127}));

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
          extent={{-240,270},{200,210}},
          lineColor={0,0,255},
          textString="%name")}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-160,-300},{160,280}}), graphics={
          Text(
          extent={{-148,280},{-78,262}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="When there is no WSE:"),
          Text(
          extent={{-148,264},{-32,258}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="- if no chiller enabled, then tower fan speed being zero;"),
          Text(
          extent={{-148,258},{-30,248}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="- if any chiller enabled, then control fan speed with sequence here;"),
          Text(
          extent={{6,278},{70,266}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="When there is WSE:"),
          Text(
          extent={{6,266},{142,256}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="- if no chiller enabled, then contorl tower fan speed with uTowSpeWSE;"),
          Text(
          extent={{6,256},{150,248}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="- if any chiller enabled and WSE not running, then control fan speed with sequence here;"),
          Text(
          extent={{6,248},{150,240}},
          pattern=LinePattern.None,
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="- if any chiller enabled and WSE is running, then control fan speed with uTowSpeWSE;")}));
end Controller;
