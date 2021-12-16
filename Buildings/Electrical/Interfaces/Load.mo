within Buildings.Electrical.Interfaces;
model Load "Partial model for a generic load"
  replaceable package PhaseSystem =
      Buildings.Electrical.PhaseSystems.PartialPhaseSystem constrainedby
    Buildings.Electrical.PhaseSystems.PartialPhaseSystem "Phase system"
    annotation (choicesAllMatching=true);
  parameter Boolean linearized = false "If true, the load model is linearized"
    annotation(Evaluate=true,Dialog(group="Modeling assumption"));
  parameter Buildings.Electrical.Types.Load mode(
    min=Buildings.Electrical.Types.Load.FixedZ_steady_state,
    max=Buildings.Electrical.Types.Load.VariableZ_y_input) = Buildings.Electrical.Types.Load.FixedZ_steady_state
    "Type of load model (e.g., steady state, dynamic, prescribed power consumption, etc.)"
    annotation (Evaluate=true, Dialog(group="Modeling assumption"));

  parameter Modelica.Units.SI.Power P_nominal=0
    "Nominal power (negative if consumed, positive if generated). Used if mode <> Buildings.Electrical.Types.Load.VariableZ_P_input"
    annotation (Dialog(group="Nominal conditions", enable=mode <> Buildings.Electrical.Types.Load.VariableZ_P_input));

  parameter Modelica.Units.SI.Voltage V_nominal(min=0, start=110)
    "Nominal voltage (V_nominal >= 0)" annotation (Evaluate=true, Dialog(group=
          "Nominal conditions", enable=(mode == Buildings.Electrical.Types.Load.FixedZ_dynamic
           or linearized)));
  parameter Buildings.Electrical.Types.InitMode initMode(
  min=Buildings.Electrical.Types.InitMode.zero_current,
  max=Buildings.Electrical.Types.InitMode.linearized) = Buildings.Electrical.Types.InitMode.zero_current
    "Initialization mode for homotopy operator"  annotation(Dialog(tab = "Initialization"));

  Modelica.Units.SI.Voltage v[:](start=PhaseSystem.phaseVoltages(V_nominal)) =
    terminal.v "Voltage vector";
  Modelica.Units.SI.Current i[:](each start=0) = terminal.i "Current vector";
  Modelica.Units.SI.Power S[PhaseSystem.n]=PhaseSystem.phasePowers_vi(v, -i)
    "Phase powers";
  Modelica.Units.SI.Power P(start=0)
    "Power of the load (negative if consumed, positive if fed into the electrical grid)";

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1, unit="1")
    if (mode == Buildings.Electrical.Types.Load.VariableZ_y_input)
    "Fraction of the nominal power consumed" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  Modelica.Blocks.Interfaces.RealInput Pow(unit="W")
    if (mode == Buildings.Electrical.Types.Load.VariableZ_P_input)
    "Power consumed" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={100,0})));
  replaceable Buildings.Electrical.Interfaces.Terminal terminal(
    redeclare replaceable package PhaseSystem = PhaseSystem)
    "Generalized electric terminal"
    annotation (Placement(transformation(extent={{-108,-8},{-92,8}}),
        iconTransformation(extent={{-108,-8},{-92,8}})));

protected
  Modelica.Blocks.Interfaces.RealInput y_internal
    "Hidden value of the input load for the conditional connector";
  Modelica.Blocks.Interfaces.RealInput P_internal
    "Hidden value of the input power for the conditional connector";
  Real load(min=eps, max=1)
    "Internal representation of control signal, used to avoid singularity";
  constant Real eps = 1E-10
    "Small number used to avoid a singularity if the power is zero";
  constant Real oneEps = 1-eps
    "Small number used to avoid a singularity if the power is zero";

initial equation
  if mode == Buildings.Electrical.Types.Load.VariableZ_P_input then
    assert(abs(P_nominal) < 1E-10, "*** Warning: P_nominal = " + String(P_nominal) + ", but this value will be ignored.",
           AssertionLevel.warning);
  end if;

