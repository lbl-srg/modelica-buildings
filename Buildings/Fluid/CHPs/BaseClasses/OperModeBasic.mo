within Buildings.Fluid.CHPs.BaseClasses;
model OperModeBasic "Energy conversion for a typical CHP operation"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEle(
    final unit="W") "Electric power"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Water flow rate"
    annotation (Placement(transformation(extent={{-180,-30},{-140,10}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWatIn(
    final unit="K",
    final quantity="ThermodynamicTemperature") "Water inlet temperature"
    annotation (Placement(transformation(extent={{-180,-76},{-140,-36}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mFue_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Fuel flow rate"
    annotation (Placement(transformation(extent={{140,40},{180,80}}),
      iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mAir_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Air flow rate"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QGen(
    final unit="W") "Heat generation within the engine"
    annotation (Placement(transformation(extent={{140,-40},{180,0}}),
      iconTransformation(extent={{102,-80},{142,-40}})));

protected
  Buildings.Fluid.CHPs.BaseClasses.EfficiencyCurve etaE(
    final a=per.coeEtaE)
    "Part load electrical efficiency"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Fluid.CHPs.BaseClasses.EfficiencyCurve etaQ(
    final a=per.coeEtaQ)
    "Part load thermal efficiency"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Division groHea
    "Gross heat input into the system"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Product heaGen
    "Heat generation within the engine"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(
    final k=1/per.LHVFue) "Reciprocal of fuel lower heating value "
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Product fueFlo "Fuel flow rate"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Utilities.Math.Polynominal airFlo(
    final a=per.coeMasAir)  "Air flow rate"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

equation
  connect(groHea.u1, PEle) annotation (Line(points={{-22,46},{-110,46},{-110,60},
          {-160,60}},  color={0,0,127}));
  connect(heaGen.y, QGen) annotation (Line(points={{82,-20},{160,-20}},
          color={0,0,127}));
  connect(QGen, QGen) annotation (Line(points={{160,-20},{160,-20}},
          color={0,0,127}));
  connect(groHea.y, fueFlo.u2) annotation (Line(points={{2,40},{20,40},{20,54},{
          38,54}}, color={0,0,127}));
  connect(const.y, fueFlo.u1) annotation (Line(points={{2,80},{20,80},{20,66},{38,
          66}}, color={0,0,127}));
  connect(fueFlo.y, mFue_flow) annotation (Line(points={{62,60},{160,60}},
          color={0,0,127}));
  connect(airFlo.u, fueFlo.y) annotation (Line(points={{98,20},{80,20},{80,60},{
          62,60}}, color={0,0,127}));
  connect(airFlo.y, mAir_flow) annotation (Line(points={{121,20},{160,20}},
          color={0,0,127}));
  connect(etaE.TWatIn, TWatIn) annotation (Line(points={{-82,-16},{-100,-16},{-100,
          -56},{-160,-56}}, color={0,0,127}));
  connect(etaE.PNet, PEle) annotation (Line(points={{-82,-4},{-110,-4},{-110,60},
          {-160,60}},  color={0,0,127}));
  connect(etaQ.PNet, PEle) annotation (Line(points={{-82,-44},{-110,-44},{-110,
          60},{-160,60}},
                      color={0,0,127}));
  connect(mWat_flow, etaE.mWat_flow) annotation (Line(points={{-160,-10},{-82,-10}},
          color={0,0,127}));
  connect(etaQ.mWat_flow, mWat_flow) annotation (Line(points={{-82,-50},{-120,-50},
          {-120,-10},{-160,-10}}, color={0,0,127}));
  connect(etaQ.TWatIn, TWatIn) annotation (Line(points={{-82,-56},{-160,-56}},
          color={0,0,127}));
  connect(etaE.eta, groHea.u2) annotation (Line(points={{-58,-10},{-40,-10},{-40,
          34},{-22,34}}, color={0,0,127}));
  connect(etaQ.eta, heaGen.u2) annotation (Line(points={{-58,-50},{20,-50},{20,-26},
          {58,-26}}, color={0,0,127}));
  connect(groHea.y, heaGen.u1) annotation (Line(points={{2,40},{20,40},{20,-14},
          {58,-14}},color={0,0,127}));

annotation (
  defaultComponentName="opeModBas",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,140}})),
  Documentation(info="<html>
<p>
The model defines energy conversion for a typical CHP operation that includes the 
normal mode and warm-up mode based on the time delay (CHPs with internal combustion engines). 
Energy conversion from fuel to the electric power and heat is modeled using 
system's part-load electrical and thermal efficiencies, based on the empirical 
data from the manufacturer. 
The curves are described by a 2nd order polynomial, a function of the electric 
power, water flow rate and water inlet temperature. 
The air flow rate is also modeled using a 2nd order polynomial, a function of 
the fuel flow rate. 
</p>
</html>", revisions="<html>
<ul>
<li>
June 01, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end OperModeBasic;
