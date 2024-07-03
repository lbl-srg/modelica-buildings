within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure;
block Controller "Head pressure controller for plants with headered condenser water pumps"
  parameter Boolean have_heaPreConSig = false
    "Flag indicating if there is head pressure control signal from chiller controller"
    annotation (Dialog(group="Plant"));
  parameter Boolean have_WSE=true
    "True if the plant has waterside economizer. When the plant has waterside economizer, the condenser water pump speed must be variable"
    annotation (Dialog(group="Plant"));
  parameter Boolean have_fixSpeConWatPum=false
    "Flag indicating if the plant has fixed speed condenser water pumps"
    annotation (Dialog(group="Plant", enable=not have_WSE));
  parameter Real minTowSpe=0.1
    "Minimum cooling tower fan speed"
    annotation (Dialog(group="Setpoints"));
  parameter Real minConWatPumSpe=0.1
    "Minimum condenser water pump speed"
    annotation (Dialog(group="Setpoints", enable= not ((not have_WSE) and have_fixSpeConWatPum)));
  parameter Real minHeaPreValPos=0.1
    "Minimum head pressure control valve position"
    annotation (Dialog(group="Setpoints", enable= (not ((not have_WSE) and (not have_fixSpeConWatPum)))));
  parameter Real minChiLif=10
    "Minimum allowable lift at minimum load for chiller"
    annotation (Dialog(tab="Loop signal", enable=not have_heaPreConSig));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(tab="Loop signal", group="PID controller", enable=not have_heaPreConSig));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(tab="Loop signal", group="PID controller", enable=not have_heaPreConSig));
  parameter Real Ti(
    final unit="s",
    final quantity="Time")=0.5 "Time constant of integrator block"
    annotation (Dialog(tab="Loop signal", group="PID controller",
                       enable= not have_heaPreConSig
                               and (controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                                 or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real Td(
    final unit="s",
    final quantity="Time")=0.5
    "Time constant of derivative block"
    annotation (Dialog(tab="Loop signal", group="PID controller",
                       enable= not have_heaPreConSig
                               and (controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                                 or controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiHeaCon
    "Chillers head pressure control status: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not have_heaPreConSig
    "Measured condenser water return temperature (condenser leaving)"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not have_heaPreConSig
    "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput desConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") if not have_fixSpeConWatPum
    "Design condenser water pump speed for current stage"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE
    if have_WSE and (not have_fixSpeConWatPum)
    "Status of water side economizer: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaPreCon(
    final min=0,
    final max=1,
    final unit="1") if have_heaPreConSig
    "Chiller head pressure control loop signal from chiller controller"
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMaxTowSpeSet(
    final min=0,
    final max=1,
    final unit="1")  "Maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaPreConVal(
    final min=0,
    final max=1,
    final unit="1") if have_WSE or ((not have_WSE) and have_fixSpeConWatPum)
    "Head pressure control valve position"
    annotation (Placement(transformation(extent={{100,10},{140,50}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpeSet(
    final min=0,
    final max=1,
    final unit="1") if not have_fixSpeConWatPum
    "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{100,-30},{140,10}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.ControlLoop
    chiHeaPreLoo(
    final minChiLif=minChiLif,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td) if not have_heaPreConSig
    "Generate chiller head pressure control loop signal"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithoutWSE
    noWSE(
    final have_fixSpeConWatPum=have_fixSpeConWatPum,
    final minTowSpe=minTowSpe,
    final minConWatPumSpe=minConWatPumSpe,
    final minHeaPreValPos=minHeaPreValPos) if not have_WSE
    "Controlling equipments for plants without waterside economizer"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithWSE
    withWSE(
    final minTowSpe=minTowSpe,
    final minConWatPumSpe=minConWatPumSpe,
    final minHeaPreValPos=minHeaPreValPos) if have_WSE and (not have_fixSpeConWatPum)
    "Controlling equipments for plants with waterside economizer"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Switch swi if have_heaPreConSig
    "Head pressure control from chiller controller"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=0) if have_heaPreConSig "Constant"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMes1(
    final message="If the plant has waterside economizer, the condenser water pump cannot be fix speed.")
    "Generate alert if the plant has waterside economizer and the condenser water pump has fix speed"
    annotation (Placement(transformation(extent={{60,-110},{80,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant havWSE(
    final k=have_WSE)
    "Have waterside economizer"
    annotation (Placement(transformation(extent={{-60,-100},{-40,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fixSpe(
    final k=have_fixSpeConWatPum)
    "Fix speed condenser water pump"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Buildings.Controls.OBC.CDL.Logical.And fixSpeWSE
    "The plant has waterside economizer and the condenser water pump is fix speed"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre "Break loop"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));

equation
  connect(chiHeaPreLoo.TConWatRet, TConWatRet)
    annotation (Line(points={{-22,90},{-120,90}}, color={0,0,127}));
  connect(chiHeaPreLoo.TChiWatSup, TChiWatSup)
    annotation (Line(points={{-22,82},{-60,82},{-60,60},{-120,60}}, color={0,0,127}));
  connect(chiHeaPreLoo.yHeaPreCon, noWSE.uHeaPreCon)
    annotation (Line(points={{2,90},{20,90},{20,58},{38,58}}, color={0,0,127}));
  connect(chiHeaPreLoo.yHeaPreCon, withWSE.uHeaPreCon)
    annotation (Line(points={{2,90},{20,90},{20,-2},{38,-2}},   color={0,0,127}));
  connect(withWSE.uWSE, uWSE)
    annotation (Line(points={{38,-14},{-20,-14},{-20,0},{-120,0}},
      color={255,0,255}));
  connect(uHeaPreCon, swi.u1)
    annotation (Line(points={{-120,-30},{-60,-30},{-60,-32},{-22,-32}},
      color={0,0,127}));
  connect(con.y, swi.u3)
    annotation (Line(points={{-58,-60},{-40,-60},{-40,-48},{-22,-48}},
      color={0,0,127}));
  connect(swi.y, noWSE.uHeaPreCon)
    annotation (Line(points={{2,-40},{20,-40},{20,58},{38,58}},   color={0,0,127}));
  connect(swi.y, withWSE.uHeaPreCon)
    annotation (Line(points={{2,-40},{20,-40},{20,-2},{38,-2}},     color={0,0,127}));
  connect(noWSE.yMaxTowSpeSet, yMaxTowSpeSet)
    annotation (Line(points={{62,56},{80,56},{80,80},{120,80}}, color={0,0,127}));
  connect(withWSE.yHeaPreConVal, yHeaPreConVal)
    annotation (Line(points={{62,-16},{90,-16},{90,30},{120,30}}, color={0,0,127}));
  connect(withWSE.yMaxTowSpeSet, yMaxTowSpeSet)
    annotation (Line(points={{62,-4},{80,-4},{80,80},{120,80}},   color={0,0,127}));
  connect(withWSE.yConWatPumSpeSet, yConWatPumSpeSet)
    annotation (Line(points={{62,-10},{120,-10}}, color={0,0,127}));
  connect(desConWatPumSpe, withWSE.desConWatPumSpe)
    annotation (Line(points={{-120,30},{0,30},{0,-6},{38,-6}},   color={0,0,127}));
  connect(noWSE.yConWatPumSpeSet, yConWatPumSpeSet)
    annotation (Line(points={{62,42},{70,42},{70,-10},{120,-10}}, color={0,0,127}));
  connect(noWSE.yHeaPreConVal, yHeaPreConVal)
    annotation (Line(points={{62,46},{90,46},{90,30},{120,30}}, color={0,0,127}));
  connect(desConWatPumSpe, noWSE.desConWatPumSpe)
    annotation (Line(points={{-120,30},{0,30},{0,50},{38,50}}, color={0,0,127}));
  connect(havWSE.y, fixSpeWSE.u1) annotation (Line(points={{-38,-90},{-30,-90},{
          -30,-100},{-22,-100}}, color={255,0,255}));
  connect(fixSpe.y, fixSpeWSE.u2) annotation (Line(points={{-38,-120},{-30,-120},
          {-30,-108},{-22,-108}}, color={255,0,255}));
  connect(fixSpeWSE.y, not1.u)
    annotation (Line(points={{2,-100},{18,-100}}, color={255,0,255}));
  connect(not1.y, assMes1.u)
    annotation (Line(points={{42,-100},{58,-100}}, color={255,0,255}));
  connect(uChiHeaCon, pre.u)
    annotation (Line(points={{-120,120},{-82,120}}, color={255,0,255}));
  connect(pre.y, swi.u2) annotation (Line(points={{-58,120},{-40,120},{-40,-40},
          {-22,-40}}, color={255,0,255}));
  connect(pre.y, chiHeaPreLoo.uHeaPreEna) annotation (Line(points={{-58,120},{-40,
          120},{-40,98},{-22,98}}, color={255,0,255}));
  connect(pre.y, noWSE.uHeaPreEna) annotation (Line(points={{-58,120},{-40,120},
          {-40,42},{38,42}}, color={255,0,255}));
  connect(pre.y, withWSE.uHeaPreEna) annotation (Line(points={{-58,120},{-40,120},
          {-40,-18},{38,-18}}, color={255,0,255}));
annotation (
  defaultComponentName="heaPreCon",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
       graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
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
          extent={{-100,-140},{100,140}})),
  Documentation(info="<html>
<p>
Block that generates control signals for chiller head pressure control,
according to ASHRAE Guideline36-2021, section 5.20.10 Head pressure control.
</p>
<p>
Note that if a plant has waterside economizer, the condenser water pump must be
variable speed.
</p>
<p>
This sequence contains three subsequences:
</p>
<ul>
<li>
First, if the head pressure control signal <code>uHeaPreCon</code> is not
available from the chiller controller. The signal will be generated by block
<code>chiHeaPreLoo</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.ControlLoop\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.ControlLoop</a>
for a description.
</li>
<li>
If the chiller plant does not have waterside economizer, block <code>noWSE</code>
will be used for controlling maximum cooling tower speed setpoint
<code>yMaxTowSpeSet</code> and, whether the plant has constant speed condenser
water pump or not, resetting head pressure control valve position
<code>yHeaPreConVal</code> when <code>have_fixSpeConWatPum</code>=true, or resetting condenser
water pump speed <code>yConWatPumSpeSet</code> when <code>have_fixSpeConWatPum</code>=false. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithoutWSE\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithoutWSE</a>
for a description.
</li>
<li>
If the chiller plant has waterside economizer, block <code>withWSE</code>
will be used for specifying <code>yMaxTowSpeSet</code>, <code>yHeaPreConVal</code> and
condenser water pump speed <code>yConWatPumSpeSet</code>. See
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithWSE\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithWSE</a>
for a description.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
January 30, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
