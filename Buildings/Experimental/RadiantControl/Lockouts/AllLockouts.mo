within Buildings.Experimental.RadiantControl.Lockouts;
block AllLockouts "Composite block of all lockouts: room air temperature, chilled water return, hysteresis, and night flush"
    parameter Real TAirHiSet(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=297.6
    "Air temperature high limit above which heating is locked out";
    parameter Real TAirLoSet(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=293.15
    "Air temperature low limit below which heating is locked out";
   parameter Real TWaLoSet(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="Temperature")=285.9
    "Lower limit for chilled water return temperature, below which cooling is locked out";
   parameter  Real TiCHW(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time")=1800 "Time for which cooling is locked if CHW return is too cold";

    parameter Real TiHea(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which heating is locked out after cooling concludes";
    parameter Real TiCoo(min=0,
    final unit="s",
    final displayUnit="s",
    final quantity="Time") = 3600 "Time for which cooling is locked out after heating concludes";

  Controls.OBC.CDL.Logical.And3 andHea
    annotation (Placement(transformation(extent={{58,20},{78,40}})));
  Controls.OBC.CDL.Logical.And3 andCoo
    annotation (Placement(transformation(extent={{60,-62},{80,-42}})));
  Controls.OBC.CDL.Interfaces.RealInput TWater
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Controls.OBC.CDL.Interfaces.BooleanInput HtgSig
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Controls.OBC.CDL.Interfaces.BooleanInput ClgSig
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}})));
  Controls.OBC.CDL.Interfaces.RealInput TRooAir
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Controls.OBC.CDL.Interfaces.BooleanInput NightFlushSig
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput HtgLockout
    "True if heating allowed, false if locked out"
    annotation (Placement(transformation(extent={{100,10},{140,50}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput ClgLockout
    "True if cooling allowed, false if cooling locked out"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}})));
  SubLockouts.HysteresisLimit hysteresisLimit1
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  SubLockouts.AirTemperatureLimit airTemperatureLimit
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  SubLockouts.NightFlush nightFlush
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  SubLockouts.CHWReturnLimit cHWReturnLimit
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
equation
  connect(andHea.y, HtgLockout)
    annotation (Line(points={{80,30},{120,30}}, color={255,0,255}));
  connect(andCoo.y, ClgLockout) annotation (Line(points={{82,-52},{90,-52},
          {90,-50},{120,-50}}, color={255,0,255}));
  connect(HtgSig, hysteresisLimit1.heatingSignal) annotation (Line(points={{-120,
          50},{-80,50},{-80,-3},{-66,-3}}, color={255,0,255}));
  connect(ClgSig, hysteresisLimit1.coolingSignal) annotation (Line(points={{-120,
          10},{-80,10},{-80,-19},{-66,-19}}, color={255,0,255}));
  connect(hysteresisLimit1.heatingSignal_Hysteresis, andHea.u3) annotation (
      Line(points={{-18,-10.6},{20,-10.6},{20,22},{56,22}}, color={255,0,255}));
  connect(hysteresisLimit1.coolingSignal_Hysteresis, andCoo.u2) annotation (
      Line(points={{-18,-19.2},{20,-19.2},{20,-52},{58,-52}}, color={255,0,255}));
  connect(TRooAir, airTemperatureLimit.TRoo) annotation (Line(points={{-120,-30},
          {-81,-30},{-81,37.2},{-42,37.2}}, color={0,0,127}));
  connect(airTemperatureLimit.heatingSignal_AirTemp, andHea.u2) annotation (
      Line(points={{-18,33},{20,33},{20,30},{56,30}}, color={255,0,255}));
  connect(airTemperatureLimit.coolingSignal_AirTemp, andCoo.u1) annotation (
      Line(points={{-18,25},{20,25},{20,-44},{58,-44}}, color={255,0,255}));
  connect(NightFlushSig, nightFlush.nightFlushSignal) annotation (Line(points={{
          -120,90},{-82,90},{-82,70},{-42.2,70}}, color={255,0,255}));
  connect(nightFlush.heatingSignal_NightFlush, andHea.u1) annotation (Line(
        points={{-18,70},{20,70},{20,38},{56,38}}, color={255,0,255}));
  connect(TWater, cHWReturnLimit.TWater) annotation (Line(points={{-120,-70},{-80,
          -70},{-80,-68},{-42,-68}}, color={0,0,127}));
  connect(cHWReturnLimit.coolingSignal_CHWReturn, andCoo.u3) annotation (Line(
        points={{-18,-69},{20,-69},{20,-60},{58,-60}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This block encompasses all lockouts. Heating is locked out if room air temperature is too hot, if night flush mode is on, or if cooling was on within a user-specified amount of time. 
Cooling is locked out if room air temperature is too cold, if chilled water return temperature is too cold, or if heating was on within a user-specified amount of time. 
</p>
</html>"),Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}),graphics={
        Text(
          lineColor={0,0,255},
          extent={{-148,104},{152,144}},
          textString="%name"),
        Rectangle(extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,0},{68,0}}, color={192,192,192}),
        Polygon(points={{90,0},{68,8}, {68,-8},{90,0}},
          lineColor={192,192,192}, fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,0},{80,0}}),
        Text(
        extent={{-56,90},{48,-88}},
        lineColor={0,0,0},
        fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="L"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end AllLockouts;
