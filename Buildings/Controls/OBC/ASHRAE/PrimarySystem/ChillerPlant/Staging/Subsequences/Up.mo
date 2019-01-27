within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Up "Conditions to enable stage up"

  // fixme: pull OPRLup and OPRLdown out into chiller type staging packages
  parameter Integer numSta = 2
  "Number of stages";

  parameter Modelica.SIunits.Time delayStaCha = 15*60
  "Minimum chiller load time below or above current stage before a change is enabled";

  CDL.Interfaces.RealInput uOplrUp(final unit="1")
    "Operating part load ratio of the next higher stage"
    annotation (Placement(transformation(extent={{-120,30},{-80,70}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  CDL.Interfaces.RealInput uOplrUpMin(final unit="1")
    "Minimum operating part load ratio at the next stage up"
    annotation (Placement(transformation(extent={{-120,-10},{-80,30}}),
        iconTransformation(extent={{-120,10},{-100,30}})));
  CDL.Interfaces.RealInput dpChiWatPumSet(final unit="Pa", final quantity="PressureDifference")
    "Chilled water pump differential static pressure setpoint"
    annotation (Placement(transformation(extent={{-120,-130},{-80,-90}}),
      iconTransformation(extent={{-120,-80},{-100,-60}})));
  CDL.Interfaces.RealInput dpChiWatPum(final unit="Pa", final quantity="PressureDifference")
    "Chilled water pump differential static pressure"
    annotation (Placement(
    transformation(extent={{-120,-170},{-80,-130}}),  iconTransformation(
     extent={{-120,-100},{-100,-80}})));
  CDL.Interfaces.RealInput TChiWatSupSet(final unit="K", final quantity="ThermodynamicTemperature")
    "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-120,-50},{-80,-10}}),
    iconTransformation(extent={{-120,-30},{-100,-10}})));
  CDL.Interfaces.RealInput TChiWatSup(final unit="K", final quantity="ThermodynamicTemperature")
    "Chilled water return temperature"
    annotation (Placement(transformation(
      extent={{-120,-90},{-80,-50}}),    iconTransformation(extent={{-120,-50},
            {-100,-30}})));
  CDL.Interfaces.RealInput uOplr(final unit="1")
    "Operating part load ratio of the current stage" annotation (Placement(
        transformation(extent={{-120,110},{-80,150}}), iconTransformation(
          extent={{-120,80},{-100,100}})));
  CDL.Interfaces.RealInput uSplrUp(final unit="1")
    "Staging part load ratio of the next stage up" annotation (Placement(
        transformation(extent={{-120,80},{-80,120}}), iconTransformation(extent={{-120,60},
            {-100,80}})));
  CDL.Logical.Or orStaUp "Or for staging up"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  FailsafeCondition faiSafCon
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  EfficiencyCondition effCon
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  CDL.Interfaces.BooleanOutput y "Efficiency condition for chiller staging"
    annotation (Placement(transformation(extent={{100,-10},{120,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));
equation
  connect(uOplr, effCon.uOplr) annotation (Line(points={{-100,130},{-71,130},{-71,
          125},{-1,125}}, color={0,0,127}));
  connect(uSplrUp, effCon.uSplrUp) annotation (Line(points={{-100,100},{-70,100},
          {-70,115},{-1,115}}, color={0,0,127}));
  connect(uOplrUp, faiSafCon.uOplrUp) annotation (Line(points={{-100,50},{-10,50},
          {-10,-62},{-1,-62}}, color={0,0,127}));
  connect(uOplrUpMin, faiSafCon.uOplrUpMin) annotation (Line(points={{-100,10},{
          -20,10},{-20,-66},{-1,-66}}, color={0,0,127}));
  connect(TChiWatSupSet, faiSafCon.TChiWatSupSet) annotation (Line(points={{-100,
          -30},{-30,-30},{-30,-71},{-1,-71}}, color={0,0,127}));
  connect(TChiWatSup, faiSafCon.TChiWatSup) annotation (Line(points={{-100,-70},
          {-40,-70},{-40,-73},{-1,-73}}, color={0,0,127}));
  connect(dpChiWatPumSet, faiSafCon.dpChiWatPumSet) annotation (Line(points={{-100,
          -110},{-40,-110},{-40,-77},{-1,-77}}, color={0,0,127}));
  connect(dpChiWatPum, faiSafCon.dpChiWatPum) annotation (Line(points={{-100,-150},
          {-20,-150},{-20,-79},{-1,-79}}, color={0,0,127}));
  connect(effCon.y, orStaUp.u1) annotation (Line(points={{21,120},{40,120},{40,0},
          {58,0}}, color={255,0,255}));
  connect(faiSafCon.y, orStaUp.u2) annotation (Line(points={{21,-70},{40,-70},{40,
          -8},{58,-8}}, color={255,0,255}));
  connect(orStaUp.y, y)
    annotation (Line(points={{81,0},{110,0}}, color={255,0,255}));
  annotation (defaultComponentName = "staUp",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),          Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-80,-160},{100,140}})),
Documentation(info="<html>
<p>
Outputs the chiller stage change signal

fixme: add a stage availability input signal, which will
remove the stage change delay if the stage is unavailable, to
allow for a change to the next available stage at the next instant.  

add WSE enable at plant enable part (input, output, predicted temperature) and at staging down from 1.
</p>
</html>",
revisions="<html>
<ul>
<li>
January xx, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Up;