equation
  assert(y_internal>=0 and y_internal<=1+eps, "The power load fraction P (input of the model) must be within [0,1]");

  // Connection between the conditional and inner connector
  connect(y,y_internal);
  connect(Pow,P_internal);

  // If the power is fixed, inner connector value is equal to 1
  if mode==Buildings.Electrical.Types.Load.FixedZ_steady_state or
     mode==Buildings.Electrical.Types.Load.FixedZ_dynamic then
    y_internal   = 1;
    P_internal = 0;
  elseif mode==Buildings.Electrical.Types.Load.VariableZ_y_input then
    P_internal = 0;
  elseif mode==Buildings.Electrical.Types.Load.VariableZ_P_input then
    y_internal = 1;
  end if;

  // Value of the load, depending on the type: fixed or variable
  if mode==Buildings.Electrical.Types.Load.VariableZ_y_input then
    load = eps + oneEps*y_internal;
  else
    load = 1;
  end if;

  // Power consumption
  if mode==Buildings.Electrical.Types.Load.FixedZ_steady_state or
     mode==Buildings.Electrical.Types.Load.FixedZ_dynamic then
    P = P_nominal;
  elseif mode==Buildings.Electrical.Types.Load.VariableZ_P_input then
    P = P_internal;
  else
    P = P_nominal*load;
  end if;

  annotation ( Documentation(revisions="<html>
<ul>
<li>
January 30, 2019, by Michael Wetter:<br/>
Set start value for <code>P</code>.
</li>
<li>
November 28, 2016, by Michael Wetter:<br/>
Removed zero start value for current.
The current is typically non-zero and zero is anyway the default start value, hence there is no need to set it.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/584\">#584</a>.
</li>
<li>
September 17, 2016, by Michael Wetter:<br/>
Corrected wrong annotation to avoid an error in the pedantic model check
in Dymola 2017 FD01 beta2.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/557\">issue 557</a>.
</li>
<li>
February 26, 2016, by Michael Wetter:<br/>
Set default value for <code>P_nominal</code>
and removed assertion warning.
This is required for pedantic model check in Dymola.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/426\">#426</a>.
</li>
<li>
September 24, 2015 by Michael Wetter:<br/>
Provided value for <code>P_nominal</code> if
<code>mode &lt;&gt; Buildings.Electrical.Types.Load.VariableZ_P_input</code>.
This avoids a warning during translation of
<a href=\"modelica://Buildings.Examples.ChillerPlant.DataCenterRenewables\">
Buildings.Examples.ChillerPlant.DataCenterRenewables</a>.
</li>
<li>
September 4, 2014, by Michael Wetter:<br/>
Changed the parameter from <code>linear</code> to <code>linearized</code>
because <code>Buildings.Fluid</code> also uses <code>linearized</code>.
This change has been done to use a consistent naming across the library.
</li>
<li>June 17, 2014, by Marco Bonvini:<br/>
Adde parameter <code>initMode</code> that can be used to
select the assumption to be used during initialization phase
by the homotopy operator.
</li>
<li>
May 15, 2014, by Marco Bonvini:<br/>
Created documentation and revised model.
</li>
<li>
October 31, 2013, by Marco Bonvini:<br/>
Model included in the Buildings library.
</li>
</ul>
</html>", info="<html>
<p>
This model represents a generic load that can be extended to represent
either a DC or an AC load.
</p>
<p>
The model has a single generalized electric terminal of type
<a href=\"modelica://Buildings.Electrical.Interfaces.Terminal\">
Buildings.Electrical.Interfaces.Terminal</a>
that can be redeclared.
The generalized load is modeled as an impedance whose value can change. The value of the impedance
can change depending on the value of the parameter <code>mode</code>, which is of type
<a href=\"Buildings.Electrical.Types.Load\">Buildings.Electrical.Types.Load</a>:
</p>

<table summary=\"summary\" border=\"1\" cellspacing=\"0\" cellpadding=\"2\" style=\"border-collapse:collapse;\">
<tr>
<th>Mode</th>
<th>Description</th>
<th>Explanation</th>
</tr>
<!-- ************ -->
<tr>
<td>Buildings.Electrical.Types.Load.FixedZ_steady_state</td>
<td>fixed Z steady state</td>
<td>The load consumes exactly the power
specified by the parameter <code>P_nominal</code>.
</td>
</tr>
<!-- ************ -->
<tr>
<td>Buildings.Electrical.Types.Load.FixedZ_dynamic</td>
<td>fixed Z dynamic</td>
<td>
The load consumes exactly the power
specified by the parameter <code>P_nominal</code> at steady state.
Depending on the type
of load (e.g., inductive or capacitive)
different dynamics are represented.
</td>
</tr>
<!-- ************ -->
<tr>
<td>Buildings.Electrical.Types.Load.VariableZ_P_input</td>
<td>variable Z P input</td>
<td>
The load consumes exactly the power specified
by the input variable <code>Pow</code>.
</td>
</tr>
<!-- ************ -->
<tr>
<td>Buildings.Electrical.Types.Load.VariableZ_y_input</td>
<td>variable Z y input</td>
<td>
The load consumes exactly the a fraction of the nominal power
<code>P_nominal</code> specified by the input variable <code>y</code>.
</td>
</tr>
<!-- ************ -->
</table>


<h4>Conventions</h4>
<p>
It is assumed that the power <code>P</code> of the load is positive when produced
(e.g., the load acts like a source) and negative when consumed (e.g., the
source acts like a utilizer).
</p>

<h4>Linearized models</h4>
<p>
The model has a Boolean parameter <code>linearized</code> that by default is equal to <code>false</code>.
When the power consumption of the load is imposed, this introduces
a nonlinear equation between the voltage and the current of the load. This flag is used to
select between a linearized version
of the equations or the original nonlinear ones.<br/>
When the linearized version of the model is used, the parameter <code>V_nominal</code> has to
be specified. The nominal voltage is needed to linearize the nonlinear equations.<br/>
</p>
<p>
<b>Note:</b>
A linearized model will not consume the nominal power if the voltage
at the terminal differs from the nominal voltage.
</p>

</html>"));
end Load;
