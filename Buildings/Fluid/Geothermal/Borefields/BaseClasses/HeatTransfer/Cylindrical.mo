within Buildings.Fluid.Geothermal.Borefields.BaseClasses.HeatTransfer;
model Cylindrical
  "Heat conduction in a cylinder using the radial discretization as advised by Eskilson"

  parameter Buildings.Fluid.Geothermal.Borefields.Data.Soil.Template soiDat
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  parameter Modelica.Units.SI.Height h "Height of the cylinder";
  parameter Modelica.Units.SI.Radius r_a "Internal radius";
  parameter Modelica.Units.SI.Radius r_b "External radius";
  parameter Integer nSta(min=1) = 10 "Number of state variables";
  parameter Modelica.Units.SI.Temperature TInt_start
    "Initial temperature at port_a, used if steadyStateInitial = false and the material stores energy"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial and
        not soiDat.steadyState));
  parameter Modelica.Units.SI.Temperature TExt_start
    "Initial temperature at port_b, used if steadyStateInitial = false and the material stores energy"
    annotation (Dialog(group="Initialization", enable=not steadyStateInitial and
        not soiDat.steadyState));
  parameter Boolean steadyStateInitial=false
    "true initializes dT(0)/dt=0, false initializes T(0) at fixed temperature using T_a_start and T_b_start"
    annotation (Dialog(group="Initialization", enable=not soiDat.steadyState),
    Evaluate=true);

  parameter Real gridFac(min=1) = 2 "Grid factor for spacing";

  parameter Modelica.Units.SI.Time tMinEsk(min=0) = 60
    "Shortest time for which the grid resolves the depth of thermal penetration"
    annotation (Evaluate=true, Dialog(tab="Advanced", group="Radial grid"));

  parameter Modelica.Units.SI.Radius r[nSta + 1](each fixed=false)
    "Radius to the boundary of the i-th domain";

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a(T(start=TInt_start))
    "Heat port at surface a" annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}, rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b(T(start=TExt_start))
    "Heat port at surface b" annotation (Placement(transformation(extent={{90,-10},
            {110,10}},rotation=0)));

  Modelica.Units.SI.Temperature T[nSta](start={TInt_start + (TExt_start -
        TInt_start)/Modelica.Math.log(r_b/r_a)*Modelica.Math.log((r_a + (r_b -
        r_a)/(nSta)*(i - 0.5))/r_a) for i in 1:nSta})
    "Temperature of the states";

  Modelica.Units.SI.TemperatureDifference dT "port_a.T - port_b.T";

  Modelica.Units.SI.HeatFlowRate Q_flow[nSta + 1]
    "Heat flow rate from state i to i+1";

protected
  parameter Modelica.Units.SI.Radius rC[nSta](each fixed=false)
    "Radius to the center of the i-th domain";

  final parameter Modelica.Units.SI.SpecificHeatCapacity c=soiDat.cSoi
    "Specific heat capacity";
  final parameter Modelica.Units.SI.ThermalConductivity k=soiDat.kSoi
    "Thermal conductivity of the material";
  final parameter Modelica.Units.SI.Density d=soiDat.dSoi
    "Density of the material";

  parameter Modelica.Units.SI.ThermalConductance G[nSta + 1](each fixed=false)
    "Heat conductance between the temperature nodes";
  parameter Modelica.Units.SI.HeatCapacity C[nSta](each fixed=false)
    "Heat capacity of each state";

  parameter Real gridFac_sum(fixed=false);
  parameter Real gridFac_sum_old(fixed=false);

  final parameter Modelica.Units.SI.Length dREsk(fixed=false)
    "Thickness of each of the three cells that are adjacent to the inner surface";

initial algorithm
  gridFac_sum := 0;
  gridFac_sum_old := 0;
  for i in 0:(if nSta >= 4 then nSta - 4 else nSta - 1) loop
    gridFac_sum := gridFac_sum_old + gridFac^i;
    gridFac_sum_old := gridFac_sum;
  end for;

