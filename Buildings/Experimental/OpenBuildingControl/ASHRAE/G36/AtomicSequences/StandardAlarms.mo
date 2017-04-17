within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.AtomicSequences;
model StandardAlarms
  "Freeze protection sequence according to G36 PART5.N.13 and O.10"

  CDL.Interfaces.RealInput TOut(unit="K", displayUnit="degC")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-180,120},
            {-140,160}}),      iconTransformation(extent={{-180,120},{-140,160}})));
  CDL.Interfaces.BooleanInput uFre(start=false) "Freezestat status" annotation (
     Placement(transformation(extent={{-180,-40},{-140,0}}), iconTransformation(
          extent={{-180,-40},{-140,0}})));
  CDL.Interfaces.RealInput TSup(unit="K", displayUnit="degC")
    "Supply air temperature" annotation (Placement(transformation(extent={{-180,40},
            {-140,80}}),      iconTransformation(extent={{-180,40},{-140,80}})));
  CDL.Logical.Switch assignDamperPosition
    "If control loop signal = 1 opens the damper to it's max position; if signal = 0 closes the damper to it's min position."
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  CDL.Logical.Hysteresis hysTOut(uHigh=297, final uLow=297 - 1)
    "Close damper when TOut is above the uHigh, open it again only when TOut falls down to uLow"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  //fixme: units for instantiated limits, example TOut limit is 75K, delta = 1K
  CDL.Logical.LessThreshold TSupThreshold(threshold=276.483)
    "fixme: timer still not implemented, threshold value provided in K, units not indicated. Fixme: add hysteresis"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  CDL.Logical.Timer timer1
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  CDL.Logical.Greater greater
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  CDL.Continuous.Constant TSupTimeLimit(k=300)
    "Max time during which TSup may be lower than temperature defined in the appropriate evaluation block. fixme: should this be a parameter, how do we deal with units"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  CDL.Interfaces.IntegerOutput y
    annotation (Placement(transformation(extent={{140,50},{160,70}})));
  CDL.Conversions.BooleanToInteger firStaFreePro
    "First Stage Freeze Protection "
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  CDL.Conversions.BooleanToInteger booleanToInteger1
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  CDL.Conversions.BooleanToInteger booleanToInteger2
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
  CDL.Integers.Add3 add3_1
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
equation
  connect(TOut, hysTOut.u) annotation (Line(points={{-160,140},{-160,140},{-100,
          140},{-100,100},{-100,100},{-62,100}},
                 color={0,0,127}));
  connect(TSupThreshold.y, timer1.u) annotation (Line(points={{-59,60},{-50,60},
          {-42,60}},                 color={255,0,255}));
  connect(TSupTimeLimit.y, greater.u2) annotation (Line(points={{-19,30},{-12,30},
          {-12,42},{-2,42}},      color={0,0,127}));
  connect(timer1.y, greater.u1) annotation (Line(points={{-19,60},{-12,60},{-12,
          50},{-2,50}},    color={0,0,127}));
  connect(TSup, TSupThreshold.u) annotation (Line(points={{-160,60},{-160,60},{-82,
          60}},               color={0,0,127}));
  connect(firStaFreePro.y, add3_1.u1) annotation (Line(points={{81,110},{88,110},
          {88,68},{98,68}}, color={255,127,0}));
  connect(booleanToInteger2.y, add3_1.u3) annotation (Line(points={{81,10},{90,10},
          {90,52},{98,52}}, color={255,127,0}));
  connect(booleanToInteger1.y, add3_1.u2)
    annotation (Line(points={{81,60},{89.5,60},{98,60}}, color={255,127,0}));
  connect(add3_1.y, y)
    annotation (Line(points={{121,60},{150,60},{150,60}}, color={255,127,0}));
  annotation (
    Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-140,-80},{140,200}},
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-100,-40},{100,160}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-60,0},{0,124},{60,0}},
          color={28,108,200},
          thickness=0.5),
        Line(
          points={{-34,54},{34,54}},
          color={28,108,200},
          thickness=0.5)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-140,-80},{140,200}},
        initialScale=0.1)),
    Documentation(info="<html>      
    <p>
    fixme:
    This is a placeholder for storing any input-output relationships related
    to Alarms, which occur while configuring sequences that we already created
    or are currently configuring.
    Alarms are being mentioned in most of the sequences throughout G36 and all
    sections should get harmonized, if possible, in this atomic sequence.
    </p>   
    <p>

    </p>
    <p>

    </p>

<p>

</p>
<p>

</p>

<p align=\"center\">
<img alt=\"fixme\"
src=\"modelica://Buildings/Resources/Images/Experimental/OpenBuildingControl/ASHRAE/G36/fixme.png\"/>
</p>

</html>", revisions="<html>
<ul>
<li>
April 17, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end StandardAlarms;
