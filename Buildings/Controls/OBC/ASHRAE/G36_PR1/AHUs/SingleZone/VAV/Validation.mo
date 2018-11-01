within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV;
package Validation "Collection of validation models"

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
      TSupSetMax=303.15,
      TSupSetMin=289.15,
      use_TMix=false)   "Single zone VAV sequence from Guideline 36"
      annotation (Placement(transformation(extent={{20,12},{60,60}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOut(
      offset=18 + 273.15,
      freqHz=1/86400,
      amplitude=-5)  "Outdoor air temperature"
      annotation (Placement(transformation(extent={{-120,100},{-100,120}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TZon(
      each duration=86400,
      each height=15,
      each offset=273.15 + 15)
                           "Measured zone temperature"
      annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
    Buildings.Controls.SetPoints.OccupancySchedule occSch(occupancy=3600*{6,19})
      "Occupancy schedule"
      annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSup(
      each height=4,
      each offset=273.15 + 14,
      each duration=86400)     "AHU supply air temperature"
      annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
    Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booWin(period=86400/2,
        width=0.5)
      annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp numOfOcc(height=2,
        duration=86400) "Occupant number in zone"
      annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  equation
    connect(TOut.y, controller.TOut) annotation (Line(points={{-99,110},{0,110},
            {0,60},{18,60}}, color={0,0,127}));
    connect(TZon.y, controller.TZon) annotation (Line(points={{-99,50},{-30,50},
            {-30,52},{18,52}}, color={0,0,127}));
    connect(occSch.occupied, controller.uOcc) annotation (Line(points={{-99,74},
            {-74,74},{-74,48},{18,48}}, color={255,0,255}));
    connect(occSch.tNexOcc, controller.tNexOcc) annotation (Line(points={{-99,
            86},{-30,86},{-30,56},{18,56}}, color={0,0,127}));
    connect(TSup.y, controller.TSup) annotation (Line(points={{-99,-10},{0,-10},
            {0,40},{18,40}}, color={0,0,127}));
    connect(booWin.y, controller.uWin) annotation (Line(points={{-99,-110},{10,
            -110},{10,28},{18,28}}, color={255,0,255}));
    connect(controller.nOcc, numOfOcc.y) annotation (Line(points={{18,32},{6,32},
            {6,-70},{-99,-70}}, color={0,0,127}));
    connect(TZon.y, controller.TRet) annotation (Line(points={{-99,50},{-30,50},
            {-30,44},{18,44}}, color={0,0,127}));
    annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
              -120},{120,120}}),                                  graphics={
          Ellipse(lineColor = {75,138,73},
                  fillColor={255,255,255},
                  fillPattern = FillPattern.Solid,
                  extent={{-120,-120},{120,120}}),
          Polygon(lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
              120}})),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.Controller</a>.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 24, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
      experiment(StopTime=86400, Interval=300));
  end Controller;

  model ModeAndSetPoints
    "Validation models of reseting zone setpoint temperature"
    import Buildings;

    Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ModeAndSetPoints
      setPoi(
      cooAdj=true,
      heaAdj=true)
      "Output resetted zone setpoint remperature"
      annotation (Placement(transformation(extent={{20,70},{40,90}})));
    Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ModeAndSetPoints
      setPoi1(
      have_occSen=true,
      have_winSen=true)
      "Output resetted zone setpoint remperature"
      annotation (Placement(transformation(extent={{20,30},{40,50}})));

    Buildings.Controls.SetPoints.OccupancySchedule occSch "Occupancy schedule"
      annotation (Placement(transformation(extent={{-90,72},{-70,92}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Sine heaSetAdj(each freqHz=1/
          28800, each amplitude=0.5) "Heating setpoint adjustment"
      annotation (Placement(transformation(extent={{-46,0},{-26,20}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Sine cooSetAdj(each freqHz=1/
          28800) "Cooling setpoint adjustment"
      annotation (Placement(transformation(extent={{-46,40},{-26,60}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TZon1(
      amplitude=5,
      offset=18 + 273.15,
      freqHz=1/86400) "Zone 1 temperature"
      annotation (Placement(transformation(extent={{-88,40},{-68,60}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TZon2(
      offset=18 + 273.15,
      freqHz=1/86400,
      amplitude=7.5) "Zone 2 temperature"
      annotation (Placement(transformation(extent={{-88,0},{-68,20}})));
    Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta1(k=false)
      "Window status"
      annotation (Placement(transformation(extent={{-88,-80},{-68,-60}})));
    Buildings.Controls.OBC.CDL.Logical.Sources.Constant winSta2(k=true)
      "Window status"
      annotation (Placement(transformation(extent={{-46,-80},{-26,-60}})));
    Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSen1(k=false)
      "Occupancy sensor"
      annotation (Placement(transformation(extent={{-88,-40},{-68,-20}})));
    Buildings.Controls.OBC.CDL.Logical.Sources.Constant occSen2(k=true)
      "Occupancy sensor"
      annotation (Placement(transformation(extent={{-46,-40},{-26,-20}})));

    Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ModeAndSetPoints
      setPoi3(
      have_occSen=true,
      have_winSen=true)
      "Output resetted zone setpoint remperature"
      annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
    Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ModeAndSetPoints
      setPoi2(
      cooAdj=true,
      heaAdj=true)
      "Output resetted zone setpoint remperature"
      annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  equation
    connect(cooSetAdj.y, setPoi.setAdj)
      annotation (Line(points={{-25,50},{-20,50},{-20,82},{19,82}},
        color={0,0,127}));
    connect(heaSetAdj.y, setPoi.heaSetAdj)
      annotation (Line(points={{-25,10},{-16,10},{-16,79},{19,79}},
        color={0,0,127}));

    connect(occSen2.y, setPoi3.uOccSen) annotation (Line(points={{-25,-30},{-2,
            -30},{-2,-57},{19,-57}}, color={255,0,255}));
    connect(winSta2.y, setPoi3.uWinSta) annotation (Line(points={{-25,-70},{-2,
            -70},{-2,-59},{19,-59}}, color={255,0,255}));
    connect(setPoi3.TZon, TZon2.y) annotation (Line(points={{19,-45},{6,-45},{6,
            -6},{-20,-6},{-20,-8},{-60,-8},{-60,10},{-67,10}}, color={0,0,127}));
    connect(setPoi2.TZon, TZon2.y) annotation (Line(points={{19,-5},{6,-5},{6,
            -6},{-20,-6},{-20,-8},{-60,-8},{-60,10},{-67,10}}, color={0,0,127}));
    connect(cooSetAdj.y, setPoi2.setAdj) annotation (Line(points={{-25,50},{-20,
            50},{-20,0},{10,0},{10,-8},{19,-8}}, color={0,0,127}));
    connect(heaSetAdj.y, setPoi2.heaSetAdj) annotation (Line(points={{-25,10},{
            12,10},{12,-11},{19,-11}}, color={0,0,127}));
    connect(TZon1.y, setPoi.TZon) annotation (Line(points={{-67,50},{-60,50},{
            -60,85},{19,85}}, color={0,0,127}));
    connect(setPoi1.TZon, setPoi.TZon) annotation (Line(points={{19,45},{-12,45},
            {-12,32},{-60,32},{-60,85},{19,85}}, color={0,0,127}));
    connect(occSch.tNexOcc, setPoi.tNexOcc)
      annotation (Line(points={{-69,88},{19,88}}, color={0,0,127}));
    connect(occSch.tNexOcc, setPoi1.tNexOcc) annotation (Line(points={{-69,88},
            {4,88},{4,48},{19,48}}, color={0,0,127}));
    connect(setPoi2.tNexOcc, setPoi1.tNexOcc) annotation (Line(points={{19,-2},
            {4,-2},{4,48},{19,48}}, color={0,0,127}));
    connect(setPoi3.tNexOcc, setPoi1.tNexOcc) annotation (Line(points={{19,-42},
            {4,-42},{4,48},{19,48}}, color={0,0,127}));
    connect(occSch.occupied, setPoi.uOcc) annotation (Line(points={{-69,76},{
            -26,76},{-26,76.025},{19,76.025}}, color={255,0,255}));
    connect(occSch.occupied, setPoi1.uOcc) annotation (Line(points={{-69,76},{
            -6,76},{-6,36.025},{19,36.025}}, color={255,0,255}));
    connect(occSch.occupied, setPoi2.uOcc) annotation (Line(points={{-69,76},{
            -6,76},{-6,-13.975},{19,-13.975}}, color={255,0,255}));
    connect(occSch.occupied, setPoi3.uOcc) annotation (Line(points={{-69,76},{
            -6,76},{-6,-53.975},{19,-53.975}}, color={255,0,255}));
    connect(occSen1.y, setPoi1.uOccSen) annotation (Line(points={{-67,-30},{-58,
            -30},{-58,-14},{-10,-14},{-10,33},{19,33}}, color={255,0,255}));
    connect(winSta1.y, setPoi1.uWinSta) annotation (Line(points={{-67,-70},{-60,
            -70},{-60,-48},{0,-48},{0,31},{19,31}}, color={255,0,255}));
  annotation (experiment(StopTime=86400.0, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/TerminalUnits/Validation/ModeAndSetPoints.mos"
      "Simulate and plot"),
      Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints</a>.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 30, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
   Diagram(
          coordinateSystem(preserveAspectRatio=false), graphics={Text(
            extent={{50,86},{126,76}},
            lineColor={85,0,255},
            horizontalAlignment=TextAlignment.Left,
            textString="No window status sensor
No occupancy sensor
Zone 1"),                Text(
            extent={{48,44},{102,36}},
            lineColor={85,0,255},
            horizontalAlignment=TextAlignment.Left,
            textString="No local setpoint adjustment
Zone 1"),                Text(
            extent={{46,-46},{100,-54}},
            lineColor={85,0,255},
            horizontalAlignment=TextAlignment.Left,
            textString="No local setpoint adjustment
Zone 2"),                                                        Text(
            extent={{48,-4},{124,-14}},
            lineColor={85,0,255},
            horizontalAlignment=TextAlignment.Left,
            textString="No window status sensor
No occupancy sensor
Zone 2")}),
      Icon(graphics={
          Ellipse(lineColor = {75,138,73},
                  fillColor={255,255,255},
                  fillPattern = FillPattern.Solid,
                  extent = {{-100,-100},{100,100}}),
          Polygon(lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
                     Ellipse(
            lineColor={75,138,73},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            extent={{-100,-100},{100,100}}), Polygon(
            lineColor={0,0,255},
            fillColor={75,138,73},
            pattern=LinePattern.None,
            fillPattern=FillPattern.Solid,
            points={{-36,58},{64,-2},{-36,-62},{-36,58}})}));
  end ModeAndSetPoints;

  model ZoneState "Validation models of determining zone state"
    import Buildings;
    Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.VAV.ZoneState zonSta
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse uCoo(
      period=2,
      offset=0,
      startTime=1,
      amplitude=1) "Cooling control signal"
      annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
    Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse uHea(
      period=2,
      offset=0,
      amplitude=1,
      startTime=2) "Heating control signal"
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  equation
    connect(uHea.y, zonSta.uHea) annotation (Line(points={{-79,30},{-50,30},{
            -50,4},{-2,4}}, color={0,0,127}));
    connect(uCoo.y, zonSta.uCoo) annotation (Line(points={{-79,-30},{-50,-30},{
            -50,-4},{-2,-4}}, color={0,0,127}));
    annotation (
      Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                     Ellipse(
            lineColor={75,138,73},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid,
            extent={{-100,-100},{100,100}}), Polygon(
            lineColor={0,0,255},
            fillColor={75,138,73},
            pattern=LinePattern.None,
            fillPattern=FillPattern.Solid,
            points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
      Diagram(coordinateSystem(preserveAspectRatio=false)),
      experiment(
        StopTime=3,
        Tolerance=1e-06,
        __Dymola_Algorithm="Cvode"));
  end ZoneState;
  annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0),
        Polygon(
          origin={8.0,14.0},
          lineColor={78,138,73},
          fillColor={78,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-58.0,46.0},{42.0,-14.0},{-58.0,-74.0},{-58.0,46.0}}),
        Rectangle(
          lineColor={128,128,128},
          extent={{-100.0,-100.0},{100.0,100.0}},
          radius=25.0)}),
Documentation(info="<html>
<p>
This package contains validation models for the classes in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone</a>.
</p>
<p>
Note that most validation models contain simple input data
which may not be realistic, but for which the correct
output can be obtained through an analytic solution.
The examples plot various outputs, which have been verified against these
solutions. These model outputs are stored as reference data and
used for continuous validation whenever models in the library change.
</p>
</html>"));
end Validation;
