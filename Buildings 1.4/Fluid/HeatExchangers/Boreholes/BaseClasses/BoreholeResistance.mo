within Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses;
model BoreholeResistance "Thermal resistance of the borehole"
  extends
    Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.PartialBoreholeResistance;

equation
  if homotopyInitialization then
    Rb = homotopy(actual=Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.boreholeThermalResistance(
          hSeg=hSeg, rBor=rBor, rTub=rTub, eTub=eTub, kTub=kTub, kFil=kFil,
          kMed=kMed, mueMed=mueMed, cpFluid=cpFluid, m_flow=m_flow, m_flow_nominal=m_flow_nominal,
          B0=B0, B1=B1),
                  simplified=  Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.boreholeThermalResistance(
          hSeg=hSeg, rBor=rBor, rTub=rTub, eTub=eTub, kTub=kTub, kFil=kFil,
          kMed=kMed, mueMed=mueMed, cpFluid=cpFluid, m_flow=m_flow_nominal, m_flow_nominal=m_flow_nominal,
          B0=B0, B1=B1));
  else
    Rb = Buildings.Fluid.HeatExchangers.Boreholes.BaseClasses.boreholeThermalResistance(
          hSeg=hSeg, rBor=rBor, rTub=rTub, eTub=eTub, kTub=kTub, kFil=kFil,
          kMed=kMed, mueMed=mueMed, cpFluid=cpFluid, m_flow=m_flow, m_flow_nominal=m_flow_nominal,
          B0=B0, B1=B1);
  end if;
  G = 1/(2*Rb);
  annotation (
    Documentation(info="<html>
<p>
This model computes the total thermal resistance from the fluid to the borehole wall. 
This thermal resistance is then used for a three-resistance model.
It assumes that the pipe configuration is symmetric. 
The resistance is obtain using
<p align=\"center\" style=\"font-style:italic;\">
 R = 2 R<sub>b</sub>,
</p>
<p>
where <i>R<sub>b</sub></i> is the total borehole resistance as defined by Hellstrom (1991). 
</p>
<p>
The resistance <i>R<sub>b</sub></i> includes three different thermal resistances: 
<ol>
<li>
a convective resistance from the brine to the pipe wall,
</li>
<li>
a thermal resistance of the pipe wall, and
</li>
<li>
the thermal resistance of the filling material.
</li>
</ul>
</p>
<h4>Implementation</h4>
<p>
The calculation of <i>R<sub>b</sub></i> is done using the function
<a href=\"modelica://Buildings.Fluid.Boreholes.BaseClasses.boreholeThermalResistance\">
Buildings.Fluid.Boreholes.BaseClasses.boreholeThermalResistance</a>.
</p>
<h4>References</h4>
<p>
Hellstrom, G (1991). <br>
 <a href=\"http://intraweb.stockton.edu/eyos/energy_studies/content/docs/proceedings/HELLS.PDF\">
 Thermal Performance of Borehole Heat Exchangers</a>.<br> 
Department of Mathematical Physics, Lund Institute of Technology.
</p>
</html>", revisions="<html>
<ul>
<li>
July 28 2011, by Pierre Vigouroux:<br>
First implementation.
</li>
</ul>
</html>"));
end BoreholeResistance;
