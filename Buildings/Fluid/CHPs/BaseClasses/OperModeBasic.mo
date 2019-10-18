within Buildings.Fluid.CHPs.BaseClasses;
model OperModeBasic "Energy conversion for a typical CHP operation"
  extends Modelica.Blocks.Icons.Block;

  replaceable parameter Buildings.Fluid.CHPs.Data.Generic per
    "Performance data"
    annotation (Placement(transformation(extent={{-80,160},{-60,180}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput PEle(
    final unit="W") "Electric power"
    annotation (Placement(transformation(extent={{-140,100},{-100,140}}),
      iconTransformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mWat_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Water flow rate"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TWatIn(
    final unit="K",
    final quantity="ThermodynamicTemperature") "Water inlet temperature"
    annotation (Placement(transformation(extent={{-140,-66},{-100,-26}}),
      iconTransformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mFue_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Fuel flow rate"
    annotation (Placement(transformation(extent={{180,100},{220,140}}),
      iconTransformation(extent={{100,50},{120,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mAir_flow(
    final unit="kg/s",
    final quantity="MassFlowRate") "Air flow rate"
    annotation (Placement(transformation(extent={{180,30},{220,70}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QGen(
    final unit="W") "Heat generation within the engine"
    annotation (Placement(transformation(extent={{180,-30},{220,10}}),
      iconTransformation(extent={{100,-70},{120,-50}})));

protected
  Buildings.Fluid.CHPs.BaseClasses.EfficiencyCurve etaE(
    final a=per.coeEtaE)
    "Part load electrical efficiency"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Fluid.CHPs.BaseClasses.EfficiencyCurve etaQ(
    final a=per.coeEtaQ)
    "Part load thermal efficiency"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Division groHea
    "Gross heat input into the system"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Product heaGen
    "Heat generation within the engine"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant const(
    final k=1/per.LHVFue) "Reciprocal of fuel lower heating value "
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Product fueFlo "Fuel flow rate"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Utilities.Math.Polynominal airFlo(
    final a=per.coeMasAir)  "Air flow rate"
    annotation (Placement(transformation(extent={{140,40},{160,60}})));

equation
  connect(groHea.u1, PEle) annotation (Line(points={{18,106},{-70,106},{-70,120},
          {-120,120}}, color={0,0,127}));
  connect(heaGen.y, QGen) annotation (Line(points={{122,-10},{200,-10}},
          color={0,0,127}));
  connect(QGen, QGen) annotation (Line(points={{200,-10},{200,-10}},
          color={0,0,127}));
  connect(groHea.y, fueFlo.u2) annotation (Line(points={{42,100},{60,100},{60,114},
          {78,114}}, color={0,0,127}));
  connect(const.y, fueFlo.u1) annotation (Line(points={{42,140},{60,140},{60,126},
          {78,126}}, color={0,0,127}));
  connect(fueFlo.y, mFue_flow) annotation (Line(points={{102,120},{200,120}},
          color={0,0,127}));
  connect(airFlo.u, fueFlo.y) annotation (Line(points={{138,50},{120,50},{120,120},
          {102,120}}, color={0,0,127}));
  connect(airFlo.y, mAir_flow) annotation (Line(points={{161,50},{200,50}},
          color={0,0,127}));
  connect(etaE.TWatIn, TWatIn) annotation (Line(points={{-42,54},{-60,54},{-60,-46},
          {-120,-46}}, color={0,0,127}));
  connect(etaE.PNet, PEle) annotation (Line(points={{-42,66},{-70,66},{-70,120},
          {-120,120}}, color={0,0,127}));
  connect(etaQ.PNet, PEle) annotation (Line(points={{-42,-34},{-70,-34},{-70,120},
          {-120,120}},color={0,0,127}));
  connect(mWat_flow, etaE.mWat_flow) annotation (Line(points={{-120,60},{-42,60}},
          color={0,0,127}));
  connect(etaQ.mWat_flow, mWat_flow) annotation (Line(points={{-42,-40},{-80,-40},
          {-80,60},{-120,60}}, color={0,0,127}));
  connect(etaQ.TWatIn, TWatIn) annotation (Line(points={{-42,-46},{-120,-46}},
          color={0,0,127}));
  connect(etaE.eta, groHea.u2) annotation (Line(points={{-18,60},{0,60},{0,94},
          {18,94}},color={0,0,127}));
  connect(etaQ.eta, heaGen.u2) annotation (Line(points={{-18,-40},{60,-40},{60,
          -16},{98,-16}},
                     color={0,0,127}));
  connect(groHea.y, heaGen.u1) annotation (Line(points={{42,100},{60,100},{60,-4},
          {98,-4}}, color={0,0,127}));

annotation (
  defaultComponentName="opeModBas",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{180,200}})),
  Documentation(info="<html>
<p>
The model defines energy conversion for a typical CHP operation that includes the normal mode and warm-up mode based on the time delay (CHPs with internal combustion engines). 
Energy conversion from fuel to the electric power and heat is modeled using system's part-load electrical and thermal efficiencies, based on the empirical data from the manufacturer. 
The curves are described by a 2nd order polynomial, a function of the electric power, water flow rate and water inlet temperature. 
The air flow rate is also modeled using a 2nd order polynomial, a function of the fuel flow rate. 
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
