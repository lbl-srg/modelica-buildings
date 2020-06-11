within Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints;
block ZoneGroupStatus "Block that outputs the zone group status"

  parameter Integer numZon(min=2)=5 "number of zones in the zone group";

  CDL.Continuous.MultiMax mulMax1(nin=numZon)
    annotation (Placement(transformation(extent={{-10,90},{10,110}})));
  CDL.Continuous.MultiMax mulMax4(nin=numZon)
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
  CDL.Interfaces.BooleanInput uHigOccCoo[numZon]
    "True when the zone temperature is higher than the occupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.BooleanInput uHigUnoCoo[numZon]
    "True when the zone temperature is higher than unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{-140,-150},{-100,-110}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));
  CDL.Interfaces.IntegerInput uColZon[numZon] "Cool zone" annotation (Placement(
        transformation(extent={{-140,-70},{-100,-30}}),   iconTransformation(
          extent={{-140,0},{-100,40}})));
  CDL.Interfaces.IntegerInput uHotZon[numZon] "Hot zone" annotation (Placement(
        transformation(extent={{-140,-190},{-100,-150}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));
  CDL.Continuous.MultiMax mulMax(nin=numZon)    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  CDL.Continuous.MultiMin mulMin(nin=numZon)    annotation (Placement(transformation(extent={{-10,-120},{10,-100}})));
  CDL.Interfaces.RealInput TZon[numZon](
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Zone temperature"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  CDL.Interfaces.RealOutput yWarTim(
    final unit="s",
    final quantity="Time") "Warm-up time"
    annotation (Placement(transformation(extent={{100,50},{140,90}}),
        iconTransformation(extent={{100,50},{140,90}})));
  CDL.Interfaces.RealOutput TZonMax(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Maximum zone temperature in the zone group" annotation (Placement(
        transformation(extent={{100,-100},{140,-60}}), iconTransformation(
          extent={{100,-70},{140,-30}})));
  CDL.Interfaces.RealOutput TZonMin(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
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
  CDL.Interfaces.RealOutput yCooTim(
    final unit="s",
    final quantity="Time")
    "Cool down time" annotation (Placement(transformation(extent={{100,80},{140,
            120}}), iconTransformation(extent={{100,70},{140,110}})));
  CDL.Interfaces.RealInput TZonCooSetOcc[numZon](
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature") "Occupied zone cooling setpoint"
    annotation (Placement(transformation(extent={{-140,-230},{-100,-190}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.RealInput TZonCooSetUno[numZon](
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Unoccupied zone cooling setpoint" annotation (Placement(transformation(
          extent={{-140,-260},{-100,-220}}), iconTransformation(extent={{-140,-100},
            {-100,-60}})));
  CDL.Interfaces.RealInput TZonHeaSetOcc[numZon](
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Occupied zone heating setpoint"
    annotation (Placement(transformation(extent={{-140,-290},{-100,-250}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));
  CDL.Interfaces.RealInput TZonHeaSetUno[numZon](
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Unoccupied zone heating setpoint" annotation (Placement(transformation(
          extent={{-140,-320},{-100,-280}}), iconTransformation(extent={{-140,-140},
            {-100,-100}})));
  CDL.Interfaces.RealInput uCooTim[numZon](final unit="s", final quantity="Time")
    "Cool down time" annotation (Placement(transformation(extent={{-140,80},{-100,
            120}}), iconTransformation(extent={{-140,80},{-100,120}})));
  CDL.Interfaces.BooleanInput uUnoHeaHig[numZon]
    "True when the unoccupied heating setpoint is higher than zone temperature"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.BooleanInput uOccHeaHig[numZon]
    "True when the occupied heating setpoint temperature is higher than the zone temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  CDL.Continuous.MultiMin mulMin2(nin=numZon)
    annotation (Placement(transformation(extent={{-10,-220},{10,-200}})));
  CDL.Continuous.MultiMin mulMin3(nin=numZon)
    annotation (Placement(transformation(extent={{-10,-250},{10,-230}})));
  CDL.Continuous.MultiMax mulMax2(nin=numZon)
    annotation (Placement(transformation(extent={{-10,-280},{10,-260}})));
  CDL.Continuous.MultiMax mulMax3(nin=numZon)
    annotation (Placement(transformation(extent={{-10,-310},{10,-290}})));
  CDL.Interfaces.RealOutput TGroCooOcc(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone group occupied cooling setpoint" annotation (Placement(transformation(
          extent={{100,-230},{140,-190}}), iconTransformation(extent={{100,-130},
            {140,-90}})));
  CDL.Interfaces.RealOutput TGroCooUno(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone group unoccupied cooling setpoint" annotation (Placement(
        transformation(extent={{100,-260},{140,-220}}), iconTransformation(
          extent={{100,-150},{140,-110}})));
  CDL.Interfaces.RealOutput TGroHeaOcc(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone group occupied heating setpoint" annotation (Placement(transformation(
          extent={{100,-290},{140,-250}}), iconTransformation(extent={{100,-170},
            {140,-130}})));
  CDL.Interfaces.RealOutput TGroHeaUno(
    final unit="K",
    final displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone group unoccupied heating setpoint" annotation (Placement(
        transformation(extent={{100,-320},{140,-280}}), iconTransformation(
          extent={{100,-190},{140,-150}})));
  CDL.Interfaces.RealInput uWarTim[numZon](
    final unit="s",
    final quantity="Time")
    "Occupied zone cooling setpoint" annotation (
      Placement(transformation(extent={{-140,50},{-100,90}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
equation
  connect(mulMax.y, TZonMax) annotation (Line(points={{12,-80},{120,-80}},
                       color={0,0,127}));
  connect(mulMin.y, TZonMin) annotation (Line(points={{12,-110},{120,-110}},
                       color={0,0,127}));
  connect(mulMax1.y, yCooTim) annotation (Line(points={{12,100},{120,100}},
                    color={0,0,127}));
  connect(mulMax4.y, yWarTim) annotation (Line(points={{12,70},{120,70}},
                    color={0,0,127}));
  connect(mulOr.y, yOccHeaHig)   annotation (Line(points={{12,40},{120,40}}, color={255,0,255}));
  connect(mulOr1.y, yHigOccCoo)  annotation (Line(points={{12,10},{120,10}}, color={255,0,255}));
  connect(mulSumInt.y, yColZon)  annotation (Line(points={{12,-50},{120,-50}}, color={255,127,0}));
  connect(mulOr3.y, yHigUnoCoo)   annotation (Line(points={{12,-140},{120,-140}}, color={255,0,255}));
  connect(mulSumInt1.y, yHotZon)   annotation (Line(points={{12,-170},{120,-170}}, color={255,127,0}));
  connect(mulOr2.y, yUnoHeaHig)  annotation (Line(points={{12,-20},{120,-20}}, color={255,0,255}));
  connect(uCooTim, mulMax1.u)   annotation (Line(points={{-120,100},{-12,100}}, color={0,0,127}));
  connect(uUnoHeaHig, mulOr2.u)   annotation (Line(points={{-120,-20},{-12,-20}}, color={255,0,255}));
  connect(uOccHeaHig, mulOr.u)  annotation (Line(points={{-120,40},{-12,40}}, color={255,0,255}));
  connect(mulMin2.y, TGroCooOcc)   annotation (Line(points={{12,-210},{120,-210}}, color={0,0,127}));
  connect(mulMin3.y, TGroCooUno)   annotation (Line(points={{12,-240},{120,-240}}, color={0,0,127}));
  connect(mulMax2.y, TGroHeaOcc)   annotation (Line(points={{12,-270},{120,-270}}, color={0,0,127}));
  connect(mulMax3.y, TGroHeaUno)    annotation (Line(points={{12,-300},{120,-300}}, color={0,0,127}));

  connect(TZonCooSetOcc, mulMin2.u)
    annotation (Line(points={{-120,-210},{-12,-210}}, color={0,0,127}));
  connect(TZonCooSetUno, mulMin3.u)
    annotation (Line(points={{-120,-240},{-12,-240}}, color={0,0,127}));
  connect(TZonHeaSetOcc, mulMax2.u)
    annotation (Line(points={{-120,-270},{-12,-270}}, color={0,0,127}));
  connect(TZonHeaSetUno, mulMax3.u)
    annotation (Line(points={{-120,-300},{-12,-300}}, color={0,0,127}));
  connect(uHotZon, mulSumInt1.u)
    annotation (Line(points={{-120,-170},{-12,-170}}, color={255,127,0}));
  connect(uHigUnoCoo, mulOr3.u) annotation (Line(points={{-120,-130},{-66,-130},
          {-66,-140},{-12,-140}}, color={255,0,255}));
  connect(TZon, mulMax.u)
    annotation (Line(points={{-120,-80},{-12,-80}}, color={0,0,127}));
  connect(TZon, mulMin.u) annotation (Line(points={{-120,-80},{-60,-80},{-60,-110},
          {-12,-110}}, color={0,0,127}));
  connect(uColZon, mulSumInt.u)
    annotation (Line(points={{-120,-50},{-12,-50}}, color={255,127,0}));
  connect(uHigOccCoo, mulOr1.u)
    annotation (Line(points={{-120,10},{-12,10}}, color={255,0,255}));
  connect(uWarTim,mulMax4. u)
    annotation (Line(points={{-120,70},{-12,70}}, color={0,0,127}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-320},{100,120}})));
end ZoneGroupStatus;
