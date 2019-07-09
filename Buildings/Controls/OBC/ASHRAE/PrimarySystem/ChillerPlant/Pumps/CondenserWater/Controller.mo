within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater;
block Controller "Condenser water pump controller"

  parameter Boolean isHeadered = true
    "Flag of headered condenser water pumps design: true=headered, false=dedicated";
  parameter Boolean haveWSE = true
    "Flag of waterside economizer: true=have WSE, false=no WSE";
  parameter Integer nSta = 3
    "Total number of stages, zero stage should be counted as one stage";
  parameter Real chiNum[nSta] = {0, 1, 2}
    "Vector of number of operating chillers at each stage";
  parameter Integer nChi=2 "Total number of chiller"
    annotation (Dialog(group="No waterside economizer", enable=not haveWSE));
  parameter Real conWatPumSpeSet_noWse[nChi + 1]={0,0.5,0.75}
    "Vector of condenser water pump speed setpoint, the size should be total number of chiller plus one. number of operating pumps matchs number of operating chillers"
    annotation (Dialog(group="No waterside economizer", enable=not haveWSE));
  parameter Real conWatPumSpeSet_haveWse[2*nSta]={0,0.5,0.75,0.6,0.75,0.9}
    "Vector of condenser water pump speed setpoint, the size should be doule of total stage numbers"
    annotation (Dialog(group="Have waterside economizer", enable=haveWSE));
  parameter Real conWatPumOnSet[2*nSta]={0,1,1,2,2,2}
    "Vector of number of condenser water pumps that should be ON, the size should be doule of total stage numbers"
    annotation (Dialog(group="Have waterside economizer", enable=haveWSE));
  parameter Real uLow = 0.005 "if y=true and u<uLow, switch to y=false"
    annotation (Dialog(group="Speed equality check"));
  parameter Real uHigh = 0.015 "if y=false and u>uHigh, switch to y=true"
    annotation (Dialog(group="Speed equality check"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-160,50},{-120,90}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if haveWSE
    "Water side economizer status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-160,-50},{-120,-10}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaChiOn
    "Lead chiller status: true=lead chiller proven on"
    annotation (Placement(transformation(extent={{-160,20},{-120,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLeaConWatReq
    "Status indicating if chiller is requesting condenser water"
    annotation (Placement(transformation(extent={{-160,-10},{-120,30}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-160,-120},{-120,-80}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPum
    "Lead pump status"
    annotation (Placement(transformation(extent={{120,70},{140,90}}),
      iconTransformation(extent={{100,80},{120,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpeSet
    "Condenser water pump speed"
    annotation (Placement(transformation(extent={{120,-4},{140,16}}),
      iconTransformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yConWatPumNum
    "Number of operating condenser water pumps"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}}),
      iconTransformation(extent={{100,-40},{120,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPumSpeChe
    "Flag to indicate if pump speed achieve setpoint"
    annotation (Placement(transformation(extent={{120,-90},{140,-70}}),
        iconTransformation(extent={{100,-100},{120,-80}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_headered
    enaLeaHeaPum if isHeadered
    "Enable lead pumps for plants with headered condenser water pump"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.EnableLead_dedicated
    enaLeaDedPum if not isHeadered
    "Enable lead pumps for plants with dedicated condenser water pump"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Speed_noWSE
    pumSpeNoWse(
    final nChi=nChi,
    final conWatPumSpeSet=conWatPumSpeSet_noWse) if not haveWSE
    "Operating speed of condenser water pump for plants without waterside economizer"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pumps.CondenserWater.Subsequences.Speed_haveWSE
    pumSpeWitWse(
    final nSta=nSta,
    final conWatPumSpeSet=conWatPumSpeSet_haveWse,
    final conWatPumOnSet=conWatPumOnSet) if haveWSE
    "Operating speed of condenser water pump for plants with waterside economizer"
    annotation (Placement(transformation(extent={{40,-50},{60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=0.5)
    "Check if there is any chiller operating"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt if not haveWSE
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[nSta](
    final k=chiNum)
    "Number of operating chillers at each stage"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor curOpeChi(
    final nin=nSta)
    "Current number of operating chillers"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Feedback speDif
    "Calculate difference between speed setpoint and operating speed"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs "Absolute value"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=uLow,
    final uHigh=uHigh)
    "Check if operating speed equals to setpoint"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));

equation
  connect(con.y, curOpeChi.u)
    annotation (Line(points={{-79,100},{-62,100}}, color={0,0,127}));
  connect(uChiSta, curOpeChi.index)
    annotation (Line(points={{-140,70},{-50,70},{-50,88}}, color={255,127,0}));
  connect(curOpeChi.y, greEquThr.u)
    annotation (Line(points={{-39,100},{-22,100}}, color={0,0,127}));
  connect(uWSE, enaLeaHeaPum.uWseConIsoVal)
    annotation (Line(points={{-140,-30},{10,-30},{10,76},{38,76}},
      color={255,0,255}));
  connect(greEquThr.y, enaLeaHeaPum.uChiConIsoVal)
    annotation (Line(points={{1,100},{20,100},{20,84},{38,84}},
      color={255,0,255}));
  connect(greEquThr.y, enaLeaDedPum.uLeaChiEna)
    annotation (Line(points={{1,100},{20,100},{20,48},{38,48}},
      color={255,0,255}));
  connect(enaLeaDedPum.uLeaChiOn, uLeaChiOn)
    annotation (Line(points={{38,40},{-140,40}}, color={255,0,255}));
  connect(enaLeaDedPum.uLeaConWatReq, uLeaConWatReq)
    annotation (Line(points={{38,32},{-100,32},{-100,10},{-140,10}},
      color={255,0,255}));
  connect(uWSE, pumSpeWitWse.uWSE)
    annotation (Line(points={{-140,-30},{10,-30},{10,-44},{38,-44}},
      color={255,0,255}));
  connect(uChiSta, pumSpeWitWse.uChiSta)
    annotation (Line(points={{-140,70},{-50,70},{-50,-36},{38,-36}},
      color={255,127,0}));
  connect(curOpeChi.y, reaToInt.u)
    annotation (Line(points={{-39,100},{-30,100},{-30,0},{-22,0}},
      color={0,0,127}));
  connect(reaToInt.y, pumSpeNoWse.uOpeChiNum)
    annotation (Line(points={{1,0},{38,0}},     color={255,127,0}));
  connect(enaLeaHeaPum.yLeaPum, yLeaPum)
    annotation (Line(points={{61,80},{130,80}}, color={255,0,255}));
  connect(enaLeaDedPum.yLeaPum, yLeaPum)
    annotation (Line(points={{61,40},{80,40},{80,80},{130,80}},
      color={255,0,255}));
  connect(pumSpeNoWse.yConWatPumSpeSet, yConWatPumSpeSet)
    annotation (Line(points={{61,6},{130,6}}, color={0,0,127}));
  connect(pumSpeWitWse.yConWatPumSpeSet, yConWatPumSpeSet)
    annotation (Line(points={{61,-34},{80,-34},{80,6},{130,6}},
      color={0,0,127}));
  connect(pumSpeWitWse.yConWatPumNum, yConWatPumNum)
    annotation (Line(points={{61,-40},{130,-40}}, color={255,127,0}));
  connect(pumSpeNoWse.yConWatPumNum, yConWatPumNum)
    annotation (Line(points={{61,0},{100,0},{100,-40},{130,-40}},
      color={255,127,0}));
  connect(uConWatPumSpe, speDif.u2)
    annotation (Line(points={{-140,-100},{-70,-100},{-70,-92}}, color={0,0,127}));
  connect(pumSpeNoWse.yConWatPumSpeSet, speDif.u1)
    annotation (Line(points={{61,6},{80,6},{80,-60},{-100,-60},{-100,-80},
      {-82,-80}}, color={0,0,127}));
  connect(pumSpeWitWse.yConWatPumSpeSet, speDif.u1)
    annotation (Line(points={{61,-34},{80,-34},{80,-60},{-100,-60},{-100,-80},
      {-82,-80}}, color={0,0,127}));
  connect(speDif.y, abs.u)
    annotation (Line(points={{-59,-80},{-42,-80}}, color={0,0,127}));
  connect(abs.y, hys.u)
    annotation (Line(points={{-19,-80},{-2,-80}}, color={0,0,127}));
  connect(hys.y, not1.u)
    annotation (Line(points={{21,-80},{38,-80}}, color={255,0,255}));
  connect(not1.y, yPumSpeChe)
    annotation (Line(points={{61,-80},{130,-80}}, color={255,0,255}));

annotation (
  defaultComponentName="conWatPumCon",
  Icon(graphics={
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
          extent={{-120,-120},{120,120}})),
  Documentation(info="<html>
<p>
Block that generates control signals for condenser water pumps control, 
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019), 
section 5.2.9 Condenser water pumps. 
</p>
<p>
This sequence contains four subsequences:
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
The operating speed <code>yConWatPumSpe</code> and number of operating pumps
<code>yConWatPumNum</code> should be controlled based on whether the plant has 
waterside economizer or not (<code>haveWSE</code>). When it has economizer, then 
use block <code>pumSpeWitWse</code>. See 
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.Speed_haveWSE\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.Speed_haveWSE</a>
for a description. Otherwise, use block <code>pumSpeNoWse</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.Speed_noWSE\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Pump.CondenserWaterP.Subsequences.Speed_noWSE</a>
for a description.
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
