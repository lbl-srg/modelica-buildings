partial model PartialMixingVolume 
  "Mixing volume with inlet and outlet ports (flow reversal is allowed)" 
  extends Modelica_Fluid.Interfaces.PartialInitializationParameters;
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium 
    "Medium in the component" 
      annotation (choicesAllMatching = true);
  parameter Modelica.SIunits.Volume V "Volume";
  parameter Integer nP(min=1) = 2 "Number of ports";
  Modelica_Fluid.Interfaces.FluidPort_a port[nP](
     redeclare each package Medium = Medium,
     each C(nominal=1E-3)) "Fluid port" 
                     annotation (extent=[-10,-10; 10,10]);
  Medium.BaseProperties medium(
    preferredMediumStates=true,
    p(start=p_start),
    h(start=h_start),
    T(start=T_start),
    Xi(start=X_start[1:Medium.nXi]));
  Modelica.SIunits.Energy U(start=V*rho0*Medium.specificInternalEnergy(sta0)) 
    "Internal energy of fluid";
  Modelica.SIunits.Mass m(start=V*rho0) "Mass of fluid";
  Modelica.SIunits.Mass mXi[Medium.nXi] 
    "Masses of independent components in the fluid";
  Modelica.SIunits.Volume V_lumped "Volume";
  
  Medium.ExtraProperty mC[Medium.nC] 
    "Masses of auxiliary components in the fluid";
  Medium.MassFraction mc[Medium.nC](start=zeros(Medium.nC), nominal=1E-3) 
    "Mass fraction of auxiliary components in the fluid";
  
protected 
   parameter Medium.ThermodynamicState sta0 = Medium.setState_pTX(T=T_start,
         p=p_start, X=X_start[1:Medium.nXi]);
   parameter Modelica.SIunits.Density rho0=Medium.density(sta0) 
    "Density, used to compute fluid volume";
  Modelica.SIunits.HeatFlowRate Qs_flow 
    "Heat flow across boundaries or energy source/sink";
  Modelica.SIunits.Power Ws_flow=0 "Work flow across boundaries or source term";
  annotation (
    Icon(Text(extent=[-144,178; 146,116], string="%name"), Text(
        extent=[-130,-108; 144,-150],
        style(color=0),
        string="V=%V"),
    Ellipse(extent=[-100,100; 100,-100], style(
        color=0,
        rgbcolor={0,0,0},
        gradient=3,
        fillColor=68,
        rgbfillColor={170,213,255}))),
    Documentation(info="<html>
Model for an ideally mixed fluid volume with <tt>nP</tt> ports and the ability 
to store mass and energy. The volume is fixed.
<p>
This model represents the same physics as 
<tt>Modelica_Fluid.Volumes.MixingVolume</tt>, but it allows to have more than 
two fluid ports. This is convenient for modeling the room volume in a 
building energy simulation since rooms often have more than two fluid connections, 
such as an HVAC inlet, outlet and a leakage flow to other rooms or the outside. 
If a fluid port is connected twice, the model will terminate the 
simulation with an error message.
</p>
<p>
Models that extend this partial model need to provide the energy, mass and species
balance equations. See <a href=\"Modelica:Buildings.Fluids.MixingVolumes.MixingVolume\">
Buildings.Fluids.MixingVolumes.MixingVolume</a>.
</p>
<p>
The thermal port need not be connected, but can have any number of connections.
</p>
</html>", revisions="<html>
<ul>
<li>
September 18, 2008 by Michael Wetter:<br>
Added equations for the mass balance of extra species flow,
i.e., <tt>C</tt> and <tt>mC_flow</tt>.
</li>
<li>
September 4, 2008 by Michael Wetter:<br>
Added start values for the medium mass and internal energy.
This avoids a division by zero that occured in some problems during the initialization
since the start value for the mass was set to zero and this mass was used in the denominator.
</li>
<li>
August 12, 2008 by Michael Wetter:<br>
Introduced option to compute model in steady state. This allows the heat exchanger model
to switch from a dynamic model for the medium to a steady state model.
</li>
<li>
August 6, 2008 by Michael Wetter:<br>
Introduced partial class.
</li>
<li>
March 14, 2008 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram);
  
public 
Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a thermalPort "Thermal port" 
  annotation (extent=[-20,88; 20,108]);
public 
   parameter Boolean steadyState =  false "Set to true for steady state model";
equation 
  V_lumped=V;
  thermalPort.T = medium.T;
  Qs_flow = thermalPort.Q_flow;
// boundary conditions  
  for i in 1:nP loop
    port[i].p = medium.p;
    port[i].H_flow = semiLinear(
      port[i].m_flow,
      port[i].h,
      medium.h);
    port[i].mXi_flow = semiLinear(
      port[i].m_flow,
      port[i].Xi,
      medium.Xi);
    port[i].mC_flow = semiLinear(
      port[i].m_flow,
      port[i].C,
      mc);
  end for;
// Total quantities
  m = V_lumped*medium.d;
  mXi = m*medium.Xi;
  U = m*medium.u;
  
  // The auxiliary species balances is formulated in the non-dimensional form
  // using mc instead of mC, which makes it easier to provide a nominal value
  if steadyState then
    zeros(Medium.nC) = sum(port[i].mC_flow for i in 1:nP);
  else
    der(mc) = sum(port[i].mC_flow for i in 1:nP)/m;
  end if;
  mC = mc*m;
  
// Mass and energy balance.
// To be implemented by models that extend this partial model.
//  der(m) = sum(port[i].m_flow for i in 1:nP);
//  der(mXi) = sum(port[i].mXi_flow for i in 1:nP);
//  der(U) = sum(port[i].H_flow for i in 1:nP) + Qs_flow + Ws_flow;
  
initial equation 
// Initial conditions
  for i in 1:nP loop
    assert(cardinality(port[i]) == 1, "Only one port connection allowed. To fix, increase nP and use new port.");
  end for;
  
  if initType == Modelica_Fluid.Types.Init.NoInit then
  // no initial equations
  elseif initType == Modelica_Fluid.Types.Init.InitialValues then
    if not Medium.singleState then
      medium.p = p_start;
    end if;
    if use_T_start then
      medium.T = T_start;
    else
      medium.h = h_start;
    end if;
    medium.Xi = X_start[1:Medium.nXi];
  elseif initType == Modelica_Fluid.Types.Init.SteadyState then
    if not Medium.singleState then
      der(medium.p) = 0;
    end if;
    der(medium.h) = 0;
    der(medium.Xi) = zeros(Medium.nXi);
  elseif initType == Modelica_Fluid.Types.Init.SteadyStateHydraulic then
    if not Medium.singleState then
      der(medium.p) = 0;
    end if;
    if use_T_start then
      medium.T = T_start;
    else
      medium.h = h_start;
    end if;
    medium.Xi = X_start[1:Medium.nXi];
  else
    assert(false, "Unsupported initialization option");
  end if;
end PartialMixingVolume;
