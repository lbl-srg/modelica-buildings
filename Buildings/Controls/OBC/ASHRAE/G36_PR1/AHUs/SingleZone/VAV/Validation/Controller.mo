within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Validation;
model Controller "Validation controller model"
  import Buildings;
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller
    controller(
    yHeaMax=0.7,
    yMin=0.3,
    AFlo=50,
    controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    have_occSen=true,
    TSupSetMax=297.15,
    TSupSetMin=289.15,
    use_TMix=false)   "Single zone VAV sequence from Guideline 36"
    annotation (Placement(transformation(extent={{20,12},{60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
    offset=20 + 273.15,
    freqHz=1/86400,
    amplitude=-5)  "Outdoor air temperature"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
    each duration=86400,
    each height=14,
    each offset=273.15 + 14)
                         "Measured zone temperature"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{6,19})
    "Occupancy schedule"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booWin(period=86400/2,
      width=0.5)
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc(height=2,
      duration=86400) "Occupant number in zone"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TCut(final k=273.15
         + 16) "Fixed dry bulb temperature high limit cutoff for economizer"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Logical.TriggeredTrapezoid TSup(
    final rising(displayUnit="h") = 43200,
    final falling(displayUnit="h") = 43200,
    final amplitude=5,
    final offset=273.15 + 20) "AHU measured supply air temperature"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(final startTime=10,
      final period(displayUnit="h") = 86400)
                       "Boolean pulse signal"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));
equation
  connect(TOut.y, controller.TOut) annotation (Line(points={{-99,110},{0,110},
          {0,60},{18,60}}, color={0,0,127}));
  connect(TZon.y, controller.TZon) annotation (Line(points={{-99,50},{-30,50},
          {-30,52},{18,52}}, color={0,0,127}));
  connect(occSch.occupied, controller.uOcc) annotation (Line(points={{-99,74},
          {-74,74},{-74,48},{18,48}}, color={255,0,255}));
  connect(occSch.tNexOcc, controller.tNexOcc) annotation (Line(points={{-99,
          86},{-30,86},{-30,56},{18,56}}, color={0,0,127}));
  connect(booWin.y, controller.uWin) annotation (Line(points={{-99,-110},{10,
          -110},{10,28},{18,28}}, color={255,0,255}));
  connect(controller.nOcc, numOfOcc.y) annotation (Line(points={{18,32},{6,32},
          {6,-70},{-99,-70}}, color={0,0,127}));
  connect(TCut.y, controller.TCut) annotation (Line(points={{-99,10},{-40,10},
          {-40,44},{18,44}}, color={0,0,127}));
  connect(booPul.y, TSup.u)
    annotation (Line(points={{-99,-30},{-82,-30}}, color={255,0,255}));
  connect(TSup.y, controller.TSup) annotation (Line(points={{-59,-30},{-20,
          -30},{-20,40},{18,40}}, color={0,0,127}));
  annotation (experiment(StopTime=86400, Interval=300, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/SingleZone/VAV/Validation/Controller.mos"
    "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}}),                                  graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-120,-120},{120,120}}),
                                           Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}})),
Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end Controller;