initial equation
  assert(0 < r_a, "Error: Model requires 0 < r_a.");
  assert(r_a < r_b, "Error: Model requires r_a < r_b.");
  assert(0 < k, "Error: Model requires 0 < k, but k=" + String(k) + ".");
  assert(0 < h, "Error: Model requires 0 < h, but h=" + String(h) + ".");

  // Thickness of the three cells that are adjacent to the inner surface. As
  // advised by Eskilson (1987), these cells have a thickness equal to the
  // depth of thermal penetration sqrt(a*tMinEsk), where a = k/(c*d) is the
  // thermal diffusivity and tMinEsk is the shortest time for which the grid
  // is designed to resolve the temperature profile. If the domain
  // r_b - r_a is too thin to accommodate these three cells, then their
  // thickness is reduced to (r_b - r_a)/nSta. This cap is also active if the
  // material does not store energy, since then the thermal diffusivity is
  // unbounded. Note that in steady state, the heat flow rate at the ports is
  // independent of the grid, as asserted below.
  dREsk = if c*d > Modelica.Constants.eps then
            min(sqrt(tMinEsk*k/(c*d)), (r_b - r_a)/nSta)
          else
            (r_b - r_a)/nSta;
  assert(0 < dREsk,
    "Error: The thickness of the cells that are adjacent to the inner surface is zero. Check tMinEsk, and note that the model requires r_a < r_b.");

  // ****************** Comments *********************:
  // The domain r_b - r_a is divided into nSta segments. Following Eskilson,
  // the three segments that are adjacent to r_a have the thickness dREsk,
  // whereas the thickness of the remaining segments grows geometrically with
  // base gridFac >= 1, namely
  //   r[i] = r[i-1] + (r_b - r[4]) * gridFac^(i-5) / gridFac_sum,
  //   gridFac_sum = sum(gridFac^k, k=0..nSta-4),
  // which is equivalent to
  //   r[i] = r[i-1] + (r_b - r[4]) * (1-gridFac)/(1-gridFac^(nSta-3)) * gridFac^(i-5).
  // Since gridFac >= 1 and r_b > r_a, all increments are positive, and since
  // they sum to r_b - r[4], the last boundary is r[nSta+1] = r_b.
  //
  // If nSta < 4, then there are not enough segments to also allocate the three
  // segments of thickness dREsk. In this case, a purely geometric grid is used:
  //   r[1] = r_a,
  //   r[i] = r[i-1] + (r_b - r_a) * gridFac^(i-2) / gridFac_sum,
  //   gridFac_sum = sum(gridFac^k, k=0..nSta-1),
  // which is equivalent to
  //   r[i] = r[i-1] + (r_b - r_a) * (1-gridFac)/(1-gridFac^nSta) * gridFac^(i-2).
  r[1] = r_a;
  if nSta < 4 then
    for i in 2:nSta + 1 loop
      r[i] = r[i - 1] + (r_b - r_a)/gridFac_sum*gridFac^(i - 2);
    end for;
  else
    for i in 2:4 loop
      r[i] = r_a + (i - 1)*dREsk;
    end for;
    for i in 5:nSta + 1 loop
      r[i] = r[i - 1] + (r_b - r[4])/gridFac_sum*gridFac^(i - 5);
    end for;
  end if;
  assert(abs(r[nSta + 1] - r_b) < 1E-6*(r_b - r_a),
    "Error: Wrong computation of radius. r[nSta+1]=" + String(r[nSta + 1]));
  assert(min(r[2:nSta + 1] - r[1:nSta]) > 0,
    "Error: The radial grid is not strictly increasing, and the smallest increment is "
      + String(min(r[2:nSta + 1] - r[1:nSta])));

  // Radii at middle of resistance
  for i in 1:nSta loop
    rC[i] = (r[i] + r[i + 1])/2;
  end for;

  // Conductance between nodes (which are in the center of the domain)
  G[1] = 2*Modelica.Constants.pi*k*h/Modelica.Math.log(rC[1]/r_a);
  G[nSta + 1] = 2*Modelica.Constants.pi*k*h/Modelica.Math.log(r_b/rC[nSta]);
  for i in 2:nSta loop
    G[i] = 2*Modelica.Constants.pi*k*h/Modelica.Math.log(rC[i]/rC[i - 1]);
  end for;
  // The thermal resistances of the segments are in series. Hence, for any
  // strictly increasing grid, they telescope to the analytical steady-state
  // resistance log(r_b/r_a)/(2*pi*k*h). Assert this identity, which also
  // ensures that the heat flow rate at the ports is independent of nSta,
  // gridFac and tMinEsk in steady state.
  assert(abs(2*Modelica.Constants.pi*k*h/Modelica.Math.log(r_b/r_a)
      - 1/sum({1/G[i] for i in 1:nSta + 1}))
      < 1E-6*2*Modelica.Constants.pi*k*h/Modelica.Math.log(r_b/r_a),
    "Error: The thermal resistances of the discretization do not sum to the analytical steady-state resistance of the cylinder.");

  // Heat capacity of each segment
  for i in 1:nSta loop
    C[i] = (d*Modelica.Constants.pi*c*h*((r[i + 1])^2 - (r[i])^2));
  end for;
  // The initialization is only done for materials that store energy.
  if not soiDat.steadyState then
    if steadyStateInitial then
      der(T) = zeros(nSta);
    else
      for i in 1:nSta loop
        T[i] = TInt_start + (TExt_start - TInt_start)/Modelica.Math.log(r_b/r_a)
          *Modelica.Math.log(rC[i]/r_a);
      end for;
    end if;
  end if;
