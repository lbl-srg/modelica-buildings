within Buildings.Fluid.HeatExchangers.CoolingTowers.Validation;
model MerkelEnergyPlus
  "Validation with EnergyPlus model for Merkel's cooling tower"
  extends Modelica.Icons.Example;

  package MediumAir = Buildings.Media.Air "Air medium model";
  package MediumWat = Buildings.Media.Water "Water medium model";

  parameter Modelica.Units.SI.Density denWat=MediumWat.density(
      MediumWat.setState_pTX(
      MediumWat.p_default,
      MediumWat.T_default,
      MediumWat.X_default)) "Default density of water";

  // Cooling tower parameters
  parameter Modelica.Units.SI.PressureDifference dp_nominal=6000
    "Nominal pressure difference of cooling tower";
  parameter Modelica.Units.SI.VolumeFlowRate VWat_flow_nominal=0.00109181
    "Nominal volumetric flow rate of water (medium 2)";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=VWat_flow_nominal*
      denWat "Nominal mass flow rate of water (medium 2)";
  parameter Real ratWatAir_nominal = 1.61599
    "Nominal water-to-air ratio";
  parameter Modelica.Units.SI.Temperature TAirInWB_nominal=18.85 + 273.15
    "Nominal outdoor wetbulb temperature";
  parameter Modelica.Units.SI.Temperature TWatIn_nominal=34.16 + 273.15
    "Nominal water inlet temperature";
  parameter Modelica.Units.SI.Temperature TWatOut_initial=33.019 + 273.15
    "Nominal water inlet temperature";
  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=-20286.37455
    "Nominal heat transfer, positive";
  parameter Modelica.Units.SI.ThermalConductance UA_nominal_EP=2011.28668
    "Nominal heat transfer, positive";
  parameter Modelica.Units.SI.Power PFan_nominal=213.00693 "Nominal fan power";

  parameter Real r_VEnePlu[:] = {0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1}
    "Fan control signal";
  parameter Real r_PEnePlu[:] = {0,0.020982275,0.027843038,0.046465108,
    0.082729139,0.142515786,0.231705701,0.356179538,0.521817952,0.734501596,1}
    "Fan power output as a function of the signal";

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=ModelicaServices.ExternalReferences.loadResource(
      "modelica://Buildings//Resources/Data/Fluid/HeatExchangers/CoolingTowers/Validation/MerkelEnergyPlus/CoolingTower_VariableSpeed_Merkel.dat"),
    verboseRead=false,
    columns=2:10,
    tableName="EnergyPlus",
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for \"CoolingTower_VariableSpeed_Merkel.idf\" energy plus example results"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel tow(
    redeclare package Medium = MediumWat,
    dp_nominal=dp_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=TWatOut_initial,
    m_flow_nominal=m_flow_nominal,
    ratWatAir_nominal=ratWatAir_nominal,
    TAirInWB_nominal=TAirInWB_nominal,
    TWatIn_nominal=TWatIn_nominal,
    TWatOut_nominal=TWatIn_nominal+Q_flow_nominal/(m_flow_nominal*Buildings.Utilities.Psychrometrics.Constants.cpWatLiq),
    PFan_nominal=PFan_nominal,
    yMin=0.1,
    fraFreCon=0.1,
    fanRelPow(r_V=r_VEnePlu, r_P=r_PEnePlu),
    UACor(FRAirMin=0.2)) "Merkel-theory based cooling tower"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Sources.MassFlowSource_T souWat(
    redeclare package Medium = MediumWat,
    use_m_flow_in=true,
    T=328.15,
    nPorts=1,
    use_T_in=true)
    "Water source to the cooling tower"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));

  Sources.Boundary_pT sinWat(redeclare package Medium = MediumWat,nPorts=1)
    "Water sink from the cooling tower"
    annotation (Placement(transformation(extent={{100,-60},{80,-40}})));

  Controls.OBC.UnitConversions.From_degC TEntWat
    "Block that converts entering water temperature"
    annotation (Placement(transformation(extent={{-60,-56},{-40,-36}})));

  Controls.OBC.UnitConversions.From_degC TAirWB
    "Block that converts entering air wetbulb temperature"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Modelica.Blocks.Sources.RealExpression TLvg_EP(y=datRea.y[4])
    "EnergyPlus results: cooling tower leaving water temperature"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

  Modelica.Blocks.Sources.RealExpression Q_flow_EP(y=-1*datRea.y[6])
    "EnergyPlus results: cooling tower heat flow rate"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));

  Modelica.Blocks.Sources.RealExpression PFan_EP(y=datRea.y[7])
    "EnergyPlus results: fan power consumption"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));

equation
  connect(tow.TAir, TAirWB.y)
    annotation (Line(points={{38,-46},{20,-46},{20,10},{-38,10}},
      color={0,0,127}));
  connect(souWat.ports[1], tow.port_a)
    annotation (Line(points={{0,-50},{40,-50}}, color={0,127,255}));
  connect(tow.port_b, sinWat.ports[1])
    annotation (Line(points={{60,-50},{80,-50}}, color={0,127,255}));
  connect(TEntWat.y, souWat.T_in)
    annotation (Line(points={{-38,-46},{-22,-46}},color={0,0,127}));
  connect(datRea.y[2], TAirWB.u)
    annotation (Line(points={{-79,50},{-70,50},{-70,10},{-62,10}},
      color={0,0,127}));
  connect(TEntWat.u, datRea.y[3])
    annotation (Line(points={{-62,-46},{-70,-46},{-70,50},{-79,50}},
       color={0,0,127}));
  connect(souWat.m_flow_in, datRea.y[5])
    annotation (Line(points={{-22,-42},{-30,-42},{-30,-20},{-70,-20},
      {-70,50},{-79,50}}, color={0,0,127}));
  connect(tow.y, datRea.y[9])
    annotation (Line(points={{38,-42},{30,-42},{30,50},
          {-79,50}}, color={0,0,127}));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false,
        extent={{-120,-100},{120,100}})),
    __Dymola_Commands(file=
        "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Validation/MerkelEnergyPlus.mos"
        "Simulate and plot"),
    experiment(
      StartTime=0,
      StopTime=172800,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model validates the model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a> by comparing against
results obtained from EnergyPlus.
</p>
<p>
The EnergyPlus results were obtained using the example file
<code>CoolingTower:VariableSpeed</code>, with the cooling tower evaluated as
the <code>CoolingTower:VariableSpeed:Merkel</code> model from EnergyPlus.
</p>
<p>
The difference in results of the cooling tower's leaving water temperature
(<code>tow.TLvg</code> and <code>TLvg.EP</code>)
during the middle and end of the simulation is because the mass flow rate is
zero. For zero mass flow rate, EnergyPlus assumes a steady state condition,
whereas the Modelica model is a dynamic model and hence the properties at the
outlet are equal to the state variables of the model.
</p>
</html>", revisions="<html>
<ul>
<li>
December 23, 2019, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end MerkelEnergyPlus;
