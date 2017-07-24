within Buildings.ChillerWSE.BaseClasses;
partial model PartialHeatExchanger "Partial model for heat exchangers "

  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
   final computeFlowResistance1=(dp1_nominal > Modelica.Constants.eps),
   final computeFlowResistance2=(dp2_nominal > Modelica.Constants.eps));
  extends Buildings.Fluid.Interfaces.LumpedVolumeDeclarations(
    final mSenFac=1,
    redeclare package Medium=Medium2);
  extends Buildings.ChillerWSE.BaseClasses.ThreeWayValveParameters;

  parameter Modelica.SIunits.Efficiency eta(min=0,max=1,start=0.8) "constant effectiveness";

   // Filter opening
  parameter Boolean use_inputFilter=true if use_Controller
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=use_Controller));
  parameter Modelica.SIunits.Time riseTime=120 if use_Controller
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=(use_Controller and use_inputFilter)));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput if
       use_Controller
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=(use_Controller and use_inputFilter)));
  parameter Real yBypVal_start=1 if use_Controller
    "Initial value of output from the filter in the bypass valve"
    annotation(Dialog(tab="Dynamics", group="Filtered opening",enable=(use_Controller and use_inputFilter)));

 // Time constant
   parameter Modelica.SIunits.Time tau_ThrWayVal=10 if use_Controller
    "Time constant at nominal flow for dynamic energy and momentum balance of the three-way valve"
    annotation(Dialog(tab="Dynamics", group="Nominal condition",
               enable=(use_Controller and not energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState)));

  // Advanced
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Modelica.SIunits.Density rhoStd = Medium2.density_pTX(101325, 273.15+4, Medium2.X_default) if
       use_Controller
    "Inlet density for which valve coefficients are defined"
  annotation(Dialog(group="Nominal condition", tab="Advanced",enable=use_Controller));

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K",displayUnit="degC") if use_Controller
  "Temperature setpoint for port_b2"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear   bypVal(
    redeclare package Medium = Medium2,
    final from_dp=from_dp2,
    final linearized={linearizeFlowResistance2,linearizeFlowResistance2},
    final rhoStd=rhoStd,
    final homotopyInitialization=homotopyInitialization,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final R=R,
    final delta0=delta0,
    final fraK=fraK_ThrWayVal,
    final dpFixed_nominal={dp2_nominal,0},
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final X_start=X_start,
    final y_start=yBypVal_start,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    final l=l_ThrWayVal,
    final dpValve_nominal=dp2_nominal,
    final deltaM=deltaM2,
    final m_flow_nominal=m2_flow_nominal,
    final portFlowDirection_1=portFlowDirection_1,
    final portFlowDirection_2=portFlowDirection_2,
    final portFlowDirection_3=portFlowDirection_3,
    final tau=tau_ThrWayVal) if use_Controller
    "Bypass valve used to control the outlet temperature "
    annotation (Placement(transformation(extent={{-40,-40},{-60,-20}})));

  Buildings.Fluid.HeatExchangers.ConstantEffectiveness hex(
    redeclare package Medium1 = Medium1,
    redeclare package Medium2 = Medium2,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final show_T=show_T,
    final from_dp1=from_dp1,
    final dp1_nominal=dp1_nominal,
    final linearizeFlowResistance1=linearizeFlowResistance1,
    final deltaM1=deltaM1,
    final from_dp2=from_dp2,
    final linearizeFlowResistance2=linearizeFlowResistance2,
    final deltaM2=deltaM2,
    final eps=eta,
    final homotopyInitialization=homotopyInitialization,
    final dp2_nominal=0)
    "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation

  connect(port_a1, hex.port_a1) annotation (Line(points={{-100,60},{-100,60},{-40,
          60},{-40,6},{-10,6}}, color={0,127,255}));
  connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{40,6},{40,60},{
          100,60}}, color={0,127,255}));
  connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{40,-6},{40,-60},
          {100,-60}}, color={0,127,255}));

  if use_Controller then
    connect(hex.port_b2, bypVal.port_1) annotation (Line(points={{-10,-6},{-28,-6},
            {-28,-30},{-40,-30}},
                                color={0,127,255}));
    connect(port_a2, bypVal.port_3) annotation (Line(points={{100,-60},{-50,-60},
            {-50,-40}},
                     color={0,127,255}));
    connect(bypVal.port_2, port_b2) annotation (Line(points={{-60,-30},{-60,-30},
            {-80,-30},{-80,-60},{-100,-60}},
                                          color={0,127,255}));
  else
connect(port_b2, hex.port_b2) annotation (Line(points={{-100,-60},{-80,-60},{-80,
          -60},{-80,-6},{-10,-6}}, color={0,127,255}));
  end if;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},
            {100,80}}), graphics={
        Ellipse(
          extent={{-80,40},{80,36}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-74,-22},{88,-28}},
          lineColor={0,127,255},
          lineThickness=1,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,80}})),
    __Dymola_Commands,
    Documentation(info="<html>
<p>
This module simulates a heat exchanger with a three-way bypass used to modulate water flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialHeatExchanger;
