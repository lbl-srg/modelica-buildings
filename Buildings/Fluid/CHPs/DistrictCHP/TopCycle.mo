within Buildings.Fluid.CHPs.DistrictCHP;
model TopCycle "Topping cycle subsystem model"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Fluid.CHPs.DistrictCHP.Data.Generic per
    "Records of gas turbine performance data"
     annotation (choicesAllMatching= true, Placement(transformation(extent={{40,-120},
            {60,-100}})));

  // Inputs
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y
    "Part load ratio"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    displayUnit="degC",
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Ambient temperature"
    annotation (Placement(transformation(extent={{-180,-90},{-140,-50}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  // Outputs
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEle(
    final quantity= "Power",
    final unit = "W")
    "Gas turbine electricity generation"
    annotation (Placement(transformation(extent={{140,80},{180,120}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mFue_flow(
    final unit="kg/s")
    "Fuel mass flow rate"
    annotation (Placement(transformation(extent={{140,20},{180,60}}),
        iconTransformation(extent={{100,10},{140,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TExh(
    displayUnit="degC",
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Exhaust temperature"
    annotation (Placement(transformation(extent={{140,-50},{180,-10}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mExh_flow(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "Exhaust mass flow rate"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
        iconTransformation(extent={{100,-100},{140,-60}})));

  // Look-up tables
  Modelica.Blocks.Tables.CombiTable2Ds eleCap_CorFac(
    final table=per.capPowCor_GTG,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Look-up table that represents a set of efficiency curves varying with both the outdoor air temperature and the part load ratio"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Modelica.Blocks.Tables.CombiTable2Ds gasTurEff_CorFac(
    final table=per.effCor_GTG,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Look-up table that represents a set of efficiency curves varying with both the outdoor air temperature and the part load ratio"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Modelica.Blocks.Tables.CombiTable2Ds exhT_CorFac(
    final table=per.exhTempCor_GT,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Modelica.Blocks.Tables.CombiTable2Ds exhMas_CorFac(
    final table=per.exhMasCor_GT,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));

  // Others
protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant fulCap(
    final k=1)
    "Full power generation capacity"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pow
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Reals.Divide groHea
    "Gross heat input into the system"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter eleCap(
    final k=per.P_nominal) "Fuel mass flow rate computation"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter nomHea(
    final k=1/per.LHVFue)    "Low heating value"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gasTurEff(
    final k=per.eta_nominal) "Gas turbine efficiency computation"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter exhTemp(
    final k=per.TExh_nominal) "Exhaust temperature computation"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter exhMas(
    final k=per.mExh_nominal) "Exhaust mass flow rate computation"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter loaPer(
    final k=1)
    "load ratio"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=-273.15)
    "Convert from degK to degC"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

equation
  connect(exhT_CorFac.y, exhTemp.u)
    annotation (Line(points={{-39,-30},{-22,-30}},color={0,0,127}));
  connect(exhMas_CorFac.y, exhMas.u)
    annotation (Line(points={{-39,-80},{-22,-80}},color={0,0,127}));
  connect(loaPer.u, y)
    annotation (Line(points={{-122,40},{-160,40}},color={0,0,127}));
  connect(gasTurEff_CorFac.u1, loaPer.y) annotation (Line(points={{-62,26},{-80,
          26},{-80,40},{-98,40}}, color={0,0,127}));
  connect(exhT_CorFac.u1, loaPer.y) annotation (Line(points={{-62,-24},{-80,-24},
          {-80,40},{-98,40}},color={0,0,127}));
  connect(exhMas_CorFac.u1, loaPer.y) annotation (Line(points={{-62,-74},{-80,-74},
          {-80,40},{-98,40}}, color={0,0,127}));
  connect(gasTurEff.u, gasTurEff_CorFac.y)
    annotation (Line(points={{-22,20},{-39,20}},color={0,0,127}));
  connect(eleCap_CorFac.y, eleCap.u)
    annotation (Line(points={{-39,70},{-22,70}},color={0,0,127}));
  connect(gasTurEff.y, groHea.u2) annotation (Line(points={{2,20},{40,20},{40,
          34},{58,34}}, color={0,0,127}));
  connect(exhTemp.y, TExh)
    annotation (Line(points={{2,-30},{160,-30}}, color={0,0,127}));
  connect(exhMas.y, mExh_flow)
    annotation (Line(points={{2,-80},{160,-80}}, color={0,0,127}));
  connect(nomHea.y, mFue_flow)
    annotation (Line(points={{122,40},{160,40}}, color={0,0,127}));
  connect(nomHea.u, groHea.y) annotation (Line(points={{98,40},{82,40}},
         color={0,0,127}));
  connect(pow.y, PEle)
    annotation (Line(points={{42,100},{160,100}}, color={0,0,127}));
  connect(eleCap.y, pow.u2) annotation (Line(points={{2,70},{10,70},{10,94},{18,
          94}}, color={0,0,127}));
  connect(pow.y, groHea.u1) annotation (Line(points={{42,100},{50,100},{50,46},
          {58,46}},color={0,0,127}));
  connect(eleCap_CorFac.u1, fulCap.y) annotation (Line(points={{-62,76},{-80,76},
          {-80,80},{-98,80}}, color={0,0,127}));
  connect(TSet, addPar.u)
    annotation (Line(points={{-160,-70},{-122,-70}},color={0,0,127}));
  connect(addPar.y, eleCap_CorFac.u2) annotation (Line(points={{-98,-70},{-90,-70},
          {-90,64},{-62,64}}, color={0,0,127}));
  connect(addPar.y, gasTurEff_CorFac.u2) annotation (Line(points={{-98,-70},{-90,
          -70},{-90,14},{-62,14}}, color={0,0,127}));
  connect(addPar.y, exhT_CorFac.u2) annotation (Line(points={{-98,-70},{-90,-70},
          {-90,-36},{-62,-36}}, color={0,0,127}));
  connect(addPar.y, exhMas_CorFac.u2) annotation (Line(points={{-98,-70},{-90,-70},
          {-90,-86},{-62,-86}}, color={0,0,127}));
  connect(y, pow.u1) annotation (Line(points={{-160,40},{-130,40},{-130,106},{18,
          106}}, color={0,0,127}));
annotation (
  defaultComponentName="topCyc",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
  Documentation(info="<html>
<p>
In the topping cycle, a gas turbine is commonly used as the prime mover.
The energy balance equation of the topping cycle process can be expressed as follows
</p>
<p>
The fuel combustion energy flow is considered equal to the generated electricity
and the heat flow of the exhaust gas.
</p>
<p align=\"center\">
<i>
Q&#775;<sub>fuel</sub> = P<sub>GTG</sub> + Q&#775;<sub>exhaust</sub>,
</i>
</p>
<p>
where <i>Q&#775;<sub>fuel</sub></i> is the fuel combustion energy in the gas turbine,
<i>P<sub>GTG</sub></i> denotes the electricity production from the gas turbine
generator, and <i>Q&#775;<sub>exhaust</sub></i> represents the heat flow of the exhaust
gas. Note that the fuel combustion energy is calculated as the product of the
mass flow rate of the fuel, <i>m&#775;<sub>fuel</sub></i>, and its lower heating
value (LHV):
</p>
<p align=\"center\">
<i>
Q&#775;<sub>fuel</sub> = m&#775;<sub>fuel</sub> LHV<sub>fuel</sub>.
</i>
</p>
<p>
A fraction of the fuel combustion energy of the gas turbine fuel,
<i>&eta;<sub>GTG</sub></i>, is transformed into electricity, denoted as
<i>P<sub>GTG</sub></i>, through the gas turbine generator. The remaining portion
of energy, <i>1 - &eta;<sub>GTG</sub></i>, is supplied to the HRSG as exhaust gas.
The equations are:
</p>
<p align=\"center\">
<i>
P<sub>GTG</sub> = Q&#775;<sub>fuel</sub> &eta;<sub>GTG</sub>,
</i>
</p>
<p align=\"center\">
<i>
Q&#775;<sub>exhaust</sub> = Q&#775;<sub>fuel</sub> (1 - &eta;<sub>GTG</sub>).
</i>
</p>
<p>
In theory, the waste heat <i>Q&#775;<sub>exhaust</sub></i> can be expressed by the
equation above. In the model, the corresponding values of exhaust gas mass flow
rate and exhaust temperature are given to provide the waste heat.
</p>
<p>
This model uses look-up tables to capture the gas turbine's performance. The Solar
Turbine manufacturer datasheet, available in
<a href=\"modelica://Buildings.Fluid.CHPs.DistrictCHP.Data.SolarTurbines\">
Data.SolarTurbines</a>, provides details on gas turbine performance in terms of
electricity generation efficiency, exhaust gas mass flow rate, and exhaust gas
temperature. These parameters are determined based on the ambient temperature
<code>TSet</code> and the load factor <code>y</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 08, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end TopCycle;
