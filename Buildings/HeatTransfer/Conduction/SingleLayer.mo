within Buildings.HeatTransfer.Conduction;
model SingleLayer "Model for single layer heat conductance"
  extends Buildings.HeatTransfer.Conduction.BaseClasses.PartialConductor(
   final R=if (material.R < Modelica.Constants.eps) then material.x/material.k/A else material.R/A);
   // if material.R == 0, then the material specifies material.k, and this model specifies x
   // For resistances, material.k need not be specified, and hence we use material.R

  // The value T[:].start is used by the solver when finding initial states
  // that satisfy dT/dt=0, which requires solving a system of nonlinear equations
  // if the convection coefficient is a function of temperature.
  Modelica.Units.SI.Temperature T[nSta](start=if stateAtSurface_a then cat(
        1,
        {T_a_start},
        {(T_a_start + (T_b_start - T_a_start)*UA*sum(RNod[k] for k in 1:i - 1))
          for i in 2:nSta}) else {(T_a_start + (T_b_start - T_a_start)*UA*sum(
        RNod[k] for k in 1:i)) for i in 1:nSta}, each nominal=300)
    "Temperature at the states";

  Modelica.Units.SI.HeatFlowRate Q_flow[nSta + 1](each start=0)
    "Heat flow rates to each state";
  Modelica.Units.SI.SpecificInternalEnergy u[nSta](each start=2.7E5, each
      nominal=2.7E5) "Definition of specific internal energy";

  parameter Boolean stateAtSurface_a=true
    "=true, a state will be at the surface a"
    annotation (Dialog(tab="Dynamics"),
                Evaluate=true);
  parameter Boolean stateAtSurface_b=true
    "=true, a state will be at the surface b"
    annotation (Dialog(tab="Dynamics"),
                Evaluate=true);

  replaceable parameter Data.BaseClasses.Material material
    "Material from Data.Solids, Data.SolidsPCM or Data.Resistances"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{60,60},
            {80,80}})));

  parameter Boolean steadyStateInitial=false
    "=true initializes dT(0)/dt=0, false initializes T(0) at fixed temperature using T_a_start and T_b_start"
        annotation (Dialog(group="Initialization"), Evaluate=true);
  parameter Modelica.Units.SI.Temperature T_a_start=293.15
    "Initial temperature at port_a, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Modelica.Units.SI.Temperature T_b_start=293.15
    "Initial temperature at port_b, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Integer nSta2=material.nSta
  "Number of states in a material (do not overwrite, used to work around Dymola 2017 bug)"
     annotation (Evaluate=true, HideResult=true, Dialog(enable=false, tab="Advanced"));
