within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences.Validation;
model EconomizerMultiZone_TSup_VOut
  "Validation model for the multizone economizer model."
                                    //fixme: add mos file
  extends Modelica.Icons.Example;

  parameter Real TOutCutoff(unit="K", quantity="TermodynamicTemperature")=297 "Outdoor temperature high limit cutoff";
  parameter Real hOutCutoff(unit="J/kg", quantity="SpecificEnergy")=65100 "Outdoor air enthalpy high limit cutoff";
  parameter Real airflowSetpoint(unit="m3/s", displayUnit="m3/h")=0.71
    "Example volumetric airflow setpoint, 15cfm/occupant, 100 occupants";
  parameter Real TSupSet(unit="K", quantity="TermodynamicTemperature")=291 "Supply air temperature setpoint";

  EconomizerMultiZone economizer
    annotation (Placement(transformation(extent={{80,-20},{100,0}})));
  CDL.Logical.Constant FanStatus(k=true) "Fan is on"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  CDL.Integers.Constant FreProSta(k=0) "Freeze Protection Status"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));
  CDL.Integers.Constant ZoneState(k=1) "Zone State is not heating"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  CDL.Integers.Constant AHUMode(k=1) "AHU System Mode (1 = Occupied)"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  CDL.Continuous.Constant hOutBelowCutoff(k=hOutCutoff - 1000)
    "Outdoor air enthalpy is slightly below the cufoff"
    annotation (Placement(transformation(extent={{-100,2},{-80,22}})));
  CDL.Continuous.Constant hOutCut(k=hOutCutoff) "Outdoor air enthalpy cutoff"
                                                    annotation (Placement(transformation(extent={{-100,
            -40},{-80,-20}})));
  CDL.Continuous.Constant TOutBellowCutoff(k=TOutCutoff - 2)
    "Outdoor air temperature is slightly below the cutoff"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  CDL.Continuous.Constant TOutCut1(
                                  k=TOutCutoff) annotation (Placement(transformation(extent={{-100,50},
            {-80,70}})));
  CDL.Continuous.Constant VOutMinSet(k=airflowSetpoint)
    "Outdoor airflow rate setpoint, example assumes 15cfm/occupant and 100 occupants"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Modelica.Blocks.Sources.Ramp VOut(
    duration=1800,
    height=0.2,
    offset=airflowSetpoint - 0.1)
    "TSup falls below 38 F and remains there for longer than 5 min."
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Ramp TSup(
    duration=900,
    height=4,
    offset=TSupSet - 2)    "Supply air temperature sensor output temperature"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  CDL.Continuous.Constant TSupSetSig(k=TSupSet)
    "Example supply air temperature setpoint. The economizer control uses cooling supply temperature."
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
equation
  connect(FanStatus.y, economizer.uSupFan) annotation (Line(points={{1,-30},{10,
          -30},{10,-14},{79,-14}}, color={255,0,255}));
  connect(FreProSta.y, economizer.uFreProSta) annotation (Line(points={{1,-70},{
          20,-70},{20,-20},{79,-20}}, color={255,127,0}));
  connect(AHUMode.y, economizer.uAHUMode) annotation (Line(points={{-39,-70},{-30,
          -70},{-30,-52},{16,-52},{16,-16},{79,-16}}, color={255,127,0}));
  connect(ZoneState.y, economizer.uZoneState) annotation (Line(points={{-39,-40},
          {18,-40},{18,-18},{79,-18}}, color={255,127,0}));
  connect(TOutBellowCutoff.y, economizer.TOut) annotation (Line(points={{-79,90},
          {14,90},{14,2},{79,2}},color={0,0,127}));
  connect(TOutCut1.y, economizer.TOutCut) annotation (Line(points={{-79,60},{-70,
          60},{-70,50},{12,50},{12,0},{79,0}}, color={0,0,127}));
  connect(hOutBelowCutoff.y, economizer.hOut) annotation (Line(points={{-79,12},
          {-32,12},{-32,-2},{16,-2},{80,-2},{79,-2}}, color={0,0,127}));
  connect(hOutCut.y, economizer.hOutCut) annotation (Line(points={{-79,-30},{-70,
          -30},{-70,-20},{-32,-20},{-32,-4},{79,-4}}, color={0,0,127}));
  connect(VOut.y, economizer.uVOut) annotation (Line(points={{1,70},{12,70},{12,
          -10},{79,-10}}, color={0,0,127}));
  connect(VOutMinSet.y, economizer.uVOutMinSet) annotation (Line(points={{1,30},
          {10,30},{10,-12},{79,-12}}, color={0,0,127}));
  connect(TSup.y, economizer.TSup) annotation (Line(points={{-39,70},{-30,70},{-30,
          -6},{79,-6}}, color={0,0,127}));
  connect(TSupSetSig.y, economizer.TCooSet) annotation (Line(points={{-39,30},{-30,
          30},{-30,-8},{79,-8}}, color={0,0,127}));
  annotation (
    experiment(StopTime=1800.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/CompositeSequences/Validation/EconomizerMultiZone_TSup_VOut.mos"
    "Simulate and plot"),
  Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,120}}),
        graphics={Text(
          extent={{52,106},{86,84}},
          lineColor={28,108,200})}),
  experiment(StopTime=1800.0),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences.EconomizerMultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.CompositeSequences.EconomizerMultiZone</a>
for different control signals.
</p>
</html>", revisions="<html>
<ul>
<li>
June 12, 2017, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end EconomizerMultiZone_TSup_VOut;
