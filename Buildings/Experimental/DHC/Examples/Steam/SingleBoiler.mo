within Buildings.Experimental.DHC.Examples.Steam;
model SingleBoiler "Example model for a complete steam district heating system with a 
  central plant that contains a single boiler"
  extends Modelica.Icons.Example;

  package MediumSte = Buildings.Media.Steam (p_default=400000,
    T_default=273.15+143.61,
    h_default=2738100)
    "Steam medium";
  package MediumWat =
    Buildings.Media.Specialized.Water.TemperatureDependentDensity (
      p_default=101325,
      T_default=100+273.15,
      h_default=2738100)
    "Water medium";

  parameter Modelica.Units.SI.AbsolutePressure pSat=400000
    "Saturation pressure, high pressure";
  parameter Modelica.Units.SI.AbsolutePressure pLow=200000
    "Reduced pressure, after PRV";
  parameter Modelica.Units.SI.Temperature TSat=
     MediumSte.saturationTemperature(pSat)
     "Saturation temperature, at high pressure";

  parameter Integer N = 3 "Number of buildings";
  parameter Modelica.Units.SI.MassFlowRate mDis_flow_nominal=sum(bld.m_flow_nominal)
    "Nominal mass flow rate of entire district";
  parameter Modelica.Units.SI.HeatFlowRate QDis_flow_nominal=QBui_flow_nominal*N
    "Nominal heat flow rate of entire district";
  parameter Modelica.Units.SI.HeatFlowRate QBui_flow_nominal=20000
    "Nominal heat flow rate of each building";
  parameter Modelica.Units.SI.PressureDifference dpPip=6000
    "Pressure drop in the condensate return pipe";

  parameter Buildings.Fluid.Movers.Data.Generic perPumFW(
   pressure(V_flow=mDis_flow_nominal*1000*{0,1,2},
     dp=(pSat-101325)*{2,1,0}))
    "Performance data for feedwater pump at the plant";

  parameter Modelica.Units.SI.PressureDifference dp_nominal=6000
    "Pressure drop of distribution at nominal mass flow rate";

  Buildings.Experimental.DHC.Loads.Steam.BuildingTimeSeriesAtETS bld[N](
    redeclare final package MediumSte = MediumSte,
    redeclare final package MediumWat = MediumWat,
    each have_prv=true,
    each dp_nominal=dpPip/2,
    each final pSte_nominal=pSat,
    each final Q_flow_nominal=QBui_flow_nominal,
    each pLow_nominal=pLow,
    each energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    each tableOnFile=false,
    each QHeaLoa=
      [0,0.8; 2,1; 10,1; 12,0.5; 20,0.5; 24,0.8]*[1,0;0,QBui_flow_nominal],
    each smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1,
    each timeScale(displayUnit="s") = 3600,
    each show_T=true)
    "Buildings"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));
  Buildings.Experimental.DHC.Networks.Steam.DistributionCondensatePipe dis(
    redeclare final package MediumSup = MediumSte,
    redeclare final package MediumRet = MediumWat,
    final dp_nominal=dp_nominal,
    final nCon=N,
    final mDis_flow_nominal=mDis_flow_nominal,
    final mCon_flow_nominal=bld.m_flow_nominal)
    "Distribution network"
    annotation (Placement(transformation(extent={{0,-20},{40,0}})));
  Buildings.Experimental.DHC.Plants.Steam.SingleBoiler pla(
    redeclare final package Medium = MediumWat,
    redeclare final package MediumHea_b = MediumSte,
    final m_flow_nominal=mDis_flow_nominal,
    final pSteSet=pSat,
    final Q_flow_nominal=QDis_flow_nominal,
    final per=perPumFW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    kBoi=600,
    TiBoi(displayUnit="min") = 120,
    kPum=200,
    TiPum=1000)
    "Plant"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
equation
  connect(dis.ports_bCon, bld.port_a)
    annotation (Line(points={{8,0},{8,30},{40,30}},      color={0,127,255}));
  connect(bld.port_b, dis.ports_aCon)
    annotation (Line(points={{40,24},{32,24},{32,0}},  color={0,127,255}));
  connect(pla.port_bSerHea, dis.port_aDisSup)
    annotation (Line(points={{-30,30},{-20,30},{-20,-10},{0,-10}},
                                                 color={0,127,255}));
  connect(dis.port_bDisRet, pla.port_aSerHea) annotation (Line(points={{0,-16},{
          -60,-16},{-60,30},{-50,30}},                   color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
      __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Examples/Steam/SingleBoiler.mos"
    "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06),
    Documentation(revisions="<html>
<ul>
<li>
March 3, 2022 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This example model demonstrates a complete system simulation for 
steam district heating systems. The central plant features a single boiler.
For the distribution network, pressure losses on the condensate return 
pipes are included, while the steam pipes are assumed to be lossless.
</p>
</html>"));
end SingleBoiler;
