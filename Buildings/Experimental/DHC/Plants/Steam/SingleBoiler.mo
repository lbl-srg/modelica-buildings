within Buildings.Experimental.DHC.Plants.Steam;
model SingleBoiler
  extends Buildings.Experimental.DHC.Plants.BaseClasses.PartialPlant(
    final typ=Buildings.Experimental.DHC.Types.DistrictSystemType.HeatingGeneration1,
    final have_fan=false,
    final have_pum=true,
    final have_fue=true,
    final have_eleHea=false,
    final have_eleCoo=false,
    final have_weaBus=false,
    redeclare replaceable package MediumHea_b=Buildings.Media.Steam);

  parameter Modelica.Units.SI.Volume VBoi=3
    "Total volume of boiler";
  parameter Modelica.Units.SI.Volume VBoiWatSet=VBoi/2
    "Setpoint for liquid water volume in the boiler";
  parameter Modelica.Units.SI.Volume VTanFW_start=1
    "Setpoint for liquid water volume in the boiler";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.AbsolutePressure pSteSet=300000
    "Steam pressure setpoint";
  parameter Modelica.Units.SI.Temperature TSat=
    MediumHea_b.saturationTemperature(pSteSet)
    "Saturation temperature at pressure setpoint";
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
  parameter Real boiSca = 1.25 "Boiler heat capacity scaling factor";
  // pump
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow=m_flow_nominal*1000*{0.4,0.6,0.8,1.0},
      dp=(pSteSet-101325)*{1.34,1.27,1.17,1.0}))
    "Performance data for pump";

// dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,Dialog(tab="Dynamics",group="Equations"));

  // Boiler controller
  parameter Modelica.Blocks.Types.SimpleController controllerTypeBoi=
         Modelica.Blocks.Types.SimpleController.PID "Type of controller";
  parameter Real kBoi(min=0) = 20 "Gain of controller";
  parameter Modelica.Units.SI.Time TiBoi(min=Modelica.Constants.small)=30
    "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time TdBoi(min=0)=10
    "Time constant of Derivative block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Real wpBoi(min=0) = 1 "Set-point weight for Proportional block (0..1)";
  parameter Real wdBoi(min=0) = 0 "Set-point weight for Derivative block (0..1)"
       annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real NiBoi(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PI or
                              controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real NdBoi(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
       annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Blocks.Types.Init initTypeBoi=
    Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
      annotation(Evaluate=true,
      Dialog(group="Initialization"));
  parameter Real yBoiCon_start=0.1 "Initial value of output"
    annotation(Dialog(enable=initTypeBoi == Modelica.Blocks.Types.InitPID.InitialOutput, group=
          "Initialization"));

    // Feedwater pump controller
  parameter Modelica.Blocks.Types.SimpleController controllerTypePum=
         Modelica.Blocks.Types.SimpleController.PI "Type of controller";
  parameter Real kPum(min=0) = 100 "Gain of controller";
  parameter Modelica.Units.SI.Time TiPum(min=Modelica.Constants.small)=120
    "Time constant of Integrator block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time TdPum(min=0)=0.1
    "Time constant of Derivative block" annotation (Dialog(enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Real wpPum(min=0) = 1 "Set-point weight for Proportional block (0..1)";
  parameter Real wdPum(min=0) = 0 "Set-point weight for Derivative block (0..1)"
       annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real NiPum(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
     annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PI or
                              controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Real NdPum(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
       annotation(Dialog(enable=controllerType==.Modelica.Blocks.Types.SimpleController.PD or
                                controllerType==.Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Blocks.Types.Init initTypePum=
    Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
      annotation(Evaluate=true,
      Dialog(group="Initialization"));
  parameter Real yPumCon_start=0.5 "Initial value of output"
    annotation(Dialog(enable=initTypePum == Modelica.Blocks.Types.InitPID.InitialOutput, group=
          "Initialization"));

  Buildings.Fluid.Movers.SpeedControlled_y pumFW(
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    redeclare package Medium = Medium,
    p_start=101325,
    T_start=293.15,
    per=per,
    y_start=0.8)
               "Feedwater pump"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Experimental.DHC.Plants.Steam.BaseClasses.BoilerPolynomial boi(
    energyDynamics=energyDynamics,
    massDynamics=massDynamics,
    redeclare package MediumSte = MediumHea_b,
    redeclare package MediumWat = Medium,
    allowFlowReversal=allowFlowReversal,
    p_start=pSteSet,
    T_start=TSat,
    fue=fue,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=3000,
    Q_flow_nominal=Q_flow_nominal*boiSca,
    V=VBoi,
    mDry=300000)
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.Continuous.LimPID conPum(
    controllerType=controllerTypePum,
    k=kPum,
    Ti=TiPum,
    Td=TdPum,
    wp=wpPum,
    wd=wdPum,
    Ni=NiPum,
    Nd=NdPum,
    initType=initTypePum,
    y_start=yPumCon_start)
                 "Pump control"
    annotation (Placement(transformation(extent={{-80,80},{-60,60}})));
  Modelica.Blocks.Math.Gain VNor(k=1/VBoiWatSet)
    "Normalized volume"
    annotation (Placement(transformation(extent={{160,80},{140,100}})));
  Buildings.Controls.Continuous.LimPID conBoi(
    controllerType=controllerTypeBoi,
    k=kBoi,
    Ti=TiBoi,
    Td=TdBoi,
    wp=wpBoi,
    wd=wdBoi,
    Ni=NiBoi,
    Nd=NdBoi,
    initType=initTypeBoi,
    y_start=yBoiCon_start)
           "Boiler control"
    annotation (Placement(transformation(extent={{80,-82},{100,-62}})));
  Modelica.Blocks.Math.Gain PNor(k=1/pSteSet) "Normalized pressure"
    annotation (Placement(transformation(extent={{160,-100},{140,-80}})));
  Buildings.Fluid.Sensors.Pressure senPSte(redeclare package Medium =
        MediumHea_b)
    "Steam pressure sensor"
    annotation (Placement(transformation(extent={{220,-80},{200,-100}})));
  Modelica.Blocks.Sources.Constant uni(k=1) "Unitary"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Buildings.Fluid.Storage.ExpansionVessel tanFW(
    redeclare package Medium = Medium,
    p_start=101325,
    T_start=293.15,
    V_start=VTanFW_start,
    p=101325) "Feedwater tank"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Fluid.FixedResistances.CheckValve cheVal(
    redeclare package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=6000,
    rhoStd=Medium.density_pTX(
        pSteSet,
        MediumHea_b.saturationTemperature(pSteSet),
        Medium.X_default))
    annotation (Placement(transformation(extent={{38,-10},{58,10}})));
equation
  connect(port_aSerHea, pumFW.port_a)
    annotation (Line(points={{-300,0},{-40,0}}, color={0,127,255}));
  connect(boi.port_b, port_bSerHea)
    annotation (Line(points={{160,0},{300,0}}, color={0,127,255}));
  connect(conPum.y, pumFW.y)
    annotation (Line(points={{-59,70},{-30,70},{-30,12}}, color={0,0,127}));
  connect(uni.y, conPum.u_s)
    annotation (Line(points={{-159,70},{-82,70}}, color={0,0,127}));
  connect(VNor.y, conPum.u_m)
    annotation (Line(points={{139,90},{-70,90},{-70,82}}, color={0,0,127}));
  connect(boi.VLiq, VNor.u) annotation (Line(points={{161,6},{180,6},{180,90},{162,
          90}}, color={0,0,127}));
  connect(senPSte.port, boi.port_b)
    annotation (Line(points={{210,-80},{210,0},{160,0}}, color={0,127,255}));
  connect(senPSte.p, PNor.u)
    annotation (Line(points={{199,-90},{162,-90}}, color={0,0,127}));
  connect(PNor.y, conBoi.u_m)
    annotation (Line(points={{139,-90},{90,-90},{90,-84}}, color={0,0,127}));
  connect(conBoi.y, boi.y) annotation (Line(points={{101,-72},{120,-72},{120,8},
          {138,8}}, color={0,0,127}));
  connect(uni.y, conBoi.u_s) annotation (Line(points={{-159,70},{-150,70},{-150,
          -72},{78,-72}}, color={0,0,127}));
  connect(QFue_flow, boi.QFueFlo) annotation (Line(points={{320,120},{200,
          120},{200,9},{161,9}}, color={0,0,127}));
  connect(PPum, pumFW.P) annotation (Line(points={{320,160},{0,160},{0,9},{-19,9}},
        color={0,0,127}));
  connect(tanFW.port_a, pumFW.port_a)
    annotation (Line(points={{-70,20},{-70,0},{-40,0}}, color={0,127,255}));
  connect(pumFW.port_b, cheVal.port_a)
    annotation (Line(points={{-20,0},{38,0}}, color={0,127,255}));
  connect(cheVal.port_b, boi.port_a)
    annotation (Line(points={{58,0},{140,0},{140,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SingleBoiler;
