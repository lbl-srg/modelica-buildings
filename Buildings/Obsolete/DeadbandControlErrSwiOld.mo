within Buildings.Obsolete;
block DeadbandControlErrSwiOld
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

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysRelax(uLow=-TDeaRel,
      uHigh=TDeaRel)
    "Call for heating or cooling in times of relaxed deadband, i.e. during unoccupied hours"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch
    "Switches between occupied and unoccupied deadband based on time of day"
    annotation (Placement(transformation(extent={{-40,-120},{-20,-100}})));
  Modelica.Blocks.Sources.BooleanPulse booleanPulse(width=w, period=86400)
    "1 if slab needs to meet occupied setpoint within tight deadband, 0 if looser deadband (after occupied hours)"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(uLow=-TDeaNor, uHigh=
        TDeaNor)
    "Call for heating or cooling in times of tight deadband, i.e. during occupied hours"
    annotation (Placement(transformation(extent={{-120,-62},{-100,-42}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Negates hysteresis for heating control"
    annotation (Placement(transformation(extent={{20,-26},{40,-6}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput slabTempError
    annotation (Placement(transformation(extent={{-196,-158},{-156,-118}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput heatingCall
    "True if there is a call for heating; false if not"
    annotation (Placement(transformation(extent={{150,-10},{190,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput coolingCall
    "True if there is a call for cooling; false if not"
    annotation (Placement(transformation(extent={{150,-110},{190,-70}})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch1
    "Switches between occupied and unoccupied deadband based on time of day"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Abs abs
    "Absolute value of difference between slab setpoint and slab temp"
    annotation (Placement(transformation(extent={{-124,42},{-104,62}})));
  Modelica.Blocks.Sources.Constant occError(k=TDeaNor)
    "Error tolerance during occupied hours"
    annotation (Placement(transformation(extent={{-80,58},{-60,78}})));
  Modelica.Blocks.Sources.Constant unoccError(k=TDeaRel)
    "Error tolerance during unoccupied hours"
    annotation (Placement(transformation(extent={{-78,-20},{-58,0}})));
  Modelica.Blocks.Logical.Greater greater
    "True if error is greater than occupied deadband"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  Modelica.Blocks.Logical.Greater greater1
    "True if error is greater than unoccupied deadband"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Modelica.Blocks.Logical.And and1
    "Makes sure no heating occurs if error is within deadband"
    annotation (Placement(transformation(extent={{124,2},{144,22}})));
  Modelica.Blocks.Logical.And and2
    "Makes sure no cooling occurs if error is within deadband"
    annotation (Placement(transformation(extent={{120,-102},{140,-82}})));
  Modelica.Blocks.Logical.LogicalSwitch logicalSwitch2
    "Passes signal if flow is allowed to stop if slab temp is within deadband; if flow is NOT allowed to stop, always passes true"
    annotation (Placement(transformation(extent={{80,118},{100,138}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant
    annotation (Placement(transformation(extent={{22,40},{42,60}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant1(k=
        off_within_deadband)
    annotation (Placement(transformation(extent={{22,80},{42,100}})));
protected
          parameter Real w=(k/24)*100 "Width of day";
equation
  connect(hysRelax.y,logicalSwitch. u3) annotation (Line(points={{-98,-130},{-80,
          -130},{-80,-118},{-42,-118}},
                                    color={255,0,255}));
  connect(booleanPulse.y,logicalSwitch. u2) annotation (Line(points={{-99,-90},{
          -70,-90},{-70,-110},{-42,-110}},
                                         color={255,0,255}));
  connect(hys.y,logicalSwitch. u1) annotation (Line(points={{-98,-52},{-70,-52},
          {-70,-102},{-42,-102}},
                                color={255,0,255}));
  connect(logicalSwitch.y,not1. u) annotation (Line(points={{-19,-110},{18,-110},
          {18,-16}},            color={255,0,255}));
  connect(slabTempError, hys.u) annotation (Line(points={{-176,-138},{-141,-138},
          {-141,-52},{-122,-52}},
                               color={0,0,127}));
  connect(slabTempError, hysRelax.u) annotation (Line(points={{-176,-138},{-140,
          -138},{-140,-130},{-122,-130}},
                                     color={0,0,127}));
  connect(slabTempError, abs.u) annotation (Line(points={{-176,-138},{-140,-138},
          {-140,52},{-126,52}},
                            color={0,0,127}));
  connect(booleanPulse.y, logicalSwitch1.u2) annotation (Line(points={{-99,-90},
          {-4,-90},{-4,130},{18,130}},
                                   color={255,0,255}));
  connect(abs.y, greater.u1) annotation (Line(points={{-102,52},{-102,90},{-42,
          90}},              color={0,0,127}));
  connect(occError.y, greater.u2) annotation (Line(points={{-59,68},{-42,68},{-42,
          82}},           color={0,0,127}));
  connect(unoccError.y, greater1.u2) annotation (Line(points={{-57,-10},{-46,-10},
          {-46,2},{-42,2}}, color={0,0,127}));
  connect(abs.y, greater1.u1) annotation (Line(points={{-102,52},{-102,10},{-42,
          10}},      color={0,0,127}));
  connect(greater.y, logicalSwitch1.u1) annotation (Line(points={{-19,90},{-14,90},
          {-14,138},{18,138}},color={255,0,255}));
  connect(greater1.y, logicalSwitch1.u3) annotation (Line(points={{-19,10},{10,10},
          {10,122},{18,122}}, color={255,0,255}));
  connect(not1.y, and1.u2) annotation (Line(points={{42,-16},{116,-16},{116,4},{
          122,4}},  color={255,0,255}));
  connect(logicalSwitch.y, and2.u2) annotation (Line(points={{-19,-110},{96,-110},
          {96,-100},{118,-100}},
                           color={255,0,255}));
  connect(logicalSwitch1.y, logicalSwitch2.u1) annotation (Line(points={{41,130},
          {56,130},{56,136},{78,136}},    color={255,0,255}));
  connect(logicalSwitch2.y, and2.u1) annotation (Line(points={{101,128},{106,128},
          {106,-92},{118,-92}}, color={255,0,255}));
  connect(booleanConstant.y, logicalSwitch2.u3) annotation (Line(points={{43,50},
          {74,50},{74,120},{78,120}},    color={255,0,255}));
  connect(logicalSwitch2.y, and1.u1) annotation (Line(points={{101,128},{106,128},
          {106,12},{122,12}}, color={255,0,255}));
  connect(booleanConstant1.y, logicalSwitch2.u2) annotation (Line(points={{43,90},
          {64,90},{64,128},{78,128}},    color={255,0,255}));
  connect(and2.y, coolingCall)
    annotation (Line(points={{141,-92},{142,-92},{142,-90},{170,-90}},
                                                  color={255,0,255}));
  connect(and1.y, heatingCall) annotation (Line(points={{145,12},{146,12},{146,10},
          {170,10}}, color={255,0,255}));
  annotation (Documentation(info="<html>
<p>
This determines calls for heating or cooling based on the slab error. 
</p>
</html>"),Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-150,-150},{150,150}}),  graphics={
        Text(
          lineColor={0,0,255},
          extent={{-150,110},{150,150}},
          textString="%name"),  Rectangle(
        extent={{-150,-150},{150,150}},
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
          textString=DynamicSelect("", String(y, leftjustified=false, significantDigits=3)))}), Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-150,
            -150},{150,150}})));
end DeadbandControlErrSwiOld;
