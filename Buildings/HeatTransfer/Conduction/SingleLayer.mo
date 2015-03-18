within Buildings.HeatTransfer.Conduction;
model SingleLayer "Model for single layer heat conductance"
  extends Buildings.HeatTransfer.Conduction.BaseClasses.PartialConductor(
   final R=if (material.R == 0) then material.x/material.k/A else material.R/A);
   // if material.R == 0, then the material specifies material.k, and this model specifies x
   // For resistances, material.k need not be specified, and hence we use material.R
  // The value T[:].start is used by the solver when finding initial states
  // that satisfy dT/dt=0, which requires solving a system of nonlinear equations
  // if the convection coefficient is a function of temperature.
  Modelica.SIunits.Temperature T[nSta](start=
     {T_a_start+(T_b_start-T_a_start) * UA *
        sum(1/(if (k==1 or k==nSta+1) then UAnSta2 else UAnSta) for k in 1:i) for i in 1:nSta},
      each nominal = 300) "Temperature at the states";
  Modelica.SIunits.HeatFlowRate Q_flow[nSta+1]
    "Heat flow rate from state i to i+1";
  Modelica.SIunits.SpecificInternalEnergy u[nSta](start=
     material.c*{T_a_start+(T_b_start-T_a_start) * UA *
        sum(1/(if (k==1 or k==nSta+1) then UAnSta2 else UAnSta) for k in 1:i) for i in 1:nSta},
        each nominal = 270000)
    "Definition of specific internal energy (enthalpy in solids)!";
  replaceable parameter Data.BaseClasses.Material material
    "Material from Data.Solids, Data.SolidsPCM or Data.Resistances"
    annotation (choicesAllMatching=true, Placement(transformation(extent={{60,60},
            {80,80}})));

  parameter Boolean steadyStateInitial=false
    "=true initializes dT(0)/dt=0, false initializes T(0) at fixed temperature using T_a_start and T_b_start"
        annotation (Dialog(group="Initialization"), Evaluate=true);
  parameter Modelica.SIunits.Temperature T_a_start=293.15
    "Initial temperature at port_a, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));
  parameter Modelica.SIunits.Temperature T_b_start=293.15
    "Initial temperature at port_b, used if steadyStateInitial = false"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial));

protected
  final parameter Integer nSta(min=1) = material.nSta
    "Number of state variables";
  final parameter Modelica.SIunits.ThermalConductance UAnSta = UA*nSta
    "Thermal conductance between nodes";
  final parameter Modelica.SIunits.ThermalConductance UAnSta2 = 2*UAnSta
    "Thermal conductance between nodes and surface boundary";
  parameter Modelica.SIunits.Mass m = A*material.x*material.d/material.nSta
    "Mass associated with the temperature state";
  parameter Modelica.SIunits.HeatCapacity C = m*material.c
    "Heat capacity associated with the temperature state";

  parameter Modelica.SIunits.SpecificInternalEnergy ud[Buildings.HeatTransfer.Conduction.nSupPCM](each fixed=false)
    "Support points for derivatives (used for PCM)";
  parameter Modelica.SIunits.Temperature Td[Buildings.HeatTransfer.Conduction.nSupPCM](each fixed=false)
    "Support points for derivatives (used for PCM)";
  parameter Real dT_du[Buildings.HeatTransfer.Conduction.nSupPCM](each fixed=false, each unit="kg.K2/J")
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
        for i in 1:nSta loop
          T[i] = T_a_start+(T_b_start-T_a_start) * UA *
            sum(1/(if (k==1 or k==nSta+1) then UAnSta2 else UAnSta) for k in 1:i);
        end for;
      end if;
    end if;

   if material.phasechange then
     (ud, Td, dT_du) = Buildings.HeatTransfer.Conduction.BaseClasses.der_temperature_u(
       c=   material.c,
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
    port_b.Q_flow = -Q_flow[nSta+1];

    port_a.T-T[1] = Q_flow[1]/UAnSta2;
    T[nSta] -port_b.T = Q_flow[nSta+1]/UAnSta2;

    for i in 2:nSta loop
       // Q_flow[i] is heat flowing from (i-1) to (i)
       T[i-1]-T[i] = Q_flow[i]/UAnSta;
    end for;

    // Steady-state heat balance
    if material.steadyState then
      for i in 2:nSta+1 loop
        Q_flow[i] = Q_flow[1];
        if material.phasechange then
          // Phase change material
          T[i-1]=Buildings.HeatTransfer.Conduction.BaseClasses.temperature_u(
                    ud=ud,
                    Td=Td,
                    dT_du=dT_du,
                    u=u[i-1]);
        else
          // Regular material
          u[i-1]=material.c*T[i-1];
        end if;
      end for;
    else
      // Transient heat conduction
      if material.phasechange then
        // Phase change material
        for i in 1:nSta loop
          der(u[i]) = (Q_flow[i]-Q_flow[i+1])/m;
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
          der(T[i]) = (Q_flow[i]-Q_flow[i+1])/C;
          u[i]=material.c*T[i];
        end for;
      end if;
    end if;

  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=false,extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-94,4},{92,-4}},
          lineColor={0,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{12,8},{14,8},{16,4},{18,-2},{18,-6},{16,-12},{10,-16},{6,-20},
              {-2,-22},{-6,-18},{-12,-12},{-14,-2},{-12,4},{-10,8},{-8,10},{-6,
              12},{-2,14},{2,14},{8,12},{12,8}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-6,-16},{2,-18},{8,-16},{14,-14},{10,-16},{6,-20},{-2,-22},{
              -8,-20},{-12,-12},{-14,-2},{-12,4},{-10,8},{-8,10},{-10,0},{-10,-8},
              {-6,-16}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,54},{-42,-60}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{-100,-74},{6,-92}},
          lineColor={0,0,255},
          textString="%x"),
        Rectangle(
          extent={{44,54},{62,-60}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Text(
          extent={{8,-68},{86,-98}},
          lineColor={0,0,255},
          textString="%nSta")}),
defaultComponentName="lay",
    Documentation(info="<html>
This is a model of a heat conductor for a single layer of homogeneous material
that computes transient or steady-state heat conduction.

<h4>Transient heat conduction in materials without phase change</h4>
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
<h4>Transient heat conduction in phase change materials</h4>
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
<a href=\"modelica://Buildings.HeatTransfer.Conduction.BaseClasses.enthalpyTemperature\">
Buildings.HeatTransfer.Conduction.BaseClasses.enthalyTemperature</a> by using
cubic hermite spline interpolation with linear extrapolation.
</p>
<h4>Steady-state heat conduction</h4>
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
<h4>Spatial discretization</h4>
<p>
To spatially discretize the heat equation, the construction is
divided into compartments with <code>material.nSta &ge; 1</code> state variables.
The state variables are connected to each other through thermal conductors.
There is also a thermal conductor
between the surfaces and the outermost state variables. Thus, to obtain
the surface temperature, use <code>port_a.T</code> (or <code>port_b.T</code>)
and not the variable <code>T[1]</code>.
Each compartment has the same material properties.
To build multi-layer constructions,
use
<a href=\"Buildings.HeatTransfer.Conduction.MultiLayer\">
Buildings.HeatTransfer.Conduction.MultiLayer</a> instead of this model.
</p>

</html>",
revisions="<html>
<ul>
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
