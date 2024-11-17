within GED.DistrictElectrical.CHP;
model ToppingCycle "Topping cycle subsystem model"
  extends Modelica.Blocks.Icons.Block;

  // Parameters for the nominal condition
  parameter Modelica.Units.SI.Power P_nominal = per.P_nominal
    "Gas turbine power generation capacity"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TExh_nominal = per.TExh_nominal
    "Nominal exhaust gas temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mExh_nominal = per.mExh_nominal
    "Nominal exhaust mass flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Efficiency eta_nominal=per.eta_nominal
    "Nominal gas turbine efficiency"
    annotation (Dialog(group="Nominal condition"));
  // Natural gas properties
  parameter Modelica.Units.SI.SpecificEnthalpy  LHVFue = per.LHVFue
    "Lower heating value";

  // Inputs
  Modelica.Blocks.Interfaces.RealInput y "Part load ratio"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput TSet "Ambient temperature"
    annotation (Placement(
        transformation(extent={{-140,-60},{-100,-20}}), iconTransformation(
          extent={{-140,-60},{-100,-20}})));

  // Outputs
  Modelica.Blocks.Interfaces.RealOutput PEle(
    final quantity= "Power",
    final unit = "W")
    "Gas turbine electricity generation"
    annotation (Placement(
        transformation(extent={{100,64},{132,96}}), iconTransformation(extent={{100,64},
            {132,96}})));
  Modelica.Blocks.Interfaces.RealOutput mFue(
    final unit= "kg/s")
    "Fuel mass flow rate"
    annotation (Placement(
        transformation(extent={{100,4},{134,38}}),  iconTransformation(extent={{100,4},
            {134,38}})));
  Modelica.Blocks.Interfaces.RealOutput TExh(
    final quantity="ThermodynamicTemperature",
    final unit = "degC")
    "Exhaust temperature"
    annotation (Placement(
        transformation(
        extent={{-17,-17},{17,17}},
        rotation=-90,
        origin={81,-117}), iconTransformation(
        extent={{-19,-19},{19,19}},
        rotation=-90,
        origin={81,-119})));
  Modelica.Blocks.Interfaces.RealOutput mExh(
    final unit= "kg/s")
    "Exhaust mass flow rate"
    annotation (Placement(
        transformation(
        extent={{-19,-19},{19,19}},
        rotation=-90,
        origin={41,-119}),iconTransformation(
        extent={{-19,-19},{19,19}},
        rotation=-90,
        origin={19,-119})));

  // Look-up tables
  replaceable parameter GED.DistrictElectrical.CHP.Data.Generic per
    "Records of gas turbine performance data"
     annotation (choicesAllMatching= true, Placement(transformation(extent={{-80,-78},{-60,-58}})));
  Modelica.Blocks.Tables.CombiTable2Ds eleCap_CorFac(
    final table=per.capPowCor_GTG,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Look-up table that represents a set of efficiency curves varying with both the outdoor air temperature and the part load ratio"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Modelica.Blocks.Tables.CombiTable2Ds gasTurEff_CorFac(
    final table=per.effCor_GTG,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    "Look-up table that represents a set of efficiency curves varying with both the outdoor air temperature and the part load ratio"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Tables.CombiTable2Ds exhT_CorFac(
    final table=per.exhTempCor_GT,
    final smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Modelica.Blocks.Tables.CombiTable2Ds exhMas_CorFac(
    final table=per.exhMasCor_GT,
    final smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments)
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  // Others
protected
  Modelica.Blocks.Sources.Constant fulCap(k=1)
    "Full power generation capacity"
    annotation (Placement(transformation(extent={{-88,70},{-68,90}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply pow
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Modelica.Blocks.Sources.RealExpression loaFac(y=loaPer.u)
    annotation (Placement(transformation(extent={{0,80},{20,100}})));
  Buildings.Controls.OBC.CDL.Reals.Divide groHea
    "Gross heat input into the system"
    annotation (Placement(transformation(extent={{40,20},{60,40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter eleCap(
    final k=P_nominal) "Fuel mass flow rate computation"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter nomHea(
    final k=1/LHVFue)    "Low heating value"
    annotation (Placement(transformation(extent={{72,10},{92,30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gasTurEff(
    final k=eta_nominal) "Gas turbine efficiency computation"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter exhTemp(
    final k=TExh_nominal) "Exhaust temperature computation"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter exhMas(
    final k=mExh_nominal) "Exhaust mass flow rate computation"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter loaPer(
    final k=1)
    "load ratio"
    annotation (Placement(transformation(extent={{-88,30},{-68,50}})));

equation
  connect(exhT_CorFac.y, exhTemp.u)
    annotation (Line(points={{-19,-10},{-2,-10}}, color={0,0,127}));
  connect(exhMas_CorFac.y, exhMas.u)
    annotation (Line(points={{-19,-50},{-2,-50}}, color={0,0,127}));
  connect(loaPer.u, y)
    annotation (Line(points={{-90,40},{-120,40}}, color={0,0,127}));
  connect(gasTurEff_CorFac.u1, loaPer.y) annotation (Line(points={{-42,36},{-60,
          36},{-60,40},{-66,40}}, color={0,0,127}));
  connect(exhT_CorFac.u1, loaPer.y) annotation (Line(points={{-42,-4},{-60,-4},{
          -60,40},{-66,40}}, color={0,0,127}));
  connect(exhMas_CorFac.u1, loaPer.y) annotation (Line(points={{-42,-44},{-60,-44},
          {-60,40},{-66,40}}, color={0,0,127}));
  connect(gasTurEff.u, gasTurEff_CorFac.y)
    annotation (Line(points={{-2,30},{-19,30}}, color={0,0,127}));
  connect(eleCap_CorFac.y, eleCap.u)
    annotation (Line(points={{-19,70},{-2,70}}, color={0,0,127}));
  connect(gasTurEff.y, groHea.u2) annotation (Line(points={{22,30},{30,30},{30,
          24},{38,24}},
                    color={0,0,127}));
  connect(exhTemp.y, TExh)
    annotation (Line(points={{22,-10},{81,-10},{81,-117}}, color={0,0,127}));
  connect(exhMas.y, mExh)
    annotation (Line(points={{22,-50},{41,-50},{41,-119}}, color={0,0,127}));
  connect(nomHea.y, mFue)
    annotation (Line(points={{94,20},{106,20},{106,21},{117,21}},
                                                color={0,0,127}));
  connect(nomHea.u, groHea.y) annotation (Line(points={{70,20},{66,20},{66,30},
          {62,30}},color={0,0,127}));
  connect(pow.y, PEle)
    annotation (Line(points={{62,80},{116,80}}, color={0,0,127}));
  connect(loaFac.y, pow.u1) annotation (Line(points={{21,90},{32,90},{32,86},{
          38,86}}, color={0,0,127}));
  connect(eleCap.y, pow.u2) annotation (Line(points={{22,70},{30,70},{30,74},{
          38,74}}, color={0,0,127}));
  connect(pow.y, groHea.u1) annotation (Line(points={{62,80},{80,80},{80,60},{
          32,60},{32,36},{38,36}}, color={0,0,127}));
  connect(eleCap_CorFac.u1, fulCap.y) annotation (Line(points={{-42,76},{-60,76},
          {-60,80},{-67,80}}, color={0,0,127}));
  connect(eleCap_CorFac.u2, TSet) annotation (Line(points={{-42,64},{-50,64},{
          -50,-40},{-120,-40}}, color={0,0,127}));
  connect(gasTurEff_CorFac.u2, TSet) annotation (Line(points={{-42,24},{-50,24},
          {-50,-40},{-120,-40}}, color={0,0,127}));
  connect(exhT_CorFac.u2, TSet) annotation (Line(points={{-42,-16},{-50,-16},{
          -50,-40},{-120,-40}}, color={0,0,127}));
  connect(exhMas_CorFac.u2, TSet) annotation (Line(points={{-42,-56},{-50,-56},
          {-50,-40},{-120,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  Documentation(info="<html>
<p>
In the topping cycle, a gas turbine is commonly used as the prime mover. The energy balance equation of the topping cycle process can be expressed as follows
</p>

<p>
The fuel combustion energy flow is considered equal to the generated electricity and the heat flow of the exhaust gas.
</p>

<p align=\"center\">
<i>
Q<sub>fuel</sub> = P<sub>GTG</sub> + Q<sub>exhaust</sub>,
</i>
</p>

<p>where <i>Q<sub>fuel</sub></i> is the fuel combustion energy in the gas turbine, <i>P<sub>GTG</sub></i> denotes the electricity production from the gas turbine generator, and <i>Q<sub>exhaust</sub></i> represents the heat flow of the exhaust gas. Note that the fuel combustion energy is calculated as the product of the mass flow rate of the fuel, <i>m&#775;<sub>fuel</sub></i>, and its lower heating value (LHV):</p>

<p align=\"center\">
<i>
Q<sub>fuel</sub> = m&#775;<sub>fuel</sub> LHV<sub>fuel</sub>.
</i>
</p>

<p>A fraction of the fuel combustion energy of the gas turbine fuel, <i>&eta;<sub>GTG</sub></i>, is transformed into electricity, denoted as <i>P<sub>GTG</sub></i>, through the gas turbine generator. The remaining portion of energy, <i>1 - &eta;<sub>GTG</sub></i>, is supplied to the HRSG as exhaust gas. The equations are:</p>

<p align=\"center\">
<i>
P<sub>GTG</sub> = Q<sub>fuel</sub> &eta;<sub>GTG</sub>,
</i>
</p>

<p align=\"center\">
<i>
Q<sub>exhaust</sub> = Q<sub>fuel</sub> (1 - &eta;<sub>GTG</sub>).
</i>
</p>

<p>
In theory, the waste heat <i>Q<sub>exhaust</sub></i> can be expressed by the equation above. In the model, the corresponding values of exhaust gas mass flow rate and exhaust temperature are given to provide the waste heat. 
</p>

<p>
This model uses look-up tables to capture the gas turbine's performance. The Solar Turbine manufacturer datasheet, available in <code>Data.SolarTurbines</code>, provides details on gas turbine performance in terms of electricity generation efficiency, exhaust gas mass flow rate, and exhaust gas temperature. These parameters are determined based on the ambient temperature <code>TSet</code> and the load factor <code>y</code>.
</p>

</html>", revisions="<html>
<ul>
<li>
March 08, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>"));
end ToppingCycle;
