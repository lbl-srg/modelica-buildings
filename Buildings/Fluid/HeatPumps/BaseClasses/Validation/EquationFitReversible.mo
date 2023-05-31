within Buildings.Fluid.HeatPumps.BaseClasses.Validation;
model EquationFitReversible
  "Validation of the equation fit method implemented in the reversible heat pump model"

   package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.Units.SI.MassFlowRate mSou_flow_nominal=per.hea.mSou_flow
    "Source heat exchanger nominal mass flow rate";
  parameter Modelica.Units.SI.MassFlowRate mLoa_flow_nominal=per.hea.mLoa_flow
    "Load heat exchanger nominal mass flow rate";
   parameter Data.EquationFitReversible.Trane_Axiom_EXW240 per
    "Performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  BaseClasses.EquationFitReversible equFit(
    per=per,
    scaling_factor=1)
    "Performance model for equation fit"
    annotation (Placement(transformation(extent={{46,-20},{66,0}})));
  Modelica.Blocks.Math.RealToInteger reaToInt
    "Real to integer conversion"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Sources.Sine uMod(amplitude=1, f=1/2600)
    "Heat pump operates in heating mode"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Sine Q_flow_set(amplitude=5000, f=1/2600)
    "Set point for heat flow rate"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Controls.OBC.CDL.Continuous.Sources.Constant mLoa_flow(k=1.89)
    "Mass flow rate entering load heat exchanger side"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TLoaEnt(
    amplitude=10,
    freqHz=1/2600,
    offset=25 + 273.15,
    startTime=0) "Load side entering water temperature"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant mSou_flow(k=1.89)
    "Mass flow rate entering source heat exchanger side"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TSouEnt(
    amplitude=5,
    freqHz=1/2600,
    offset=15 + 273.15,
    startTime=0) "Source side entering water temperature"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
equation
  connect(reaToInt.u,uMod. y)
    annotation (Line(points={{-22,-10},{-39,-10}},
                                             color={0,0,127}));
  connect(reaToInt.y, equFit.uMod)
    annotation (Line(points={{1,-10},{45,-10}},
                                            color={255,127,0}));
  connect(Q_flow_set.y, equFit.Q_flow_set)
    annotation (Line(points={{-39,80},{40,80},{40,-1},{45,-1}},
                                                             color={0,0,127}));
  connect(mLoa_flow.y, equFit.mLoa_flow)
    annotation (Line(points={{-38,50},{34,50},{34,-4},{45,-4}},
                          color={0,0,127}));
  connect(TLoaEnt.y, equFit.TLoaEnt)
    annotation (Line(points={{-38,20},{24,20},{24,-7},{45,-7}},
                                                              color={0,0,127}));
  connect(mSou_flow.y, equFit.mSou_flow)
    annotation (Line(points={{-38,-70},{36,-70},{36,-18},{45,-18}},
                                                                color={0,0,127}));
  connect(TSouEnt.y, equFit.TSouEnt)
    annotation (Line(points={{-38,-40},{30,-40},{30,-14},{45,-14}},
                                                                  color={0,0,127}));
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
                 __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/BaseClasses/Validation/EquationFitReversible.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6, StopTime=2600),
Documentation(info="<html>
<p>
This model implements a validation of the block
<a href=\"modelica://Buildings.Fluid.HeatPumps.BaseClasses.EquationFitReversible\">
Buildings.Fluid.HeatPumps.BaseClasses.EquationFitReversible</a>
that applies the equation fit method used for <a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquationFitReversible;
