within Buildings.Fluid.HeatPumps.Validation;
model EquationFitReversibleMethod
  "Validation of the equation fit method implemented in the reversible heat pump model"

   package Medium = Buildings.Media.Water "Medium model";

   parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=per.hea.mSou_flow
   "Source heat exchanger nominal mass flow rate";
   parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal=per.hea.mLoa_flow
   "Load heat exchanger nominal mass flow rate";
   parameter Data.EquationFitReversible.Trane_Axiom_EXW240 per
    "Performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  BaseClasses.EquationFitReversible equFit(
    per=per,
    scaling_factor=1)
    annotation (Placement(transformation(extent={{46,-10},{66,10}})));
  Modelica.Blocks.Math.RealToInteger reaToInt
    "Real to integer conversion"
    annotation (Placement(transformation(extent={{-4,-10},{16,10}})));
  Modelica.Blocks.Sources.Sine  uMod(amplitude=1, freqHz=1/2600)
                 "Heat pump operates in heating mode"
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));

  Modelica.Blocks.Sources.Sine sine(amplitude=5000, freqHz=1/2600)
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Controls.OBC.CDL.Continuous.Sources.Constant mLoa_flow(k=1.89)
    "Mass flow rate entering load heat exchanger side"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TLoaEnt(
    amplitude=10,
    freqHz=1/2600,
    offset=25 + 273.15,
    startTime=0) "Load side entering water temperature"
    annotation (Placement(transformation(extent={{-62,20},{-42,40}})));
  Controls.OBC.CDL.Continuous.Sources.Constant mSou_flow(k=1.89)
    "Mass flow rate entering source heat exchanger side"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TSouEnt(
    amplitude=5,
    freqHz=1/2600,
    offset=15 + 273.15,
    startTime=0) "Source side entering water temperature"
    annotation (Placement(transformation(extent={{-62,-42},{-42,-22}})));
equation
  connect(reaToInt.u,uMod. y)
    annotation (Line(points={{-6,0},{-61,0}},      color={0,0,127}));
  connect(reaToInt.y, equFit.uMod)
    annotation (Line(points={{17,0},{45,0}},    color={255,127,0}));
  connect(sine.y, equFit.Q_flow_set)
    annotation (Line(points={{21,80},{40,80},{40,9},{45,9}}, color={0,0,127}));
  connect(mLoa_flow.y, equFit.mLoa_flow) annotation (Line(points={{2,50},{34,50},
          {34,6},{45,6}}, color={0,0,127}));
  connect(TLoaEnt.y, equFit.TLoaEnt) annotation (Line(points={{-40,30},{24,30},
          {24,3},{45,3}}, color={0,0,127}));
  connect(mSou_flow.y, equFit.mSou_flow) annotation (Line(points={{2,-50},{36,
          -50},{36,-8},{45,-8}}, color={0,0,127}));
  connect(TSouEnt.y, equFit.TSouEnt) annotation (Line(points={{-40,-32},{30,-32},
          {30,-4},{45,-4}}, color={0,0,127}));
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
                 __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Validation/EquationFitReversibleMethod.mos"
        "Simulate and plot"),
    experiment(
      Tolerance=1e-6, StopTime=86400),
Documentation(info="<html>
<p>
This model implements a validation of the block
<a href=\"Buildings.Fluid.HeatPumps.BaseClasses.EquationFitReversible\">
Buildings.Fluid.HeatPumps.BaseClasses.EquationFitReversible</a>
that applies the equation fit method used for <a href=\"Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a> model.
</p>
</html>", revisions="<html>
<ul>
<li>
September 20, 2019, by Hagar Elarga:<br/>
First implementation.
</li>
</ul>
</html>"));
end EquationFitReversibleMethod;
