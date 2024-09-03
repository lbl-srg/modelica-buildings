within Buildings.Electrical.Interfaces;
model Impedance "Partial model representing a generalized impedance"
  extends Buildings.Electrical.Interfaces.Load(
    final linearized = false,
    final mode=Buildings.Electrical.Types.Load.FixedZ_steady_state,
    final P_nominal(fixed = true)=0,
    final V_nominal(fixed = true)=1);
  parameter Boolean inductive=true
    "If true, the load is inductive, otherwise it is capacitive"
    annotation (Evaluate=true, choices(
      choice=true "Inductive",
      choice=false "Capacitive",
      __Dymola_radioButtons=true));
  parameter Modelica.Units.SI.Resistance R(
    start=1,
    min=0) = 1 "Resistance" annotation (Dialog(enable=not use_R_in));
  parameter Modelica.Units.SI.Inductance L(
    start=0,
    min=0) = 0 "Inductance"
    annotation (Dialog(enable=inductive and (not use_L_in)));
  parameter Modelica.Units.SI.Capacitance C(
    start=0,
    min=0) = 0 "Capacitance"
    annotation (Dialog(enable=(not inductive) and (not use_C_in)));
  parameter Boolean use_R_in = false "If true, R is specified by an input"
     annotation(Evaluate=true, Dialog(tab = "Variable load", group="Resistance"));
  parameter Modelica.Units.SI.Resistance RMin(
    start=R,
    min=Modelica.Constants.eps) = 1e-4 "Minimum value of the resistance"
    annotation (Evaluate=true, Dialog(
      enable=use_R_in,
      tab="Variable load",
      group="Resistance"));
  parameter Modelica.Units.SI.Resistance RMax(
    start=R,
    min=Modelica.Constants.eps) = 1e2 "Maximum value of the resistance"
    annotation (Evaluate=true, Dialog(
      enable=use_R_in,
      tab="Variable load",
      group="Resistance"));
  parameter Boolean use_C_in = false "If true, C is specified by an input"
    annotation(Evaluate=true, Dialog(tab = "Variable load", group="Capacitance"));
  parameter Modelica.Units.SI.Capacitance CMin(
    start=C,
    min=Modelica.Constants.eps) = 1e-4 "Minimum value of the capacitance"
    annotation (Evaluate=true, Dialog(
      enable=use_C_in,
      tab="Variable load",
      group="Capacitance"));
  parameter Modelica.Units.SI.Capacitance CMax(
    start=C,
    min=Modelica.Constants.eps) = 1e2 "Maximum value of the capacitance"
    annotation (Evaluate=true, Dialog(
      enable=use_C_in,
      tab="Variable load",
      group="Capacitance"));
  parameter Boolean use_L_in = false "If true, L is specified by an input"
     annotation(Evaluate=true, Dialog(tab = "Variable load", group="Inductance"));
  parameter Modelica.Units.SI.Inductance LMin(
    start=L,
    min=Modelica.Constants.eps) = 1e-4 "Minimum value of the inductance"
    annotation (Evaluate=true, Dialog(
      enable=use_L_in,
      tab="Variable load",
      group="Inductance"));
  parameter Modelica.Units.SI.Inductance LMax(
    start=L,
    min=Modelica.Constants.eps) = 1e2 "Maximum value of the inductance"
    annotation (Evaluate=true, Dialog(
      enable=use_L_in,
      tab="Variable load",
      group="Inductance"));
  Modelica.Blocks.Interfaces.RealInput y_R(min=0, max=1) if use_R_in
    "Input that sepecify variable R"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,100})));
  Modelica.Blocks.Interfaces.RealInput y_C(min=0, max=1) if use_C_in
    "Input that sepecify variable C"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealInput y_L(min=0, max=1) if use_L_in
    "Input that sepecify variable L"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,100})));
protected
  Modelica.Blocks.Interfaces.RealOutput y_R_internal
    "Internal signal used to compute the variable R_internal";
  Modelica.Blocks.Interfaces.RealOutput y_C_internal
    "Internal signal used to compute the variable C_internal";
  Modelica.Blocks.Interfaces.RealOutput y_L_internal
    "Internal signal used to compute the variable L_internal";
  Modelica.Units.SI.Resistance R_internal
    "Actual resistance used to compute the impedance";
  Modelica.Units.SI.Inductance L_internal
    "Actual inductance used to compute the impedance";
  Modelica.Units.SI.Capacitance C_internal
    "Actual capacitance used to compute the impedance";
equation
  // These assertions ensures that if the variable R, L or C is computed using the inputs
  // the parameters min and max are sorted
  assert((not use_R_in) or RMin < RMax, "The value of RMin has to be lower than RMax");
  assert((not use_L_in) or LMin < LMax, "The value of Lmin has to be lower than Lmax");
  assert((not use_C_in) or CMin < CMax, "The value of Cmin has to be lower than Cmax");

  // Connections to internal connectors
  connect(y_R, y_R_internal);
  connect(y_C, y_C_internal);
  connect(y_L, y_L_internal);

  // Default assignment when connectors are conditionally removed
  if not use_R_in then
    y_R_internal = 0;
  end if;

  if not use_C_in then
    y_C_internal = 0;
  end if;

  if not use_L_in then
    y_L_internal = 0;
  end if;

  // Retrieve the value of the R,L,C either if fixed or
  // varying
  if not use_R_in then
    R_internal = R;
  else
    R_internal = RMin + y_R_internal*(RMax - RMin);
  end if;

  if not use_C_in then
    C_internal = C;
  else
    C_internal = CMin + y_C_internal*(CMax - CMin);
  end if;

  if not use_L_in then
    L_internal = L;
  else
    L_internal = LMin + y_L_internal*(LMax - LMin);
  end if;

  annotation ( Documentation(info="<html>
<p>
This model represents a generalized interface for an impedance.
</p>
<p>
The model has a single generalized electric terminal of type
<a href=\"modelica://Buildings.Electrical.Interfaces.Terminal\">
Buildings.Electrical.Interfaces.Terminal</a>
that can be redeclared.
The impedance can be of different types:
</p>
<ol>
<li>resistive,</li>
<li>inductive,</li>
<li>resistive and inductive,</li>
<li>capacitive, and</li>
<li>resistive and capacitive.</li>
</ol>
<p>
The values of the resistance <code>R</code>, capacitance <code>C</code> and
inductance <code>L</code> can be
specified as parameters of the model.
</p>
<p>
The values of the resistance <code>R</code>, capacitance <code>C</code>
and inductance <code>L</code> can also be
specified by using the input variables <code>y_R</code>, <code>y_C</code>,
and <code>y_L</code> that are Real values between <i>[0,1]</i>.<br/>
These input values are enabled by the boolean flags <code>use_R_in</code>,
<code>use_L_in</code>, and
<code>use_C_in</code>.
</p>
<h5>Example</h5>
<p>
If the flag <code>use_R_in = true</code>, the value of <code>R</code> is computed as
</p>
<p align=\"center\" style=\"font-style:italic;\">
R = R<sub>min</sub> + y<sub>R</sub> (R<sub>max</sub> - R<sub>min</sub>)
</p>
</html>", revisions="<html>
<ul>
<li>
May 15, 2014, by Marco Bonvini:<br/>
Created documentation.
</li>
</ul>
</html>"));
end Impedance;
