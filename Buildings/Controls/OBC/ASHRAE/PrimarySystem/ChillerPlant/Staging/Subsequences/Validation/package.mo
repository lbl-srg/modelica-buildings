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
      annotation (Placement(transformation(extent={{-60,120},{-40,140}})));

    Buildings.Controls.OBC.CDL.Logical.Sources.Constant higSta(final k=false)
      "Indicates whether the current is the highest available stage"
      annotation (Placement(transformation(extent={{-160,20},{-140,40}})));

    Buildings.Controls.OBC.CDL.Logical.Sources.Constant lowSta(final k=false)
      "Indicates whether the current is the lowest available stage"
      annotation (Placement(transformation(extent={{-160,-10},{-140,10}})));

    CDL.Continuous.Max max
      annotation (Placement(transformation(extent={{-102,200},{-80,220}})));

protected
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap3(
      final nSta=2)
      "Returns design and minimal stage capacities required for calculating operating and stage part load ratios"
      annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta(final k=1)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{-200,120},{-180,140}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq3(
      amplitude=18e5,
      freqHz=1/1800,
      offset=200000,
      startTime=200)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-160,230},{-140,250}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp(final k=2)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{-160,100},{-140,120}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown(final k=0)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowLim(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-160,190},{-140,210}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desCap[2](
      final k={8e5,2e6})
      "Chiller design capacities"
      annotation (Placement(transformation(extent={{-200,80},{-180,100}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minCap[2](
      final k={1.6e4,4e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{-200,40},{-180,60}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiTyp[2](final k={
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal})
      "Stage types"
      annotation (Placement(transformation(extent={{-160,140},{-140,160}})));

  equation

    connect(curSta.y, PLRs0.u) annotation (Line(points={{-178,130},{-120,130},{-120,
            120},{-61,120}}, color={255,127,0}));
    connect(curSta.y, staCap3.u) annotation (Line(points={{-178,130},{-130,130},{-130,
            66},{-122,66}}, color={255,127,0}));
    connect(staUp.y, PLRs0.uUp) annotation (Line(points={{-138,110},{-80,110},{-80,
            118},{-61,118}}, color={255,127,0}));
    connect(staDown.y, PLRs0.uDown) annotation (Line(points={{-138,70},{-132,70},{
            -132,108},{-78,108},{-78,116},{-61,116}}, color={255,127,0}));
    connect(staUp.y, staCap3.uUp) annotation (Line(points={{-138,110},{-134,110},{
            -134,63},{-122,63}}, color={255,127,0}));
    connect(staDown.y, staCap3.uDown) annotation (Line(points={{-138,70},{-136,70},
            {-136,60},{-122,60}}, color={255,127,0}));
    connect(higSta.y, staCap3.uHig) annotation (Line(points={{-138,30},{-132,30},{
            -132,57},{-122,57}}, color={255,0,255}));
    connect(lowSta.y, staCap3.uLow) annotation (Line(points={{-138,0},{-130,0},{-130,
            54},{-122,54}}, color={255,0,255}));
    connect(desCap.y, staCap3.uDesCap) annotation (Line(points={{-178,90},{-128,90},
            {-128,69},{-122,69}}, color={0,0,127}));
    connect(staCap3.uMinCap, minCap.y) annotation (Line(points={{-122,51},{-160,51},
            {-160,50},{-178,50}}, color={0,0,127}));
    connect(PLRs0.uTyp,chiTyp. y) annotation (Line(points={{-61,123},{-116,123},{-116,
            150},{-138,150}}, color={255,127,0}));
    connect(staCap3.yDes, PLRs0.uCapDes) annotation (Line(points={{-98,68},{-90,68},
            {-90,141},{-61,141}}, color={0,0,127}));
    connect(staCap3.yUpDes, PLRs0.uUpCapDes) annotation (Line(points={{-98,64},{-88,
            64},{-88,139},{-61,139}}, color={0,0,127}));
    connect(staCap3.yDowDes, PLRs0.uDowCapDes) annotation (Line(points={{-98,60},{
            -86,60},{-86,137},{-61,137}}, color={0,0,127}));
    connect(staCap3.yUpMin, PLRs0.uUpCapMin) annotation (Line(points={{-98,52},{-84,
            52},{-84,133},{-61,133}}, color={0,0,127}));
    connect(PLRs0.uCapMin, staCap3.yMin) annotation (Line(points={{-61,135},{-82,135},
            {-82,56},{-98,56}}, color={0,0,127}));
    connect(max.y, PLRs0.uCapReq) annotation (Line(points={{-77.8,210},{-70,210},{
            -70,143},{-61,143}}, color={0,0,127}));
    connect(capReq3.y, max.u1) annotation (Line(points={{-138,240},{-120,240},{-120,
            216},{-104.2,216}}, color={0,0,127}));
    connect(lowLim.y, max.u2) annotation (Line(points={{-138,200},{-120,200},{-120,
            204},{-104.2,204}}, color={0,0,127}));
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