protected
  final parameter Integer nSta=
    max(nSta2,
        if stateAtSurface_a or stateAtSurface_b then 2 else 1)
    "Number of state variables";
  final parameter Integer nR=nSta+1 "Number of thermal resistances";
  parameter Modelica.Units.SI.ThermalResistance RNod[nR]=if (stateAtSurface_a
       and stateAtSurface_b) then if (nSta == 2) then {(if i == 1 or i == nR
       then 0 else R/(nSta - 1)) for i in 1:nR} else {(if i == 1 or i == nR
       then 0 elseif i == 2 or i == nR - 1 then R/(2*(nSta - 2)) else R/(nSta
       - 2)) for i in 1:nR} elseif (stateAtSurface_a and (not stateAtSurface_b))
       then {(if i == 1 then 0 elseif i == 2 or i == nR then R/(2*(nSta - 1))
       else R/(nSta - 1)) for i in 1:nR} elseif (stateAtSurface_b and (not
      stateAtSurface_a)) then {(if i == nR then 0 elseif i == 1 or i == nR - 1
       then R/(2*(nSta - 1)) else R/(nSta - 1)) for i in 1:nR} else {R/(if i
       == 1 or i == nR then (2*nSta) else nSta) for i in 1:nR}
    "Thermal resistance";

  parameter Modelica.Units.SI.Mass m[nSta]=(A*material.x*material.d)*(if (
      stateAtSurface_a and stateAtSurface_b) then if (nSta == 2) then {1/(2*(
      nSta - 1)) for i in 1:nSta} elseif (nSta == 3) then {1/(if i == 1 or i
       == nSta then (2*(nSta - 1)) else (nSta - 1)) for i in 1:nSta} else {1/(
      if i == 1 or i == nSta or i == 2 or i == nSta - 1 then (2*(nSta - 2))
       else (nSta - 2)) for i in 1:nSta} elseif (stateAtSurface_a and (not
      stateAtSurface_b)) then {1/(if i == 1 or i == 2 then (2*(nSta - 1)) else
      (nSta - 1)) for i in 1:nSta} elseif (stateAtSurface_b and (not
      stateAtSurface_a)) then {1/(if i == nSta or i == nSta - 1 then (2*(nSta
       - 1)) else (nSta - 1)) for i in 1:nSta} else {1/(nSta) for i in 1:nSta})
    "Mass associated with the temperature state";

  final parameter Real mInv[nSta]=
    if material.steadyState then zeros(nSta) else {1/m[i] for i in 1:nSta}
    "Inverse of the mass associated with the temperature state";

  final parameter Modelica.Units.SI.HeatCapacity C[nSta]=m*material.c
    "Heat capacity associated with the temperature state";
  final parameter Real CInv[nSta]=
    if material.steadyState then zeros(nSta) else {1/C[i] for i in 1:nSta}
    "Inverse of heat capacity associated with the temperature state";

  parameter Modelica.Units.SI.SpecificInternalEnergy ud[Buildings.HeatTransfer.Conduction.nSupPCM](
     each fixed=false) "Support points for derivatives (used for PCM)";
  parameter Modelica.Units.SI.Temperature Td[Buildings.HeatTransfer.Conduction.nSupPCM](
     each fixed=false) "Support points for derivatives (used for PCM)";
  parameter Real dT_du[Buildings.HeatTransfer.Conduction.nSupPCM](
    each fixed=false,
    each unit="kg.K2/J")
    "Derivatives dT/du at the support points (used for PCM)";

initial equation
  // The initialization is only done for materials that store energy.
    if not material.steadyState then
      if steadyStateInitial then
        if material.phasechange then
          der(u) = zeros(nSta);
        else
          der(T) = zeros(nSta);
        end if;
      else
        if stateAtSurface_a then
          T[1] = T_a_start;
          for i in 2:nSta loop
            T[i] =T_a_start + (T_b_start - T_a_start)*UA*sum(RNod[k] for k in 1:i-1);
          end for;
        else // stateAtSurface_a == false
          for i in 1:nSta loop
            T[i] = T_a_start + (T_b_start - T_a_start)*UA*sum(RNod[k] for k in 1:i);
          end for;
        end if;
      end if;
    end if;

   if material.phasechange then
     (ud, Td, dT_du) = Buildings.HeatTransfer.Conduction.BaseClasses.der_temperature_u(
       c =  material.c,
       TSol=material.TSol,
       TLiq=material.TLiq,
       LHea=material.LHea,
       ensureMonotonicity=material.ensureMonotonicity);
   else
     ud    = zeros(Buildings.HeatTransfer.Conduction.nSupPCM);
     Td    = zeros(Buildings.HeatTransfer.Conduction.nSupPCM);
     dT_du = zeros(Buildings.HeatTransfer.Conduction.nSupPCM);
   end if;
