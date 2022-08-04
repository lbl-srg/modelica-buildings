within Buildings.Fluid.CHPs.BaseClasses;
model EnergyConversionNormal
  "Energy conversion for typical CHP operation either in normal mode or warm-up mode based on time delay"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEle(
    final unit="W") "Electric power"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Water mass flow rate"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWatIn(
    final unit="K",
    displayUnit="degC") "Water inlet temperature"
    annotation (Placement(transformation(extent={{-180,-96},{-140,-56}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mFue_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Fuel mass flow rate"
    annotation (Placement(transformation(extent={{140,20},{180,60}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mAir_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Air mass flow rate"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QGen_flow(final unit="W")
    "Heat generation rate within the engine"
    annotation (Placement(transformation(extent={{140,-60},{180,-20}}),
      iconTransformation(extent={{102,-80},{142,-40}})));

protected
  Buildings.Fluid.CHPs.BaseClasses.EfficiencyCurve etaE(
    final a=per.coeEtaE)
    "Part load electrical efficiency"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.CHPs.BaseClasses.EfficiencyCurve etaQ(
    final a=per.coeEtaQ)
    "Part load thermal efficiency"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Divide groHea
    "Gross heat input into the system"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply heaGen
    "Heat generation within the engine"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Utilities.Math.Polynomial masFloAir(final a=per.coeMasAir)
    "Air mass flow rate computation"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter masFloFue(
    final k=1/per.LHVFue) "Fuel mass flow rate computation"
    annotation (Placement(transformation(extent={{40,30},{60,50}})));
equation
  connect(groHea.u1, PEle) annotation (Line(points={{-22,26},{-110,26},{-110,40},
          {-160,40}},  color={0,0,127}));
  connect(heaGen.y, QGen_flow)
    annotation (Line(points={{82,-40},{160,-40}}, color={0,0,127}));
  connect(masFloAir.y, mAir_flow)
    annotation (Line(points={{121,0},{160,0}}, color={0,0,127}));
  connect(etaE.TWatIn, TWatIn) annotation (Line(points={{-82,-6},{-100,-6},{-100,
          -76},{-160,-76}}, color={0,0,127}));
  connect(etaE.PNet, PEle) annotation (Line(points={{-82,6},{-110,6},{-110,40},{
          -160,40}}, color={0,0,127}));
  connect(etaQ.PNet, PEle) annotation (Line(points={{-82,-64},{-110,-64},{-110,40},
          {-160,40}}, color={0,0,127}));
  connect(mWat_flow, etaE.mWat_flow) annotation (Line(points={{-160,0},{-82,0}},
          color={0,0,127}));
  connect(etaQ.mWat_flow, mWat_flow) annotation (Line(points={{-82,-70},{-120,-70},
          {-120,0},{-160,0}}, color={0,0,127}));
  connect(etaQ.TWatIn, TWatIn) annotation (Line(points={{-82,-76},{-160,-76}},
          color={0,0,127}));
  connect(etaE.eta, groHea.u2) annotation (Line(points={{-58,0},{-40,0},{-40,14},
          {-22,14}}, color={0,0,127}));
  connect(etaQ.eta, heaGen.u2) annotation (Line(points={{-58,-70},{20,-70},{20,-46},
          {58,-46}}, color={0,0,127}));
  connect(groHea.y, heaGen.u1) annotation (Line(points={{2,20},{20,20},{20,-34},
          {58,-34}},color={0,0,127}));
  connect(masFloFue.y, mFue_flow)
    annotation (Line(points={{62,40},{160,40}}, color={0,0,127}));
  connect(groHea.y, masFloFue.u) annotation (Line(points={{2,20},{20,20},{20,40},
          {38,40}}, color={0,0,127}));
  connect(masFloFue.y, masFloAir.u)
    annotation (Line(points={{62,40},{80,40},{80,0},{98,0}}, color={0,0,127}));
annotation (
  defaultComponentName="opeModBas",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
  Documentation(info="<html>
<p>
The model defines energy conversion for a typical CHP operation that includes the
normal mode and warm-up mode based on the time delay (CHPs with internal combustion engines).
Energy conversion from fuel to the electric power and heat is modeled using
system's part-load electrical and thermal efficiencies, based on the empirical
data from the manufacturer.
The curves are described by a fifth order polynomial, a function of the electric
power, water flow rate and water inlet temperature.
The air flow rate is modeled using a second order polynomial, a function of
the fuel flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Removed connector to itself.
</li>
<li>
October 31, 2019, by Jianjun Hu:<br/>
Refactored implementation.
</li>
<li>
June 1, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnergyConversionNormal;
