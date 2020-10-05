within Buildings.Experimental.NaturalVentilation.Lockouts.SubLockouts;
block DryBulbLockout
  "Locks out natural ventilation if outdoor air dry bulb temperature is below a user-specified threshhold"
  parameter Real TDryBulCut=288.7                    "Outdoor air temperature below which nat vent is not allowed";
 parameter Real TiFav(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=900  "Time for which conditions must be favorable for natural ventilation to start being allowed";
  parameter Real TiNotFav(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=900  "Time for which conditions must be unfavorable for natural ventilation to stop being allowed";
  parameter Real TNitFluCut=280                    "Outdoor air temperature below which night flush sequence does not operate";

  Controls.OBC.CDL.Continuous.Hysteresis hys(
    uLow=-0.5,
    uHigh=0,
    pre_y_start=true)
    "Tests if Tout- Tset > 0. If so, output true (which is then negated- window must be closed). If not, output false (which is negated- window can stay open)."
    annotation (Placement(transformation(extent={{-62,182},{-42,202}})));
  Controls.OBC.CDL.Continuous.Add add2(k1=-1)
    annotation (Placement(transformation(extent={{-100,182},{-80,202}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysNotNitFlu(
    uLow=TDryBulCutLo,
    uHigh=TDryBulCut,
    pre_y_start=false)
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-20,182},{0,202}})));
  Controls.OBC.CDL.Interfaces.RealInput TDryBul
    "Outdoor air dry bulb temperature"
    annotation (Placement(transformation(extent={{-422,20},{-382,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yDryBulOASig
    "True if natural ventilation allowed; otherwise false" annotation (
      Placement(transformation(extent={{200,-12},{240,28}}), iconTransformation(
          extent={{100,-20},{140,20}})));
  Controls.OBC.CDL.Interfaces.RealInput TRooSet
    "Thermostat setpoint temperature used in window control" annotation (
      Placement(transformation(extent={{-422,82},{-382,122}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           ConOne(k=1)
    "Error integral- constant one"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Controls.OBC.CDL.Logical.Switch           swi1
    "Switch integrated function from constant zero to constant one if conditions are favorable"
    annotation (Placement(transformation(extent={{-18,-100},{2,-80}})));
  Controls.OBC.CDL.Continuous.IntegratorWithReset           intWitRes
    "Find integral of how long temperature has been favorable, reset to zero if temperature becomes unfavorable"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysFav(uLow=TiFav - 5,   uHigh=TiFav)
    "Allow natural ventilation if favorable air temps are sustained for specified time duration"
    annotation (Placement(transformation(extent={{82,-100},{102,-80}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           ConZero(k=0)
    "Error integral- constant zero"
    annotation (Placement(transformation(extent={{-58,-120},{-38,-100}})));
  Controls.OBC.CDL.Logical.Not           not7
    "Zero out integral if error is below threshhold"
    annotation (Placement(transformation(extent={{-18,-162},{2,-142}})));
  Controls.OBC.CDL.Logical.Or or2
    "Nat vent allowed if conditions have been favorable for more than 15 minutes, or if they have been unfavorable for less than 15 minutes"
    annotation (Placement(transformation(extent={{158,-20},{178,0}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           ConOne1(k=1)
    "Error integral- constant one"
    annotation (Placement(transformation(extent={{-60,-200},{-40,-180}})));
  Controls.OBC.CDL.Continuous.Sources.Constant           ConZero1(k=0)
    "Error integral- constant zero"
    annotation (Placement(transformation(extent={{-58,-242},{-38,-222}})));
  Controls.OBC.CDL.Logical.Switch           swi2
    "Switch integrated function from constant zero to constant one if conditions are unfavorable"
    annotation (Placement(transformation(extent={{-20,-224},{0,-204}})));
  Controls.OBC.CDL.Continuous.IntegratorWithReset           intWitRes1
    "Find integral of how long error has been above threshold, reset to zero if error goes below 2 F threshhold"
    annotation (Placement(transformation(extent={{40,-222},{60,-202}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysNotFav(uLow=TiNotFav - 5,   uHigh=
        TiNotFav)
    "Tests if air temperatures have been unfavorable for more than specified time duration"
    annotation (Placement(transformation(extent={{80,-220},{100,-200}})));
  Controls.OBC.CDL.Logical.Not           not2
    "Zero out integral if error is below threshhold"
    annotation (Placement(transformation(extent={{-82,-220},{-62,-200}})));
  Controls.OBC.CDL.Logical.Not           not3
    "Zero out integral if error is below threshhold"
    annotation (Placement(transformation(extent={{122,-220},{142,-200}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uNitFlu
    "Night flush signal- true if night flush on, false if not" annotation (
      Placement(transformation(extent={{-420,-38},{-380,2}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysNitFlu(
    uLow=TNitFluCutLo,
    uHigh=TNitFluCut,
    pre_y_start=false)
    annotation (Placement(transformation(extent={{-60,260},{-40,280}})));
  Controls.OBC.CDL.Interfaces.RealInput TRooMea
    "Thermostat setpoint temperature used in window control" annotation (
      Placement(transformation(extent={{-420,160},{-380,200}}),
        iconTransformation(extent={{-140,-96},{-100,-56}})));
  Controls.OBC.CDL.Continuous.Add add1(k1=-1)
    annotation (Placement(transformation(extent={{-100,322},{-80,342}})));
  Controls.OBC.CDL.Continuous.Hysteresis hys1(
    uLow=-0.5,
    uHigh=0,
    pre_y_start=true)
    "Tests if Tout- Troo> 0. If so, output true (which is then negated- window must be closed). If not, output false (which is negated- window can stay open)."
    annotation (Placement(transformation(extent={{-60,322},{-40,342}})));
  Controls.OBC.CDL.Logical.Not not4
    annotation (Placement(transformation(extent={{-20,318},{0,338}})));
  Controls.OBC.CDL.Logical.And and1
    "Tests if dry bulb temperature is above room setpoint or above threshhold"
    annotation (Placement(transformation(extent={{42,158},{62,178}})));
  Controls.OBC.CDL.Logical.And and3
    "Tests if dry bulb temperature is above room setpoint or above threshhold"
    annotation (Placement(transformation(extent={{40,284},{60,304}})));
  Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    annotation (Placement(transformation(extent={{120,200},{140,220}})));
protected
    parameter Real TDryBulCutLo(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")=TDryBulCut-0.5  "Lower hysteresis limit";
    parameter Real TNitFluCutLo(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")=TNitFluCut-0.5 "Lower hysteresis limit for night flush";
equation
  connect(add2.y,hys. u)
    annotation (Line(points={{-78,192},{-64,192}},
                                                color={0,0,127}));
  connect(TDryBul,add2. u2) annotation (Line(points={{-402,40},{-120,40},{-120,
          186},{-102,186}},
                    color={0,0,127}));
  connect(TDryBul, hysNotNitFlu.u) annotation (Line(points={{-402,40},{-120,40},
          {-120,130},{-62,130}},                   color={0,0,127}));
  connect(hys.y,not1. u)
    annotation (Line(points={{-40,192},{-22,192}},
                                              color={255,0,255}));

  connect(TRooSet, add2.u1) annotation (Line(points={{-402,102},{-140,102},{
          -140,198},{-102,198}},
                     color={0,0,127}));
  connect(not7.y,intWitRes. trigger) annotation (Line(points={{4,-152},{50,-152},
          {50,-102}},           color={255,0,255}));
  connect(swi1.y, intWitRes.u)
    annotation (Line(points={{4,-90},{38,-90}}, color={0,0,127}));
  connect(ConOne.y, swi1.u1)
    annotation (Line(points={{-38,-70},{-38,-82},{-20,-82}}, color={0,0,127}));
  connect(intWitRes.y, hysFav.u)
    annotation (Line(points={{62,-90},{80,-90}}, color={0,0,127}));
  connect(ConZero.y, swi1.u3) annotation (Line(points={{-36,-110},{-36,-98},{-20,
          -98}}, color={0,0,127}));
  connect(hysFav.y, or2.u1) annotation (Line(points={{104,-90},{124,-90},{124,-10},
          {156,-10}}, color={255,0,255}));
  connect(ConOne1.y, swi2.u1) annotation (Line(points={{-38,-190},{-30,-190},{-30,
          -206},{-22,-206}}, color={0,0,127}));
  connect(ConZero1.y, swi2.u3) annotation (Line(points={{-36,-232},{-32,-232},{-32,
          -222},{-22,-222}}, color={0,0,127}));
  connect(intWitRes1.y, hysNotFav.u) annotation (Line(points={{62,-212},{72,
          -212},{72,-210},{78,-210}},
                                color={0,0,127}));
  connect(swi2.y, intWitRes1.u) annotation (Line(points={{2,-214},{22,-214},{22,
          -212},{38,-212}}, color={0,0,127}));
  connect(not2.y, swi2.u2) annotation (Line(points={{-60,-210},{-40,-210},{-40,-214},
          {-22,-214}}, color={255,0,255}));
  connect(hysNotFav.y, not3.u)
    annotation (Line(points={{102,-210},{120,-210}}, color={255,0,255}));
  connect(not3.y, or2.u2) annotation (Line(points={{144,-210},{144,-18},{156,-18}},
        color={255,0,255}));
  connect(TDryBul, hysNitFlu.u) annotation (Line(points={{-402,40},{-120,40},{
          -120,270},{-62,270}},
                           color={0,0,127}));
  connect(or2.y,yDryBulOASig)  annotation (Line(points={{180,-10},{189,-10},{189,
          8},{220,8}}, color={255,0,255}));
  connect(add1.y, hys1.u)
    annotation (Line(points={{-78,332},{-62,332}}, color={0,0,127}));
  connect(hys1.y, not4.u) annotation (Line(points={{-38,332},{-30,332},{-30,328},
          {-22,328}}, color={255,0,255}));
  connect(TDryBul, add1.u2) annotation (Line(points={{-402,40},{-120,40},{-120,
          326},{-102,326}}, color={0,0,127}));
  connect(TRooMea, add1.u1) annotation (Line(points={{-400,180},{-280,180},{
          -280,338},{-102,338}}, color={0,0,127}));
  connect(hysNitFlu.y, and3.u2) annotation (Line(points={{-38,270},{18,270},{18,
          286},{38,286}}, color={255,0,255}));
  connect(not4.y, and3.u1) annotation (Line(points={{2,328},{20,328},{20,294},{
          38,294}}, color={255,0,255}));
  connect(hysNotNitFlu.y, and1.u2) annotation (Line(points={{-38,130},{2,130},{
          2,160},{40,160}}, color={255,0,255}));
  connect(not1.y, and1.u1) annotation (Line(points={{2,192},{22,192},{22,168},{
          40,168}}, color={255,0,255}));
  connect(ConZero1.y, intWitRes1.y_reset_in) annotation (Line(points={{-36,-232},
          {28,-232},{28,-220},{38,-220}}, color={0,0,127}));
  connect(ConZero.y, intWitRes.y_reset_in) annotation (Line(points={{-36,-110},
          {28,-110},{28,-98},{38,-98}}, color={0,0,127}));
  connect(and3.y, logSwi.u1) annotation (Line(points={{62,294},{100,294},{100,
          218},{118,218}}, color={255,0,255}));
  connect(and1.y, logSwi.u3) annotation (Line(points={{64,168},{96,168},{96,202},
          {118,202}}, color={255,0,255}));
  connect(uNitFlu, logSwi.u2) annotation (Line(points={{-400,-18},{-354,-18},{
          -354,212},{118,212},{118,210}}, color={255,0,255}));
  connect(logSwi.y, swi1.u2) annotation (Line(points={{142,210},{174,210},{174,
          28},{-214,28},{-214,-90},{-20,-90}}, color={255,0,255}));
  annotation (defaultComponentName = "dryBulLoc", Documentation(info="<html>
  <p>
  This block locks out natural ventilation if the dry bulb temperature is unacceptable for natural ventilation based on user-specified conditions.
  These conditions vary with the building's operational mode.
  
   <p>If the building is in night flush mode, natural ventilation is locked out if one of the following is true:
   <p>1. The outdoor air is below a user-specified threshhold (TNitFluCut)
   <p>2. The outdoor air temperature is above the current measured room temperature
   <p>AND either or both of these conditions has persisted for a user-specified amount of time (TiNotFav, typically 15 minutes). 
  
   <p>If the building is not in night flush mode, natural ventilation is locked out if:
   <p>1. The outdoor air is below a user-specified threshhold (TDryBulCut)
   <p>2. The outdoor air dry bulb temperature is above the air temperature setpoint for the room.
   <p>AND either or both of these conditions has persisted for a user-specified amount of time (TiNotFav, typically 15 minutes). 
  
  <p> In either night flush or daytime natural ventilation mode, in order for the lockout to reverse (ie, for natural ventilation to be allowed), conditions must be favorable for at least a user-specified amount of time
  (TiFav, typically 15 minutes). 
</p>
</html>"), Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-76,40},{-76,-82},{84,-82},{84,40},{-76,40}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-50,40},{-56,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{-56,86},{64,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Rectangle(
          extent={{64,40},{58,80}},
          lineColor={28,108,200},
          lineThickness=1),
        Text(
          extent={{-18,42},{32,-54}},
          lineColor={28,108,200},
          textString="D"),
        Text(
          lineColor={0,0,255},
          extent={{-148,106},{152,146}},
          textString="%name")}),
                             Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-380,
            -300},{200,420}}), graphics={
        Rectangle(extent={{-378,-182},{200,-300}}, lineColor={28,108,200}),
        Text(
          extent={{-358,-184},{178,-380}},
          lineColor={28,108,200},
          textString=
              "Tests if conditions have been unfavorable for less than specified duration",
          fontName="Arial Narrow"),
        Rectangle(extent={{-378,-34},{200,-172}}, lineColor={28,108,200}),
        Text(
          extent={{-372,54},{192,-152}},
          lineColor={28,108,200},
          textString=
              "Tests if conditions have been favorable for more than specified duration",
          fontName="Arial Narrow"),
        Rectangle(extent={{-380,232},{196,56}}, lineColor={28,108,200}),
        Rectangle(extent={{-378,358},{198,236}},lineColor={28,108,200}),
        Text(
          extent={{-366,348},{194,150}},
          lineColor={28,108,200},
          fontName="Arial Narrow",
          textString=
              "Tests if conditions are favorable for natural ventilation in night flush mode"),
        Text(
          extent={{-374,176},{186,-22}},
          lineColor={28,108,200},
          textString=
              "Tests if conditions are favorable for natural ventilation if not in night flush mode",
          fontName="Arial Narrow"),
        Text(
          extent={{-370,404},{30,372}},
          lineColor={0,0,0},
          lineThickness=1,
          fontSize=9,
          horizontalAlignment=TextAlignment.Left,
          textStyle={TextStyle.Bold},
          textString="Dry Bulb Temperature Lockout:
Locks out natural ventilation if outdoor air temperature is out of user-specified range
and has been out of range for more than user-specified duration")}));
end DryBulbLockout;
