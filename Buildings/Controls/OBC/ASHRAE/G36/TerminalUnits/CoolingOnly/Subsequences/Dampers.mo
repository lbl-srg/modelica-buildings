within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.CoolingOnly.Subsequences;
block Dampers
  "Output signals for controlling VAV cooling only box damper position"

  parameter Real VMin_flow(unit="m3/s")
    "Design zone minimum airflow setpoint";
  parameter Real VCooMax_flow(unit="m3/s")
    "Design zone cooling maximum airflow rate";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController damCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (__cdl(ValueInReference=false));
  parameter Real kDam(unit="1")=0.5
    "Gain of controller for damper control"
    annotation (__cdl(ValueInReference=false));
  parameter Real TiDam(unit="s")=300
    "Time constant of integrator block for damper control"
    annotation(__cdl(ValueInReference=false),
               Dialog(
      enable=(damCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
           or damCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real TdDam(unit="s")=0.1
    "Time constant of derivative block for damper control"
    annotation (__cdl(ValueInReference=false),
                Dialog(
       enable=(damCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
            or damCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)));
  parameter Real dTHys(unit="K")=0.25
    "Delta between the temperature hysteresis high and low limit"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));
  parameter Real iniDam(unit="1")=0.01
    "Initial damper position when the damper control is enabled"
    annotation (__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActMin_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active minimum airflow rate"
    annotation (Placement(transformation(extent={{-300,270},{-260,310}}),
        iconTransformation(extent={{-140,160},{-100,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSup(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC")
    "Temperature of the air supplied from central air handler"
    annotation (Placement(transformation(extent={{-300,240},{-260,280}}),
        iconTransformation(extent={{-140,130},{-100,170}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    final displayUnit="degC") "Measured zone temperature"
    annotation (Placement(transformation(extent={{-300,200},{-260,240}}),
        iconTransformation(extent={{-140,100},{-100,140}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final min=0,
    final max=1,
    final unit="1") "Cooling loop signal"
    annotation (Placement(transformation(extent={{-300,150},{-260,190}}),
        iconTransformation(extent={{-140,70},{-100,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VActCooMax_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate") "Active cooling maximum airflow rate"
    annotation (Placement(transformation(extent={{-300,110},{-260,150}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonSta
    "Current zone state"
    annotation (Placement(transformation(extent={{-300,50},{-260,90}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveFloSet
    "Index of overriding flow setpoint, 1: set to zero; 2: set to cooling maximum; 3: set to minimum flow"
    annotation (Placement(transformation(extent={{-300,20},{-260,60}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "AHU supply fan status"
    annotation (Placement(transformation(extent={{-300,-170},{-260,-130}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VDis_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Measured primary discharge airflow rate"
    annotation (Placement(transformation(extent={{-300,-200},{-260,-160}}),
        iconTransformation(extent={{-140,-160},{-100,-120}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput oveDamPos
    "Index of overriding damper position, 1: set to close; 2: set to open"
    annotation (Placement(transformation(extent={{-300,-240},{-260,-200}}),
        iconTransformation(extent={{-140,-200},{-100,-160}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput VSet_flow(
    final min=0,
    final unit="m3/s",
    final quantity="VolumeFlowRate")
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{260,-100},{300,-60}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDam(
    final min=0,
    final unit="1")
    "Commanded damper position after considering override"
    annotation (Placement(transformation(extent={{260,-280},{300,-240}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0) "Constant zero"
    annotation (Placement(transformation(extent={{-220,210},{-200,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(
    final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-180,210},{-160,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Line lin
    "Map cooling loop output to the active airflow setpoint"
    annotation (Placement(transformation(extent={{-120,180},{-100,200}})));
  Buildings.Controls.OBC.CDL.Continuous.Greater gre(
    final h=dTHys)
    "Check if supplyair temperature from the air handler is greater than room temperature"
    annotation (Placement(transformation(extent={{-160,250},{-140,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Select active airfow setpoint based on difference between supply and zone temperature"
    annotation (Placement(transformation(extent={{-60,250},{-40,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch actFlo
    "Specify active flow setpoint based on the zone status"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conPID(
    final controllerType=damCon,
    final k=kDam,
    final Ti=TiDam,
    final Td=TdDam,
    final y_reset=iniDam)
    "Damper controller"
    annotation (Placement(transformation(extent={{150,-130},{170,-110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=Buildings.Controls.OBC.ASHRAE.G36.Types.ZoneStates.cooling)
    "Cooling state value"
    annotation (Placement(transformation(extent={{-220,90},{-200,110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal cooSta
    "Check if zone is in cooling state"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant nomFlow(
    final k=VCooMax_flow)
    "Nominal volume flow rate"
    annotation (Placement(transformation(extent={{0,-120},{20,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDisSet_flowNor
    "Normalized setpoint for discharge volume flow rate"
    annotation (Placement(transformation(extent={{100,-130},{120,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide VDis_flowNor
    "Normalized discharge volume flow rate"
    annotation (Placement(transformation(extent={{100,-200},{120,-180}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-220,10},{-200,30}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forZerFlo
    "Check if forcing zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forCooMax
    "Check if forcing zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-220,-30},{-200,-10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal forMinFlo
    "Check if forcing zone airflow setpoint to minimum flow"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    final k=3)
    "Constant 3"
    annotation (Placement(transformation(extent={{-220,-70},{-200,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal zerFlo(
    final realTrue=0)
    "Force zone airflow setpoint to zero"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cooMax(
    final realTrue=VCooMax_flow)
    "Force zone airflow setpoint to cooling maximum"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal minFlo(
    final realTrue=VMin_flow)
    "Force zone airflow setpoint to zone minimum flow"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Add up two inputs"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add1
    "Add up inputs"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Airflow setpoint after considering override"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Check if the airflow setpoint should be overrided"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    final k=1)
    "Constant 1"
    annotation (Placement(transformation(extent={{-120,-250},{-100,-230}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Check if forcing damper to full close"
    annotation (Placement(transformation(extent={{-60,-230},{-40,-210}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4
    "Check if forcing damper to full open"
    annotation (Placement(transformation(extent={{-60,-270},{-40,-250}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt5(final k=2)
    "Constant 2"
    annotation (Placement(transformation(extent={{-120,-290},{-100,-270}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal cloDam(
    final realTrue=0)
    "Full closed damper position"
    annotation (Placement(transformation(extent={{0,-230},{20,-210}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal opeDam(
    final realTrue=1)
    "Full open damper position"
    annotation (Placement(transformation(extent={{0,-270},{20,-250}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add3
    "Add up inputs"
    annotation (Placement(transformation(extent={{60,-250},{80,-230}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Check if the damper setpoint position should be overrided"
    annotation (Placement(transformation(extent={{60,-290},{80,-270}})));
  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Damper setpoint position after considering override"
    annotation (Placement(transformation(extent={{220,-270},{240,-250}})));

equation
  connect(conInt.y, cooSta.u1)
    annotation (Line(points={{-198,100},{-162,100}}, color={255,127,0}));
  connect(uZonSta, cooSta.u2) annotation (Line(points={{-280,70},{-180,70},{-180,
          92},{-162,92}},   color={255,127,0}));
  connect(con.y, lin.x1) annotation (Line(points={{-198,220},{-190,220},{-190,198},
          {-122,198}}, color={0,0,127}));
  connect(con1.y, lin.x2) annotation (Line(points={{-158,220},{-140,220},{-140,186},
          {-122,186}}, color={0,0,127}));
  connect(uCoo, lin.u) annotation (Line(points={{-280,170},{-200,170},{-200,190},
          {-122,190}}, color={0,0,127}));
  connect(TSup, gre.u1)
    annotation (Line(points={{-280,260},{-162,260}}, color={0,0,127}));
  connect(TZon, gre.u2) annotation (Line(points={{-280,220},{-240,220},{-240,252},
          {-162,252}}, color={0,0,127}));
  connect(gre.y, swi.u2)
    annotation (Line(points={{-138,260},{-62,260}},color={255,0,255}));
  connect(lin.y, swi.u3) annotation (Line(points={{-98,190},{-80,190},{-80,252},
          {-62,252}}, color={0,0,127}));
  connect(VActMin_flow, lin.f1) annotation (Line(points={{-280,290},{-230,290},{
          -230,194},{-122,194}}, color={0,0,127}));
  connect(VActMin_flow, swi.u1) annotation (Line(points={{-280,290},{-80,290},{-80,
          268},{-62,268}}, color={0,0,127}));
  connect(VActCooMax_flow, lin.f2) annotation (Line(points={{-280,130},{-180,130},
          {-180,182},{-122,182}},  color={0,0,127}));
  connect(cooSta.y, actFlo.u2) annotation (Line(points={{-138,100},{-120,100},{-120,
          160},{-22,160}}, color={255,0,255}));
  connect(VActMin_flow, actFlo.u3) annotation (Line(points={{-280,290},{-230,290},
          {-230,152},{-22,152}}, color={0,0,127}));
  connect(swi.y, actFlo.u1) annotation (Line(points={{-38,260},{-30,260},{-30,168},
          {-22,168}}, color={0,0,127}));
  connect(nomFlow.y, VDisSet_flowNor.u2) annotation (Line(points={{22,-110},{60,
          -110},{60,-126},{98,-126}}, color={0,0,127}));
  connect(nomFlow.y, VDis_flowNor.u2) annotation (Line(points={{22,-110},{60,-110},
          {60,-196},{98,-196}}, color={0,0,127}));
  connect(VDis_flow, VDis_flowNor.u1) annotation (Line(points={{-280,-180},{80,-180},
          {80,-184},{98,-184}}, color={0,0,127}));
  connect(VDisSet_flowNor.y, conPID.u_s)
    annotation (Line(points={{122,-120},{148,-120}}, color={0,0,127}));
  connect(VDis_flowNor.y, conPID.u_m) annotation (Line(points={{122,-190},{160,-190},
          {160,-132}},color={0,0,127}));
  connect(oveFloSet,forZerFlo. u1)
    annotation (Line(points={{-280,40},{-182,40}},  color={255,127,0}));
  connect(conInt1.y, forZerFlo.u2) annotation (Line(points={{-198,20},{-190,20},
          {-190,32},{-182,32}}, color={255,127,0}));
  connect(oveFloSet,forCooMax. u1) annotation (Line(points={{-280,40},{-240,40},
          {-240,0},{-182,0}},    color={255,127,0}));
  connect(conInt2.y,forCooMax. u2) annotation (Line(points={{-198,-20},{-190,-20},
          {-190,-8},{-182,-8}}, color={255,127,0}));
  connect(oveFloSet,forMinFlo. u1) annotation (Line(points={{-280,40},{-240,40},
          {-240,-40},{-182,-40}}, color={255,127,0}));
  connect(conInt3.y,forMinFlo. u2) annotation (Line(points={{-198,-60},{-190,-60},
          {-190,-48},{-182,-48}}, color={255,127,0}));
  connect(forZerFlo.y,zerFlo. u)
    annotation (Line(points={{-158,40},{-122,40}}, color={255,0,255}));
  connect(forCooMax.y,cooMax. u)
    annotation (Line(points={{-158,0},{-122,0}}, color={255,0,255}));
  connect(forMinFlo.y,minFlo. u)
    annotation (Line(points={{-158,-40},{-122,-40}}, color={255,0,255}));
  connect(cooMax.y,add2. u1) annotation (Line(points={{-98,0},{-90,0},{-90,-14},
          {-82,-14}}, color={0,0,127}));
  connect(minFlo.y,add2. u2) annotation (Line(points={{-98,-40},{-90,-40},{-90,-26},
          {-82,-26}}, color={0,0,127}));
  connect(zerFlo.y,add1. u1) annotation (Line(points={{-98,40},{-50,40},{-50,26},
          {-42,26}}, color={0,0,127}));
  connect(add2.y,add1. u2) annotation (Line(points={{-58,-20},{-50,-20},{-50,14},
          {-42,14}}, color={0,0,127}));
  connect(forZerFlo.y,or3. u1) annotation (Line(points={{-158,40},{-140,40},{-140,
          -72},{-82,-72}},  color={255,0,255}));
  connect(forCooMax.y,or3. u2) annotation (Line(points={{-158,0},{-140,0},{-140,
          -80},{-82,-80}}, color={255,0,255}));
  connect(forMinFlo.y,or3. u3) annotation (Line(points={{-158,-40},{-140,-40},{-140,
          -88},{-82,-88}}, color={255,0,255}));
  connect(or3.y, swi1.u2)
    annotation (Line(points={{-58,-80},{38,-80}}, color={255,0,255}));
  connect(add1.y, swi1.u1) annotation (Line(points={{-18,20},{0,20},{0,-72},{38,
          -72}}, color={0,0,127}));
  connect(swi1.y, VSet_flow)
    annotation (Line(points={{62,-80},{280,-80}}, color={0,0,127}));
  connect(actFlo.y, swi1.u3) annotation (Line(points={{2,160},{10,160},{10,-88},
          {38,-88}}, color={0,0,127}));
  connect(swi1.y, VDisSet_flowNor.u1) annotation (Line(points={{62,-80},{80,-80},
          {80,-114},{98,-114}}, color={0,0,127}));
  connect(oveDamPos,intEqu3. u1)
    annotation (Line(points={{-280,-220},{-62,-220}}, color={255,127,0}));
  connect(oveDamPos,intEqu4. u1) annotation (Line(points={{-280,-220},{-70,-220},
          {-70,-260},{-62,-260}},color={255,127,0}));
  connect(intEqu3.y,cloDam. u)
    annotation (Line(points={{-38,-220},{-2,-220}},color={255,0,255}));
  connect(intEqu4.y,opeDam. u)
    annotation (Line(points={{-38,-260},{-2,-260}},color={255,0,255}));
  connect(cloDam.y,add3. u1) annotation (Line(points={{22,-220},{40,-220},{40,-234},
          {58,-234}},color={0,0,127}));
  connect(opeDam.y,add3. u2) annotation (Line(points={{22,-260},{40,-260},{40,-246},
          {58,-246}},color={0,0,127}));
  connect(intEqu3.y,or2. u1) annotation (Line(points={{-38,-220},{-20,-220},{-20,
          -280},{58,-280}}, color={255,0,255}));
  connect(intEqu4.y,or2. u2) annotation (Line(points={{-38,-260},{-20,-260},{-20,
          -288},{58,-288}}, color={255,0,255}));
  connect(or2.y,swi2. u2)
    annotation (Line(points={{82,-280},{160,-280},{160,-260},{218,-260}},
          color={255,0,255}));
  connect(swi2.y, yDam)
    annotation (Line(points={{242,-260},{280,-260}}, color={0,0,127}));
  connect(conPID.y, swi2.u3) annotation (Line(points={{172,-120},{180,-120},{180,
          -268},{218,-268}}, color={0,0,127}));
  connect(conInt5.y, intEqu4.u2) annotation (Line(points={{-98,-280},{-80,-280},
          {-80,-268},{-62,-268}}, color={255,127,0}));
  connect(conInt4.y, intEqu3.u2) annotation (Line(points={{-98,-240},{-80,-240},
          {-80,-228},{-62,-228}}, color={255,127,0}));
  connect(add3.y, swi2.u1) annotation (Line(points={{82,-240},{160,-240},{160,-252},
          {218,-252}}, color={0,0,127}));
  connect(u1Fan, conPID.trigger) annotation (Line(points={{-280,-150},{154,-150},
          {154,-132}}, color={255,0,255}));
annotation (
  defaultComponentName="damCon",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-260,-300},{260,300}})),
  Icon(coordinateSystem(extent={{-100,-200},{100,200}}),
       graphics={
        Rectangle(
        extent={{-100,-200},{100,200}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,240},{100,200}},
          textColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-98,66},{-52,54}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActCooMax_flow"),
        Text(
          extent={{-98,6},{-68,-6}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="uZonSta"),
        Text(
          extent={{-98,186},{-54,174}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VActMin_flow"),
        Text(
          extent={{-100,96},{-74,84}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uCoo"),
        Text(
          extent={{-98,-132},{-62,-146}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="VDis_flow"),
        Text(
          extent={{-100,156},{-76,146}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TSup"),
        Text(
          extent={{-100,126},{-78,116}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TZon"),
        Text(
          extent={{68,-84},{96,-94}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="yDam"),
        Line(points={{-50,64},{-50,-48},{62,-48}}, color={95,95,95}),
        Line(
          points={{-2,-22},{-2,-48}},
          color={215,215,215},
          pattern=LinePattern.Dash),
    Polygon(
      points={{-64,-58},{-42,-52},{-42,-64},{-64,-58}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
    Line(points={{-2,-58},{-60,-58}}, color={95,95,95}),
    Line(points={{16,-58},{78,-58}},  color={95,95,95}),
    Polygon(
      points={{80,-58},{58,-52},{58,-64},{80,-58}},
      lineColor={95,95,95},
      fillColor={95,95,95},
      fillPattern=FillPattern.Solid),
        Text(
          extent={{60,98},{98,86}},
          textColor={0,0,127},
          pattern=LinePattern.Dash,
          horizontalAlignment=TextAlignment.Right,
          textString="VSet_flow"),
        Line(
          points={{-50,-20},{-2,-20},{18,-20},{64,40}},
          color={0,0,255},
          thickness=0.5),
        Text(
          extent={{-100,-84},{-56,-96}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveFloSet"),
        Text(
          extent={{-96,-172},{-52,-184}},
          textColor={255,127,0},
          pattern=LinePattern.Dash,
          textString="oveDamPos"),
        Text(
          extent={{-98,-34},{-68,-46}},
          textColor={255,0,255},
          pattern=LinePattern.Dash,
          textString="u1Fan")}),
Documentation(info="<html>
<p>
This sequence sets the damper position for VAV cooling only terminal unit. The
implementation is according to Section 5.5.5 and 5.5.7 of ASHRAE Guideline 36 (G36), May 2020.
</p>
<ol>
<li>
When the zone state (<code>uZonSta</code>) is cooling, the cooling-loop output 
(<code>uCoo</code>) shall be mapped to the active airflow setpoint from the
minimum (<code>VActMin_flow</code>) to the cooling maximum airflow setpoints
(<code>VActCooMax_flow</code>).
<ul>
<li>
If supply air temperature <code>TSup</code> from the air handler is greater than
room temperature <code>TZon</code>, cooling supply airflow setpoint shall be
no higher than the minimum.
</li>
</ul>
</li>
<li>
When the zone state is deadband or heating, the active airflow setpoint shall be
the minimum airflow setpoint.
</li>
<li>
The VAV damper <code>yDam</code> shall be modulated by a control loop to maintain
the measured airflow <code>VDis_flow</code> at the active setpoint.
</li>
</ol>
<p>The sequences of controlling damper position for the cooling only terminal
unit are described in the following figure below.</p>
<p align=\"center\">
<img alt=\"Image of damper control for VAV cooling only unit\"
src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/TerminalUnits/CoolingOnly/Subsequences/Damper.png\"/>
</p>
<p>
Override the airflow setpoint and the damper position setpoint by providing software
switches that interlock to a system-level point to:
</p>
<ol>
<li>
when <code>oveFloSet</code> equals to 1, force the zone airflow setpoint
<code>VSet_flow</code> to zero,
</li>
<li>
when <code>oveFloSet</code> equals to 2, force the zone airflow setpoint
<code>VSet_flow</code> to zone cooling maximum airflow rate
<code>VCooMax_flow</code>,
</li>
<li>
when <code>oveFloSet</code> equals to 3, force the zone airflow setpoint
<code>VSet_flow</code> to zone minimum airflow setpoint
<code>VMin_flow</code>.
</li>
<li>
when <code>oveDamPos</code> equals to 1, force the damper to full closed by setting
<code>yDam</code> to 0,
</li>
<li>
when <code>oveDamPos</code> equals to 2, force the damper to full open by setting
<code>yDam</code> to 1.
</li>
</ol>
</html>", revisions="<html>
<ul>
<li>
August 24, 2023, by Jianjun Hu:<br/>
Added AHU supply fan status for damper position reset.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3257\">issue 3257</a>.
</li>
<li>
January 12, 2023, by Jianjun Hu:<br/>
Removed the parameter <code>have_preIndDam</code> to exclude the option of using pressure independant damper.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3139\">issue 3139</a>.
</li>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Dampers;
