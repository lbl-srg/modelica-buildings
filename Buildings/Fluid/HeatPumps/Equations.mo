within Buildings.Fluid.HeatPumps;
block Equations
  extends Modelica.Blocks.Interfaces.BlockIcon;

extends Buildings.Fluid.Interfaces.FourPortHeatMassExchanger(
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
   T1_start = 273.15+25,
   T2_start = 273.15+5,
   m1_flow_nominal= mCon_flow_nominal,
   m2_flow_nominal= mEva_flow_nominal,
    redeclare Buildings.Fluid.MixingVolumes.MixingVolume vol2(
      V=m2_flow_nominal*tau2/rho2_nominal,
      energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
      nPorts=4,
    final prescribedHeatFlowRate=true),
    vol1(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      V=m1_flow_nominal*tau1/rho1_nominal,
      nPorts=4,
    final prescribedHeatFlowRate=true));


  final parameter Modelica.SIunits.HeatFlowRate   QCon_heatflow_nominal=per.QCon_heatflow_nominal
  "Heating load nominal capacity_Heating mode";
  final parameter Modelica.SIunits.HeatFlowRate   QEva_heatflow_nominal=per.QEva_heatflow_nominal
  "Cooling load nominal capacity_Cooling mode";
  final parameter Modelica.SIunits.VolumeFlowRate VCon_flow_nominal=per.VCon_nominal
  "Heating mode Condenser volume flow rate nominal capacity";
  final parameter Modelica.SIunits.MassFlowRate   mCon_flow_nominal= per.mCon_flow_nominal
  "Heating mode Condenser mass flow rate nominal capacity";
  final parameter Modelica.SIunits.VolumeFlowRate VEva_flow_nominal=per.VEva_nominal
  "Heating mode Condenser volume flow rate nominal capacity";
  final parameter Modelica.SIunits.MassFlowRate   mEva_flow_nominal=per.mEva_flow_nominal
  "Heating mode Evaporator mass flow rate nominal capacity";
  final parameter Modelica.SIunits.Power          PCon_nominal_HD= per.PCon_nominal_HD
  "Heating mode Compressor Power nominal capacity";
  final parameter Modelica.SIunits.Power          PEva_nominal_CD = per.PEva_nominal_CD
  "Heating mode Compressor Power nominal capacity";
  final parameter Modelica.SIunits.Temperature    TRef= per.TRef;
  final parameter Modelica.SIunits.HeatFlowRate   Q_flow_small = QCon_heatflow_nominal*1E-9
    "Small value for heat flow rate or power, used to avoid division by zero";
  parameter Buildings.Fluid.HeatPumps.Data.EquationFitWaterToWater.Generic_EquationFit
    per annotation (choicesAllMatching=true, Placement(transformation(extent={{48,100},{80,132}})));


  Modelica.Blocks.Sources.RealExpression QEva_flow_in( final y=QEva_flow)
  "Evaorator heat flow rate"
    annotation (Placement(transformation(extent={{-78,-30},{-58,-10}})));

  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
  "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-65,24},{-45,44}})));

  HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
  "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-39,-30},{-19,-10}})));





 Modelica.Blocks.Interfaces.RealInput TEvaSet(final unit="K", displayUnit="degC")
    "Set point for leaving chilled water temperature" annotation (Placement(
        transformation(extent={{-260,-100},{-220,-60}}), iconTransformation(
          extent={{-260,-100},{-220,-60}})));
  Modelica.Blocks.Interfaces.RealInput TConSet(final unit="K", displayUnit="degC")
    "Set point for leaving heating water temperature" annotation (Placement(
        transformation(extent={{-260,140},{-220,180}}),iconTransformation(
          extent={{-260,140},{-220,180}})));


  Modelica.SIunits.Efficiency HLR
    "Heating load ratio";
  Modelica.SIunits.Efficiency CLR
    "Cooling load ratio";
  Modelica.SIunits.Efficiency P_HD
    "Power Ratio in heating dominanat mode";
  Modelica.SIunits.Efficiency P_CD
    "Power Ratio in cooling dominant mode";
  /*
  Modelica.SIunits.HeatFlowRate  QCon_flow
  "Condenser heatflow input";
  Modelica.SIunits.HeatFlowRate  QEva_flow
  "Evaporator heatflow input";
*/

  Modelica.SIunits.Power         P
  "HeatPump Compressor Power";

  /*
  Modelica.SIunits.HeatFlowRate QCon_flow_ava
  "Heating capacity available at the condender";
  Modelica.SIunits.HeatFlowRate QEva_flow_ava
  "Cooling capacity available at the Evaporator";
  */



  Modelica.SIunits.SpecificEnthalpy hSet_Con
  "Enthalpy setpoint for heating water";
  Modelica.SIunits.SpecificEnthalpy hSet_Eva
  "Enthalpy setpoint for cooling water";


  Modelica.SIunits.HeatFlowRate QCon_flow_set
  "Heating capacity required to heat to set point temperature";
  Modelica.SIunits.HeatFlowRate QEva_flow_set
  "Cooling capacity required to cool to set point temperature";

 /*
  
    Modelica.SIunits.HeatFlowRate QCon_flow_internal(start=QCon_flow_nominal)=
    P - QEva_flow_internal "Condenser heat input";
  Modelica.SIunits.HeatFlowRate QEva_flow_internal(start=QEva_flow_nominal)=
    if COP_is_for_cooling then -COP * P else (1-COP)*P "Evaporator heat input";
  */


