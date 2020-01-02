within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
package Validation "Collection of validation models"
  model PartLoadRatios_u_uTyp
    "Validates the operating and stage part load ratios calculation for chiller stage and stage type inputs"

    parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
    "Chilled water supply set temperature";

    parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
    "Average measured chilled water return temperature";

    parameter Integer nSta = 3
      "Total number of stages";

    parameter Real aveVChiWat_flow(
      final quantity="VolumeFlowRate",
      final unit="m3/s") = 0.05
      "Average measured chilled water flow rate";

    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs0(
      final anyVsdCen=false,
      final nSta = 2) "Stage and operative part load ratios"
      annotation (Placement(transformation(extent={{-180,120},{-160,140}})));

    Buildings.Controls.OBC.CDL.Continuous.Max max
      annotation (Placement(transformation(extent={{-262,280},{-240,300}})));

protected
    Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta(final k=1)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{-340,120},{-320,140}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq3(
    amplitude=6e5,
      freqHz=1/1800,
    offset=1400000,
    startTime=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-340,310},{-320,330}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp(final k=2)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{-340,80},{-320,100}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown(final k=0)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{-340,40},{-320,60}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowLim(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-340,270},{-320,290}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capDes[2](final k={
        10e5,15e5,25e5}) "Stage design capacities"
      annotation (Placement(transformation(extent={{-300,240},{-280,260}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capMin[2](final k={
        2e5,3e5,5e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{-300,200},{-280,220}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staTyp[3](final k={
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal})
      "Stage types"
      annotation (Placement(transformation(extent={{-340,160},{-320,180}})));

  equation

    connect(curSta.y, PLRs0.u) annotation (Line(points={{-318,130},{-240,130},{
          -240,120},{-181,120}},
                             color={255,127,0}));
    connect(staUp.y, PLRs0.uUp) annotation (Line(points={{-318,90},{-240,90},{
          -240,118},{-181,118}},
                             color={255,127,0}));
    connect(staDown.y, PLRs0.uDown) annotation (Line(points={{-318,50},{-230,50},
          {-230,116},{-181,116}},                     color={255,127,0}));
    connect(PLRs0.uTyp,staTyp. y) annotation (Line(points={{-181,123},{-230,123},
          {-230,170},{-318,170}},
                              color={255,127,0}));
    connect(max.y, PLRs0.uCapReq) annotation (Line(points={{-237.8,290},{-210,
          290},{-210,143},{-181,143}},
                                 color={0,0,127}));
    connect(capReq3.y, max.u1) annotation (Line(points={{-318,320},{-280,320},{
          -280,296},{-264.2,296}},
                                color={0,0,127}));
    connect(lowLim.y, max.u2) annotation (Line(points={{-318,280},{-280,280},{
          -280,284},{-264.2,284}},
                                color={0,0,127}));
  connect(capDes[1].y, PLRs0.uCapDes) annotation (Line(points={{-278,250},{-212,
          250},{-212,141},{-181,141}}, color={0,0,127}));
  connect(capDes[2].y, PLRs0.uUpCapDes) annotation (Line(points={{-278,250},{
          -212,250},{-212,139},{-181,139}}, color={0,0,127}));
  connect(capMin[1].y, PLRs0.uDowCapDes) annotation (Line(points={{-278,210},{
          -214,210},{-214,137},{-181,137}}, color={0,0,127}));
  connect(capMin[1].y, PLRs0.uCapMin) annotation (Line(points={{-278,210},{-214,
          210},{-214,135},{-181,135}}, color={0,0,127}));
  connect(capMin[2].y, PLRs0.uUpCapMin) annotation (Line(points={{-278,210},{
          -216,210},{-216,133},{-181,133}}, color={0,0,127}));
  annotation (
   experiment(StopTime=1200.0, Tolerance=1e-06),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/PartLoadRatios_u_uTyp.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement</a>.
</p>
</html>",   revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(graphics={
          Ellipse(lineColor = {75,138,73},
                  fillColor={255,255,255},
                  fillPattern = FillPattern.Solid,
                  extent = {{-100,-100},{100,100}}),
          Polygon(lineColor = {0,0,255},
                  fillColor = {75,138,73},
                  pattern = LinePattern.None,
                  fillPattern = FillPattern.Solid,
                  points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
          coordinateSystem(preserveAspectRatio=false, extent={{-360,-340},{360,340}})));
  end PartLoadRatios_u_uTyp;

annotation (preferredView="info", Documentation(info="<html>
<p>
This package contains validation models for the classes in
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences</a>.
</p>
<p>
Note that most validation models contain simple input data
which may not be realistic, but for which the correct
output can be obtained through an analytic solution.
The examples plot various outputs, which have been verified against these
solutions. These model outputs are stored as reference data and
used for continuous validation whenever models in the library change.
</p>
</html>"),
  Icon(graphics={
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
          radius=25.0)}));
end Validation;
