within Buildings.Experimental.RadiantControl;
model ControlPlusLockouts
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
    parameter Real TiCHW(min=0,
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
  parameter Real TDeaRel(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=2.22 "Difference from slab temp setpoint required to trigger alarm during occupied hours";
parameter Real TDeaNor(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=0.28
                                           "Difference from slab temp setpoint required to trigger alarm during unoccpied hours";
  parameter Real k(min=0,max=24)=18 "Last occupied hour";
 parameter Boolean off_within_deadband=true "If flow should turn off when slab setpoint is within deadband, set to true. Otherwise, set to false";
  Controls.OBC.CDL.Logical.And and2 "Final Heating Signal"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));
  Controls.OBC.CDL.Logical.And and1 "Final cooling signal"
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  Controls.OBC.CDL.Interfaces.RealInput TRooAir
    annotation (Placement(transformation(extent={{-140,8},{-100,48}})));
  Controls.OBC.CDL.Interfaces.RealInput TSla
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Controls.OBC.CDL.Interfaces.RealInput TWaRet
    annotation (Placement(transformation(extent={{-140,-30},{-100,10}})));
  SlabTempSignal.Error error
    annotation (Placement(transformation(extent={{-58,40},{-38,60}})));
  Controls.OBC.CDL.Interfaces.RealInput TSlaSet
    annotation (Placement(transformation(extent={{-140,34},{-100,74}})));
  Controls.OBC.CDL.Interfaces.BooleanInput nightFlushLockout
    annotation (Placement(transformation(extent={{-142,-68},{-102,-28}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput heatingSignal
    annotation (Placement(transformation(extent={{180,30},{220,70}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput coolingSignal
    annotation (Placement(transformation(extent={{180,-30},{220,10}})));
  Lockouts.AllLockouts allLockouts1
    annotation (Placement(transformation(extent={{2,0},{22,20}})));
  SlabTempSignal.DeadbandControlErrSwi deadbandControlErrSwi
    annotation (Placement(transformation(extent={{22,40},{42,60}})));
  Modelica.Blocks.Logical.Pre pre1
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Modelica.Blocks.Logical.Pre pre2
    annotation (Placement(transformation(extent={{120,-60},{140,-40}})));
equation
  connect(error.TSlaSet, TSlaSet) annotation (Line(points={{-60,47},{-60,54},
          {-120,54}},          color={0,0,127}));
  connect(error.TSla, TSla) annotation (Line(points={{-60,51},{-60,80},{-120,
          80}},           color={0,0,127}));
  connect(and1.y, coolingSignal)
    annotation (Line(points={{102,-10},{200,-10}}, color={255,0,255}));
  connect(and2.y, heatingSignal)
    annotation (Line(points={{102,50},{200,50}}, color={255,0,255}));
  connect(nightFlushLockout, allLockouts1.NightFlushSig) annotation (Line(
        points={{-122,-48},{-58,-48},{-58,19},{0,19}}, color={255,0,255}));
  connect(TRooAir, allLockouts1.TRooAir) annotation (Line(points={{-120,28},{
          -56,28},{-56,7},{0,7}}, color={0,0,127}));
  connect(TWaRet, allLockouts1.TWater) annotation (Line(points={{-120,-10},{
          -56,-10},{-56,3},{0,3}}, color={0,0,127}));
  connect(allLockouts1.HtgLockout, and2.u2) annotation (Line(points={{24,13},
          {60,13},{60,42},{78,42}}, color={255,0,255}));
  connect(allLockouts1.ClgLockout, and1.u1) annotation (Line(points={{24,5},{
          60,5},{60,-10},{78,-10}}, color={255,0,255}));
  connect(error.slabTempError, deadbandControlErrSwi.slabTempError)
    annotation (Line(points={{-36,51},{-4,51},{-4,52.8},{12,52.8}}, color={0,
          0,127}));
  connect(deadbandControlErrSwi.heatingCall, and2.u1) annotation (Line(points=
         {{58,54.8},{70,54.8},{70,50},{78,50}}, color={255,0,255}));
  connect(deadbandControlErrSwi.coolingCall, and1.u2) annotation (Line(points=
         {{58,47},{60,47},{60,-18},{78,-18}}, color={255,0,255}));
  connect(and2.y, pre1.u) annotation (Line(points={{102,50},{110,50},{110,70},
          {118,70}}, color={255,0,255}));
  connect(pre1.y, allLockouts1.HtgSig) annotation (Line(points={{141,70},{156,
          70},{156,90},{-20,90},{-20,18},{0,18},{0,15}}, color={255,0,255}));
  connect(and1.y, pre2.u) annotation (Line(points={{102,-10},{110,-10},{110,
          -50},{118,-50}}, color={255,0,255}));
  connect(pre2.y, allLockouts1.ClgSig) annotation (Line(points={{141,-50},{
          142,-50},{142,-80},{-20,-80},{-20,11},{0,11}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This encompasses full radiant control based on water return temperature, room air temperature, night flush signal, slab temperature, and slab setpoint.
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
        Line(points={{-80,-70},{-40,-70},{31,38}}),
        Polygon(lineColor = {191,0,0},
                fillColor = {191,0,0},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{20,58},{100,-2},{20,-62},{20,58}}),
        Text(
          extent={{-72,78},{72,6}},
          lineColor={0,0,0},
        textString="R"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{180,100}})));
end ControlPlusLockouts;