equation
  dT = port_a.T - port_b.T;
  port_a.Q_flow = +Q_flow[1];
  port_b.Q_flow = -Q_flow[nSta + 1];
  Q_flow[1] = G[1]*(port_a.T - T[1]);
  Q_flow[nSta + 1] = G[nSta + 1]*(T[nSta] - port_b.T);
  for i in 2:nSta loop
    Q_flow[i] = G[i]*(T[i - 1] - T[i]);
    // Q_flow[i] represents the heat flowing between two nodes
  end for;
  if soiDat.steadyState then
    for i in 2:nSta + 1 loop
      Q_flow[i] = Q_flow[1];
    end for;
  else
    for i in 1:nSta loop
      der(T[i]) = (Q_flow[i] - Q_flow[i + 1])/C[i];
    end for;
  end if;
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}), graphics),
    Icon(coordinateSystem(preserveAspectRatio=false,extent={{-100,-100},{100,100}}),
                    graphics={
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
        Text(
          extent={{-110,-74},{-26,-86}},
          textColor={0,0,255},
          textString="%r_a"),
        Text(
          extent={{-22,-62},{20,-76}},
          textColor={0,0,255},
          textString="%nSta"),
        Text(
          extent={{16,-76},{102,-88}},
          textColor={0,0,255},
          textString="%r_b"),
        Polygon(
          points={{-50,60},{-38,34},{-32,0},{-36,-30},{-50,-60},{-62,-60},{-48,
              -30},{-44,0},{-50,34},{-62,60},{-50,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Backward,
          fillColor={175,175,175}),
        Polygon(
          points={{52,60},{64,34},{70,0},{66,-30},{52,-60},{40,-60},{54,-30},{
              58,0},{52,34},{40,60},{52,60}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillPattern=FillPattern.Backward,
          fillColor={175,175,175}),
        Text(
          extent={{-100,100},{100,60}},
          textColor={0,0,255},
          textString="%name")}),
    defaultComponentName="lay",
    Documentation(info="<html>
<p>
Model for radial heat transfer in a hollow cylinder.
</p>
<p>
If the heat capacity of the material is non-zero, then this model computes transient heat conduction, i.e., it
computes a numerical approximation to the solution of the heat equation
</p>
<p align=\"center\" style=\"font-style:italic;\">
   &rho; c ( &part; T(r,t) &frasl; &part;t ) = 
    k ( &part;&sup2; T(r,t) &frasl; &part;r&sup2; + 1 &frasl; r &nbsp;  &part; T(r,t) &frasl; &part;r ),
</p>
<p>
where 
<i>&rho;</i>
is the mass density,
<i>c</i>
is the specific heat capacity per unit mass,
<i>T</i>
is the temperature at location <i>r</i> and time <i>t</i> and
<i>k</i> is the heat conductivity. 
At the locations <i>r=r<sub>a</sub></i> and <i>r=r<sub>b</sub></i>, 
the temperature and heat flow rate are equal to the 
temperature and heat flow rate of the heat ports.
</p>
<p>
If the heat capacity of the material is set to zero, then steady-state heat flow is computed using
</p>
<p align=\"center\" style=\"font-style:italic;\">
   Q = 2 &pi; k h (T<sub>a</sub>-T<sub>b</sub>)&frasl; ln(r<sub>b</sub> &frasl; r<sub>a</sub>),
</p>
<p>
where
<i>r<sub>a</sub></i> is the internal radius,
<i>r<sub>b</sub></i> is the external radius,
<i>h</i> is the height of the cylinder,
<i>T<sub>a</sub></i> is the temperature at port a and
<i>T<sub>b</sub></i> is the temperature at port b.
In this case, the parameters <code>TInt_start</code>, <code>TExt_start</code> and
<code>steadyStateInitial</code> have no effect, as the temperature profile is
determined by the temperatures at the ports.
</p>
<h4>Implementation</h4>
<p>
To spatially discretize the heat equation, the construction is 
divided into compartments with <code>nSta &ge; 1</code> state variables. 
The state variables are connected to each other through thermal conductors. 
There is also a thermal conductor
between the surfaces and the outermost state variables. Thus, to obtain
the surface temperature, use <code>port_a.T</code> (or <code>port_b.T</code>)
and not the variable <code>T[1]</code>.
</p>
<h4>Radial grid</h4>
<p>
The radial grid is as proposed by Eskilson (1987): The three cells that are adjacent
to the inner surface have the thickness
</p>
<p align=\"center\" style=\"font-style:italic;\">
   &Delta;r = &radic;(a t<sub>Min</sub>),
</p>
<p>
where <i>a = k/(&rho;c)</i> is the thermal diffusivity and
<i>t</i><sub>Min</sub> = <code>tMinEsk</code> is the shortest time for which the grid
resolves the temperature profile. The thickness of the remaining cells grows
geometrically with the factor <code>gridFac &ge; 1</code>, such that the last cell
boundary is at <code>r_b</code>.
</p>
<p>
If <code>r_b - r_a</code> is too small to accommodate the three cells of thickness
<code>dREsk</code>, then their thickness is capped at
<code>(r_b - r_a)/nSta</code>. This cap is also active if the heat capacity of the
material is zero, since in this case the thermal diffusivity is unbounded.
For <code>nSta &lt; 4</code>, there are not enough cells to also allocate the three
inner cells, in which case a purely geometric grid is used.
In any of these cases, the grid is strictly increasing, and the sum of the thermal
resistances of the cells equals the analytical steady-state resistance
<span style=\"font-style:italic;\">ln(r<sub>b</sub>/r<sub>a</sub>)/(2&pi;kh)</span>.
The latter is asserted, which ensures that in steady state, the heat flow rate at the
ports does not depend on <code>nSta</code>, <code>gridFac</code> or
<code>tMinEsk</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
November 20, 2026, by Michael Wetter:<br/>
Revised the radial discretization so that the grid proposed by Eskilson is used irrespective of the
heat capacity of the material, which removes the previously separate grid for
<code>soiDat.steadyState = true</code>. Furthermore, added the parameter <code>tMinEsk</code>, and
assertions on the positivity of <code>k</code> and <code>h</code>, on the monotonicity of the grid,
and on the sum of the thermal resistances being equal to the analytical steady-state resistance.
</li>
<li>
November 15, 2026, by Michael Wetter:<br/>
Guarded the radial grid calculation for steady-state conduction (<code>c == 0</code>), small domain thickness <code>r_b - r_a</code>, and <code>nSta &lt; 4</code>.
</li>
<li>
January, 2014, by Damien Picard:<br/>
Modify the discretization of the cilindrical layer so that the first three layers have an equal thickness the following an exponentionally growing thickness.
This follows the guidelines of Eskilson (P. Eskilson. Thermal analysis of heat extraction
boreholes. PhD thesis, Dep. of Mathematical
Physics, University of Lund, Sweden, 1987).
</li>
<li>
March 9, 2012, by Michael Wetter:<br/>
Removed protected variable <code>der_T</code> as it is not required.
</li>
<li>
April 14 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end Cylindrical;
