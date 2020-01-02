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
      final anyVsdCen=false, final nSta=3)
                      "Stage and operative part load ratios"
      annotation (Placement(transformation(extent={{-180,110},{-160,130}})));

    Buildings.Controls.OBC.CDL.Continuous.Max max
      annotation (Placement(transformation(extent={{-262,270},{-240,290}})));

    PartLoadRatios                                                                               PLRs1(final
        anyVsdCen=false, final nSta=3)
                      "Stage and operative part load ratios"
      annotation (Placement(transformation(extent={{180,110},{200,130}})));
    CDL.Continuous.Max                        max1
      annotation (Placement(transformation(extent={{98,270},{120,290}})));
protected
    Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta(final k=1)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{-340,100},{-320,120}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq3(
      amplitude=6e5,
      freqHz=1/1800,
      offset=900000,
      startTime=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-340,300},{-320,320}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp(final k=2)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{-340,60},{-320,80}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown(final k=0)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{-340,20},{-320,40}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowLim(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-340,260},{-320,280}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capDes[3](final k={10e5,
          15e5,25e5}) "Stage design capacities"
      annotation (Placement(transformation(extent={{-300,220},{-280,240}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capMin[3](final k={2e5,
          3e5,5e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{-300,180},{-280,200}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staTyp[3](final k={
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal,
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal})
      "Stage types"
      annotation (Placement(transformation(extent={{-340,140},{-320,160}})));

    CDL.Integers.Sources.Constant                        curSta1(final k=2)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{20,100},{40,120}})));
    CDL.Continuous.Sources.Sine                        capReq1(
      amplitude=6e5,
      freqHz=1/1800,
    offset=1400000,
      startTime=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{20,300},{40,320}})));
    CDL.Integers.Sources.Constant                        staUp1(final k=3)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{20,60},{40,80}})));
    CDL.Integers.Sources.Constant                        staDown1(final k=1)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{20,20},{40,40}})));
    CDL.Continuous.Sources.Constant                        lowLim1(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{20,260},{40,280}})));
    CDL.Continuous.Sources.Constant                        capDes1[3](final k={10e5,
          15e5,25e5}) "Stage design capacities"
      annotation (Placement(transformation(extent={{60,220},{80,240}})));
    CDL.Continuous.Sources.Constant                        capMin1[3](final k={2e5,
          3e5,5e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{60,180},{80,200}})));
    CDL.Integers.Sources.Constant                        staTyp1[3](final k={
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal,
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal})
      "Stage types"
      annotation (Placement(transformation(extent={{20,140},{40,160}})));
  equation

    connect(curSta.y, PLRs0.u) annotation (Line(points={{-318,110},{-181,110}},
                             color={255,127,0}));
    connect(staUp.y, PLRs0.uUp) annotation (Line(points={{-318,70},{-240,70},{-240,
            108},{-181,108}},color={255,127,0}));
    connect(staDown.y, PLRs0.uDown) annotation (Line(points={{-318,30},{-230,30},{
            -230,106},{-181,106}},                    color={255,127,0}));
    connect(max.y, PLRs0.uCapReq) annotation (Line(points={{-237.8,280},{-210,280},
            {-210,133},{-181,133}},
                                 color={0,0,127}));
    connect(capReq3.y, max.u1) annotation (Line(points={{-318,310},{-280,310},{-280,
            286},{-264.2,286}}, color={0,0,127}));
    connect(lowLim.y, max.u2) annotation (Line(points={{-318,270},{-280,270},{-280,
            274},{-264.2,274}}, color={0,0,127}));
    connect(capDes[1].y, PLRs0.uCapDes) annotation (Line(points={{-278,230},{-212,
            230},{-212,131},{-181,131}}, color={0,0,127}));
    connect(capDes[2].y, PLRs0.uUpCapDes) annotation (Line(points={{-278,230},{-212,
            230},{-212,129},{-181,129}}, color={0,0,127}));
    connect(capMin[1].y, PLRs0.uDowCapDes) annotation (Line(points={{-278,190},{-214,
            190},{-214,127},{-181,127}}, color={0,0,127}));
    connect(capMin[1].y, PLRs0.uCapMin) annotation (Line(points={{-278,190},{-214,
            190},{-214,125},{-181,125}}, color={0,0,127}));
    connect(capMin[2].y, PLRs0.uUpCapMin) annotation (Line(points={{-278,190},{-216,
            190},{-216,123},{-181,123}}, color={0,0,127}));
    connect(staTyp.y, PLRs0.uTyp) annotation (Line(points={{-318,150},{-230,150},{
            -230,113},{-181,113}}, color={255,127,0}));
    connect(curSta1.y, PLRs1.u)
      annotation (Line(points={{42,110},{179,110}}, color={255,127,0}));
    connect(staUp1.y, PLRs1.uUp) annotation (Line(points={{42,70},{120,70},{120,108},
            {179,108}}, color={255,127,0}));
    connect(staDown1.y, PLRs1.uDown) annotation (Line(points={{42,30},{130,30},{130,
            106},{179,106}}, color={255,127,0}));
    connect(max1.y, PLRs1.uCapReq) annotation (Line(points={{122.2,280},{150,280},
            {150,133},{179,133}}, color={0,0,127}));
    connect(capReq1.y, max1.u1) annotation (Line(points={{42,310},{80,310},{80,286},
            {95.8,286}}, color={0,0,127}));
    connect(lowLim1.y, max1.u2) annotation (Line(points={{42,270},{80,270},{80,274},
            {95.8,274}}, color={0,0,127}));
    connect(capDes1[2].y, PLRs1.uCapDes) annotation (Line(points={{82,230},{148,230},
            {148,131},{179,131}}, color={0,0,127}));
    connect(capDes1[3].y, PLRs1.uUpCapDes) annotation (Line(points={{82,230},{148,
            230},{148,129},{179,129}}, color={0,0,127}));
    connect(capMin1[1].y, PLRs1.uDowCapDes) annotation (Line(points={{82,190},{146,
            190},{146,127},{179,127}}, color={0,0,127}));
    connect(capMin1[2].y, PLRs1.uCapMin) annotation (Line(points={{82,190},{146,190},
            {146,125},{179,125}}, color={0,0,127}));
    connect(capMin1[3].y, PLRs1.uUpCapMin) annotation (Line(points={{82,190},{144,
            190},{144,123},{179,123}}, color={0,0,127}));
    connect(staTyp1.y, PLRs1.uTyp) annotation (Line(points={{42,150},{130,150},{130,
            113},{179,113}}, color={255,127,0}));
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
