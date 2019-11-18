within Buildings.Fluid.HeatExchangers.CoolingTowers.Validation;
model MerkelEnergyPlus
  "Validation with EnergyPlus model for Merkel's cooling tower"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model";

  // Cooling tower parameters
  parameter Modelica.SIunits.PressureDifference dp_nominal = 1000
    "Nominal pressure difference of cooling tower";
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal = 0.5
    "Nominal mass flow rate of medium 1";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal = 0.5
    "Nominal mass flow rate of medium 2";
  parameter Modelica.SIunits.Temperature TAirInWB_nominal = 30+273.15
    "Nominal outdoor wetbulb temperature";
  parameter Modelica.SIunits.Temperature TWatIn_nominal = 30+273.15
    "Nominal water inlet temperature";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 1000
    "Nominal heat transfer, positive";
  parameter Modelica.SIunits.Power PFan_nominal = 100
    "Nominal fan power";


  Merkel tow(
    redeclare package Medium = Medium,
    dp_nominal=dp_nominal,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    TAirInWB_nominal=TAirInWB_nominal,
    TWatIn_nominal=TWatIn_nominal,
    Q_flow_nominal=Q_flow_nominal,
    PFan_nominal=PFan_nominal)
             "Merkel-theory based cooling tower"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Sources.MassFlowSource_T souWat(
    redeclare package Medium = Medium,
    use_m_flow_in=false,
    m_flow=1.088,
    T=328.15,
    nPorts=1,
    use_T_in=true) "Water source to the cooling tower" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-10,-30})));
  Sources.Boundary_pT sinWat(redeclare package Medium = Medium, nPorts=1)
    "Water sink from the cooling tower"
    annotation (Placement(transformation(extent={{100,-40},{80,-20}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings//Resources/Data/Fluid/HeatExchangers/CoolingTowers/Validation/MerkelEnergyPlus/modelica.csv"),
    columns=2:12,
    tableName="modelica",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"CoolingTower_VariableSpeed_Merkel.idf\" energy plus example results"
      annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Controls.OBC.UnitConversions.From_degC TEntWat
    "Block that converts entering water temperature"
    annotation (Placement(transformation(extent={{-60,-44},{-40,-24}})));
  Controls.OBC.UnitConversions.From_degC TAirWB
    "Block that converts entering air wetbulb temperature"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Modelica.Blocks.Math.Division conFan
    "Block to convert fan power reading to fan control signal y"
    annotation (Placement(transformation(extent={{-20,54},{0,74}})));
  Modelica.Blocks.Sources.RealExpression PFan_nom(y=PFan_nominal)
    "Nominal fan power"
    annotation (Placement(transformation(extent={{-60,48},{-40,68}})));
equation
  connect(datRea.y[6], TEntWat.u) annotation (Line(points={{-79,70},{-70,70},{-70,
          -34},{-62,-34}}, color={0,0,127}));
  connect(datRea.y[3], TAirWB.u) annotation (Line(points={{-79,70},{-70,70},{-70,
          30},{-62,30}}, color={0,0,127}));
  connect(tow.TAir, TAirWB.y) annotation (Line(points={{38,-26},{20,-26},{20,30},
          {-38,30}}, color={0,0,127}));
  connect(souWat.ports[1], tow.port_a)
    annotation (Line(points={{0,-30},{40,-30}}, color={0,127,255}));
  connect(tow.port_b, sinWat.ports[1])
    annotation (Line(points={{60,-30},{80,-30}}, color={0,127,255}));
  connect(TEntWat.y, souWat.T_in)
    annotation (Line(points={{-38,-34},{-22,-34}}, color={0,0,127}));
  connect(datRea.y[10], conFan.u1)
    annotation (Line(points={{-79,70},{-22,70}}, color={0,0,127}));
  connect(PFan_nom.y, conFan.u2)
    annotation (Line(points={{-39,58},{-22,58}}, color={0,0,127}));
  connect(conFan.y, tow.y) annotation (Line(points={{1,64},{30,64},{30,-22},{38,
          -22}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-100},{120,100}})),
    Documentation(info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a> by comparing against results 
obtained from EnergyPlus 9.2.
</p>
<p>
The EnergyPlus results were obtained using the example file <code>CoolingTower:VariableSpeed</code>, 
with the cooling tower evaluated as the <code>CoolingTower:VariableSpeed:Merkel</code> model from 
EnergyPlus 9.2. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 23, 2019 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end MerkelEnergyPlus;
