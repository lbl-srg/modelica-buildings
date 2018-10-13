within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer;
block Status "Water side economizer enable/disable status"

  parameter Modelica.SIunits.Time minDisableTime=20*60
  "Post disable enable delay";

  parameter Modelica.SIunits.TemperatureDifference TOffset=2
  "Additional temperature offset";

  parameter Modelica.SIunits.TemperatureDifference heaExcAppDes=2
  "Design heat exchanger approach";

  parameter Modelica.SIunits.TemperatureDifference cooTowAppDes=2
  "Design cooling tower approach";

  parameter Modelica.SIunits.Temperature TOutWetDes=288.15
  "Design outdoor air wet bulb temperature";

  parameter Real VHeaExcDes_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s")=0.1
  "Desing heat exchanger water flow rate";

  CDL.Interfaces.RealInput TOutWet "Outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-200,120},{-160,160}})));

  PredictedOutletTemperature predictedOutletTemperature(
    heaExcAppDes=heaExcAppDes,
    cooTowAppDes=cooTowAppDes,
    TOutWetDes=TOutWetDes,
    VHeaExcDes_flow=VHeaExcDes_flow)
    annotation (Placement(transformation(extent={{-20,60},{12,96}})));
  Tuning tuning
    annotation (Placement(transformation(extent={{-80,-40},{-44,0}})));
  CDL.Interfaces.BooleanInput uEcoSta
    "Water side economizer enable disable status"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}})));
  CDL.Interfaces.RealInput uTowFanSpe "Water side economizer tower fan speed"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}})));
  CDL.Interfaces.RealInput VChiWat_flow(final quantity="VolumeFlowRate", final
      unit="m3/s")
    "Measured chilled water flow rate"
    annotation (Placement(transformation(extent={{-200,-20},{-160,20}}),
    iconTransformation(extent={{-200,20},{-160,60}})));
  CDL.Interfaces.RealInput TChiWatRet
    "Chiller water return temperature upstream of the water side economizer"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}})));
  CDL.Continuous.Sources.Constant addTOffset(k=TOffset)
    "Additional temperature offset"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  CDL.Continuous.Greater gre
    annotation (Placement(transformation(extent={{80,80},{100,100}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{120,20},{140,40}})));
  CDL.Logical.TrueDelay truDel(delayTime=minDisableTime)
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Interfaces.BooleanOutput yEcoSta
    "Water side economizer enable disable status"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
equation
  connect(tuning.yTunPar, predictedOutletTemperature.uTunPar) annotation (Line(
        points={{-43,-18},{-40,-18},{-40,64},{-22,64}},color={0,0,127}));
  connect(uEcoSta, tuning.uEcoSta) annotation (Line(points={{-180,60},{-100,60},
          {-100,-18},{-82,-18}}, color={255,0,255}));
  connect(uTowFanSpe, tuning.uTowFanSpe) annotation (Line(points={{-180,-60},{
          -100,-60},{-100,-33},{-82,-33}},
                                      color={0,0,127}));
  connect(TOutWet, predictedOutletTemperature.TOutWet) annotation (Line(points={{-180,
          140},{-92,140},{-92,92},{-22,92}},      color={0,0,127}));
  connect(VChiWat_flow, predictedOutletTemperature.VChiWat_flow) annotation (
      Line(points={{-180,0},{-94,0},{-94,82},{-22,82}},color={0,0,127}));
  connect(predictedOutletTemperature.TEcoOut_pred, add2.u1) annotation (Line(
        points={{14,78},{28,78},{28,56},{38,56}}, color={0,0,127}));
  connect(addTOffset.y, add2.u2) annotation (Line(points={{21,30},{28,30},{28,44},
          {38,44}}, color={0,0,127}));
  connect(add2.y, gre.u2) annotation (Line(points={{61,50},{70,50},{70,82},{78,82}},
        color={0,0,127}));
  connect(TChiWatRet, gre.u1) annotation (Line(points={{-180,100},{-64,100},{-64,
          126},{64,126},{64,90},{78,90}}, color={0,0,127}));
  connect(gre.y, and2.u1) annotation (Line(points={{101,90},{110,90},{110,30},{118,
          30}}, color={255,0,255}));
  connect(uEcoSta, truDel.u) annotation (Line(points={{-180,60},{-62,60},{-62,
          10},{58,10}}, color={255,0,255}));
  connect(and2.u2, truDel.y) annotation (Line(points={{118,22},{100,22},{100,10},
          {81,10}}, color={255,0,255}));
  connect(and2.y, yEcoSta) annotation (Line(points={{141,30},{152,30},{152,0},{
          170,0}}, color={255,0,255}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-160,-180},{160,180}})), Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-160,-180},{160,180}})));
end Status;
