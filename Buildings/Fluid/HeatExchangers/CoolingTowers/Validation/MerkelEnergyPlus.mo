within Buildings.Fluid.HeatExchangers.CoolingTowers.Validation;
model MerkelEnergyPlus
  "Validation with EnergyPlus model for Merkel's cooling tower"
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air "Air medium model";
  package MediumWat = Buildings.Media.Water "Water medium model";

  parameter Modelica.SIunits.Density denAir=
    MediumAir.density(
      MediumAir.setState_pTX(MediumAir.p_default, MediumAir.T_default, MediumAir.X_default))
      "Default density of air";
  parameter Modelica.SIunits.Density denWat=
    MediumWat.density(
      MediumWat.setState_pTX(MediumWat.p_default, MediumWat.T_default, MediumWat.X_default))
      "Default density of water";

  // Cooling tower parameters
  parameter Modelica.SIunits.PressureDifference dp_nominal = 1000
    "Nominal pressure difference of cooling tower";
  parameter Modelica.SIunits.VolumeFlowRate vAir_flow_nominal = 0.56054
    "Nominal volumetric flow rate of air (medium 1)";
  parameter Modelica.SIunits.VolumeFlowRate vWat_flow_nominal = 0.00109181
    "Nominal volumetric flow rate of water (medium 2)";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal = vAir_flow_nominal * denAir
    "Nominal mass flow rate of air (medium 1)";
  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal = vWat_flow_nominal * denWat
    "Nominal mass flow rate of water (medium 2)";
  parameter Modelica.SIunits.Temperature TAirInWB_nominal = 20.59+273.15
    "Nominal outdoor wetbulb temperature";
  parameter Modelica.SIunits.Temperature TWatIn_nominal = 34.16+273.15
    "Nominal water inlet temperature";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 20286.37455
    "Nominal heat transfer, positive";
  parameter Modelica.SIunits.Power pFan_nominal = 213.00693
    "Nominal fan power";


  Merkel tow(
    redeclare package Medium = MediumWat,
    dp_nominal=dp_nominal,
    m1_flow_nominal=mAir_flow_nominal,
    m2_flow_nominal=mWat_flow_nominal,
    TAirInWB_nominal=TAirInWB_nominal,
    TWatIn_nominal=TWatIn_nominal,
    Q_flow_nominal=Q_flow_nominal,
    PFan_nominal=pFan_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow)
             "Merkel-theory based cooling tower"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWat,
    use_m_flow_in=false,
    m_flow=1.088,
    T=328.15,
    nPorts=1,
    use_T_in=true) "Water source to the cooling tower" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-10,-10})));
  Sources.Boundary_pT sinWat(redeclare package Medium = MediumWat,
                                                                nPorts=1)
    "Water sink from the cooling tower"
    annotation (Placement(transformation(extent={{100,-20},{80,0}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings//Resources/Data/Fluid/HeatExchangers/CoolingTowers/Validation/MerkelEnergyPlus/modelica.csv"),
    columns=2:12,
    tableName="modelica",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"CoolingTower_VariableSpeed_Merkel.idf\" energy plus example results"
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));

  Controls.OBC.UnitConversions.From_degC TEntWat
    "Block that converts entering water temperature"
    annotation (Placement(transformation(extent={{-60,-24},{-40,-4}})));
  Controls.OBC.UnitConversions.From_degC TAirWB
    "Block that converts entering air wetbulb temperature"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Math.Division conFan
    "Block to convert fan power reading to fan control signal y"
    annotation (Placement(transformation(extent={{-20,74},{0,94}})));
  Modelica.Blocks.Sources.RealExpression pFan_nom(y=pFan_nominal)
    "Nominal fan power"
    annotation (Placement(transformation(extent={{-60,68},{-40,88}})));
  Modelica.Blocks.Sources.RealExpression Q_flow_EP(y=-datRea.y[8])
    "EnergyPlus results: cooling tower heat flow rate"
    annotation (Placement(transformation(extent={{20,-58},{40,-38}})));
  Modelica.Blocks.Sources.RealExpression pFan_EP(y=datRea.y[9])
    "EnergyPlus results: fan power consumption"
    annotation (Placement(transformation(extent={{20,-78},{40,-58}})));
  Modelica.Blocks.Sources.RealExpression TLvg_EP(y=datRea.y[6])
    "EnergyPlus results: cooling tower leaving water temperature"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
equation
  connect(tow.TAir, TAirWB.y) annotation (Line(points={{38,-6},{20,-6},{20,50},
          {-38,50}}, color={0,0,127}));
  connect(souWat.ports[1], tow.port_a)
    annotation (Line(points={{0,-10},{40,-10}}, color={0,127,255}));
  connect(tow.port_b, sinWat.ports[1])
    annotation (Line(points={{60,-10},{80,-10}}, color={0,127,255}));
  connect(TEntWat.y, souWat.T_in)
    annotation (Line(points={{-38,-14},{-22,-14}}, color={0,0,127}));
  connect(pFan_nom.y, conFan.u2)
    annotation (Line(points={{-39,78},{-22,78}}, color={0,0,127}));
  connect(conFan.y, tow.y) annotation (Line(points={{1,84},{30,84},{30,-2},{38,
          -2}},  color={0,0,127}));
  connect(datRea.y[9], conFan.u1)
    annotation (Line(points={{-79,90},{-22,90}}, color={0,0,127}));
  connect(datRea.y[2], TAirWB.u) annotation (Line(points={{-79,90},{-70,90},{
          -70,50},{-62,50}},
                         color={0,0,127}));
  connect(datRea.y[5], TEntWat.u) annotation (Line(points={{-79,90},{-70,90},{
          -70,-14},{-62,-14}},
                           color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-120,
            -120},{120,120}})),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,
            120}})),
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
