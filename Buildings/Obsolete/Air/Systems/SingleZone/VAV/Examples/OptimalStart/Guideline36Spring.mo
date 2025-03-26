within Buildings.Obsolete.Air.Systems.SingleZone.VAV.Examples.OptimalStart;
model Guideline36Spring
  "Example model using the block OptimalStart with a Guideline36 controller for a single-zone system in spring"
  extends Modelica.Icons.Example;

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    computeWetBulbTemperature=false,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  Buildings.Controls.OBC.Utilities.OptimalStart optStaHea(
    computeHeating=true,
    computeCooling=false,
    uLow=0.1,
    thrOptOn(displayUnit="s"))
    "Optimal start for heating"
    annotation (Placement(transformation(extent={{-20,62},{0,82}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{8,18})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-60,-34},{-40,-14}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetHeaOn(k=20 + 273.15)
    "Zone heating setpoint during occupied period"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TSetCooOn(k=24 + 273.15)
    "Zone cooling setpoint during occupied time"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.Utilities.OptimalStart optStaCoo(
    computeHeating=false,
    computeCooling=true,
    uLow=0.1,
    thrOptOn(displayUnit="s"))
    "Optimal start for cooling"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=0)
    "No optimal start"
    annotation (Placement(transformation(extent={{-20,-78},{0,-58}})));
  Buildings.Obsolete.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUG36
    zonAHUG36Opt
    "A single zone building with a VAV system and a Guideline36 controller"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));
  Buildings.Obsolete.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUG36
    zonAHUG36Con
    "A single zone building with a VAV system and a Guideline36 controller"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

equation
  connect(TSetHeaOn.y, optStaHea.TSetZonHea) annotation (Line(points={{-38,80},{
          -22,80}},                       color={0,0,127}));
  connect(TSetCooOn.y, optStaCoo.TSetZonCoo) annotation (Line(points={{-38,30},{
          -30,30},{-30,34},{-22,34}},        color={0,0,127}));
  connect(occSch.tNexOcc, optStaCoo.tNexOcc) annotation (Line(points={{-39,-18},
          {-26,-18},{-26,22},{-22,22}},      color={0,0,127}));
  connect(optStaCoo.TZon, optStaHea.TZon) annotation (Line(points={{-22,26},{-32,
          26},{-32,68},{-22,68}},         color={0,0,127}));
  connect(occSch.tNexOcc, zonAHUG36Opt.tNexOcc) annotation (Line(points={{-39,
          -18},{26,-18},{26,47},{38,47}}, color={0,0,127}));
  connect(occSch.occupied, zonAHUG36Opt.uOcc) annotation (Line(points={{-39,-30},
          {32,-30},{32,43},{38,43}}, color={255,0,255}));
  connect(optStaHea.tOpt, zonAHUG36Opt.warUpTim) annotation (Line(points={{2,76},
          {20,76},{20,56},{38,56}}, color={0,0,127}));
  connect(optStaCoo.tOpt, zonAHUG36Opt.cooDowTim) annotation (Line(points={{2,34},
          {20,34},{20,51.8},{38,51.8}}, color={0,0,127}));
  connect(zonAHUG36Opt.TZon, optStaHea.TZon) annotation (Line(points={{62,50},{64,
          50},{64,14},{-32,14},{-32,68},{-22,68}},     color={0,0,127}));
  connect(con.y, zonAHUG36Con.warUpTim) annotation (Line(points={{2,-68},{8,-68},
          {8,-64},{38,-64}}, color={0,0,127}));
  connect(con.y, zonAHUG36Con.cooDowTim) annotation (Line(points={{2,-68},{8,-68},
          {8,-68.2},{38,-68.2}}, color={0,0,127}));
  connect(occSch.tNexOcc, zonAHUG36Con.tNexOcc) annotation (Line(points={{-39,
          -18},{26,-18},{26,-73},{38,-73}}, color={0,0,127}));
  connect(occSch.occupied, zonAHUG36Con.uOcc) annotation (Line(points={{-39,-30},
          {20,-30},{20,-77},{38,-77}}, color={255,0,255}));
  connect(occSch.tNexOcc, optStaHea.tNexOcc) annotation (Line(points={{-39,-18},
          {-26,-18},{-26,64},{-22,64}}, color={0,0,127}));

  connect(weaDat.weaBus, zonAHUG36Opt.weaBus) annotation (Line(
      points={{60,-10},{80,-10},{80,58.2},{43,58.2}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, zonAHUG36Con.weaBus) annotation (Line(
      points={{60,-10},{80,-10},{80,-61.8},{43,-61.8}},
      color={255,204,51},
      thickness=0.5));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false),
                    graphics={
        Rectangle(
          extent={{-70,-50},{74,-94}},
          fillColor={226,226,226},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{0,-76},{54,-102}},
          textColor={238,46,47},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System without optimal start"),
        Rectangle(
          extent={{-70,96},{72,8}},
          fillColor={226,226,226},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{0,104},{48,80}},
          textColor={238,46,47},
          fillColor={229,229,229},
          fillPattern=FillPattern.Solid,
          textString="System with optimal start")}),
    experiment(
      StartTime=6393600,
      StopTime=7171200,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Air/Systems/SingleZone/VAV/Examples/OptimalStart/Guideline36Spring.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
This is an example model on how to use the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.OptimalStart\">
Buildings.Controls.OBC.Utilities.OptimalStart</a>
that integrates with a controller based on Guideline36
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller\">
Buildings.Obsolete.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller</a>,
a single-zone VAV system and a single-zone floor building.
The building, HVAC system and controller model
can be found in the base class
<a href=\"modelica://Buildings.Obsolete.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUG36\">
Buildings.Obsolete.Air.Systems.SingleZone.VAV.Examples.OptimalStart.BaseClasses.ZoneWithAHUG36</a>.
</p>
<p>
This example validates the optimal start results for the spring condition.
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
end Guideline36Spring;
