within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower;
block Controller "Cooling tower controller"

  parameter Integer nChi=2 "Total number of chillers";
  parameter Integer nSta=3
    "Total number of stages, stage zero should be counted as one stage";
  parameter Integer nTowCel=4 "Total number of cooling tower cells";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Boolean closeCoupledPlant=true
    "Flag to indicate if the plant is close coupled";
  parameter Boolean haveWSE=true
    "Flag to indicate if the plant has waterside economizer";
  parameter Modelica.SIunits.HeatFlowRate desCap=1e6 "Plant design capacity"
    annotation (Dialog(group="Nominal"));
  parameter Real minTowSpe=0.1 "Minimum tower fan speed"
    annotation (Dialog(group="Nominal"));
  parameter Real maxTowSpe=1 "Maximum tower fan speed"
    annotation (Dialog(group="Nominal"));
  parameter Modelica.SIunits.HeatFlowRate minUnLTon[nChi]={1e4,1e4}
    "Minimum cyclining load below which chiller will begin cycling"
    annotation (Dialog(tab="Fan speed", group="WSE enabled"));
  parameter Real minSpe=0.1
    "Allowed minimum value of waterside economizer tower maximum speed"
    annotation (Dialog(tab="Fan speed", group="WSE enabled"));
  parameter Real LIFT_min[nChi]={12,12} "Minimum LIFT of each chiller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Modelica.SIunits.Time iniPlaTim=600
    "Time to hold return temperature to initial setpoint after plant being enabled"
    annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Modelica.SIunits.Time ramTim=180
    "Time to ramp return water temperature from initial value to setpoint"
    annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Modelica.SIunits.Temperature TConWatRet_nominal[nChi]={303.15,303.15}
    "Condenser water return temperature (condenser leaving) of each chiller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Modelica.SIunits.Temperature TChiWatSupMin[nChi]={278.15,278.15}
    "Lowest chilled water supply temperature oc each chiller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Modelica.SIunits.Temperature TPlaConWatRet_nominal=303.15
    "Design plant condenser water return temperature"
    annotation (Dialog(tab="Fan speed", group="Return temperature control"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController couPlaCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of coupled plant controller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=closeCoupledPlant));
  parameter Modelica.SIunits.TemperatureDifference desTemDif=8
    "Design condenser water temperature difference"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=not closeCoupledPlant));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController retWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller of less coupled plant controller"
    annotation (Dialog(tab="Fan speed", group="Return temperature control",
                       enable=not closeCoupledPlant));
  parameter Real speChe=0.005
    "Lower threshold value to check fan or pump speed"
    annotation (Dialog(tab="Fan speed", group="Advanced"));
  parameter Real towCelOnSet[2*nSta]={0,2,2,4,4,4}
    "Number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(tab="Tower staging"));
  parameter Modelica.SIunits.Time chaTowCelIsoTim=300
    "Time to slowly change isolation valve"
    annotation (Dialog(tab="Tower staging", group="Enable_Disable cell isolation valve"));
  parameter Real iniValPos=0
    "Initial valve position, if it needs to turn on tower cell, the value should be 0"
    annotation (Dialog(tab="Tower staging", group="Enable_Disable cell isolation valve"));
  parameter Real endValPos=1
    "Ending valve position, if it needs to turn on tower cell, the value should be 1"
    annotation (Dialog(tab="Tower staging", group="Enable_Disable cell isolation valve"));
  parameter Modelica.SIunits.Length watLevMin
    "Minimum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Makeup water"));
  parameter Modelica.SIunits.Length watLevMax
    "maximum cooling tower water level recommended by manufacturer"
    annotation (Dialog(tab="Makeup water"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput chiLoa[nChi](
    each final unit="W",
    each final quantity="Power") if haveWSE "Current load of each chillerCurrent load of each chiller"
    annotation (Placement(transformation(extent={{-140,200},{-100,240}}),
      iconTransformation(extent={{-140,190},{-100,230}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChi[nChi]
    "Chiller enabling status: true=ON"
    annotation (Placement(transformation(extent={{-140,180},{-100,220}}),
      iconTransformation(extent={{-140,170},{-100,210}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if haveWSE
    "Waterside economizer enabling status: true=ON"
    annotation (Placement(transformation(extent={{-140,160},{-100,200}}),
      iconTransformation(extent={{-140,150},{-100,190}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowSpe(
     final min=0,
     final max=1,
     final unit="1") "Tower fan speed"
    annotation (Placement(transformation(extent={{-140,140},{-100,180}}),
      iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature") if haveWSE
    "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,120},{-100,160}}),
      iconTransformation(extent={{-140,110},{-100,150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,90},{-100,130}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput reqPlaCap(
    final unit="W",
    final quantity="Power") "Current required plant capacity"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
      iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowSta[nTowCel]
    "Cooling tower cell operating status: true=running tower cell"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uConWatPumNum
    "Number of enabled condenser water pumps"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enabling status"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature") "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    each final min=0,
    each final max=1,
    each final unit="1") "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature") if not closeCoupledPlant
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uTowCelPri[nTowCel]
    "Cooling tower cell enabling priority"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaUp
    "Plant stage up status: true=stage-up"
    annotation (Placement(transformation(extent={{-140,-160},{-100,-120}}),
      iconTransformation(extent={{-140,-130},{-100,-90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowStaUp
    "Cooling tower stage-up command"
    annotation (Placement(transformation(extent={{-140,-180},{-100,-140}}),
      iconTransformation(extent={{-140,-150},{-100,-110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uStaDow
    "Plant stage down status: true=stage-down"
    annotation (Placement(transformation(extent={{-140,-200},{-100,-160}}),
      iconTransformation(extent={{-140,-170},{-100,-130}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uTowStaDow
    "Cooling tower stage-down command"
    annotation (Placement(transformation(extent={{-140,-220},{-100,-180}}),
      iconTransformation(extent={{-140,-190},{-100,-150}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uIsoVal[nTowCel](
    each final unit="1",
    each final min=0,
    each final max=1)
    "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{-140,-240},{-100,-200}}),
      iconTransformation(extent={{-140,-210},{-100,-170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput watLev(
    final quantity="Length") "Measured water level"
    annotation (Placement(transformation(extent={{-140,-260},{-100,-220}}),
      iconTransformation(extent={{-140,-230},{-100,-190}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yTowSta[nTowCel]
    "Cooling tower cell enabling status"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,80},{140,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowSpe[nTowCel](
    each final min=0,
    each final max=1,
    each final unit="1") "Fan speed of each cooling tower cell"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yIsoVal[nTowCel](
    each final unit="1",
    each final min=0,
    each final max=1)
    "Cooling tower cells isolation valve position"
    annotation (Placement(transformation(extent={{100,-100},{140,-60}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yMakUp
    "Makeup water valve On-Off status"
    annotation (Placement(transformation(extent={{100,-260},{140,-220}}),
      iconTransformation(extent={{100,-120},{140,-80}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Controller towSta(
    final nTowCel=nTowCel,
    final nSta=nSta,
    final towCelOnSet=towCelOnSet,
    final chaTowCelIsoTim=chaTowCelIsoTim,
    final iniValPos=iniValPos,
    final endValPos=endValPos) "Staging tower cells"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.Controller towFanSpe(
    final nChi=nChi,
    final nTowCel=nTowCel,
    final nConWatPum=nConWatPum,
    final closeCoupledPlant=closeCoupledPlant,
    final haveWSE=haveWSE,
    final desCap=desCap,
    final minTowSpe=minTowSpe,
    final maxTowSpe=maxTowSpe,
    final minUnLTon=minUnLTon,
    final minSpe=minSpe,
    final LIFT_min=LIFT_min,
    final iniPlaTim=iniPlaTim,
    final ramTim=ramTim,
    final TConWatRet_nominal=TConWatRet_nominal,
    final TChiWatSupMin=TChiWatSupMin,
    final TPlaConWatRet_nominal=TPlaConWatRet_nominal,
    final couPlaCon=couPlaCon,
    final desTemDif=desTemDif,
    final retWatCon=retWatCon,
    final speChe=speChe) "Tower fan speed"
    annotation (Placement(transformation(extent={{-20,0},{0,40}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.WaterLevel makUpWat(
    final watLevMin=watLevMin,
    final watLevMax=watLevMax)
    "Make up water control"
    annotation (Placement(transformation(extent={{-20,-250},{0,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi[nTowCel] "Logical switch"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer[nTowCel](
    each final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator reaRep(
    final nout=nTowCel) "Replicate real input"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

equation
  connect(towSta.yTowSta, yTowSta)
    annotation (Line(points={{2,-40},{40,-40},{40,0},{120,0}}, color={255,0,255}));
  connect(towSta.yIsoVal, yIsoVal)
    annotation (Line(points={{2,-49},{40,-49},{40,-80},{120,-80}}, color={0,0,127}));
  connect(towSta.yTowSta, swi.u2)
    annotation (Line(points={{2,-40},{58,-40}}, color={255,0,255}));
  connect(towFanSpe.yTowSpe, reaRep.u)
    annotation (Line(points={{2,20},{18,20}}, color={0,0,127}));
  connect(reaRep.y, swi.u1)
    annotation (Line(points={{42,20},{50,20},{50,-32},{58,-32}}, color={0,0,127}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{2,-100},{50,-100},{50,-48},{58,-48}}, color={0,0,127}));
  connect(swi.y, yTowSpe)
    annotation (Line(points={{82,-40},{120,-40}}, color={0,0,127}));
  connect(towFanSpe.chiLoa, chiLoa)
    annotation (Line(points={{-22,39},{-40,39},{-40,220},{-120,220}}, color={0,0,127}));
  connect(towFanSpe.uChi, uChi)
    annotation (Line(points={{-22,36},{-44,36},{-44,200},{-120,200}}, color={255,0,255}));
  connect(towFanSpe.uWSE, uWSE)
    annotation (Line(points={{-22,33},{-48,33},{-48,180},{-120,180}}, color={255,0,255}));
  connect(towFanSpe.uTowSpe, uTowSpe)
    annotation (Line(points={{-22,30},{-52,30},{-52,160},{-120,160}}, color={0,0,127}));
  connect(towFanSpe.TChiWatSup, TChiWatSup)
    annotation (Line(points={{-22,27},{-56,27},{-56,140},{-120,140}}, color={0,0,127}));
  connect(towFanSpe.TChiWatSupSet, TChiWatSupSet)
    annotation (Line(points={{-22,24},{-60,24},{-60,120},{-120,120}}, color={0,0,127}));
  connect(towFanSpe.reqPlaCap, reqPlaCap)
    annotation (Line(points={{-22,21},{-64,21},{-64,100},{-120,100}}, color={0,0,127}));
  connect(towFanSpe.uMaxTowSpeSet, uMaxTowSpeSet)
    annotation (Line(points={{-22,18},{-68,18},{-68,80},{-120,80}}, color={0,0,127}));
  connect(towFanSpe.uTowSta, uTowSta)
    annotation (Line(points={{-22,15},{-76,15},{-76,40},{-120,40}}, color={255,0,255}));
  connect(towFanSpe.uConWatPumNum, uConWatPumNum)
    annotation (Line(points={{-21,12},{-80,12},{-80,20},{-120,20}}, color={255,127,0}));
  connect(towFanSpe.uPla, uPla)
    annotation (Line(points={{-22,9},{-80,9},{-80,0},{-120,0}},   color={255,0,255}));
  connect(towFanSpe.TConWatRet, TConWatRet)
    annotation (Line(points={{-22,6},{-76,6},{-76,-20},{-120,-20}}, color={0,0,127}));
  connect(towFanSpe.uConWatPumSpe, uConWatPumSpe)
    annotation (Line(points={{-22,3},{-72,3},{-72,-40},{-120,-40}}, color={0,0,127}));
  connect(towFanSpe.TConWatSup, TConWatSup)
    annotation (Line(points={{-22,1},{-68,1},{-68,-60},{-120,-60}}, color={0,0,127}));
  connect(towSta.uChiSta, uChiSta)
    annotation (Line(points={{-22,-31},{-64,-31},{-64,-100},{-120,-100}}, color={255,127,0}));
  connect(uWSE, towSta.uWSE)
    annotation (Line(points={{-120,180},{-48,180},{-48,-33},{-22,-33}}, color={255,0,255}));
  connect(uTowSta, towSta.uTowSta)
    annotation (Line(points={{-120,40},{-76,40},{-76,14},{-60,14},{-60,-35},{
          -22,-35}},
      color={255,0,255}));
  connect(towSta.uTowCelPri, uTowCelPri)
    annotation (Line(points={{-22,-37},{-60,-37},{-60,-120},{-120,-120}}, color={255,127,0}));
  connect(towSta.uStaUp, uStaUp)
    annotation (Line(points={{-22,-40},{-56,-40},{-56,-140},{-120,-140}}, color={255,0,255}));
  connect(towSta.uTowStaUp, uTowStaUp)
    annotation (Line(points={{-22,-43},{-52,-43},{-52,-160},{-120,-160}}, color={255,0,255}));
  connect(towSta.uStaDow, uStaDow)
    annotation (Line(points={{-22,-45},{-48,-45},{-48,-180},{-120,-180}}, color={255,0,255}));
  connect(towSta.uTowStaDow, uTowStaDow)
    annotation (Line(points={{-22,-47},{-44,-47},{-44,-200},{-120,-200}}, color={255,0,255}));
  connect(towSta.uIsoVal, uIsoVal)
    annotation (Line(points={{-22,-49},{-40,-49},{-40,-220},{-120,-220}}, color={0,0,127}));
  connect(makUpWat.watLev, watLev)
    annotation (Line(points={{-22,-240},{-120,-240}}, color={0,0,127}));
  connect(makUpWat.yMakUp, yMakUp)
    annotation (Line(points={{2,-240},{120,-240}}, color={255,0,255}));

annotation (
  defaultComponentName="towCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -200},{100,200}}), graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,248},{100,210}},
          lineColor={0,0,255},
          textString="%name")}),Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-260},{100,260}})));
end Controller;
