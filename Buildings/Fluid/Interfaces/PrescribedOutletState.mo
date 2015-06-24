within Buildings.Fluid.Interfaces;
model PrescribedOutletState
  "Component that assigns the outlet fluid property at port_a based on an input signal"
  extends Buildings.Fluid.Interfaces.PartialTwoPortTransport(
    final dp_start=0,
    show_T=false,
    show_V_flow=false);
  extends Buildings.Fluid.Interfaces.PrescribedOutletStateParameters(
    T_start=Medium.T_default);

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC")
    "Set point temperature of the fluid that leaves port_b"
    annotation (Placement(transformation(origin={-120,80},
              extent={{20,-20},{-20,20}},rotation=180)));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat added to the fluid (if flow is from port_a to port_b)"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(
        Medium.setState_pTX(
          p=Medium.p_default,
          T=Medium.T_default,
          X=Medium.X_default)) "Specific heat capacity at default medium state";

  parameter Boolean restrictHeat = Q_flow_maxHeat <> Modelica.Constants.inf
    "Flag, true if maximum heating power is restricted";
  parameter Boolean restrictCool = Q_flow_maxCool <> -Modelica.Constants.inf
    "Flag, true if maximum cooling power is restricted";

  parameter Modelica.SIunits.SpecificEnthalpy deltah=
    cp_default*m_flow_small*0.01
    "Small value for deltah used for regularization";

  final parameter Boolean dynamic = tau > 1E-10 or tau < -1E-10
    "Flag, true if the sensor is a dynamic sensor";

  Modelica.SIunits.MassFlowRate m_flow_pos
    "Mass flow rate, or zero if reverse flow";

  Modelica.SIunits.MassFlowRate m_flow_limited
    "Mass flow rate bounded away from zero";

  Modelica.SIunits.SpecificEnthalpy hSet
    "Set point for enthalpy leaving port_b";

  Modelica.SIunits.Temperature T
    "Temperature of outlet state assuming unlimited capacity and taking dynamics into account";

  Modelica.SIunits.SpecificEnthalpy dhSetAct
    "Actual enthalpy difference from port_a to port_b";

  Real k(start=1)
    "Gain to take flow rate into account for sensor time constant";

  Real mNor_flow "Normalized mass flow rate";

initial equation
  if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
      der(T) = 0;
  elseif energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
      T = T_start;
  end if;

  if energyDynamics <>  Modelica.Fluid.Types.Dynamics.SteadyState then
    assert(tau > 1E-5, "Time constant tau is unreasonably small for dynamic balance. Check model parameters.");
  end if;
equation
  if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState then
    mNor_flow = 1;
    k = 1;
    T=TSet;
  else
    mNor_flow = port_a.m_flow/m_flow_nominal;
    k = Modelica.Fluid.Utilities.regStep(x=port_a.m_flow,
                                         y1= mNor_flow,
                                         y2=-mNor_flow,
                                         x_small=m_flow_small);
    der(T) = (TSet-T)*k/tau;
  end if;

  // Set point for outlet enthalpy without any capacity limitation
  hSet = Medium.specificEnthalpy(
    Medium.setState_pTX(
      p=  port_a.p,
      T=  T,
      X=  inStream(port_a.Xi_outflow)));

  m_flow_pos = Buildings.Utilities.Math.Functions.smoothMax(
    x1=m_flow,
    x2=0,
    deltaX=m_flow_small);
  // Compute how much dH may need to be reduced.
  if not restrictHeat and not restrictCool then
    // No capacity limit
    dhSetAct = 0;
    port_b.h_outflow = hSet;
    m_flow_limited = 0;
    Q_flow = m_flow_pos*(hSet-inStream(port_a.h_outflow));
  else

    m_flow_limited = Buildings.Utilities.Math.Functions.smoothMax(
      x1=  port_a.m_flow,
      x2=  m_flow_small,
      deltaX=m_flow_small/2);

    if restrictHeat and restrictCool then
      // Capacity limits for heating and cooling
      dhSetAct = Buildings.Utilities.Math.Functions.smoothLimit(
        x=hSet-inStream(port_a.h_outflow),
        l=Q_flow_maxCool / m_flow_limited,
        u=Q_flow_maxHeat / m_flow_limited,
        deltaX=deltah);
    elseif restrictHeat then
      // Capacity limit for heating only
      dhSetAct = Buildings.Utilities.Math.Functions.smoothMin(
        x1=hSet-inStream(port_a.h_outflow),
        x2=Q_flow_maxHeat / m_flow_limited,
        deltaX=deltah);
    else
      // Capacity limit for cooling only
      dhSetAct = Buildings.Utilities.Math.Functions.smoothMax(
        x1=hSet-inStream(port_a.h_outflow),
        x2=Q_flow_maxCool / m_flow_limited,
        deltaX=deltah);
    end if;

    port_b.h_outflow = inStream(port_a.h_outflow) + dhSetAct;
    Q_flow = m_flow_pos*dhSetAct;

  end if;

  // Outflowing property at port_a is unaffected by this model.
  port_a.h_outflow = inStream(port_b.h_outflow);

  // No pressure drop
  dp = 0;

    annotation (
  defaultComponentName="heaCoo",
  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                      graphics={
        Rectangle(
          extent={{-68,70},{74,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-99,6},{102,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{2,-4},{102,6}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,92},{-78,70}},
          lineColor={0,0,127},
          textString="T"),
        Text(
          extent={{48,102},{92,74}},
          lineColor={0,0,127},
          textString="Q_flow")}),
  Documentation(info="<html>
<p>
This model sets the temperature of the medium that leaves <code>port_a</code>
to the value given by the input <code>TSet</code>, subject to optional
limitations on the heating and cooling capacity.
</p>
<p>
In case of reverse flow, the set point temperature is still applied to
the fluid that leaves <code>port_b</code>.
</p>
<p>
If the parameter <code>energyDynamics</code> is not equal to
<code>Modelica.Fluid.Types.Dynamics.SteadyState</code>,
the component models the dynamic response using a first order differential equation.
The time constant of the component is equal to the parameter <code>tau</code>.
This time constant is adjusted based on the mass flow rate using
</p>
<p align=\"center\" style=\"font-style:italic;\">
&tau;<sub>eff</sub> = &tau; |m&#775;| &frasl; m&#775;<sub>nom</sub>
</p>
<p>
where
<i>&tau;<sub>eff</sub></i> is the effective time constant for the given mass flow rate
<i>m&#775;</i> and
<i>&tau;</i> is the time constant at the nominal mass flow rate
<i>m&#775;<sub>nom</sub></i>.
This type of dynamics is equal to the dynamics that a completely mixed
control volume would have.
</p>
<p>
This model has no pressure drop.
See <a href=\"modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_T\">
Buildings.Fluid.HeatExchangers.HeaterCooler_T</a>
for a model that instantiates this model and that has a pressure drop.
</p>
</html>", revisions="<html>
<ul>
<li>
November 10, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PrescribedOutletState;
