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
  parameter Modelica.SIunits.Power PFan_nominal = 213.00693
    "Nominal fan power";


  Modelica.Blocks.Interfaces.RealOutput PFan_EP(
    quantity="Power",
    unit="W",
    displayUnit="kW")
    "EnergyPlus results: fan power consumption"
    annotation (Placement(transformation(extent={{120,40},{140,60}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow_EP(
    quantity="HeatFlowRate",
    unit="W",
    displayUnit="kW")
    "EnergyPlus results: cooling tower heat flow rate"
    annotation (Placement(transformation(extent={{120,60},{140,80}})));
  Modelica.Blocks.Interfaces.RealOutput TLvg_EP(
    quantity="Temperature",
    unit="degC") "EnergyPlus results: cooling tower leaving water temperature"
    annotation (Placement(transformation(extent={{120,100},{140,120}})));
  Modelica.Blocks.Math.Gain inv(k=-1) "Additive inverse (cooling)"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Merkel tow(
    redeclare package Medium = MediumWat,
    dp_nominal=dp_nominal,
    m1_flow_nominal=mAir_flow_nominal,
    m2_flow_nominal=mWat_flow_nominal,
    TAirInWB_nominal=TAirInWB_nominal,
    TWatIn_nominal=TWatIn_nominal,
    Q_flow_nominal=Q_flow_nominal,
    PFan_nominal=PFan_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow)
             "Merkel-theory based cooling tower"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
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
        origin={-10,-70})));
  Sources.Boundary_pT sinWat(redeclare package Medium = MediumWat,
                                                                nPorts=1)
    "Water sink from the cooling tower"
    annotation (Placement(transformation(extent={{100,-80},{80,-60}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings//Resources/Data/Fluid/HeatExchangers/CoolingTowers/Validation/MerkelEnergyPlus/modelica.csv"),
    columns=2:12,
    tableName="modelica",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"CoolingTower_VariableSpeed_Merkel.idf\" energy plus example results"
      annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Controls.OBC.UnitConversions.From_degC TEntWat
    "Block that converts entering water temperature"
    annotation (Placement(transformation(extent={{-60,-84},{-40,-64}})));
  Controls.OBC.UnitConversions.From_degC TAirWB
    "Block that converts entering air wetbulb temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Math.Division conFan
    "Block to convert fan power reading to fan control signal y"
    annotation (Placement(transformation(extent={{-20,14},{0,34}})));
  Modelica.Blocks.Sources.RealExpression PFan_nom(y=PFan_nominal)
    "Nominal fan power"
    annotation (Placement(transformation(extent={{-60,8},{-40,28}})));
  Modelica.Blocks.Interfaces.RealOutput m_flow_EP(quantity="MassFlowRate", unit=
       "kg/s") "EnergyPlus results: cooling tower mass flow rate"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
equation
  connect(tow.TAir, TAirWB.y) annotation (Line(points={{38,-66},{20,-66},{20,-10},
          {-38,-10}},color={0,0,127}));
  connect(souWat.ports[1], tow.port_a)
    annotation (Line(points={{0,-70},{40,-70}}, color={0,127,255}));
  connect(tow.port_b, sinWat.ports[1])
    annotation (Line(points={{60,-70},{80,-70}}, color={0,127,255}));
  connect(TEntWat.y, souWat.T_in)
    annotation (Line(points={{-38,-74},{-22,-74}}, color={0,0,127}));
  connect(PFan_nom.y, conFan.u2)
    annotation (Line(points={{-39,18},{-22,18}}, color={0,0,127}));
  connect(conFan.y, tow.y) annotation (Line(points={{1,24},{30,24},{30,-62},{38,
          -62}}, color={0,0,127}));
  connect(datRea.y[9], conFan.u1)
    annotation (Line(points={{-79,30},{-22,30}}, color={0,0,127}));
  connect(datRea.y[2], TAirWB.u) annotation (Line(points={{-79,30},{-70,30},{-70,
          -10},{-62,-10}},
                         color={0,0,127}));
  connect(datRea.y[5], TEntWat.u) annotation (Line(points={{-79,30},{-70,30},{-70,
          -74},{-62,-74}}, color={0,0,127}));
  connect(TLvg_EP, datRea.y[6]) annotation (Line(points={{130,110},{-70,110},{-70,
          30},{-79,30}}, color={0,0,127}));
  connect(inv.y, Q_flow_EP) annotation (Line(points={{101,70},{112,70},{112,70},
          {130,70}}, color={0,0,127}));
  connect(inv.u, datRea.y[8]) annotation (Line(points={{78,70},{-70,70},{-70,30},
          {-79,30}}, color={0,0,127}));
  connect(PFan_EP, datRea.y[9]) annotation (Line(points={{130,50},{-70,50},{-70,
          30},{-79,30}}, color={0,0,127}));
  connect(m_flow_EP, datRea.y[7]) annotation (Line(points={{130,90},{-70,90},{-70,
          30},{-79,30}}, color={0,0,127}));
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
