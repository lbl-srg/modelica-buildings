within Buildings.Fluid.Interfaces;
model PrescribedOutlet
  "Component that assigns the outlet fluid property at port_a based on an input signal"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

  parameter Modelica.SIunits.HeatFlowRate QMax_flow(min=0) = Modelica.Constants.inf
    "Maximum heat flow rate for heating (positive)"
    annotation (Evaluate=true, Dialog(enable=use_TSet));
  parameter Modelica.SIunits.HeatFlowRate QMin_flow(max=0) = -Modelica.Constants.inf
    "Maximum heat flow rate for cooling (negative)"
    annotation (Evaluate=true, Dialog(enable=use_TSet));
  parameter Modelica.SIunits.MassFlowRate mWatMax_flow(min=0) = Modelica.Constants.inf
    "Maximum water mass flow rate addition (positive)"
    annotation (Evaluate=true, Dialog(enable=use_X_wSet));

  parameter Modelica.SIunits.MassFlowRate mWatMin_flow(max=0) = -Modelica.Constants.inf
    "Maximum water mass flow rate removal (negative)"
    annotation (Evaluate=true, Dialog(enable=use_X_wSet));

  parameter Modelica.SIunits.Time tau(min=0) = 10
    "Time constant at nominal flow rate (used if energyDynamics or massDynamics not equal Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation(Dialog(tab = "Dynamics"));
  parameter Modelica.SIunits.Temperature T_start=Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", enable=use_TSet));
  parameter Modelica.SIunits.MassFraction X_start[Medium.nX] = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=use_X_wSet and Medium.nXi > 0));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations", enable=use_TSet));

  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations", enable=use_X_wSet));

  parameter Boolean use_TSet = true
    "Set to false to disable temperature set point"
    annotation(Evaluate=true);

  parameter Boolean use_X_wSet = true
    "Set to false to disable water vapor set point"
    annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput TSet(unit="K", displayUnit="degC") if use_TSet
    "Set point temperature of the fluid that leaves port_b"
    annotation (Placement(transformation(origin={-120,90},
              extent={{20,-20},{-20,20}},rotation=180), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,80})));

  Modelica.Blocks.Interfaces.RealInput X_wSet(unit="1") if use_X_wSet
    "Set point for water vapor mass fraction of the fluid that leaves port_b"
    annotation (Placement(transformation(origin={-120,50},
              extent={{20,-20},{-20,20}},rotation=180), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-110,40})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat flow rate added to the fluid (if flow is from port_a to port_b)"
    annotation (Placement(transformation(extent={{100,70},{120,90}})));

  Modelica.Blocks.Interfaces.RealOutput mWat_flow(unit="kg/s")
    "Water vapor mass flow rate added to the fluid (if flow is from port_a to port_b)"
    annotation (Placement(transformation(extent={{100,30},{120,50}})));

protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(
        Medium.setState_pTX(
          p=Medium.p_default,
          T=Medium.T_default,
          X=Medium.X_default)) "Specific heat capacity at default medium state";

  parameter Boolean restrictHeat = QMax_flow < Modelica.Constants.inf/10.0
    "Flag, true if maximum heating power is restricted"
    annotation(Evaluate = true);
  parameter Boolean restrictCool = QMin_flow > -Modelica.Constants.inf/10.0
    "Flag, true if maximum cooling power is restricted"
    annotation(Evaluate = true);

  parameter Boolean restrictHumi = mWatMax_flow < Modelica.Constants.inf/10.0
    "Flag, true if maximum humidification is restricted"
    annotation(Evaluate = true);
  parameter Boolean restrictDehu = mWatMin_flow > -Modelica.Constants.inf/10.0
    "Flag, true if maximum dehumidification is restricted"
    annotation(Evaluate = true);

  parameter Modelica.SIunits.SpecificEnthalpy deltaH=
    cp_default*1E-6
    "Small value for deltaH used for regularization";

  parameter Modelica.SIunits.MassFraction deltaXi = 1E-6
    "Small mass fraction used for regularization";

  Modelica.SIunits.MassFlowRate m_flow_pos
    "Mass flow rate, or zero if reverse flow";

  Modelica.SIunits.MassFlowRate m_flow_non_zero
    "Mass flow rate bounded away from zero";

  Modelica.SIunits.SpecificEnthalpy hSet
    "Set point for enthalpy leaving port_b";

  Modelica.SIunits.Temperature T
    "Temperature of outlet state assuming unlimited capacity and taking dynamics into account";

  Modelica.SIunits.MassFraction Xi
    "Water vapor mass fraction of outlet state assuming unlimited capacity and taking dynamics into account";

  Modelica.SIunits.MassFraction Xi_instream[Medium.nXi]
    "Instreaming water vapor mass fraction at port_a";

  Modelica.SIunits.MassFraction Xi_outflow
    "Outstreaming water vapor mass fraction at port_a";

  Modelica.SIunits.SpecificEnthalpy dhAct
    "Actual enthalpy difference from port_a to port_b";

  Real dXiAct(final unit="1")
    "Actual mass fraction difference from port_a to port_b";

  Real k(start=1)
    "Gain to take flow rate into account for sensor time constant";

  Real mNor_flow "Normalized mass flow rate";

  Modelica.Blocks.Interfaces.RealInput TSet_internal(unit="K", displayUnit="degC")
    "Internal connector for set point temperature of the fluid that leaves port_b";

  Modelica.Blocks.Interfaces.RealInput X_wSet_internal(unit="1")
    "Internal connector for set point for water vapor mass fraction of the fluid that leaves port_b";

