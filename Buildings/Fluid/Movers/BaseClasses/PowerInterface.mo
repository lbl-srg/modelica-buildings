within Buildings.Fluid.Movers.BaseClasses;
partial model PowerInterface
  "Partial model to compute power draw and heat dissipation of fans and pumps"

  import Modelica.Constants;

  parameter Boolean use_powerCharacteristic = false
    "Use powerCharacteristic (vs. efficiencyCharacteristic)"
     annotation(Evaluate=true,Dialog(group="Characteristics"));

  parameter Boolean motorCooledByFluid = true
    "If true (and if addPowerToMedium = true), then motor heat is added to fluid stream"
    annotation(Dialog(group="Characteristics"));

  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  parameter Modelica.SIunits.Density rho_default
    "Fluid density at medium default state";

  Modelica.Blocks.Interfaces.RealOutput P(quantity="Modelica.SIunits.Power",
   unit="W") "Electrical power consumed"
  annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.SIunits.Power WHyd
    "Hydraulic power input (converted to flow work and heat)";
  Modelica.SIunits.Power WFlo "Flow work";
  Modelica.SIunits.HeatFlowRate Q_flow "Heat input from fan or pump to medium";
  Real eta(min=0, max=1) "Global efficiency";
  Real etaHyd(min=0, max=1) "Hydraulic efficiency";
  Real etaMot(min=0, max=1) "Motor efficiency";

  Modelica.SIunits.Pressure dpMachine(displayUnit="Pa") "Pressure increase";
  Modelica.SIunits.VolumeFlowRate VMachine_flow "Volume flow rate";
  //Modelica.SIunits.HeatFlowRate QThe_flow "Heat input into the medium";
protected
  parameter Data.FlowControlled _perPow
    "Record with performance data for power";

  parameter Modelica.SIunits.VolumeFlowRate delta_V_flow
    "Factor used for setting heat input into medium to zero at very small flows";
  final parameter Real motDer[size(_perPow.motorEfficiency.V_flow, 1)](each fixed=false)
    "Coefficients for polynomial of pressure vs. flow rate";
  final parameter Real hydDer[size(_perPow.hydraulicEfficiency.V_flow,1)](each fixed=false)
    "Coefficients for polynomial of pressure vs. flow rate";

  Modelica.SIunits.HeatFlowRate QThe_flow
    "Heat input from fan or pump to medium";

initial algorithm
 // Compute derivatives for cubic spline
 motDer :=
   if _perPow.use_powerCharacteristic then
     zeros(size(_perPow.motorEfficiency.V_flow, 1))
   elseif ( size(_perPow.motorEfficiency.V_flow, 1) == 1)  then
       {0}
   else
      Buildings.Utilities.Math.Functions.splineDerivatives(
      x=_perPow.motorEfficiency.V_flow,
      y=_perPow.motorEfficiency.eta,
      ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(x=_perPow.motorEfficiency.eta,
                                                                        strict=false));
  hydDer :=
     if _perPow.use_powerCharacteristic then
       zeros(size(_perPow.hydraulicEfficiency.V_flow, 1))
     elseif ( size(_perPow.hydraulicEfficiency.V_flow, 1) == 1)  then
       {0}
     else
       Buildings.Utilities.Math.Functions.splineDerivatives(
                   x=_perPow.hydraulicEfficiency.V_flow,
                   y=_perPow.hydraulicEfficiency.eta);

equation
  eta = etaHyd * etaMot;
  // Flow work
  WFlo = dpMachine*VMachine_flow;
  // Hydraulic power (transmitted by shaft), etaHyd = WFlo/WHyd
  etaHyd * WHyd   = WFlo;
  // Heat input into medium
  QThe_flow +  WFlo = if _perPow.motorCooledByFluid then P else WHyd;
  // At m_flow = 0, the solver may still obtain positive values for QThe_flow.
  // The next statement sets the heat input into the medium to zero for very small flow rates.
  if homotopyInitialization then
    Q_flow = homotopy(actual=Buildings.Utilities.Math.Functions.spliceFunction(pos=QThe_flow, neg=0,
                       x=noEvent(abs(VMachine_flow))-2*delta_V_flow, deltax=delta_V_flow),
                     simplified=0);
  else
    Q_flow = Buildings.Utilities.Math.Functions.spliceFunction(pos=QThe_flow, neg=0,
                       x=noEvent(abs(VMachine_flow))-2*delta_V_flow, deltax=delta_V_flow);
  end if;
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=true,  extent={{-100,-100},{100,
            100}}), graphics={
        Text(extent={{64,100},{114,86}},  textString="P",
          lineColor={0,0,127}),
        Line(
          points={{0,80},{100,80}},
          color={0,0,0},
          smooth=Smooth.None)}),
    Documentation(info="<html>
<p>This is an interface that implements the functions to compute the power draw and the
heat dissipation of fans and pumps. It is used by the model
<a href=\"modelica://Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface\">
Buildings.Fluid.Movers.BaseClasses.FlowMachineInterface</a>.
</p>
<h4>Implementation</h4>
<p>
Models that extend this model need to provide an implementation of
<code>WFlo = eta * P</code>.
This equation is not implemented in this model to allow other models
to properly guard against division by zero.
</p>
</html>",
      revisions="<html>
<ul>
<li>
January 6, 2015, by Michael Wetter:<br/>
Revised model for OpenModelica.
</li>
<li>
May 29, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
April 21, 2014, by Filip Jorisson and Michael Wetter:<br/>
Changed model to use
<a href=\"modelica://Buildings.Fluid.Movers.Data.Generic\">
Buildings.Fluid.Movers.Data.Generic</a>.
</li>
<li>
September 17, 2013, by Michael Wetter:<br/>
Added missing <code>each</code> keyword in declaration of parameters
that are an array.
</li>
<li>
December 14, 2012 by Michael Wetter:<br/>
Renamed protected parameters for consistency with the naming conventions.
</li>
<li><i>October 11, 2012</i> by Michael Wetter:<br/>
    Removed <code>WFlo = eta * P</code> so that classes that use this partial model
    can properly implement the equation so it guards against division by zero.
</li>
<li><i>March 1, 2010</i>
    by Michael Wetter:<br/>
    Revised implementation to allow <code>N=0</code>.
<li><i>October 1, 2009</i>
    by Michael Wetter:<br/>
    Changed model so that it is based on total pressure in Pascals instead of the pump head in meters.
    This change is needed if the device is used with air as a medium. The original formulation in Modelica.Fluid
    converts head to pressure using the density medium.d. Therefore, for fans, head would be converted to pressure
    using the density of air. However, for fans, manufacturers typically publish the head in
    millimeters water (mmH20). Therefore, to avoid confusion and to make this model applicable for any medium,
    the model has been changed to use total pressure in Pascals instead of head in meters.
</li>
<li><i>31 Oct 2005</i>
    by <a href=\"mailto:francesco.casella@polimi.it\">Francesco Casella</a>:<br/>
       Model added to the Fluid library</li>
</ul>
</html>"));
end PowerInterface;