equation
    port_a.Q_flow = +Q_flow[1];
    port_b.Q_flow = -Q_flow[end];

    port_a.T-T[1]    = if stateAtSurface_a then 0 else Q_flow[1]*RNod[1];
    T[nSta]-port_b.T = if stateAtSurface_b then 0 else Q_flow[end]*RNod[end];

    for i in 1:nSta-1 loop
       // Q_flow[i+1] is heat flowing from (i) to (i+1)
       // because T[1] has Q_flow[1] and Q_flow[2] acting on it.
       T[i]-T[i+1] = Q_flow[i+1]*RNod[i+1];
    end for;

    // Steady-state heat balance
    if material.steadyState then
      for i in 2:nSta+1 loop
        Q_flow[i] = port_a.Q_flow;
      end for;

      for i in 1:nSta loop
        if material.phasechange then
          // Phase change material
          T[i]=Buildings.HeatTransfer.Conduction.BaseClasses.temperature_u(
                    ud=ud,
                    Td=Td,
                    dT_du=dT_du,
                    u=u[i]);
        else
          // Regular material
          u[i]=0; // u is not required in this case
        end if;
      end for;
    else
      // Transient heat conduction
      if material.phasechange then
        // Phase change material
        for i in 1:nSta loop
          der(u[i]) = (Q_flow[i]-Q_flow[i+1])*mInv[i];
          // Recalculation of temperature based on specific internal energy
          T[i]=Buildings.HeatTransfer.Conduction.BaseClasses.temperature_u(
                    ud=ud,
                    Td=Td,
                    dT_du=dT_du,
                    u=u[i]);
        end for;
      else
        // Regular material
        for i in 1:nSta loop
          der(T[i]) = (Q_flow[i]-Q_flow[i+1])*CInv[i];
        end for;
        for i in 1:nSta loop
          u[i]=0; // u is not required in this case
        end for;
      end if;
    end if;

  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=false,extent={{-100,-100},{100,100}}), graphics={
        Text(
          extent={{-100,-80},{6,-98}},
          textColor={0,0,255},
          textString="%material.x"),
        Text(
          extent={{8,-74},{86,-104}},
          textColor={0,0,255},
          textString="%nSta"),
   Rectangle(
    extent={{-60,80},{60,-80}},     fillColor={215,215,215},
   fillPattern=FillPattern.Solid,    lineColor={175,175,175}),
   Line(points={{-92,0},{90,0}},      color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),
   Line(points={{8,-40},{-6,-40}},        color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),
   Line(points={{14,-32},{-12,-32}},      color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),            Line(
          points={{0,0},{0,-32}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),       Rectangle(extent={{-40,6},{-20,-6}},
   lineColor = {0, 0, 0}, lineThickness =  0.5, fillColor = {255, 255, 255},
   fillPattern = FillPattern.Solid), Rectangle(extent={{20,6},{40,-6}},
   lineColor = {0, 0, 0}, lineThickness =  0.5, fillColor = {255, 255, 255},
   fillPattern = FillPattern.Solid),
   Line(points={{66,-40},{52,-40}},       color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None,
   visible=stateAtSurface_b),
   Line(points={{72,-32},{46,-32}},       color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None,
   visible=stateAtSurface_b),            Line(points={{59,0},{59,-32}},
   color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None,
   visible=stateAtSurface_b),
   Line(points={{-59,0},{-59,-32}},
   color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None,
   visible=stateAtSurface_a),
   Line(points={{-46,-32},{-72,-32}},     color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None,
   visible=stateAtSurface_a),
   Line(points={{-52,-40},{-66,-40}},     color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None,
   visible=stateAtSurface_a)}),
