within Buildings.Fluid.HeatPumps.BaseClasses.Validation;
model DOE2Reversible
  "Validation of the DOE2 method implemented in the reversible heat pump model"

   package Medium = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.MassFlowRate mSou_flow_nominal=per.m2_flow_nominal
    "Source heat exchanger nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate mLoa_flow_nominal=per.m1_flow_nominal
    "Load heat exchanger nominal mass flow rate";

  Buildings.Fluid.HeatPumps.BaseClasses.DOE2Reversible doe2(
    per=per,
    scaling_factor=1)
    "Performance model for DOE2 method"
    annotation (Placement(transformation(extent={{74,4},{94,24}})));
  Modelica.Blocks.Math.RealToInteger reaToInt
    "Real to integer conversion"
    annotation (Placement(transformation(extent={{-50,-20},{-30,0}})));
  Modelica.Blocks.Sources.Sine  uMod(amplitude=1, freqHz=1/2600)
                 "Heat pump operates in heating mode"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.Constant
                               Q_flow_set(k=-40000)
    "Set point for heat flow rate"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TLoaLvg(
    amplitude=5,
    freqHz=1/2600,
    offset=30 + 273.15,
    startTime=0) "Load side entering water temperature"
    annotation (Placement(transformation(extent={{-82,10},{-62,30}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TLoaEnt(
    amplitude=5,
    freqHz=1/2600,
    offset=25 + 273.15,
    startTime=0) "Load side entering water temperature"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  parameter Data.DOE2Reversible.EnergyPlus per
    annotation (Placement(transformation(extent={{60,72},{80,92}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TSouLvg(
    amplitude=2,
    freqHz=1/2600,
    offset=6 + 273.15,
    startTime=0) "Source side leaving water temperature"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TSouEnt(
    amplitude=2,
    freqHz=1/2600,
    offset=12 + 273.15,
    startTime=0) "Source side entering water temperature"
    annotation (Placement(transformation(extent={{-80,-92},{-60,-72}})));
  Controls.OBC.CDL.Integers.GreaterThreshold isHea(final threshold=0)
    "Output true if in heating mode"
    annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
protected
  Controls.OBC.CDL.Logical.Switch TEntPer(y(final unit="K", displayUnit="degC"))
    "Entering temperature used to compute the performance"
    annotation (Placement(transformation(extent={{40,-68},{60,-48}})));
  Controls.OBC.CDL.Logical.Switch TLvgPer(y(final unit="K", displayUnit="degC"))
    "Leaving temperature used to compute the performance"
    annotation (Placement(transformation(extent={{36,20},{56,40}})));
equation
  connect(reaToInt.u,uMod. y)
    annotation (Line(points={{-52,-10},{-59,-10}},
                                             color={0,0,127}));
  connect(reaToInt.y, doe2.uMod)
    annotation (Line(points={{-29,-10},{20,-10},{20,18},{73,18}},
                       color={255,127,0}));
  connect(reaToInt.y, isHea.u) annotation (Line(points={{-29,-10},{-20,-10},{
          -20,-30},{-12,-30}}, color={255,127,0}));
  connect(isHea.y, TEntPer.u2) annotation (Line(points={{12,-30},{26,-30},{26,
          -58},{38,-58}}, color={255,0,255}));
  connect(isHea.y, TLvgPer.u2) annotation (Line(points={{12,-30},{26,-30},{26,
          30},{34,30}}, color={255,0,255}));
  connect(doe2.TConEnt, TEntPer.y) annotation (Line(points={{73,10},{64,10},{64,
          -58},{62,-58}}, color={0,0,127}));
  connect(doe2.TEvaLvg, TLvgPer.y)
    annotation (Line(points={{73,6},{68,6},{68,30},{58,30}}, color={0,0,127}));
  connect(TSouLvg.y, TLvgPer.u1)
    annotation (Line(points={{-58,50},{-10,50},{-10,38},{34,38}},
                                                color={0,0,127}));
  connect(TLoaLvg.y, TLvgPer.u3) annotation (Line(points={{-60,20},{-10,20},{
          -10,22},{34,22}}, color={0,0,127}));
  connect(TSouEnt.y, TEntPer.u3) annotation (Line(points={{-58,-82},{32,-82},{
          32,-66},{38,-66}}, color={0,0,127}));
  connect(TEntPer.u1, TLoaEnt.y)
    annotation (Line(points={{38,-50},{-58,-50}}, color={0,0,127}));
  connect(Q_flow_set.y, doe2.QSet_flow) annotation (Line(points={{-59,80},{0,80},
          {0,48},{70,48},{70,22},{73,22}}, color={0,0,127}));
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
    experiment(StopTime=2600, Tolerance=1e-06),
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
