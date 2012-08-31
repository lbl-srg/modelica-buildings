within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Examples;
model EvaporationFlowReversal
  "Test model for evaporation with zero flow and flow reversal"
  extends Modelica.Icons.Example;
  package Medium =Buildings.Media.GasesConstantDensity.MoistAirUnsaturated;

  parameter
    Buildings.Fluid.HeatExchangers.DXCoils.Data.BaseClasses.NominalValues nomVal(
          Q_flow_nominal=-5000,
          COP_nominal=3,
          SHR_nominal=0.8,
          m_flow_nominal=5000/1006/10) "Nominal values for DX coil"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  parameter Modelica.SIunits.Temperature TOut_nominal=
    nomVal.TIn_nominal + nomVal.SHR_nominal * nomVal.Q_flow_nominal/nomVal.m_flow_nominal/1006
    "Nominal air outlet temperature";

  parameter Modelica.SIunits.MassFraction XIn_nominal=
    Buildings.Utilities.Psychrometrics.Functions.X_pSatpphi(
     pSat=Medium.saturationPressure(nomVal.TIn_nominal),
     p=nomVal.p_nominal,
     phi=nomVal.phiIn_nominal) "Mass fraction at nominal inlet conditions";

  parameter Modelica.SIunits.MassFraction XOut_nominal = XIn_nominal +
   (1-nomVal.SHR_nominal) * nomVal.Q_flow_nominal/nomVal.m_flow_nominal/Medium.enthalpyOfVaporization(293.15)
    "Nominal air outlet humidity";

  Evaporation eva(redeclare package Medium = Medium, nomVal=nomVal,
    m(start=0.55)) "Evaporation model"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));
  Modelica.Blocks.Sources.BooleanConstant offSignal(k=false)
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Blocks.Sources.Constant TWat(k=293.15)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.TimeTable mAir_flow(table=[0,1; 300,1; 900,-1; 1200,-1;
        1500,0; 1800,0]) "Air flow rate"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.Constant XOut(k=XOut_nominal)
    "Outlet water vapor mass fraction"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Modelica.Blocks.Sources.Constant TOut(k=TOut_nominal) "Outlet Temperature"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Modelica.Blocks.Continuous.Integrator int
    "Mass of water that evaporates into air stream"
    annotation (Placement(transformation(extent={{80,10},{100,30}})));
  Modelica.Blocks.Sources.Constant mWat_flow(k=0)
    "Water flow rate added into the medium from the coil model (without reevaporation flow rate)"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Modelica.Blocks.Math.Gain gain(k=nomVal.m_flow_nominal)
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation

  connect(offSignal.y, eva.on)        annotation (Line(
      points={{-59,70},{-18,70},{-18,30},{38,30}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(eva.TWat, TWat.y)    annotation (Line(
      points={{38,22},{-6,22},{-6,6.10623e-16},{-59,6.10623e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XOut.y, eva.XOut)    annotation (Line(
      points={{-59,-60},{26,-60},{26,14},{38,14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut.y, eva.TOut)    annotation (Line(
      points={{-59,-90},{10,-90},{10,10},{38,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eva.mEva_flow, int.u)       annotation (Line(
      points={{61,20},{78,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mWat_flow.y, eva.mWat_flow) annotation (Line(
      points={{-59,30},{-20,30},{-20,26},{38,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mAir_flow.y, gain.u) annotation (Line(
      points={{-59,-30},{-42,-30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y, eva.mAir_flow) annotation (Line(
      points={{-19,-30},{0,-30},{0,18},{38,18}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(extent={{-100,-120},{120,100}},
          preserveAspectRatio=true),
                      graphics),
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
August 25, 2012 by Michael Wetter:<br>
First implementation. 
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-120},{120,100}})),
    experiment(
      StopTime=2400,
      Tolerance=1e-05,
      Algorithm="Radau"),
    __Dymola_experimentSetupOutput);
end EvaporationFlowReversal;
