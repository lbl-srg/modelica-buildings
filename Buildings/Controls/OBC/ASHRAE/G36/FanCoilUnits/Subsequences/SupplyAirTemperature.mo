within Buildings.Controls.OBC.ASHRAE.G36.FanCoilUnits.Subsequences;
block SupplyAirTemperature
  "Subsequence for calculating supply air temperature setpoint"

  parameter Boolean have_cooCoi
    "True if the unit has a cooling coil"
    annotation(__cdl(ValueInReference=false));

  parameter Boolean have_heaCoi
    "True if the unit has a heating coil"
    annotation(__cdl(ValueInReference=false));

  parameter Real uHea_min(unit="1")=heaDea
    "Minimum heating loop signal at which supply air temperature is modified"
    annotation(Dialog(group="Heating loop", enable = have_heaCoi));

  parameter Real TSupSet_max(
    unit="K",
    displayUnit="degC")=305.15
    "Supply air temperature setpoint at maximum heating loop signal"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Heating loop", enable = have_heaCoi));

  parameter Real uHea_max(
    unit="1",
    displayUnit="1")=0.5
    "Maximum heating loop signal at which supply air temperature is modified"
    annotation(Dialog(group="Heating loop", enable = have_heaCoi));

  parameter Real uCoo_min(unit="1")=cooDea
    "Minimum cooling loop signal at which supply air temperature is modified"
    annotation(Dialog(group="Cooling loop", enable = have_cooCoi));

  parameter Real TSupSet_min(
    unit="K",
    displayUnit="degC")=285.95
    "Supply air temperature setpoint at maximum cooling loop signal"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Cooling loop", enable = have_cooCoi));

  parameter Real uCoo_max(
    unit="1",
    displayUnit="1")=0.5
    "Maximum cooling loop signal at which supply air temperature is modified"
    annotation(Dialog(group="Cooling loop", enable = have_cooCoi));

  parameter Real heaDea(
    unit="1",
    displayUnit="1")=0.05
    "Heating loop signal limit above which setpoint operation changes from deadband
    mode to heating mode"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Deadband", enable = have_heaCoi));

  parameter Real cooDea(
    unit="1",
    displayUnit="1")=0.05
    "Cooling loop signal limit above which setpoint operation changes from deadband
    mode to cooling mode"
    annotation(__cdl(ValueInReference=false),
      Dialog(group="Deadband", enable = have_cooCoi));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController cooCoiConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of cooling coil controller"
    annotation(Dialog(tab="PID controller parameters", group="Cooling coil",
                      enable=have_cooCoi));

  parameter Real kCooCoi(
    unit="1",
    displayUnit="1")=1
    "Controller gain"
    annotation(Dialog(tab="PID controller parameters", group="Cooling coil",
                      enable=have_cooCoi));

  parameter Real TiCooCoi(
    unit="s",
    displayUnit="s")=60
    "Integrator time constant"
    annotation(Dialog(tab="PID controller parameters", group="Cooling coil",
      enable = (cooCoiConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                or cooCoiConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
            and have_cooCoi));

  parameter Real TdCooCoi(
    unit="s",
    displayUnit="s")=0.1
    "Derivative block time constant"
    annotation(Dialog(tab="PID controller parameters", group="Cooling coil",
      enable = (cooCoiConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                or cooCoiConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
            and have_cooCoi));

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController heaCoiConTyp=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of heating coil controller"
    annotation(Dialog(tab="PID controller parameters", group="Heating coil",
      enable=have_heaCoi));

  parameter Real kHeaCoi(
    unit="1",
    displayUnit="1")=1
    "Controller gain"
    annotation(Dialog(tab="PID controller parameters", group="Heating coil",
      enable=have_heaCoi));

  parameter Real TiHeaCoi(
    unit="s",
    displayUnit="s")=60
    "Integrator block time constant"
    annotation(Dialog(tab="PID controller parameters", group="Heating coil",
      enable = (heaCoiConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                or heaCoiConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
            and have_heaCoi));

  parameter Real TdHeaCoi(
    unit="s",
    displayUnit="s")=0.1
    "Derivative block time constant"
    annotation(Dialog(tab="PID controller parameters", group="Heating coil",
      enable = (heaCoiConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                or heaCoiConTyp == Buildings.Controls.OBC.CDL.Types.SimpleController.PID)
            and have_heaCoi));

  parameter Real deaHysLim(
    unit="1",
    displayUnit="1")=0.05
    "Hysteresis limits for deadband mode transitions"
    annotation(__cdl(ValueInReference=false), Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Fan
    "Fan proven on signal"
    annotation (Placement(transformation(extent={{-280,120},{-240,160}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uHea(
    final unit="1",
    displayUnit="1") if have_heaCoi
    "Heating loop signal"
    annotation (Placement(transformation(extent={{-280,20},{-240,60}}),
      iconTransformation(extent={{-140,0},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uCoo(
    final unit="1",
    displayUnit="1") if have_cooCoi
    "Cooling loop signal"
    annotation (Placement(transformation(extent={{-280,-80},{-240,-40}}),
      iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAirSup(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured supply air temperature"
    annotation (Placement(transformation(extent={{-280,-20},{-240,20}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonHeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_heaCoi
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-280,60},{-240,100}}),
      iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZonCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature") if have_cooCoi
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-280,-130},{-240,-90}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHeaCoi(
    final unit="1",
    displayUnit="1") if have_heaCoi
    "Heating coil signal"
    annotation (Placement(transformation(extent={{240,90},{280,130}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCooCoi(
    final unit="1",
    displayUnit="1") if have_cooCoi
    "Cooling coil signal"
    annotation (Placement(transformation(extent={{240,-110},{280,-70}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TSupSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{240,-70},{280,-30}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiDeaCoo
    "Switch for turning on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiCooCoi if have_cooCoi
    "Switch cooling coil signal to zero in deadband mode"
    annotation (Placement(transformation(extent={{140,-150},{160,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiHeaCoi if have_heaCoi
    "Switch heating coil signal to zero in deadband mode"
    annotation (Placement(transformation(extent={{140,80},{160,100}})));

  Buildings.Controls.OBC.CDL.Reals.Line linTHeaSupAir if have_heaCoi
    "Convert heating loop signal to supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Buildings.Controls.OBC.CDL.Reals.Line linTCooSupAir if have_cooCoi
    "Convert cooling loop signal to supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));

  Buildings.Controls.OBC.CDL.Reals.PID conPIDHea(
    final controllerType=heaCoiConTyp,
    final k=kHeaCoi,
    final Ti=TiHeaCoi,
    final Td=TdHeaCoi) if have_heaCoi
    "PID controller for heating coil"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));

  Buildings.Controls.OBC.CDL.Reals.PID conPIDCoo(
    final controllerType=cooCoiConTyp,
    final k=kCooCoi,
    final Ti=TiCooCoi,
    final Td=TdCooCoi,
    final reverseActing=false) if have_cooCoi
    "PID controller for cooling coil"
    annotation (Placement(transformation(extent={{80,-110},{100,-90}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysDeaHea(
    final uLow=heaDea-deaHysLim,
    final uHigh=heaDea) if have_heaCoi
    "Hysteresis for switching between deadband mode and heating mode"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swiDeaHea if have_heaCoi
    "Switch for turning on heating mode from deadband mode"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hysDeaCoo(
    final uLow=cooDea-deaHysLim,
    final uHigh=cooDea) if have_cooCoi
    "Hysteresis for switching on cooling mode from deadband mode"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{120,130},{140,150}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul2 if have_heaCoi
    "Output heating coil signal only when fan is proven on"
    annotation (Placement(transformation(extent={{200,100},{220,120}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply mul3 if have_cooCoi
    "Output cooling coil signal only when fan is proven on"
    annotation (Placement(transformation(extent={{200,-100},{220,-80}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=1) if not have_heaCoi
    "Dummy gain"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai1(
    final k=1) if not have_cooCoi
    "Dummy gain"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conTSupSet_max(
    final k=TSupSet_max) if have_heaCoi
    "Maximum heating supply air temperature setpoint limit signal"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conUHea_min(
    final k=uHea_min) if have_heaCoi
    "Minimum heating loop signal support point"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conTSupSet_min(
    final k=TSupSet_min) if have_cooCoi
    "Minimum cooling supply air temperature setpoint limit signal"
    annotation (Placement(transformation(extent={{-140,-150},{-120,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conUCoo_min(
    final k=uCoo_min) if have_cooCoi
    "Minimum cooling loop signal support point"
    annotation (Placement(transformation(extent={{-220,-90},{-200,-70}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conUHea_max(
    final k=uHea_max) if have_heaCoi
    "Maximum heating loop signal support point"
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conUCoo_max(
    final k=uCoo_max) if have_cooCoi
    "Maximum cooling loop signal support point"
    annotation (Placement(transformation(extent={{-180,-150},{-160,-130}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant conZer(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false) if not have_cooCoi
    "Constant false"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

equation
  connect(uHea, linTHeaSupAir.u) annotation (Line(points={{-260,40},{-100,40},{-100,
          60},{-82,60}}, color={0,0,127}));
  connect(uCoo, linTCooSupAir.u) annotation (Line(points={{-260,-60},{-160,-60},
          {-160,-110},{-82,-110}}, color={0,0,127}));
  connect(TAirSup, conPIDHea.u_m)
    annotation (Line(points={{-260,0},{90,0},{90,48}}, color={0,0,127}));
  connect(TAirSup, conPIDCoo.u_m) annotation (Line(points={{-260,0},{60,0},{60,-120},
          {90,-120},{90,-112}}, color={0,0,127}));
  connect(linTHeaSupAir.y, swiDeaHea.u1) annotation (Line(points={{-58,60},{-40,
          60},{-40,68},{-22,68}}, color={0,0,127}));
  connect(uHea, hysDeaHea.u) annotation (Line(points={{-260,40},{-100,40},{-100,
          110},{-82,110}}, color={0,0,127}));
  connect(hysDeaHea.y, swiDeaHea.u2) annotation (Line(points={{-58,110},{-30,110},
          {-30,60},{-22,60}}, color={255,0,255}));
  connect(hysDeaCoo.y, swiDeaCoo.u2)
    annotation (Line(points={{-98,-50},{18,-50}}, color={255,0,255}));
  connect(uCoo, hysDeaCoo.u) annotation (Line(points={{-260,-60},{-160,-60},{-160,
          -50},{-122,-50}},color={0,0,127}));
  connect(swiDeaHea.y, swiDeaCoo.u3) annotation (Line(points={{2,60},{10,60},{10,
          -58},{18,-58}}, color={0,0,127}));
  connect(linTCooSupAir.y, swiDeaCoo.u1) annotation (Line(points={{-58,-110},{-40,
          -110},{-40,-42},{18,-42}},color={0,0,127}));
  connect(swiDeaCoo.y, conPIDHea.u_s) annotation (Line(points={{42,-50},{50,-50},
          {50,60},{78,60}}, color={0,0,127}));
  connect(swiDeaCoo.y, conPIDCoo.u_s) annotation (Line(points={{42,-50},{50,-50},
          {50,-100},{78,-100}}, color={0,0,127}));
  connect(conTSupSet_max.y, linTHeaSupAir.f2) annotation (Line(points={{-118,20},
          {-90,20},{-90,52},{-82,52}},  color={0,0,127}));
  connect(conTSupSet_min.y, linTCooSupAir.f2) annotation (Line(points={{-118,-140},
          {-100,-140},{-100,-118},{-82,-118}}, color={0,0,127}));
  connect(TZonHeaSet, linTHeaSupAir.f1) annotation (Line(points={{-260,80},{-120,
          80},{-120,64},{-82,64}},color={0,0,127}));
  connect(TZonCooSet, linTCooSupAir.f1) annotation (Line(points={{-260,-110},{-200,
          -110},{-200,-106},{-82,-106}}, color={0,0,127}));
  connect(TAirSup, swiDeaHea.u3) annotation (Line(points={{-260,0},{-50,0},{-50,
          52},{-22,52}}, color={0,0,127}));
  connect(swiDeaCoo.y, TSupSet) annotation (Line(points={{42,-50},{260,-50}},
          color={0,0,127}));
  connect(u1Fan, booToRea2.u)
    annotation (Line(points={{-260,140},{118,140}},color={255,0,255}));
  connect(yHeaCoi, mul2.y)
    annotation (Line(points={{260,110},{222,110}}, color={0,0,127}));
  connect(booToRea2.y, mul2.u1) annotation (Line(points={{142,140},{190,140},{190,
          116},{198,116}}, color={0,0,127}));
  connect(mul3.y, yCooCoi) annotation (Line(points={{222,-90},{260,-90}},
          color={0,0,127}));
  connect(booToRea2.y, mul3.u1) annotation (Line(points={{142,140},{190,140},{190,
          -84},{198,-84}},color={0,0,127}));
  connect(conUHea_max.y, linTHeaSupAir.x2) annotation (Line(points={{-178,20},{-160,
          20},{-160,56},{-82,56}}, color={0,0,127}));
  connect(conUHea_min.y, linTHeaSupAir.x1) annotation (Line(points={{-178,110},{
          -160,110},{-160,68},{-82,68}}, color={0,0,127}));
  connect(conUCoo_min.y, linTCooSupAir.x1) annotation (Line(points={{-198,-80},{
          -180,-80},{-180,-102},{-82,-102}}, color={0,0,127}));
  connect(conUCoo_max.y, linTCooSupAir.x2) annotation (Line(points={{-158,-140},
          {-150,-140},{-150,-114},{-82,-114}}, color={0,0,127}));
  connect(conPIDCoo.y, swiCooCoi.u1) annotation (Line(points={{102,-100},{110,-100},
          {110,-132},{138,-132}}, color={0,0,127}));
  connect(swiCooCoi.y, mul3.u2) annotation (Line(points={{162,-140},{190,-140},{
          190,-96},{198,-96}}, color={0,0,127}));
  connect(hysDeaCoo.y, swiCooCoi.u2) annotation (Line(points={{-98,-50},{-20,-50},
          {-20,-140},{138,-140}}, color={255,0,255}));
  connect(swiHeaCoi.y, mul2.u2) annotation (Line(points={{162,90},{180,90},{180,
          104},{198,104}}, color={0,0,127}));
  connect(conPIDHea.y, swiHeaCoi.u1) annotation (Line(points={{102,60},{110,60},
          {110,98},{138,98}}, color={0,0,127}));
  connect(hysDeaHea.y, swiHeaCoi.u2) annotation (Line(points={{-58,110},{-30,110},
          {-30,90},{138,90}},color={255,0,255}));
  connect(conZer.y, swiHeaCoi.u3) annotation (Line(points={{102,-20},{120,-20},{
          120,82},{138,82}}, color={0,0,127}));
  connect(conZer.y, swiCooCoi.u3) annotation (Line(points={{102,-20},{120,-20},{
          120,-148},{138,-148}}, color={0,0,127}));
  connect(TAirSup, gai.u) annotation (Line(points={{-260,0},{-50,0},{-50,30},{-22,
          30}}, color={0,0,127}));
  connect(gai.y, swiDeaCoo.u3) annotation (Line(points={{2,30},{10,30},{10,-58},
          {18,-58}}, color={0,0,127}));
  connect(con.y, swiDeaCoo.u2) annotation (Line(points={{-98,-80},{-80,-80},{-80,
          -50},{18,-50}}, color={255,0,255}));
  connect(TAirSup, gai1.u) annotation (Line(points={{-260,0},{-50,0},{-50,-20},{
          -42,-20}}, color={0,0,127}));
  connect(gai1.y, swiDeaCoo.u1) annotation (Line(points={{-18,-20},{0,-20},{0,-42},
          {18,-42}}, color={0,0,127}));

  annotation (defaultComponentName="supAirTem",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                      graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,140},{100,100}},
          textString="%name",
          textColor={0,0,255}),
        Text(
          extent={{-96,92},{-50,72}},
          textColor={255,0,255},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="u1Fan"),
        Text(
          extent={{-96,60},{-20,38}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonHeaSet",
          visible=have_heaCoi),
        Text(
          extent={{-100,30},{-52,10}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uHea",
          visible=have_heaCoi),
        Text(
          extent={{-96,-10},{-46,-28}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TAirSup"),
        Text(
          extent={{-100,-40},{-52,-60}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="uCoo",
          visible=have_cooCoi),
        Text(
          extent={{38,70},{96,50}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yHeaCoi",
          visible=have_heaCoi),
        Text(
          extent={{-96,-68},{-20,-90}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TZonCooSet",
          visible=have_cooCoi),
        Text(
          extent={{20,12},{96,-10}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="TSupSet"),
        Text(
          extent={{38,-50},{96,-70}},
          textColor={0,0,127},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          textString="yCooCoi",
          visible=have_cooCoi)}),        Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-240,-180},{240,180}})),
  Documentation(info="<html>
<p>
Block that outputs the supply air temperature setpoint, as well as the control signals
for the cooling and heating coils in a fan coil unit system. 
The implemented sequence is based on ASHRAE Guideline 36, 2021, Part 5.22.4.
</p>
<p>The supply air temperature 
<code>TSupSet</code> is varied from the zone cooling setpoint temperature 
<code>TZonCooSet</code> to the minimum supply air temperature for cooling 
<code>TSupSet_min</code>, when the cooling loop signal 
<code>uCoo</code> varies from the minimum limit 
<code>uCoo_min</code> to the maximum limit 
<code>uCoo_max</code>. 
Similarly, <code>TSupSet</code> is varied from the zone heating setpoint temperature 
<code>TZonHeaSet</code> to the maximum supply air temperature for heating 
<code>TSupSet_max</code>, when the heating loop signal 
<code>uHea</code> varies from the minimum limit 
<code>uHea_min</code> to the maximum limit 
<code>uHea_max</code>. The setpoint in deadband mode is equal to the current 
measured supply air temperature <code>TAirSup</code>. 
<code>yCooCoi</code> and <code>yHeaCoi</code> are set to zero when the fan proven on signal 
<code>u1Fan</code> is <code>false</code>. </p>
<p align=\"center\"><img src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/G36/FanCoilUnits/Subsequences/SupplyAirTemperature.png\"
alt=\"Supply air temperature setpoint control logic diagram\"/> </p>
</html>",
revisions="<html>
<ul>
<li>
March 17, 2022, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end SupplyAirTemperature;
