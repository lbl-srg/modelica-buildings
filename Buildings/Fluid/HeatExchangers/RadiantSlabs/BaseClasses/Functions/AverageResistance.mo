within Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions;
function AverageResistance
  "Average fictitious resistance for plane that contains the pipes"
  extends Modelica.Icons.Function;
  input Modelica.SIunits.Distance disPip "pipe distance";
  input Modelica.SIunits.Diameter dPipOut "pipe outside diameter";
  input Modelica.SIunits.ThermalConductivity k
    "pipe level construction element thermal conductivity";
  input
    Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType
     sysTyp "Type of radiant system";
  input Modelica.SIunits.ThermalConductivity kIns
    "floor slab insulation thermal conductivity";
  input Modelica.SIunits.Thickness dIns "floor slab insulation thickness";
  output Modelica.SIunits.ThermalInsulance Rx "Thermal insulance";
protected
  Real cri(unit="1")
    "Criteria used to select formula for computation of resistance";
  Real infSum
    "Approximation to infinite sum used to compute the thermal resistance";
  Real alpha(unit="W/(m2.K)", min=0)
    "Criteria used to select formula for computation of resistance";
  Real fac "Factor used for systems in wall or ceiling, or for capillary tubes";
algorithm

  if sysTyp == Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor then
    alpha := kIns/dIns;
    assert(alpha < 1.212,
           "Warning: In RadiantAverageResistance, require alpha = kIns/dIns <= 1.212 W/(m2.K).\n" +
                     "   Obtained alpha = " + String(alpha) + " W/(m2.K)\n" +
                     "            kIns = " + String(kIns) + " W/(m.K)\n" +
                     "            dIns = " + String(dIns) + " m\n" +
                     "            For these values, the radiant slab model is outside its valid range.\n",
                     level=AssertionLevel.warning);
    infSum := - sum(((alpha/k*disPip - 2*Modelica.Constants.pi*s)/
                    (alpha/k*disPip + 2*Modelica.Constants.pi*s))
                    *Modelica.Math.exp(-4*Modelica.Constants.pi*s*dIns/disPip)/s for s in 1:100);
    Rx := disPip*(Modelica.Math.log(disPip/Modelica.Constants.pi/dPipOut) + infSum)
          /(2*Modelica.Constants.pi*k);
    fac := 0; // not needed.
  elseif sysTyp == Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary then
    // Branch for radiant ceilings, radiant walls, and systems with capillary heat exchangers
    cri := disPip/dPipOut;
    fac := if (cri >= 5.8) then Modelica.Math.log(cri/Modelica.Constants.pi) else (cri/Modelica.Constants.pi/3);
    Rx := disPip/2/Modelica.Constants.pi/k * fac;
  else
    assert(sysTyp == Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor or
           sysTyp == Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary,
           "Invalid value for sysTyp in \"Buildings.Fluid.HeatExchangers.RadiantSlabs.BaseClasses.Functions.AverageResistance\"
    Check parameters of the radiant slab model.");
    cri := 0;
    fac := 0;
    Rx  := 1;
  end if;
annotation (
Documentation(info="<html>
<p>
This function computes a fictitious thermal resistance between the pipe outer wall
and a fictitious, average temperature of the plane that contains the pipes.
The equation is the same as is implemented in TRNSYS 17 Type 56 active layer component, manual page 197-201.
Different equations are used for
</p>
<ul>
<li>
floor heating systems (if
<code>sysTyp == Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Floor</code>),
</li>
<li>
radiant heating or cooling systems in ceilings and walls (if
<code>sysTyp == Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary</code>
and <code>disPip/dPipOut &ge; 5.8</code>), and
</li>
<li>
capillary tube systems (if
<code>sysTyp == Buildings.Fluid.HeatExchangers.RadiantSlabs.Types.SystemType.Ceiling_Wall_or_Capillary</code>
and <code>disPip/dPipOut &lt; 5.8</code>).
</li>
</ul>
<h4>Limitations</h4>
<p>
The resistance <code>Rx</code> is based on a steady-state heat transfer analysis. Therefore, it is
only valid during steady-state.
For a fully dynamic model, a finite element method for the radiant slab would need to be implemented.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 16, 2020, by Ettore Zanetti and Michael Wetter:<br/>
Corrected inequality test on <code>alpha</code>,
and changed print statement to an assertion with assertion level set to warning.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2009\">issue 2009</a>.
</li>
<li>
April 17, 2012, by Michael Wetter:<br/>
Added term <code>1/s</code> in computation of <code>infSum</code>.
</li>
<li>
April 5, 2012, by Michael Wetter:<br/>
Revised implementation.
</li>
<li>
April 3, 2012, by Xiufeng Pang:<br/>
First implementation.
</li>
</ul>
</html>"));
end AverageResistance;
