within Buildings.DHC.ETS.Combined.Controls;
model HeatPumpModular "Modular heat pump controller"

  parameter Real PLRMin(min=0) "Minimum part load ratio";
  parameter Real kHea=2
    "Gain of controller for compressor during heating operation";
  parameter Real kCoo=2 "Gain of controller for compressor during cooling";

  parameter Real THeaWatSupSetMin(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Minimum value of heating water supply temperature set point";
  parameter Real TChiWatSupSetMax(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC")
    "Maximum value of chilled water supply temperature set point";
  parameter Modelica.Units.SI.TemperatureDifference dTOffSetHea(
    min=0.5,
    displayUnit="K")
    "Temperature to be added to the set point in order to be slightly above what the heating load requires";
  parameter Modelica.Units.SI.TemperatureDifference dTOffSetCoo(
    max=-0.5,
    displayUnit="K")
    "Temperature to be added to the set point in order to be slightly below what the cooling load requires";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaSpa
    "True if space heating is required from tank" annotation (Placement(
        transformation(extent={{-320,180},{-280,220}}), iconTransformation(
          extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHeaDhw
    "True if domestic hot water heating is required from tank" annotation (
      Placement(transformation(extent={{-320,140},{-280,180}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uCoo
    "True if cooling is required from tank"
    annotation (Placement(transformation(extent={{-320,100},{-280,140}}),
    iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaWatSupSet(final unit="K",
      displayUnit="degC") "Set point temperature for heating water" annotation
    (Placement(transformation(extent={{-320,50},{-280,90}}), iconTransformation(
          extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatLvg(final unit="K",
      displayUnit="degC") "Condenser water leaving temperature" annotation (
      Placement(transformation(extent={{-320,10},{-280,50}}),iconTransformation(
          extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaWatLvg(final unit="K",
      displayUnit="degC") "Evaporator water leaving temperature" annotation (
      Placement(transformation(extent={{-320,-70},{-280,-30}}),
        iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSupSet(final unit="K",
      displayUnit="degC") "Set point temperature for chilled water" annotation
    (Placement(transformation(extent={{-320,-40},{-280,0}}),
    iconTransformation(extent={{-140,-30},{-100,10}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValCon
    "Condenser mixing valve control signal"
    annotation (Placement(transformation(extent={{280,-20},{320,20}}),
    iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yValEva
    "Evaporator mixing valve control signal"
    annotation (Placement(transformation(extent={{280,-80},{320,-40}}),
    iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPum
    "Primary pump enable signal"
    annotation (Placement(transformation(extent={{280,170},{320,210}}),
    iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yComOn
    "Outputs true if the compressor is on" annotation (Placement(transformation(
          extent={{280,130},{320,170}}), iconTransformation(extent={{100,30},{140,
            70}})));
  Buildings.Controls.OBC.CDL.Logical.Or heaOrCoo "Heating or cooling requested"
    annotation (Placement(transformation(extent={{-140,180},{-120,200}})));
  Buildings.Controls.OBC.CDL.Reals.PID conValHea(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final yMax=1,
    final yMin=0,
    k=kHea,
    Ti=60,
    final reverseActing=false,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"))
    "Condenser three-way valve control"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Reals.PID conValCoo(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final yMax=1,
    final yMin=0,
    k=kCoo,
    Ti=60,
    final reverseActing=true,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"))  "Evaporator three-way valve control"
    annotation (Placement(transformation(extent={{40,-120},{60,-100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCom
    "Compressor speed control signal"         annotation (Placement(
        transformation(extent={{278,80},{318,120}}),
        iconTransformation(extent={{100,0},{140,40}})));
  Buildings.DHC.ETS.Combined.Controls.PIDWithEnable conCoo(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final yMax=1,
    final yMin=PLRMin,
    final k=kCoo,
    y_reset=PLRMin,
    Ti(displayUnit="s") = 300,
    final reverseActing=false,
    final y_neutral=0,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"))
    "Chiller compressor speed control during cooling mode"
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  Buildings.DHC.ETS.Combined.Controls.PIDWithEnable conHea(
    final controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    final yMax=1,
    final yMin=PLRMin,
    final k=kHea,
    y_reset=PLRMin,
    Ti(displayUnit="s") = 300,
    final reverseActing=true,
    final y_neutral=0,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"))
    "Chiller compressor speed control during heating mode"
    annotation (Placement(transformation(extent={{-10,140},{10,160}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch to select heating or cooling control signal"
    annotation (Placement(transformation(extent={{112,140},{132,160}})));
  Buildings.Controls.OBC.CDL.Reals.LimitSlewRate ramLimCom(
    raisingSlewRate=1/(15*60),
    fallingSlewRate=-1/30,
    Td=1) "Ramp limiter to avoid sudden load increase from chiller"
    annotation (Placement(transformation(extent={{240,90},{260,110}})));

  Buildings.Controls.OBC.CDL.Logical.Or hea "Heating requested"
    annotation (Placement(transformation(extent={{-180,190},{-160,210}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage movAveHea(delta=600)
    "Moving average of heating compressor signal"
    annotation (Placement(transformation(extent={{40,160},{60,180}})));
  Buildings.Controls.OBC.CDL.Reals.MovingAverage movAveCoo(delta=600)
    "Moving average of cooling compressor signal"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Reals.Greater heaDom(h=0.001)
    "Output true if heating dominates the operation"
    annotation (Placement(transformation(extent={{80,140},{100,160}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1
    "Switch to select heating or cooling control signal"
    annotation (Placement(transformation(extent={{202,90},{222,110}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0)
    "Outputs zero"
    annotation (Placement(transformation(extent={{148,60},{168,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSupSetDhw(
    y(final unit="K",
      displayUnit="degC"),
      final k(
        final unit="K",
        displayUnit="degC") = 323.15)
    "Supply water temperature set point during domestic hot water charging"
    annotation (Placement(transformation(extent={{-134,42},{-114,62}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swiTSupSetHea(
    u1(final unit="K", displayUnit="degC"),
    u3(final unit="K", displayUnit="degC"),
    y(final unit="K", displayUnit="degC"))
    "Switch for heating water temperature set point"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter offSetHea(
    p(final unit="K")=-1/kHea*2,
    u(final unit="K", displayUnit="degC"),
    y(final unit="K", displayUnit="degC"))
    "Offset temperature for 3-way valve control during heating"
    annotation (Placement(transformation(extent={{10,-60},{30,-40}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter offSetCoo(
    p(final unit="K")=+1/kCoo*2,
    u(final unit="K", displayUnit="degC"),
    y(final unit="K", displayUnit="degC"))
    "Offset temperature for 3-way valve control during cooling"
    annotation (Placement(transformation(extent={{10,-120},{30,-100}})));

  Buildings.DHC.ETS.Combined.Controls.Reset resTHeaSup(
    final TWatSupSetMinMax=THeaWatSupSetMin)
    "Heating water supply temperature reset"
    annotation (Placement(transformation(extent={{-230,70},{-210,90}})));
  Buildings.DHC.ETS.Combined.Controls.Reset resTCooSup(
    final TWatSupSetMinMax=TChiWatSupSetMax)
    "Chilled water supply temperature reset"
    annotation (Placement(transformation(extent={{-230,0},{-210,20}})));
  Buildings.Controls.OBC.CDL.Reals.Max maxTSup(
  u1(final unit="K", displayUnit="degC"),
  u2(final unit="K", displayUnit="degC"),
  y(final unit="K", displayUnit="degC"))
  "Maximum to pick the larger value of space heating or hot water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-100,36},{-80,56}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delSta(delayTime=30)
    "Delay start of compressor to ensure pumps have sufficient speed"
    annotation (Placement(transformation(extent={{148,90},{168,110}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay delPumOff(delayTime=30)
    "Delay pump off signal to allow compressor to ramp down"
    annotation (Placement(transformation(extent={{202,180},{222,200}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{160,180},{180,200}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2
    annotation (Placement(transformation(extent={{240,180},{260,200}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter dTOffHea(
    p=dTOffSetHea,
    u(final unit="K", displayUnit="degC"),
    y(final unit="K", displayUnit="degC"))
    "Offset to slightly increase the set point"
    annotation (Placement(transformation(extent={{-270,60},{-250,80}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter dTOffCoo(
    p=dTOffSetCoo,
    u(final unit="K", displayUnit="degC"),
    y(final unit="K", displayUnit="degC"))
    "Offset to slightly decrease the set point"
    annotation (Placement(transformation(extent={{-270,-30},{-250,-10}})));
equation
  connect(uCoo,heaOrCoo.u2)
    annotation (Line(points={{-300,120},{-194,120},{-194,182},{-142,182}},
                                                                      color={255,0,255}));
  connect(TEvaWatLvg,conCoo. u_m) annotation (Line(points={{-300,-50},{-180,-50},
          {-180,72},{0,72},{0,88}},  color={0,0,127}));
  connect(TConWatLvg, conHea.u_m) annotation (Line(points={{-300,30},{-196,30},
          {-196,116},{0,116},{0,138}},
                              color={0,0,127}));
  connect(conCoo.uEna, uCoo) annotation (Line(points={{-4,88},{-4,80},{-184,80},
          {-184,120},{-300,120}},
                                color={255,0,255}));
  connect(hea.u1, uHeaSpa)
    annotation (Line(points={{-182,200},{-300,200}}, color={255,0,255}));
  connect(hea.u2, uHeaDhw) annotation (Line(points={{-182,192},{-208,192},{-208,
          160},{-300,160}}, color={255,0,255}));
  connect(hea.y, heaOrCoo.u1) annotation (Line(points={{-158,200},{-150,200},{
          -150,190},{-142,190}},
                            color={255,0,255}));
  connect(hea.y, conHea.uEna) annotation (Line(points={{-158,200},{-150,200},{
          -150,130},{-4,130},{-4,138}},color={255,0,255}));
  connect(movAveHea.u, conHea.y) annotation (Line(points={{38,170},{20,170},{20,
          150},{12,150}},         color={0,0,127}));
  connect(conCoo.y, movAveCoo.u) annotation (Line(points={{12,100},{20,100},{20,
          120},{38,120}},         color={0,0,127}));
  connect(movAveHea.y, heaDom.u1) annotation (Line(points={{62,170},{70,170},{
          70,150},{78,150}},   color={0,0,127}));
  connect(movAveCoo.y, heaDom.u2) annotation (Line(points={{62,120},{70,120},{
          70,142},{78,142}},   color={0,0,127}));
  connect(heaDom.y, swi.u2)
    annotation (Line(points={{102,150},{110,150}}, color={255,0,255}));
  connect(conHea.y, swi.u1) annotation (Line(points={{12,150},{20,150},{20,186},
          {108,186},{108,158},{110,158}},      color={0,0,127}));
  connect(conCoo.y, swi.u3) annotation (Line(points={{12,100},{106,100},{106,
          142},{110,142}},
                      color={0,0,127}));
  connect(zer.y, swi1.u3) annotation (Line(points={{170,70},{188,70},{188,92},{200,
          92}},       color={0,0,127}));
  connect(swiTSupSetHea.u2, uHeaDhw) annotation (Line(points={{-62,40},{-72,40},
          {-72,160},{-300,160}},  color={255,0,255}));
  connect(conValHea.u_s, offSetHea.y)
    annotation (Line(points={{38,-50},{32,-50}},     color={0,0,127}));
  connect(TConWatLvg, conValHea.u_m) annotation (Line(points={{-300,30},{-196,
          30},{-196,-80},{50,-80},{50,-62}},
                                           color={0,0,127}));
  connect(conValCoo.u_s, offSetCoo.y)
    annotation (Line(points={{38,-110},{32,-110}},   color={0,0,127}));
  connect(conValHea.y, yValCon)
    annotation (Line(points={{62,-50},{146,-50},{146,0},{300,0}},
                                               color={0,0,127}));
  connect(conValCoo.y, yValEva)
    annotation (Line(points={{62,-110},{146,-110},{146,-60},{300,-60}},
                                                   color={0,0,127}));
  connect(resTHeaSup.TWatSupSet, swiTSupSetHea.u3) annotation (Line(points={{-208,80},
          {-190,80},{-190,8},{-88,8},{-88,32},{-62,32}},
                                                   color={0,0,127}));
  connect(resTCooSup.TWatSupSet, conCoo.u_s) annotation (Line(points={{-208,10},
          {-200,10},{-200,100},{-12,100}},  color={0,0,127}));
  connect(resTCooSup.u, uCoo) annotation (Line(points={{-232,16},{-274,16},{
          -274,120},{-300,120}}, color={255,0,255}));
  connect(resTHeaSup.u, uHeaSpa) annotation (Line(points={{-232,86},{-248,86},{
          -248,200},{-300,200}}, color={255,0,255}));
  connect(maxTSup.y, swiTSupSetHea.u1) annotation (Line(points={{-78,46},{-70,
          46},{-70,48},{-62,48}},   color={0,0,127}));
  connect(TSupSetDhw.y, maxTSup.u1)
    annotation (Line(points={{-112,52},{-102,52}}, color={0,0,127}));
  connect(resTHeaSup.TWatSupSet, maxTSup.u2) annotation (Line(points={{-208,80},
          {-190,80},{-190,30},{-108,30},{-108,40},{-102,40}}, color={0,0,127}));
  connect(TEvaWatLvg, conValCoo.u_m) annotation (Line(points={{-300,-50},{-210,-50},
          {-210,-140},{50,-140},{50,-122}},        color={0,0,127}));
  connect(resTCooSup.TWatSupSet, offSetCoo.u) annotation (Line(points={{-208,10},
          {-200,10},{-200,-110},{8,-110}},         color={0,0,127}));
  connect(delSta.y, swi1.u2)
    annotation (Line(points={{170,100},{200,100}}, color={255,0,255}));
  connect(delSta.u, heaOrCoo.y) annotation (Line(points={{146,100},{140,100},{140,
          190},{-118,190}},     color={255,0,255}));
  connect(swi.y, swi1.u1) annotation (Line(points={{134,150},{180,150},{180,108},
          {200,108}}, color={0,0,127}));
  connect(swi1.y, ramLimCom.u)
    annotation (Line(points={{224,100},{238,100}}, color={0,0,127}));
  connect(ramLimCom.y,yCom)  annotation (Line(points={{262,100},{298,100}},
                           color={0,0,127}));
  connect(heaOrCoo.y, not1.u)
    annotation (Line(points={{-118,190},{158,190}}, color={255,0,255}));
  connect(not1.y, delPumOff.u)
    annotation (Line(points={{182,190},{200,190}}, color={255,0,255}));
  connect(delPumOff.y, not2.u)
    annotation (Line(points={{224,190},{238,190}}, color={255,0,255}));
  connect(not2.y, yPum)
    annotation (Line(points={{262,190},{300,190}}, color={255,0,255}));
  connect(yComOn, delSta.y) annotation (Line(points={{300,150},{184,150},{184,100},
          {170,100}}, color={255,0,255}));
  connect(offSetHea.u, swiTSupSetHea.y) annotation (Line(points={{8,-50},{-20,
          -50},{-20,40},{-38,40}},
                              color={0,0,127}));
  connect(swiTSupSetHea.y, conHea.u_s) annotation (Line(points={{-38,40},{-20,
          40},{-20,150},{-12,150}},
                                color={0,0,127}));
  connect(TChiWatSupSet, dTOffCoo.u)
    annotation (Line(points={{-300,-20},{-272,-20}}, color={0,0,127}));
  connect(dTOffCoo.y, resTCooSup.TWatSupPreSet) annotation (Line(points={{-248,
          -20},{-240,-20},{-240,4},{-232,4}}, color={0,0,127}));
  connect(THeaWatSupSet, dTOffHea.u)
    annotation (Line(points={{-300,70},{-272,70}}, color={0,0,127}));
  connect(dTOffHea.y, resTHeaSup.TWatSupPreSet) annotation (Line(points={{-248,
          70},{-240,70},{-240,74},{-232,74}}, color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          textColor={0,0,255},
          extent={{-100,100},{102,140}},
          textString="%name")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-280,-220},{280,220}})),
    defaultComponentName="con",
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This is a controller for the chiller system, which includes the dedicated
condenser and evaporator pumps.
</p>
<p>
The system is enabled if any of the input control signals <code>uHea</code>
or <code>uCoo</code> is <code>true</code>.
When enabled,
</p>
<ul>
<li>
the condenser and evaporator pumps are operated at constant speed,
</li>
<li>
the condenser (resp. evaporator) mixing valve is modulated with a PI
loop controlling the minimum (resp. maximum) inlet temperature.
</li>
</ul>
<h4>ESTCP adaptation</h4>
<p>
Adapted from Buildings.Obsolete.DHC.ETS.Combined.Controls.Chiller.
A PI controller for compressor speed is added in order to use
the ModularReversible component to replace the original EIR model.
</p>
<p>
An additional input has been added for the heating water supply temperature,
and a PI controller has been added.
</p>
<p>
A rate limiter has been added to avoid a sharp change in cooling load.
This was done before the heating water supply temperature controller was
added, and may no longer be needed.
</p>
</html>"));
end HeatPumpModular;