initial equation
  // Set initial conditions, unless use_{T,Xi}Set = false in which case
  // it is not a state.
  if use_TSet then
    if energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
      der(T) = 0;
    elseif energyDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
      T = T_start;
    end if;
  end if;

  if use_X_wSet then
    if massDynamics == Modelica.Fluid.Types.Dynamics.SteadyStateInitial then
      der(Xi) = 0;
    elseif massDynamics == Modelica.Fluid.Types.Dynamics.FixedInitial then
      Xi = X_start[1];
    end if;
  end if;

  assert((energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau > Modelica.Constants.eps,
"The parameter tau, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau = " + String(tau) + "\n");
  assert((massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
          tau > Modelica.Constants.eps,
"The parameter tau, or the volume of the model from which tau may be derived, is unreasonably small.
 You need to set massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState to model steady-state.
 Received tau = " + String(tau) + "\n");

 if use_X_wSet then
  assert(Medium.nX > 1, "If use_X_wSet = true, require a medium with water vapor, such as Buildings.Media.Air");
 end if;

equation
  // Conditional connectors
  if not use_TSet then
    TSet_internal = 293.15;
  end if;
  connect(TSet, TSet_internal);
  if not use_X_wSet then
    X_wSet_internal = 0.01;
  end if;
  connect(X_wSet, X_wSet_internal);

  if (use_TSet and energyDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) or
     (use_X_wSet and massDynamics == Modelica.Fluid.Types.Dynamics.SteadyState) then
    mNor_flow = port_a.m_flow/m_flow_nominal;
    k = Modelica.Fluid.Utilities.regStep(x=port_a.m_flow,
                                         y1= mNor_flow,
                                         y2=-mNor_flow,
                                         x_small=m_flow_small);
  else
    mNor_flow = 1;
    k = 1;
  end if;

  if use_TSet and energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState then
    der(T) = (TSet_internal-T)*k/tau;
  else
    T = TSet_internal;
  end if;

  if use_X_wSet and massDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState then
    der(Xi) = (X_wSet_internal-Xi)*k/tau;
  else
    Xi = X_wSet_internal;
  end if;

  Xi_instream = inStream(port_a.Xi_outflow);

  // Set point without any capacity limitation
  hSet = if use_TSet then Medium.specificEnthalpy(
    Medium.setState_pTX(
      p = port_a.p,
      T = T,
      X = Xi_instream + fill(dXiAct, Medium.nXi)))
        else Medium.h_default;

  m_flow_pos = Buildings.Utilities.Math.Functions.smoothMax(
    x1=m_flow,
    x2=0,
    deltaX=m_flow_small);

   if not restrictHeat and not restrictCool and
      not restrictHumi and not restrictDehu then
     m_flow_non_zero = Modelica.Constants.eps;
   else
     m_flow_non_zero = Buildings.Utilities.Math.Functions.smoothMax(
       x1 = port_a.m_flow,
       x2 = m_flow_small,
       deltaX=m_flow_small/2);
   end if;

  // Compute mass fraction leaving the component.
  // Below, we use sum(Xi_instream) as Xi anyway has only one element.
  // However, scalar(Xi_instream) would not work as dim(Xi_instream) = 0
  // if the medium is not a mixture.
  // Note that the computations for the mass fraction and for the
  // enthalpy change are identical. In a development version, they were
  // put in a function, but this led to large nonlinear systems of equations.
  if use_X_wSet then
    if not restrictHumi and not restrictDehu then
      // No capacity limit
      dXiAct = Xi_outflow-sum(Xi_instream);
      Xi_outflow  = Xi;
      mWat_flow   = m_flow_pos*(Xi - sum(Xi_instream));
    else
      if restrictHumi and restrictDehu then
        // Capacity limits for heating and cooling
        dXiAct =Buildings.Utilities.Math.Functions.smoothLimit(
              x=Xi - sum(Xi_instream),
              l=mWatMin_flow/m_flow_non_zero,
              u=mWatMax_flow/m_flow_non_zero,
              deltaX=deltaXi);
      elseif restrictHumi then
        // Capacity limit for heating only
        dXiAct =Buildings.Utilities.Math.Functions.smoothMin(
              x1=Xi - sum(Xi_instream),
              x2=mWatMax_flow/m_flow_non_zero,
              deltaX=deltaXi);
      else
        // Capacity limit for cooling only
        dXiAct =Buildings.Utilities.Math.Functions.smoothMax(
              x1=Xi - sum(Xi_instream),
              x2=mWatMin_flow/m_flow_non_zero,
              deltaX=deltaXi);
      end if;
      Xi_outflow = sum(Xi_instream) + dXiAct;
      mWat_flow  = m_flow_pos*dXiAct;
    end if;
    port_b.Xi_outflow = fill(Xi_outflow, Medium.nXi);
  else
    Xi_outflow = sum(Xi_instream);
    mWat_flow = 0;
    dXiAct = 0;
    port_b.Xi_outflow = Xi_instream;
  end if;

  // Compute enthalpy leaving the component.
  if use_TSet then
    if not restrictHeat and not restrictCool then
      // No capacity limit
      dhAct = 0;
      port_b.h_outflow  = hSet;
      Q_flow  =    m_flow_pos*(hSet - inStream(port_a.h_outflow));
    else
      if restrictHeat and restrictCool then
        // Capacity limits for heating and cooling
        dhAct =Buildings.Utilities.Math.Functions.smoothLimit(
              x=hSet - inStream(port_a.h_outflow),
              l=QMin_flow/m_flow_non_zero,
              u=QMax_flow/m_flow_non_zero,
              deltaX=deltaH);
      elseif restrictHeat then
        // Capacity limit for heating only
        dhAct =Buildings.Utilities.Math.Functions.smoothMin(
              x1=hSet - inStream(port_a.h_outflow),
              x2=QMax_flow/m_flow_non_zero,
              deltaX=deltaH);
      else
        // Capacity limit for cooling only
        dhAct =Buildings.Utilities.Math.Functions.smoothMax(
              x1=hSet - inStream(port_a.h_outflow),
              x2=QMin_flow/m_flow_non_zero,
              deltaX=deltaH);
      end if;
      port_b.h_outflow = inStream(port_a.h_outflow) + dhAct;
      Q_flow = m_flow_pos*dhAct;
    end if;
  else
    port_b.h_outflow = inStream(port_a.h_outflow);
    Q_flow = 0;
    dhAct = 0;
  end if;

  // Outflowing property at port_a is unaffected by this model.
  if allowFlowReversal then
    port_a.h_outflow =  inStream(port_b.h_outflow);
    port_a.Xi_outflow = inStream(port_b.Xi_outflow);
    port_a.C_outflow =  inStream(port_b.C_outflow);
  else
    port_a.h_outflow =  Medium.h_default;
    port_a.Xi_outflow = Medium.X_default[1:Medium.nXi];
    port_a.C_outflow =  zeros(Medium.nC);
  end if;
  // No pressure drop
  dp = 0;

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Transport of substances
  port_b.C_outflow = inStream(port_a.C_outflow);

  if not allowFlowReversal then
    assert(m_flow > -m_flow_small,
      "Reverting flow occurs even though allowFlowReversal is false");
  end if;

    annotation (
  defaultComponentName="heaCoo",
  Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                      graphics={
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
          extent={{-98,64},{-76,42}},
          lineColor={0,0,127},
          visible=use_X_wSet,
          textString="X_w"),
        Text(
          extent={{74,72},{120,44}},
          lineColor={0,0,127},
          textString="mWat_flow"),
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-64,34},{-34,54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-64,34},{-52,44},{-64,54}}, color={0,0,0}),
        Rectangle(
          extent={{-70,60},{-66,82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          visible=use_TSet,
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{66,60},{70,82}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-106,102},{-74,88}},
          lineColor={0,0,127},
          visible=use_TSet,
          textString="T"),
        Rectangle(
          extent={{-100,82},{-70,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          visible=use_TSet,
          fillPattern=FillPattern.Solid),
        Text(
          extent={{72,108},{120,92}},
          lineColor={0,0,127},
          textString="Q_flow"),
        Rectangle(
          extent={{70,82},{100,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,41},{-70,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          visible=use_X_wSet,
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,41},{100,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
  Documentation(info="<html>
<p>
This model sets the temperature or the water vapor mass fraction
of the medium that leaves <code>port_a</code>
to the value given by the input <code>TSet</code> or <code>X_wSet</code>,
subject to optional limitations on the capacity
for heating and cooling, or limitations on the humidification or dehumidification
moisture mass flow rate.
Also, optionally the model allows to take into account first order dynamics.
</p>
<p>
If the parameters <code>energyDynamics</code> or
<code>massDynamics</code> are not equal to
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
See <a href=\"modelica://Buildings.Fluid.HeatExchangers.PrescribedOutlet\">
Buildings.Fluid.HeatExchangers.PrescribedOutlet</a>
for a model that instantiates this model and that has a pressure drop.
</p>
<p>
In case of reverse flow,
the fluid that leaves <code>port_a</code> has the same
properties as the fluid that enters <code>port_b</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
April 29, 2021, by Michael Wetter:<br/>
Removed duplicate declaration of <code>m_flow_nominal</code> which is already
declared in the base class.<br/>
</li>
<li>
March 19, 2018, by Michael Wetter:<br/>
Added bugfix as the old model did not track <code>TSet</code> and <code>X_wSet</code>
simultaneously.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/893\">#893</a>.
</li>
<li>
May 3, 2017, by Michael Wetter:<br/>
Refactored model to allow <code>X_wSet</code> as an input.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/763\">#763</a>.
</li>
<li>
January 26, 2016, by Michael Wetter:<br/>
Removed inequality comparison of real numbers in <code>restrictCool</code>
and in <code>restrictHeat</code> as this is not allowed in Modelica.
</li>
<li>
November 10, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PrescribedOutlet;
