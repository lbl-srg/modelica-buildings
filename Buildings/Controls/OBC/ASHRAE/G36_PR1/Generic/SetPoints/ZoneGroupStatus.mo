within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints;
block ZoneGroupStatus "Block that outputs the zone group status"

  parameter Integer numZon(min=2)=5 "number of zones in the zone group";

  CDL.Continuous.MultiMax mulMax1(nin=numZon)
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  CDL.Continuous.MultiMin mulMin1(nin=numZon)
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  CDL.Logical.MultiOr mulOr(nu=numZon)
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  CDL.Logical.MultiOr mulOr1(nu=numZon)
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  CDL.Integers.MultiSum mulSumInt(nin=numZon)
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));
  CDL.Logical.MultiOr mulOr2(nu=numZon)
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  CDL.Logical.MultiOr mulOr3(nu=numZon)
    annotation (Placement(transformation(extent={{-10,-150},{10,-130}})));
  CDL.Integers.MultiSum mulSumInt1(nin=numZon)
    annotation (Placement(transformation(extent={{-10,-180},{10,-160}})));
  CDL.Interfaces.BooleanInput uOccHeaHig[numZon]
    "True when the occupied heating setpoint temperature is higher than the zone temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.BooleanInput uHigOccCoo[numZon]
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  CDL.Interfaces.BooleanInput uUnoHeaHig[numZon]
    "True when the unoccupied heating setpoint is higher than zone temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  CDL.Interfaces.BooleanInput uHigUnoCoo[numZon]
    "True when the zone temperature is higher than unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,-150},{-100,-110}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.IntegerInput uColZon[numZon] "Cool zone" annotation (Placement(
        transformation(extent={{-140,-70},{-100,-30}}),   iconTransformation(
          extent={{-140,-40},{-100,0}})));
  CDL.Interfaces.IntegerInput uHotZon[numZon] "Hot zone" annotation (Placement(
        transformation(extent={{-140,-190},{-100,-150}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  CDL.Continuous.MultiMax mulMax(nin=numZon)
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  CDL.Continuous.MultiMin mulMin(nin=numZon)
    annotation (Placement(transformation(extent={{-10,-120},{10,-100}})));
  CDL.Interfaces.RealInput TZon[numZon](
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Single zone temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Interfaces.RealOutput                        yWarTim(final unit="s",
      final quantity="Time") "Warm-up time"
    annotation (Placement(transformation(extent={{100,50},{140,90}}),
        iconTransformation(extent={{100,50},{140,90}})));
  CDL.Interfaces.RealOutput TZonMax(final unit="K", final quantity="ThermodynamicTemperature")
    "Maximum zone temperature in the zone group" annotation (Placement(
        transformation(extent={{100,-100},{140,-60}}), iconTransformation(
          extent={{100,-70},{140,-30}})));
  CDL.Interfaces.RealOutput TZonMin(final unit="K", final quantity="ThermodynamicTemperature")
    "Minimum zone temperature in the zone group" annotation (Placement(
        transformation(extent={{100,-130},{140,-90}}),  iconTransformation(
          extent={{100,-50},{140,-10}})));
  CDL.Interfaces.IntegerOutput yColZon
    "Output 1 when the zone is a cold zone; otherwise 0" annotation (Placement(
        transformation(extent={{100,-70},{140,-30}}), iconTransformation(extent=
           {{100,-10},{140,30}})));
  CDL.Interfaces.BooleanOutput yOccHeaHig
    "True when the occupied heating setpoint temperature is higher than the zone temperature"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),
        iconTransformation(extent={{100,30},{140,70}})));
  CDL.Interfaces.BooleanOutput yHigOccCoo
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{100,-10},{140,30}}),
        iconTransformation(extent={{100,10},{140,50}})));
  CDL.Interfaces.BooleanOutput yHigUnoCoo
    "True when the zone temperature is higher than unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{100,-160},{140,-120}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  CDL.Interfaces.BooleanOutput yUnoHeaHig
    "True when the unoccupied heating setpoint is higher than zone temperature"
    annotation (Placement(transformation(extent={{100,-40},{140,0}}),
        iconTransformation(extent={{100,-30},{140,10}})));
  CDL.Interfaces.IntegerOutput yHotZon
    "Output 1 when the zone is a hot zone; otherwise 0" annotation (Placement(
        transformation(extent={{100,-190},{140,-150}}), iconTransformation(
          extent={{100,-90},{140,-50}})));
  CDL.Interfaces.RealOutput yCooTim(final unit="s", final quantity="Time")
    "Cool down time" annotation (Placement(transformation(extent={{100,80},{140,
            120}}), iconTransformation(extent={{100,70},{140,110}})));
  CDL.Interfaces.RealInput uCooTim[numZon](final unit="s", final quantity="Time")
    "Cool down time" annotation (Placement(transformation(extent={{-140,80},{-100,
            120}}), iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.RealInput uWarTim[numZon](final unit="s", final quantity="Time")
    "Warm up time" annotation (Placement(transformation(extent={{-140,50},{-100,
            90}}), iconTransformation(extent={{-140,40},{-100,80}})));
equation
  connect(TZon, mulMax.u[1:numZon]) annotation (Line(points={{-120,-80},{-80,-80},
          {-80,-80},{-12,-80}},          color={0,0,127}));
  connect(TZon, mulMin.u[1:numZon]) annotation (Line(points={{-120,-80},{-80,-80},
          {-80,-110},{-12,-110}},        color={0,0,127}));
  connect(uHotZon, mulSumInt1.u[1:numZon]) annotation (Line(points={{-120,-170},
          {-48,-170},{-48,-170},{-12,-170}},                          color={255,
          127,0}));
  connect(uColZon, mulSumInt.u[1:numZon]) annotation (Line(points={{-120,-50},{-80,
          -50},{-80,-50},{-12,-50}},      color={255,127,0}));
  connect(uOccHeaHig, mulOr.u[1:numZon]) annotation (Line(points={{-120,40},{-80,
          40},{-80,40},{-12,40}},       color={255,0,255}));
  connect(uHigOccCoo, mulOr1.u[1:numZon]) annotation (Line(points={{-120,10},{-80,
          10},{-80,10},{-12,10}},         color={255,0,255}));
  connect(uUnoHeaHig, mulOr2.u[1:numZon]) annotation (Line(points={{-120,-20},{-80,
          -20},{-80,-20},{-12,-20}},                          color={255,0,255}));
  connect(uHigUnoCoo, mulOr3.u[1:numZon]) annotation (Line(points={{-120,-130},{
          -80,-130},{-80,-140},{-12,-140}},                   color={255,0,255}));
  connect(mulMax.y, TZonMax) annotation (Line(points={{12,-80},{120,-80}},
                       color={0,0,127}));
  connect(mulMin.y, TZonMin) annotation (Line(points={{12,-110},{120,-110}},
                       color={0,0,127}));
  connect(mulMax1.y, yCooTim) annotation (Line(points={{12,100},{120,100}},
                    color={0,0,127}));
  connect(mulMin1.y, yWarTim) annotation (Line(points={{12,70},{120,70}},
                    color={0,0,127}));
  connect(mulOr.y, yOccHeaHig)   annotation (Line(points={{12,40},{120,40}}, color={255,0,255}));
  connect(mulOr1.y, yHigOccCoo)  annotation (Line(points={{12,10},{120,10}}, color={255,0,255}));
  connect(mulSumInt.y, yColZon)  annotation (Line(points={{12,-50},{120,-50}}, color={255,127,0}));
  connect(mulOr3.y, yHigUnoCoo)   annotation (Line(points={{12,-140},{120,-140}}, color={255,0,255}));
  connect(mulSumInt1.y, yHotZon)   annotation (Line(points={{12,-170},{120,-170}}, color={255,127,0}));
  connect(mulOr2.y, yUnoHeaHig)  annotation (Line(points={{12,-20},{120,-20}}, color={255,0,255}));
  connect(uCooTim, mulMax1.u[1:numZon]) annotation (Line(points={{-120,100},{-66,100},
          {-66,100},{-12,100}},         color={0,0,127}));
  connect(uWarTim, mulMin1.u[1:numZon]) annotation (Line(points={{-120,70},{-66,
          70},{-66,70},{-12,70}},      color={0,0,127}));
  annotation (
  defaultComponentName = "zonGroSta",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,142},{100,104}},
          lineColor={0,0,255},
          textString="%name")}),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-200},{100,120}})));
end ZoneGroupStatus;
