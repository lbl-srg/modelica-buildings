within Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Validation;
model WetterAfjei1997
  "Validate the values described by Wetter, Afjei and Glass"
  extends Modelica.Icons.Example;
  Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.FunctionalIcingFactor
    iceFacWatSou(cpEva=4184, redeclare function icingFactor =
        Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.Functions.wetterAfjei1997)
    "Water source icing factor"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Modelica.Blocks.Interfaces.RealOutput iceFacWat
    "Icing factor from 0 to 1 to estimate influence of icing"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus
    sigBus1
    "Bus-connector used in a heat pump"
    annotation (Placement(transformation(extent={{-48,-20},{-8,20}})));
  Modelica.Blocks.Sources.Constant const(
    final k=0,
    y(unit="kg/s"))
    "Values are irrelevant for the function"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Sources.Ramp ramp(
    height=35,
    duration=35,
    offset=253.15,
    y(unit="K", displayUnit="degC"))
                   "Outdoor air temperature ramp"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  FunctionalIcingFactor iceFacAirSou(cpEva=1004, redeclare function icingFactor
      = Functions.wetterAfjei1997) "Air source icing factor"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Modelica.Blocks.Interfaces.RealOutput iceFacAir
    "Icing factor from 0 to 1 to estimate influence of icing"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Sources.Constant const1(
    final k=0,
    y(unit="K"))
    "Values are irrelevant for the function"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation
  connect(iceFacWatSou.iceFac, iceFacWat)
    annotation (Line(points={{41,20},{110,20}}, color={0,0,127}));
  connect(iceFacWatSou.sigBus, sigBus1) annotation (Line(
      points={{19.9,20},{-2,20},{-2,0},{-28,0}},
      color={255,204,51},
      thickness=0.5));
  connect(const.y, sigBus1.mEvaMea_flow) annotation (Line(points={{-59,30},{-28,
          30},{-28,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(ramp.y, sigBus1.TEvaInMea) annotation (Line(points={{-59,-30},{-28,-30},
          {-28,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(iceFacAirSou.iceFac, iceFacAir)
    annotation (Line(points={{41,-20},{110,-20}}, color={0,0,127}));
  connect(iceFacAirSou.sigBus, sigBus1) annotation (Line(
      points={{19.9,-20},{-2,-20},{-2,0},{-28,0}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(const1.y, sigBus1.TEvaOutMea) annotation (Line(points={{-59,70},{-28,
          70},{-28,0}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{2,2},{2,5}},
      horizontalAlignment=TextAlignment.Left));
  annotation (   __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/RefrigerantCycle/Frosting/Validation/WetterAfjei1997.mos"
        "Simulate and plot"),
  experiment(
      StartTime=0,
      StopTime=35,
      Interval=1,
      Tolerance=1e-08),
    Documentation(info="<html>
 Test model to validate if the equation fit the data in Figure 3 in the paper by Wetter, Afjei and Glass.
 Also, the option to disable frosting surpression if air is not used is tested.
<h4>References</h4>
<p>
Thomas Afjei, Michael Wetter and Andrew Glass.<br/>
TRNSYS type: Dual-stage compressor heat pump including frost and cycle losses. Model description and implementation in TRNSYS.</br>
TRNSYS user meeting, November 1997, Stuttgart, Germany.<br/>
<a href=\"https://simulationresearch.lbl.gov/wetter/download/type204_hp.pdf\">
https://simulationresearch.lbl.gov/wetter/download/type204_hp.pdf</a>
</p>
</html>", revisions="<html>
<ul>
<li>
March 31, 2026, by Michael Wetter:<br/>
Corrected unit propagation error that causes Dymola 2026x to not show certain units.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/2100\">#2100</a>.
</li>
<li>
April 17, 2025, by Fabian Wuellhorst:<br/>
First implementation, see
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1975\">IBPSA #1975</a>
</li>
</ul>
</html>"));
end WetterAfjei1997;
