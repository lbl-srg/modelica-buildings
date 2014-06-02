within Buildings.Electrical.Interfaces;
model PartialImpedance
  "Partial model representing a generalized impedance fixme: Rename model as it is not a partial model. It has as many eqns and vars"
  extends Buildings.Electrical.Interfaces.PartialLoad(
    final linear = false,
    final mode=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
    final P_nominal(fixed = true)=0,
    final V_nominal(fixed = true)=1);
  parameter Boolean inductive=true
    "If =true the load is inductive, otherwise it is capacitive"
    annotation (Evaluate=true, choices(
      choice=true "Inductive",
      choice=false "Capacitive",
      __Dymola_radioButtons=true));
      // fixme: useVariableR, useVariableL and useVariableC need to be renamed to
      //        use_R_in, use_L_in and use_C_in to use consistent naming with MSL.
      //        See also Buildings.Fluid.Sources.Boundary_pT
  parameter Modelica.SIunits.Resistance R(start = 1,min=0) = 1 "Resistance"
    annotation (Dialog(enable= not useVariableR));
  parameter Modelica.SIunits.Inductance L(start=0, min=0) = 0 "Inductance"
    annotation (Dialog(enable=inductive and (not useVariableL)));
  parameter Modelica.SIunits.Capacitance C(start=0,min=0) = 0 "Capacitance"
  annotation (Dialog(enable=(not inductive) and (not useVariableC)));
  parameter Boolean useVariableR = false "if true, R is specified by an input"
     annotation(Evaluate=true, Dialog(tab = "Variable load", group="Resistance"));
  // fixme: Rename Rmin to RMin and Rmax to RMax (and the same for C and L)
  //        to use the naming convention of the other models. See for example Fluid/Chillers/Data/ElectricEIR.mo

  parameter Modelica.SIunits.Resistance Rmin(start = R, min=Modelica.Constants.eps) = 1e-4
    "Minimum value of the resistance"
    annotation(Evaluate=true, Dialog(enable = useVariableR, tab = "Variable load", group="Resistance"));
  parameter Modelica.SIunits.Resistance Rmax(start = R, min=Modelica.Constants.eps) = 1e2
    "Maximum value of the resistance"
    annotation(Evaluate=true, Dialog(enable = useVariableR, tab = "Variable load", group="Resistance"));
  parameter Boolean useVariableC = false "if true, C is specified by an input"
    annotation(Evaluate=true, Dialog(tab = "Variable load", group="Capacitance"));
  parameter Modelica.SIunits.Capacitance Cmin(start = C, min=Modelica.Constants.eps) = 1e-4
    "Minimum value of the capacitance"
    annotation(Evaluate=true, Dialog(enable = useVariableC, tab = "Variable load", group="Capacitance"));
  // fixme: Removed the value of Cmax, Lmax and Rmax, as typical values can change
  //        by a few orders of magntitude depending on the application.
  parameter Modelica.SIunits.Capacitance Cmax(start = C, min=Modelica.Constants.eps) = 1e2
    "Maximum value of the capacitance"
    annotation(Evaluate=true, Dialog(enable = useVariableC, tab = "Variable load", group="Capacitance"));
  parameter Boolean useVariableL = false "if true, L is specified by an input"
     annotation(Evaluate=true, Dialog(tab = "Variable load", group="Inductance"));
  parameter Modelica.SIunits.Inductance Lmin(start = L, min=Modelica.Constants.eps) = 1e-4
    "Minimum value of the inductance"
    annotation(Evaluate=true, Dialog(enable = useVariableL, tab = "Variable load", group="Inductance"));
  parameter Modelica.SIunits.Inductance Lmax(start = L, min=Modelica.Constants.eps) = 1e2
    "Maximum value of the inductance"
    annotation(Evaluate=true, Dialog(enable = useVariableL, tab = "Variable load", group="Inductance"));
  Modelica.Blocks.Interfaces.RealInput y_R(min=0, max=1) if useVariableR
    "Input that sepecify variable R"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={-40,100})));
  Modelica.Blocks.Interfaces.RealInput y_C(min=0, max=1) if useVariableC
    "Input that sepecify variable C"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={0,100})));
  Modelica.Blocks.Interfaces.RealInput y_L(min=0, max=1) if useVariableL
    "Input that sepecify variable L"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=270,
        origin={40,100})));
  // fixme: add comments
protected
  Modelica.Blocks.Interfaces.RealOutput y_R_internal;
  Modelica.Blocks.Interfaces.RealOutput y_C_internal;
  Modelica.Blocks.Interfaces.RealOutput y_L_internal;
  Modelica.SIunits.Resistance R_internal;
  Modelica.SIunits.Inductance L_internal;
  Modelica.SIunits.Capacitance C_internal;
equation
  // These assertions ensures that if the variable R, L or C is computed using the inputs
  // the parameters min and max are sorted
  assert((not useVariableR) or Rmin < Rmax, "The value of Rmin has to be lower than Rmax");
  assert((not useVariableL) or Lmin < Lmax, "The value of Lmin has to be lower than Lmax");
  assert((not useVariableC) or Cmin < Cmax, "The value of Cmin has to be lower than Cmax");

  // Connections to internal connectors
  connect(y_R, y_R_internal);
  connect(y_C, y_C_internal);
  connect(y_L, y_L_internal);

  // default assignment when connectors are conditionally removed
  if not useVariableR then
    y_R_internal = 0;
  end if;

  if not useVariableC then
    y_C_internal = 0;
  end if;

  if not useVariableL then
    y_L_internal = 0;
  end if;

  // Retrieve the value of the R,L,C either if fixed or
  // varying
  if not useVariableR then
    R_internal = R;
  else
    R_internal = Rmin + y_R_internal*(Rmax - Rmin);
  end if;

  if not useVariableC then
    C_internal = C;
  else
    C_internal = Cmin + y_C_internal*(Cmax - Cmin);
  end if;

  if not useVariableL then
    L_internal = L;
  else
    L_internal = Lmin + y_L_internal*(Lmax - Lmin);
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Documentation(info="<html>
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
These input values are enabled by the boolean flags <code>useVariableR</code>, 
<code>useVariableL</code>, and 
<code>useVariableC</code>.
</p>
<h5>Example</h5>
<p>
If the flag <code>useVariableR = true</code>, the value of <code>R</code> is computed as
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
end PartialImpedance;
