within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure;
block Controller "Head pressure controller"
  parameter Real minTowSpe=0.1 "Minimum cooling tower fan speed";
  parameter Real minConWatPumSpe=0.1 "Minimum condenser water pump speed"
    annotation (Dialog(enable= not ((not have_WSE) and fixSpePum)));
  parameter Real minHeaPreValPos=0.1 "Minimum head pressure control valve position"
    annotation (Dialog(enable= (not ((not have_WSE) and (not fixSpePum)))));
  parameter Boolean have_HeaPreConSig = false
    "Flag indicating if there is head pressure control signal from chiller controller"
    annotation (Dialog(group="Plant"));
  parameter Boolean have_WSE = true
    "Flag indicating if the plant has waterside economizer"
    annotation (Dialog(group="Plant"));
  parameter Boolean fixSpePum = true
    "Flag indicating if the plant has fixed speed condenser water pumps"
    annotation (Dialog(group="Plant", enable=not have_WSE));
  parameter Modelica.SIunits.TemperatureDifference minChiLif=10
    "Minimum allowable lift at minimum load for chiller"
    annotation (Dialog(tab="Loop signal", enable=not have_HeaPreConSig));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Loop signal", group="PID controller", enable=not have_HeaPreConSig));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(tab="Loop signal", group="PID controller", enable=not have_HeaPreConSig));
  parameter Real Ti(
    final unit="s",
    final quantity="Time")=0.5 "Time constant of integrator block"
    annotation (Dialog(tab="Loop signal", group="PID controller", enable=not have_HeaPreConSig));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaPreEna
    "Status of head pressure control: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not have_HeaPreConSig
    "Measured condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") if not have_HeaPreConSig
    "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput desConWatPumSpe(
    final min=0,
    final max=1,
    final unit="1") if not ((not have_WSE) and fixSpePum)
    "Design condenser water pump speed for current stage"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWSE if have_WSE
    "Status of water side economizer: true = ON, false = OFF"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHeaPreCon(
    final min=0,
    final max=1,
    final unit="1") if have_HeaPreConSig
    "Chiller head pressure control loop signal from chiller controller"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMaxTowSpeSet(
    final min=0,
    final max=1,
    final unit="1")  "Maximum cooling tower speed setpoint"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaPreConVal(
    final min=0,
    final max=1,
    final unit="1") if not ((not have_WSE) and not fixSpePum)
    "Head pressure control valve position"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yConWatPumSpeSet(
    final min=0,
    final max=1,
    final unit="1") if not ((not have_WSE) and fixSpePum)
    "Condenser water pump speed setpoint"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}),
      iconTransformation(extent={{100,-70},{120,-50}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.ControlLoop
    chiHeaPreLoo(
    final minChiLif=minChiLif,
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti) if not have_HeaPreConSig
    "Generate chiller head pressure control loop signal"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithoutWSE
    noWSE(
    final fixSpePum=fixSpePum,
    final minTowSpe=minTowSpe,
    final minConWatPumSpe=minConWatPumSpe,
    final minHeaPreValPos=minHeaPreValPos) if not have_WSE
    "Controlling equipments for plants without waterside economizer"
    annotation (Placement(transformation(extent={{40,42},{60,62}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.HeadPressure.Subsequences.MappingWithWSE
    withWSE(
    final minTowSpe=minTowSpe,
    final minConWatPumSpe=minConWatPumSpe,
    final minHeaPreValPos=minHeaPreValPos) if have_WSE
    "Controlling equipments for plants with waterside economizer"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Switch swi if have_HeaPreConSig
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0) if have_HeaPreConSig "Constant"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));

equation
  connect(chiHeaPreLoo.TConWatRet, TConWatRet)
    annotation (Line(points={{-22,90},{-120,90}}, color={0,0,127}));
  connect(chiHeaPreLoo.TChiWatSup, TChiWatSup)
    annotation (Line(points={{-22,82},{-40,82},{-40,60},{-120,60}}, color={0,0,127}));
  connect(chiHeaPreLoo.uHeaPreEna, uHeaPreEna)
    annotation (Line(points={{-22,98},{-80,98},{-80,120},{-120,120}},
      color={255,0,255}));
  connect(chiHeaPreLoo.yHeaPreCon, noWSE.uHeaPreCon)
    annotation (Line(points={{1,90},{20,90},{20,60},{38,60}}, color={0,0,127}));
  connect(chiHeaPreLoo.yHeaPreCon, withWSE.uHeaPreCon)
    annotation (Line(points={{1,90},{20,90},{20,-22},{38,-22}}, color={0,0,127}));
  connect(uHeaPreEna, noWSE.uHeaPreEna)
    annotation (Line(points={{-120,120},{-80,120},{-80,44},{38,44}},
      color={255,0,255}));
  connect(withWSE.uWSE, uWSE)
    annotation (Line(points={{38,-34},{-20,-34},{-20,-20},{-120,-20}},
      color={255,0,255}));
  connect(uHeaPreEna, withWSE.uHeaPreEna)
    annotation (Line(points={{-120,120},{-80,120},{-80,-38},{38,-38}},
      color={255,0,255}));
  connect(uHeaPreEna, swi.u2)
    annotation (Line(points={{-120,120},{-80,120},{-80,-100},{-22,-100}},
      color={255,0,255}));
  connect(uHeaPreCon, swi.u1)
    annotation (Line(points={{-120,-80},{-40,-80},{-40,-92},{-22,-92}},
      color={0,0,127}));
  connect(con.y, swi.u3)
    annotation (Line(points={{-58,-120},{-40,-120},{-40,-108},{-22,-108}},
      color={0,0,127}));
  connect(swi.y, noWSE.uHeaPreCon)
    annotation (Line(points={{2,-100},{20,-100},{20,60},{38,60}}, color={0,0,127}));
  connect(swi.y, withWSE.uHeaPreCon)
    annotation (Line(points={{2,-100},{20,-100},{20,-22},{38,-22}}, color={0,0,127}));
  connect(noWSE.yMaxTowSpeSet, yMaxTowSpeSet)
    annotation (Line(points={{61,58},{80,58},{80,80},{110,80}}, color={0,0,127}));
  connect(withWSE.yHeaPreConVal, yHeaPreConVal)
    annotation (Line(points={{61,-36},{90,-36},{90,20},{110,20}}, color={0,0,127}));
  connect(withWSE.yMaxTowSpeSet, yMaxTowSpeSet)
    annotation (Line(points={{61,-24},{80,-24},{80,80},{110,80}}, color={0,0,127}));
  connect(withWSE.yConWatPumSpeSet, yConWatPumSpeSet)
    annotation (Line(points={{61,-30},{70,-30},{70,-40},{110,-40}}, color={0,0,127}));
  connect(desConWatPumSpe, noWSE.desConWatPumSpe)
    annotation (Line(points={{-120,20},{0,20},{0,52},{38,52}}, color={0,0,127}));
  connect(desConWatPumSpe, withWSE.desConWatPumSpe)
    annotation (Line(points={{-120,20},{0,20},{0,-26},{38,-26}}, color={0,0,127}));
  connect(noWSE.yConWatPumSpeSet, yConWatPumSpeSet)
    annotation (Line(points={{61,44},{70,44},{70,-40},{110,-40}}, color={0,0,127}));
  connect(noWSE.yHeaPreConVal, yHeaPreConVal)
    annotation (Line(points={{61,46},{90,46},{90,20},{110,20}}, color={0,0,127}));

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
          lineColor={0,0,255},
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
according to ASHRAE RP-1711 Advanced Sequences of Operation for HVAC Systems Phase II –
Central Plants and Hydronic Systems (Draft 4 on January 7, 2019),
section 5.2.10 Head pressure control.
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
<code>yHeaPreConVal</code> when <code>fixSpePum</code>=true, or resetting condenser
water pump speed <code>yConWatPumSpeSet</code> when <code>fixSpePum</code>=false. See
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
