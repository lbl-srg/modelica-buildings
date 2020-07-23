within Buildings.Experimental.RadiantControl.SlabTempSignal;
block DeadbandControlErrSwi
  "Outputs call for heating or cooling based on slab temperature error, i.e. difference between slab setpoint and actual slab temp. No heating or cooling allowed if slab temp is within deadband"
parameter Real TDeaRel(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=2.22 "Difference from slab temp setpoint required to trigger heating or cooling during occupied hours";
parameter Real TDeaNor(min=0,
    final unit="K",
    final displayUnit="K",
    final quantity="TemperatureDifference")=0.28
                                           "Difference from slab temp setpoint required to trigger heating or cooling during unoccpied hours";
  parameter Real k(min=0,max=24)=18 "Last occupied hour";
  parameter Boolean off_within_deadband=true "If flow should turn off when slab setpoint is within deadband, set to true. Otherwise, set to false";

  Controls.OBC.CDL.Continuous.Hysteresis           hysRelax(uLow=-TDeaRel, uHigh=TDeaRel)
    "Call for heating or cooling in times of relaxed deadband, i.e. during unoccupied hours"
    annotation (Placement(transformation(extent={{-40,-58},{-20,-38}})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
    "Switches between occupied and unoccupied deadband based on time of day"
    annotation (Placement(transformation(extent={{22,-20},{42,0}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=w, period=86400)
    "1 if slab needs to meet occupied setpoint within tight deadband, 0 if looser deadband (after occupied hours)"
    annotation (Placement(transformation(extent={{-38,0},{-18,20}})));
  Controls.OBC.CDL.Continuous.Hysteresis           hys(uLow=-TDeaNor, uHigh=TDeaNor)
    "Call for heating or cooling in times of tight deadband, i.e. during occupied hours"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Controls.OBC.CDL.Logical.Not           not1
    "Negates hysteresis for heating control"
    annotation (Placement(transformation(extent={{100,0},{120,20}})));
  Controls.OBC.CDL.Interfaces.RealInput slabTempError
    annotation (Placement(transformation(extent={{-220,8},{-180,48}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput heatingCall
    "True if there is a call for heating; false if not"
    annotation (Placement(transformation(extent={{240,28},{280,68}})));
  Controls.OBC.CDL.Interfaces.BooleanOutput coolingCall
    "True if there is a call for cooling; false if not"
    annotation (Placement(transformation(extent={{240,-50},{280,-10}})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch1
    "Switches between occupied and unoccupied deadband based on time of day"
    annotation (Placement(transformation(extent={{100,120},{120,140}})));
  Controls.OBC.CDL.Continuous.Abs           abs
    "Absolute value of difference between slab setpoint and slab temp"
    annotation (Placement(transformation(extent={{-118,120},{-98,140}})));
  Modelica.Blocks.Sources.Constant occError(k=TDeaNor)
    "Error tolerance during occupied hours"
    annotation (Placement(transformation(extent={{-40,140},{-20,160}})));
  Modelica.Blocks.Sources.Constant occError1(k=TDeaRel)
    "Error tolerance during occupied hours"
    annotation (Placement(transformation(extent={{-40,98},{-20,118}})));
  Modelica.Blocks.Logical.Greater greater
    "True if error is greater than occupied deadband"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Modelica.Blocks.Logical.Greater greater1
    "True if error is greater than unoccupied deadband"
    annotation (Placement(transformation(extent={{22,96},{42,116}})));
  Modelica.Blocks.Logical.And and1
    "Makes sure no heating occurs if error is within deadband"
    annotation (Placement(transformation(extent={{198,38},{218,58}})));
  Modelica.Blocks.Logical.And and2
    "Makes sure no cooling occurs if error is within deadband"
    annotation (Placement(transformation(extent={{200,-42},{220,-22}})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch2
    "Passes signal if flow is allowed to stop if slab temp is within deadband; if flow is NOT allowed to stop, always passes true"
    annotation (Placement(transformation(extent={{160,120},{180,140}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k=
        off_within_deadband)
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
protected
          parameter Real w=(k/24)*100 "Width of day";
equation
  connect(hysRelax.y,logicalSwitch. u3) annotation (Line(points={{-18,-48},{0,-48},
          {0,-18},{20,-18}},        color={255,0,255}));
  connect(booleanPulse.y,logicalSwitch. u2) annotation (Line(points={{-17,10},{0,
          10},{0,-10},{20,-10}},         color={255,0,255}));
  connect(hys.y,logicalSwitch. u1) annotation (Line(points={{-18,70},{0,70},{0,-2},
          {20,-2}},             color={255,0,255}));
  connect(logicalSwitch.y,not1. u) annotation (Line(points={{43,-10},{70,-10},{70,
          10},{98,10}},         color={255,0,255}));
  connect(slabTempError, hys.u) annotation (Line(points={{-200,28},{-121,28},
          {-121,70},{-42,70}}, color={0,0,127}));
  connect(slabTempError, hysRelax.u) annotation (Line(points={{-200,28},{-120,
          28},{-120,-48},{-42,-48}}, color={0,0,127}));
  connect(slabTempError, abs.u) annotation (Line(points={{-200,28},{-121,28},{-121,
          130},{-120,130}}, color={0,0,127}));
  connect(booleanPulse.y, logicalSwitch1.u2) annotation (Line(points={{-17,10},{
          0,10},{0,130},{98,130}}, color={255,0,255}));
  connect(abs.y, greater.u1) annotation (Line(points={{-96,130},{-96,174},{0,174},
          {0,150},{18,150}}, color={0,0,127}));
  connect(occError.y, greater.u2) annotation (Line(points={{-19,150},{0,150},{0,
          142},{18,142}}, color={0,0,127}));
  connect(occError1.y, greater1.u2) annotation (Line(points={{-19,108},{0,108},{
          0,98},{20,98}}, color={0,0,127}));
  connect(abs.y, greater1.u1) annotation (Line(points={{-96,130},{0,130},{0,106},
          {20,106}}, color={0,0,127}));
  connect(greater.y, logicalSwitch1.u1) annotation (Line(points={{41,150},{80,150},
          {80,138},{98,138}}, color={255,0,255}));
  connect(greater1.y, logicalSwitch1.u3) annotation (Line(points={{43,106},{80,106},
          {80,122},{98,122}}, color={255,0,255}));
  connect(not1.y, and1.u2) annotation (Line(points={{122,10},{188,10},{188,40},{
          196,40}}, color={255,0,255}));
  connect(and1.y, heatingCall)
    annotation (Line(points={{219,48},{260,48}}, color={255,0,255}));
  connect(and2.y, coolingCall)
    annotation (Line(points={{221,-32},{240,-32},{240,-30},{260,-30}},
                                                   color={255,0,255}));
  connect(logicalSwitch.y, and2.u2) annotation (Line(points={{43,-10},{72,-10},{
          72,-40},{198,-40}},
                           color={255,0,255}));
  connect(logicalSwitch1.y, logicalSwitch2.u1) annotation (Line(points={{121,130},
          {140,130},{140,138},{158,138}}, color={255,0,255}));
  connect(logicalSwitch2.y, and2.u1) annotation (Line(points={{181,130},{188,130},
          {188,-32},{198,-32}}, color={255,0,255}));
  connect(booleanConstant.y, logicalSwitch2.u3) annotation (Line(points={{121,50},
          {140,50},{140,122},{158,122}}, color={255,0,255}));
  connect(heatingCall, heatingCall)
    annotation (Line(points={{260,48},{260,48}}, color={255,0,255}));
  connect(logicalSwitch2.y, and1.u1) annotation (Line(points={{181,130},{188,130},
          {188,48},{196,48}}, color={255,0,255}));
  connect(booleanConstant1.y, logicalSwitch2.u2) annotation (Line(points={{121,90},
          {140,90},{140,130},{158,130}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This determines calls for heating or cooling based on the slab error. 
</p>
</html>"),Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}}), graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),  Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Line(points={{-80,68},{-80,-80}}, color={192,192,192}),
        Polygon(
          points={{-80,90},{-88,68},{-72,68},{-80,90}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-90,-70},{82,-70}}, color={192,192,192}),
        Polygon(
          points={{90,-70},{68,-62},{68,-78},{90,-70}},
          lineColor={192,192,192},
          fillColor={192,192,192},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-70},{-40,-70},{31,38}}),
        Text(
          extent={{-150,-150},{150,-110}},
          lineColor={0,0,0},
          textString="duration=%duration"),
        Line(points={{31,38},{86,38}}),
       Text(
          extent={{-72,78},{72,6}},
          lineColor={0,0,0},
          fillColor={0,0,0},
        fillPattern=FillPattern.Solid,
        textString="D"),
        Text(
          extent={{226,60},{106,10}},
          lineColor={0,0,0},
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-100},{240,180}})));
end DeadbandControlErrSwi;
