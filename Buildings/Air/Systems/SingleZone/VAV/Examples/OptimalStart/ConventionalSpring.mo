within Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart;
model ConventionalSpring
  "Example model using the block OptimalStart with a conventional controller for a single-zone VAV system in spring"
  extends Modelica.Icons.Example;

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{82,2},{102,22}})));

  Buildings.Controls.OBC.Utilities.OptimalStart optSta(
    computeHeating=true,
    computeCooling=true,
    uLow=0.1,
    thrOptOn(displayUnit="s"))
    "Optimal start for heating and cooling system "
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TSetRooHea(
    table=[0,15 + 273.15; 8*3600,20 + 273.15; 18*3600,15 + 273.15; 24*3600,15 +
        273.15],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
    y(each unit="K",
      each displayUnit="degC"))
    "Heating setpoint for room temperature"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable TSetRooCoo(
    table=[0,30 + 273.15; 8*3600,24 + 273.15; 18*3600,30 + 273.15; 24*3600,30 +
        273.15],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.Periodic,
    y(each unit="K",
      each displayUnit="degC"))
    "Cooling setpoint for room temperature"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-100,-16},{-80,4}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetHeaOn(k=20 + 273.15)
    "Zone heating setpoint during occupied period"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetCooOn(k=24 + 273.15)
    "Zone cooling setpoint during occupied time"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(realTrue=-6)
    "Switch to occupied cooling setpoint"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1(realTrue=5)
    "Switch to occupied heating setpoint"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Add add3
    "New cooling setpoint schedule for room"
    annotation (Placement(transformation(extent={{40,34},{60,54}})));
  Buildings.Controls.OBC.CDL.Reals.Add add4
    "New heating setpoint schedule for room"
    annotation (Placement(transformation(extent={{40,64},{60,84}})));
  Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUConventional zonAHUOpt
    "Model of a single zone with AHU and controller"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUConventional zonAHUCon
    "Model of a single zone with AHU and controller"
    annotation (Placement(transformation(extent={{80,-70},{100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Occupied or optimal start for preconditioning"  annotation (Placement(transformation(extent={{40,0},{60,20}})));

equation
  connect(TSetHeaOn.y, optSta.TSetZonHea) annotation (Line(points={{-78,70},{-72,
          70},{-72,78},{-42,78}},   color={0,0,127}));
  connect(TSetRooCoo.y[1], add3.u2) annotation (Line(points={{-18,-80},{32,-80},
          {32,38},{38,38}},color={0,0,127}));
  connect(occSch.tNexOcc, optSta.tNexOcc) annotation (Line(points={{-79,0},{-66,
          0},{-66,62},{-42,62}},     color={0,0,127}));
  connect(booToRea.y, add3.u1) annotation (Line(points={{22,50},{38,50}},
                         color={0,0,127}));
  connect(TSetCooOn.y, optSta.TSetZonCoo) annotation (Line(points={{-78,30},{-70,
          30},{-70,74},{-42,74}},    color={0,0,127}));
  connect(optSta.optOn, booToRea.u) annotation (Line(points={{-18,66},{-6,66},{
          -6,50},{-2,50}},        color={255,0,255}));
  connect(add4.y, zonAHUOpt.TSetRooHea) annotation (Line(points={{62,74},{72,
          74},{72,66},{78,66}},     color={0,0,127}));
  connect(add3.y, zonAHUOpt.TSetRooCoo) annotation (Line(points={{62,44},{72,
          44},{72,60},{78,60}}, color={0,0,127}));
  connect(TSetRooHea.y[1], zonAHUCon.TSetRooHea) annotation (Line(points={{-18,-50},
          {54,-50},{54,-54},{78,-54}},          color={0,0,127}));
  connect(TSetRooCoo.y[1], zonAHUCon.TSetRooCoo) annotation (Line(points={{-18,-80},
          {54,-80},{54,-60},{78,-60}},      color={0,0,127}));
  connect(zonAHUOpt.TZon, optSta.TZon) annotation (Line(points={{102,60},{104,60},
          {104,30},{-58,30},{-58,66},{-42,66}},     color={0,0,127}));
  connect(optSta.optOn, booToRea1.u) annotation (Line(points={{-18,66},{-6,66},{
          -6,80},{-2,80}}, color={255,0,255}));
  connect(occSch.occupied, zonAHUCon.uOcc) annotation (Line(points={{-79,-12},
          {-6,-12},{-6,-66},{78,-66}},                   color={255,0,255}));
  connect(optSta.optOn, or2.u1) annotation (Line(points={{-18,66},{-6,66},{-6,
          10},{38,10}}, color={255,0,255}));
  connect(occSch.occupied, or2.u2) annotation (Line(points={{-79,-12},{-6,-12},
          {-6,2},{38,2}}, color={255,0,255}));
  connect(or2.y, zonAHUOpt.uOcc)  annotation (Line(points={{62,10},{74,10},{74,
          54},{78,54}}, color={255,0,255}));
  connect(add4.u2, TSetRooHea.y[1]) annotation (Line(points={{38,68},{26,68},{
          26,-50},{-18,-50}}, color={0,0,127}));
  connect(booToRea1.y, add4.u1) annotation (Line(points={{22,80},{38,80}}, color={0,0,127}));

  connect(weaDat.weaBus, zonAHUOpt.weaBus) annotation (Line(
      points={{102,12},{112,12},{112,68},{83.2,68}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, zonAHUCon.weaBus) annotation (Line(
      points={{102,12},{112,12},{112,-52},{83.2,-52}},
      color={255,204,51},
      thickness=0.5));
   annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})),                                        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}}),
                    graphics={
        Rectangle(
          extent={{-108,96},{106,-18}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={226,226,226},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{40,-2},{92,-20}},
          textColor={238,46,47},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System with optimal start"),
        Rectangle(
          extent={{-108,-28},{106,-94}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillColor={226,226,226},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{40,-80},{98,-96}},
          textColor={238,46,47},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System without optimal start")}),
    experiment(
      StartTime=6393600,
      StopTime=7171200,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Air/Systems/SingleZone/VAV/Examples/OptimalStart/ConventionalSpring.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This is an example model on how to use the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a>
that integrates with a conventional controller, a single-zone VAV system
and a single-zone floor building. The building, HVAC system and controller model
can be found in the base class
<a href=\"modelica://Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUConventional\">
Buildings.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUConventional</a>.
</p>
<p>
This example validates the optimal start results for the spring condition. Note
that the optimal start block in this example computes for both heating and cooling conditions.
The first few days are initialization period. The optimal start time is zero
when the zone temperature is within the heating and cooling setpoint deadband.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 29, 2020, by Kun Zhang:<br/>
First implementation. This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2126\">2126</a>.
</li>
</ul>
</html>"));
end ConventionalSpring;
