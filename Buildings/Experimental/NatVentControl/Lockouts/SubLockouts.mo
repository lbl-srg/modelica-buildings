within Buildings.Experimental.NatVentControl.Lockouts;
package SubLockouts "Individual natural ventilation lockouts"
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
    Controls.OBC.CDL.Continuous.IntegratorWithReset           intWitRes(reset=
          Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
      "Find integral of how long temperature has been favorable, reset to zero if temperature becomes unfavorable"
      annotation (Placement(transformation(extent={{42,-100},{62,-80}})));
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
    Controls.OBC.CDL.Continuous.IntegratorWithReset           intWitRes1(reset=
          Buildings.Controls.OBC.CDL.Types.Reset.Parameter)
      "Find integral of how long error has been above threshold, reset to zero if error goes below 2 F threshhold"
      annotation (Placement(transformation(extent={{38,-222},{58,-202}})));
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
    Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
      annotation (Placement(transformation(extent={{122,200},{142,220}})));
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
    connect(not7.y,intWitRes. trigger) annotation (Line(points={{4,-152},{52,-152},
            {52,-102}},           color={255,0,255}));
    connect(swi1.y, intWitRes.u)
      annotation (Line(points={{4,-90},{40,-90}}, color={0,0,127}));
    connect(ConOne.y, swi1.u1)
      annotation (Line(points={{-38,-70},{-38,-82},{-20,-82}}, color={0,0,127}));
    connect(intWitRes.y, hysFav.u)
      annotation (Line(points={{64,-90},{80,-90}}, color={0,0,127}));
    connect(ConZero.y, swi1.u3) annotation (Line(points={{-36,-110},{-36,-98},{-20,
            -98}}, color={0,0,127}));
    connect(hysFav.y, or2.u1) annotation (Line(points={{104,-90},{124,-90},{124,-10},
            {156,-10}}, color={255,0,255}));
    connect(ConOne1.y, swi2.u1) annotation (Line(points={{-38,-190},{-30,-190},{-30,
            -206},{-22,-206}}, color={0,0,127}));
    connect(ConZero1.y, swi2.u3) annotation (Line(points={{-36,-232},{-32,-232},{-32,
            -222},{-22,-222}}, color={0,0,127}));
    connect(intWitRes1.y, hysNotFav.u) annotation (Line(points={{60,-212},{72,-212},
            {72,-210},{78,-210}}, color={0,0,127}));
    connect(swi2.y, intWitRes1.u) annotation (Line(points={{2,-214},{22,-214},{22,
            -212},{36,-212}}, color={0,0,127}));
    connect(not2.y, swi2.u2) annotation (Line(points={{-60,-210},{-40,-210},{-40,-214},
            {-22,-214}}, color={255,0,255}));
    connect(hysNotFav.y, not3.u)
      annotation (Line(points={{102,-210},{120,-210}}, color={255,0,255}));
    connect(not3.y, or2.u2) annotation (Line(points={{144,-210},{144,-18},{156,-18}},
          color={255,0,255}));
    connect(TDryBul, hysNitFlu.u) annotation (Line(points={{-402,40},{-120,40},{
            -120,270},{-62,270}},
                             color={0,0,127}));
    connect(uNitFlu, logicalSwitch.u2) annotation (Line(points={{-400,-18},{-260,
            -18},{-260,210},{120,210}},
                                  color={255,0,255}));
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
    connect(and3.y, logicalSwitch.u1) annotation (Line(points={{62,294},{92,294},
            {92,218},{120,218}}, color={255,0,255}));
    connect(and1.y, logicalSwitch.u3) annotation (Line(points={{64,168},{92,168},
            {92,202},{120,202}}, color={255,0,255}));
    connect(logicalSwitch.y, not7.u) annotation (Line(points={{143,210},{180,210},
            {180,50},{-100,50},{-100,4},{-198,4},{-198,-152},{-20,-152}}, color={
            255,0,255}));
    connect(logicalSwitch.y, not2.u) annotation (Line(points={{143,210},{180,210},
            {180,50},{-100,50},{-100,4},{-198,4},{-198,-210},{-84,-210}}, color={
            255,0,255}));
    connect(logicalSwitch.y, intWitRes1.trigger) annotation (Line(points={{143,
            210},{180,210},{180,50},{-100,50},{-100,4},{-198,4},{-198,-262},{48,
            -262},{48,-224}}, color={255,0,255}));
    connect(logicalSwitch.y, swi1.u2) annotation (Line(points={{143,210},{178,210},
            {178,50},{-98,50},{-98,4},{-198,4},{-198,-90},{-20,-90}}, color={255,
            0,255}));
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
</html>"),   Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
            textString="D")}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-380,
              -300},{200,360}}), graphics={
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
            fontName="Arial Narrow")}));
  end DryBulbLockout;

  block ManualOverrideLockout
    "Locks out natural ventilation if manual override is on"
    Controls.OBC.CDL.Interfaces.BooleanInput uManOveRid
      "True if manual override; false if not" annotation (Placement(
          transformation(extent={{-140,-10},{-100,30}}), iconTransformation(
            extent={{-140,-20},{-100,20}})));
    Controls.OBC.CDL.Logical.Not not1
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
    Controls.OBC.CDL.Interfaces.BooleanOutput yManOveNatVenSig
    "True if natural ventilation is allowed; false if natural ventilation is locked out due to manual override"  annotation (
        Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
            extent={{100,-20},{140,20}})));
  equation
    connect(not1.y,yManOveNatVenSig)
      annotation (Line(points={{22,10},{120,10}}, color={255,0,255}));
    connect(uManOveRid, not1.u)
      annotation (Line(points={{-120,10},{-2,10}}, color={255,0,255}));
    annotation (defaultComponentName = "manLoc",Documentation(info="<html>
  <p>
  This block locks out natural ventilation if a manual override is specified. 
</p>
</html>"),  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-80,40},{-80,-82},{80,-82},{80,40},{-80,40}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{-54,40},{-60,80}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{-60,86},{60,80}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{60,40},{54,80}},
            lineColor={28,108,200},
            lineThickness=1),
          Text(
            extent={{-22,42},{28,-54}},
            lineColor={28,108,200},
            textString="M")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
  end ManualOverrideLockout;

  block OccupancyLockout
    "Locks out natural ventilation if room is unoccupied and night flush mode is off"
    Controls.OBC.CDL.Interfaces.BooleanInput uOcc
      "True if room is occupied; false if not" annotation (Placement(
          transformation(extent={{-140,30},{-100,70}}), iconTransformation(extent=
             {{-140,-50},{-100,-10}})));
    Controls.OBC.CDL.Interfaces.BooleanOutput yOccNatVenSig
      "True if nat vent allowed, false if nat vent locked out" annotation (
        Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
            extent={{100,-20},{140,20}})));
    Controls.OBC.CDL.Interfaces.BooleanInput uNitFlu
      "True if night flush mode on; false if not" annotation (Placement(
          transformation(extent={{-140,-50},{-100,-10}}), iconTransformation(
            extent={{-140,8},{-100,48}})));
    Controls.OBC.CDL.Logical.Or or2
      annotation (Placement(transformation(extent={{0,0},{20,20}})));
  equation
    connect(uOcc, or2.u1) annotation (Line(points={{-120,50},{-60,50},{-60,10},{-2,
            10}}, color={255,0,255}));
    connect(uNitFlu, or2.u2) annotation (Line(points={{-120,-30},{-62,-30},{-62,2},
            {-2,2}}, color={255,0,255}));
    connect(or2.y,yOccNatVenSig)
      annotation (Line(points={{22,10},{120,10}}, color={255,0,255}));
    annotation (defaultComponentName = "occLoc", Documentation(info="<html>
  <p>
  This block locks out natural ventilation if the building is unoccupied, unless night flush mode is on. 
</p>
</html>"),  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-80,40},{-80,-82},{80,-82},{80,40},{-80,40}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{-54,40},{-60,80}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{-60,86},{60,80}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{60,40},{54,80}},
            lineColor={28,108,200},
            lineThickness=1),
          Text(
            extent={{-22,42},{28,-54}},
            lineColor={28,108,200},
            textString="O")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
  end OccupancyLockout;

  block RainLockout "Locks out natural ventilation if rain is detected"
     parameter Real locTimRai(min=0,
      final unit="s",
      final displayUnit="s",
      final quantity="Time")=1800  "Time for which natural ventilation is locked out after rain is detected";
    Controls.OBC.CDL.Interfaces.BooleanInput uRai
      "True if it is raining; false if not" annotation (Placement(transformation(
            extent={{-140,-10},{-100,30}}), iconTransformation(extent={{-140,-20},
              {-100,20}})));
    Controls.OBC.CDL.Interfaces.BooleanOutput yRaiNatVenSig
      "True if natural ventilation is allowed, false if natural ventilation is locked out due to rain"
                                                            annotation (Placement(
          transformation(extent={{100,-10},{140,30}}), iconTransformation(extent=
              {{100,-20},{140,20}})));
    Controls.OBC.CDL.Logical.Not not1
      annotation (Placement(transformation(extent={{40,0},{60,20}})));
    Controls.OBC.CDL.Logical.TrueFalseHold truFalHol(trueHoldDuration=locTimRai,
        falseHoldDuration=0)
      annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  equation
    connect(not1.y,yRaiNatVenSig)
      annotation (Line(points={{62,10},{120,10}}, color={255,0,255}));
    connect(uRai, truFalHol.u)
      annotation (Line(points={{-120,10},{-42,10}}, color={255,0,255}));
    connect(truFalHol.y, not1.u)
      annotation (Line(points={{-18,10},{38,10}}, color={255,0,255}));
    annotation (defaultComponentName = "raiLoc",Documentation(info="<html>
  <p>
  This block locks out natural ventilation for a user-specified amount of time (locTimRai, typically 30 minutes) if rain is detected. 
</p>
</html>"),  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-80,40},{-80,-82},{80,-82},{80,40},{-80,40}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{-54,40},{-60,80}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{-60,86},{60,80}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{60,40},{54,80}},
            lineColor={28,108,200},
            lineThickness=1),
          Text(
            extent={{-22,42},{28,-54}},
            lineColor={28,108,200},
            textString="R")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
  end RainLockout;

  block WetBulbLockout
    "Locks out natural ventilation based on outdoor air wet bulb temperature"
    parameter Real TWetBulDif(min=0.001,
      final unit="K",
      final displayUnit="K",
      final quantity="TemperatureDifference")=4.44 "Allowable difference between outdoor air wet bulb temperature and room air temperature setpoint: OA WB +  this difference must be less than room air temperature setpoint";
    Controls.OBC.CDL.Continuous.Add addDif(k2=-1)
      "Difference between room setpoint and wet bulb temperature"
      annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    Controls.OBC.CDL.Interfaces.RealInput TRooSet
      "Thermostat setpoint temperature used in window control" annotation (
        Placement(transformation(extent={{-140,10},{-100,50}}),
          iconTransformation(extent={{-140,-50},{-100,-10}})));
    Controls.OBC.CDL.Interfaces.RealInput TWetBul
      "Outdoor air wet bulb temperature"
      annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
          iconTransformation(extent={{-140,10},{-100,50}})));
    Controls.OBC.CDL.Continuous.Hysteresis hys(
      uLow=TWetBulDifLo,
      uHigh=TWetBulDif,
      pre_y_start=true)
      "Tests if room air setpoint minus wet bulb temp is greater than user-specified tolerance (typically 8 F). If so, window can open. If not, window must be closed."
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Controls.OBC.CDL.Interfaces.BooleanOutput yWetBulNatVenSig
      "True if natural ventilation allowed; otherwise false" annotation (
        Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
            extent={{100,-18},{140,22}})));
    Controls.OBC.CDL.Continuous.Hysteresis hys1(
      uLow=0,
      uHigh=0.01,
      pre_y_start=true)
      "Tests if wet bulb temp is greater than zero. If so, compare to room setpoint. If not, window is not locked out due to wet bulb temperature "
      annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
    Controls.OBC.CDL.Logical.And and2
      annotation (Placement(transformation(extent={{62,-20},{82,0}})));
  protected
            parameter Real TWetBulDifLo(min=0,
      final unit="K",
      final displayUnit="K",
      final quantity="TemperatureDifference")=TWetBulDif*0.99  "Lower hysteresis limit";
  equation
    connect(addDif.y, hys.u)
      annotation (Line(points={{-38,10},{-22,10}}, color={0,0,127}));
    connect(TRooSet, addDif.u1) annotation (Line(points={{-120,30},{-82,30},{-82,
            16},{-62,16}}, color={0,0,127}));
    connect(TWetBul, addDif.u2) annotation (Line(points={{-120,-30},{-82,-30},{
            -82,4},{-62,4}}, color={0,0,127}));
    connect(TWetBul, hys1.u)
      annotation (Line(points={{-120,-30},{-22,-30}}, color={0,0,127}));
    connect(and2.y,yWetBulNatVenSig)  annotation (Line(points={{84,-10},{94,-10},
            {94,10},{120,10}}, color={255,0,255}));
    connect(hys.y, and2.u1) annotation (Line(points={{2,10},{32,10},{32,-10},{60,
            -10}}, color={255,0,255}));
    connect(hys1.y, and2.u2) annotation (Line(points={{2,-30},{32,-30},{32,-18},{
            60,-18}}, color={255,0,255}));
    annotation (defaultComponentName = "wetBulLoc",Documentation(info="<html>
  <p>
  This block locks out natural ventilation if the wet bulb temperature is too high. 
  <p> The user specifies a tolerance (TWetBulDif, typically 4.5 degrees Celsius), and the wet bulb temperature must be below the room setpoint minus the tolerance 
  in order for natural ventilation to be permitted. 
</p>
</html>"),  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-80,40},{-80,-82},{80,-82},{80,40},{-80,40}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{-54,40},{-60,80}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{-60,86},{60,80}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{60,40},{54,80}},
            lineColor={28,108,200},
            lineThickness=1),
          Text(
            extent={{-40,32},{44,-42}},
            lineColor={28,108,200},
            textString="B")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
  end WetBulbLockout;

  block WindLockout "Locks out natural ventilation due to high wind speed"
     parameter Real winSpeLim(min=0,
      final unit="m/s",
      final displayUnit="m/s",
      final quantity="Velocity")=8.94 "Wind speed above which window must be closed";
    Controls.OBC.CDL.Continuous.Hysteresis hys(
      uLow=winSpeLimLo,
      uHigh=winSpeLim,
      pre_y_start=true)
      "Tests if wind speed is above 20 mph (8.94 m/s); if so, locks out nat vent"
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Controls.OBC.CDL.Interfaces.RealInput winSpe
      "Wind speed perpendicular to window" annotation (Placement(transformation(
            extent={{-140,-10},{-100,30}}), iconTransformation(extent={{-140,
              -20},{-100,20}})));
    Controls.OBC.CDL.Logical.Not not1
      annotation (Placement(transformation(extent={{20,0},{40,20}})));
    Controls.OBC.CDL.Interfaces.BooleanOutput yWinNatVenSig
      "True if natural ventilation allowed; otherwise false" annotation (
        Placement(transformation(extent={{100,-10},{140,30}}), iconTransformation(
            extent={{100,-20},{140,20}})));
  protected
      parameter Real winSpeLimLo(min=0,
      final unit="m/s",
      final displayUnit="m/s",
      final quantity="Velocity")=winSpeLim*0.95  "Lower hysteresis limit";
  equation
    connect(winSpe, hys.u)
      annotation (Line(points={{-120,10},{-22,10}}, color={0,0,127}));
    connect(hys.y, not1.u)
      annotation (Line(points={{2,10},{18,10}}, color={255,0,255}));
    connect(not1.y,yWinNatVenSig)
      annotation (Line(points={{42,10},{120,10}}, color={255,0,255}));
    annotation (defaultComponentName = "winLoc",Documentation(info="<html>
  <p>
  This block locks out natural ventilation if wind speed is greater than a user-specified amount (winSpeLim, typically 20 mph).
</p>
</html>"),  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={28,108,200},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Polygon(
            points={{-80,38},{-80,-84},{80,-84},{80,38},{-80,38}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{-54,38},{-60,78}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{-60,84},{60,78}},
            lineColor={28,108,200},
            lineThickness=1),
          Rectangle(
            extent={{60,38},{54,78}},
            lineColor={28,108,200},
            lineThickness=1),
          Text(
            extent={{-22,40},{28,-56}},
            lineColor={28,108,200},
            textString="W")}), Diagram(coordinateSystem(preserveAspectRatio=false)));
  end WindLockout;

  package Validation "Validation models for individual lockouts"

    model DryBulLoc "Validation model for outdoor air dry bulb natural ventilation lockout"

      Controls.OBC.CDL.Continuous.Sources.Constant con(k=293.15)
        annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
      DryBulbLockout dryBulLoc
        annotation (Placement(transformation(extent={{-2,16},{18,36}})));
      Controls.OBC.CDL.Logical.Sources.Pulse booPul(width=0.25, period=86400)
        annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
      Controls.OBC.CDL.Continuous.Sources.Ramp ram(
        height=20,
        duration=86400,
        offset=278)
        annotation (Placement(transformation(extent={{-60,78},{-40,98}})));
      Controls.OBC.CDL.Continuous.Sources.Constant con1(k=295)
        annotation (Placement(transformation(extent={{-60,-38},{-40,-18}})));
    equation
      connect(con.y, dryBulLoc.TRooSet) annotation (Line(points={{-38,12},{-30,12},{
              -30,22},{-4,22}}, color={0,0,127}));
      connect(booPul.y, dryBulLoc.uNitFlu) annotation (Line(points={{-38,50},{
              -28,50},{-28,26},{-4,26}}, color={255,0,255}));
      connect(ram.y, dryBulLoc.TDryBul) annotation (Line(points={{-38,88},{-22,
              88},{-22,30},{-4,30}}, color={0,0,127}));
      connect(con1.y, dryBulLoc.TRooMea) annotation (Line(points={{-38,-28},{
              -22,-28},{-22,18.4},{-4,18.4}}, color={0,0,127}));
      annotation (Documentation(info="<html>
<p>
This model validates the dry bulb lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out due to dry bulb temperature being out of range, output should show false.   
</p>
</html>"),    experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/DryBulLoc.mos"
            "Simulate and plot"), Icon(graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end DryBulLoc;

    model ManOvrLoc "Validation model for manual override natural ventilation lockout"

      ManualOverrideLockout manLoc
        annotation (Placement(transformation(extent={{0,0},{20,20}})));
      Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=86400)
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
    equation
      connect(booPul.y, manLoc.uManOveRid)
        annotation (Line(points={{-38,10},{-2,10}}, color={255,0,255}));
      annotation (Documentation(info="<html>
<p>
This model validates the manual override lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out due to manual override, output should show false. 
</p>
</html>"),    experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/ManOvrLoc.mos"
            "Simulate and plot"), Icon(graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end ManOvrLoc;

    model OccLoc "Validation model for occupancy natural ventilation lockout"

      OccupancyLockout occLoc
        annotation (Placement(transformation(extent={{0,38},{20,58}})));
      Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=86400)
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      Controls.OBC.CDL.Logical.Sources.Pulse booPul1(period=43200)
        annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
    equation
      connect(booPul.y, occLoc.uOcc) annotation (Line(points={{-38,10},{-20,10},
              {-20,45},{-2,45}}, color={255,0,255}));
      connect(booPul1.y, occLoc.uNitFlu) annotation (Line(points={{-38,50},{-20,
              50},{-20,50.8},{-2,50.8}}, color={255,0,255}));
      annotation (Documentation(info="<html>
<p>
This model validates the occupancy lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out because the building is unoccupied and is also not in night flush mode, output should show false. 
</p>  
</p>
</html>"),    experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/OccLoc.mos"
            "Simulate and plot"), Icon(graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end OccLoc;

    model RaiLoc "Validation model for rain natural ventilation lockout"

      RainLockout raiLoc
        annotation (Placement(transformation(extent={{0,20},{20,40}})));
      Controls.OBC.CDL.Logical.Sources.Pulse booPul(period=14400)
        annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
    equation
      connect(booPul.y, raiLoc.uRai)
        annotation (Line(points={{-38,30},{-2,30}}, color={255,0,255}));
      annotation (Documentation(info="<html>
<p>
This model validates the rain lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out because it is raining or it was raining within a specified amount of time (in this case, 30 minutes), output should show false. 
</p>  
</p>
</html>"),    experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/RaiLoc.mos"
            "Simulate and plot"), Icon(graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end RaiLoc;

    model WetBulLoc "Validation model for natural ventilation wet bulb lockout"

      Controls.OBC.CDL.Continuous.Sources.Sine sin(
        amplitude=2*4.44,
        freqHz=2/86400,
        phase(displayUnit="rad"),
        offset=293.15)
        annotation (Placement(transformation(extent={{-60,42},{-40,62}})));
      Controls.OBC.CDL.Continuous.Sources.Constant con(k=293.15)
        annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
      WetBulbLockout wetBulLoc
        annotation (Placement(transformation(extent={{0,20},{20,40}})));
    equation
      connect(con.y, wetBulLoc.TRooSet) annotation (Line(points={{-38,12},{-20,
              12},{-20,27},{-2,27}}, color={0,0,127}));
      connect(sin.y, wetBulLoc.TWetBul) annotation (Line(points={{-38,52},{-20,
              52},{-20,33},{-2,33}}, color={0,0,127}));
      annotation (Documentation(info="<html>
<p>
This model validates the wet bulb lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out because the wet bulb temperature is above the room setpoint minus the temperature difference , output should show false. 
</p> 
</p>
</html>"),    experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/WetBulLoc.mos"
            "Simulate and plot"), Icon(graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end WetBulLoc;

    model WinLoc "Validation model for wind natural ventilation lockout"


      Controls.OBC.CDL.Continuous.Sources.Sine sin2(
        amplitude=2,
        freqHz=4/86400,
        phase(displayUnit="rad"),
        offset=8.94)
        annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
      WindLockout winLoc
        annotation (Placement(transformation(extent={{0,0},{20,20}})));
    equation
      connect(sin2.y, winLoc.winSpe)
        annotation (Line(points={{-38,10},{-2,10}}, color={0,0,127}));
      annotation (Documentation(info="<html>
<p>
This model validates the wind speed lockout. If natural ventilation is allowed, output should show true. 
If natural ventilation is locked out due to wind speeds exceeding the specified threshhold, output should show false. 
</p>  
</p>
</html>"),    experiment(Tolerance=1e-6, StartTime=0, StopTime=86400),__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Lockouts/SubLockouts/Validation/WinLoc.mos"
            "Simulate and plot"), Icon(graphics={
            Ellipse(
              lineColor={75,138,73},
              fillColor={255,255,255},
              fillPattern=FillPattern.Solid,
              extent={{-100,-100},{100,100}}),
            Polygon(lineColor = {0,0,255},
                    fillColor = {75,138,73},
                    pattern = LinePattern.None,
                    fillPattern = FillPattern.Solid,
                    points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
            coordinateSystem(preserveAspectRatio=false)));
    end WinLoc;
  end Validation;
end SubLockouts;
