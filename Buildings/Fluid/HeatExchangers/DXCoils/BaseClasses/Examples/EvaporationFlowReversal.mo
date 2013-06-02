within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model EvaporationFlowReversal
  "Test model for evaporation with zero flow and flow reversal"
  extends Modelica.Icons.Example;
  package Medium =Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.Data.Generic.BaseClasses.NominalValues
                                                                          nomVal(
          Q_flow_nominal=-5000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=5000/1006/10) "Nominal values for DX coil"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  parameter Modelica.SIunits.MassFraction XEvaIn_nominal=
    Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
     pSat=Medium.saturationPressure(nomVal.TEvaIn_nominal),
     p=nomVal.p_nominal,
     phi=nomVal.phiIn_nominal) "Mass fraction at nominal inlet conditions";

  parameter Modelica.SIunits.MassFraction XEvaOut_nominal = XEvaIn_nominal +
   (1-nomVal.SHR_nominal) * nomVal.Q_flow_nominal/nomVal.m_flow_nominal/Medium.enthalpyOfVaporization(293.15)
    "Nominal air outlet humidity";

  Evaporation eva(redeclare package Medium = Medium, nomVal=nomVal,
    m(start=0.55, fixed=true)) "Evaporation model"
    annotation (Placement(transformation(extent={{40,6},{60,26}})));
  Modelica.Blocks.Sources.BooleanConstant offSignal(k=false)
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Modelica.Blocks.Sources.Constant TWat(k=293.15)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.TimeTable mAir_flow(table=[0,1; 300,1; 900,-1; 1200,-1;
        1500,0; 1800,0]) "Air flow rate"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Constant TEva(k=nomVal.TEvaIn_nominal)
    "Inlet Temperature"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Continuous.Integrator int
    "Mass of water that evaporates into air stream"
    annotation (Placement(transformation(extent={{80,6},{100,26}})));
  Modelica.Blocks.Sources.Constant mWat_flow(k=0)
    "Water flow rate added into the medium from the coil model (without reevaporation flow rate)"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Math.Gain gain(k=nomVal.m_flow_nominal)
    annotation (Placement(transformation(extent={{-48,0},{-28,20}})));
  Modelica.Blocks.Sources.Constant XEvaIn(k=XEvaIn_nominal)
    "Inlet water vapor mass fraction"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
equation

  connect(offSignal.y, eva.on)        annotation (Line(
      points={{1,70},{20,70},{20,24},{38,24}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(eva.TWat, TWat.y)    annotation (Line(
      points={{38,14},{-34,14},{-34,40},{-59,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow.y, eva.mWat_flow) annotation (Line(
      points={{-59,70},{-30,70},{-30,20},{38,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mAir_flow.y, gain.u) annotation (Line(
      points={{-59,10},{-50,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, eva.mAir_flow) annotation (Line(
      points={{-27,10},{3.5,10},{3.5,8},{38,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eva.mTotWat_flow, int.u) annotation (Line(
      points={{61,16},{78,16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XEvaIn.y, eva.XEvaOut) annotation (Line(
      points={{-59,-30},{44,-30},{44,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEva.y, eva.TEvaOut) annotation (Line(
      points={{-59,-70},{56,-70},{56,4}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-120},{120,100}},
          preserveAspectRatio=true)),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/DXCoils/BaseClasses/Examples/EvaporationFlowReversal.mos"
        "Simulate and plot"),
          Documentation(info="<html>
<p>
This example illustrates the evaporation of water vapor that 
accumulated on the coil.
Input to the model is an air mass flow rate that is first positive, then
ramps down to a negative value, and eventually ramps up to zero where
it remains for a while.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 25, 2012 by Michael Wetter:<br/>
First implementation. 
</li>
</ul>
</html>"),
    experiment(
      StopTime=2400,
      Tolerance=1e-05));
end EvaporationFlowReversal;