defaultComponentName="lay",
    Documentation(info="<html>
<p>
This is a model of a heat conductor for a single layer of homogeneous material
that computes transient or steady-state heat conduction.
</p>
<h4>Main equations</h4>
<h5>Transient heat conduction in materials without phase change</h5>
<p>
If the material is a record that extends
<a href=\"modelica://Buildings.HeatTransfer.Data.Solids\">
Buildings.HeatTransfer.Data.Solids</a> and its
specific heat capacity (as defined by the record <code>material.c</code>)
is non-zero, then this model computes <i>transient</i> heat conduction, i.e., it
computes a numerical approximation to the solution of the heat equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
   &rho; c (&part; T(s,t) &frasl; &part;t) =
    k (&part;&sup2; T(s,t) &frasl; &part;s&sup2;),
</p>
<p>
where
<i>&rho;</i>
is the mass density,
<i>c</i>
is the specific heat capacity per unit mass,
<i>T</i>
is the temperature at location <i>s</i> and time <i>t</i> and
<i>k</i> is the heat conductivity.
At the locations <i>s=0</i> and <i>s=x</i>, where <i>x</i> is the
material thickness, the temperature and heat flow rate is equal to the
temperature and heat flow rate of the heat ports.
</p>
<h5>Transient heat conduction in phase change materials</h5>
<p>
If the material is declared using a record of type
<a href=\"modelica://Buildings.HeatTransfer.Data.SolidsPCM\">
Buildings.HeatTransfer.Data.SolidsPCM</a>, the heat transfer
in a phase change material is computed.
The record <a href=\"modelica://Buildings.HeatTransfer.Data.SolidsPCM\">
Buildings.HeatTransfer.Data.SolidsPCM</a>
declares the solidus temperature <code>TSol</code>,
the liquidus temperature <code>TLiq</code> and the latent heat of
phase transformation <code>LHea</code>.
For heat transfer with phase change, the specific internal energy <i>u</i>
is the dependent variable, rather than the temperature.
Therefore, the governing equation is
</p>
<p align=\"center\" style=\"font-style:italic;\">
   &rho; (&part; u(s,t) &frasl; &part;t) =
    k (&part;&sup2; T(s,t) &frasl; &part;s&sup2;).
</p>
<p>
The constitutive
relation between specific internal energy <i>u</i> and temperature <i>T</i> is defined in
<a href=\"modelica://Buildings.HeatTransfer.Conduction.BaseClasses.temperature_u\">
Buildings.HeatTransfer.Conduction.BaseClasses.temperature_u</a> by using
cubic hermite spline interpolation with linear extrapolation.
</p>
<h5>Steady-state heat conduction</h5>
<p>
If <code>material.c=0</code>, or if the material extends
<a href=\"modelica://Buildings.HeatTransfer.Data.Resistances\">
Buildings.HeatTransfer.Data.Resistances</a>,
then steady-state heat conduction is computed. In this situation, the heat
flow between its heat ports is
</p>
<p align=\"center\" style=\"font-style:italic;\">
   Q = A &nbsp; k &frasl; x &nbsp; (T<sub>a</sub>-T<sub>b</sub>),
</p>
<p>
where
<i>A</i> is the cross sectional area,
<i>x</i> is the layer thickness,
<i>T<sub>a</sub></i> is the temperature at port a and
<i>T<sub>b</sub></i> is the temperature at port b.
</p>
<h5>Spatial discretization</h5>
<p>
To spatially discretize the heat equation, the construction is
divided into compartments (control volumes) with <code>material.nSta &ge; 1</code> state variables.
Each control volume has the same material properties.
The state variables are connected to each other through thermal resistances.
If <code>stateAtSurface_a = true</code>, a state is placed
at the surface a, and similarly, if
<code>stateAtSurface_b = true</code>, a state is placed
at the surface b.
Otherwise, these states are placed inside the material, away
from the surface.
Thus, to obtain
the surface temperature, use <code>port_a.T</code> (or <code>port_b.T</code>)
and not the variable <code>T[1]</code>.
</p>

As an example, we assume a material with a length of <code>x</code>
and a discretization with four state variables.
<ul>
<li>
If <code>stateAtSurface_a = false</code> and <code>stateAtSurface_b = false</code>,
then each of the four state variables is placed in the middle of a control volume with length <code>l=x/material.nSta</code>.
<p align=\"left\"><img alt=\"image\" src=\"modelica://Buildings/Resources/Images/HeatTransfer/Conduction/noStateAtSurface.svg\"/>
</li>
<li>
If <code>stateAtSurface_a = true</code> or <code>stateAtSurface_b = true</code>,
then one state is placed on the surface of the material. Each of the remaining three states
is placed in the middle of a control volume with length <code>l=x/(material.nSta-1)</code>.
<p align=\"left\"><img alt=\"image\" src=\"modelica://Buildings/Resources/Images/HeatTransfer/Conduction/oneStateAtSurface.svg\"/>
</li>
<li>
If <code>stateAtSurface_a = true</code> and <code>stateAtSurface_b = true</code>,
then two states are placed on the surfaces of the material. Each of the remaining two states is placed
in the middle of a control volume with length <code>l=x/(material.nSta-2)</code>.
<p align=\"left\"><img alt=\"image\" src=\"modelica://Buildings/Resources/Images/HeatTransfer/Conduction/twoStatesAtSurface.svg\"/>
</li>
</ul>

<p>
To build multi-layer constructions,
use
<a href=\"modelica://Buildings.HeatTransfer.Conduction.MultiLayer\">
Buildings.HeatTransfer.Conduction.MultiLayer</a> instead of this model.
</p>
<h4>Important parameters</h4>
<p>
The parameters <code>stateAtSurface_a</code> and
<code>stateAtSurface_b</code>
determine whether there is a state variable at these surfaces,
as described above.
Note that if <code>stateAtSurface_a = true</code>,
then there is temperature state on the surface a with prescribed
value, as determined by the differential equation of the heat conduction.
Hence, in this situation, it is not possible to
connect a temperature boundary condition such as
<a href=\"modelica://Buildings.HeatTransfer.Sources.FixedTemperature\">
Buildings.HeatTransfer.Sources.FixedTemperature</a> as this would
yield to specifying the same temperature twice.
To avoid this, either set <code>stateAtSurface_a = false</code>,
or place a thermal resistance
between the boundary condition and the surface of this model.
The same applies for surface b.
See the examples in
<a href=\"modelica://Buildings.HeatTransfer.Examples\">
Buildings.HeatTransfer.Examples</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
August 27, 2019, by Michael Wetter:<br/>
Removed assertion on geometry.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1529\">issue 1529</a>.
</li>
<li>
November 22, 2016, by Thierry S. Nouidui:<br/>
Fix bug in mass balance.
</li>
<li>
November 17, 2016, by Thierry S. Nouidui:<br/>
Added parameter <code>nSta2</code> to avoid translation error
in Dymola 2107. This is a work-around for a bug in Dymola
which will be addressed in future releases.
</li>
<li>
November 11, 2016, by Thierry S. Nouidui:<br/>
Revised the implementation for adding a state at the surface.
</li>
<li>
October 29, 2016, by Michael Wetter:<br/>
Added option to place a state at the surface.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/565\">issue 565</a>.
</li>
<li>
March 1, 2016, by Michael Wetter:<br/>
Removed test for equality of <code>Real</code> variables.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/493\">issue 493</a>.
</li>
<li>
May 21, 2015, by Michael Wetter:<br/>
Reformulated function to reduce use of the division macro
in Dymola.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/417\">issue 417</a>.
</li>
<li>
October 17, 2014, by Michael Wetter:<br/>
Changed the input argument for the function
<code>Buildings.HeatTransfer.Conduction.BaseClasses.der_temperature_u</code>
from type
<code>Buildings.HeatTransfer.Data.BaseClasses.Material</code>
to the elements of this type as OpenModelica fails to translate the
model if the input to this function is a record.
</li>
<li>
May 30, 2014, by Michael Wetter:<br/>
Removed undesirable annotation <code>Evaluate=true</code>.
</li>
<li>
January 22, 2013, by Armin Teskeredzic:<br/>
Implementation of phase-change materials based on enthalpy-linearisation method.
Phase-change properties defined in <code>material</code> record and relationship
between enthalpy and temperature defined in the <code>EnthalpyTemperature</code> function.
</li>
<li>
March 9, 2012, by Michael Wetter:<br/>
Removed protected variable <code>der_T</code> as it is not required.
</li>
<li>
March 6 2010, by Michael Wetter:<br/>
Changed implementation to allow steady-state and transient heat conduction
depending on the specific heat capacity of the material. This allows using the
same model in composite constructions in which some layers are
computed steady-state and other transient.
</li><li>
February 5 2009, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleLayer;
