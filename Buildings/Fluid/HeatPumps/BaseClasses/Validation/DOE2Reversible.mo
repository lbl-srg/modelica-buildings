within Buildings.Fluid.HeatPumps.BaseClasses.Validation;
model DOE2Reversible
  "Validation of the DOE2 method implemented in the reversible heat pump model"

   package Medium = Buildings.Media.Water "Medium model";

   parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=per.coo.mSou_flow
   "Source heat exchanger nominal mass flow rate";
   parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal=per.coo.mLoa_flow
   "Load heat exchanger nominal mass flow rate";

  Buildings.Fluid.HeatPumps.BaseClasses.DOE2Reversible doe2(
    per=per,
    scaling_factor=1)
    "Performance model for DOE2 method"
    annotation (Placement(transformation(extent={{40,6},{60,26}})));
  Modelica.Blocks.Math.RealToInteger reaToInt
    "Real to integer conversion"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Sources.Sine  uMod(amplitude=1, freqHz=1/2600)
                 "Heat pump operates in heating mode"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Constant
                               Q_flow_set(k=-40000)
    "Set point for heat flow rate"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TLoaLvg(
    amplitude=5,
    freqHz=1/2600,
    offset=30 + 273.15,
    startTime=0) "Load side entering water temperature"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TLoaEnt(
    amplitude=5,
    freqHz=1/2600,
    offset=25 + 273.15,
    startTime=0) "Load side entering water temperature"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  parameter Data.DOE2Reversible.EnergyPlus per
    annotation (Placement(transformation(extent={{52,74},{72,94}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TSouLvg(
    amplitude=2,
    freqHz=1/2600,
    offset=6 + 273.15,
    startTime=0) "Source side leaving water temperature"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TSouEnt(
    amplitude=2,
    freqHz=1/2600,
    offset=12 + 273.15,
    startTime=0) "Source side entering water temperature"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(reaToInt.u,uMod. y)
    annotation (Line(points={{-22,-10},{-39,-10}},
                                             color={0,0,127}));
  connect(reaToInt.y, doe2.uMod)
    annotation (Line(points={{1,-10},{20,-10},{20,16},{39,16}},
                       color={255,127,0}));
  connect(Q_flow_set.y, doe2.Q_flow_set)
    annotation (Line(points={{-39,80},{34,80},{34,25},{39,25}},
                            color={0,0,127}));
  connect(TLoaLvg.y, doe2.TLoaLvg)
    annotation (Line(points={{-38,50},{22,50},{22,20.8},{39,20.8}},
                        color={0,0,127}));
  connect(TLoaEnt.y, doe2.TLoaEnt) annotation (Line(points={{-38,-80},{30,-80},
          {30,8},{39,8}},     color={0,0,127}));
  connect(TSouLvg.y, doe2.TSouLvg) annotation (Line(points={{-38,20},{22,20},{
          22,18},{39,18}},    color={0,0,127}));
  connect(TSouEnt.y, doe2.TSouEnt) annotation (Line(points={{-38,-50},{26,-50},
          {26,12},{39,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -100},{100,100}}),
               graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-102},{100,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
        Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),
                 __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/BaseClasses/Validation/DOE2Reversible.mos"
        "Simulate and plot"),
    experiment(StopTime=5000, Tolerance=1e-06),
Documentation(info="<html>
<p>
This model implements a validation of the block
<a href=\"Buildings.Fluid.HeatPumps.BaseClasses.DOE2Reversible\">
Buildings.Fluid.HeatPumps.BaseClasses.DOE2Reversible</a>
that applies the equation fit method used for <a href=\"Buildings.Fluid.HeatPumps.DOE2Reversible\">
Buildings.Fluid.HeatPumps.DOE2Reversible</a> model.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end DOE2Reversible;
