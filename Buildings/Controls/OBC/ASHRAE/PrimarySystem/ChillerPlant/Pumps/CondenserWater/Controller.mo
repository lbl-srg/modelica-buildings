within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater;
block Controller "Condenser water pump controller"

  parameter Boolean isHeadered = true
    "Flag of headered condenser water pumps design: true=headered, false=dedicated";
  parameter Boolean haveWSE = true
    "Flag of waterside economizer: true=have WSE, false=no WSE";
  parameter Integer nChi=2 "Total number of chiller";
  parameter Integer totSta=6
    "Total number of stages, including the stages with a WSE, if applicable"
    annotation (Dialog(group="Stage design speed"));
  parameter Real staVec[totSta]={0,0.5,1,1.5,2,2.5}
    "Chiller stage vector, element value like x.5 means chiller stage x plus WSE"
    annotation (Dialog(group="Stage design speed"));
  parameter Real desConWatPumSpe[totSta]={0,0.5,0.75,0.6,0.75,0.9}
    "Design condenser water pump speed setpoints, the size should be doule of total stage numbers"
    annotation (Dialog(group="Stage design speed"));
  parameter Real desConWatPumNum[totSta]={0,1,1,2,2,2}
    "Design number of condenser water pumps that should be ON, the size should be doule of total stage numbers"
    annotation (Dialog(group="Stage design speed"));
  parameter Real relSpeDif = 0.05
    "Relative error to the setpoint for checking if it has achieved speed setpoint"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiConIsoVal[nChi]
    "Chiller condenser water isolation valve status"
    annotation (Placement(transformation(extent={{-160,120},{-120,160}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiEna
    "Lead chiller enabling status: true=lead chiller is enabled"
    annotation (Placement(transformation(extent={{-160,90},{-120,130}}),
      iconTransformation(extent={{-140,50},{-100,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiSta
    "Lead chiller status: true=lead chiller proven on"
    annotation (Placement(transformation(extent={{-160,60},{-120,100}}),
      iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaConWatReq
    "Status indicating if chiller is requesting condenser water"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage that does not include WSE"
    annotation (Placement(transformation(extent={{-160,-40},{-120,0}}),
      iconTransformation(extent={{-140,-30},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if haveWSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-160,-70},{-120,-30}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpeSet(
    final min=0,
    final max=1,
    final unit="1") "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{-160,-100},{-120,-60}}),
      iconTransformation(extent={{-140,-90},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-160,-130},{-120,-90}}),
      iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum
    "Lead pump status"
    annotation (Placement(transformation(extent={{120,110},{160,150}}),
      iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDesConWatPumSpe
    "Condenser water pump design speed at current stage"
    annotation (Placement(transformation(extent={{120,30},{160,70}}),
      iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yConWatPumNum
    "Number of operating condenser water pumps"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumSpeChe
    "Flag to indicate if pump speed achieve setpoint"
    annotation (Placement(transformation(extent={{120,-100},{160,-60}}),
      iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=1e-6,
    final k=1)
    "Add a small value to avoid zero denominator"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Continuous.Division div
    "Calculate the relative error"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_headered
    enaLeaHeaPum(final haveWSE=haveWSE) if isHeadered
    "Enable lead pumps for plants with headered condenser water pump"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_dedicated
    enaLeaDedPum if not isHeadered
    "Enable lead pumps for plants with dedicated condenser water pump"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Speed
    pumSpe(
    final haveWSE=haveWSE,
    final totSta=totSta,
    final staVec=staVec,
    final desConWatPumSpe=desConWatPumSpe,
    final desConWatPumNum=desConWatPumNum)
    "Design pump speed of condenser water pump at current stage"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback speDif
    "Calculate difference between speed setpoint and operating speed"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs "Absolute value"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=relSpeDif - 0.01,
    final uHigh=relSpeDif + 0.01)
    "Check if operating speed equals to setpoint"
    annotation (Placement(transformation(extent={{0,-130},{20,-110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{40,-130},{60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,32},{-40,52}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant zer1(final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,-18},{-40,2}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi "Real switch"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Buildings.Controls.OBC.CDL.Logical.IntegerSwitch intSwi "Integer switch"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Logical.And and2 "Logical and"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=false) if
       not haveWSE
    "Logical true"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));

equation
  connect(uWSE, enaLeaHeaPum.uWseConIsoVal)
    annotation (Line(points={{-140,-50},{6,-50},{6,126},{18,126}},
      color={255,0,255}));
  connect(enaLeaDedPum.uLeaChiSta, uLeaChiSta)
    annotation (Line(points={{18,70},{-100,70},{-100,80},{-140,80}}, color={255,0,255}));
  connect(enaLeaDedPum.uLeaConWatReq, uLeaConWatReq)
    annotation (Line(points={{18,62},{-80,62},{-80,40},{-140,40}},
      color={255,0,255}));
  connect(uWSE, pumSpe.uWSE)
    annotation (Line(points={{-140,-50},{6,-50},{6,-54},{18,-54}}, color={255,0,255}));
  connect(enaLeaHeaPum.yLea, yLeaPum)
    annotation (Line(points={{42,130},{140,130}}, color={255,0,255}));
  connect(enaLeaDedPum.yLea, yLeaPum)
    annotation (Line(points={{42,70},{50,70},{50,130},{140,130}}, color={255,0,255}));
  connect(uConWatPumSpe, speDif.u2)
    annotation (Line(points={{-140,-110},{-90,-110},{-90,-92}}, color={0,0,127}));
  connect(speDif.y, abs.u)
    annotation (Line(points={{-78,-80},{-62,-80}},   color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{22,-120},{38,-120}}, color={255,0,255}));
  connect(uChiSta, pumSpe.uChiSta)
    annotation (Line(points={{-140,-20},{-100,-20},{-100,-46},{18,-46}},
      color={255,127,0}));
  connect(swi.y,yDesConWatPumSpe)
    annotation (Line(points={{102,50},{140,50}}, color={0,0,127}));
  connect(enaLeaDedPum.yLea, swi.u2)
    annotation (Line(points={{42,70},{50,70},{50,50},{78,50}}, color={255,0,255}));
  connect(enaLeaHeaPum.yLea, swi.u2)
    annotation (Line(points={{42,130},{50,130},{50,50},{78,50}}, color={255,0,255}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-38,42},{78,42}}, color={0,0,127}));
  connect(enaLeaHeaPum.yLea, intSwi.u2)
    annotation (Line(points={{42,130},{50,130},{50,0},{78,0}}, color={255,0,255}));
  connect(enaLeaDedPum.yLea, intSwi.u2)
    annotation (Line(points={{42,70},{50,70},{50,0},{78,0}}, color={255,0,255}));
  connect(pumSpe.yConWatPumNum, intSwi.u1)
    annotation (Line(points={{42,-50},{68,-50},{68,8},{78,8}}, color={255,127,0}));
  connect(intSwi.y, yConWatPumNum)
    annotation (Line(points={{102,0},{140,0}}, color={255,127,0}));
  connect(zer1.y, intSwi.u3)
    annotation (Line(points={{-38,-8},{78,-8}}, color={255,127,0}));
  connect(and2.y, yPumSpeChe)
    annotation (Line(points={{102,-80},{140,-80}}, color={255,0,255}));
  connect(not1.y, and2.u2)
    annotation (Line(points={{62,-120},{70,-120},{70,-88},{78,-88}},
      color={255,0,255}));
  connect(enaLeaHeaPum.yLea, and2.u1)
    annotation (Line(points={{42,130},{50,130},{50,-80},{78,-80}}, color={255,0,255}));
  connect(enaLeaDedPum.yLea, and2.u1)
    annotation (Line(points={{42,70},{50,70},{50,-80},{78,-80}}, color={255,0,255}));
  connect(pumSpe.yDesConWatPumSpe, swi.u1)
    annotation (Line(points={{42,-44},{60,-44},{60,58},{78,58}}, color={0,0,127}));
  connect(uConWatPumSpeSet, speDif.u1)
    annotation (Line(points={{-140,-80},{-102,-80}},
      color={0,0,127}));
  connect(con.y, enaLeaHeaPum.uWseConIsoVal)
    annotation (Line(points={{-38,100},{-20,100},{-20,126},{18,126}},
      color={255,0,255}));
  connect(con.y, pumSpe.uWSE)
    annotation (Line(points={{-38,100},{-20,100},{-20,-54},{18,-54}},
      color={255,0,255}));
  connect(uLeaChiEna, enaLeaDedPum.uLeaChiEna)
    annotation (Line(points={{-140,110},{-80,110},{-80,78},{18,78}},
      color={255,0,255}));
  connect(enaLeaHeaPum.uChiConIsoVal, uChiConIsoVal)
    annotation (Line(points={{18,134},{-40,134},{-40,140},{-140,140}},
      color={255,0,255}));
  connect(uConWatPumSpeSet, addPar.u)
    annotation (Line(points={{-140,-80},{-110,-80},{-110,-140},{-102,-140}},
      color={0,0,127}));
  connect(addPar.y, div.u2)
    annotation (Line(points={{-78,-140},{-70,-140},{-70,-126},{-42,-126}},
      color={0,0,127}));
  connect(abs.y, div.u1)
    annotation (Line(points={{-38,-80},{-30,-80},{-30,-100},{-60,-100},{-60,-114},
      {-42,-114}}, color={0,0,127}));
  connect(div.y, hys.u)
    annotation (Line(points={{-18,-120},{-2,-120}}, color={0,0,127}));

annotation (
  defaultComponentName="conWatPumCon",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(extent={{-120,146},{100,108}},
          lineColor={0,0,255},
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
Central Plants and Hydronic Systems (Draft 6 on July 25, 2019), 
section 5.2.9 Condenser water pumps. 
</p>
<p>
This sequence contains three subsequences:
</p>
<ul>
<li>
Enabling and disabling lead pump should be controlled based on weather the pumps
are configurated as headered or dedicated. If it is headered, 
<code>isHeadered</code> = true, then use block <code>enaLeaHeaPum</code>. See
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
<p>
Note that this sequence is for plants with variable speed condenser water pumps and
they are equally sized.
</p>
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
