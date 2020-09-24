within Buildings.Experimental.NatVentControl.Alarms;
block WindowUnstableAlarm
  "Alarm if window moves within a specified range more than a specified amount of times within a given time interval"
parameter Real TiUns(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=1200  "Time interval within which window must move a given number of times to trigger alarm";
parameter Real swiRan(min=0,max=1)=0.75 "Percent range within which window can swing without triggering alarm";
parameter Real numSwi(min=0)=3 "Allowable number of swings before window is considered unstable";

  Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{-80,38},{-60,58}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar1(p=0.5 + 0.5*swiRan, k=-1)
    annotation (Placement(transformation(extent={{-80,-62},{-60,-42}})));
  Controls.OBC.CDL.Integers.OnCounter onCouInt
    annotation (Placement(transformation(extent={{40,-58},{52,-46}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar2(p=0.5 - 0.5*swiRan, k=-1)
    annotation (Placement(transformation(extent={{-80,-102},{-60,-82}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysAboHi(
    uLow=-0.01,
    uHigh=0,
    pre_y_start=true)
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysBelLo(uLow=0, uHigh=0.01)
    annotation (Placement(transformation(extent={{-40,-102},{-20,-82}})));
  Controls.OBC.CDL.Integers.OnCounter onCouInt1
    annotation (Placement(transformation(extent={{4,-98},{16,-86}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar3(p=-numSwi, k=1)
    annotation (Placement(transformation(extent={{262,-60},{282,-40}})));
  Controls.OBC.CDL.Conversions.IntegerToReal intToRea
    annotation (Placement(transformation(extent={{80,-62},{100,-42}})));
  Controls.OBC.CDL.Conversions.IntegerToReal intToRea1
    annotation (Placement(transformation(extent={{80,-102},{100,-82}})));
  Controls.OBC.CDL.Continuous.AddParameter addPar4(p=-numSwi, k=1)
    annotation (Placement(transformation(extent={{262,-100},{282,-80}})));
  Controls.OBC.CDL.Logical.And andCouAbo
    annotation (Placement(transformation(extent={{362,-80},{382,-60}})));
  Controls.OBC.CDL.Logical.And and3
    annotation (Placement(transformation(extent={{404,0},{424,20}})));
  Controls.OBC.CDL.Interfaces.BooleanInput uManOvr "Manual override"
    annotation (Placement(transformation(extent={{-180,28},{-140,68}}),
        iconTransformation(extent={{-140,10},{-100,50}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput yUnsAla
    "True if instability alarm is triggered; false if not" annotation (
      Placement(transformation(extent={{440,-10},{480,30}}), iconTransformation(
          extent={{100,-18},{140,22}})));
  Controls.OBC.CDL.Interfaces.RealInput uWinPos "Window position" annotation (
      Placement(transformation(extent={{-180,-52},{-140,-12}}),
        iconTransformation(extent={{-140,-48},{-100,-8}})));
  Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysCouHi(
    uLow=0,
    uHigh=0.1,
    pre_y_start=false)
    annotation (Placement(transformation(extent={{302,-58},{322,-38}})));
  Controls.OBC.CDL.Continuous.Hysteresis hysCouLo(
    uLow=0,
    uHigh=0.1,
    pre_y_start=false)
    annotation (Placement(transformation(extent={{302,-100},{322,-80}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant(k=false)
    annotation (Placement(transformation(extent={{-42,-190},{-22,-170}})));
  Controls.OBC.CDL.Continuous.Add add2(k1=-1, k2=+1)
    annotation (Placement(transformation(extent={{218,-60},{238,-40}})));
  Controls.OBC.CDL.Continuous.Add add1(k2=-1)
    annotation (Placement(transformation(extent={{218,-100},{238,-80}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay(delayTime=TiUns)
    annotation (Placement(transformation(extent={{144,-162},{164,-142}})));
  Modelica.Blocks.Nonlinear.FixedDelay fixedDelay1(delayTime=TiUns)
    annotation (Placement(transformation(extent={{124,0},{144,20}})));
equation
  connect(uManOvr, not1.u)
    annotation (Line(points={{-160,48},{-82,48}}, color={255,0,255}));
  connect(uWinPos, addPar1.u) annotation (Line(points={{-160,-32},{-120,-32},{-120,
          -52},{-82,-52}}, color={0,0,127}));
  connect(uWinPos, addPar2.u) annotation (Line(points={{-160,-32},{-120,-32},{-120,
          -92},{-82,-92}}, color={0,0,127}));
  connect(addPar1.y, hysAboHi.u) annotation (Line(points={{-58,-52},{-50,-52},{
          -50,-50},{-42,-50}}, color={0,0,127}));
  connect(addPar2.y, hysBelLo.u)
    annotation (Line(points={{-58,-92},{-42,-92}}, color={0,0,127}));
  connect(hysBelLo.y, onCouInt1.trigger)
    annotation (Line(points={{-18,-92},{2.8,-92}}, color={255,0,255}));
  connect(onCouInt.y, intToRea.u)
    annotation (Line(points={{53.2,-52},{78,-52}}, color={255,127,0}));
  connect(onCouInt1.y, intToRea1.u)
    annotation (Line(points={{17.2,-92},{78,-92}}, color={255,127,0}));
  connect(and3.y, yUnsAla)
    annotation (Line(points={{426,10},{460,10}},
                                               color={255,0,255}));
  connect(not2.u, hysAboHi.y)
    annotation (Line(points={{-2,-50},{-18,-50}}, color={255,0,255}));
  connect(not2.y, onCouInt.trigger) annotation (Line(points={{22,-50},{32,-50},
          {32,-52},{38.8,-52}}, color={255,0,255}));
  connect(not1.y, and3.u1) annotation (Line(points={{-58,48},{368,48},{368,10},
          {402,10}}, color={255,0,255}));
  connect(hysCouHi.y, andCouAbo.u1) annotation (Line(points={{324,-48},{332,-48},
          {332,-70},{360,-70}}, color={255,0,255}));
  connect(hysCouLo.y, andCouAbo.u2) annotation (Line(points={{324,-90},{338,-90},
          {338,-78},{360,-78}}, color={255,0,255}));
  connect(addPar3.y, hysCouHi.u) annotation (Line(points={{284,-50},{292,-50},{
          292,-48},{300,-48}}, color={0,0,127}));
  connect(addPar4.y, hysCouLo.u)
    annotation (Line(points={{284,-90},{300,-90}}, color={0,0,127}));
  connect(andCouAbo.y, and3.u2)
    annotation (Line(points={{384,-70},{384,2},{402,2}}, color={255,0,255}));
  connect(booleanConstant.y, onCouInt1.reset) annotation (Line(points={{-21,
          -180},{10,-180},{10,-99.2}}, color={255,0,255}));
  connect(booleanConstant.y, onCouInt.reset) annotation (Line(points={{-21,-180},
          {46,-180},{46,-59.2}}, color={255,0,255}));
  connect(addPar3.u, add2.y)
    annotation (Line(points={{260,-50},{240,-50}}, color={0,0,127}));
  connect(addPar4.u, add1.y)
    annotation (Line(points={{260,-90},{240,-90}}, color={0,0,127}));
  connect(intToRea.y, add2.u2) annotation (Line(points={{102,-52},{160,-52},{
          160,-56},{216,-56}}, color={0,0,127}));
  connect(intToRea1.y, add1.u1) annotation (Line(points={{102,-92},{160,-92},{
          160,-84},{216,-84}}, color={0,0,127}));
  connect(intToRea1.y, fixedDelay.u) annotation (Line(points={{102,-92},{128,
          -92},{128,-152},{142,-152}}, color={0,0,127}));
  connect(fixedDelay.y, add1.u2) annotation (Line(points={{165,-152},{196,-152},
          {196,-96},{216,-96}}, color={0,0,127}));
  connect(intToRea.y, fixedDelay1.u) annotation (Line(points={{102,-52},{112,
          -52},{112,10},{122,10}}, color={0,0,127}));
  connect(fixedDelay1.y, add2.u1) annotation (Line(points={{145,10},{164,10},{
          164,-44},{216,-44}}, color={0,0,127}));
  annotation (defaultComponentName = "winUnsAla",Documentation(info="<html>
  <p>
  
This alarm is triggered when the window is unstable, i.e. when it is opening and closing excessively within a limited amount of time.

 <p>
The user specifies values for three parameters: 
         <p>1. The swing range, swiRan
         <p>2. The time frame, TiUns
         <p>3. The number of swings within the time frame required to trigger the alarm, numSwi

 <p>Each time the window position moves above the top of the user-defined swing range or moves below the bottom of the swing range, one swing event is counted. 
 <p> Swing events are counted continuously. 
  <p>In order to trigger the alarm, the window position must exceed the top of the swing range the given number of times (numSwi) 
  AND must also dip below the bottom of the swing range the user-specified number of times (numSwi). 
   <p>
If more than the user-defined number of swings (numSwi) occur during the user-specified time frame (TiUns), the alarm is triggered. 
</p>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={238,46,47},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
          Polygon(
          points={{-38,92},{42,92},{62,34},{62,-28},{42,-88},{-38,-88},{-58,-28},
              {-58,32},{-38,92}},
          lineColor={255,0,0},
          lineThickness=1), Text(
          extent={{-18,52},{18,-44}},
          lineColor={255,0,0},
          lineThickness=1,
          textString="U"),
        Text(
          lineColor={0,0,255},
          extent={{-158,102},{142,142}},
          textString="%name")}),
                             Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,
            -240},{440,100}}),       graphics={
                  Polygon(
          points={{-72,-24},{-72,-24}},
          lineColor={28,108,200},
          lineThickness=1)}));
end WindowUnstableAlarm;
