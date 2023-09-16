within Buildings.Experimental.DHC.Plants.Steam;
model SingleBoiler "A generic steam plant with a single boiler that discharges 
  saturated steam"
  extends Buildings.Experimental.DHC.Plants.BaseClasses.PartialPlant(
    final typ=Buildings.Experimental.DHC.Types.DistrictSystemType.HeatingGeneration1,
    redeclare replaceable package MediumHea_b=Buildings.Media.Steam,
    final have_fan=false,
    final have_pum=true,
    final nFue=1,
    final fue={fueBoi},
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_weaBus=false);

  parameter Buildings.Fluid.Data.Fuels.Generic fueBoi=
    Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue()
    "Boiler fuel type"
     annotation (choicesAllMatching = true, Dialog(enable=have_fue));

  // Nominal values
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.Power Q_flow_nominal=m_flow_nominal*(
      MediumHea_b.specificEnthalpy(MediumHea_b.setState_pTX(
        p=pSteSet,
        T=TSat,
        X=MediumHea_b.X_default)) -
      Medium.specificEnthalpy(Medium.setState_pTX(
        p=pSteSet,
        T=TSat,
        X=Medium.X_default)))
    "Nominal heating power";

  // Setpoints
  parameter Modelica.Units.SI.AbsolutePressure pSteSet=300000
    "Steam pressure setpoint";
  final parameter Modelica.Units.SI.Temperature TSat=
    MediumHea_b.saturationTemperature(pSteSet)
    "Saturation temperature at pressure setpoint";
  parameter Modelica.Units.SI.AbsolutePressure pTanFW=101325
    "Pressure of feedwater tank";
  parameter Modelica.Units.SI.Volume VBoiWatSet=VBoi/2
    "Setpoint for liquid water volume in the boiler";

  // System sizing
  parameter Modelica.Units.SI.Volume VBoi=3
    "Total drum volume of steam boiler";
  parameter Real boiSca = 1.25 "Boiler heat capacity scaling factor";
  parameter Modelica.Units.SI.Mass mDry = 1.5E-3*Q_flow_nominal
    "Mass of boiler that will be lumped to water heat capacity"
    annotation(Dialog(tab = "Dynamics",
      enable = not (energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow=(m_flow_nominal/1000)*{0.4,0.6,0.8,1.0},
      dp=(pSteSet-pTanFW)*{1.34,1.27,1.17,1.0}))
    "Performance data for the feedwater pump";

  // Initial conditions
  parameter Modelica.Units.SI.Volume VTanFW_start=1
    "Setpoint for liquid water volume in the boiler"
    annotation(Dialog(tab = "Initialization"));
  parameter Modelica.Media.Interfaces.Types.AbsolutePressure pBoi_start=pTanFW
    "Start value of boiler pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Real yPum_start=0.7 "Initial value of pump speed"
    annotation(Dialog(tab="Initialization"));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));

  // Boiler controller
  parameter Modelica.Blocks.Types.SimpleController controllerTypeBoi=
    Modelica.Blocks.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Control", group="Boiler"));
  parameter Real kBoi(min=0) = 10 "Gain of controller"
    annotation (Dialog(tab="Control", group="Boiler"));
  parameter Modelica.Units.SI.Time TiBoi(min=Modelica.Constants.small)=120
    "Time constant of Integrator block"
     annotation (Dialog(enable=
          controllerTypeBoi == Modelica.Blocks.Types.SimpleController.PI or
          controllerTypeBoi == Modelica.Blocks.Types.SimpleController.PID,
          tab="Control", group="Boiler"));
  parameter Modelica.Units.SI.Time TdBoi(min=0)=10
    "Time constant of Derivative block" annotation (Dialog(enable=
          controllerTypeBoi == Modelica.Blocks.Types.SimpleController.PD or
          controllerTypeBoi == Modelica.Blocks.Types.SimpleController.PID,
          tab="Control", group="Boiler"));
  parameter Real wpBoi(min=0) = 1 "Set-point weight for Proportional block (0..1)"
    annotation (Dialog(tab="Control", group="Boiler"));
  parameter Real wdBoi(min=0) = 0 "Set-point weight for Derivative block (0..1)"
    annotation(Dialog(enable=
      controllerTypeBoi==.Modelica.Blocks.Types.SimpleController.PD or
      controllerTypeBoi==.Modelica.Blocks.Types.SimpleController.PID,
      tab="Control", group="Boiler"));
  parameter Real NiBoi(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(enable=
       controllerTypeBoi==.Modelica.Blocks.Types.SimpleController.PI or
       controllerTypeBoi==.Modelica.Blocks.Types.SimpleController.PID,
       tab="Control", group="Boiler"));
  parameter Real NdBoi(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
    annotation(Dialog(enable=
      controllerTypeBoi==.Modelica.Blocks.Types.SimpleController.PD or
      controllerTypeBoi==.Modelica.Blocks.Types.SimpleController.PID,
      tab="Control", group="Boiler"));

  // Feedwater pump controller
  parameter Modelica.Blocks.Types.SimpleController controllerTypePum=
    Modelica.Blocks.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(tab="Control", group="Pump"));
  parameter Real kPum(min=0) = 5 "Gain of controller"
    annotation (Dialog(tab="Control", group="Pump"));
  parameter Modelica.Units.SI.Time TiPum(min=Modelica.Constants.small)=120
    "Time constant of Integrator block"
    annotation (Dialog(enable=
      controllerTypePum == Modelica.Blocks.Types.SimpleController.PI or
      controllerTypePum == Modelica.Blocks.Types.SimpleController.PID,
      tab="Control", group="Pump"));
  parameter Modelica.Units.SI.Time TdPum(min=0)=0.1
    "Time constant of Derivative block"
    annotation (Dialog(enable=
      controllerTypePum == Modelica.Blocks.Types.SimpleController.PD or
      controllerTypePum == Modelica.Blocks.Types.SimpleController.PID,
      tab="Control", group="Pump"));
  parameter Real wpPum(min=0) = 1 "Set-point weight for Proportional block (0..1)"
    annotation (Dialog(tab="Control", group="Pump"));
  parameter Real wdPum(min=0) = 0 "Set-point weight for Derivative block (0..1)"
    annotation(Dialog(enable=
      controllerTypePum==.Modelica.Blocks.Types.SimpleController.PD or
      controllerTypePum==.Modelica.Blocks.Types.SimpleController.PID,
      tab="Control", group="Pump"));
  parameter Real NiPum(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(enable=
       controllerTypePum==.Modelica.Blocks.Types.SimpleController.PI or
       controllerTypePum==.Modelica.Blocks.Types.SimpleController.PID,
       tab="Control", group="Pump"));
  parameter Real NdPum(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
    annotation(Dialog(enable=
      controllerTypePum==.Modelica.Blocks.Types.SimpleController.PD or
      controllerTypePum==.Modelica.Blocks.Types.SimpleController.PID,
      tab="Control", group="Pump"));

  // Pump can have reverse flow at start up
  Buildings.Fluid.Movers.SpeedControlled_y pumFW(
    redeclare final package Medium = Medium,
    final energyDynamics=energyDynamics,
    p_start=pTanFW,
    final allowFlowReversal=allowFlowReversal,
    final per=per,
    final y_start=yPum_start)
    "Feedwater pump"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  // At start up, water leaves port_a, see Buildings.Experimental.DHC.Examples.Steam.SingleBoiler
  Buildings.Experimental.DHC.Plants.Steam.BaseClasses.BoilerPolynomial boi(
    redeclare final package MediumSte = MediumHea_b,
    redeclare final package MediumWat = Medium,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final allowFlowReversal=allowFlowReversal,
    final p_start=pTanFW,
    fixed_p_start=true,
    final fue=fueBoi,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=3000,
    final Q_flow_nominal=Q_flow_nominal*boiSca,
    final V=VBoi,
    final mDry=mDry)
    "Steam boiler"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.Continuous.LimPID conPum(
    final controllerType=controllerTypePum,
    final k=kPum,
    final Ti=TiPum,
    final Td=TdPum,
    final wp=wpPum,
    final wd=wdPum,
    final Ni=NiPum,
    final Nd=NdPum,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    y_start=yPum_start)
    "Pump control"
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Modelica.Blocks.Math.Gain VNor(final k=1/VBoiWatSet)
    "Normalized volume setpoint"
    annotation (Placement(transformation(extent={{160,60},{140,80}})));
  Buildings.Controls.Continuous.LimPID conBoi(
    final controllerType=controllerTypeBoi,
    final k=kBoi,
    final Ti=TiBoi,
    final Td=TdBoi,
    final wp=wpBoi,
    final wd=wdBoi,
    final Ni=NiBoi,
    final Nd=NdBoi)
    "Boiler control"
    annotation (Placement(transformation(extent={{80,-82},{100,-62}})));
  Modelica.Blocks.Math.Gain PNor(final k=1/pSteSet)
    "Normalized pressure setpoint"
    annotation (Placement(transformation(extent={{160,-100},{140,-80}})));
  Buildings.Fluid.Sensors.Pressure senPreSte(
    redeclare final package Medium = MediumHea_b)
    "Steam pressure sensor"
    annotation (Placement(transformation(extent={{220,-80},{200,-100}})));
  Modelica.Blocks.Sources.Constant uni(final k=1) "Unitary"
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  Buildings.Fluid.Storage.ExpansionVessel tanFW(
    redeclare final package Medium = Medium,
    final V_start=VTanFW_start,
    final p_start=pTanFW)
    "Feedwater tank"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.FixedResistances.CheckValve cheVal(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    dpValve_nominal=6000,
    rhoStd=Medium.density_pTX(
        pSteSet,
        MediumHea_b.saturationTemperature(pSteSet),
        Medium.X_default))
    "Check valve"
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));
equation
  connect(port_aSerHea, pumFW.port_a)
    annotation (Line(points={{-300,0},{-40,0}}, color={0,127,255}));
  connect(boi.port_b, port_bSerHea)
    annotation (Line(points={{160,0},{300,0}}, color={0,127,255}));
  connect(conPum.y, pumFW.y)
    annotation (Line(points={{-59,110},{-30,110},{-30,12}},
                                                          color={0,0,127}));
  connect(uni.y, conPum.u_s)
    annotation (Line(points={{-159,110},{-82,110}},
                                                  color={0,0,127}));
  connect(VNor.y, conPum.u_m)
    annotation (Line(points={{139,70},{-70,70},{-70,98}}, color={0,0,127}));
  connect(boi.VLiq, VNor.u)
    annotation (Line(points={{161,6},{180,6},{180,70},{162,70}},
      color={0,0,127}));
  connect(senPreSte.port, boi.port_b)
    annotation (Line(points={{210,-80},{210,0},{160,0}}, color={0,127,255}));
  connect(senPreSte.p, PNor.u)
    annotation (Line(points={{199,-90},{162,-90}}, color={0,0,127}));
  connect(PNor.y, conBoi.u_m)
    annotation (Line(points={{139,-90},{90,-90},{90,-84}}, color={0,0,127}));
  connect(conBoi.y, boi.y)
    annotation (Line(points={{101,-72},{120,-72},{120,8},{138,8}},
      color={0,0,127}));
  connect(uni.y, conBoi.u_s)
    annotation (Line(points={{-159,110},{-150,110},{-150,-72},{78,-72}},
      color={0,0,127}));
  connect(QFue_flow, boi.QFueFlo)
    annotation (Line(points={{320,120},{200,120},{200,9},{161,9}},
      color={0,0,127}));
  connect(PPum, pumFW.P)
    annotation (Line(points={{320,160},{0,160},{0,9},{-19,9}},
      color={0,0,127}));
  connect(tanFW.port_a, pumFW.port_a)
    annotation (Line(points={{-70,20},{-70,0},{-40,0}}, color={0,127,255}));
  connect(pumFW.port_b, cheVal.port_a)
    annotation (Line(points={{-20,0},{38,0}}, color={0,127,255}));
  connect(cheVal.port_b, boi.port_a)
    annotation (Line(points={{58,0},{140,0},{140,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)),
    defaultComponentName="pla",
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a generic steam plant model that can be used in 
district heating system simulations. The model contains a 
feedwater tank, feedwater pump, check valve, and a boiler. 
The boiler is designed to discharge saturated steam vapor. 
For controls, the feedwater pump maintains the water volume 
setpoint in the drum boiler, while the boiler control 
maintains the discharge pressure setpoint. 
</p>
<h4>References </h4>
<p>
Kathryn Hinkelman, Saranya Anbarasu, Michael Wetter, Antoine Gautier, Wangda Zuo. 2022. 
&ldquo;A Fast and Accurate Modeling Approach for Water and Steam 
Thermodynamics with Practical Applications in District Heating System Simulation,&rdquo; 
<i>Energy</i>, 254(A), pp. 124227.
<a href=\"https://doi.org/10.1016/j.energy.2022.124227\">10.1016/j.energy.2022.124227</a>
</p>
<p>
Kathryn Hinkelman, Saranya Anbarasu, Michael Wetter, Antoine Gautier, Baptiste Ravache, Wangda Zuo 2022. 
&ldquo;Towards Open-Source Modelica Models For Steam-Based District Heating Systems.&rdquo; 
<i>Proc. of the 1st International Workshop On Open Source Modelling And Simulation Of 
Energy Systems (OSMSES 2022)</i>, Aachen, German, April 4-5, 2022.
<a href=\"https://doi.org/10.1109/OSMSES54027.2022.9769121\">10.1109/OSMSES54027.2022.9769121</a>
</p>
</html>", revisions="<html>
<ul>
<li>
September 15, 2023, by Kathryn Hinkelman:<br/>
Added publication references.
</li>
<li>
July 18, 2023, by Michael Wetter:<br/>
Corrected assignment of <code>allowFlowReversal</code>, and set start pressure
of boiler to be equal to start pressure of feed water tank. Otherwise, backflow
occurs at the start of the simulation.
</li>
<li>
March 3, 2022 by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleBoiler;
