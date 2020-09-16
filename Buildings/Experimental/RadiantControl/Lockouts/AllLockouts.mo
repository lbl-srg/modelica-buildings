within Buildings.Experimental.RadiantControl.Lockouts;
block AllLockouts "Composite block of all lockouts: room air temperature, chilled water return, hysteresis, and night flush"
    parameter Real TAirHiSet(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="Temperature")=297.6
    "Air temperature high limit above which heating is locked out";
    parameter Real TAirLoSet(min=0,
    final unit="K",
    final displayUnit="degC",
    final quantity="Temperature")=293.15
    "Air temperature low limit below which heating is locked out";
   parameter Real TWaLoSet(min=0,
    final unit="K",
    final displayUnit="degC",
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
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Controls.OBC.CDL.Logical.And3 andCoo
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Controls.OBC.CDL.Interfaces.RealInput TWater
    annotation (Placement(transformation(extent={{-140,-90},{-100,-50}})));
  Controls.OBC.CDL.Interfaces.BooleanInput htgSig
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Controls.OBC.CDL.Interfaces.BooleanInput clgSig
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}})));
  Controls.OBC.CDL.Interfaces.RealInput TRooAir
    annotation (Placement(transformation(extent={{-140,-50},{-100,-10}})));
  Controls.OBC.CDL.Interfaces.BooleanInput nitFluSig
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput htgSigL
    "True if heating allowed, false if locked out"
    annotation (Placement(transformation(extent={{100,10},{140,50}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput clgSigL
    "True if cooling allowed, false if cooling locked out"
    annotation (Placement(transformation(extent={{100,-70},{140,-30}})));
  SubLockouts.HysteresisLimit hysteresisLimit1(TiHea=TiHea, TiCoo=TiCoo)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  SubLockouts.AirTemperatureLimit airTemperatureLimit(TAirHiSet=TAirHiSet,
      TAirLoSet=TAirLoSet)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  SubLockouts.NightFlush nightFlush
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  SubLockouts.CHWReturnLimit cHWReturnLimit(TWaLoSet=TWaLoSet, TiCHW=TiCHW)
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
equation
  connect(andHea.y, htgSigL)
    annotation (Line(points={{82,30},{120,30}}, color={255,0,255}));
  connect(andCoo.y, clgSigL)
    annotation (Line(points={{82,-50},{120,-50}}, color={255,0,255}));
  connect(htgSig, hysteresisLimit1.heaSig) annotation (Line(points={{-120,50},{
          -80,50},{-80,-5.8},{-42.2,-5.8}}, color={255,0,255}));
  connect(clgSig, hysteresisLimit1.cooSig) annotation (Line(points={{-120,10},{
          -84,10},{-84,-18},{-42,-18}}, color={255,0,255}));
  connect(hysteresisLimit1.htgSigHys, andHea.u3) annotation (Line(points={{-18,
          -8},{20,-8},{20,22},{58,22}}, color={255,0,255}));
  connect(hysteresisLimit1.clgSigHys, andCoo.u2) annotation (Line(points={{-18,
          -18},{20,-18},{20,-50},{58,-50}}, color={255,0,255}));
  connect(TRooAir, airTemperatureLimit.TRoo) annotation (Line(points={{-120,-30},
          {-73,-30},{-73,37.2},{-42,37.2}}, color={0,0,127}));
  connect(airTemperatureLimit.htgSigAirTem, andHea.u2) annotation (Line(points=
          {{-18,33},{20,33},{20,30},{58,30}}, color={255,0,255}));
  connect(airTemperatureLimit.clgSigAirTem, andCoo.u1) annotation (Line(points=
          {{-18,25},{30,25},{30,-42},{58,-42}}, color={255,0,255}));
  connect(nitFluSig, nightFlush.nitFluSig) annotation (Line(points={{-120,90},{
          -82,90},{-82,70},{-42.2,70}}, color={255,0,255}));
  connect(nightFlush.htgSigNitFlu, andHea.u1) annotation (Line(points={{-18,70},
          {20,70},{20,38},{58,38}}, color={255,0,255}));
  connect(TWater, cHWReturnLimit.TWater) annotation (Line(points={{-120,-70},{-80,
          -70},{-80,-68},{-42,-68}}, color={0,0,127}));
  connect(cHWReturnLimit.cooSigCHWRet, andCoo.u3) annotation (Line(points={{-18,
          -69},{20,-69},{20,-58},{58,-58}}, color={255,0,255}));
  annotation (defaultComponentName = "AllLockouts",Documentation(info="<html>
<p>
This block encompasses all lockouts.
<p> 
Heating lockouts are as follows:<p>
<p>
1. Air Temperature Lockout: Heating is locked out if room air temperature is above a user-specified temperature threshold (typically 76F). <p>
<p> 2. Night Flush Lockout: Heating is locked out if night flush mode is on, as night flush setpoints are typically below heating setpoint, but heating is not desired during night flush operation,
as this would waste energy and negate the cooling effect of the flush. <p>
<p>3. Hysteresis Lockout: Heating is locked out if cooling was on within a user-specified amount of time (typically one hour).<p>
<p>Cooling lockouts are as follows:<p>
<p>1. Air Temperature Lockout: Cooling is locked out if room air temperature is below a user-specified temperature threshhold (typically 68F). <p>
<p> 2. Chilled Water Return Temperature Lockout: Cooling is locked out for a user-specified amount of time (typically 30 minutes) if chilled water return temperature is too cold, 
as this indicates that the room needs less cooling than is being provided. <p>
<p>3. Hysteresis Lockout: Cooling is locked out if heating was on within a user-specified amount of time (typically one hour).<p>

 <p>Output is expressed as a heating or cooling signal. If the heating signal is true, heating is allowed (ie, it is not locked out).
 If the cooling signal is true, cooling is allowed (ie, it is not locked out).<p>

  A true signal indicates only that heating or cooling is *permitted*- it does *not* indicate the actual status
  of the final heating or cooling signal, which depends on the slab temperature and slab setpoint (see Buildings.Experimental.RadiantControl.SlabTempSignal for more info).
  
  <p>
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