Buildings.Fluid.Sensors.TemperatureTwoPort TEvaEnt(
    redeclare package Medium = Medium2,
    m_flow_nominal=m2_flow_nominal,
    allowFlowReversal=false,
    tau=0) "Evaporator entering water temperature"
    annotation (Placement(transformation(extent={{56,-90},{36,-70}})));

Buildings.Fluid.Sensors.TemperatureTwoPort TConEnt(
    redeclare package Medium = Medium1,
    m_flow_nominal=m2_flow_nominal,
    allowFlowReversal=false,
    tau=0) "Condenser entering water temperature"
    annotation (Placement(transformation(extent={{-46,70},{-26,90}})));



  Modelica.Fluid.Sensors.SpecificEnthalpyTwoPort hCon "Enthalpy value for heating water" annotation (Placement(transformation(extent={{50,50},{70,70}})));
  Modelica.Fluid.Sensors.SpecificEnthalpyTwoPort hEva "Enthalpy value for cooling water" annotation (Placement(transformation(extent={{-30,-70},{-50,-50}})));

  Modelica.Blocks.Interfaces.RealOutput QEva annotation (Placement(transformation(extent={{106,-8},{126,12}})));


  Modelica.Blocks.Sources.RealExpression QCon_flow_Set(final y=QCon_flow_set) "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{-52,144},{-32,164}})));
  Sensors.MassFlowRate m1_flow(redeclare package Medium = Medium, m1_flow=m1_flow) "Mass flow rate sensor" annotation (Placement(transformation(extent={{-26,70},{-6,90}})));
  Modelica.Blocks.Sources.RealExpression QCon_flow_ava(final y=QCon_flow_ava) "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{-52,116},{-32,136}})));










  Modelica.Blocks.Interfaces.IntegerInput uMod "Heating mode= 1, Off=0, Cooling mode=-1" annotation (Placement(transformation(extent={{-260,20},{-220,60}})));
  Modelica.Blocks.Sources.RealExpression hCon_flow_Set(final y=Medium1.specificEnthalpy_pTX(
        p=port_b1.p,
        T=TConSet,
        X=cat(
          1,
          port_b1.Xi_outflow,
          {1 - sum(port_b1.Xi_outflow)}))) "Condenser heat flow rate" annotation (Placement(transformation(extent={{-146,188},{-126,208}})));
  equationfitCalequationsection equationfitCalequationsection1
    annotation (Placement(transformation(extent={{-168,20},{-148,40}})));
equation
  connect(vol2.ports[3], TEvaEnt.port_a) annotation (Line(points={{2,-70},{2,-80},{56,-80}}, color={0,127,255}));
  connect(preDro1.port_b, TConEnt.port_a) annotation (Line(points={{-60,80},{
          -46,80}},                                                                    color={0,127,255}));
  connect(vol1.ports[3], TConEnt.port_b) annotation (Line(points={{0,70},{0,80},
          {-26,80}},                                                                       color={0,127,255}));


  connect(preHeaFloCon.port,vol1.heatPort)
  annotation (Line(points={{-45,34},{-12,34},{-12,60},{-10,60}}, color={191,0,0}));

  connect(QEva_flow_in.y, preHeaFloEva.Q_flow)
    annotation (Line(points={{-57,-20},{-39,-20}},                     color={0,0,127}));
  connect(preHeaFloEva.port, vol2.heatPort)
  annotation (Line(points={{-19,-20},{24,-20},{24,-60},{12,-60}}, color={191,0,0}));


  connect(preDro2.port_b, TEvaEnt.port_a) annotation (Line(points={{60,-80},{56,-80}}, color={0,127,255}));
  connect(port_b1, hCon.port_b) annotation (Line(points={{100,60},{70,60}}, color={0,127,255}));
  connect(vol1.ports[4], hCon.port_a) annotation (Line(points={{0,70},{20,70},{20,60},{50,60}}, color={0,127,255}));
  connect(vol2.ports[4], hEva.port_a) annotation (Line(points={{2,-70},{-30,-70},{-30,-60}}, color={0,127,255}));
  connect(QEva_flow_in.y, QEva) annotation (Line(points={{-57,-20},{-48,-20},{-48,2},{116,2}}, color={0,0,127}));
      annotation (Placement(transformation(extent={{40,50},{60,70}})),
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                                                 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-220,-120},{100,240}})));
end Equations;
