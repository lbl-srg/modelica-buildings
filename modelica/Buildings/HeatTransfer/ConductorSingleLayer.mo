within Buildings.HeatTransfer;
model ConductorSingleLayer "Model for single layer heat conductance"
  extends Buildings.HeatTransfer.BaseClasses.PartialConductor(
   final R=if (material.R == 0) then material.x/material.k/A else material.R/A);
   // if material.R == 0, then the material specifies material.k, and this model specifies x
   // For resistances, material.k need not be specified, and hence we use material.R
  // The value T[:].start is used by the solver when finding initial states
  // that satisfy dT/dt=0, which requires solving a system of nonlinear equations
  // if the convection coefficient is a function of temperature.
  Modelica.SIunits.Temperature T[nSta](start=
     {T_a_start+(T_b_start-T_a_start) * UA * sum(1/G[k] for k in 1:i) for i in 1:nSta})
    "Temperature at the states";
  Modelica.SIunits.HeatFlowRate Q_flow[nSta+1]
    "Heat flow rate from state i to i+1";

  replaceable parameter Data.BaseClasses.Material material
    "Material from Data.Solids or Data.Resistances"
    annotation (choicesAllMatching=true);

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
  parameter Modelica.SIunits.HeatCapacity C = A*material.x*material.d*material.c/material.nSta
    "Heat capacity associated with the temperature state";
  // nodes at surface have only 1/2 the layer thickness
  final parameter Modelica.SIunits.ThermalConductance G[nSta+1]={
  UA*nSta * (if (i==1 or i==(nSta+1)) then 2 else 1) for i in 1:nSta+1}
    "Thermal conductance of layer between the states";
  Modelica.SIunits.TemperatureSlope der_T[nSta]
    "Time derivative of temperature (= der(T))";
  final parameter Integer nSta(min=1) = material.nSta
    "Number of state variables";
initial equation
  // The initialization is only done for materials that store energy.
  if not material.steadyState then
    if steadyStateInitial then
      der_T = zeros(nSta);
    else
      for i in 1:nSta loop
        T[i] = T_a_start+(T_b_start-T_a_start) * UA * sum(1/G[k] for k in 1:i);
      end for;
      end if;
   end if;

equation
    port_a.Q_flow = +Q_flow[1];
    port_b.Q_flow = -Q_flow[nSta+1];

    Q_flow[1]      = G[1]      * (port_a.T-T[1]);
    Q_flow[nSta+1] = G[nSta+1] * (T[nSta] -port_b.T);
    for i in 2:nSta loop
       // Q_flow[i] is heat flowing from (i-1) to (i)
       Q_flow[i] = G[i] * (T[i-1]-T[i]);
    end for;
    if material.steadyState then
      der_T = zeros(nSta);
      for i in 2:nSta+1 loop
        Q_flow[i] = Q_flow[1];
      end for;
      else
        for i in 1:nSta loop
          der(T[i]) = (Q_flow[i]-Q_flow[i+1])/C;
          der_T[i] = der(T[i]);
        end for;
    end if;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
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
    Documentation(info="<html>
This is a model of a heat conductor for a single material.
If the material is a record that extends
<a href=\"modelica://Buildings.HeatTransfer.Data.Solids\">
Buildings.HeatTransfer.Data.Solids</a> and its
specific heat capacity (as defined by the record <tt>material.c</tt>)
is non-zero, then this model computes <i>transient</i> heat conduction.
If <tt>material.c=0</tt>, or if the material extends
<a href=\"modelica://Buildings.HeatTransfer.Data.Resistances\">
Buildings.HeatTransfer.Data.Resistances</a>, 
then steady-state heat conduction is computed.
</p>
<p>
The construction has <tt>material.nSta &ge; 1</tt> state variables. The state variables
are connected to each other through thermal conductors. There is also a thermal conductor
between the surfaces and the outermost state variables. Thus, to obtain
the surface temperature, use <tt>port_a.T</tt> (or <tt>port_b.T</tt>)
and not the variable <tt>T[1]</tt>.
</p>
<p>
The thickness of the construction is divided into <tt>nLay &ge; 1</tt> layers
of equal material properties.
To build multi-layer constructions,
use
<a href=\"Buildings.HeatTransfer.ConductorMultiLayer\">
Buildings.HeatTransfer.ConductorMultiLayer</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 6 2010, by Michael Wetter:<br>
Changed implementation to allow steady-state and transient heat conduction
depending on the specific heat capacity of the material. This allows using the
same model in composite constructions in which some layers are
computed steady-state and other transient.
</li><li>
February 5 2009, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end ConductorSingleLayer;
