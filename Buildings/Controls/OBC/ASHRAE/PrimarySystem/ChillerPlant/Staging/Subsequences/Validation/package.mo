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
      annotation (Placement(transformation(extent={{-180,140},{-160,160}})));

    Buildings.Controls.OBC.CDL.Logical.Sources.Constant higSta(final k=false)
      "Indicates whether the current is the highest available stage"
      annotation (Placement(transformation(extent={{-280,40},{-260,60}})));

    Buildings.Controls.OBC.CDL.Logical.Sources.Constant lowSta(final k=true)
      "Indicates whether the current is the lowest available stage"
      annotation (Placement(transformation(extent={{-280,10},{-260,30}})));

    CDL.Continuous.Max max
      annotation (Placement(transformation(extent={{-242,270},{-220,290}})));

    PartLoadRatios                                                                               PLRs1(final
      anyVsdCen=false, final nSta=2)
                      "Stage and operative part load ratios"
      annotation (Placement(transformation(extent={{20,140},{40,160}})));
    CDL.Logical.Sources.Constant                        higSta1(final k=false)
      "Indicates whether the current is the highest available stage"
      annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
    CDL.Logical.Sources.Constant                        lowSta1(final k=true)
      "Indicates whether the current is the lowest available stage"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
protected
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap3(
      final nSta=2)
      "Returns design and minimal stage capacities required for calculating operating and stage part load ratios"
      annotation (Placement(transformation(extent={{-240,70},{-220,90}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant curSta(final k=1)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{-320,190},{-300,210}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Sine capReq3(
      amplitude=18e5,
      freqHz=1/1800,
      offset=200000,
      startTime=200)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-300,300},{-280,320}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staUp(final k=2)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{-280,170},{-260,190}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant staDown(final k=0)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{-320,150},{-300,170}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant lowLim(final k=0)
      "Capacity requirement"
      annotation (Placement(transformation(extent={{-300,260},{-280,280}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant desCap[2](
      final k={8e5,2e6})
      "Chiller design capacities"
      annotation (Placement(transformation(extent={{-320,-20},{-300,0}})));

    Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minCap[2](
      final k={1.6e4,4e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{-320,-62},{-300,-42}})));

    Buildings.Controls.OBC.CDL.Integers.Sources.Constant chiTyp[2](final k={
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
          Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal})
      "Stage types"
      annotation (Placement(transformation(extent={{-300,220},{-280,240}})));

protected
    Capacities                                                                               staCap1(final
      nSta=2)
      "Returns design and minimal stage capacities required for calculating operating and stage part load ratios"
      annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
    CDL.Integers.Sources.Constant                        curSta1(final k=0)
      "Current chiller stage"
      annotation (Placement(transformation(extent={{-120,190},{-100,210}})));
    CDL.Integers.Sources.Constant                        staUp1(final k=1)
      "Next available chiller stage up"
      annotation (Placement(transformation(extent={{-80,170},{-60,190}})));
    CDL.Integers.Sources.Constant                        staDown1(final k=0)
      "Next available chiller stage down"
      annotation (Placement(transformation(extent={{-120,150},{-100,170}})));
    CDL.Continuous.Sources.Constant                        desCap1
                                                                 [2](final k={
        8e5,2e6})
      "Chiller design capacities"
      annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));
    CDL.Continuous.Sources.Constant                        minCap1
                                                                 [2](final k={
        1.6e4,4e5})
      "Stage unload capacities"
      annotation (Placement(transformation(extent={{-120,-62},{-100,-42}})));
  equation

    connect(curSta.y, PLRs0.u) annotation (Line(points={{-298,200},{-240,200},{
          -240,140},{-181,140}},
                             color={255,127,0}));
    connect(curSta.y, staCap3.u) annotation (Line(points={{-298,200},{-250,200},
          {-250,86},{-242,86}},
                            color={255,127,0}));
    connect(staUp.y, PLRs0.uUp) annotation (Line(points={{-258,180},{-200,180},
          {-200,138},{-181,138}},
                             color={255,127,0}));
    connect(staDown.y, PLRs0.uDown) annotation (Line(points={{-298,160},{-252,
          160},{-252,128},{-198,128},{-198,136},{-181,136}},
                                                      color={255,127,0}));
    connect(staUp.y, staCap3.uUp) annotation (Line(points={{-258,180},{-254,180},
          {-254,83},{-242,83}},  color={255,127,0}));
    connect(staDown.y, staCap3.uDown) annotation (Line(points={{-298,160},{-258,
          160},{-258,80},{-242,80}},
                                  color={255,127,0}));
    connect(higSta.y, staCap3.uHig) annotation (Line(points={{-258,50},{-252,50},
          {-252,77},{-242,77}},  color={255,0,255}));
    connect(lowSta.y, staCap3.uLow) annotation (Line(points={{-258,20},{-250,20},
          {-250,74},{-242,74}},
                            color={255,0,255}));
    connect(desCap.y, staCap3.uDesCap) annotation (Line(points={{-298,-10},{
          -290,-10},{-290,89},{-242,89}},
                                  color={0,0,127}));
    connect(staCap3.uMinCap, minCap.y) annotation (Line(points={{-242,71},{-290,
          71},{-290,-52},{-298,-52}},
                                  color={0,0,127}));
    connect(PLRs0.uTyp,chiTyp. y) annotation (Line(points={{-181,143},{-236,143},
          {-236,230},{-278,230}},
                              color={255,127,0}));
    connect(staCap3.yDes, PLRs0.uCapDes) annotation (Line(points={{-218,88},{
          -210,88},{-210,161},{-181,161}},
                                  color={0,0,127}));
    connect(staCap3.yUpDes, PLRs0.uUpCapDes) annotation (Line(points={{-218,84},
          {-208,84},{-208,159},{-181,159}},
                                      color={0,0,127}));
    connect(staCap3.yDowDes, PLRs0.uDowCapDes) annotation (Line(points={{-218,80},
          {-206,80},{-206,157},{-181,157}},
                                          color={0,0,127}));
    connect(staCap3.yUpMin, PLRs0.uUpCapMin) annotation (Line(points={{-218,72},
          {-204,72},{-204,153},{-181,153}},
                                      color={0,0,127}));
    connect(PLRs0.uCapMin, staCap3.yMin) annotation (Line(points={{-181,155},{
          -202,155},{-202,76},{-218,76}},
                                color={0,0,127}));
    connect(max.y, PLRs0.uCapReq) annotation (Line(points={{-217.8,280},{-210,
          280},{-210,163},{-181,163}},
                                 color={0,0,127}));
    connect(capReq3.y, max.u1) annotation (Line(points={{-278,310},{-260,310},{
          -260,286},{-244.2,286}},
                                color={0,0,127}));
    connect(lowLim.y, max.u2) annotation (Line(points={{-278,270},{-260,270},{
          -260,274},{-244.2,274}},
                                color={0,0,127}));
  connect(curSta1.y, PLRs1.u) annotation (Line(points={{-98,200},{-40,200},{-40,
          140},{19,140}}, color={255,127,0}));
  connect(curSta1.y, staCap1.u) annotation (Line(points={{-98,200},{-50,200},{
          -50,86},{-42,86}}, color={255,127,0}));
  connect(staUp1.y, PLRs1.uUp) annotation (Line(points={{-58,180},{-54,180},{
          -54,138},{19,138}}, color={255,127,0}));
  connect(staDown1.y, PLRs1.uDown) annotation (Line(points={{-98,160},{-52,160},
          {-52,128},{2,128},{2,136},{19,136}}, color={255,127,0}));
  connect(staUp1.y, staCap1.uUp) annotation (Line(points={{-58,180},{-54,180},{
          -54,83},{-42,83}}, color={255,127,0}));
  connect(staDown1.y, staCap1.uDown) annotation (Line(points={{-98,160},{-58,
          160},{-58,80},{-42,80}}, color={255,127,0}));
  connect(higSta1.y, staCap1.uHig) annotation (Line(points={{-58,50},{-52,50},{
          -52,77},{-42,77}}, color={255,0,255}));
  connect(lowSta1.y, staCap1.uLow) annotation (Line(points={{-58,20},{-50,20},{
          -50,74},{-42,74}}, color={255,0,255}));
  connect(desCap1.y, staCap1.uDesCap) annotation (Line(points={{-98,-10},{-90,
          -10},{-90,89},{-42,89}}, color={0,0,127}));
  connect(staCap1.uMinCap, minCap1.y) annotation (Line(points={{-42,71},{-90,71},
          {-90,-52},{-98,-52}}, color={0,0,127}));
    connect(staCap1.yDes,PLRs1. uCapDes) annotation (Line(points={{-18,88},{-10,
          88},{-10,161},{19,161}},color={0,0,127}));
    connect(staCap1.yUpDes,PLRs1. uUpCapDes) annotation (Line(points={{-18,84},
          {-8,84},{-8,159},{19,159}}, color={0,0,127}));
    connect(staCap1.yDowDes,PLRs1. uDowCapDes) annotation (Line(points={{-18,80},
          {-6,80},{-6,157},{19,157}},     color={0,0,127}));
    connect(staCap1.yUpMin,PLRs1. uUpCapMin) annotation (Line(points={{-18,72},
          {-4,72},{-4,153},{19,153}}, color={0,0,127}));
    connect(PLRs1.uCapMin,staCap1. yMin) annotation (Line(points={{19,155},{-2,
          155},{-2,76},{-18,76}},
                                color={0,0,127}));
  connect(max.y, PLRs1.uCapReq) annotation (Line(points={{-217.8,280},{10,280},
          {10,163},{19,163}}, color={0,0,127}));
  connect(PLRs1.uTyp, chiTyp.y) annotation (Line(points={{19,143},{-30,143},{
          -30,230},{-278,230}}, color={255,127,0}));
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
