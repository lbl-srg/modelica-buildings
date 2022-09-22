within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater;
block Controller "Condenser water pump controller"

  parameter Boolean have_heaPum = true
    "Flag of headered condenser water pumps design: true=headered, false=dedicated";
  parameter Boolean have_WSE = true
    "Flag of waterside economizer: true=have WSE, false=no WSE";
  parameter Boolean fixSpe = false
    "Flag to indicate if the plant has fix speed condenser water pump";
  parameter Integer nChi=2 "Total number of chillers";
  parameter Integer nConWatPum=2 "Total number of condenser water pumps";
  parameter Integer totSta=6
    "Total number of plant stages, including stage zero and the stages with a WSE, if applicable"
    annotation (Dialog(group="Stage design speed"));
  parameter Integer nChiSta = 3
    "Total number of chiller stages, including stage zero but not the stages with a WSE, if applicable";
  parameter Real staVec[totSta]={0,0.5,1,1.5,2,2.5}
    "Chiller stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(group="Stage design speed"));
  parameter Real desConWatPumSpe[totSta]={0,0.5,0.75,0.6,0.75,0.9}
    "Design condenser water pump speed setpoints, according to current chiller stage and WSE status"
    annotation (Dialog(group="Stage design speed"));
  parameter Real desConWatPumNum[totSta]={0,1,1,2,2,2}
    "Design number of condenser water pumps that should be ON, according to current chiller stage and WSE status"
    annotation (Dialog(group="Stage design speed"));
  parameter Real desChiNum[nChiSta]={0,1,2}
    "Design number of chiller that should be ON, according to current chiller stage"
    annotation (Dialog(group="Stage design speed", enable=fixSpe));
  parameter Real pumSpeChe = 0.05
    "Lower threshold value to check if condenser water pump has achieved setpoint";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiConIsoVal[nChi]
    "Chiller condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-160,130},{-120,170}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiEna
    "Lead chiller enabling status: true=lead chiller is enabled"
    annotation (Placement(transformation(extent={{-160,100},{-120,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiSta
    "Lead chiller status: true=lead chiller proven on"
    annotation (Placement(transformation(extent={{-162,70},{-122,110}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaConWatReq
    "Status indicating if chiller is requesting condenser water"
    annotation (Placement(transformation(extent={{-162,40},{-122,80}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEnaPla
    "True: plant is just enabled"
    annotation(Placement(transformation(extent={{-160,10},{-120,50}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage that does not include WSE"
    annotation (Placement(transformation(extent={{-160,-26},{-120,14}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if have_WSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-160,-60},{-120,-20}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpeSet(
    final min=0,
    final max=1,
    final unit="1") if not fixSpe
    "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{-160,-90},{-120,-50}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") if not fixSpe
    "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-160,-130},{-120,-90}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[nConWatPum] if fixSpe
    "Status indicating if condenser water pump is running"
    annotation (Placement(transformation(extent={{-160,-160},{-120,-120}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum
    "Lead pump status setpoint"
    annotation (Placement(transformation(extent={{120,110},{160,150}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDesConWatPumSpe
    if not fixSpe
    "Condenser water pump design speed at current stage"
    annotation (Placement(transformation(extent={{120,40},{160,80}}),
      iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yConWatPumNum
    "Number of operating condenser water pumps"
    annotation (Placement(transformation(extent={{120,0},{160,40}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumSpeChe
    "Flag to indicate if pump speed achieves setpoint"
    annotation (Placement(transformation(extent={{120,-70},{160,-30}}),
      iconTransformation(extent={{100,-110},{140,-70}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_headered
    enaLeaHeaPum(final have_WSE=have_WSE) if have_heaPum
    "Enable lead pumps for plants with headered condenser water pump"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_dedicated
    enaLeaDedPum if not have_heaPum
    "Enable lead pumps for plants with dedicated condenser water pump"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Speed
    pumSpe(
    final have_WSE=have_WSE,
    final fixSpe=fixSpe,
    final totSta=totSta,
    final nChiSta=nChiSta,
    final staVec=staVec,
    final desConWatPumSpe=desConWatPumSpe,
    final desConWatPumNum=desConWatPumNum,
    final desChiNum=desChiNum)
    "Design pump speed of condenser water pump at current stage"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract speDif if not fixSpe
    "Calculate difference between speed setpoint and operating speed"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs if not fixSpe
    "Absolute difference"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(final uLow=pumSpeChe,
      final uHigh=2*pumSpeChe)    if not fixSpe
    "Check if operating speed equals to setpoint"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 if not fixSpe
    "Logical not"
    annotation (Placement(transformation(extent={{40,-100},{60,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    if not fixSpe
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,42},{-40,62}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zer1(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,2},{-40,22}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi if not fixSpe
    "Real switch"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Controls.OBC.CDL.Integers.Switch intSwi "Integer switch"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{80,-60},{100,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) if not have_WSE
    "Logical true"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nConWatPum] if fixSpe
    "Convert boolean to integer"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nConWatPum) if fixSpe
    "Calculate total number of pumps that are running"
    annotation (Placement(transformation(extent={{-40,-150},{-20,-130}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu if fixSpe
    "Check if total number of running pumps are equal to setpoint"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));

equation
  connect(uWSE, enaLeaHeaPum.uWseConIsoVal)
    annotation (Line(points={{-140,-40},{0,-40},{0,130},{18,130}},
      color={255,0,255}));
  connect(enaLeaDedPum.uLeaChiSta, uLeaChiSta)
    annotation (Line(points={{18,76},{-90,76},{-90,90},{-142,90}}, color={255,0,255}));
  connect(enaLeaDedPum.uLeaConWatReq, uLeaConWatReq)
    annotation (Line(points={{18,72},{-80,72},{-80,60},{-142,60}},
      color={255,0,255}));
  connect(uWSE, pumSpe.uWSE)
    annotation (Line(points={{-140,-40},{0,-40},{0,-14},{18,-14}}, color={255,0,255}));
  connect(enaLeaHeaPum.yLea, yLeaPum)
    annotation (Line(points={{42,130},{140,130}}, color={255,0,255}));
  connect(enaLeaDedPum.yLea, yLeaPum)
    annotation (Line(points={{42,80},{50,80},{50,130},{140,130}}, color={255,0,255}));
  connect(speDif.y, abs.u)
    annotation (Line(points={{-58,-90},{-42,-90}},   color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{22,-90},{38,-90}},   color={255,0,255}));
  connect(uChiSta, pumSpe.uChiSta)
    annotation (Line(points={{-140,-6},{18,-6}},
      color={255,127,0}));
  connect(swi.y,yDesConWatPumSpe)
    annotation (Line(points={{102,60},{140,60}}, color={0,0,127}));
  connect(enaLeaDedPum.yLea, swi.u2)
    annotation (Line(points={{42,80},{50,80},{50,60},{78,60}}, color={255,0,255}));
  connect(enaLeaHeaPum.yLea, swi.u2)
    annotation (Line(points={{42,130},{50,130},{50,60},{78,60}}, color={255,0,255}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-38,52},{78,52}}, color={0,0,127}));
  connect(enaLeaHeaPum.yLea, intSwi.u2)
    annotation (Line(points={{42,130},{50,130},{50,20},{78,20}}, color={255,0,255}));
  connect(enaLeaDedPum.yLea, intSwi.u2)
    annotation (Line(points={{42,80},{50,80},{50,20},{78,20}}, color={255,0,255}));
  connect(pumSpe.yConWatPumNum, intSwi.u1)
    annotation (Line(points={{42,-10},{68,-10},{68,28},{78,28}}, color={255,127,0}));
  connect(intSwi.y, yConWatPumNum)
    annotation (Line(points={{102,20},{140,20}}, color={255,127,0}));
  connect(zer1.y, intSwi.u3)
    annotation (Line(points={{-38,12},{78,12}}, color={255,127,0}));
  connect(and2.y, yPumSpeChe)
    annotation (Line(points={{102,-50},{140,-50}}, color={255,0,255}));
  connect(not1.y, and2.u2)
    annotation (Line(points={{62,-90},{70,-90},{70,-58},{78,-58}},
      color={255,0,255}));
  connect(enaLeaHeaPum.yLea, and2.u1)
    annotation (Line(points={{42,130},{50,130},{50,-50},{78,-50}}, color={255,0,255}));
  connect(enaLeaDedPum.yLea, and2.u1)
    annotation (Line(points={{42,80},{50,80},{50,-50},{78,-50}}, color={255,0,255}));
  connect(pumSpe.yDesConWatPumSpe, swi.u1)
    annotation (Line(points={{42,-4},{60,-4},{60,68},{78,68}},   color={0,0,127}));
  connect(con.y, enaLeaHeaPum.uWseConIsoVal)
    annotation (Line(points={{-38,110},{-20,110},{-20,130},{18,130}},
      color={255,0,255}));
  connect(con.y, pumSpe.uWSE)
    annotation (Line(points={{-38,110},{-20,110},{-20,-14},{18,-14}},
      color={255,0,255}));
  connect(uLeaChiEna, enaLeaDedPum.uLeaChiEna)
    annotation (Line(points={{-140,120},{-80,120},{-80,84},{18,84}},
      color={255,0,255}));
  connect(enaLeaHeaPum.uChiConIsoVal, uChiConIsoVal) annotation (Line(points={{18,136},
          {-40,136},{-40,150},{-140,150}},         color={255,0,255}));
  connect(uConWatPum, booToInt.u)
    annotation (Line(points={{-140,-140},{-102,-140}}, color={255,0,255}));
  connect(booToInt.y, mulSumInt.u)
    annotation (Line(points={{-78,-140},{-42,-140}}, color={255,127,0}));
  connect(mulSumInt.y, intEqu.u2) annotation (Line(points={{-18,-140},{20,-140},
          {20,-128},{38,-128}}, color={255,127,0}));
  connect(intSwi.y, intEqu.u1) annotation (Line(points={{102,20},{110,20},{110,-30},
          {30,-30},{30,-120},{38,-120}}, color={255,127,0}));
  connect(intEqu.y, and2.u2) annotation (Line(points={{62,-120},{70,-120},{70,-58},
          {78,-58}}, color={255,0,255}));
  connect(abs.y, hys.u) annotation (Line(points={{-18,-90},{-2,-90}},
                    color={0,0,127}));
  connect(uConWatPumSpeSet, speDif.u1) annotation (Line(points={{-140,-70},{-100,
          -70},{-100,-84},{-82,-84}}, color={0,0,127}));
  connect(uConWatPumSpe, speDif.u2) annotation (Line(points={{-140,-110},{-100,-110},
          {-100,-96},{-82,-96}}, color={0,0,127}));
  connect(uEnaPla, enaLeaHeaPum.uEnaPla) annotation (Line(points={{-140,30},{10,
          30},{10,124},{18,124}}, color={255,0,255}));
  connect(uEnaPla, enaLeaDedPum.uEnaPla) annotation (Line(points={{-140,30},{10,
          30},{10,88},{18,88}}, color={255,0,255}));

annotation (Dialog(tab="Advanced"),
  defaultComponentName="conWatPumCon",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,60},{82,-60}},
          lineColor={28,108,200},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Polygon(
          points={{-80,60},{-14,4},{-80,-60},{-80,60}},
          lineColor={175,175,175},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-120,-160},{120,160}})),
  Documentation(info="<html>
<p>
Block that generates control signals for condenser water pumps control, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft on March 23, 2020), 
section 5.2.9 Condenser water pumps. 
</p>
<p>
This sequence contains three subsequences:
</p>
<ul>
<li>
Enabling and disabling lead pump should be controlled based on weather the pumps
are configurated as headered or dedicated. If it is headered, 
<code>have_heaPum</code> = true, then use block <code>enaLeaHeaPum</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.EnableLead_headered\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.EnableLead_headered</a>
for a description. Otherwise, use block <code>enaLeaDedPum</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.EnableLead_dedicated\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.EnableLead_dedicated</a>
for a description.
</li>
<li>
The design pump speed at current stage <code>yDesConWatPumSpe</code> and number of 
operating pumps <code>yConWatPumNum</code> should be output from block 
<code>pumSpe</code>. See 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Speed\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Speed</a>
for a description. 
</li>
<li>
The last section of the sequence is to check if current pump speed is running on
the setpoint.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
Febuary 4, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
